package com.security.pingger;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import java.io.BufferedReader;
import java.io.InputStreamReader;

@Controller
public class PingController {

    @GetMapping("/")
    public String index() {
        System.out.println("DEBUG: GET / endpoint called");
        return "index";
    }

    @PostMapping("/ping")
    @ResponseBody
    public String ping(@RequestParam("target") String target) {
        System.out.println("DEBUG: POST /ping endpoint called");
        System.out.println("DEBUG: Target parameter: " + target);

        try {
            // VULNERABILITY: Direct command construction without sanitization
            String cmd = "ping -c 4"; // Add count parameter to limit pings
            String command = cmd + " " + target;
            System.out.println("DEBUG: Executing command: " + command);

            // Execute the command with timeout
            Process process = Runtime.getRuntime().exec(new String[]{"sh", "-c", command});

            StringBuilder output = new StringBuilder();
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));

            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }

            // Also capture error output
            while ((line = errorReader.readLine()) != null) {
                output.append("ERROR: ").append(line).append("\n");
            }

            // Wait for process to complete (with timeout)
            boolean finished = process.waitFor(10, java.util.concurrent.TimeUnit.SECONDS);
            if (!finished) {
                process.destroyForcibly();
                return "Command timed out after 10 seconds";
            }

            reader.close();
            errorReader.close();

            String result = output.toString();
            System.out.println("DEBUG: Command output: " + result);
            return result.isEmpty() ? "No output received" : result;

        } catch (Exception e) {
            String error = "Error executing ping: " + e.getMessage();
            System.out.println("DEBUG: Exception occurred: " + error);
            e.printStackTrace();
            return error;
        }
    }
}