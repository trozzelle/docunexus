import json
import os.path

def get_config():
    json_file_path = "../conf/config.json"

    with open(json_file_path) as json_file:
        config = json.load(json_file)

    return config