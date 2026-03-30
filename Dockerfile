# Builder - Generowanie dynamicznej treści strony
FROM alpine:latest AS builder

# Definicja argumentu budowy - wersja aplikacji
ARG VERSION
ENV APP_VERSION=$VERSION

# Dynamiczne generowanie pliku index.html
RUN echo "<html><body style='font-family: Arial; text-align: center; background-color: #f0f2f5;'>" > /index.html && \
    echo "<h1 style='color: #1a73e8;'>Laboratorium 5 - Dominik Blaziak</h1>" >> /index.html && \
    echo "<div style='display: inline-block; text-align: left; border: 1px solid #ccc; padding: 20px; border-radius: 8px; background: white; box-shadow: 2px 2px 5px #aaa;'>" >> /index.html && \
    echo "<p><b>Adres IP serwera:</b> $(hostname -i)</p>" >> /index.html && \
    echo "<p><b>Nazwa serwera:</b> $(hostname)</p>" >> /index.html && \
    echo "<p><b>Wersja aplikacji:</b> $APP_VERSION</p>" >> /index.html && \
    echo "<hr><p style='font-size: 0.8em; color: #666;'>Data budowy: $(date)</p>" >> /index.html && \
    echo "</div></body></html>" >> /index.html

# Scratch - Minimalistyczny etap pośredni 
FROM scratch AS stage1
COPY --from=builder /index.html /index.html

# Serwer produkcyjny Nginx (Wersja Alpine)
FROM nginx:alpine

# Metadane OCI
LABEL org.opencontainers.image.authors="Dominik Blaziak <s101539@pollub.edu.pl>" \
      org.opencontainers.image.title="Laboratorium 5 - Serwer Nginx" \
      org.opencontainers.image.description="Obraz zbudowany metodą wieloetapową z wykorzystaniem scratch" 
      
# Instalacja curl niezbędnego dla mechanizmu HEALTHCHECK
RUN apk add --no-cache curl

# Kopiowanie przygotowanego pliku HTML z etapu scratch
COPY --from=stage1 /index.html /usr/share/nginx/html/index.html

# Optymalizacja uprawnień dla serwera Nginx (Zgodność z najlepszymi praktykami)
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Informacja o porcie, na którym pracuje usługa
EXPOSE 80

# Automatyczna kontrola poprawności działania (Healthcheck)
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

# Punkt wejścia - uruchomienie serwera Nginx w trybie foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]