#!/bin/sh
set -e

python manage.py migrate --noinput
exec python manage.py runserver --no-reload 0.0.0.0:8000