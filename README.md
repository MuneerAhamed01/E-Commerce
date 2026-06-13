# Trends

A production-style **Flutter e-commerce app** with **Firebase**, built using [Very Good Ventures layered architecture](https://verygood.ventures/blog/very-good-flutter-architecture/).

Built as a portfolio piece demonstrating mobile architecture, Firebase integration, and end-to-end shopping flows.

![Flutter](https://img.shields.io/badge/Flutter-3.44+-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore%20%7C%20Functions-FFCA28?logo=firebase)
![CI](https://img.shields.io/badge/CI-analyze%20%2B%20test-blue)

## Highlights

- **Monorepo packages** — `app_ui`, repository layer, auth client abstraction
- **State management** — `flutter_bloc` with Formz-validated auth forms
- **Navigation** — `go_router` with auth-aware redirects and onboarding gate
- **Firebase** — Auth (email, Google, Apple), Firestore, Cloud Functions, Analytics, Crashlytics
- **E-commerce flows** — Home, catalog, search, product detail, cart, wishlist, checkout, orders
- **Design system** — Aura Couture tokens and reusable widgets in `packages/app_ui`
- **Security** — Owner-based Firestore and Storage rules (not open access)

## Screens & features

| Feature | Description |
|---------|-------------|
| Auth | Email/password, Google, Apple, forgot password |
| Onboarding | Profile completion after first sign-in |
| Home | Banners, categories, featured & new arrivals |
| Catalog & search | Category browsing, Firestore prefix search |
| Product detail | Variants, reviews, add to cart / wishlist |
| Cart | Quantity updates, coupon support, badge |
| Checkout | Addresses, order summary, COD placement |
| Orders | Order history and detail |
| Profile | Account info and sign-out |

## Architecture

```text
lib/                         # Feature UI + BLoC/Cubit
packages/
  app_ui/                    # Design system
  authentication_client/     # Auth abstraction
  firebase_authentication_client/
  user_repository/
  product_repository/
  cart_repository/
  order_repository/
  form_inputs/
  persistent_storage/
functions/                   # Cloud Functions + seed scripts
```

**Data flow:** Presentation → BLoC → Repository → Firebase

## Quick start

```bash
flutter pub get
flutter run
```

### Backend setup (required for full demo)

```bash
npx firebase-tools@latest deploy --only firestore:rules,firestore:indexes,storage,functions:onUserCreated
cd functions && npm install && npm run seed -- --force
```

See **[docs/DEMO.md](./docs/DEMO.md)** for the full client demo script.

### Local emulators (optional)

```bash
firebase emulators:start
flutter run --dart-define=USE_FIREBASE_EMULATORS=true
```

## Development

```bash
flutter analyze
flutter test

# Package tests
cd packages/user_repository && flutter test
```

CI runs analyze + tests on push (see `.github/workflows/ci.yml`).

## Project identity

| Field | Value |
|-------|-------|
| App name | **Trends** |
| Dart package | `trends` |
| Bundle ID | `com.trends.commerce` |
| Firebase project | `trends-commerce-dev` |

## Tech stack

| Layer | Choice |
|-------|--------|
| UI | Flutter, Material 3, custom `app_ui` |
| State | `flutter_bloc`, `formz` |
| Routing | `go_router` |
| Backend | Firebase Auth, Firestore, Cloud Functions |
| Images | `cached_network_image` |
| Lint | `very_good_analysis` |

## Roadmap (post-MVP)

- Razorpay payment SDK + webhooks
- Algolia search
- FCM push notifications
- Firebase App Check
- App flavors (dev / staging / prod)

## License

Private portfolio project. Contact the author for usage terms.
