import json
import os
import sys

from github import Github


def extract_token():
    try:
        f = open(f'{os.path.dirname(os.path.abspath(__file__))}/secrets.json', )
        token = set(json.load(f).values())
        f.close()
    except Exception as e:
        print(e)
        sys.exit(f"Error in reading secrets.json, must create github key and store it in {os.path.dirname(os.path.abspath(__file__))}/secrets.json")
    return token


def create_project():
    token = extract_token()
    try:
        user = Github(*token).get_user()
        user.create_repo(sys.argv[1])
        print("Succesfully created repository {}".format(sys.argv[1]))
    except Exception as e:
        print(e)
        sys.exit("Error processing request")

if __name__ == "__main__":
    create_project()
