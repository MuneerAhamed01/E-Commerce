import { slugify } from "../utils/slugify";
import { textilePhotoIds } from "./images";

export type BrandSeed = {
  id: string;
  name: string;
  slug: string;
  logoUrl: string;
  isActive: boolean;
};

const rawBrands: Array<Omit<BrandSeed, "slug">> = [
  {
    id: "brand_trends",
    name: "Trends Originals",
    logoUrl: textilePhotoIds.cottonFabric[0],
    isActive: true,
  },
  {
    id: "brand_aura",
    name: "Aura Weaves",
    logoUrl: textilePhotoIds.sarees[1],
    isActive: true,
  },
  {
    id: "brand_silkroute",
    name: "SilkRoute",
    logoUrl: textilePhotoIds.silk[0],
    isActive: true,
  },
  {
    id: "brand_cottoncraft",
    name: "CottonCraft",
    logoUrl: textilePhotoIds.linen[0],
    isActive: true,
  },
  {
    id: "brand_handloom",
    name: "Handloom Heritage",
    logoUrl: textilePhotoIds.womensKurtis[0],
    isActive: true,
  },
  {
    id: "brand_urbanloom",
    name: "Urban Loom",
    logoUrl: textilePhotoIds.mensShirts[0],
    isActive: true,
  },
];

export const brands: BrandSeed[] = rawBrands.map((brand) => ({
  ...brand,
  slug: slugify(brand.name),
}));

export const brandById = new Map(brands.map((brand) => [brand.id, brand]));
