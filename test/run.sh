#!/bin/sh
# Package checks: every JSON parses, every manifest payload exists and every payload file is listed.
# usage: sh test/run.sh   (needs python3)
set -eu
cd "$(dirname "$0")/.."
python3 - <<'EOF'
import json, os
m = json.load(open("pkg/manifest.json"))
assert m["name"].startswith("cmu-re-"), m["name"]
listed = {f["payload"] for f in m["files"]}
for p in listed:
    assert os.path.isfile(os.path.join("pkg", p)), "missing payload " + p
found = set()
for d, _, fs in os.walk("pkg/payload"):
    for f in fs:
        p = os.path.relpath(os.path.join(d, f), "pkg").replace(os.sep, "/")
        found.add(p)
        if p.endswith(".json"):
            json.load(open(os.path.join("pkg", p)))
assert found == listed, "unlisted payload: %s" % sorted(found - listed)
assert m["files"] or m["depends"].strip(), "no files and no depends"
EOF
echo ok
