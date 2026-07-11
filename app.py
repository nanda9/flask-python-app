from flask import Flask, render_template
from kubernetes import client, config
import os
import socket

app = Flask(__name__)


@app.route("/")
def home():

    # Read ConfigMap values
    app_name = os.getenv("APP_NAME")
    app_env = os.getenv("APP_ENV")
    company = os.getenv("COMPANY")

    # Get Kubernetes pod information
    try:
        try:
            config.load_incluster_config()
        except:
            config.load_kube_config()

        v1 = client.CoreV1Api()

        pods = v1.list_namespaced_pod(
            namespace="dev",
            label_selector="app=flask"
        )

        running_pods = [
            pod for pod in pods.items
            if pod.status.phase == "Running"
        ]

        pod_count = len(running_pods)

    except Exception as e:
        print("Kubernetes Error:", e)
        pod_count = "N/A"

    return render_template(
        "index.html",
        app_name=app_name,
        app_env=app_env,
        company=company,
        pod_count=pod_count,
        hostname=socket.gethostname(),
        namespace="dev"
    )


@app.route("/health")
def health():
    return {
        "status": "healthy"
    }


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )