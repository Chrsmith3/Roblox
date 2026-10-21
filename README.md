# SimulatorGame (Arbeitstitel)

Roblox-Simulator von Christopher, Julius und Gregor – gecodet mit Claude.

- **Regeln für Code & KI:** `CLAUDE.md`
- **Spielidee & Design:** `docs/GDD.md`

## Schnell testen (ohne Einrichtung)

`SimulatorGame.rbxl` per Doppelklick in Roblox Studio öffnen → **Play**. Du siehst die Coin-Anzeige oben links und einen KLICK-Button. Jeder Klick gibt Coins (mit Animation und "+1"). Ausgabe-Fenster (View → Output) zeigt "[Server] 4 Services gestartet" und "[Client] 3 Controller gestartet".
Diese Datei ist nur ein Schnappschuss – richtig gearbeitet wird mit Rojo (unten).

## Einmalige Einrichtung (pro Person, Mac)

Terminal öffnen und in diesen Ordner wechseln (Anführungszeichen wegen des Leerzeichens im Namen):

```bash
cd ~/Desktop/"Roblox "
```

1. **Rokit installieren** (verwaltet die Tools, alle haben dieselben Versionen):
   ```bash
   curl -sSf https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.sh | bash
   ```
   Danach Terminal neu öffnen.

2. **Tools installieren** (Rojo, StyLua, Selene – Versionen stehen in `rokit.toml`):
   ```bash
   rokit install
   ```
   Wenn gefragt wird, ob du den Tools vertraust: mit `y` bestätigen.

3. **Rojo-Plugin für Studio installieren:**
   ```bash
   rojo plugin install
   ```
   Danach Roblox Studio neu starten.

## Täglich arbeiten

1. Roblox Studio öffnen, **dein eigenes Dev-Experience** öffnen (Name steht in deiner `CLAUDE.local.md`). Nicht das gemeinsame Team-Create-Spiel.
2. Im Terminal in diesem Ordner:
   ```bash
   rojo serve
   ```
3. In Studio: Plugins-Tab → **Rojo** → **Connect**. Ab jetzt landet jede Code-Änderung sofort in Studio.
4. Play drücken und testen.

**Wichtig im Team:** Rojo verbindest du nur mit deinem eigenen Dev-Experience. Ins gemeinsame Staging (Team Create) synchronisiert nur, wer in `.team/OFFEN.md` unter „Studio“ die Zeile `Rojo-Sync: <kürzel>` hält. Code-Stand teilt ihr über GitHub, die Map über Team Create. Regeln: `.team/README.md`.

## Einmalig fürs Spiel (macht eine Person)

1. In Studio: **File → Publish to Roblox** – am besten unter einer **Roblox-Gruppe** (dann laufen die Einnahmen über die Gruppe und lassen sich aufteilen).
2. **Home → Game Settings → Security → "Enable Studio Access to API Services"** an (sonst wird in Studio nicht gespeichert).
3. **Collaborate** aktivieren und die anderen einladen.
4. Optional: Claude mit dem **eingebauten Studio-MCP-Server** verbinden, damit Claude Playtests starten und die Konsole lesen kann. Anleitung: https://create.roblox.com/docs/studio/mcp

## GitHub

1. Repo klonen und die Einrichtung oben machen. Persönliche KI-Einstellungen: `.team/_claude-local-vorlage.md` nach `CLAUDE.local.md` kopieren und ausfüllen (wird nicht committet).
2. Ein Branch pro Feature: `<kürzel>/<feature>` (`chris`, `julius`, `gregor`), nie direkt auf `main`.
3. Merge nach `main` per Pull Request mit Approval einer anderen Person. Der komplette Ablauf für Mensch und KI steht in `.team/README.md`.

## Prüfen vor dem Commit

```bash
stylua src      # formatiert den Code
selene src      # findet Fehler und schlechte Muster
```

## Was schon drin ist

| Bereich | Datei | Was es macht |
|---|---|---|
| Start | `src/server/init.server.luau`, `src/client/init.client.luau` | Lädt automatisch alle Services/Controller |
| Speichern | `Services/DataService.luau` | ProfileStore, Session-Lock, Sync zum Client |
| Währungen | `Services/CurrencyService.luau` | Coins/Gems, Multiplikatoren, Leaderstats |
| Shop-Technik | `Services/MonetizationService.luau` | Gamepässe, sichere Developer-Product-Käufe, Policy-Checks für Robux-Eggs |
| Demo-Loop | `Services/ClickService.luau` | Klicken → Coins (mit Anti-Spam), wird später ersetzt |
| Client-Daten | `Controllers/DataController.luau` | Spielstand auf dem Client, `Observe()` für UI |
| UI | `Controllers/UIController.luau` | HUD, Skalierung für Handy, Toast-Meldungen |
| Game Feel | `Controllers/FeedbackController.luau` | Sounds, Pop, FloatingText, Kamera-Shake, Vibration |
| Komponenten | `UI/Components/` | Button, Währungsanzeige |
| Einstellungen | `src/shared/Config/` | Balancing, Produkt-IDs, UI-Styleguide |

ProfileStore © loleris, Apache-2.0 (`packages/licenses/`).
