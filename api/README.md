# Dummy API

This repository contains a dummy API designed to test Ansible deployment workflows. It provides basic functionality with SQLite as the backend storage and exposes a few endpoints for demonstration purposes.

## Purpose

The purpose of this API is to serve as a placeholder for deploying and managing containerized applications using Ansible. It is not intended for production use.

## Features

- SQLite database backend for storage.
- Basic RESTful endpoints.
- Simple health check and environment inspection endpoints.

## API Endpoints

### 1. **GET: `/environment`**
   - **Description**: Returns important environment variables.
   - **Response**: List containing the current environment variables.

### 2. **GET: `/healtz`**
   - **Description**: A basic health check endpoint.
   - **Response**: A status indicating the API is running (e.g., `OK` and corresponding HTTP code).

### 3. **GET: `/count`**
   - **Description**: Returns a list of all resources stored in the database.
   - **Response**: List of numeric values stored in the database.

### 4. **POST: `/count/{num}`**
   - **Description**: Adds a single entry to the database.
   - **Path Parameter**:
     - `num` (numeric): The value to add to the database.
   - **Response**: A confirmation message.

### 5. **DELETE: `/count/{num}`**
   - **Description**: Deletes a single entry from the database.
   - **Path Parameter**:
     - `num` (numeric): The value to remove from the database.
   - **Response**: A confirmation message.

## Notes

- This API is a dummy implementation and is not optimized for performance or security.
- This project is intended for testing purposes only.

## Example Requests

### Adding an Entry

```bash
curl -X POST http://<api-url>/count/42
```

### Deleting an Entry

```bash
curl -X DELETE http://<api-url>/count/42
```

### Fetching All Entries

```bash
curl http://<api-url>/count
```