import { brandById, brands } from "./brands";
import { categoryById, categories } from "./categories";
import { textilePhotoIds } from "./images";
import { slugify } from "../utils/slugify";

export type ProductVariantSeed = {
  id: string;
  size: string;
  color: string;
  sku: string;
  stock: number;
  priceDelta: number;
};

export type ProductSeed = {
  id: string;
  name: string;
  slug: string;
  description: string;
  price: number;
  salePrice: number;
  currency: "INR";
  stock: number;
  sku: string;
  images: string[];
  categoryId: string;
  categoryName: string;
  brandId: string;
  brandName: string;
  rating: number;
  reviewCount: number;
  searchKeywords: string[];
  variants: ProductVariantSeed[];
  isPublished: boolean;
  isFeatured: boolean;
};

type CategoryProductTemplate = {
  categoryId: string;
  names: string[];
  description: string;
  priceRange: [number, number];
  sizes: string[];
  colors: string[];
  imageUrls: readonly string[];
  keywords: string[];
};

const categoryTemplates: CategoryProductTemplate[] = [
  {
    categoryId: "cat_mens_shirts",
    names: [
      "Classic Linen Shirt",
      "Oxford Cotton Shirt",
      "Slim Fit Chambray Shirt",
      "Striped Formal Shirt",
      "Casual Denim Shirt",
      "Mandarin Collar Shirt",
      "Checked Casual Shirt",
      "Pure Cotton Kurta Shirt",
      "Half Sleeve Summer Shirt",
      "Textured Weave Shirt",
      "Office Ready Poplin Shirt",
      "Heritage Block Print Shirt",
    ],
    description:
      "Breathable cotton-linen blend tailored for everyday comfort and smart casual styling.",
    priceRange: [1299, 3499],
    sizes: ["S", "M", "L", "XL"],
    colors: ["White", "Navy", "Sky Blue", "Charcoal"],
    imageUrls: textilePhotoIds.mensShirts,
    keywords: ["shirt", "mens", "cotton", "linen", "formal", "casual"],
  },
  {
    categoryId: "cat_womens_kurtis",
    names: [
      "Handloom Cotton Kurta",
      "Floral Print Kurti",
      "Straight Cut Anarkali Kurti",
      "Embroidered Festive Kurti",
      "A-Line Cotton Kurti",
      "Block Print Kurta Set",
      "Rayon Daily Wear Kurti",
      "Mirror Work Kurti",
      "Pastel Office Kurti",
      "Indigo Dyed Kurti",
      "Chikankari Kurti",
      "Tiered Cotton Kurti",
    ],
    description:
      "Soft woven fabric with artisan finishing, ideal for daily wear and festive occasions.",
    priceRange: [799, 2499],
    sizes: ["S", "M", "L", "XL", "XXL"],
    colors: ["Maroon", "Teal", "Mustard", "Ivory"],
    imageUrls: textilePhotoIds.womensKurtis,
    keywords: ["kurti", "kurta", "womens", "ethnic", "cotton", "handloom"],
  },
  {
    categoryId: "cat_sarees",
    names: [
      "Banarasi Silk Saree",
      "Kanjivaram Temple Border Saree",
      "Chiffon Party Wear Saree",
      "Cotton Handloom Saree",
      "Georgette Embroidered Saree",
      "Tussar Silk Saree",
      "Linen Blend Saree",
      "Bandhani Print Saree",
      "Organza Festive Saree",
      "Mysore Silk Saree",
      "Kota Doria Saree",
      "Paithani Inspired Saree",
    ],
    description:
      "Rich weave with elegant drape, crafted for celebrations and timeless ethnic elegance.",
    priceRange: [1999, 8999],
    sizes: ["Free Size"],
    colors: ["Red", "Gold", "Green", "Royal Blue"],
    imageUrls: textilePhotoIds.sarees,
    keywords: ["saree", "silk", "banarasi", "ethnic", "festive", "handloom"],
  },
  {
    categoryId: "cat_dupattas",
    names: [
      "Phulkari Embroidered Dupatta",
      "Chanderi Silk Dupatta",
      "Cotton Block Print Dupatta",
      "Bandhani Tie-Dye Dupatta",
      "Zari Border Dupatta",
      "Kalamkari Dupatta",
      "Organza Sheer Dupatta",
      "Mirror Work Dupatta",
      "Ikat Weave Dupatta",
      "Velvet Festive Dupatta",
      "Linen Summer Dupatta",
      "Net Embroidered Dupatta",
    ],
    description:
      "Lightweight drape with detailed weave work to complement kurtis and ethnic sets.",
    priceRange: [499, 1999],
    sizes: ["Free Size"],
    colors: ["Pink", "Orange", "Cream", "Wine"],
    imageUrls: textilePhotoIds.dupattas,
    keywords: ["dupatta", "stole", "ethnic", "embroidered", "cotton", "silk"],
  },
  {
    categoryId: "cat_cotton_fabric",
    names: [
      "Premium Cotton Shirting Fabric",
      "Handspun Khadi Fabric",
      "Poplin Dress Material",
      "Cambric Cotton Fabric",
      "Voile Cotton Fabric",
      "Yarn Dyed Cotton Fabric",
      "Organic Cotton Fabric",
      "Printed Cotton Fabric",
      "Satin Weave Cotton Fabric",
      "Cotton Twill Fabric",
      "Cotton Canvas Fabric",
      "Soft Cotton Lawn Fabric",
    ],
    description:
      "Per-meter cotton textile with smooth finish, suitable for shirts, dresses, and crafts.",
    priceRange: [299, 899],
    sizes: ["1m", "2m", "3m", "5m"],
    colors: ["Natural", "White", "Indigo", "Beige"],
    imageUrls: textilePhotoIds.cottonFabric,
    keywords: ["cotton", "fabric", "shirting", "khadi", "textile", "meter"],
  },
  {
    categoryId: "cat_silk",
    names: [
      "Pure Mulberry Silk Fabric",
      "Tussar Silk Material",
      "Silk Chiffon Fabric",
      "Silk Georgette Fabric",
      "Raw Silk Texture Fabric",
      "Silk Crepe Fabric",
      "Silk Satin Fabric",
      "Matka Silk Fabric",
      "Silk Organza Fabric",
      "Silk Brocade Fabric",
      "Silk Jacquard Fabric",
      "Silk Blend Fabric",
    ],
    description:
      "Luxurious silk textile with natural sheen, perfect for sarees and occasion wear.",
    priceRange: [899, 2499],
    sizes: ["1m", "2m", "3m", "5m"],
    colors: ["Champagne", "Emerald", "Ruby", "Ivory"],
    imageUrls: textilePhotoIds.silk,
    keywords: ["silk", "fabric", "mulberry", "tussar", "textile", "luxury"],
  },
  {
    categoryId: "cat_linen",
    names: [
      "European Linen Fabric",
      "Washed Linen Shirting",
      "Linen Blend Suiting",
      "Natural Linen Material",
      "Linen Dobby Fabric",
      "Soft Linen Dress Fabric",
      "Linen Yarn Dyed Fabric",
      "Heavy Linen Upholstery Fabric",
      "Linen Stripe Fabric",
      "Linen Check Fabric",
      "Breathable Linen Fabric",
      "Premium Linen Roll",
    ],
    description:
      "Airy linen textile with crisp texture, ideal for summer apparel and home styling.",
    priceRange: [699, 1799],
    sizes: ["1m", "2m", "3m", "5m"],
    colors: ["Flax", "Sand", "Olive", "Slate"],
    imageUrls: textilePhotoIds.linen,
    keywords: ["linen", "fabric", "summer", "breathable", "textile", "natural"],
  },
  {
    categoryId: "cat_bedsheets",
    names: [
      "400 TC Cotton Bedsheet",
      "Floral Print Bedsheet Set",
      "Sateen Finish Bedsheet",
      "King Size Cotton Bedsheet",
      "Queen Size Bedsheet Set",
      "Jaipuri Print Bedsheet",
      "Solid Pastel Bedsheet",
      "Hotel Collection Bedsheet",
      "Microcheck Bedsheet Set",
      "Striped Cotton Bedsheet",
      "Boho Print Bedsheet",
      "Premium Percale Bedsheet",
    ],
    description:
      "Soft-touch cotton bedsheet set with durable weave for restful sleep and easy care.",
    priceRange: [599, 2499],
    sizes: ["Single", "Double", "Queen", "King"],
    colors: ["White", "Grey", "Blush", "Sage"],
    imageUrls: textilePhotoIds.bedsheets,
    keywords: ["bedsheet", "cotton", "bedding", "home", "linen", "sleep"],
  },
  {
    categoryId: "cat_curtains",
    names: [
      "Sheer Voile Curtain Panel",
      "Blackout Curtain Pair",
      "Linen Look Curtain",
      "Floral Print Curtain",
      "Eyelet Door Curtain",
      "Jacquard Window Curtain",
      "Striped Living Room Curtain",
      "Thermal Insulated Curtain",
      "Embroidered Curtain Panel",
      "Geometric Print Curtain",
      "Velvet Accent Curtain",
      "Cotton Blend Curtain Set",
    ],
    description:
      "Room-enhancing curtain panels with balanced opacity for privacy and natural light.",
    priceRange: [899, 3999],
    sizes: ["5ft", "7ft", "9ft"],
    colors: ["Beige", "Taupe", "Navy", "Ivory"],
    imageUrls: textilePhotoIds.curtains,
    keywords: ["curtain", "drape", "home", "window", "decor", "textile"],
  },
  {
    categoryId: "cat_ethnic_wear",
    names: [
      "Men's Kurta Pajama Set",
      "Women's Anarkali Suit",
      "Indo-Western Fusion Set",
      "Festive Sherwani Jacket",
      "Palazzo Suit Set",
      "Straight Salwar Suit",
      "Embroidered Lehenga Choli",
      "Nehrus Jacket Set",
      "Cotton Pathani Suit",
      "Sharara Suit Set",
      "Bandhgala Ethnic Set",
      "Classic Dhoti Kurta Set",
    ],
    description:
      "Occasion-ready ethnic ensemble with refined tailoring and artisan textile details.",
    priceRange: [1499, 5999],
    sizes: ["S", "M", "L", "XL"],
    colors: ["Maroon", "Navy", "Emerald", "Gold"],
    imageUrls: textilePhotoIds.ethnicWear,
    keywords: ["ethnic", "kurta", "suit", "festive", "traditional", "wear"],
  },
];

