// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries
// Your web app's Firebase configuration

const firebaseConfig = {
    apiKey: "AIzaSyCmGTxwi4U7Y2KgZsde4ZgtN3vvVxCd8rs",
    authDomain: "testing-60e88.firebaseapp.com",
    projectId: "testing-60e88",
    storageBucket: "testing-60e88.firebasestorage.app",
    messagingSenderId: "1055324128496",
    appId: "1:1055324128496:web:2d393f775774ed98cb2e35"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase Authentication and get a reference to the service
export const auth = getAuth(app);
export default app;