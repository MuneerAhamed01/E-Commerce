# Trends

Production-grade e-commerce platform built with **Flutter** and **Firebase**, following [Very Good Ventures layered architecture](https://verygood.ventures/blog/very-good-flutter-architecture/).

## Quick Start

```bash
# Use FVM Flutter version (3.44.1)
fvm flutter pub get
fvm flutter run
```

## Project Identity

| Field | Value |
|-------|-------|
| App name | **Trends** |
| Dart package | `trends` |
| Bundle ID | `com.trends.commerce` |

## Architecture

- **State:** `flutter_bloc` (VGV standard)
- **Layers:** Data → Domain → Business Logic → Presentation
- **Reference:** [Flutter News Toolkit](https://github.com/VGVentures/news_toolkit)

## Documentation

All architecture and planning docs live in [`cursor_analysis/`](./cursor_analysis/README.md):

- [Project identity](./cursor_analysis/01_project_identity.md)
- [Flutter architecture](./cursor_analysis/02_flutter_architecture.md)
- [Database design](./cursor_analysis/03_database_design.md)
- [Firebase setup](./cursor_analysis/04_firebase_setup.md)
- [External services](./cursor_analysis/05_external_services.md)
- [MVP implementation plan](./cursor_analysis/06_mvp_implementation_plan.md)
- [News Toolkit reference](./cursor_analysis/07_news_toolkit_reference.md)

## Current Phase

**Phase 1 — Full MVP:** Advanced VGV monorepo structure (`packages/`), all e-commerce features, Stitch UI. Phase 0 (foundation + Firebase) is complete.

## Structure (target)

```text
lib/                    # Feature presentation (BLoC, views)
packages/               # app_ui, repositories, clients
functions/              # Cloud Functions
cursor_analysis/        # Architecture docs
```
