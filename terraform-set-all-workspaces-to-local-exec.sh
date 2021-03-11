#!/usr/bin/env python3

import os
import re
import sys

import requests

PAYLOAD = {"data": {"type": "workspaces", "attributes": {"operations": False}}}

HEADERS = {"Content-Type": "application/vnd.api+json"}


def load_api_credentials(rc_path="~/.terraformrc"):
    with open(os.path.expanduser(rc_path)) as f:
        m = re.search(r'token = "([^"]+)"', f.read())

    if not m:
        raise RuntimeError(f"Unable to load credentials from {rc_path}")
    else:
        HEADERS["Authorization"] = f"Bearer {m.group(1)}"


def configure_workspace(workspace_id):
    requests.patch(
        f"https://app.terraform.io/api/v2/workspaces/{workspace_id}",
        json=PAYLOAD,
        headers=HEADERS,
    ).raise_for_status()


def configure_all_workspaces():
    next_page = "https://app.terraform.io/api/v2/organizations/loc/workspaces"

    while next_page:
        page = requests.get(next_page, headers=HEADERS).json()

        for i in page["data"]:
            ws_id = i["id"]
            ws_name = i["attributes"]["name"]
            print(f"Updating {ws_name}")
            try:
                configure_workspace(i["id"])
            except requests.exceptions.HTTPError as exc:
                print(f"Error updating {ws_id} {ws_name}: {exc}", file=sys.stderr)

        next_page = page["links"].get("next")


if __name__ == "__main__":
    load_api_credentials()
    configure_all_workspaces()


