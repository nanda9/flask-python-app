from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <h1>End-to-End DevOps Project: CI/CD with Docker, Kubernetes & ArgoCD</h1>
    <h2>Automated Deployment Triggered by Git Push</h2>
    <h3>Designed by Nandakumar Jyothi | DevOps Engineer</h3>
    """
    
if __name__ == "__main__":
    import os
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
