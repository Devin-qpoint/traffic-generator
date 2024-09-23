# Docker Traffic Generator

This Docker image is designed to generate network traffic using multiple programming languages (Python, Node.js, Go, and Java) for testing and demonstration purposes. It's particularly useful for simulating diverse application traffic patterns, testing egress filtering, and evaluating network monitoring systems.

## Prerequisites

* Docker installed on your system
* Basic understanding of Docker commands

## Building the Docker Image

To build the Docker image, navigate to the directory containing the Dockerfile and run:

```bash
docker build -t traffic-generator .
```

This command builds the Docker image and tags it as `traffic-generator`.

## Running the Container

You can run the container with different combinations of traffic generators. By default, it runs all four (Python, Node.js, Go, and Java).

### Run all traffic generators:

```bash
docker run -it --rm traffic-generator
```

### Run specific traffic generators:

You can specify which generators to run by passing arguments:

* For Python: `--python`
* For Node.js: `--node`
* For Go: `--go`
* For Java: `--java`

For example, to run only Python and Go generators:

```bash
docker run -it --rm traffic-generator --python --go
```

## Supported Languages and Versions

The Docker image includes the following languages and versions:

- Python 3.10
- Node.js 18.x
- Go 1.21
- Java 17

Each language has its own script to generate traffic, allowing for diverse traffic patterns.

## Authentication

The traffic generator includes authentication for specific endpoints. Currently, it provides authentication for:

- Mailgun API (api.mailgun.net): Uses a Bearer token for authentication.

The authentication details are included in the respective scripts and can be customized as needed.

## Docker Image Details

The Docker image is built on Ubuntu 22.04 and includes:

- Common dependencies (curl, wget, git, build-essential)
- Language-specific installations (Python, Node.js, Go, Java)
- A non-root user for improved security
- Pre-installed language dependencies (e.g., Python packages, Node.js modules)
- Compiled versions of Go and Java programs
- An entrypoint script to manage the execution of traffic generation scripts

## Customization

The traffic generation scripts (`traffic.py`, `traffic.js`, `traffic.go`, and `traffic.java`) are copied into the Docker image during build. If you want to modify the endpoints or behavior of these scripts, you'll need to update them and rebuild the Docker image.

To customize:

1. Modify the desired script(s) in the project directory.
2. Rebuild the Docker image using the command provided in the "Building the Docker Image" section.
3. Run the new container with your customized traffic generation.

## Output

When running, each script will output its activities, including:

- The URL called
- The HTTP status code received
- The time taken for the request

This output helps in monitoring and verifying the traffic generation process.

---

For any additional questions or support, please refer to the project repository or contact the hello@qpoint.io
