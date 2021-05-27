const { assertFails, assertSucceeds } = require("@firebase/rules-unit-testing");
const { setup, myAuth, myUid, adminAuth, otherUid } = require("./helper");

describe("Admin Test", () => {
  it("Editing 'isAdmin' property must be failed", async () => {
    ///
    ///
    const mockData = {
      ["users/" + myUid]: {
        displayName: "user-name",
        isAdmin: false
      }
    };
    const db = await setup(myAuth, mockData);
    usersCol = db.collection("users");
    await assertSucceeds(usersCol.doc(myUid).update({ birthday: 731016 }));
    await assertFails(usersCol.doc(myUid).update({ isAdmin: true }));
  });

  it("Admin can cannot change 'isAdmin'. isAdmin is true for admin. So setting isAdmin true is okay.", async () => {
    const db = await setup(adminAuth);
    usersCol = db.collection("users");
    await assertSucceeds(usersCol.doc(adminAuth.uid).update({ isAdmin: true }));
  });
  it("Admin can cannot change 'isAdmin'. isAdmin is true for admin. So setting isAdmin false should fail.", async () => {
    const db = await setup(adminAuth);
    usersCol = db.collection("users");
    await assertFails(usersCol.doc(adminAuth.uid).update({ isAdmin: false }));
  });
  it("Admin can cannot change other user's 'isAdmin'.", async () => {
    const mockData = {
      ["users/" + otherUid]: {
        displayName: "user-name"
      }
    };
    const db = await setup(adminAuth, mockData);
    usersCol = db.collection("users");
    await assertFails(usersCol.doc(otherUid).update({ isAdmin: true }));
    await assertFails(usersCol.doc(otherUid).update({ isAdmin: false }));
  });
});
