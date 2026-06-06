import { textilePhotoIds } from "./images";

export type BannerSeed = {
  id: string;
  title: string;
  subtitle: string;
  imageUrl: string;
  linkType: "category" | "product" | "external";
  linkTarget: string;
  sortOrder: number;
  isActive: boolean;
};

export const banners: BannerSeed[] = [
  {
    id: "banner_summer_sale",
    title: "Summer Textile Sale",
    subtitle: "Up to 40% off on cotton & linen",
    imageUrl: textilePhotoIds.cottonFabric[1],
    linkType: "category",
    linkTarget: "cat_cotton_fabric",
    sortOrder: 1,
    isActive: true,
  },
  {
    id: "banner_saree_collection",
    title: "Festive Saree Collection",
    subtitle: "Handwoven silk & Banarasi weaves",
    imageUrl: textilePhotoIds.sarees[2],
    linkType: "category",
    linkTarget: "cat_sarees",
    sortOrder: 2,
    isActive: true,
  },
  {
    id: "banner_ethnic_edit",
    title: "Ethnic Wear Edit",
    subtitle: "Kurtis, dupattas & more",
    imageUrl: textilePhotoIds.ethnicWear[1],
    linkType: "category",
    linkTarget: "cat_ethnic_wear",
    sortOrder: 3,
    isActive: true,
  },
  {
    id: "banner_home_linen",
    title: "Home Linen Refresh",
    subtitle: "Bedsheets & curtains from ₹599",
    imageUrl: textilePhotoIds.bedsheets[2],
    linkType: "category",
    linkTarget: "cat_bedsheets",
    sortOrder: 4,
    isActive: true,
  },
];
