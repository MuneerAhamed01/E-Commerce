import { initializeApp, applicationDefault, cert } from "firebase-admin/app";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

import { banners } from "./data/banners";
import { brands } from "./data/brands";
import { categories } from "./data/categories";
import { coupons } from "./data/coupons";
import { productCountByCategory, products } from "./data/products";
import { reviews } from "./data/reviews";
import {
  clearCollection,
  commitBatches,
  type BatchWrite,
} from "./utils/firestore-batch";

const SEED_VERSION = 3;
const PROJECT_ID = "trends-commerce-dev";
const META_COLLECTION = "meta";
const META_DOC_ID = "seed";

const COLLECTIONS_TO_CLEAR = [
  "categories",
  "brands",
  "products",
  "banners",
  "coupons",
  "reviews",
];

type SeedFlags = {
  force: boolean;
  emulator: boolean;
};

function parseFlags(argv: string[]): SeedFlags {
  return {
    force: argv.includes("--force"),
    emulator: argv.includes("--emulator"),
  };
}

function resolveCredential() {
  const envPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
  if (envPath) {
    const absolutePath = resolve(envPath);
    if (existsSync(absolutePath)) {
      const serviceAccount = JSON.parse(readFileSync(absolutePath, "utf8"));
      return cert(serviceAccount);
    }
  }

  const localPath = resolve(__dirname, "../../service-account.json");
  if (existsSync(localPath)) {
    const serviceAccount = JSON.parse(readFileSync(localPath, "utf8"));
    return cert(serviceAccount);
  }

  return applicationDefault();
}

function initializeFirebase(flags: SeedFlags) {
  if (flags.emulator) {
    process.env.FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080";
  }

  initializeApp({
    credential: resolveCredential(),
    projectId: PROJECT_ID,
  });

  return getFirestore();
}

async function getSeedStatus(db: ReturnType<typeof getFirestore>) {
  const snapshot = await db.collection(META_COLLECTION).doc(META_DOC_ID).get();
  return snapshot.exists ? snapshot.data() : null;
}

async function clearCatalog(db: ReturnType<typeof getFirestore>): Promise<void> {
  console.log("Clearing existing catalog collections...");

  for (const collectionName of COLLECTIONS_TO_CLEAR) {
    const deleted = await clearCollection(db, collectionName);
    console.log(`  - ${collectionName}: deleted ${deleted}`);
  }

  await db.collection(META_COLLECTION).doc(META_DOC_ID).delete();
}

function withTimestamps<T extends Record<string, unknown>>(
  data: T,
  now: Timestamp,
): T & { createdAt: Timestamp; updatedAt: Timestamp } {
  return {
    ...data,
    createdAt: now,
    updatedAt: now,
  };
}

