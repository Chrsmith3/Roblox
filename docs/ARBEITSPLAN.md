# Arbeitsplan: Rollen und Arbeitsprinzip

> Für Menschen **und KIs**. Liest du als KI: Lies dieses Dokument, bevor du ein Feature planst, und halte dich an die Rollen und Verträge. Frage deinen Menschen, wenn etwas deine Rolle oder eine fremde Rolle berührt.
> Stand: 2026-10-21 · Status: **Entwurf, vom Team angenommen**, Zuordnung Person ↔ Rolle noch offen. Bei Änderungen: Entscheidung unten im Log eintragen.

## Beschlossen (Team, 2026-10-20/21)

- Spiel: Simulator mit Zeitaltern von der Steinzeit bis 3000 n. Chr. (open end), dazu PvP als fester Teil. Details: `docs/GDD.md`.
- **PvP-Format A:** Arena-Kampf mit Fähigkeiten (Abklingzeit), Treffer entscheidet immer der Server. Ranked-Matchmaking kommt erst später, v1 ist die Arena im eigenen Server.
- Core Loop: *Sammle Ressourcen deiner Ära, werde stärker und spring in die nächste Epoche. Miss dich in der Arena mit Spielern auf deiner Stufe und hol dir Belohnungen, die es nur dort gibt.*
- Eier nur mit erspielbarer Währung (nie mit Robux kaufbar), Odds immer sichtbar, Pity-Zähler. PvP-Boni aus dem Simulator sind gedeckelt.
- **Design von Anfang an:** Kein graues Graybox, alle Platzhalter nutzen sofort den Style Guide.
- Gestaltung bevorzugt mit **Claude Design** (2D). 3D-Maps, Modelle und Animationen entstehen in Roblox Studio.
- Stufen: Dev → Staging → Live als eigene Experiences. Ablauf: `docs/KI-BRIEFING-DEV-STAGING-LIVE.md`.

## Arbeitsprinzip: nach Features teilen, nicht nach Handwerk

Jede Person besitzt einen **Bereich komplett** (Plan → Code → Optik → Test) und arbeitet mit der eigenen KI daran. So wartet niemand auf andere. Zusammenarbeit läuft über feste Schnittstellen (Verträge unten) und die Teamregeln in `.team/README.md` (eigene Branches, `OFFEN.md`, Review durch eine andere Person).

## Rollen

| Rolle | Person | Verantwortung |
|---|---|---|
| **Look** | _offen_ | Style Guide, UI, Maps, Modelle, Pets (Optik) |
| **Arena & Feel** | _offen_ | PvP-Arena komplett, Animationen, Effekte, Sounds |
| **Kern & Ökonomie** | _offen_ | Simulator-Systeme, Speichern, Zahlen |
| **Producer** (Zusatzhut, ca. 10 % Zeit) | _offen_ | GDD pflegen, Syncs leiten, Playtests, Gruppe/Places/Rechte |

### Look
- **Claude Design (2D):** Style Guide (Farben, Schrift, Formen, Low-Poly-Regeln, Buttons), Moodboards je Ära, UI-Mockups (HUD, Ei mit Odds, Rebirth, Ära-Sprung, Arena-Lobby, Shop), Icons, Pet-Konzepte, später Game-Icon und Thumbnails. Weg zur UI im Spiel: Mockup → Claude-Code-Handoff → Luau-UI mit `UIStyle` und den Komponenten aus `client/UI/Components`.
- **Roblox Studio (3D):** Steinzeit-Map, Ära-2-Map, Ressourcen-Objekte, 6–8 Pets, Arena-Look. Studio-KI-Generierung über das Studio-MCP (Mesh, Material, Textur), Toolbox nur geprüft (Backdoor-Gefahr). Ab Ära 2 immer eine Ära vorausarbeiten.
- **Besitzt:** `Config/UIStyle.luau`, den Style Guide (`docs/style/`), Karten/Modelle.

### Arena & Feel
- Rundenablauf (Beitreten, Countdown, 60–90 s Kampf, Ergebnis), 3 Fähigkeiten mit Abklingzeit, Treffer **serverseitig** geprüft, Belohnung für Teilnahme und Platzierung statt nur für Siege, PvP-Boni aus `StatsService.GetPvPModifiers` mit Deckel.
- Touch-Steuerung für den Kampf (mobile-first).
- Animationen (Angriff, Treffer, Sieg, Sammeln), Effekte, Sounds über `FeedbackController`.
- **Besitzt:** `ArenaService`, `ArenaController`, `Config/Abilities.luau`, Animations-/Sound-IDs in `Config/Assets.luau`.

### Kern & Ökonomie
- Farm-Loop, zwei Währungen (pro Ära + universell), Speichern (ProfileStore), Ära-Sprung, Rebirth, Ei mit Odds + Pity, Pets ausrüsten, Leaderboard, Daily Reward, Game Passes, Analytics-Events.
- Ökonomie-Tabelle (Kosten/Ertrag je Ära, Rebirth-Kurve, Pet-Werte, Pity-Grenze).
- **Besitzt:** `DataService`, `CurrencyService`, `MonetizationService`, Farm-Service (aus `ClickService`), neue `EraService`, `PetService`, `EggService`, `RebirthService`, `StatsService`; `Config/Eras|Pets|Eggs.luau`, `DataTemplate.luau`.