const categoryCodeMap: Record<string, string> = {
  cat_mens_shirts: "MSH",
  cat_womens_kurtis: "KUR",
  cat_sarees: "SAR",
  cat_dupattas: "DUP",
  cat_cotton_fabric: "CTF",
  cat_silk: "SLK",
  cat_linen: "LIN",
  cat_bedsheets: "BED",
  cat_curtains: "CUR",
  cat_ethnic_wear: "ETH",
};

function roundRating(seed: number): number {
  const value = 3.8 + (seed % 12) * 0.1;
  return Math.round(value * 10) / 10;
}

function buildVariants(
  productIndex: number,
  categoryCode: string,
  template: CategoryProductTemplate,
): ProductVariantSeed[] {
  return template.sizes.flatMap((size, sizeIndex) =>
    template.colors.map((color, colorIndex) => {
      const variantIndex = sizeIndex * template.colors.length + colorIndex + 1;
      const sizeCode = size.replace(/\s+/g, "").slice(0, 3).toUpperCase();
      const colorCode = color.slice(0, 3).toUpperCase();
      const priceDelta = variantIndex % 3 === 0 ? 100 : 0;

      return {
        id: `var_${productIndex}_${variantIndex}`,
        size,
        color,
        sku: `TLS-${categoryCode}-${String(productIndex).padStart(3, "0")}-${sizeCode}-${colorCode}`,
        stock: 12 + ((productIndex + variantIndex) % 25),
        priceDelta,
      };
    }),
  );
}

