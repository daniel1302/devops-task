# Ansible Deployment for `web-api`

This Ansible setup is designed to deploy the `web-api` application using Docker Compose with Docker Swarm for orchestration. It is organized into inventories, playbooks, and roles to ensure modularity and reusability.

---

## Components

### 1. **Inventories**
   - **Description**: Contains inventory files with server details, including host variables and parameters needed for deployment.
   - **Purpose**: Centralized management of server information and configuration variables for different environments.

### 2. **Playbooks**
   - **Description**: Contains playbooks to handle various use cases and deployment scenarios.
   - **Purpose**: Defines specific tasks and sequences to execute, leveraging roles and inventory variables.

### 3. **Roles**
   - **Description**: Modular roles that encapsulate specific functionality for the deployment process.
   - **Purpose**: Ensure reusable and maintainable task definitions for common operations.


---

## Roles

### 1. **`docker`**
   - **Description**: Installs Docker on the target servers and initialize swarm server
   - **Parameters**:
     Refer to `roles/docker/defaults/main.yaml` for detailed configuration options.

### 2. **`zfs_volume`**
   - **Description**: Sets up ZFS and prepares the ZFS volume required for the deployment.
   - **Parameters**:
     Refer to `roles/zfs_volume/defaults/main.yaml` for detailed configuration options.

### 3. **`web-api`**
   - **Description**: Deploys the `web-api` application stack using Docker Compose and Docker Swarm.
   - **Features**:
     - Deploys the `web-api` stack defined in Docker Compose.
     - Configures service scaling and stack parameters.
   - **Parameters**:
     Refer to `roles/web-api/defaults/main.yaml` for detailed configuration options.

---

## Workflow

1. **Prepare Inventories**:
   - Update the inventory files with the server details and required variables.
   - Define environment-specific parameters as needed.

2. **Execute Playbooks**:
   - `ansible-playbook ./playbooks/web-api.yaml`


---

## Notes

- Ensure that the ZFS volume is configured properly before deploying the `web-api` application.
- Docker Swarm is utilized for orchestration, enabling scalability and fault tolerance.
- Refer to the `defaults/main.yaml` file within each role for additional parameters and customization options.
