# Strava-Automation

This project is a Swift Vapor application that processes new activities from Strava. It uses the Strava API to receive webhooks when a new activity is uploaded to Strava. The application then processes the activity and marks it as commute if it meets certain criteria.

## How it works

- Strava API: The application uses the Strava API to receive webhooks when a new activity is uploaded to Strava. The webhook sends a POST request to the specified URL.
- Swift OpenAPI Generator: The application uses the Swift OpenAPI Generator to generate Swift code from the Strava API. This allows the application to interact with the Strava API in a type-safe manner.
- HTTP Server: The application uses Vapor to create an HTTP server that listens for POST requests from the Strava webhook. The server processes the incoming request and interacts with the database using Fluent.