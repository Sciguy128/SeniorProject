import React, { useState, useEffect } from 'react';
import { onAuthStateChanged, signOut } from "firebase/auth";
import { auth } from '../firebase';
import { useNavigate } from 'react-router-dom';

const Home = () => {

    const [user, setUser] = useState(null);
    const navigate = useNavigate();
    const [currentTime, setCurrentTime] = useState(0);

    useEffect(() => {
        fetch('api/time').then(res => res.json()).then(data => {
          setCurrentTime(data.time);
        });
      }, []);

    useEffect(()=>{
        onAuthStateChanged(auth, (user) => {
            if (user) {
              // User is signed in, see docs for a list of available properties
              // https://firebase.google.com/docs/reference/js/firebase.User
              const uid = user.uid;
              // ...
              console.log("uid", uid)
            } else {
              // User is signed out
              // ...
              console.log("user is logged out")
            }
          });

    }, [])

    useEffect(() => {
        const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
            if (currentUser) {
                setUser(currentUser); // Set the user when logged in
                console.log("User logged in:", currentUser);
            } else {
                setUser(null); // Clear user when logged out
                console.log("User is logged out");
            }
        });

        // Cleanup the subscription when the component unmounts
        return () => unsubscribe();
    }, []);

    const handleLogout = () => {               
        signOut(auth).then(() => {
        // Sign-out successful.
            navigate("/");
            console.log("Signed out successfully")
        }).catch((error) => {
        // An error happened.
        });
    }

    const goToSignup = () => {
        navigate("/signup");
    }

    const goToLogin = () => {
        navigate("/login");
    }

    return(
        <>
            <nav>
                <p>
                    Welcome Home
                </p>
                <p>The current time is {currentTime}.</p>

                <div>
                {user ? (
                    <>
                        <p>Logged in as: {user.email}</p>
                        <button onClick={handleLogout}>Logout</button>
                    </>
                ) : (
                    <>
                    <p>No user is currently logged in.</p>
                    <button onClick={goToSignup}>Go to Signup</button>
                    <button onClick={goToLogin}>Go to Login</button>
                    </>
                )}
                </div>
            </nav>
        </>
    )

}

export default Home
