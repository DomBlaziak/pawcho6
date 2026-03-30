Laboratorium 5 - Wieloetapowe budowanie obrazów
Opis projektu

Zadanie polegało na stworzeniu wydajnego i bezpiecznego obrazu Docker z wykorzystaniem techniki Multi-stage build. Pozwala to na całkowite oddzielenie ciężkiego środowiska budowy od minimalistycznego i bezpiecznego obrazu końcowego, co redukuje rozmiar obrazu i zwiększa bezpieczeństwo (brak zbędnych narzędzi w obrazie produkcyjnym).
Struktura pliku Dockerfile:

    Etap Builder: Wykorzystuje obraz Alpine do wygenerowania dynamicznego pliku index.html z danymi systemowymi kontenera 
    (IP, Hostname, Wersja).

    Etap Scratch: Służy jako minimalistyczny etap pośredni (izolator), na który kopiowany jest wyłącznie gotowy plik strony, 
    co gwarantuje czystość artefaktów.

    Etap Final: Wykorzystuje serwer Nginx (wersja alpine). W tej wersji wprowadzono kluczowe usprawnienia:

        Metadane OCI: Zgodność ze standardami Open Container Initiative (autor, opisy).

        Zarządzanie uprawnieniami: Pliki należą do użytkownika nginx, co jest zgodne z zasadą minimalnych uprawnień.

        ENTRYPOINT: Zdefiniowanie stałego procesu serwera, zapewniające stabilność kontenera.

        HEALTHCHECK: Skonfigurowany mechanizm monitorowania stanu zdrowia aplikacji.

Instrukcja uruchomienia projektu:

Aby poprawnie zbudować i uruchomić aplikację, wykonaj poniższe kroki w terminalu (będąc w folderze projektu):
1. Budowa obrazu:

Podczas budowy należy przekazać numer wersji aplikacji za pomocą argumentu VERSION. Flaga -t nadaje obrazowi nazwę lab5-app:

docker build --build-arg VERSION=1.5.0-stable -t lab5-app .

2. Uruchomienie kontenera:

Uruchamiamy serwer na porcie 8080 hosta w trybie odłączonym (-d):

docker run -d -p 8080:80 --name lab5-srv lab5-app

3. Weryfikacja działania:

    Status Healthcheck: Odczekaj ok. 30 sekund i wpisz docker ps. W kolumnie STATUS powinno pojawić się oznaczenie (healthy).

    Podgląd strony: Otwórz w przeglądarce adres: http://localhost:8080/.

Wynik działania:

Aplikacja wyświetla dynamicznie pobrane dane w estetycznej formie graficznej:

    Adres IP serwera: Adres IP interfejsu sieciowego kontenera.

    Nazwa serwera: Nazwa hosta kontenera (generowana w etapie builder).

    Wersja aplikacji: Wartość przekazana dynamicznie w kroku budowy przez ARG.