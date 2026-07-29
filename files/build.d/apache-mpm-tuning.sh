#!/bin/sh
set -e

# Raise the prefork MPM's spare-worker pool from the Gentoo stock defaults
# (StartServers 5 / MinSpareServers 5 / MaxSpareServers 10). Each Apache
# child here embeds a full mod_php interpreter, so a burst of concurrent
# WebDAV/OCS requests beyond the spare pool forces a fresh fork+PHP-init
# before it can be served, adding latency exactly when load is bursty.
# MaxRequestWorkers/MaxConnectionsPerChild are left at their defaults.
sed -Ei '/<IfModule mpm_prefork_module>/,+3{
	s/^([[:space:]]*StartServers[[:space:]]+)5$/\110/
	s/^([[:space:]]*MinSpareServers[[:space:]]+)5$/\110/
	s/^([[:space:]]*MaxSpareServers[[:space:]]+)10$/\120/
}' /etc/apache2/modules.d/00_mpm.conf
