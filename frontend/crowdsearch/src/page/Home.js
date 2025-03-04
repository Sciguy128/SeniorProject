import React, { useState, useEffect } from 'react';
import { onAuthStateChanged, signOut } from "firebase/auth";
import { auth } from '../firebase';
import { useNavigate } from 'react-router-dom';
import { Container, Navbar, Button, Card, Spinner } from 'react-bootstrap';
import Report from './Report'; 

const Home = () => {

    const [user, setUser] = useState(null);
    const navigate = useNavigate();
    const [currentTime, setCurrentTime] = useState(0);

    useEffect(() => {
        const fetchTime = () => {
            fetch('api/time')
              .then(res => res.json())
              .then(data => setCurrentTime(data.time))
        };

        fetchTime();

        const intervalId = setInterval(fetchTime, 10000);

        return () => clearInterval(intervalId);

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
            {/* Navbar */}
            <Navbar bg="dark" variant="dark" className="mb-4 px-3">
                <Navbar.Brand>CrowdSearch</Navbar.Brand>
                {user && <Button variant="outline-light" onClick={handleLogout}>Logout</Button>}
            </Navbar>

            {/* Main Content */}
            <Container className="text-center">
                <h1 className="mb-4">Welcome Home</h1>

                {/* Decorative Time Display */}
                <Card className="shadow-sm p-3 mb-4 bg-light rounded" style={{ maxWidth: "400px", margin: "auto" }}>
                    <Card.Body>
                        <Card.Title>Current Time</Card.Title>
                        {currentTime === 0 ? <Spinner animation="border" /> : <Card.Text className="fs-4">{currentTime}</Card.Text>}
                    </Card.Body>
                </Card>

                {/* User Authentication Section */}
                <Card className="shadow p-3 bg-white rounded" style={{ maxWidth: "500px", margin: "auto" }}>
                    <Card.Body>
                        {user ? (
                            <>
                                <h5 className="mb-3">Logged in as: <span className="text-primary">{user.email}</span></h5>
                                <Button variant="danger" onClick={handleLogout}>Logout</Button>
                                <Report></Report>
                            </>
                        ) : (
                            <>
                                <h5 className="mb-3">No user is currently logged in.</h5>
                                <Button variant="primary" className="me-2" onClick={() => navigate("/signup")}>Go to Signup</Button>
                                <Button variant="secondary" onClick={() => navigate("/login")}>Go to Login</Button>
                            </>
                        )}
                    </Card.Body>
                </Card>
            </Container>
        </>
    )

}

export default Home
