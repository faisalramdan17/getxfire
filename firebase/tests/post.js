const {
  assertFails,
  assertSucceeds,
  firestore
} = require("@firebase/rules-unit-testing");
const { setup, myAuth, myUid, otherAuth, otherUid } = require("./helper");

const postId = "post-id-1";
const category = "apple";

const mockMyPost = {
  ["posts/" + postId]: {
    uid: myUid,
    category: category,
    title: "this is the title.",
    createdAt: 1,
    updatedAt: 2
  },
  ["categories/" + category]: {
    title: "Apple"
  },
  ["categories/banana"]: {
    title: "Banana"
  }
};

const postData = {
  uid: myAuth.uid,
  title: "title",
  category: "apple",
  createdAt: 1,
  updatedAt: 1
};

function data(obj) {
  return Object.assign({}, postData, obj);
}

describe("Post", () => {
  /// Write without logging in
  it("Post create without login", async () => {
    const db = await setup();
    const postsDoc = db.collection("posts").doc(postId);
    await assertFails(postsDoc.set({ uid: "my-id", title: "title" }));
  });
  ///  Test creating a post with someone else's UID.
  it("Creating a post with other user's uid should fail", async () => {
    const db = await setup(myAuth);
    const postsCol = db.collection("posts");
    await assertFails(postsCol.add({ uid: "other-uid", title: "title" }));
  });

  it("Creating a post with login but without a category should fail", async () => {
    const db = await setup(myAuth);
    const postsCol = db.collection("posts");
    await assertFails(postsCol.add({ uid: myAuth.uid, title: "title" }));
  });

  it("Creating a post without createdAt should fails", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsCol = db.collection("posts");
    await assertFails(
      postsCol.add({
        uid: myAuth.uid,
        category: category,
        updatedAt: 0
      })
    );
  });

  it("Creating a post without updatedAt should fails", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsCol = db.collection("posts");
    await assertFails(
      postsCol.add({
        uid: myAuth.uid,
        category: category,
        createdAt: 0
      })
    );
  });

  it("Creating success", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsCol = db.collection("posts");
    // console.log(data());
    await assertSucceeds(postsCol.add(data()));
  });

  it("Creating a post with a wrong category should fail", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsCol = db.collection("posts");
    await assertFails(postsCol.add(data({ category: "wrong-category" })));
  });

  it("Creating a post with array category should fail", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsCol = db.collection("posts");

    await assertFails(postsCol.add(data({ category: ["abc"] })));
  });

  it("Updating with updatedAt should success", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsDoc = db.collection("posts").doc(postId);
    const d = { updatedAt: 3 };
    await assertSucceeds(postsDoc.update(d));
  });

  it("Updating without updatedAt should fail", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsDoc = db.collection("posts").doc(postId);
    await assertFails(postsDoc.update({ title: "update" }));
  });

  it("Updating uid property with my uid should success", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsDoc = db.collection("posts").doc(postId);

    const d = {
      uid: myUid,
      updatedAt: 4
    };
    await assertSucceeds(postsDoc.update(d));
  });

  it("Updating uid property with other user uid should faile", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsDoc = db.collection("posts").doc(postId);

    const d = {
      uid: otherUid,
      updatedAt: 5
    };
    await assertFails(postsDoc.update(d));
  });

  it("Updating with wrong category should fail", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsDoc = db.collection("posts").doc(postId);
    await assertFails(
      postsDoc.update({
        category: "abc",
        updatedAt: 6
      })
    );
  });
  it("Updating category", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsDoc = db.collection("posts").doc(postId);
    await assertSucceeds(
      postsDoc.update({
        category: "apple",
        updatedAt: 7
      })
    );
    await assertSucceeds(
      postsDoc.update({
        category: "banana",
        updatedAt: 8
      })
    );
  });

  it("Updating a post on other user should fail", async () => {
    const db = await setup(otherAuth, mockMyPost);
    const postsDoc = db.collection("posts").doc(postId);
    await assertFails(
      postsDoc.update({
        updatedAt: 9
      })
    );
  });

  it("Updating a post created by another user", async () => {
    const db = await setup(myAuth, {
      ["posts/" + postId]: {
        uid: otherUid,
        title: "this is the title."
      }
    });
    const postsDoc = db.collection("posts").doc(postId);
    await assertFails(postsDoc.update({ uid: myAuth.uid, updatedAt: 10 }));
  });

  it("fail on deleting another's post", async () => {
    const db = await setup(myAuth, {
      "posts/post-id-3": {
        uid: "written-by-another-user",
        title: "this is the title."
      }
    });
    const postsDoc = db.collection("posts").doc("post-id-3");
    await assertFails(postsDoc.delete());
  });

  it("success on deleting my post", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsDoc = db.collection("posts").doc("post-id-1");
    await assertSucceeds(postsDoc.delete());
  });
  it("Cannot update likes together with other properties.", async () => {
    const db = await setup(myAuth, mockMyPost);
    const postsDoc = db.collection("posts").doc(postId);
    await assertFails(
      postsDoc.update({
        category: "apple",
        likes: 123456789,
        updatedAt: 20
      })
    );
  });
});
