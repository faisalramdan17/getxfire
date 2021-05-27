// require("cors")({ origin: true });
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

import { functionsRegion } from "./config";
import { User } from "./user";
import { FileStorage } from "./file-storage";

const user = new User();
const fileStorage = new FileStorage();

function errdata(data: any, context: any) {
  return {
    request: {
      auth: {
        uid: context.auth.uid,
        email: context.auth.email
      },
      data: data
    }
  };
}

exports.fileDelete = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await fileStorage.delete(data, context);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });

exports.userGet = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await user.getUser(data, context);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });
exports.userCreate = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await user.create(data, context);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });
exports.userDelete = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await user.delete(data, context);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });

exports.userSetAdmin = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await user.setAdmin(data, context);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });

exports.userDataGet = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await user.dataGet(data);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });
exports.userDataCreate = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await user.dataCreate(data, context);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });
exports.userDataUpdate = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await user.dataUpdate(data, context);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });

exports.userDataDelete = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await user.dataDelete(data, context);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });

exports.userPublicDataGet = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await user.publicDataGet(data);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });
exports.userPublicDataCreate = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await user.publicDataCreate(data, context);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });
exports.userPublicDataUpdate = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await user.publicDataUpdate(data, context);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });

exports.userPublicDataDelete = functions
  .region(functionsRegion)
  .https.onCall(async (data, context) => {
    try {
      return await user.publicDataDelete(data, context);
    } catch (error) {
      throw new functions.https.HttpsError(
        "unimplemented",
        error,
        errdata(data, context)
      );
    }
  });
