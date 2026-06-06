import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

/**
 * Creates a Firestore user profile when a new Firebase Auth user is created.
 */
export const onUserCreated = functions.auth.user().onCreate(async (user) => {
  const userRef = db.collection("users").doc(user.uid);

  await userRef.set(
    {
      id: user.uid,
      email: user.email ?? null,
      displayName: user.displayName ?? null,
      photoUrl: user.photoURL ?? null,
      phone: user.phoneNumber ?? null,
      role: "customer",
      orderCount: 0,
      defaultAddressId: null,
      fcmTokens: [],
      preferences: {
        notificationsEnabled: true,
        marketingOptIn: false,
      },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true },
  );
});
