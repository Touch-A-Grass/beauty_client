importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js');

const firebaseConfig = {
  apiKey: "AIzaSyCcOFXtLXCkBwUuvSU0G_VUboGniaTYGGs",
  authDomain: "beauty-client-1c87a.firebaseapp.com",
  projectId: "beauty-client-1c87a",
  storageBucket: "beauty-client-1c87a.firebasestorage.app",
  messagingSenderId: "679846823395",
  appId: "1:679846823395:web:f2366677908098c392ccd6",
  measurementId: "G-0V5S8S8FT8"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();