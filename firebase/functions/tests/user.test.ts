import * as admin from "firebase-admin";
import { UserRecord } from "firebase-functions/lib/providers/auth";

/// Firebase Admin SDK Account Key 를 가져 옴
const serviceAccount = require("/Users/thruthesky/Documents/Keys/firebase/admin-sdk-service-account-key/sonub-dating.json");

/// Firebase 초기화는 한 번 만 함
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://sonub-dating.firebaseio.com"
  });
}

/// 테스트를 위한 헬퍼 함수 import
import { deleteCollection } from "./test-helper-functions";

/// 테스트 툴
import "mocha";
import { assert } from "chai";

/// Firebase Authentication 의 사용자를 관리하기 위한 admin.auth() 인스턴스
const auth = admin.auth();

/// 테스트 사용자 정보
const password = "12345a,*";
interface UserData {
  email: string;
  password: string;
  phoneNumber: string;
  displayName: string;
  photoURL: string;
  disabled: boolean;
}
interface UsersData {
  [key: string]: UserData;
}
const users: UsersData = {
  admin: {
    email: "userAdmin@test.com",
    password: password,
    phoneNumber: "+10123456785",
    displayName: "User Admin",
    photoURL: "http://www.example.com/12345678/photo.png",
    disabled: false
  },
  a: {
    email: "userA@test.com",
    password: password,
    phoneNumber: "+10123456782",
    displayName: "User A",
    photoURL: "http://www.example.com/12345678/photo.png",
    disabled: false
  },
  b: {
    email: "userB@test.com",
    password: password,
    phoneNumber: "+10123456780",
    displayName: "User B",
    photoURL: "http://www.example.com/12345678/photo.png",
    disabled: false
  },
  c: {
    email: "userC@test.com",
    password: password,
    phoneNumber: "+10123456781",
    displayName: "User C",
    photoURL: "http://www.example.com/12345678/photo.png",
    disabled: false
  }
};

import { User } from "../src/user";
import {
  EMPTY_UID,
  USER_PUBLIC_DATA_NOT_EXISTS,
  ADMIN_DATA_NOT_EXISTS,
  YOU_ARE_NOT_ADMIN,
  USER_NOT_EXISTS
} from "../src/definitions";
const user = new User();
let adminAccount: UserRecord;
function adminContext() {
  return {
    auth: {
      uid: adminAccount?.uid
    }
  };
}

describe("Firebase test", () => {
  it("Clean user data before test", async () => {
    for (const k of Object.keys(users)) {
      try {
        const u = await auth.getUserByEmail(users[k].email);
        await auth.deleteUser(u.uid);
        console.log(`${u.displayName} has been deleted.`);
      } catch (e) {
        if (e.code == "auth/user-not-found") {
        } else {
          console.log(e);
          assert(false, "Failed to delete user.");
        }
      }
    }
  });
  it("Clean test firestore data before test", async () => {
    await deleteCollection(admin.firestore(), "test/data/path", 500);
  });

  it("Create admin account", async () => {
    /// 처음에 관리자를 계정 생성 할 때, 관리자 권한이 없으므로, User.create() 를 사용하지 못하고, auth 를 통해 생성.
    const u = await auth.createUser(users.admin);
    adminAccount = u;
    assert(u.displayName, users.a.displayName);
    /// 처음에 관리자 게정 생성 할 때, 관리자 권한이 없으므로, User.setAdmin() 을 사용하지 못한다.
    await user.dataDoc(adminAccount.uid).set({ isAdmin: true });
    const pub = await user.dataGet(adminAccount.uid);
    assert(pub.isAdmin == true, "isAdmin == true");
  });
  it("Set as admin", async () => {
    await user.setAdmin(adminAccount.uid, adminContext());
  });
  it("Get admin data", async () => {
    const userGot = await user.dataGet(adminAccount.uid);
    assert(userGot.isAdmin, "the user is admin");
  });
  it("Error test", async () => {
    try {
      await user.setAdmin("", adminContext());
      assert(false, "must failed on setAdmin.");
    } catch (e) {
      assert(e === EMPTY_UID);
    }
    try {
      await user.publicDataGet("");
      assert(false, "must failed on publicDataGet");
    } catch (e) {
      assert(e === EMPTY_UID);
    }
  });

  it("Get non-existent user", async () => {
    try {
      await user.getUser("abc", adminContext());
    } catch (e) {
      assert(e == USER_NOT_EXISTS, `${e} == USER_NOT_EXISTS`);
    }
  });

  it("Delete non-existent user", async () => {
    try {
      await user.delete("abc", adminContext());
    } catch (e) {
      assert(e == USER_NOT_EXISTS, `${e} == USER_NOT_EXISTS`);
    }
  });

  it("Creating user A with wrong uid", async () => {
    try {
      await user.create(users.a, { auth: { uid: "wrong-uid" } });
    } catch (e) {
      // console.log(e);
      assert(e == ADMIN_DATA_NOT_EXISTS, "USER_PUBLIC_DATA_NOT_EXISTS");
    }
  });

  it("Creating user B by user A. Admin permission error expected.", async () => {
    let a = await user.create(users.a, adminContext());
    try {
      await user.create(users.b, { auth: { uid: a.uid } });
    } catch (e) {
      assert(
        e == ADMIN_DATA_NOT_EXISTS,
        `${e} == ADMIN_DATA_NOT_EXISTS Admin data document must not exists.`
      );
    }
    await user.dataCreate(a.uid, adminContext());
    try {
      await user.create(users.b, { auth: { uid: a.uid } });
    } catch (e) {
      assert(e == YOU_ARE_NOT_ADMIN, `${e} == YOU_ARE_NOT_ADMIN`);
    }
    await user.delete(a.uid, adminContext());
  });

  it("Create user A and delete", async () => {
    const a = await user.create(users.a, adminContext());
    assert(a.displayName, users.a.displayName);

    await user.publicDataCreate(a.uid, adminContext());
    const aPub = await user.publicDataGet(a.uid);
    assert(aPub.id == a.uid);

    await user.delete(a.uid, adminContext());
    await user.publicDataDelete(a.uid, adminContext());

    try {
      await user.publicDataGet(a.uid);
    } catch (e) {
      assert(
        e == USER_PUBLIC_DATA_NOT_EXISTS,
        "e == USER_PUBLIC_DATA_NOT_EXISTS"
      );
    }
  });

  it("Create user A/B/C and delete them", async () => {
    const a = await user.create(users.a, adminContext());
    const b = await user.create(users.b, adminContext());
    const c = await user.create(users.c, adminContext());

    await user.publicDataCreate(a.uid, adminContext());
    await user.publicDataCreate(b.uid, adminContext());
    await user.publicDataCreate(c.uid, adminContext());
    // console.log([a.uid, b.uid, c.uid]);
    await user.delete([a.uid, b.uid, c.uid], adminContext());

    await user.publicDataDelete([a.uid, b.uid, c.uid], adminContext());

    try {
      await user.publicDataGet(a.uid);
    } catch (e) {
      assert(e == USER_PUBLIC_DATA_NOT_EXISTS, "a deleted");
    }
    try {
      await user.publicDataGet(b.uid);
    } catch (e) {
      assert(e == USER_PUBLIC_DATA_NOT_EXISTS, "b deleted");
    }
    try {
      await user.publicDataGet(c.uid);
    } catch (e) {
      assert(e == USER_PUBLIC_DATA_NOT_EXISTS, "c deleted");
    }
  });
});
