# Wykorzystanie obrazu alpine jako lekkiego narzędzia do budowy treści
FROM alpine:latest AS builder

# Definicja argumentu budowy
ARG VERSION
# Zapisanie wersji do zmiennej środowiskowej
ENV APP_VERSION=$VERSION

# Dynamiczne generowanie pliku index.html z danymi systemowymi kontenera
RUN echo "<html><body style='font-family: Arial; text-align: center; background-color: #f0f2f5;'>" > /index.html && \
    echo "<h1 style='color: #1a73e8;'>Laboratorium 5 - Dominik Blaziak</h1>" >> /index.html && \
    echo "<div style='display: inline-block; text-align: left; border: 1px solid #ccc; padding: 20px; border-radius: 8px; background: white; box-shadow: 2px 2px 5px #aaa;'>" >> /index.html && \
    echo "<p><b>Adres IP serwera:</b> $(hostname -i)</p>" >> /index.html && \
    echo "<p><b>Nazwa serwera:</b> $(hostname)</p>" >> /index.html && \
    echo "<p><b>Wersja aplikacji:</b> $APP_VERSION</p>" >> /index.html && \
    echo "<hr><p style='font-size: 0.8em; color: #666;'>Data budowy: $(date)</p>" >> /index.html && \
    echo "</div></body></html>" >> /index.html

# Budowa obrazu bazowego metodą od podstaw (scratch)
FROM scratch AS stage1

# Kopiowanie przygotowanego pliku HTML do czystego obrazu
COPY --from=builder /index.html /index.html

# Wykorzystanie oficjalnego obrazu serwera Nginx w wersji alpine
FROM nginx:alpine

# Instalacja curl niezbędnego do poprawnego działania mechanizmu HEALTHCHECK
RUN apk add --no-cache curl

# Metadane obrazu - autor
LABEL maintainer="Dominik Blaziak s101539@pollub.edu.pl"

# Informacja o porcie, na którym pracuje usługa
EXPOSE 80

# Kopiowanie aplikacji z etapu 1 do domyślnego katalogu serwera Nginx
COPY --from=stage1 /index.html /usr/share/nginx/html/index.html

# Automatyczna kontrola poprawności działania aplikacji (co 30 sekund)
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1