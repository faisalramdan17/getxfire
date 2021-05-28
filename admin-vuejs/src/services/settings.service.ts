import firebase from "firebase/app";
import "firebase/firestore";

export class Settings {
  private static _init = false;
  private static get settingsCol() {
    return firebase.firestore().collection("settings");
  }
  private static _settings: any = {};

  static get(field: string): string {
    return this._settings[field];
  }

  /**
   * Intialize the FireFlutter settings.
   */
  static init() {
    if (this._init) return true;
    this._init = true;

    console.log("Settings init");

    this.settingsCol.onSnapshot(querySnapshot => {
      querySnapshot.forEach(doc => {
        this._settings = doc.data();
      });
    });
  }
}
