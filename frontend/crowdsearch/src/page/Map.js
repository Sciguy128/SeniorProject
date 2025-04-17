// src/components/CampusMap.js
import React from 'react';
import { GoogleMap, useLoadScript, Marker, InfoWindow } from '@react-google-maps/api';

const containerStyle = {
  width: '100%',
  height: '500px'
};

const cleanMapStyle = [
    {
      featureType: "all",
      elementType: "labels",
      stylers: [{ visibility: "off" }],
    },
    {
      featureType: "road",
      elementType: "geometry",
      stylers: [{ visibility: "on" }],
    },
    {
        featureType: "poi", // includes buildings
        elementType: "geometry",
        stylers: [{ visibility: "on" }, { color: "#e6e6e6" }],
      },
      {
        featureType: "poi",
        elementType: "labels",
        stylers: [{ visibility: "off" }],
      },
    {
      featureType: "administrative",
      elementType: "geometry",
      stylers: [{ visibility: "on" }],
    },
    {
      featureType: "landscape",
      elementType: "geometry",
      stylers: [{ color: "#f4f4f4" }],
    },
    {
      featureType: "water",
      elementType: "geometry",
      stylers: [{ color: "#c9e6ff" }],
    }
  ];
  

// Center on your campus — replace with actual coordinates
const center = {
  lat: 41.5015, // example: Case Western Reserve University
  lng: -81.6051
};

// Replace with your interesting locations
const pointsOfInterest = [
  { id: 1, name: 'Thwing Center', lat: 41.50742, lng: -81.60842 },
  { id: 2, name: 'Tinkham Veale University Center', lat: 41.50795, lng: -81.60873 },
  { id: 3, name: 'Leutner Commons', lat: 41.51353, lng: -81.60597 },
  { id: 4, name: 'Fribley Commons', lat: 41.50114, lng: -81.60284 },
  { id: 5, name: 'Veale Center', lat: 41.50124, lng: -81.60565 },
];

const CampusMap = () => {
  const { isLoaded } = useLoadScript({
    googleMapsApiKey: 'AIzaSyBOY2jAUqEgeiiTHSkGWhg_DW0bk7Bn_8U', // replace with your actual key
  });

  if (!isLoaded) return <div>Loading...</div>;

  return (
    <GoogleMap
      mapContainerStyle={containerStyle}
      center={center}
      zoom={17}
      options={{
        styles: cleanMapStyle,
        disableDefaultUI: true,     // hides zoom buttons, etc.
        gestureHandling: 'greedy',  // scroll + drag friendly
        clickableIcons: false       // disables POI tooltips
      }}
    >
      {pointsOfInterest.map(point => (
        <Marker
          key={point.id}
          position={{ lat: point.lat, lng: point.lng }}
          label={point.name}
        />
      ))}
    </GoogleMap>
  );
};

export default CampusMap;
