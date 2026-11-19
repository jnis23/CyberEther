#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

usage() {
    printf 'Usage: %s [output-directory]\n' "${0##*/}"
    printf 'Build an x86-64 Linux release and extract it to the output directory.\n'
    printf 'Defaults: output-directory=%s/.dist/linux-x86_64, CONTAINER_ENGINE=docker, BUILD_JOBS=2\n' "$root_dir"
}

if [[ "${1:-}" == -h || "${1:-}" == --help ]]; then
    usage
    exit 0
fi
if (( $# > 1 )) || [[ "${1:-}" == -* ]]; then
    usage >&2
    exit 2
fi

engine="${CONTAINER_ENGINE:-docker}"
if ! command -v "$engine" >/dev/null 2>&1; then
    printf 'Container engine %s was not found. Install Docker or set CONTAINER_ENGINE=podman.\n' "$engine" >&2
    exit 1
fi

output_dir="${1:-$root_dir/.dist/linux-x86_64}"
scratch_dir="$(mktemp -d)"
container_id=''
cleanup() {
    if [[ -n "$container_id" ]]; then
        "$engine" rm "$container_id" >/dev/null
    fi
    rm -rf -- "$scratch_dir"
}
trap cleanup EXIT

"$engine" build --platform linux/amd64 --target linux-binary \
    --build-arg "BUILD_JOBS=${BUILD_JOBS:-2}" \
    --iidfile "$scratch_dir/image-id" "$root_dir"
container_id="$("$engine" create --platform linux/amd64 "$(cat "$scratch_dir/image-id")")"

mkdir -p -- "$output_dir"
output_dir="$(cd -- "$output_dir" && pwd)"
"$engine" cp "$container_id:/bundle/." "$output_dir"
printf 'Build exported to %s\n' "$output_dir"
printf 'Check it with %q --version\n' "$output_dir/cyberether"
