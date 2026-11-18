# 👕 FitCheck — Smart Sizing &amp; Second-Hand Matchmaker

&gt; **Automatyzacja pomiaru odzieży, unikalne kody wymiarów oraz inteligentny silnik dopasowania ubrań do sylwetki dla rynku C2C (Vinted, OLX) i e-commerce.**

---

## 📌 O Projekcie

Kupowanie i sprzedawanie ubrań przez Internet – zwłaszcza na platformach second-hand (C2C), takich jak Vinted czy OLX – cierpi na brak standaryzacji rozmiarów. Rozmiar z metki często nie odzwierciedla rzeczywistości (kurczenie materiału, różnice między markami), co prowadzi do niepewności kupujących, lawiny pytań o wymiary i kosztownych zwrotów.

**FitCheck** rozwiązuje ten problem dwuetapowo:
1. **Dla Sprzedających:** Umożliwia automatyczny pomiar odzieży na podstawie zdjęcia z fizycznym punktem odniesienia (np. kartka A4) lub ręczne wprowadzenie wymiarów. Generuje **unikalny kod ID (np. `FC-4912`)** oraz gotową grafikę z naniesionymi miarkami, którą sprzedawca pobiera i wkleja do swojej oferty na Vinted/OLX.
2. **Dla Kupujących:** Zamiast skomplikowanych tabel rozmiarów, użytkownik podaje kod z ogłoszenia i otrzymuje **natychmiastowy raport dopasowania w języku korzyści** (np. *„Pasuje idealnie w talii, długość standardowa”*). Dodatkowo zyskuje dostęp do wyszukiwarki ubrań pasujących do jego indywidualnego profilu wymiarowego.

---

## 🚀 Kluczowe Funkcjonalności

* 📸 **Kalibrowany skan zdjęciem:** Wyznaczanie rzeczywistych wymiarów ubrania na płasko za pomocą wizji komputerowej i obiektu referencyjnego (kartka A4).
* 🏷️ **Unikalny kod wymiaru (Dimension Code):** Lekki identyfikator łączący aukcję zewnętrzną (Vinted) z profilem wymiarowym w FitCheck.
* 👤 **Elastyczny Profil Użytkownika:**
  * Wprowadzanie obwodów ciała **LUB**
  * Wprowadzanie wymiarów ulubionych, dobrze leżących ubrań na płasko.
* 🔒 **Privacy by Design:**
  * **Tryb lokalny (Zero-Knowledge):** Wymiary ciała szyfrowane wyłącznie na urządzeniu użytkownika (`flutter_secure_storage`).
  * **Tryb chmurowy:** Bezpieczna synchronizacja profilu pomiędzy wieloma urządzeniami.
  * Zgodność z RODO: Pełne usuwanie danych konta i wymiarów w dowolnym momencie.
* 🔍 **Wyszukiwarka Ofert z Dopasowaniem (Marketplace):** Wewnętrzny katalog ubrań z bezpośrednimi odnośnikami do aukcji zewnętrznych, filtrujący oferty pod kątem zgodności z sylwetką kupującego.
* 📊 **Pętla Informacji Zwrotnej (KPI):** Ankieta in-app po 14 dniach monitorująca cel biznesowy: **trafność rekomendacji \\(\ge 85\%\\)**.

---

## 🛠️ Stack Technologiczny

| Warstwa | Technologia | Zastosowanie |
| :--- | :--- | :--- |
| **Frontend (Mobile)** | **Flutter (Dart)** | Wieloplatformowa aplikacja mobilna (Android &amp; iOS), obsługa kamery, nakładanie miarek UI, `flutter_secure_storage`. |
| **Backend API** | **.NET 10 (C#)** | Wydajne REST API, silnik reguł dopasowania (`FitMatchingEngine`), autoryzacja JWT, walidacja RODO. |
| **Baza Danych** | **PostgreSQL** | Relacyjna baza danych przechowująca słowniki wymiarów, konta, metadane skanów oraz oferty. |
| **Computer Vision** | **OpenCV / Python / C#** | Detekcja krawędzi odzieży i arkusza referencyjnego A4, konwersja pikseli na centymetry. |
| **Cloud Storage** | **S3 / MinIO / Blob** | Przechowywanie oryginalnych zdjęć oraz wyeksportowanych grafik z kodami ID. |

---

## 🗄️ Architektura Bazy Danych (Struktura Modułowa)

Baza została zaprojektowana w sposób modularny, rozdzielając proces czystego pomiaru od publikacji e-commerce:

---

## 📂 Struktura Repozytorium

```text
fitcheck/
├── backend/                  # Backend w .NET 10 (Web API)
│   ├── src/
│   │   ├── FitCheck.Api/            # Kontrolery, middleware, konfiguracja
│   │   ├── FitCheck.Core/           # Logika domenowa, algorytm dopasowania (FitScore)
│   │   └── FitCheck.Infrastructure/ # Entity Framework Core, PostgreSQL, repozytoria
│   └── tests/                       # Testy jednostkowe i integracyjne
│
├── mobile/                   # Aplikacja mobilna we Flutterze
│   ├── lib/
│   │   ├── core/                    # Klient HTTP, routing, szyfrowany storage
│   │   ├── features/
│   │   │   ├── auth/                # Logowanie i rejestracja
│   │   │   ├── scanner/             # Aparat, detekcja A4, eksport zdjęcia z kodem
│   │   │   ├── profile/             # Wymiary ciała / ubrań, tryb lokalny vs chmura
│   │   │   ├── marketplace/         # Wyszukiwarka ubrań pasujących do wymiarów
│   │   │   └── settings/            # Ustawienia prywatności, zarządzanie kontem, RODO
│   │   └── main.dart
│   └── test/
│
├── docker/                   # Środowisko lokalne (docker-compose dla PostgreSQL, pgAdmin)
└── docs/                     # Diagramy architektury, specyfikacja API i baza wiedzy
```

---

## ⚡ Szybki Start (Lokalne Uruchomienie)

### Wymagania wstępne

* [.NET 10 SDK]
* [Flutter SDK (v3.22+)]
* [Docker &amp; Docker Compose]

### 1\. Uruchomienie Bazy Danych

W głównym katalogu projektu uruchom kontener PostgreSQL:

```
docker compose -f docker/docker-compose.yml up -d

```

### 2\. Konfiguracja i Start Backendu (.NET)

```
cd backend/src/FitCheck.Api
dotnet restore
dotnet ef database update --project ../FitCheck.Infrastructure
dotnet run

```

API będzie dostępne domyślnie pod adresem: `https://localhost:7001`.

### 3\. Uruchomienie Aplikacji Mobilnej (Flutter)

```
cd mobile
flutter pub get
flutter run

```

---

## 🔒 Prywatność i Bezpieczeństwo (Privacy by Design)

* **Zero-Knowledge Measurements:** Użytkownik może wybrać przechowywanie swoich wymiarów wyłącznie w pamięci telefonu (`LOCAL_ONLY`). Podczas weryfikacji kodu przedmiotu, dane są przetwarzane w locie w pamięci RAM serwera i natychmiast usuwane.
* **Separacja danych C2C:** Sprzedawca widzi jedynie wygenerowany kod oraz swoje ogłoszenie – nigdy nie ma wglądu w to, kto sprawdzał wymiary ani jakie wymiary posiada kupujący.
* **Usuwanie danych (RODO):** Wywołanie usunięcia konta realizuje kaskadowe czyszczenie bazy danych (`ON DELETE CASCADE`), nie pozostawiając powiązań z tożsamością użytkownika.

---
