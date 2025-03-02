import React, {useState} from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import {  createUserWithEmailAndPassword  } from 'firebase/auth';
import { auth } from '../firebase';
import { Container, Card, Form, Button, Alert } from 'react-bootstrap';

const Signup = () => {
    const navigate = useNavigate();

    const [email, setEmail] = useState('')
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');

    const onSubmit = async (e) => {
      e.preventDefault();
      console.log("Sign up botton clicked");

      await createUserWithEmailAndPassword(auth, email, password)
        .then((userCredential) => {
            // Signed in
            const user = userCredential.user;
            console.log("Firebase User Created:", user);

            fetch('/api/users/add', {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    id: user.uid,
                    name: "", 
                    email: user.email
                }),
            })
            .then((res) => res.json())
            .then((data) => {
                console.log("User added to database:", data);
                navigate("/login");
            })
            .catch((error) => console.error("Error adding user to database:", error));
        })
        .catch((error) => {
            const errorCode = error.code;
            const errorMessage = error.message;
            console.log(errorCode, errorMessage);
            // ..
        });


    }

  return (
    <Container className="d-flex justify-content-center align-items-center min-vh-100">
            <Card className="shadow p-4" style={{ width: '400px' }}>
                <Card.Body>
                    <h2 className="text-center mb-4">Sign Up</h2>
                    
                    {error && <Alert variant="danger">{error}</Alert>} {/* Display errors if any */}

                    <Form onSubmit={onSubmit}>
                        <Form.Group className="mb-3">
                            <Form.Label>Email address</Form.Label>
                            <Form.Control
                                type="email"
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                                required
                                placeholder="Enter your email"
                            />
                        </Form.Group>

                        <Form.Group className="mb-3">
                            <Form.Label>Password</Form.Label>
                            <Form.Control
                                type="password"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                required
                                placeholder="Create a password"
                            />
                        </Form.Group>

                        <Button variant="primary" type="submit" className="w-100">
                            Sign Up
                        </Button>
                    </Form>

                    <div className="text-center mt-3">
                        <p>Already have an account? <NavLink to="/login">Sign in</NavLink></p>
                    </div>
                </Card.Body>
            </Card>
        </Container>
    );
};

export default Signup;