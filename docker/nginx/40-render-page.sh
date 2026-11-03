#!/bin/sh
set -eu

	: "${OLYMPUS_APP_NAME:?Debes definir OLYMPUS_APP_NAME}"
	: "${OLYMPUS_ENV:?Debes definir OLYMPUS_ENV}"


	envsubst '${OLYMPUS_APP_NAME} ${OLYMPUS_ENV}' \
		< /opt/olympus/index.html.template \
		> /usr/share/nginx/html/index.html

