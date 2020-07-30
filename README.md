## About

A simple Shop app using Flutter and Dart for iOS, Android and web. The app uses Firebase Authentication and Database for the backend.

Hosted web example here: http://shop-app-flutter.s3-website.ca-central-1.amazonaws.com

## Functionality

- Basic authentication -> signup, login, logout
- Add products that can be ordered through the store
- Mark products as favorite
- Add products to cart
- Order products in cart
- View all previous orders

## Install and Setup

You will need Flutter installed, along with a number of dependencies for building and running iOS and Android apps on simulators. You can find the install instructions here: https://flutter.dev/docs/get-started/install

To run with web, follow the instructions here: https://flutter.dev/docs/get-started/web

## Setup

This implementation uses Firebase Authentication and Database. You will need to do set these up, in order for the app to work for you.

- Set up a new project in Firebase:

  - Get the the Web API Key from Settings (YOUR_FIREBASE_WEB_API_KEY)

- Set up the Database:

  - Go to Develop -> Database
  - Add a database
  - Copy the DB URL (YOUR_FIREBASE_DB_URL)
    - Example: https://my-app-e7a11.firebaseio.com/
  - Set up the Rules:
    {
    "rules": {
    ".read": "auth != null",
    ".write": "auth != null",
    "products": {
    ".indexOn": ["creatorId"]
    }
    }
    }

- Authentication
  - Go to Develop -> Authentication
  - In Sign-in method tab, and enable Email/Password Provider

## Run

Run on a device (once it is connected):

    $ flutter run --dart-define=FIREBASE_API_KEY=[YOUR_FIREBASE_WEB_API_KEY] --dart-define=FIREBASE_DB_URL=[YOUR_FIREBASE_DB_URL]

Run on a web browser (if you have installed support for running on web):

    $ flutter run -d chrome --dart-define=FIREBASE_API_KEY=[YOUR_FIREBASE_WEB_API_KEY] --dart-define=FIREBASE_DB_URL=[YOUR_FIREBASE_DB_URL]

## TODO

- Test cases
