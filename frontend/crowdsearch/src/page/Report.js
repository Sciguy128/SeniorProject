import React, { useState } from 'react';
import { Container, Form, Button, Card, Alert } from 'react-bootstrap';

const Report = () => {
  const [location, setLocation] = useState('');
  const [crowdLevel, setCrowdLevel] = useState('');
  const [notes, setNotes] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [error, setError] = useState(null);

  const handleSubmit = (e) => {
    e.preventDefault();

    // Simple validation: location and crowd level are required
    if (!location || !crowdLevel) {
      setError('Please fill in all required fields.');
      return;
    }

    const reportData = {
      location,
      crowd_level: crowdLevel,
      notes,
      timestamp: new Date().toISOString(),
    };

    fetch('api/report', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(reportData)
    })
      .then(res => {
        if (!res.ok) {
          throw new Error('Failed to submit report');
        }
        return res.json();
      })
      .then(data => {
        console.log('Report submitted:', data);
        setSubmitted(true);
        setError(null);
      })
      .catch(err => {
        console.error('Error submitting report:', err);
        setError('Submission failed. Please try again later.');
      });
  };

  return (
    <Container className="mt-4">
      <Card className="shadow-sm p-4">
        <Card.Title>Report a Location</Card.Title>
        {submitted ? (
          <Alert variant="success">Thank you for your report!</Alert>
        ) : (
          <Form onSubmit={handleSubmit}>
            <Form.Group className="mb-3" controlId="formLocation">
              <Form.Label>Location</Form.Label>
              <Form.Control
                type="text"
                placeholder="Enter location name"
                value={location}
                onChange={(e) => setLocation(e.target.value)}
              />
            </Form.Group>

            <Form.Group className="mb-3" controlId="formCrowdLevel">
              <Form.Label>Crowd Level</Form.Label>
              <Form.Control
                type="number"
                placeholder="Enter crowd level"
                value={crowdLevel}
                onChange={(e) => setCrowdLevel(e.target.value)}
              />
            </Form.Group>

            <Form.Group className="mb-3" controlId="formNotes">
              <Form.Label>Additional Notes (optional)</Form.Label>
              <Form.Control
                as="textarea"
                rows={3}
                placeholder="Enter any additional details"
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
              />
            </Form.Group>

            {error && <Alert variant="danger">{error}</Alert>}

            <Button variant="primary" type="submit">
              Submit Report
            </Button>
          </Form>
        )}
      </Card>
    </Container>
  );
};

export default Report;
