const { assertSucceeds, assertFails } = require("@firebase/rules-unit-testing");
const firebase = require("@firebase/rules-unit-testing");
const { setup, myAuth, myUid, otherUid } = require("./helper");

const mockData = {
  "posts/post-id-1": {
    uid: myAuth.uid,
    title: "this is the title."
  },
  "posts/post-id-1/comments/comment-id-1": {
    uid: myAuth.uid,
    order: "99999.9999.999.999.999.999.999.999.999.999.999.999",
    content: "content"
  },
  "categories/apple": {
    title: "Apple"
  }
};

describe("Comment it", () => {
  it("comment without login must failed", async () => {
    const db = await setup();
    const col = db.collection("posts").doc("post-id-1").collection("comments");
    await assertFails(col.add({ uid: "uid", content: "content" }));
  });

  it("comment with login but post id not existing", async () => {
    const db = await setup(myAuth);
    const col = db
      .collection("posts")
      .doc("non-exisiting-post-id")
      .collection("comments");
    await assertFails(
      col.doc("non-exisiting-post-id").set({ uid: "uid", content: "content" })
    );
  });

  it("with wrong post id", async () => {
    const db = await setup(myAuth, mockData);
    const col = db
      .collection("posts")
      .doc("non-exisiting-post-id")
      .collection("comments");
    await assertFails(col.add({ uid: "uid", content: "content" }));
  });

  it("with wrong order", async () => {
    const db = await setup(myAuth, mockData);
    const col = db.collection("posts").doc("post-id-1").collection("comments");
    await assertFails(col.add({ uid: "uid", content: "content" }));
  });

  it("create", async () => {
    const db = await setup(myAuth, mockData);
    const col = db.collection("posts").doc("post-id-1").collection("comments");
    await assertSucceeds(
      col.add({
        uid: myAuth.uid,
        content: "content",
        depth: 1,
        order: "999999.999.999.999.999.999.999.999.999.999.999.999",
        like: 0,
        dislike: 0,
        createdAt: 1,
        updatedAt: 1
      })
    );
  });

  it("update with wrong uid( not my comment )", async () => {
    const db = await setup({ uid: "wrong-uid" }, mockData);
    const col = db
      .collection("posts")
      .doc("post-id-1")
      .collection("comments")
      .doc("comment-id-1");
    await assertFails(
      col.update({
        content: "content change"
      })
    );
  });
  it("update with uid", async () => {
    const db = await setup(myAuth, mockData);
    const col = db
      .collection("posts")
      .doc("post-id-1")
      .collection("comments")
      .doc("comment-id-1");
    await assertFails(
      col.update({
        content: "content",
        uid: "new-uid"
      })
    );
  });

  it("update with order", async () => {
    const db = await setup(myAuth, mockData);
    const col = db
      .collection("posts")
      .doc("post-id-1")
      .collection("comments")
      .doc("comment-id-1");
    await assertFails(
      col.update({
        content: "content",
        order:
          "99999.99999.99999.99999.99999.99999.99999.99999.99999.99999.99999.99990" // uid 변경
      })
    );
  });
  it("update with non-exist-post", async () => {
    const db = await setup(myAuth, mockData);
    const col = db
      .collection("posts")
      .doc("non-exist")
      .collection("comments")
      .doc("comment-id-1");
    await assertFails(
      col.update({
        content: "content change"
      })
    );
  });

  it("update with wrong comment -id", async () => {
    const db = await setup(myAuth, mockData);
    const col = db
      .collection("posts")
      .doc("post-id-1")
      .collection("comments")
      .doc("wrong-comment-id");
    await assertFails(
      col.update({
        content: "content change"
      })
    );
  });

  it("update comment", async () => {
    const db = await setup(myAuth, mockData);
    const col = db
      .collection("posts")
      .doc("post-id-1")
      .collection("comments")
      .doc("comment-id-1");
    await firebase.assertSucceeds(
      col.update({
        content: "content change"
      })
    );
  });

  it("delete with wrong uid", async () => {
    const db = await setup({ uid: "wrong" }, mockData);
    const col = db
      .collection("posts")
      .doc("post-id-1")
      .collection("comments")
      .doc("comment-id-1");
    await assertFails(col.delete());
  });

  it("delete with wrong post id", async () => {
    const db = await setup(myAuth, mockData);
    const col = db
      .collection("posts")
      .doc("wrong")
      .collection("comments")
      .doc("comment-id-1");
    await assertFails(col.delete());
  });

  it("delete with wrong wrong comment id", async () => {
    const db = await setup(myAuth, mockData);
    const col = db
      .collection("posts")
      .doc("post-id-1")
      .collection("comments")
      .doc("wrong");
    await assertFails(col.delete());
  });

  it("delete comment", async () => {
    const db = await setup(myAuth, mockData);
    const col = db
      .collection("posts")
      .doc("post-id-1")
      .collection("comments")
      .doc("comment-id-1");
    await assertSucceeds(col.delete());
  });
});
