import type { Firestore } from "firebase-admin/firestore";

const BATCH_LIMIT = 400;

export type BatchWrite = {
  collection: string;
  id: string;
  data: FirebaseFirestore.DocumentData;
};

/** Commits writes in Firestore batches (max 400 per batch). */
export async function commitBatches(
  db: Firestore,
  writes: BatchWrite[],
): Promise<void> {
  for (let index = 0; index < writes.length; index += BATCH_LIMIT) {
    const chunk = writes.slice(index, index + BATCH_LIMIT);
    const batch = db.batch();

    for (const write of chunk) {
      const ref = db.collection(write.collection).doc(write.id);
      batch.set(ref, write.data, { merge: false });
    }

    await batch.commit();
  }
}

/** Deletes all documents in a collection (dev re-seed only). */
export async function clearCollection(
  db: Firestore,
  collectionName: string,
): Promise<number> {
  const snapshot = await db.collection(collectionName).get();
  if (snapshot.empty) {
    return 0;
  }

  const deletes: BatchWrite[] = snapshot.docs.map((doc) => ({
    collection: collectionName,
    id: doc.id,
    data: {},
  }));

  for (let index = 0; index < deletes.length; index += BATCH_LIMIT) {
    const chunk = deletes.slice(index, index + BATCH_LIMIT);
    const batch = db.batch();

    for (const write of chunk) {
      batch.delete(db.collection(write.collection).doc(write.id));
    }

    await batch.commit();
  }

  return snapshot.size;
}
