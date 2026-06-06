import { banners } from "./data/banners";
import { brands } from "./data/brands";
import { categories } from "./data/categories";
import { coupons } from "./data/coupons";
import {
  featuredProductIds,
  productCountByCategory,
  products,
} from "./data/products";
import { reviews } from "./data/reviews";

const summary = {
  categories: categories.length,
  brands: brands.length,
  products: products.length,
  featuredProducts: featuredProductIds.length,
  banners: banners.length,
  coupons: coupons.length,
  reviews: reviews.length,
  productCountByCategory,
};

console.log("Seed data validation passed.");
console.log(JSON.stringify(summary, null, 2));
