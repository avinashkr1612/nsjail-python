from flask import Flask, request, jsonify
import json
import subprocess
import os

app = Flask(__name__)

@app.route('/execute', methods=['POST'])
def execute_script():
    data = request.get_json()
    if not data or 'script' not in data:
        return jsonify({"error": "No script provided"}), 400

    script = data['script']

    if "def main():" not in script:
        return jsonify({"error": "No main() function found"}), 400

    script_path = "/app/user_script.py"

    import_script = """
import json
import os
import pandas
import numpy
"""

    wrapper_script = """
def main_wrapper():
    try:
        result = main()
        if not isinstance(result, dict):
            raise ValueError("main() must return a dictionary")
        return json.dumps(result)
    except Exception as e:
        return json.dumps({"error": str(e)})

if __name__ == "__main__":
    print(main_wrapper())
"""

    full_script = f"{import_script}\n{script}\n{wrapper_script}"


    with open(script_path, 'w') as f:
        f.write(full_script)

    try:
        result = subprocess.run([
            'nsjail',
            '--config', 'nsjail.cfg',
            '--', 'python3', script_path
        ], capture_output=True, text=True, timeout=10)

        
        if result.returncode != 0:
            return jsonify({"error": result.stderr}), 400

        # Assuming the main() function returns a JSON string
        output = result.stdout.strip()
        return jsonify({"result": json.loads(output)})

    except subprocess.TimeoutExpired:
        return jsonify({"error": "Script execution timed out"}), 500
    except json.JSONDecodeError:
        return jsonify({"error": "Script did not return valid JSON"}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