function buildProducts(): ProductSeed[] {
  const products: ProductSeed[] = [];
  let globalIndex = 1;
  const featuredSlots = new Set([1, 5, 9, 14, 18, 23, 27, 33, 41, 55, 67, 88, 99, 105, 112]);

  for (const template of categoryTemplates) {
    const category = categoryById.get(template.categoryId);
    if (!category) {
      throw new Error(`Missing category: ${template.categoryId}`);
    }

    const categoryCode = categoryCodeMap[template.categoryId] ?? "GEN";

    template.names.forEach((name, index) => {
      const productIndex = globalIndex;
      const brand = brands[(productIndex + index) % brands.length];
      const min = template.priceRange[0];
      const max = template.priceRange[1];
      const price = min + ((productIndex * 73) % (max - min + 1));
      const salePrice = Math.max(min, price - (productIndex % 4 === 0 ? 250 : 150));
      const primaryImage = template.imageUrls[index];
      const secondaryImage =
        template.imageUrls[(index + 1) % template.imageUrls.length];
      const variants = buildVariants(productIndex, categoryCode, template);
      const totalStock = variants.reduce((sum, variant) => sum + variant.stock, 0);

      products.push({
        id: `prod_${categoryCode.toLowerCase()}_${String(index + 1).padStart(3, "0")}`,
        name,
        slug: slugify(name),
        description: template.description,
        price,
        salePrice,
        currency: "INR",
        stock: totalStock,
        sku: `TLS-${categoryCode}-${String(index + 1).padStart(3, "0")}`,
        images: [primaryImage, secondaryImage],
        categoryId: category.id,
        categoryName: category.title,
        brandId: brand.id,
        brandName: brand.name,
        rating: roundRating(productIndex),
        reviewCount: 18 + (productIndex * 7) % 180,
        searchKeywords: [
          ...template.keywords,
          slugify(name).replace(/-/g, " "),
          category.title.toLowerCase(),
          brand.name.toLowerCase(),
        ],
        variants,
        isPublished: true,
        isFeatured: featuredSlots.has(productIndex),
      });

      globalIndex += 1;
    });
  }

  return products;
}

export const products: ProductSeed[] = buildProducts();

export const featuredProductIds = products
  .filter((product) => product.isFeatured)
  .map((product) => product.id);

export const productCountByCategory = products.reduce<Record<string, number>>(
  (counts, product) => {
    counts[product.categoryId] = (counts[product.categoryId] ?? 0) + 1;
    return counts;
  },
  {},
);

export function assertSeedCatalog(): void {
  if (products.length !== 120) {
    throw new Error(`Expected 120 products, found ${products.length}`);
  }

  for (const category of categories) {
    if ((productCountByCategory[category.id] ?? 0) !== 12) {
      throw new Error(`Category ${category.id} must have 12 products`);
    }
  }

  for (const product of products) {
    if (!brandById.has(product.brandId)) {
      throw new Error(`Unknown brand on product ${product.id}`);
    }
    if (!categoryById.has(product.categoryId)) {
      throw new Error(`Unknown category on product ${product.id}`);
    }
  }
}

assertSeedCatalog();
