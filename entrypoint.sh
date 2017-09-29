#!/bin/sh

# startup
case "$1" in
	'')
		nginx -g 'daemon off;';
		;;
	*)
		exec "$@"
		;;
esac
