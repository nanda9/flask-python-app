from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
    Hello from Render + Docker!  CI/CD Docker Pipeline Running!
    This is my First local host application deployed on Render + Docker container.
    Designed by Nandakumar Jyothi, DevOps Engineer.
    """

if __name__ == "__main__":
    import os
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)