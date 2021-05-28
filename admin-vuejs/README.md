# Firebase Admin

- This project is for managing for `thefire project` But it can be used for serving the clients(members) of the app by customizing(designing) the front.

- Cloud functions in fireflutter-firebase should be deployed to manage user accounts. Managing user accounts like creating/deleting is not allowed directly from frontend.

# Project Installation, Serving, Deployment

## Get flutter-admin project

```
git clone https://github.com/thruthesky/fireflutter-admin
cd fireflutter-admin
npm i
npm run serve
```

## Deploye fireflutter-firebase functions

```
git clone https://github.com/thruthesky/fireflutter-firebase
cd fireflutter-firebase
npm i
cd functions
npm i
firebase deploy --only functions
```

## Project setup

```
npm install
```

### Compiles and hot-reloads for development

```
npm run serve
```

### Compiles and minifies for production

```
npm run build
```

### Run your unit tests

```
npm run test:unit
```

### Run your end-to-end tests

```
npm run test:e2e
```

### Lints and fixes files

```
npm run lint
```

## Deployment

- You can build and deploy anywhere you want.
  - `npm run build`
  - Copy public folder to web server home folder.

### Firebase Hosting

To deploy fireflutter-admin to firebase, follow the instructions below.

- Edit firebase project id

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
