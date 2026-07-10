from flask import Flask, render_template
import os

app = Flask(__name__)

@app.route("/")
def home():
    return render_template(
        "index.html",
        app_name=os.getenv("APP_NAME"),
        app_env=os.getenv("APP_ENV"),
        company=os.getenv("COMPANY")
    )

@app.route("/health")
def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)