const firebase = require("@firebase/rules-unit-testing");
const { setup, myAuth, myUid } = require("./helper");

describe("Basic", () => {
  it("Read should success", async () => {
    const db = await setup();

    const testDoc = db.collection("readonlytest").doc("testDocId");

    await firebase.assertSucceeds(testDoc.get());
  });
  it("Write should fail", async () => {
    const db = await setup();
    const testDoc = db.collection("readonlytest").doc("testDocId");

    // Fails due to user authentication
    await firebase.assertFails(testDoc.set({ foo: "bar" }));
  });

  it("Write should success", async () => {
    const db = await setup(myAuth);

    const myDoc = db.collection("readonlytest").doc(myUid);

    await firebase.assertSucceeds(myDoc.set({ foo: "bar" }));
  });

  //
  it("Read success on public doc", async () => {
    const db = await setup();
    const testQuery = db
      .collection("publictest")
      .where("visibility", "==", "public");
    await firebase.assertSucceeds(testQuery.get());
  });

  it("Read success on public doc", async () => {
    const db = await setup(myAuth);
    const testQuery = db.collection("publictest").where("uid", "==", myUid);
    await firebase.assertSucceeds(testQuery.get());
  });

  // 관리자 db instance 로 private 값을 미리 지정해서, 오류 테스트
  // Set data on firestore documents with admin permission and test.
  it("Read success on public doc", async () => {
    const db = await setup(myAuth, {
      "publictest/privateDocId": {
        visibility: "private"
      },
      "publictest/publicDocId": {
        visibility: "public"
      },
      "publictest/myDocId": {
        visibility: "does not matter",
        uid: myUid
      }
    });
    let testQuery = db.collection("publictest").doc("privateDocId");
    await firebase.assertFails(testQuery.get());
    testQuery = db.collection("publictest").doc("publicDocId");
    await firebase.assertSucceeds(testQuery.get());

    await firebase.assertSucceeds(
      db.collection("publictest").doc("myDocId").get()
    );
  });
});
