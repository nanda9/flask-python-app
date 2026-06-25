from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <h1> CI/CD Docker Pipeline Running! </h1>
    <h2> This is my First local host application deployed on Docker minikube cluster. </h2>
    <h3> Designed by Nandakumar Jyothi, DevOps Engineer. </h3>
    """
    
if __name__ == "__main__":
    import os
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
