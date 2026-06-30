from flask import Flask, jsonify, render_template

app = Flask(__name__)

# ---------------- HOME PAGE ----------------
@app.route("/")
def home():
    return render_template("index.html")


# ---------------- METRICS API (USED BY DASHBOARD) ----------------
@app.route("/metrics")
def metrics():

    return jsonify({
        "pods": 3,
        "cpu": 45,
        "memory": 62,
        "commit": "a1b2c3d4"
    })


# ---------------- RUN APP ----------------
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)