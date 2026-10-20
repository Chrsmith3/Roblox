# CLAUDE.md – Regeln für die KI (und für uns)

Diese Datei liest Claude bei jeder Session zuerst. Alles hier gilt für jeden Code im Projekt.
Team: Christopher, Julius, Gregor. Sprache: Deutsch. Code-Namen auf Englisch, Kommentare auf Deutsch.

## Projekt
- Roblox-Simulator (Thema/Core Loop: siehe `docs/GDD.md`). Ziel: mobile-first, server-autoritativ, monetarisierbar.
- Code wird mit **Rojo** aus `src/` nach Studio synchronisiert. **Die Dateien sind die Wahrheit** – nie Skripte direkt in Studio ändern.
- Map, Modelle und Animationen leben in Studio (Team Create), nicht im Git.

## Ordnerstruktur
```
src/server/            -> ServerScriptService.Server   (nur Server)
  init.server.luau        Startet alle Services
  Services/               Ein Service pro System (DataService, CurrencyService, ...)
  Util/                   Server-Helfer (RateLimiter)
src/client/            -> StarterPlayerScripts.Client  (nur Client)
  init.client.luau        Startet alle Controller
  Controllers/            Ein Controller pro System (DataController, UIController, ...)
  UI/Components/          Wiederverwendbare UI-Bausteine (Button, CurrencyDisplay)
src/shared/            -> ReplicatedStorage.Shared     (Client + Server)
  Config/                 GameConfig, Products, UIStyle – ALLE Zahlen/Farben/IDs hier
  DataTemplate.luau       Standard-Spielstand
  Net.luau                Liste aller Remotes
  Util/                   Signal, Format
packages/server/       -> ServerStorage.ServerPackages (ProfileStore)
```

## Architektur-Regeln
1. **Service/Controller-Muster**: Jedes Modul ist eine Tabelle mit `Name`, optional `Priority`, `Init()` und `Start()`. Neue Datei in `Services/` bzw. `Controllers/` wird automatisch geladen.
2. **Kein zirkuläres require.** Wenn A B braucht und B A: Hook/Signal nutzen (Beispiel: `CurrencyService.RegisterMultiplier`).
3. **Daten nur über DataService** ändern (`Set`, `Update`), nie `profile.Data` direkt aus anderen Services – sonst bekommt der Client die Änderung nicht.
4. Auf geladene Spieler reagieren immer mit `DataService.OnPlayerLoaded(fn)`.
5. **Konfiguration statt Magic Numbers**: Balancing-Werte in `GameConfig`, Farben/Timings in `UIStyle`, IDs in `Products`.
6. `--!strict` in jeder Datei, Typen für öffentliche Funktionen.

## Sicherheit (Simulatoren werden ständig gehackt)
- **Der Client ist ein Feind.** Er schickt nur Absichten ("ich will kaufen"), nie Werte ("gib mir 1000 Coins").
- Jedes `OnServerEvent`/`OnServerInvoke`: Typen prüfen, Wertebereich prüfen, **RateLimiter** nutzen.
- Distanz-Checks für Interaktionen in der Welt (Spieler muss wirklich am Objekt stehen).
- Keine Free Models mit Skripten ungeprüft einfügen (Backdoors).

## Daten
- ProfileStore mit Session-Lock. `GameConfig.Data.StoreName` **nie ändern** nach Release.
- Felder im `DataTemplate` nie umbenennen/löschen nach Release – neues Feld + Migration.
- Developer Products laufen über `MonetizationService` (PurchaseId-Cache, erst bestätigen wenn gespeichert).

## Monetarisierung (Roblox-Regeln)
- **Preise nie im Code** – immer live von `MarketplaceService` holen (Managed Pricing / regionale Preise).
- **Paid Random Items** (Robux-Eggs, Spins, auch mit Robux-kaufbarer Währung): alle Ergebnisse mit %-Chance VOR dem Kauf anzeigen (Summe 100 %), Luck-Boosts numerisch erklären, `MonetizationService.CanBuyPaidRandomItems(player)` prüfen und sonst eine Alternative anbieten (direkter Kauf, freier Weg, oder sperren).
- Trading von bezahlten Items nur wenn `MonetizationService.CanTradePaidItems(player)`.
- R15-Avatare verwenden.

## UI & Game Feel
- Mobile-first: Buttons min. `UIStyle.Sizes.MinTouchTarget`, nichts in Ecken, die vom Daumen verdeckt sind.
- Nur Komponenten aus `client/UI/Components` verwenden, nur Werte aus `UIStyle`.
- **Jede Aktion braucht Feedback** über `FeedbackController`: Sound + Animation (Pop/Tween) + ggf. FloatingText, CameraShake, Haptic.
- Belohnungs-Feedback erst zeigen, wenn der Server bestätigt hat (über `DataController.Observe`).

## Teamarbeit (zuerst lesen)
Drei Personen arbeiten gleichzeitig mit eigenen KIs. **Vor jeder Arbeit `.team/README.md` lesen und befolgen** (Session-Start, eigene Branches, eigener Team-Ordner, `OFFEN.md`, Session-Ende). Persönliche Einstellungen stehen in `CLAUDE.local.md` (nicht im Git).

## Arbeitsweise mit Claude
- Ein Feature pro Session: erst Plan, dann Code (Server + Client + UI), dann Testanleitung.
- Nach jedem funktionierenden Schritt: Commit auf dem eigenen Branch (siehe `.team/README.md`).
- Neue Remotes in `Net.luau` eintragen, neue Daten in `DataTemplate.luau`.
- Vor Abgabe: `selene src` und `stylua src` ohne Fehler.
