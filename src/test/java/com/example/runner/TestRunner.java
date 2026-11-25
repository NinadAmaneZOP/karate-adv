package com.example.runner;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.testng.Assert;
import org.testng.annotations.Test;

public class TestRunner {

    @Test
    public void runKarate() {
        // Resolve target feature or default to parent folder
        String feature = System.getProperty("feature");
        String path = (feature != null && !feature.trim().isEmpty())
                ? (feature.startsWith("classpath:") ? feature : "classpath:parent/" + feature)
                : "classpath:parent";

        Runner.Builder builder = Runner.path(path);

        // Apply tag filter if provided
        String tags = System.getProperty("tags");
        if (tags != null && !tags.trim().isEmpty()) {
            builder.tags(tags);
        }

        // Configure parallel threads (default 1)
        int threads = 1;
        String threadProp = System.getProperty("threads");
        if (threadProp != null && !threadProp.trim().isEmpty()) {
            try {
                threads = Integer.parseInt(threadProp.trim());
            } catch (NumberFormatException ignored) {}
        }

        Results results = builder.parallel(threads);
        Assert.assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
}
