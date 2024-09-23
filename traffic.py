import requests
import time
import random
import uuid
from urllib3.exceptions import InsecureRequestWarning

# Suppress only the single warning from urllib3 needed.
requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)

# List of endpoints that returned 200 OK
endpoints = [
    "https://api.aiven.io/v1/service_types",
    "https://api.apigee.com/v1/organizations",
    "https://api.bitbucket.org/2.0/repositories",
    "https://api.github.com/rate_limit",
    "https://api.github.com/rate_limit",
    "https://api.github.com/rate_limit",
    "https://api.github.com/repos/octocat/hello-world/actions/workflows",
    "https://api.openstack.org/",
    "https://api.pingidentity.com/v1/environments",
    "https://api.swaggerhub.com/apis",
    "https://api.thousandeyes.com/v6/status",
    "https://gitlab.com/api/v4/projects",
    "https://hub.docker.com/v2/repositories/library/ubuntu",
    "https://synthetics.newrelic.com/synthetics/api/v3/monitors",
    "https://api.mailgun.net/v3/domains" # bad domain
]

# Dummy auth data for Mailgun
mailgun_auth = {
    "api_key": "dummy_mailgun_api_key_12345",
}

def get_dummy_headers(url):
    headers = {"X-Request-ID": str(uuid.uuid4())}
    if "api.mailgun.net" in url:
        headers["Authorization"] = f"Bearer {mailgun_auth['api_key']}"
    return headers

def call_endpoint(url):
    try:
        headers = get_dummy_headers(url)
        response = requests.get(url, headers=headers, timeout=10, verify=False)
        print(f"Called {url} - Status: {response.status_code} - Time: {response.elapsed.total_seconds():.2f}s")
        print(f"Request ID: {headers['X-Request-ID']}")
        return True
    except requests.RequestException as e:
        print(f"Error calling {url}: {str(e)}")
        return False

def main():
    successful_calls = 0
    total_calls = 0

    print("Starting to call endpoints at random intervals. Press Ctrl+C to stop.")

    try:
        while True:
            endpoint = random.choice(endpoints)
            if call_endpoint(endpoint):
                successful_calls += 1
            total_calls += 1

            # Sleep for a random interval between 1 and 5 seconds
            sleep_time = random.uniform(1, 5)
            time.sleep(sleep_time)

    except KeyboardInterrupt:
        print("\nScript stopped by user.")
    finally:
        print(f"\nTotal calls made: {total_calls}")
        print(f"Successful calls: {successful_calls}")
        print(f"Success rate: {successful_calls/total_calls*100:.2f}%")

if __name__ == "__main__":
    main()
