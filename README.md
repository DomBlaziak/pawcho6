#  Laboratorium 6 (Integracja z GitHub & BuildKit)

Niniejsze repozytorium służy jako **zdalne źródło zasobów** (Source of Truth) dla procesu budowy obrazu w ramach Laboratorium nr 6. 
Projekt opiera się na rozwiązaniu zadania z Laboratorium nr 5, rozszerzając je o zaawansowane mechanizmy chmurowe i nowoczesne standardy Docker.

### Kluczowe cechy Laboratorium 6:
*   **BuildKit jako Standard:** Wykorzystano silnik BuildKit, który od wersji Docker Desktop 2.4.0.0 (oraz Docker Engine 23.0+) jest domyślnym i pierwszorzędnym standardem budowania obrazów, oferującym lepszą wydajność i natywną obsługę sekretów.
*   **Single Source of Truth:** Zasoby obrazu są pobierane dynamicznie z tego repozytorium podczas budowy, co uniezależnia proces od lokalnego systemu plików i gwarantuje spójność kodu.
*   **Bezpieczeństwo SSH Mount:** Wykorzystano funkcjonalność `--mount=type=ssh`. Pozwala ona na bezpieczne klonowanie repozytorium wewnątrz Dockerfile przy użyciu nowoczesnego klucza prywatnego **Ed25519**, który **nie zostaje skopiowany** do warstw obrazu.
*   **Integracja GHCR:** Zbudowany obraz o tagu **lab6** jest publikowany w rejestrze **GitHub Container Registry** (ghcr.io) i trwale powiązany z niniejszym repozytorium (sekcja Packages).
*   **Metadane OCI:** Zastosowano etykietę `org.opencontainers.image.source`, która automatycznie łączy artefakt w chmurze z kodem źródłowym w Git.

---

# Opis projektu (Laboratorium 5)

Zadanie polegało na stworzeniu wydajnego i bezpiecznego obrazu Docker z wykorzystaniem techniki **Multi-stage build**. Pozwala to na całkowite oddzielenie ciężkiego środowiska budowy od minimalistycznego obrazu końcowego.

### Struktura pliku Dockerfile:

1.  **Etap Builder:** Wykorzystuje obraz Alpine do wygenerowania dynamicznego pliku `index.html` z danymi systemowymi kontenera (IP, Hostname, Wersja).
2.  **Etap Scratch:** Służy jako minimalistyczny etap pośredni (izolator), na który kopiowany jest wyłącznie gotowy plik strony.
3.  **Etap Final:** Wykorzystuje serwer **Nginx (wersja alpine)** z następującymi usprawnieniami:
    *   **Metadane OCI:** Zgodność ze standardami Open Container Initiative.
    *   **Zarządzanie uprawnieniami:** Pliki należą do użytkownika `nginx`.
    *   **ENTRYPOINT:** Zdefiniowanie stałego procesu serwera.
    *   **HEALTHCHECK:** Mechanizm monitorowania stanu zdrowia aplikacji (curl).

---

### Instrukcja obsługi projektu (Pełny cykl):

Aby poprawnie zbudować, uruchomić i zweryfikować kontener, wykonaj poniższe kroki w terminalu:

**1. Budowa obrazu z wykorzystaniem klucza SSH:**
Podczas budowy należy wskazać ścieżkę do swojego klucza prywatnego **Ed25519**, który posiada uprawnienia dostępu do Twojego konta GitHub:

``bash
docker build --ssh default=$HOME/.ssh/id_ed25519 -t lab6 .

**2. Uruchomienie kontenera:**
Po pomyślnym zbudowaniu obrazu, uruchom serwer na porcie **8080** hosta w trybie odłączonym (`-d`):

```bash
docker run -d -p 8080:80 --name lab6-srv lab6
