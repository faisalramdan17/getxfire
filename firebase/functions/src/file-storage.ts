import * as admin from "firebase-admin";
import { User } from "./user";

const user = new User();

const bucket = admin.storage().bucket();

class FileStorage {
  async delete(data: any, context: any) {
    await user.checkAdmin(context);
    await bucket.file(data).delete();
  }
}
export { FileStorage };
