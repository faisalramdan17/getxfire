const { assertFails, assertSucceeds } = require("@firebase/rules-unit-testing");
const { firestore } = require("firebase-admin");
const { setup, myAuth, otherUid, otherAuth } = require("./helper");

const postId = "my-post-id";
const myPostPath = "/posts/" + postId;
const mockData = {
  ["posts/" + postId]: {
    uid: myAuth.uid,
    title: "title",
    content: "content",
    createdAt: 0,
    updatedAt: 0
  },
  "categories/apple": {
    title: "Apple"
  }
};

const commentPath = "/posts/b/comments/c";
const commentMockData = {
  [commentPath]: {
    uid: myAuth.uid,
    content: "content",
    createdAt: 0,
    updatedAt: 0
  }
};

/// Rules. @see firestore.rules
///
describe("Vote test on Post", () => {
  it("Voting on other's post. empty non-existing likes property", async () => {
    const db = await setup(otherAuth, mockData);
    const doc = db.doc(myPostPath);
    // console.log((await doc.get()).data());
    await assertSucceeds(
      doc.set({ likes: { otherUid: true } }, { merge: true })
    );
    // console.log((await doc.get()).data());
  });

  it("Voting on my post. empty non-existing likes property", async () => {
    const db = await setup(myAuth, mockData);
    const doc = db.doc(myPostPath);
    // console.log((await doc.get()).data());
    await assertSucceeds(doc.set({ likes: { myUid: true } }, { merge: true }));
    // console.log((await doc.get()).data());
  });

  it("Voting on post with other UID", async () => {
    const db = await setup(myAuth, mockData);
    const doc = db.doc(myPostPath);
    await assertFails(doc.set({ likes: { otherUid: true } }, { merge: true }));
    // console.log((await doc.get()).data());
  });

  it("Voting on other's post. with existing-but-empty likes property", async () => {
    mockData["posts/my-post-id"]["likes"] = {};
    const db = await setup(otherAuth, mockData);
    const doc = db.doc(myPostPath);
    // console.log((await doc.get()).data());
    await assertSucceeds(
      doc.set({ likes: { otherUid: true } }, { merge: true })
    );
    // console.log((await doc.get()).data());
  });

  it("Voting on other's post. with existing-with-myUid likes property", async () => {
    mockData["posts/my-post-id"]["likes"] = { myUid: true };
    const db = await setup(otherAuth, mockData);
    const doc = db.doc(myPostPath);
    // console.log((await doc.get()).data());
    await assertSucceeds(
      doc.set({ likes: { [otherUid]: true } }, { merge: true })
    );
    // console.log((await doc.get()).data());
  });

  it("Voting with other UID.", async () => {
    mockData["posts/my-post-id"]["likes"] = { A: true };
    const db = await setup(myAuth, mockData);
    const doc = db.doc(myPostPath);
    // console.log((await doc.get()).data());
    await assertFails(doc.set({ likes: { B: true } }, { merge: true }));
    // console.log((await doc.get()).data());
  });
  it("Removing(withdrawing) other UID from vote.", async () => {
    mockData["posts/my-post-id"]["likes"] = { myUid: false, A: true, B: true };
    const db = await setup(myAuth, mockData);
    const doc = db.doc(myPostPath);
    var data = (await doc.get()).data();
    // console.log(data);
    data["likes"] = { myUid: false, A: true };
    await assertFails(doc.set(data));
    // console.log((await doc.get()).data());
  });

  it("Removing(withdrawing) my UID from my post vote.", async () => {
    mockData["posts/my-post-id"]["likes"] = { myUid: false, A: true, B: true };
    const db = await setup(myAuth, mockData);
    const doc = db.doc(myPostPath);
    var data = (await doc.get()).data();
    // console.log(data);
    data["likes"] = { A: true, B: true };
    await assertSucceeds(doc.set(data));
    // console.log((await doc.get()).data());
  });

  it("Removing(withdrawing) my(other) UID from other post vote.", async () => {
    mockData["posts/my-post-id"]["likes"] = {
      otherUid,
      myUid: false,
      A: true,
      B: true
    };
    const db = await setup(otherAuth, mockData);
    const doc = db.doc(myPostPath);
    var data = (await doc.get()).data();
    // console.log(data);
    data["likes"] = { myUid: false, A: true, B: true };
    await assertSucceeds(doc.set(data));
    // console.log((await doc.get()).data());
  });

  it("Changing other user's choice.", async () => {
    mockData["posts/my-post-id"]["likes"] = { A: true };
    const db = await setup(otherAuth, mockData);
    const doc = db.doc(myPostPath);
    await assertFails(doc.set({ likes: { A: false } }, { merge: true }));
  });

  it("Changing my choice.", async () => {
    mockData["posts/my-post-id"]["likes"] = { A: true, otherUid: true };
    const db = await setup(otherAuth, mockData);
    const doc = db.doc(myPostPath);
    await assertSucceeds(
      doc.set({ likes: { otherUid: false } }, { merge: true })
    );
  });

  it("Voting on comment that has non-existing likes property", async () => {
    const db = await setup(myAuth, commentMockData);
    const doc = db.doc(commentPath);
    await assertSucceeds(doc.set({ likes: { myUid: true } }, { merge: true }));
  });

  it("Voting on comment with other UID", async () => {
    const db = await setup(myAuth, commentMockData);
    const doc = db.doc(commentPath);
    await assertFails(doc.set({ likes: { otherUid: true } }, { merge: true }));
    // console.log((await doc.get()).data());
  });

  it("Changing my choice.", async () => {
    commentMockData[commentPath]["likes"] = { A: true, otherUid: true };
    const db = await setup(otherAuth, mockData);
    const doc = db.doc(myPostPath);
    await assertSucceeds(
      doc.set({ likes: { otherUid: false } }, { merge: true })
    );
  });
  it("Changing other's choice.", async () => {
    commentMockData[commentPath]["likes"] = { A: true, otherUid: true };
    const db = await setup(otherAuth, mockData);
    const doc = db.doc(myPostPath);
    await assertFails(doc.set({ likes: { A: false } }, { merge: true }));
  });
});
