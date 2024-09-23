# Docker Traffic Generator

This Docker image is designed to generate network traffic using multiple programming languages (Python, Node.js, Go, and Java) for testing and demonstration purposes.

## Prerequisites

- Docker installed on your system
- Basic understanding of Docker commands

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

- For Python: `--python`
- For Node.js: `--node`
- For Go: `--go`
- For Java: `--java`

For example, to run only Python and Go generators:

```bash
docker run -it --rm traffic-generator --python --go
```

## Customization

The traffic generation scripts (`traffic.py`, `traffic.js`, `traffic.go`, and `traffic.java`) are copied into the Docker image during build. If you want to modify the endpoints or behavior of these scripts, you'll need to update them and rebuild the Docker image.

