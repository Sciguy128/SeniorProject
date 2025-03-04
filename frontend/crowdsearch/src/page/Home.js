import React, { useState, useEffect } from 'react';
import { onAuthStateChanged, signOut } from "firebase/auth";
import { auth } from '../firebase';
import { useNavigate } from 'react-router-dom';
import { Container, Navbar, Button, Card, Spinner } from 'react-bootstrap';

const Home = () => {

    const [user, setUser] = useState(null);
    const [locations, setLocations] = useState([])
    const navigate = useNavigate();
    const [currentTime, setCurrentTime] = useState(0);
    const [error, setError] = useState(null);

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
              .then(data => setCurrentTime(data.time))
        };

        fetchTime();

        const intervalId = setInterval(fetchTime, 10000);

        return () => clearInterval(intervalId);

      }, []);

    useEffect(()=>{
        onAuthStateChanged(auth, (user) => {
            if (user) {
              const uid = user.uid;
              console.log("uid", uid)
            } else {
              console.log("user is logged out")
            }
          });

    }, [])

    useEffect(() => {
        const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
            if (currentUser) {
                setUser(currentUser);
                console.log("User logged in:", currentUser);
            } else {
                setUser(null);
                console.log("User is logged out");
            }
        });

        return () => unsubscribe();
    }, []);

    const handleLogout = () => {               
        signOut(auth).then(() => {
            navigate("/");
            console.log("Signed out successfully")
        }).catch((error) => {
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
            <Navbar bg="dark" variant="dark" className="mb-4 px-3">
                <Navbar.Brand>CrowdSearch</Navbar.Brand>
                {user && <Button variant="outline-light" onClick={handleLogout}>Logout</Button>}
            </Navbar>

            <Container className="text-center">
                <h1 className="mb-4">Welcome Home</h1>

                <Card className="shadow-sm p-3 mb-4 bg-light rounded" style={{ maxWidth: "400px", margin: "auto" }}>
                    <Card.Body>
                        <Card.Title>Current Time</Card.Title>
                        {currentTime === 0 ? <Spinner animation="border" /> : <Card.Text className="fs-4">{currentTime}</Card.Text>}
                    </Card.Body>
                </Card>

                <Card className="shadow p-3 bg-white rounded" style={{ maxWidth: "500px", margin: "auto" }}>
                    <Card.Body>
                        {user ? (
                            <>
                                <h5 className="mb-3">Logged in as: <span className="text-primary">{user.email}</span></h5>
                                <Button variant="danger" onClick={handleLogout}>Logout</Button>
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

                <Card className="shadow-sm p-3 mb-4 bg-light rounded" style={{ maxWidth: "400px", margin: "auto" }}>
                    <Card.Body>
                        <Card.Title>Campus Map</Card.Title>
                        <Button variant="primary" className="me-2" onClick={() => navigate("/map")}>Go to Map</Button>
                    </Card.Body>
                </Card>

                {user && location.pathname === "/" && (
                    <>
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
            </Container>
        </>
    )

}

export default Home

