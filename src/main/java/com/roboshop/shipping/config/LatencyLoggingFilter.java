package com.roboshop.shipping.config;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class LatencyLoggingFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(LatencyLoggingFilter.class);

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;
        long start = System.currentTimeMillis();
        try {
            chain.doFilter(req, res);
        } finally {
            double latencyMs = (System.currentTimeMillis() - start);
            String json = String.format("{\"method\":\"%s\",\"path\":\"%s\",\"status\":%d,\"latency_ms\":%.1f}",
                    request.getMethod(), request.getRequestURI(), response.getStatus(), latencyMs);
            log.info(json);
        }
    }
}
