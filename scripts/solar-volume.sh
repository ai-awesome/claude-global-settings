#!/usr/bin/env bash
# Outputs a volume level (0.0–1.0) based on current sun position — peaks at solar noon, minimum at night.

set -euo pipefail

MIN_VOL=0.1
MAX_VOL=1.0

# Logs messages to stderr.
log() { echo "$@" >&2; }

# Auto-detects geographic coordinates via IP geolocation, or uses manual LAT/LON if set.
fetch_location() {
    if [[ -n "${LAT:-}" && -n "${LON:-}" ]]; then
        log "[INFO] Using manually specified location: ${LAT}, ${LON}"
        return
    fi
    local response
    response=$(curl -sf "https://ipapi.co/json/") || {
        echo "[WARN] IP geolocation failed, setting minimum volume" >&2
        osascript -e "set volume output volume $(python3 -c "print(round(${MIN_VOL} * 100))")"
        exit 0
    }
    LAT=$(echo "$response" | python3 -c "import sys,json; print(json.load(sys.stdin)['latitude'])")
    LON=$(echo "$response" | python3 -c "import sys,json; print(json.load(sys.stdin)['longitude'])")
    local city
    city=$(echo "$response" | python3 -c "import sys,json; d=json.load(sys.stdin); print(f\"{d.get('city','?')}, {d.get('country_name','?')}\")")
    log "[INFO] Auto-detected location: ${city} (${LAT}, ${LON})"
}

# Fetches sunrise and sunset times from the sunrise-sunset.org API.
fetch_sun_times() {
    local response
    response=$(curl -sf "https://api.sunrise-sunset.org/json?lat=${LAT}&lng=${LON}&formatted=0") || {
        echo "[WARN] Failed to fetch sunrise/sunset data, setting minimum volume" >&2
        osascript -e "set volume output volume $(python3 -c "print(round(${MIN_VOL} * 100))")"
        exit 0
    }

    SUNRISE=$(echo "$response" | python3 -c "
import sys, json, datetime
data = json.load(sys.stdin)['results']
dt = datetime.datetime.fromisoformat(data['sunrise'].replace('Z','+00:00'))
print(dt.astimezone().strftime('%H:%M'))
")
    SUNSET=$(echo "$response" | python3 -c "
import sys, json, datetime
data = json.load(sys.stdin)['results']
dt = datetime.datetime.fromisoformat(data['sunset'].replace('Z','+00:00'))
print(dt.astimezone().strftime('%H:%M'))
")
}

# Converts an HH:MM time string to total minutes since midnight.
time_to_minutes() {
    local h m
    IFS=: read -r h m <<< "$1"
    echo $(( 10#$h * 60 + 10#$m ))
}

# Calculates volume (0.0-1.0) using a sine curve that peaks at solar noon.
calc_volume() {
    python3 - "$1" "$2" "$3" "$4" "$5" <<'EOF'
import sys, math

now_min   = int(sys.argv[1])
rise_min  = int(sys.argv[2])
set_min   = int(sys.argv[3])
min_vol   = float(sys.argv[4])
max_vol   = float(sys.argv[5])

noon_min = (rise_min + set_min) / 2

if now_min <= rise_min or now_min >= set_min:
    vol = min_vol
elif now_min <= noon_min:
    ratio = (now_min - rise_min) / (noon_min - rise_min)
    vol = min_vol + (max_vol - min_vol) * math.sin(ratio * math.pi / 2)
else:
    ratio = (set_min - now_min) / (set_min - noon_min)
    vol = min_vol + (max_vol - min_vol) * math.sin(ratio * math.pi / 2)

print(f"{vol:.4f}")
EOF
}

fetch_location
fetch_sun_times
calc_volume $(time_to_minutes "$(date '+%H:%M')") $(time_to_minutes "$SUNRISE") $(time_to_minutes "$SUNSET") "$MIN_VOL" "$MAX_VOL"
