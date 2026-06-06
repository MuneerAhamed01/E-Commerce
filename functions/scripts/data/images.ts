/**
 * Verified product imagery for textile e-commerce demo data.
 * Each category pool has 12 unique images — one per product in that category.
 */

export function unsplashImageUrl(
  photoId: string,
  options: { width?: number; height?: number } = {},
): string {
  const params = new URLSearchParams({
    auto: "format",
    fit: "crop",
    q: "80",
    w: String(options.width ?? 800),
  });

  if (options.height) {
    params.set("h", String(options.height));
  }

  return `https://images.unsplash.com/photo-${photoId}?${params.toString()}`;
}

export function pexelsImageUrl(
  photoId: number,
  options: { width?: number } = {},
): string {
  const params = new URLSearchParams({
    auto: "compress",
    cs: "tinysrgb",
    w: String(options.width ?? 800),
  });

  return `https://images.pexels.com/photos/${photoId}/pexels-photo-${photoId}.jpeg?${params.toString()}`;
}

/** 12 unique shirt images — blue, white, checkered, polo, linen, casual. */
export const mensShirtImages = [
  unsplashImageUrl("1740711152088-88a009e877bb"),
  unsplashImageUrl("1611312449412-6cefac5dc3e4"),
  unsplashImageUrl("1620012253295-c15cc3e65df4"),
  unsplashImageUrl("1627686011747-74adda3d2343"),
  unsplashImageUrl("1602810320073-1230c46d89d4"),
  unsplashImageUrl("1602810318383-e386cc2a3ccf"),
  unsplashImageUrl("1602810316693-3667c854239a"),
  unsplashImageUrl("1589234217365-08d3e0e5cf42"),
  unsplashImageUrl("1602810316498-ab67cf68c8e1"),
  unsplashImageUrl("1776838103951-993ff1ffc916"),
  unsplashImageUrl("1714568398464-fa1006821617"),
  unsplashImageUrl("1521572163474-6864f9cf17ab"),
] as const;

/** 12 women's kurti / ethnic top images with varied colors. */
export const womensKurtiImages = [
  unsplashImageUrl("1595777457583-95e059d581b8"),
  unsplashImageUrl("1490481651871-ab68de25d43d"),
  unsplashImageUrl("1509631179647-0177331693ae"),
  unsplashImageUrl("1487412720507-e7ab37603c6f"),
  pexelsImageUrl(1536619),
  pexelsImageUrl(4620618),
  pexelsImageUrl(2834912),
  pexelsImageUrl(3348880),
  pexelsImageUrl(3363728),
  pexelsImageUrl(3734346),
  pexelsImageUrl(3993449),
  pexelsImageUrl(4467687),
] as const;

/** 12 saree / drape textile images. */
export const sareeImages = [
  unsplashImageUrl("1616986491129-3e37cb654c82"),
  unsplashImageUrl("1692992193981-d3d92fabd9cb"),
  unsplashImageUrl("1717835943315-b818e90cb2a1"),
  unsplashImageUrl("1594633312681-425c7b97ccd1"),
  pexelsImageUrl(994523),
  pexelsImageUrl(1598507),
  pexelsImageUrl(1926769),
  pexelsImageUrl(2983468),
  pexelsImageUrl(4046305),
  pexelsImageUrl(4144226),
  pexelsImageUrl(4380970),
  pexelsImageUrl(4529007),
] as const;

/** 12 dupatta / stole / scarf images. */
export const dupattaImages = [
  unsplashImageUrl("1445205170230-053b83016050"),
  unsplashImageUrl("1556909114-f6e7ad7d3136"),
  pexelsImageUrl(1124468),
  pexelsImageUrl(1485031),
  pexelsImageUrl(1556907),
  pexelsImageUrl(1656684),
  pexelsImageUrl(2068673),
  pexelsImageUrl(2445542),
  pexelsImageUrl(3076723),
  pexelsImageUrl(3402820),
  pexelsImageUrl(3836616),
  pexelsImageUrl(4210868),
] as const;

