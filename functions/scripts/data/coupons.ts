export type CouponSeed = {
  id: string;
  code: string;
  type: "percentage" | "flat";
  value: number;
  minOrderAmount: number;
  maxDiscount: number | null;
  usageLimit: number;
  usageCount: number;
  isActive: boolean;
};

export const coupons: CouponSeed[] = [
  {
    id: "coupon_summer10",
    code: "SUMMER10",
    type: "percentage",
    value: 10,
    minOrderAmount: 999,
    maxDiscount: 500,
    usageLimit: 1000,
    usageCount: 42,
    isActive: true,
  },
  {
    id: "coupon_flat200",
    code: "FLAT200",
    type: "flat",
    value: 200,
    minOrderAmount: 1499,
    maxDiscount: null,
    usageLimit: 500,
    usageCount: 18,
    isActive: true,
  },
];
