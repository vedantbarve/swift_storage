const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const bucket = admin.storage().bucket();

exports.scheduleDelete = functions
  .region("asia-south1")
  .pubsub.topic("scheduleDelete")
  .onPublish(async (message) => {
    const rooms = await admin.firestore().collection("rooms").get();

    rooms.forEach(async (doc) => {
      const docData = doc.data();
      const d1 = new Date().toISOString();
      if (docData.deleteDate <= d1) {
        const files = await admin
          .firestore()
          .collection("files")
          .where("roomId", "==", docData.roomId)
          .get();
        files.forEach(async (file) => {
          const fileData = file.data();
          await bucket.file(fileData.fullPath).delete();
          await admin.firestore().collection("files").doc(file.id).delete();
        });
        await admin.firestore().collection("rooms").doc(doc.id).delete();
      }
    });
  });
