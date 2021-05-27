const firebase = require("@firebase/rules-unit-testing");
// 실제 Firebase Project ID.
// Firebase Project ID.
const MY_PROJECT_ID = "social-management-system";

// Fake User UID - My UID.
const myUid = "myUid";
// Fake User UiD
const otherUid = "otherUid";

// Fake User Auth Data
const myAuth = { uid: myUid, email: "my-email@gmail.com" };
const otherAuth = { uid: otherUid, email: "other-email@gmail.com" };

// admin User UID
const adminUid = "admin_uid";
const adminAuth = {
  uid: adminUid,
  email: "admin1@gmail.com",
  isAdmin: true,
  firebase: {
    sign_in_provider: "password"
  }
};

// Firestore intance 를 가져오는 함수
// Get Firestore instance for CRUD work.
function getFirestore(auth = null) {
  return firebase
    .initializeTestApp({ projectId: MY_PROJECT_ID, auth: auth })
    .firestore();
}

// Firestore admin instance 를 가져오는 함수. 이 객체는 모든 권한을 다 가진다.
// Get Firestore admin instance that has all the power(permission) on creat/update/delete of the entire Firestore.
// Security rules does not apply with the admin instance.
function getAdminFirestore() {
  return firebase.initializeAdminApp({ projectId: MY_PROJECT_ID }).firestore();
}

// Helper function to make the test code simple.
module.exports.setup = async (auth, data, clear = true) => {
  // Clear firestore on every setup.
  //
  // It's important to clear on every test or it might not work as expected.
  // When you call .set(), it may be a `create` action if the document is not exist, or it would be `update`.
  if (clear) await firebase.clearFirestoreData({ projectId: MY_PROJECT_ID });
  const db = getFirestore(auth); // Firestore instance 를 가져온다

  // Get admin db instance
  const adminDb = getAdminFirestore();

  // Put admin data into Firestore
  adminDb.doc("users/" + adminUid).set({ isAdmin: true });

  // Push default data to Firestore
  // If there is data to set, set it with admin instance.
  if (data && Object.keys(data).length > 0) {
    for (const key in data) {
      // key 마다, 데이터를 모두 기록한다.
      // Save data for each path.
      const ref = adminDb.doc(key);
      await ref.set(data[key]);
    }
  }
  return db;
};

module.exports.myAuth = myAuth;
module.exports.myUid = myUid;
module.exports.otherUid = otherUid;
module.exports.otherAuth = otherAuth;
module.exports.adminAuth = adminAuth;
