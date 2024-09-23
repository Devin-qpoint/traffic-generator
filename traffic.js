const axios = require('axios');
const https = require('https');

// Disable SSL certificate verification (not recommended for production)
const agent = new https.Agent({
  rejectUnauthorized: false
});

const endpoints = [
  "https://api.aiven.io/v1/service_types",
  "https://api.apigee.com/v1/organizations",
  "https://api.bitbucket.org/2.0/repositories",
  "https://api.github.com/rate_limit",
  "https://api.github.com/repos/octocat/hello-world/actions/workflows",
  "https://api.openstack.org/",
  "https://api.pingidentity.com/v1/environments",
  "https://api.swaggerhub.com/apis",
  "https://api.thousandeyes.com/v6/status",
  "https://gitlab.com/api/v4/projects",
  "https://hub.docker.com/v2/repositories/library/ubuntu",
  "https://synthetics.newrelic.com/synthetics/api/v3/monitors",
  "https://api.mailgun.net/v3/domains" // bad domain
];

async function callEndpoint(url) {
  try {
    const startTime = Date.now();
    const response = await axios.get(url, { httpsAgent: agent, timeout: 10000 });
    const duration = (Date.now() - startTime) / 1000;
    console.log(`Called ${url} - Status: ${response.status} - Time: ${duration.toFixed(2)}s`);
    return true;
  } catch (error) {
    console.error(`Error calling ${url}: ${error.message}`);
    return false;
  }
}

async function main() {
  let successfulCalls = 0;
  let totalCalls = 0;

  console.log("Starting to call endpoints at random intervals. Press Ctrl+C to stop.");

  while (true) {
    const endpoint = endpoints[Math.floor(Math.random() * endpoints.length)];
    if (await callEndpoint(endpoint)) {
      successfulCalls++;
    }
    totalCalls++;

    // Sleep for a random interval between 1 and 5 seconds
    await new Promise(resolve => setTimeout(resolve, Math.random() * 4000 + 1000));
  }
}

main().catch(error => {
  console.error("An error occurred:", error);
  process.exit(1);
});
