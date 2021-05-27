import * as admin from "firebase-admin";
/// Firebase Admin SDK Account Key 를 가져 옴
const serviceAccount = require("/Users/thruthesky/Documents/Keys/firebase/admin-sdk-service-account-key/sonub-dating.json");

/// Firebase 초기화는 한 번 만 함
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://sonub-dating.firebaseio.com"
  });
}

const listAllUsers = (nextPageToken) => {
  // List batch of users, 1000 at a time.
  admin
    .auth()
    .listUsers(1000, nextPageToken)
    .then((listUsersResult) => {
      listUsersResult.users.forEach((userRecord) => {
        console.log("user", userRecord.toJSON());
        admin.auth().deleteUser(userRecord.uid);
      });
      if (listUsersResult.pageToken) {
        // List next batch of users.
        listAllUsers(listUsersResult.pageToken);
      }
    })
    .catch((error) => {
      console.log("Error listing users:", error);
    });
};

// Start listing users from the beginning, 1000 at a time.
listAllUsers("0dIDgf0zqWXDscGdRe2tbNAso3I2");
