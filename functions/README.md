# Trends Cloud Functions

## Setup

```bash
cd functions
npm install
npm run build
```

Requires Firebase **Blaze** plan for deployment.

## Deploy

```bash
firebase deploy --only functions:onUserCreated
```

## Local emulator

```bash
firebase emulators:start --only auth,firestore,functions
```

Note: Auth emulator does not trigger production functions. Use the client
`UserRepository.ensureUserDocument()` fallback during local dev, or run the
Functions emulator alongside Auth.

## Seed textile catalog (one-time)

Populates `trends-commerce-dev` with demo categories, brands, 120 products,
banners, coupons, and reviews for the hiring portfolio.

### Prerequisites

1. Download a Firebase service account key:
   Firebase Console → Project Settings → Service Accounts → Generate new private key
2. Save it as `functions/service-account.json` (gitignored — never commit)
3. Ensure Firestore indexes are deployed:
   ```bash
   firebase deploy --only firestore:indexes
   ```

### Validate seed data locally (no Firebase credentials)

```bash
cd functions
npm run seed:validate
```

### Run seed

```bash
cd functions
export GOOGLE_APPLICATION_CREDENTIALS="./service-account.json"
npm run seed
```

### Options

```bash
npm run seed -- --force     # Clear catalog collections and re-seed
npm run seed -- --emulator  # Seed local Firestore emulator (localhost:8080)
```

Re-running without `--force` is a no-op when `meta/seed` version is already set.

### Seeded collections

| Collection | Count |
|------------|-------|
| `categories` | 10 |
| `brands` | 6 |
| `products` | 120 |
| `banners` | 4 |
| `coupons` | 2 |
| `reviews` | ~40 |
| `meta/seed` | 1 |

Product images use curated textile-specific public URLs (Unsplash) stored
directly in Firestore.
