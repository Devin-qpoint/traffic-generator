package main

import (
	"crypto/tls"
	"fmt"
	"math/rand"
	"net/http"
	"time"
)

var endpoints = []string{
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
	"https://api.mailgun.net/v3/domains", // bad domain
}

func callEndpoint(url string, client *http.Client) bool {
	start := time.Now()
	resp, err := client.Get(url)
	if err != nil {
		fmt.Printf("Error calling %s: %v\n", url, err)
		return false
	}
	defer resp.Body.Close()
	duration := time.Since(start)
	fmt.Printf("Called %s - Status: %d - Time: %.2fs\n", url, resp.StatusCode, duration.Seconds())
	return true
}

func main() {
	successfulCalls := 0
	totalCalls := 0

	// Create a custom HTTP client that ignores SSL certificate errors
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	}
	client := &http.Client{
		Transport: tr,
		Timeout:   10 * time.Second,
	}

	fmt.Println("Starting to call endpoints at random intervals. Press Ctrl+C to stop.")

	for {
		endpoint := endpoints[rand.Intn(len(endpoints))]
		if callEndpoint(endpoint, client) {
			successfulCalls++
		}
		totalCalls++

		// Sleep for a random interval between 1 and 5 seconds
		time.Sleep(time.Duration(rand.Float64()*4000+1000) * time.Millisecond)
	}
}
