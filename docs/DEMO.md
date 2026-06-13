# Demo guide

Use this flow when showing **Trends** to clients or in interviews.

## Prerequisites

1. Firebase project: `trends-commerce-dev` (already configured in this repo)
2. Catalog seeded in Firestore (see below)
3. Flutter 3.44+ / Dart 3.12+

## One-time backend setup

From the repo root:

```bash
# Deploy security rules, indexes, and auth trigger
npx firebase-tools@latest deploy --only firestore:rules,firestore:indexes,storage,functions:onUserCreated

# Seed demo catalog (categories, brands, products, banners, reviews)
cd functions
npm install
npm run seed -- --force
```

If seed fails with credentials errors, set a service account:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
npm run seed -- --force
```

Or use the Firebase emulator for local-only demos:

```bash
firebase emulators:start
# In another terminal:
cd functions && npm run seed -- --emulator --force
flutter run --dart-define=USE_FIREBASE_EMULATORS=true
```

## Demo script (5 minutes)

1. **Sign up** with email/password (or Google / Apple on device)
2. **Complete onboarding** — enter display name
3. **Home** — scroll banners, categories, featured products
4. **Product detail** — open a product, check variants and reviews
5. **Add to cart** — change quantity from cart tab
6. **Wishlist** — heart a product, open wishlist tab
7. **Search** — try “saree”, “kurti”, or a brand name
8. **Checkout** — add delivery address, place order (Cash on Delivery)
9. **Orders** — open order history and order detail

## Suggested demo account

Create a fresh account during the demo, or pre-create:

| Field | Example |
|-------|---------|
| Email | `demo@trends.app` |
| Password | `Demo@Trends1` |

After sign-up, complete onboarding with name **Demo User**.

## What to highlight for clients

- Custom design system (`packages/app_ui`)
- Clean architecture: repositories + BLoC + feature folders
- Firebase Auth, Firestore, Analytics, Crashlytics
- Real e-commerce flows: catalog, cart, checkout, orders
- Security rules with owner-based access (not open in production)

## Known MVP limits (be transparent)

| Area | Status |
|------|--------|
| Payments | Cash on delivery works; Razorpay UI label only (SDK not integrated) |
| Search | Firestore prefix search (Algolia planned for scale) |
| Push notifications | Data model ready; FCM UI not wired |
| App Check | Recommended before public launch |

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Empty home / “Store coming soon” | Run `npm run seed -- --force` in `functions/` |
| Permission denied after sign-up | Redeploy rules: `firebase deploy --only firestore:rules` |
| Search returns nothing | Ensure products are seeded and `isPublished: true` |