/** 12 cotton fabric swatch / roll images. */
export const cottonFabricImages = [
  unsplashImageUrl("1558618666-fcd25c85cd64"),
  unsplashImageUrl("1578662996442-48f60103fc96"),
  unsplashImageUrl("1582719478250-c89cae4dc85b"),
  pexelsImageUrl(996329),
  pexelsImageUrl(1040945),
  pexelsImageUrl(1183266),
  pexelsImageUrl(1308881),
  pexelsImageUrl(1884581),
  pexelsImageUrl(2043596),
  pexelsImageUrl(2233366),
  pexelsImageUrl(3258766),
  pexelsImageUrl(3616232),
] as const;

/** 12 silk / sheen fabric images. */
export const silkImages = [
  unsplashImageUrl("1558769132-cb1aea458c5e"),
  unsplashImageUrl("1542272604-787c3835535d"),
  unsplashImageUrl("1434389677669-e08b4cac3105"),
  pexelsImageUrl(298863),
  pexelsImageUrl(3222041),
  pexelsImageUrl(3457920),
  pexelsImageUrl(3771832),
  pexelsImageUrl(3965555),
  pexelsImageUrl(4040563),
  pexelsImageUrl(4103948),
  pexelsImageUrl(4348378),
  pexelsImageUrl(4554726),
] as const;

/** 12 linen texture / apparel images. */
export const linenImages = [
  unsplashImageUrl("1503342217505-b0a15ec3261c"),
  unsplashImageUrl("1441986300917-64674bd600d8"),
  unsplashImageUrl("1591047139829-d91aecb6caea"),
  pexelsImageUrl(3297505),
  pexelsImageUrl(4066293),
  pexelsImageUrl(4147981),
  pexelsImageUrl(415829),
  pexelsImageUrl(416405),
  pexelsImageUrl(416471),
  pexelsImageUrl(4240166),
  pexelsImageUrl(428338),
  pexelsImageUrl(4407012),
] as const;

/** 12 bedsheet / bedding images. */
export const bedsheetImages = [
  unsplashImageUrl("1534973098198-6b2de48816b7"),
  pexelsImageUrl(6311390),
  pexelsImageUrl(6311392),
  pexelsImageUrl(6311478),
  pexelsImageUrl(6311573),
  pexelsImageUrl(6311576),
  pexelsImageUrl(6311586),
  pexelsImageUrl(6311589),
  pexelsImageUrl(6311650),
  pexelsImageUrl(6311652),
  pexelsImageUrl(7671162),
  pexelsImageUrl(7671168),
] as const;

/** 12 curtain / home textile images. */
export const curtainImages = [
  pexelsImageUrl(7671166),
  pexelsImageUrl(2060573),
  pexelsImageUrl(4578822),
  pexelsImageUrl(4590287),
  pexelsImageUrl(4643108),
  pexelsImageUrl(4642352),
  pexelsImageUrl(4637645),
  pexelsImageUrl(4622414),
  pexelsImageUrl(4195324),
  pexelsImageUrl(4241704),
  pexelsImageUrl(4320595),
  pexelsImageUrl(4651672),
] as const;

/**
 * 12 ethnic wear images — kurtas, suits, and pants/trouser outfits.
 * Includes shirt-and-pants combos for kurta pajama / salwar looks.
 */
export const ethnicWearImages = [
  unsplashImageUrl("1717835943315-b818e90cb2a1"),
  unsplashImageUrl("1692992193981-d3d92fabd9cb"),
  unsplashImageUrl("1618001789159-ffffe6f96ef2"),
  unsplashImageUrl("1624835567150-0c530a20d8cc"),
  unsplashImageUrl("1775816364124-b305f2b06ce7"),
  unsplashImageUrl("1689580312480-75960cb8921f"),
  pexelsImageUrl(6311652),
  pexelsImageUrl(7671166),
  pexelsImageUrl(4485128),
  pexelsImageUrl(4494650),
  pexelsImageUrl(4506105),
  pexelsImageUrl(4566207),
] as const;

/** Category hero / thumbnail images (first image from each pool). */
export const textilePhotoIds = {
  mensShirts: mensShirtImages,
  womensKurtis: womensKurtiImages,
  sarees: sareeImages,
  dupattas: dupattaImages,
  cottonFabric: cottonFabricImages,
  silk: silkImages,
  linen: linenImages,
  bedsheets: bedsheetImages,
  curtains: curtainImages,
  ethnicWear: ethnicWearImages,
} as const;

export type ProductImagePoolKey = keyof typeof textilePhotoIds;
