from flask import Flask

app = Flask(__name__)

@app.route("/health")
def health_check():
    return "OK", 200

@app.route('/')
def hello():
    return "¡Hola Mundo! Esta es una aplicación Flask corriendo en Alpine Linux."

if __name__ == '__main__':
    app.run(host='0.0.0.0')