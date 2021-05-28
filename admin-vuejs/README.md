# Firebase Admin

<p align="center">
    <a title="Buy me a coffee" href="https://www.buymeacoffee.com/faisalramdan17">
        <img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=faisalramdan17&button_colour=FF5F5F&font_colour=ffffff&font_family=Lato&outline_colour=000000&coffee_colour=FFDD00">
    </a>
</p> 

- This project is for managing for `getxfire project` But it can be used for serving the clients(members) of the app by customizing(designing) the front.

- Cloud functions in getxfire-firebase should be deployed to manage user accounts. Managing user accounts like creating/deleting is not allowed directly from frontend.

# Project Installation, Serving, Deployment

## Get flutter-admin project

```sh
git clone https://github.com/faisalramdan17/getxfire; cd getxfire;git sparse-checkout set admin-vuejs; cd admin-vuejs
```
```sh
npm i
npm run serve
```

## Project setup

```sh
npm install
```

### Compiles and hot-reloads for development

```sh
npm run serve
```

### Compiles and minifies for production

```sh
npm run build
```

### Run your unit tests

```sh
npm run test:unit
```

### Run your end-to-end tests

```sh
npm run test:e2e
```

### Lints and fixes files

```sh
npm run lint
```

## Deployment

- You can build and deploy anywhere you want.
  - `npm run build`
  - Copy public folder to web server home folder.

### Firebase Hosting

## Deploye getxfire-firebase functions

```sh
git clone https://github.com/faisalramdan17/getxfire; cd getxfire;git sparse-checkout set firebase; cd firebase
```
```sh
cd getxfire
cd firebase
npm i
cd functions
npm i

```

To deploy getxfire-admin to firebase, follow the instructions below.

- Edit firebase project id at `.firebaserc` file

```json
{
  "projects": {
    "default": "... Input your project id here ..."
  }
}
```

- And run the following

```sh
firebase use [project-id]
```

- Then run

```sh
firebase deploy --only hosting
```

# Developer Coding Guideline

## App configuration

## Fire Project Settings

## User management

- This explains how to create a user account and delete it.

```js
/// Login as admin
try {
  const userCreate = await firebase
    .app()
    .functions("asia-northeast3")
    .httpsCallable("userCreate");
  const re = await userCreate({
    email: "create1@test.com",
    password: "12345a,*",
    phoneNumber: "+10123456701",
    displayName: "User V",
    photoURL: "http://www.example.com/12345678/photo.png",
    disabled: false
  });
  const user = re.data;
  console.log(user);
  try {
    const userDelete = await firebase
      .app()
      .functions("asia-northeast3")
      .httpsCallable("userDelete");
    await userDelete(user.uid);
  } catch (e) {
    const code = e.code;
    const message = e.message;
    const details = e.details;
    console.log(code, message, details);
  }
} catch (e) {
  const code = e.code;
  const message = e.message;
  const details = e.details;
  console.log(code, message, details);
}
```

# Trouble Shooting

```
Status Code: 500
Referrer Policy: strict-origin-when-cross-origin
```
