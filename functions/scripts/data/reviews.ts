import { featuredProductIds } from "./products";

export type ReviewSeed = {
  id: string;
  productId: string;
  userId: string;
  userDisplayName: string;
  rating: number;
  title: string;
  body: string;
  isVerifiedPurchase: boolean;
};

const reviewerNames = [
  "Priya S.",
  "Rahul M.",
  "Ananya K.",
  "Vikram P.",
  "Sneha R.",
  "Arjun D.",
  "Meera J.",
  "Karan T.",
  "Divya N.",
  "Rohit B.",
];

const reviewTitles = [
  "Beautiful fabric quality",
  "Great value for money",
  "Perfect for festive wear",
  "Soft and comfortable",
  "Exactly as shown",
  "Loved the color",
  "Premium finish",
  "Fast delivery experience",
];

const reviewBodies = [
  "The weave feels premium and the fit is comfortable for daily use.",
  "Color and texture matched the product photos. Very happy with this purchase.",
  "Material quality is excellent and stitching is neat. Would buy again.",
  "Lightweight yet durable textile. Ideal for the season.",
  "Received many compliments. The fabric drapes beautifully.",
  "Good craftsmanship and true-to-size options in variants.",
];

function buildReviews(): ReviewSeed[] {
  const reviews: ReviewSeed[] = [];
  let reviewIndex = 1;

  for (const productId of featuredProductIds) {
    const reviewsForProduct = 2 + (reviewIndex % 3);

    for (let index = 0; index < reviewsForProduct; index += 1) {
      const seed = reviewIndex + index;
      reviews.push({
        id: `rev_${String(reviewIndex).padStart(3, "0")}`,
        productId,
        userId: `demo_user_${String((seed % 10) + 1).padStart(2, "0")}`,
        userDisplayName: reviewerNames[seed % reviewerNames.length],
        rating: 4 + (seed % 2),
        title: reviewTitles[seed % reviewTitles.length],
        body: reviewBodies[seed % reviewBodies.length],
        isVerifiedPurchase: seed % 3 !== 0,
      });
      reviewIndex += 1;
    }
  }

  return reviews;
}

export const reviews: ReviewSeed[] = buildReviews();
