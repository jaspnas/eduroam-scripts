#!/usr/bin/env bats

setup() {
  export NMCLI_ARGS_LOG="$BATS_TMPDIR/nmcli_args.log"
  : > "$NMCLI_ARGS_LOG"
  rm -f "$BATS_TMPDIR/connection_created"
  mkdir -p "$BATS_TMPDIR/bin"
  cat <<'EOS' > "$BATS_TMPDIR/bin/nmcli"
#!/usr/bin/env bash
# mock nmcli
echo "$@" >> "$NMCLI_ARGS_LOG"
if [[ "$1" == "device" && "$2" == "status" ]]; then
  echo "wlan0 wifi connected" # minimal output
  exit 0
fi
if [[ "$1" == "connection" && "$2" == "show" ]]; then
  # first call simulates connection missing; subsequent calls succeed
  if [[ ! -f "$BATS_TMPDIR/connection_created" ]]; then
    exit 1
  fi
  exit 0
fi
if [[ "$1" == "connection" && "$2" == "add" ]]; then
  touch "$BATS_TMPDIR/connection_created"
  exit 0
fi
exit 0
EOS
  chmod +x "$BATS_TMPDIR/bin/nmcli"
  export PATH="$BATS_TMPDIR/bin:$PATH"
}

@test "DISABLE_POWERSAVE adds powersave argument" {
  run bash -c 'printf "user\npass\n" | DISABLE_POWERSAVE=1 ./add_connection.sh'
  grep -q "802-11-wireless.powersave 2" "$NMCLI_ARGS_LOG"
}

@test "script works without DISABLE_POWERSAVE" {
  run bash -c 'printf "user\npass\n" | ./add_connection.sh'
  [ "$status" -eq 0 ]
  grep -q "connection add" "$NMCLI_ARGS_LOG"
  ! grep -q "802-11-wireless.powersave 2" "$NMCLI_ARGS_LOG"
}
