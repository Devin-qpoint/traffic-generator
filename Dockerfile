# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Create a non-root user
RUN useradd -m -s /bin/bash appuser

# Install common dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.10 and pip
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies directly
RUN pip3 install requests==2.26.0 urllib3==1.26.7

# Install Node.js 18.x
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs=18.* \
    && rm -rf /var/lib/apt/lists/*

# Install Go 1.21
RUN wget https://golang.org/dl/go1.21.0.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz \
    && rm go1.21.0.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Install Java 17
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Set up work directory
WORKDIR /app

# Copy the traffic generation scripts
COPY traffic.py traffic.js traffic.go traffic.java ./

# Create package.json inline and install Node.js dependencies
RUN echo '{"name":"traffic-generator","version":"1.0.0","dependencies":{"axios":"^0.21.1"}}' > package.json && \
    npm install

# Compile Go program
RUN go build -o traffic-go traffic.go

# Compile Java program
RUN javac traffic.java

# Change ownership of the application files to the non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Create an entrypoint script with improved debugging
RUN echo '#!/bin/bash\n\
run_python() { echo "Running Python script"; python3 traffic.py & }\n\
run_node() {\n\
    echo "Running Node.js script"\n\
    node --version\n\
    npm --version\n\
    echo "Node.js dependencies:"\n\
    npm list\n\
    echo "Starting traffic.js"\n\
    node traffic.js &\n\
}\n\
run_go() { echo "Running Go program"; ./traffic-go & }\n\
run_java() { echo "Running Java program"; java traffic & }\n\
for arg in "$@"; do\n\
  case $arg in\n\
    --python) run_python ;;\n\
    --node) run_node ;;\n\
    --go) run_go ;;\n\
    --java) run_java ;;\n\
  esac\n\
done\n\
wait' > /app/entrypoint.sh && chmod +x /app/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

# Default command (can be overridden)
CMD ["--python", "--node", "--go", "--java"]
