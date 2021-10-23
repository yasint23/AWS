# Create an object named app
from flask import Flask, render_template

app = Flask(__name__)


@app.route("/index")
def index():
    return render_template("index.html")


# Add a statement to run the Flask application which can be debugged.
if __name__== "__main__":
    app.run(debug=True)
    #app.run(host='0.0.0.0', port=80)