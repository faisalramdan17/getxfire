const firebase = require("@firebase/rules-unit-testing");
const { setup, myAuth, adminAuth, myUid, otherUid } = require("./helper");

describe("Category", () => {
  it("Reading categories without login", async () => {
    const db = await setup();
    const col = db.collection("categories");
    await firebase.assertSucceeds(col.limit(10).get());
  });

  it("Reading a category with non-admin account.", async () => {
    const db = await setup(myAuth);
    const doc = db.collection("categories").doc("abc");
    await firebase.assertSucceeds(doc.get());
  });

  it("Creating without login", async () => {
    const db = await setup();
    const col = db.collection("categories");
    await firebase.assertFails(col.add({ id: "abc" }));
  });

  it("Creating with non-admin account should fail.", async () => {
    const db = await setup({ uid: otherUid });
    const col = db.collection("categories");
    await firebase.assertFails(col.add({ id: "abc" }));
  });

  it("Creating a category with admin account but missing some fields should fail", async () => {
    const db = await setup(adminAuth);
    const doc = db.collection("categories").doc("abc");
    await firebase.assertFails(doc.set({ id: "abc", title: "alphabet" }));
  });

  it("Creating a category with admin account should success", async () => {
    const db = await setup(adminAuth);
    const doc = db.collection("categories").doc("abc");
    await firebase.assertSucceeds(
      doc.set({ id: "abc", title: "title", description: "desc" })
    );
  });

  it("Different id field value from category document id should failed", async () => {
    const db = await setup(adminAuth);
    const doc = db.collection("categories").doc("abc");
    await firebase.assertFails(
      doc.set({ id: "wrong-id", title: "title", description: "desc" })
    );
  });

  it("Updating a category with non-admin account should fail", async () => {
    const db = await setup(myAuth);
    const doc = db.collection("categories").doc("abc");
    await firebase.assertFails(doc.update({ title: "updated title" }));
  });

  it("Changing id with admin account should fail.", async () => {
    const db = await setup(adminAuth, {
      "categories/abc": {
        id: "abc",
        title: "alphabet"
      }
    });
    const doc = db.collection("categories").doc("abc");
    await firebase.assertFails(doc.update({ id: "new-id" }));
  });

  it("Updating title with same id with admin account.", async () => {
    const db = await setup(adminAuth, {
      "categories/abc": {
        id: "abc",
        title: "title"
      }
    });
    const doc = db.collection("categories").doc("abc");
    await firebase.assertSucceeds(doc.update({ title: "new title" }));
  });
});
