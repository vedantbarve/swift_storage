const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

exports.scheduleDelete = functions.region("asia-south1").pubsub.topic('scheduleDelete').onPublish(async message =>{
    const rooms = await admin.firestore().collection("rooms").listDocuments();
    rooms.forEach(async data=>{
        
        await admin.firestore().collection("rooms").doc(data.id).delete();
    },);
    const files = await admin.firestore().collection("files").listDocuments();
    files.forEach(async data=>{
        await admin.firestore().collection("files").doc(data.id).delete();
    },);
    await admin.storage().bucket().deleteFiles();
},);