import { slugify } from "../utils/slugify";
import { textilePhotoIds } from "./images";

export type CategorySeed = {
  id: string;
  title: string;
  slug: string;
  imageUrl: string;
  parentId: string | null;
  sortOrder: number;
  isActive: boolean;
  productCount: number;
};

const rawCategories: Array<Omit<CategorySeed, "slug" | "productCount">> = [
  {
    id: "cat_mens_shirts",
    title: "Men's Shirts",
    imageUrl: textilePhotoIds.mensShirts[0],
    parentId: null,
    sortOrder: 1,
    isActive: true,
  },
  {
    id: "cat_womens_kurtis",
    title: "Women's Kurtis",
    imageUrl: textilePhotoIds.womensKurtis[0],
    parentId: null,
    sortOrder: 2,
    isActive: true,
  },
  {
    id: "cat_sarees",
    title: "Sarees",
    imageUrl: textilePhotoIds.sarees[0],
    parentId: null,
    sortOrder: 3,
    isActive: true,
  },
  {
    id: "cat_dupattas",
    title: "Dupattas",
    imageUrl: textilePhotoIds.dupattas[0],
    parentId: null,
    sortOrder: 4,
    isActive: true,
  },
  {
    id: "cat_cotton_fabric",
    title: "Cotton Fabric",
    imageUrl: textilePhotoIds.cottonFabric[0],
    parentId: null,
    sortOrder: 5,
    isActive: true,
  },
  {
    id: "cat_silk",
    title: "Silk",
    imageUrl: textilePhotoIds.silk[0],
    parentId: null,
    sortOrder: 6,
    isActive: true,
  },
  {
    id: "cat_linen",
    title: "Linen",
    imageUrl: textilePhotoIds.linen[0],
    parentId: null,
    sortOrder: 7,
    isActive: true,
  },
  {
    id: "cat_bedsheets",
    title: "Bedsheets",
    imageUrl: textilePhotoIds.bedsheets[0],
    parentId: null,
    sortOrder: 8,
    isActive: true,
  },
  {
    id: "cat_curtains",
    title: "Curtains",
    imageUrl: textilePhotoIds.curtains[0],
    parentId: null,
    sortOrder: 9,
    isActive: true,
  },
  {
    id: "cat_ethnic_wear",
    title: "Ethnic Wear",
    imageUrl: textilePhotoIds.ethnicWear[0],
    parentId: null,
    sortOrder: 10,
    isActive: true,
  },
];

export const categories: CategorySeed[] = rawCategories.map((category) => ({
  ...category,
  slug: slugify(category.title),
  productCount: 0,
}));

export const categoryById = new Map(
  categories.map((category) => [category.id, category]),
);
