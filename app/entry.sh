#!/bin/bash
exec gunicorn -b :3000 --access-logfile - --error-logfile - flask_app:app