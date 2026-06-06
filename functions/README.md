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
