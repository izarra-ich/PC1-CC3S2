from flask import Flask, jsonify
import os
import sys

# 12-Factor: configuración vía variables de entorno (sin valores codificados)
PORT = int(os.environ.get("PORT", "8080"))
APP_NAME = os.environ.get("APP_NAME", "flask-app")
PROJECT = os.environ.get("PROJECT", "Analizador de logs de red con seguridad integrada")
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
    print(f"[INFO] POST /  message={MESSAGE} release={RELEASE}", file=sys.stdout, flush=True)
    return jsonify(
        status="ok",
        message=MESSAGE,
        release=RELEASE,
        port=PORT,
    )
    
@app.route("/", methods=["PUT"])
def root_put():
    # Registrar logs en stdout (12-Factor: logs como flujos de eventos)
    print(f"[INFO] PUT /  message={MESSAGE} release={RELEASE}", file=sys.stdout, flush=True)
    return jsonify(
        status="ok",
        message=MESSAGE,
        release=RELEASE,
        port=PORT,
    )
    
@app.route("/", methods=["DELETE"])
def root_delete():
    # Registrar logs en stdout (12-Factor: logs como flujos de eventos)
    print(f"[INFO] DELETE /  message={MESSAGE} release={RELEASE}", file=sys.stdout, flush=True)
    return jsonify(
        status="ok",
        message=MESSAGE,
        release=RELEASE,
        port=PORT,
    )

if __name__ == "__main__":
    # 12-Factor: vincular a un puerto; proceso único; sin estado
    app.run(host="127.0.0.1", port=PORT)