### Producer
GDD pflegen, Ökonomie-Zahlen mit „Kern" abstimmen, `.team/OFFEN.md` im Blick, zwei kurze Syncs pro Woche (15 min), Playtests organisieren, Roblox-Gruppe, Experiences und Rechte verwalten.

## Verträge zwischen den Rollen

1. **Design von Anfang an:** Platzhalter (Blöcke, Pets, UI) nutzen sofort Palette und Formen des Style Guides. Die Logik bleibt von den Modellen getrennt, damit ein Modelltausch nie Code ändert.
2. **Tags statt fester Pfade:** Die Karte spricht mit dem Code über CollectionService-Tags und Attribute, z. B. `Resource` (Attribute `Era`, `ResourceType`), `ArenaSpawn`, `EraPortal` (Attribut `TargetEra`). Look darf die Karte frei umbauen, solange die Tags stimmen.
3. **Zahlen nur in Config:** `Eras`, `Pets`, `Eggs` (Kern), `Abilities` (Arena), `UIStyle` (Look), `Assets` (IDs). Code verweist auf Namen, nie auf rohe IDs.
4. **Schnittstelle Kern ↔ Arena:** `StatsService.GetPvPModifiers(player)` liefert die bereits gedeckelten Boni, z. B. `{ Speed = 0.05, Damage = 0.03 }`. Bis Kern sie liefert, nutzt Arena einen Platzhalter mit derselben Signatur.
5. **Remotes:** Jede Rolle trägt neue Remotes in `Net.luau` in einem eigenen, kommentierten Abschnitt ein (weniger Merge-Konflikte).
6. **Assets unter der Roblox-Gruppe hochladen,** der das Spiel gehört, sonst spielen Animationen im Spiel nicht ab. Bilder gehen durch die Moderation (Wartezeit einplanen).
7. **Studio:** Code nur per Rojo im eigenen Dev-Experience. Karte/Modelle im gemeinsamen Staging (Team Create), Bereich vorher in `OFFEN.md` ansagen. Live wird nur vom Publisher aus Staging überschrieben.
8. **Serverautoritativ:** Der Client schickt nur Absichten. Alle Regeln aus `CLAUDE.md` (Sicherheit, Daten, Monetarisierung) gelten für jede Rolle.

## Wochenplan (Ziel: spielbarer Soft Launch in ca. 3 Wochen, Schule geht vor)

| Woche | Alle | Look | Arena & Feel | Kern & Ökonomie |
|---|---|---|---|---|
| **0** (2–4 Tage) | Kickoff 60 min: Rollen + Verträge beschließen; Praxistest Dev/Staging/Live | Style Guide + Moodboard Steinzeit/Ära 2 | Arena-Konzept (1 Seite: Größe, 3 Fähigkeiten, Treffer-Logik, Deckel) | Ära-/Rebirth-Regel, `DataTemplate` v1, Config-Gerüste, Ökonomie-Tabelle v0 |
| **1** | **Meilenstein:** gemeinsamer Playtest (farmen + eine Arena-Runde, darf hässlich sein) | Steinzeit-Blockout mit Tags, UI-Mockups | Arena-Blockout, 1 Fähigkeit mit Server-Treffer-Prüfung, Runde Start/Ende | Farm-Loop, 2 Währungen, Speichern, `StatsService`-Platzhalter |
| **2** | **Meilenstein:** Weg Steinzeit → Ära 2 spielbar | Steinzeit final, 6–8 Pets, UI-Grafiken, Ära-2-Blockout | 3 Fähigkeiten, PvP-Boni mit Deckel, Animationen, Effekte, Sounds, Touch | Ei + Odds + Pity, Pets, Rebirth, Ära-Sprung, Leaderboard, Daily Reward |
| **3** | Playtest mit 10–20 Freunden (Handy + PC), veröffentlichen, D1/D7 messen | UI final, Game-Icon, Thumbnails, Ära 2 final | Balance, Exploit-Tests, Handy-Test | Game Passes, Analytics, Daten-Tests, Bugfixes |

Wird es eng: Umfang kürzen (z. B. 2 statt 3 Fähigkeiten, 6 statt 8 Pets), nicht den Termin verschieben.
**Nicht in v1:** Ranked-Matchmaking, Skilltree, Event-Shop, Trading, Eier gegen Robux.

## Claude Design: Grenzen
- Kann: Style Guide, UI-Prototypen, Icons, Thumbnails, Handoff an Claude Code. Kann nicht: 3D-Modelle, Roblox-Animationen, Roblox-UI direkt.
- Nutzung zählt gegen die Pro-Limits (Beta, Stand nicht verifiziert): zuerst den Style Guide, dann nur MVP-Screens.
- Jeder hat einen eigenen Account, also kein gemeinsames Design-System. Style Guide als PDF/PNG in `docs/style/` ablegen, damit alle KIs denselben Stil sehen.

## Entscheidungs-Log

| Datum | Entscheidung | Wer |
|---|---|---|
| 2026-10-20 | Analyse-Vorschläge angenommen, PvP-Format A, Core Loop bestätigt | Team |
| 2026-10-21 | Design von Anfang an statt Graybox | Team |
| 2026-10-21 | Dev → Staging → Live als eigene Experiences | Team (Vorschlag Claude, Praxistest offen) |
| offen | Person ↔ Rolle, Publisher für Live, Payout-Split, Budget | Team |
