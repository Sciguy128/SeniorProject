import React from "react";
import { GoogleMap, LoadScript, Marker } from "@react-google-maps/api";

const apiKey = "AIzaSyBOY2jAUqEgeiiTHSkGWhg_DW0bk7Bn_8U"; // Replace with your actual API key

const Map = () => {
  const mapContainerStyle = { width: "100vw", height: "100vh" };
  const center = { lat: 37.7749, lng: -122.4194 }; // Example: San Francisco

  return (
    <LoadScript googleMapsApiKey={apiKey}>
    <GoogleMap mapContainerStyle={{ width: "100vw", height: "100vh" }} center={{ lat: 41.5034, lng: -81.6084  }} zoom={14.5} />
  </LoadScript>
  );
};
export default Map;

