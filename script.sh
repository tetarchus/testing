#! /usr/bin/env bash

# PHUn VPN
# Pi-hole, Homebridge, Unbound + Tailscale VPN
# All-in-one solution, even behind a CGNAT.
# (c) 2025 tetarchus (github.com/tetarchus)
#
# This installer is intended to run on a Raspberry Pi running Raspberry Pi OS.
# While it may work on other machines, there are currently no guarantees that
# everything will work as intended.
#
# To install (from your Raspberry Pi):
# curl -sSL https://raw.githubusercontent.com/tetarchus/phun-vpn/refs/head/main/install.sh | bash
#

###### CONFIGURATION #######
# TODO: Do we want this, or check for it outselves to ensure that cleanup_and_exit is called
# -e option instructs bash to immediately exit if any command [1] has a non-zero exit status
# We do not want users to end up with a partially working install, so we exit the script
# instead of continuing the installation with something broken
set -e

# Append common folders to the PATH to ensure that all basic commands are available.
# When using "su" an incomplete PATH could be passed: https://github.com/pi-hole/pi-hole/issues/3209
export PATH+=":/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

######## ARG CHECK #########
for arg in "$@"; do
  case "$arg" in
    "--auto-update") AUTO_UPDATE_PKGS=true ;;
    "--skip-package-install") SKIP_INSTALL_CHECKS=true ;;
    "--unattended-install") UNATTENDED_INSTALL=true ;;
    "--no-color") NO_COLOR=true ;;
    "")  ;; # Ignore empty args
    *) echo "Unrecognised argument: ${arg}"; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "SCRIPT DIRECTORY: ${SCRIPT_DIR}"
echo "$0"
