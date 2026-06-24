from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
	<h1>Hello Docker! </h1>
	<h2>This is my First local host application deployed on Docker container</h2>
	<h3>Designed by Nandakumar Jyothi, DevOps Engineer</h3>
	<h3>CI/CD Docker Pipeline Running!</h3>"""

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
