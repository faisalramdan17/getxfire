# fireflutter-firebase

<p align="center">
    <a title="Buy me a coffee" href="https://www.buymeacoffee.com/faisalramdan17">
        <img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=faisalramdan17&button_colour=FF5F5F&font_colour=ffffff&font_family=Lato&outline_colour=000000&coffee_colour=FFDD00">
    </a>
</p> 

## Installation

- First, install [Firebase Tools](https://www.npmjs.com/package/firebase-tools).

- Then, clone firebase

```sh
git clone https://github.com/faisalramdan17/getxfire; cd getxfire;git sparse-checkout set firebase; cd firebase
```

- Install node modules for firestore rules and indexes which works in root folder.

```sh
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
