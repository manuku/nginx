#!/bin/sh

# check nginx conf
# DIR="/usr/local/nginx/conf/"
# if [ `find $DIR -prune -empty` ]; then
#     cp -R /usr/local/nginx/conf.default/* $DIR
# fi

# startup
case "$1" in
    '')
        nginx -g 'daemon off;';
        ;;
    *)
        exec "$@"
        ;;
esac
