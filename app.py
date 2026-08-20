import os
import socket
import time

from flask import Flask, Response, render_template
from kubernetes import client, config
from prometheus_client import (
    CONTENT_TYPE_LATEST,
    Counter,
    Histogram,
    generate_latest,
)

app = Flask(__name__)


# --------------------------------------------------
# Prometheus metrics
# --------------------------------------------------

REQUEST_COUNT = Counter(
    "flask_requests_total",
    "Total number of Flask requests",
    ["method", "endpoint"],
)

REQUEST_LATENCY = Histogram(
    "flask_request_duration_seconds",
    "Flask request latency",
    ["method", "endpoint"],
)


# --------------------------------------------------
# Home
# --------------------------------------------------

@app.route("/")
def home():

    start = time.time()

    # Simulate application latency
    time.sleep(1)

    REQUEST_COUNT.labels(
        method="GET",
        endpoint="/",
    ).inc()

    app_name = os.getenv("APP_NAME", "Watchtower")
    app_env = os.getenv("APP_ENV", "dev")
    company = os.getenv("COMPANY", "Demo")
    namespace = os.getenv("NAMESPACE", "default")

    # --------------------------------------------------
    # Query Kubernetes API
    # --------------------------------------------------

    try:

        try:
            # Running inside Kubernetes
            config.load_incluster_config()

        except config.ConfigException:
            # Running locally
            config.load_kube_config()

        v1 = client.CoreV1Api()

        pods = v1.list_namespaced_pod(
            namespace=namespace,
            label_selector="app=watchtower",
        )

        running_pods = [
            pod
            for pod in pods.items
            if pod.status.phase == "Running"
        ]

        pod_count = len(running_pods)

    except (config.ConfigException, client.ApiException) as e:
        print(f"Kubernetes API Error: {e}")
        pod_count = "N/A"

    # --------------------------------------------------
    # Render application page
    # --------------------------------------------------

    response = render_template(
        "index.html",
        app_name=app_name,
        app_env=app_env,
        company=company,
        pod_count=pod_count,
        hostname=socket.gethostname(),
        namespace=namespace,
    )

    # --------------------------------------------------
    # Record latency
    # --------------------------------------------------

    REQUEST_LATENCY.labels(
        method="GET",
        endpoint="/",
    ).observe(time.time() - start)

    return response


# --------------------------------------------------
# Health check
# --------------------------------------------------

@app.route("/health")
def health():

    REQUEST_COUNT.labels(
        method="GET",
        endpoint="/health",
    ).inc()

    return {
        "status": "healthy"
    }


# --------------------------------------------------
# Prometheus metrics
# --------------------------------------------------

@app.route("/metrics")
def metrics():

    return Response(
        generate_latest(),
        mimetype=CONTENT_TYPE_LATEST,
    )


# --------------------------------------------------
# Local development
# --------------------------------------------------

if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5000,
    )