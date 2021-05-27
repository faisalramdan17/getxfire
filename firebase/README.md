# fireflutter-firebase

## Installation

- First, install [Firebase Tools](https://www.npmjs.com/package/firebase-tools).

- Then, clone fireflutter-firebase

```sh
git clone https://github.com/thruthesky/fireflutter-firebase
```

- Install node modules for firestore rules and indexes which works in root folder.

```sh
cd fireflutter-firebase
npm i
```

- Install node modules for cloud functions which works in functions folder.

```
cd functions
npm i
```

## Test

- To test, run the Functions emulator

```sh
firebase emulators:start --only functions
```

- Then run the test,
  - Get `firebase-service-account-key.json` and save it under root folder(the same folder where .firebaserc resides). Note that `Service Admin Key` is only needed for testing(at this time). Do not expose it to public.

```sh
cd functions
npm run test:in-app-purchase
```

## Deploy
