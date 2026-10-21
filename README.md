# Symulacja magazynu – hurtownia farmaceutyczna

Współbieżna symulacja hurtowni leków napisana w Adzie (zadania / `task`).
Samochody dostawcze zgłaszają się na rampę, roboty przewożą partie towaru
do magazynu, a szpitale (zamówienia pilne) i apteki (zamówienia zwykłe)
składają zamówienia. Monitor okresowo raportuje stan magazynu i robotów.

Autorzy: Eryk Marszałkowski, Bartek Kot, Grzegorz Zorn

## Wymagania

Projekt jest budowany przez **Alire** (`alr`), menedżer pakietów Ady. Alire
sam pobiera kompilator **GNAT** i narzędzie **gprbuild**, więc nie trzeba ich
instalować ręcznie.

Sprawdzone wersje:

| Narzędzie   | Wersja  |
|-------------|---------|
| Alire       | 2.1.1   |
| GNAT native | 16.1.0  |
| gprbuild    | 26.0.1  |

Starsze wersje (GNAT ≥ 12) też powinny zadziałać.

### Instalacja Alire

Pobierz Alire ze strony <https://alire.ada.dev> lub z
<https://github.com/alire-project/alire/releases>:

- **macOS** – pobierz `alr-<wersja>-bin-<arch>-macos.zip` (`aarch64` dla Apple
  Silicon, `x86_64` dla Intela), rozpakuj i przenieś `bin/alr` do katalogu w
  `PATH`, np. `~/.local/bin`:
  ```bash
  mkdir -p ~/.local/bin
  cp bin/alr ~/.local/bin/
  # jeśli macOS blokuje plik pobrany z internetu:
  xattr -d com.apple.quarantine ~/.local/bin/alr
  ```
  Upewnij się, że `~/.local/bin` jest w `PATH` (np. w `~/.zshrc`:
  `export PATH="$HOME/.local/bin:$PATH"`).
- **Linux** – pobierz `alr-<wersja>-bin-x86_64-linux.zip` (albo AppImage),
  rozpakuj i dodaj `bin/alr` do `PATH`.
- **Windows** – pobierz i uruchom instalator `alr-<wersja>-installer-x86_64-windows.exe`.
  Instaluje on również środowisko MSYS2 potrzebne do kompilacji.

Sprawdź instalację:

```bash
alr version
```

### Wybór kompilatora (tylko za pierwszym razem)

Przy pierwszym buildzie Alire zapyta o toolchain – wybierz domyślne
`gnat_native` i `gprbuild`. Można to też zrobić ręcznie:

```bash
alr toolchain --select
```

## Budowanie

```bash
git clone https://github.com/zereq/ada_projekt.git
cd ada_projekt
alr build
```

Pierwszy build pobiera kompilator, więc może potrwać kilka minut.
Plik wykonywalny trafia do `bin/ada_project`.

Katalogi `config/`, `obj/`, `bin/` i `alire/` są generowane przez Alire i nie
są w repozytorium. Dlatego samo `gprbuild` na świeżo sklonowanym repo się nie
uda (brak `config/ada_project_config.gpr`) – zawsze buduj przez `alr build`.

Build w trybie release (z optymalizacjami):

```bash
alr build --release
```

## Uruchamianie

```bash
alr run
```

albo bezpośrednio:

```bash
./bin/ada_project          # macOS / Linux
bin\ada_project.exe        # Windows
```

Program wypisuje kolorowy log zdarzeń (kody ANSI) z polskimi znakami (UTF-8).
Najlepiej uruchamiać go w terminalu, który obsługuje oba – np. Terminal/iTerm2
na macOS, dowolny terminal na Linuxie, Windows Terminal na Windowsie.
W starym `cmd.exe` mogą pojawić się „krzaki” zamiast kolorów i polskich liter
(pomaga `chcp 65001`).

Symulacja kończy się sama po rozładowaniu wszystkich dostaw i realizacji
zamówień, wypisując raport końcowy.

## Konfiguracja symulacji

Parametry symulacji są stałymi w [src/typy.ads](src/typy.ads), m.in.:

| Stała                 | Znaczenie                                   |
|-----------------------|---------------------------------------------|
| `liczba_samochodow`   | liczba dostaw                               |
| `liczba_robotow`      | liczba robotów transportowych               |
| `liczba_szpitali`     | liczba szpitali (zamówienia pilne)          |
| `liczba_aptek`        | liczba aptek (zamówienia zwykłe)            |
| `pojemnosc_magazynu`  | maksymalna liczba sztuk w magazynie         |
| `pojemnosc_rampy`     | ile dostaw może czekać na rampie            |
| `okres_raportu`       | co ile sekund monitor wypisuje raport       |
| `Tempo`               | mnożnik czasu – większa wartość = wolniejsza symulacja |

Po zmianie wystarczy ponownie `alr build` (lub od razu `alr run`, który
przebudowuje projekt).

## Struktura projektu

| Plik / moduł        | Opis                                                     |
|---------------------|----------------------------------------------------------|
| `ada_project.adb`   | program główny – uruchamia wszystkie zadania             |
| `typy`              | typy danych i stałe konfiguracyjne                       |
| `dostawy`           | samochody dostawcze zgłaszające się na rampę             |
| `rozladunek`        | rampa – kolejka dostaw dzielonych na partie              |
| `transport`         | roboty przewożące partie z rampy do magazynu             |
| `magazynowanie`     | magazyn – przyjmowanie towaru i realizacja zamówień      |
| `klienci`           | szpitale i apteki składające zamówienia                  |
| `nadzor`            | monitor – raporty okresowe i raport końcowy              |
| `log`               | kolorowe, bezpieczne wątkowo wypisywanie na konsolę      |
| `losowe`            | pomocnicze funkcje losujące                              |
