from flask import Flask, jsonify
from .api import bp

def create_app():
    app = Flask(__name__)
    app.config['JSON_SORT_KEYS'] = False
    app.register_blueprint(bp)
    @app.errorhandler(404)
    def not_found(_): return jsonify({'error':'Resource not found.'}), 404
    @app.errorhandler(405)
    def method_not_allowed(_): return jsonify({'error':'Method not allowed.'}), 405
    @app.errorhandler(500)
    def internal(_): return jsonify({'error':'Something went wrong. Please try again.'}), 500
    return app

app = create_app()

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=False)
