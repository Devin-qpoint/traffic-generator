import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

public class traffic {
    private static final List<String> ENDPOINTS = Arrays.asList(
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
    );

    private static boolean callEndpoint(String url) {
        try {
            long startTime = System.currentTimeMillis();
            URL obj = new URL(url);
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();
            con.setRequestMethod("GET");
            int responseCode = con.getResponseCode();
            long duration = System.currentTimeMillis() - startTime;
            System.out.printf("Called %s - Status: %d - Time: %.2fs%n", url, responseCode, duration / 1000.0);
            return true;
        } catch (Exception e) {
            System.err.printf("Error calling %s: %s%n", url, e.getMessage());
            return false;
        }
    }

    public static void main(String[] args) {
        int successfulCalls = 0;
        int totalCalls = 0;
        Random random = new Random();

        System.out.println("Starting to call endpoints at random intervals. Press Ctrl+C to stop.");

        while (true) {
            String endpoint = ENDPOINTS.get(random.nextInt(ENDPOINTS.size()));
            if (callEndpoint(endpoint)) {
                successfulCalls++;
            }
            totalCalls++;

            try {
                Thread.sleep(random.nextInt(4000) + 1000);
            } catch (InterruptedException e) {
                break;
            }
        }
    }
}
