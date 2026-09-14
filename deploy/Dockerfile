FROM nginx:1.27-alpine-slim

# Criar diretorio de cache dedicado
RUN mkdir -p /var/cache/nginx && chown -R nginx:nginx /var/cache/nginx

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY web/ /usr/share/nginx/html/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
