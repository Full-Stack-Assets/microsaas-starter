#!/usr/bin/env bats
# Tests for generate-monorepo.sh
#
# These tests run the generator inside an isolated temporary directory so they
# never touch the repository working tree. Run with: bats test/

# Per-test fixture: copies the script under test into a fresh temporary
# directory and cd's into it so generation never touches the repo tree.
setup() {
  # Absolute path to the script under test (resolved before we change dirs).
  SCRIPT="${BATS_TEST_DIRNAME}/../generate-monorepo.sh"
  # Fresh, isolated working directory per test.
  WORKDIR="$(mktemp -d)"
  cp "$SCRIPT" "$WORKDIR/generate-monorepo.sh"
  cd "$WORKDIR"
}

# Per-test cleanup: leaves the temporary working directory and removes it.
teardown() {
  cd /
  rm -rf "$WORKDIR"
}

@test "script exits successfully" {
  run bash generate-monorepo.sh
  [ "$status" -eq 0 ]
}

@test "creates the expected base directory structure" {
  bash generate-monorepo.sh
  [ -d microsaas-starter/apps/tradequote/app ]
  [ -d microsaas-starter/apps/inkmanager/app ]
  [ -d microsaas-starter/apps/invoiceflow/app ]
  [ -d microsaas-starter/packages/database/tradequote ]
  [ -d microsaas-starter/packages/database/inkmanager ]
  [ -d microsaas-starter/packages/database/invoiceflow ]
  [ -d microsaas-starter/scripts ]
  [ -d microsaas-starter/.github/workflows ]
}

@test "writes the tradequote app entrypoint (regression: app/ dir must exist)" {
  # Regression test for the bug where line 53 wrote to apps/tradequote/app/
  # without that directory having been created first, aborting the script.
  bash generate-monorepo.sh
  [ -f microsaas-starter/apps/tradequote/app/page.tsx ]
}

@test "generated tradequote package.json is valid JSON" {
  bash generate-monorepo.sh
  run python3 -m json.tool microsaas-starter/apps/tradequote/package.json
  [ "$status" -eq 0 ]
}

@test "generated package.json declares the expected package name" {
  bash generate-monorepo.sh
  run python3 -c "import json,sys; print(json.load(open('microsaas-starter/apps/tradequote/package.json'))['name'])"
  [ "$status" -eq 0 ]
  [ "$output" = "tradequote-pro" ]
}

@test "writes entrypoints for inkmanager and invoiceflow apps" {
  bash generate-monorepo.sh
  [ -f microsaas-starter/apps/inkmanager/app/page.tsx ]
  [ -f microsaas-starter/apps/invoiceflow/app/page.tsx ]
}

@test "all app package.json files are valid JSON with expected names" {
  bash generate-monorepo.sh
  run python3 - <<'PY'
import json
expected = {
    "tradequote": "tradequote-pro",
    "inkmanager": "inkmanager",
    "invoiceflow": "invoiceflow",
}
for app, name in expected.items():
    data = json.load(open(f"microsaas-starter/apps/{app}/package.json"))
    assert data["name"] == name, f"{app}: {data['name']} != {name}"
print("ok")
PY
  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}

@test "emits deploy script and workflow files" {
  bash generate-monorepo.sh
  [ -f microsaas-starter/scripts/deploy.sh ]
  [ -f microsaas-starter/.github/workflows/deploy.yml ]
}

@test "produces a zip archive containing the generated app" {
  bash generate-monorepo.sh
  [ -f microsaas-starter.zip ]
  run unzip -l microsaas-starter.zip
  [ "$status" -eq 0 ]
  [[ "$output" == *"apps/tradequote/app/page.tsx"* ]]
}
