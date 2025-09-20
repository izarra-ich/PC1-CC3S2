from flask import Flask, jsonify
import os
import sys

# 12-Factor: configuración vía variables de entorno (sin valores codificados)
PORT = int(os.environ.get("PORT", "8080"))
APP_NAME = os.environ.get("APP_NAME", "flask-app")
MESSAGE = os.environ.get("MESSAGE", "Hola desde APP!")
RELEASE = os.environ.get("RELEASE", "v0")

app = Flask(__name__)

@app.route("/")
def root_get():
    # Registrar logs en stdout (12-Factor: logs como flujos de eventos)
    print(f"[INFO] GET /  app={APP_NAME} release={RELEASE}", file=sys.stdout, flush=True)
    return jsonify(
        status="ok",
        message=MESSAGE,
        release=RELEASE,
        port=PORT,
    )

@app.route("/", methods=["POST"])
def root_post():
    # Registrar logs en stdout (12-Factor: logs como flujos de eventos)
    print(f"[INFO] POST /  app={APP_NAME} release={RELEASE}", file=sys.stdout, flush=True)
    return jsonify(
        status="ok",
        message=MESSAGE,
        release=RELEASE,
        port=PORT,
    )
    
@app.route("/<int:id>", methods=["PUT"])
def root_put(id):
    # Registrar logs en stdout (12-Factor: logs como flujos de eventos)
    print(f"[INFO] PUT /  app={APP_NAME} release={RELEASE}", file=sys.stdout, flush=True)
    return jsonify(
        status="ok",
        message=f"params {id} {MESSAGE}",
        release=RELEASE,
        port=PORT,
    )
    
@app.route("/<int:id>", methods=["DELETE"])     # Eliminar recurso con id
def root_delete():                              # omito id intencionalmente para generar error 500
    # Registrar logs en stdout (12-Factor: logs como flujos de eventos)
    print(f"[INFO] DELETE /  app={APP_NAME} release={RELEASE}", file=sys.stdout, flush=True)
    return jsonify(
        status="ok",
        message=f"params {id} {MESSAGE}",
        release=RELEASE,
        port=PORT,
    )

if __name__ == "__main__":
    # 12-Factor: vincular a un puerto; proceso único; sin estado
    app.run(host="127.0.0.1", port=PORT)