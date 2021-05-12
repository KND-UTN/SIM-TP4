from flask import Flask, render_template, request, jsonify
import FastMontecarloV3

app = Flask(__name__, template_folder='templates',
            static_url_path='',
            static_folder='static')


@app.route("/")
def hello():
    return render_template('index.html')


@app.route("/procesar", methods=["GET"])
def procesar():
    argumentos = request.args
    inicial = int(argumentos.get('inicial'))
    q = int(argumentos.get('q'))
    r = int(argumentos.get('r'))
    ko = float(argumentos.get('ko'))
    km = float(argumentos.get('km'))
    ks = float(argumentos.get('ks'))
    desde = int(argumentos.get('desde'))
    hasta = int(argumentos.get('hasta'))
    n = int(argumentos.get('n'))
    resultado = FastMontecarloV3.procesar(inicial, q, r, ko, km, ks, desde, hasta, n)
    response = jsonify(resultado)
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response

app.run(host='0.0.0.0')
