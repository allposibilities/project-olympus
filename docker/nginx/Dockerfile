FROM nginx:stable

COPY index.html.template /opt/olympus/index.html.template
COPY 40-render-page.sh /docker-entrypoint.d/40-render-page.sh

RUN chmod +x /docker-entrypoint.d/40-render-page.sh


