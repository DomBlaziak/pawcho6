Laboratorium 5 - Wieloetapowe budowanie obrazów
Opis projektu

Zadanie polegało na stworzeniu wydajnego obrazu Docker z wykorzystaniem techniki Multi-stage build. Pozwala to na oddzielenie ciężkiego środowiska budowy od lekkiego i bezpiecznego obrazu końcowego.
Struktura pliku Dockerfile:

    Etap Builder: Wykorzystuje obraz Alpine do wygenerowania dynamicznego pliku index.html z danymi systemowymi kontenera.

    Etap Scratch: Służy jako minimalistyczny etap pośredni, na który kopiowany jest gotowy plik strony.

    Etap Final: Wykorzystuje serwer Nginx (wersja alpine) do udostępniania strony oraz posiada skonfigurowany mechanizm monitorowania stanu zdrowia (HEALTHCHECK).

Instrukcja uruchomienia projektu:

Aby poprawnie zbudować i uruchomić aplikację, wykonaj poniższe kroki w terminalu (będąc w folderze lab5):

1. Budowa obrazu:
Podczas budowy należy przekazać numer wersji aplikacji za pomocą argumentu VERSION. Flaga -t nadaje obrazowi nazwę lab5-app:

docker build --build-arg VERSION=1.5.0-stable -t lab5-app .

2. Uruchomienie kontenera:
Uruchamiamy serwer na porcie 8080 hosta w trybie odłączonym (-d):

docker run -d -p 8080:80 --name lab5-srv lab5-app

3. Weryfikacja działania:
    Status Healthcheck: Odczekaj 30 sekund i wpisz docker ps. W kolumnie STATUS powinno pojawić się oznaczenie (healthy).
    Podgląd strony: Otwórz w przeglądarce adres http://localhost:8080/.

Wynik działania:
Aplikacja wyświetla dynamicznie pobrane dane:

    Adres IP serwera: Pobrany w trakcie budowy obrazu.

    Nazwa serwera: Hostname kontenera budującego (buildkitsandbox).

    Wersja aplikacji: Wartość przekazana w kroku budowy przez ARG.