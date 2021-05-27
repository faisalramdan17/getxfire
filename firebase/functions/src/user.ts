import * as admin from "firebase-admin";
import { UserRecord } from "firebase-functions/lib/providers/auth";
import {
  EMPTY_UID,
  USER_PUBLIC_DATA_NOT_EXISTS,
  YOU_ARE_NOT_ADMIN,
  ADMIN_UID_EMPTY,
  ADMIN_DATA_NOT_EXISTS,
  USER_DATA_NOT_EXISTS,
  USER_NOT_EXISTS,
  UID_IS_NOT_STRING
  // USER_DELETE_FAILED
} from "./definitions";

const db = admin.firestore();
const auth = admin.auth();
const metaCol = db.collection("meta");
const usersCol = db.collection("users");
class User {
  publicDoc(uid: string) {
    return metaCol.doc("user").collection("public").doc(uid);
  }
  dataDoc(uid: string) {
    return usersCol.doc(uid);
  }

  /**
   * Creates a user
   * @param data User create data
   * @param context context data
   *
   * @example
   *    const u = await user.create(users.admin, adminContext());
   */
  async create(data: any, context: any): Promise<UserRecord> {
    await this.checkAdmin(context);
    const user = await auth.createUser(data);
    return user;
  }

  /**
   * Returns user account
   *
   * Attention, it throws an exception if the user does not exists or for any error.
   * @param uid user uid to get information of
   * @param context context
   *
   * @throws USER_NOT_EXISTS, UID_IS_NOT_STRING, or other Firebase error code.
   */
  async getUser(uid: any, context: any): Promise<UserRecord> {
    await this.checkAdmin(context);
    if (!uid) throw EMPTY_UID;
    if (typeof uid !== "string") throw UID_IS_NOT_STRING;
    try {
      return await auth.getUser(uid);
    } catch (e) {
      if (e.code === "auth/user-not-found") throw USER_NOT_EXISTS;
      throw e.code;
    }
  }

  /**
   * Delete users.
   *
   * @param uid string or array of string to delete usres.
   *   If it's a string, it will delte that user of uid.
   *   If it's an array of string, then it will delete the users of uid array.
   * @param context context
   */
  async delete(uid: any, context: any) {
    await this.checkAdmin(context);
    if (!uid) throw EMPTY_UID;

    if (typeof uid === "string") {
      // This will throw exception if the user does not exists.
      await this.getUser(uid, context);
      await auth.deleteUser(uid);
    } else {
      for (const id of uid) {
        // This will throw exception if the user does not exists.
        await this.getUser(id, context);
        await auth.deleteUser(id);
      }
    }
  }

  /**
   * Set the user as admin
   *
   * @param uid uid to become admin
   * @param context context
   */
  async setAdmin(uid: string, context: any): Promise<void> {
    await this.checkAdmin(context);
    if (!uid) throw EMPTY_UID;
    await this.dataDoc(uid).set(
      {
        isAdmin: true
      },
      { merge: true }
    );
  }

  /**
   * Returns user's data.
   *
   * @note id will be inserted into the data.
   *
   * @param uid user uid
   */
  async dataGet(uid: string): Promise<any> {
    if (!uid) throw EMPTY_UID;
    const snapshot = await this.dataDoc(uid).get();
    if (snapshot.exists === false) throw USER_DATA_NOT_EXISTS;
    const data: any = snapshot.data();
    data["id"] = snapshot.id;
    return data;
  }

  /**
   * Create user's data document under `/users` collection.
   *
   * Attention, it will delete existing document by set().
   * @param uid uid
   * @param context context
   */
  async dataCreate(uid: string, context: any) {
    await this.checkAdmin(context);
    await this.dataDoc(uid).set({
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
  }

  /**
   * Updates public data.
   *
   * If public document does not exists, it will create by set merging.
   */
  async dataUpdate(data: any, context: any) {
    await this.checkAdmin(context);
    const uid: string = data.uid;
    delete data.uid;
    data.updatedAt = admin.firestore.FieldValue.serverTimestamp();
    await this.dataDoc(uid).set(data, { merge: true });
  }

  /**
   * Deletes a user's data or multiple user's uid.
   * @param uid a string of uid or string list of multiple uid
   * @param context context
   */
  async dataDelete(uid: any, context: any) {
    await this.checkAdmin(context);
    if (typeof uid === "string") {
      await this.dataDoc(uid).delete();
    } else {
      for (const id of uid) {
        await this.dataDoc(id).delete();
      }
    }
  }

  /**
   * Returns user's public data.
   *
   * @note id will be inserted into the public data.
   *
   * @param uid user uid
   */
  async publicDataGet(uid: string): Promise<any> {
    if (!uid) throw EMPTY_UID;
    const snapshot = await this.publicDoc(uid).get();
    if (snapshot.exists === false) throw USER_PUBLIC_DATA_NOT_EXISTS;
    const data: any = snapshot.data();

    data["id"] = snapshot.id;
    return data;
  }

  /**
   * Creates public data.
   * This will overwrite all the public data document
   */
  async publicDataCreate(uid: any, context: any) {
    await this.checkAdmin(context);

    await this.publicDoc(uid).set({
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
  }

  /**
   * Updates public data.
   *
   * If public document does not exists, it will create by set merging.
   */
  async publicDataUpdate(data: any, context: any) {
    await this.checkAdmin(context);
    const uid: string = data.uid;
    delete data.uid;
    data.updatedAt = admin.firestore.FieldValue.serverTimestamp();
    await this.publicDoc(uid).set(data, { merge: true });
  }

  /**
   * Deletes a user's public data or multiple user's uid.
   * @param uid a string of uid or string list of multiple uid
   * @param context context
   */
  async publicDataDelete(uid: any, context: any) {
    await this.checkAdmin(context);

    if (typeof uid === "string") {
      await this.publicDoc(uid).delete();
    } else {
      for (const id of uid) {
        await this.publicDoc(id).delete();
      }
    }
  }

  /// Returns true if the uid (of the user) is admin.
  async isAdmin(uid: string): Promise<boolean> {
    if (!uid) throw EMPTY_UID;
    const snapshot = await this.dataDoc(uid).get();
    if (snapshot.exists === false) throw ADMIN_DATA_NOT_EXISTS;
    const data: any = snapshot.data();
    return !!data.isAdmin;
  }

  /// Throws an error if the (requesting) user is not admin.
  async checkAdmin(context: any) {
    if (!context || !context.auth || !context.auth.uid) throw ADMIN_UID_EMPTY;
    const re = await this.isAdmin(context.auth.uid);
    if (re === false) throw YOU_ARE_NOT_ADMIN;
  }
}

export { User };