function buildWrites(now: Timestamp): BatchWrite[] {
  const writes: BatchWrite[] = [];

  for (const category of categories) {
    writes.push({
      collection: "categories",
      id: category.id,
      data: withTimestamps(
        {
          id: category.id,
          title: category.title,
          slug: category.slug,
          imageUrl: category.imageUrl,
          parentId: category.parentId,
          sortOrder: category.sortOrder,
          isActive: category.isActive,
          productCount: productCountByCategory[category.id] ?? 0,
        },
        now,
      ),
    });
  }

  for (const brand of brands) {
    writes.push({
      collection: "brands",
      id: brand.id,
      data: withTimestamps(
        {
          id: brand.id,
          name: brand.name,
          slug: brand.slug,
          logoUrl: brand.logoUrl,
          isActive: brand.isActive,
        },
        now,
      ),
    });
  }

  for (const product of products) {
    writes.push({
      collection: "products",
      id: product.id,
      data: withTimestamps(
        {
          id: product.id,
          name: product.name,
          slug: product.slug,
          description: product.description,
          price: product.price,
          salePrice: product.salePrice,
          currency: product.currency,
          stock: product.stock,
          sku: product.sku,
          images: product.images,
          categoryId: product.categoryId,
          categoryName: product.categoryName,
          brandId: product.brandId,
          brandName: product.brandName,
          rating: product.rating,
          reviewCount: product.reviewCount,
          searchKeywords: product.searchKeywords,
          variants: product.variants,
          isPublished: product.isPublished,
          isFeatured: product.isFeatured,
        },
        now,
      ),
    });
  }

  for (const banner of banners) {
    writes.push({
      collection: "banners",
      id: banner.id,
      data: withTimestamps(
        {
          id: banner.id,
          title: banner.title,
          subtitle: banner.subtitle,
          imageUrl: banner.imageUrl,
          linkType: banner.linkType,
          linkTarget: banner.linkTarget,
          sortOrder: banner.sortOrder,
          isActive: banner.isActive,
          startsAt: now,
          endsAt: Timestamp.fromDate(
            new Date(Date.now() + 180 * 24 * 60 * 60 * 1000),
          ),
        },
        now,
      ),
    });
  }

  for (const coupon of coupons) {
    writes.push({
      collection: "coupons",
      id: coupon.id,
      data: withTimestamps(
        {
          id: coupon.id,
          code: coupon.code,
          type: coupon.type,
          value: coupon.value,
          minOrderAmount: coupon.minOrderAmount,
          maxDiscount: coupon.maxDiscount,
          usageLimit: coupon.usageLimit,
          usageCount: coupon.usageCount,
          isActive: coupon.isActive,
          validFrom: now,
          validUntil: Timestamp.fromDate(
            new Date(Date.now() + 90 * 24 * 60 * 60 * 1000),
          ),
        },
        now,
      ),
    });
  }

  for (const review of reviews) {
    writes.push({
      collection: "reviews",
      id: review.id,
      data: {
        id: review.id,
        productId: review.productId,
        userId: review.userId,
        userDisplayName: review.userDisplayName,
        rating: review.rating,
        title: review.title,
        body: review.body,
        isVerifiedPurchase: review.isVerifiedPurchase,
        createdAt: now,
      },
    });
  }

  return writes;
}

async function seedCatalog(): Promise<void> {
  const flags = parseFlags(process.argv.slice(2));
  const startedAt = Date.now();
  const db = initializeFirebase(flags);

  const existingSeed = await getSeedStatus(db);
  if (
    existingSeed &&
    typeof existingSeed.version === "number" &&
    existingSeed.version >= SEED_VERSION &&
    !flags.force
  ) {
    console.log(
      `Catalog already seeded (version ${existingSeed.version}). Use --force to re-seed.`,
    );
    return;
  }

  if (flags.force) {
    await clearCatalog(db);
  }

  const now = Timestamp.now();
  const writes = buildWrites(now);

  console.log(`Writing ${writes.length} documents to Firestore...`);
  await commitBatches(db, writes);

  await db.collection(META_COLLECTION).doc(META_DOC_ID).set({
    version: SEED_VERSION,
    projectId: PROJECT_ID,
    seededAt: now,
    counts: {
      categories: categories.length,
      brands: brands.length,
      products: products.length,
      banners: banners.length,
      coupons: coupons.length,
      reviews: reviews.length,
    },
  });

  const elapsedMs = Date.now() - startedAt;
  console.log("Seed completed successfully.");
  console.log(`  categories: ${categories.length}`);
  console.log(`  brands: ${brands.length}`);
  console.log(`  products: ${products.length}`);
  console.log(`  banners: ${banners.length}`);
  console.log(`  coupons: ${coupons.length}`);
  console.log(`  reviews: ${reviews.length}`);
  console.log(`  duration: ${elapsedMs}ms`);

  if (flags.emulator) {
    console.log("  target: Firestore emulator (localhost:8080)");
  } else {
    console.log(`  target: ${PROJECT_ID}`);
  }
}

seedCatalog().catch((error: unknown) => {
  console.error("Seed failed:", error);
  process.exitCode = 1;
});
