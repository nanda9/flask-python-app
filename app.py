import os
from flask import Flask

app = Flask(__name__)

port = int(os.getenv("PORT", 5000))

@app.route("/")
def home():
	return """
	<h1>Hello Docker! </h1>
	<h2>This is my First local host deployed Docker container app</h2>
	<h3>Designed by Nandakumar Jyothi DevOps Engineer</h3>
	"""


if __name__ == "__main__":
	app.run(host="0.0.0.0", port=port)


