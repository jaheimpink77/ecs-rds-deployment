#!/bin/sh
set -e

python manage.py migrate --noinput
exec python manage.py runserver --noreload 0.0.0.0:8000