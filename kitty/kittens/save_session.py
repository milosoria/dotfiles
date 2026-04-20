import json
import os
import subprocess
from pathlib import Path


def main(args):
    result = subprocess.run(
        ["kitty", "@", "--to", "unix:/tmp/mykitty", "ls"],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        print("Failed to get kitty state:", result.stderr)
        return

    state = json.loads(result.stdout)
    sessions_dir = Path(os.path.expanduser("~/.config/kitty/sessions"))
    sessions_dir.mkdir(parents=True, exist_ok=True)
    session_file = sessions_dir / "last_session.conf"

    lines = []
    first_tab = True
    for os_window in state:
        for tab in os_window.get("tabs", []):
            tab_title = tab.get("title", "shell")
            if not first_tab:
                lines.append(f"new_tab {tab_title}")
            else:
                lines.append(f"# Tab: {tab_title}")
                first_tab = False

            lines.append("layout splits")
            windows = tab.get("windows", [])
            for i, window in enumerate(windows):
                cwd = window.get("cwd", os.path.expanduser("~"))
                lines.append(f"cd {cwd}")
                if i == 0:
                    lines.append("launch")
                else:
                    lines.append("launch --location=vsplit")

    session_file.write_text("\n".join(lines) + "\n")
    subprocess.run(
        ["kitty", "@", "--to", "unix:/tmp/mykitty", "set-window-title", "Session saved!"],
        check=False
    )


handle_result = None
