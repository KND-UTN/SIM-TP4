from flask import Flask, render_template

app = Flask(__name__, template_folder='templates',
            static_url_path='',
            static_folder='static')

@app.route("/")
def hello():
    return "Funciono"


# @app.route("/person", methods=['POST'])
# def handle_person():
#     print("Peticion: " + str(request.json))
#     return ""

app.run(host='0.0.0.0', port=11000)
