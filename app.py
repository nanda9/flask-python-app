from flask import Flask, render_template, Response
from kubernetes import client, config
import os
from prometheus_client import Counter, Histogram, generate_latest
from prometheus_client import CONTENT_TYPE_LATEST
import socket
import time


app = Flask(__name__)

REQUEST_COUNT = Counter(
    "flask_requests_total",
    "Total number of Flask requests"
)

REQUEST_LATENCY = Histogram(
    "flask_request_duration_seconds",
    "Flask request latency"
)

@app.route("/")
def home():

    start = time.time()
    REQUEST_COUNT.inc()

    app_name = os.getenv("APP_NAME")
    app_env = os.getenv("APP_ENV")
    company = os.getenv("COMPANY")
    namespace = os.getenv("NAMESPACE", "dev")

    try:
        try:
            config.load_incluster_config()
        except:
            config.load_kube_config()

        v1 = client.CoreV1Api()

        pods = v1.list_namespaced_pod(
            namespace=namespace,
            label_selector="app.kubernetes.io/name=flask-chart"
        )

        running_pods = [
            pod for pod in pods.items
            if pod.status.phase == "Running"
        ]

        pod_count = len(running_pods)

    except Exception as e:
        print(f"Kubernetes API Error: {e}")
        pod_count = "N/A"

    response = render_template(
        "index.html",
        app_name=app_name,
        app_env=app_env,
        company=company,
        pod_count=pod_count,
        hostname=socket.gethostname(),
        namespace=namespace
    )

    REQUEST_LATENCY.observe(time.time() - start)

    return response

@app.route("/health")
def health():
    return {
        "status": "healthy"
    }

@app.route("/metrics")
def metrics():
    return Response(
        generate_latest(),
        mimetype=CONTENT_TYPE_LATEST
    )

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )