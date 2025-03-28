import React, { useState, useEffect } from 'react';
import { onAuthStateChanged, signOut } from "firebase/auth";
import { auth } from '../firebase';
import { useNavigate } from 'react-router-dom';
import { Container, Navbar, Button, Card, Spinner, Modal } from 'react-bootstrap';
import Report from './Report'; 

const Home = () => {

    const [user, setUser] = useState(null);
    const navigate = useNavigate();
    const [currentTime, setCurrentTime] = useState(0);
    const [locations, setLocations] = useState([]);
    const [showLocationModal, setShowLocationModal] = useState(false);
    const [latitude, setLatitude] = useState(null);
    const [longitude, setLongitude] = useState(null);


    useEffect(() => {
        const fetchCrowds = () => {
            fetch('api/crowds')
                .then(res => res.json())
                .then(data => {
                    setLocations(data)
                    console.log("Crowd Levels:", data)
                })
        }

        fetchCrowds(); 

        const intervalId = setInterval(fetchCrowds, 10000);

        return () => clearInterval(intervalId);
    }, [])

    useEffect(() => {
        const fetchTime = () => {
            fetch('api/time')
              .then(res => res.json())
              .then(data => {
                const unixTimestamp = data.time;
                const date = new Date(unixTimestamp * 1000); // convert to milliseconds
                const formattedTime = date.toLocaleString("en-US", {
                    weekday: "short",
                    year: "numeric",
                    month: "short",
                    day: "numeric",
                    hour: "2-digit",
                    minute: "2-digit",
                    second: "2-digit",
                    });
                setCurrentTime(formattedTime);
              });
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
              setShowLocationModal(true);
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
                setLatitude(null);
                setLongitude(null);
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

    const handleGetLocation = () => {
        if ("geolocation" in navigator) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    setLatitude(position.coords.latitude.toFixed(6));
                    setLongitude(position.coords.longitude.toFixed(6));
                    setShowLocationModal(false); // close modal
                    console.log("Location obtained:", position.coords.latitude, position.coords.longitude);
                },
                (error) => {
                    console.error("Error getting location:", error.message);
                    setShowLocationModal(false); // close modal even if denied
                }
            );
        } else {
            alert("Geolocation is not supported by your browser.");
            setShowLocationModal(false);
        }
    };

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

                {latitude && longitude && (
                    <Card className="shadow-sm p-3 mb-4 bg-light rounded" style={{ maxWidth: "400px", margin: "auto" }}>
                        <Card.Body>
                        <Card.Title>Your Current Location</Card.Title>
                        <Card.Text>Latitude: {latitude}</Card.Text>
                        <Card.Text>Longitude: {longitude}</Card.Text>
                        </Card.Body>
                    </Card>
                    )}

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
                                <h5 className="mb-3">Logged in as: <span className="text-primary">{user.displayName}</span></h5>
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

                {user && (
                    <>
                        {/* Display Locations & Crowd Levels */}
                        <Card className="shadow-sm p-3 mb-4 bg-light rounded" style={{ maxWidth: "400px", margin: "auto" }}>
                            <Card.Body>
                                <Card.Title>Location Crowd Levels</Card.Title>
                                {locations.length === 0 ? (
                                    <Spinner animation="border" />
                                ) : (
                                    <ul className="list-group">
                                        {locations.map((location, index) => {
                                            return (
                                            <li key={index} className="list-group-item d-flex justify-content-between align-items-center">
                                                <strong>{location.name}</strong>
                                                <span>{location.crowd_level}</span>
                                            </li>
                                            );
                                        })}
                                    </ul>
                                )}
                            </Card.Body>
                        </Card>
                    </>
                )}

                <Modal show={showLocationModal} onHide={() => setShowLocationModal(false)} centered>
                <Modal.Header closeButton>
                    <Modal.Title>Share Your Location</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    We'd like to access your location to improve map features and show crowd levels near you.
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={() => setShowLocationModal(false)}>
                    No, thanks
                    </Button>
                    <Button variant="primary" onClick={handleGetLocation}>
                    Share Location
                    </Button>
                </Modal.Footer>
                </Modal>
            </Container>
        </>
    )

}

export default Home
