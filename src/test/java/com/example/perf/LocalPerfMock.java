package com.example.perf;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.Executors;

/**
 * Tiny local HTTP server used only for safe Gatling performance practice.
 * It runs on your machine (localhost) so we do not send load to public APIs.
 */
public class LocalPerfMock {

    private static HttpServer server;

    public static synchronized void start(int port) throws IOException {
        if (server != null) {
            return; // already running
        }
        server = HttpServer.create(new InetSocketAddress(port), 0);

        // Restful-Booker style ping endpoint returns HTTP 201
        server.createContext("/ping", exchange -> {
            try {
                send(exchange, 201, "Created");
            } catch (Exception e) {
                e.printStackTrace();
                exchange.close();
            }
        });

        // Minimal products endpoint for future reuse
        server.createContext("/products", exchange -> {
            try {
                String response = "{\"products\":[],\"total\":0,\"skip\":0,\"limit\":0}";
                send(exchange, 200, response);
            } catch (Exception e) {
                e.printStackTrace();
                exchange.close();
            }
        });

        server.setExecutor(Executors.newCachedThreadPool());
        server.start();
    }

    public static synchronized void stop() {
        if (server != null) {
            server.stop(0); // stop immediately
            server = null;
        }
    }

    private static void send(HttpExchange exchange, int status, String body) throws IOException {
        byte[] bytes = body == null ? new byte[0] : body.getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().add("Content-Type", "application/json; charset=utf-8");
        exchange.sendResponseHeaders(status, bytes.length);
        try (OutputStream os = exchange.getResponseBody()) {
            if (bytes.length > 0) {
                os.write(bytes);
            }
        }
        // Closing the response body stream completes the exchange; avoid double-closing.
    }
}
