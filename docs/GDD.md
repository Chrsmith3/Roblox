# Game Design Document (GDD)

Das ist die "Bibel" des Spiels. Claude baut nach diesem Dokument. Was hier nicht steht, wird nicht gebaut.
Status: **v0.2 (2026-10-22), Wirtschaft v3**. Enthält nur, was das Team beschlossen hat. **OFFEN** = noch zu entscheiden, nicht bauen, bevor es hier steht. Wer was baut: `docs/ARBEITSPLAN.md`. Wirtschaft, Währungen, Belohnungen, Monetarisierung im Detail: `docs/WIRTSCHAFT.md` (verbindlich).

## 1. Pitch
- **Arbeitstitel:** OFFEN (Platzhalter im Code: `SimulatorGame`)
- **In einem Satz:** Trainiere Kraft, besiege Bosse deiner Ära und spring in die nächste Epoche, vom Höhlenmenschen bis in die Zukunft. Miss dich in der Arena mit Spielern auf deiner Stufe und hol dir Belohnungen, die es nur dort gibt.
- **Vorbilder / Referenz-Spiele:** Pet-Simulatoren, Armdrück-/Stärke-Simulatoren (Simulator + PvP). Bosse-Grind: Arm Wrestle Simulator, Gym League. PvE↔PvP-Brücke: Blox Fruits. Fairer PvP-Kontrast: Rivals. Kein aktives Spiel mit dem Zeitalter-Thema gefunden (Stand 2026-10-20).
- **Was ist unser Twist?** Die Welten sind **Zeitalter** (Steinzeit bis 3000 n. Chr., open end): Jede neue Ära verändert sichtbar Welt, Ausrüstung und Pets. Dazu PvP als fester Teil: Was du im Simulator sammelst, hilft dir (gedeckelt) in der Arena.

## 2. Core Loop (die 30 Sekunden, die man immer wieder macht)
1. Spieler **trainiert** (klickt/schlägt an Trainings-Objekten seiner Ära) und baut **Kraft** auf.
2. Mit genug Kraft besiegt er **Bosse** (3 pro Ära) und bekommt **Trophäen** und **Kristalle**.
3. Er gibt aus: Trophäen für **Eier/Pets** und den **Ära-Sprung**, Kristalle für **Waffen, Fähigkeiten, Attribute (später Skilltree)**.
4. Er wird stärker → stärkere Bosse, nächste Ära → zurück zu 1.

Zweiter Loop (optional, aber lohnend): **Arena-Runde** (60–90 s) → Trophäen und Kristalle für Teilnahme und Platzierung → PvP-Meilensteine. **Bosse und Arena nutzen dasselbe Kampfsystem**, Bosse sind das Training fürs PvP.

## 3. Progression
- **Wert:** **Kraft** (keine Währung): Training; gegen Bosse voll wirksam, in der Arena abgeflacht und gedeckelt.
- **Währungen (Arbeitsnamen):**
  - **Trophäen:** nur erspielt (Bosse, Arena), bezahlen Eier, festes Pet im Shop, Ära-Sprung. **Nie mit Robux kaufbar** (Option a, Team-Entscheid 2026-10-22). Kein Umtausch Kristalle → Trophäen.
  - **Kristalle:** erspielt **und** mit Robux kaufbar, bezahlen Waffen, Fähigkeiten, Attribute (später Skilltree), Umskillen. Nur deterministische Käufe, keine Kisten.
- **Zonen/Welten:** Zeitalter, beginnend mit **Steinzeit (Ära 1)** und **Ära 2** (welche: OFFEN, z. B. Antike). Weitere Ären per Update (open end bis 3000 n. Chr.). Pro Ära 3 Bosse (klein, mittel, Ära-Boss).
- **Ära-Sprung (Vorschlag, Team bestätigt Details):** Ära-Boss besiegt + X Trophäen. Pets, Trophäen, Kristalle und Skilltree bleiben. X: OFFEN.
- **Rebirth (Vorschlag):** setzt Kraft und Trainings-Werkzeuge zurück, gibt dauerhaft +X % Kraft. X: OFFEN.
- **Upgrades:** Trainings-Werkzeuge schalten sich bei Kraft-Schwellen frei (keine Währung). Waffen/Fähigkeiten/Attribute kosten Kristalle.
- **Skilltree:** vollständig erst als Ausbau (ein Baum, jede Ära schaltet einen Ast mit 3–5 Knoten frei). v1: Kristalle kaufen Waffen, Fähigkeiten und Attribute als einfache Liste.
- **Alle Zahlen** (Belohnungen, Kosten, Raten, Zielzeit ohne Kauf 5–7 Tage bis zum vollen Build einer Ära, mit Kauf 2–3 Tage): OFFEN, Ökonomie-Tabelle.
- **Tycoon-/Idle-Basis:** nicht geplant.

## 4. Sammel-System (Pets)
- **Was sammelt man?** Pets. Jedes Pet hat einen **Farm-Bonus** (z. B. mehr Kraft pro Klick) und einen **PvP-Bonus** in der Arena. Alle PvP-Boni zusammen (Pets, Skilltree, Waffen, Fähigkeiten, Kraft, Boosts) sind **gedeckelt** (Richtwert ca. +20 %, Zahl OFFEN).
- **Seltenheiten:** OFFEN (Vorschlag: Common, Rare, Epic, Legendary, Mythic).
- **Wie bekommt man sie?** Mit **Trophäen**: **Ei** öffnen (Glück) oder **festes Pet im Shop** kaufen (sicher, teurer als ein Ei).
- **Ei-Regeln (beschlossen):**
  - Alle möglichen Ergebnisse mit Prozent-Odds **vor** dem Öffnen anzeigen, Summe 100 %.
  - **Pity-Zähler:** nach N Öffnungen ohne seltenes Pet ist eins garantiert; Zähler sichtbar, serverseitig gespeichert. N: OFFEN.
  - Da Trophäen nie mit Robux kaufbar sind, ist ein Ei **kein** Paid Random Item. Odds zeigen wir trotzdem. Würde je eine ei-bezogene Währung kaufbar, gilt der Policy-Check `MonetizationService.CanBuyPaidRandomItems` (zuerst im Team klären).
- **MVP:** 1 Ei mit 6–8 Pets.
- **Equip-Slots:** OFFEN. Fusion: nicht in v1. Trading: nicht in v1 (Scam-Moderation).

## 5. Social
- **PvP: Format A, Arena-Kampf mit Fähigkeiten** (dasselbe Kampfsystem wie die Boss-Kämpfe).
  - Runde: Beitreten → Countdown → 60–90 s Kampf → Ergebnis.
  - 1v1 oder Jeder-gegen-jeden: OFFEN (Arena-Konzept in Woche 0).
  - Fähigkeiten mit Abklingzeit, **3 Fähigkeiten-Slots** (MVP: 3, notfalls 2), eher Projektil/Fläche als präziser Nahkampf, viele Fähigkeiten sind Sidegrades. **Der Server entscheidet jeden Treffer.**
  - Touch-Buttons für Fähigkeiten (mobile-first).
  - Belohnung für **Teilnahme und Platzierung** (Trophäen + kleine Menge Kristalle), nicht nur für Siege; volle Belohnung nur gegen ähnlich Starke, abnehmend gegen denselben Gegner.
  - **PvP-Meilensteine** statt eigener PvP-Währung (z. B. 10/50/200 Siege → Titel, Aura, PvP-Pet mit gleichem Farm-Wert wie Ei-Pets).
  - PvP ist optional, aber lohnend: etwas höhere Rate für gute Spieler. Genaue Belohnungen: OFFEN.
  - **Kein Pay-to-win:** gekaufte Stärke wirkt in der Arena nur innerhalb des Deckels (`docs/WIRTSCHAFT.md`, Abschnitt 5).
  - v1: Arena **im eigenen Server**. Ranked mit Skill-Matchmaking später, wenn genug Spieler da sind.
- **Leaderboards:** 1 Leaderboard in v1 (welche Größe: OFFEN).
- **Server-weite Events:** später (Phase 2).

## 6. Retention (damit Spieler wiederkommen)
- Daily Rewards / Streaks: **Daily Reward in v1** (gibt auch Kristalle).
- Quests: **3 tägliche Quests in v1** (Kristalle), wöchentliche später.
- Erfolge (einmalig, z. B. Ära erreicht): Kristalle.
- Codes: später.
- Zeitlich begrenzte Events: später (z. B. Währung pro Sekunde/gefarmtem Element während des Events). Kein manipulatives Design (keine FOMO-Timer, keine Casino-Optik).
- Offline-Earnings: nicht geplant.
- Daily-/Event-Shop: später.

## 7. Monetarisierung
Verbindlich und ausführlich: `docs/WIRTSCHAFT.md`. Nur offizielle Wege (Game Passes, Developer Products). Preise nie im Code. Produkt-IDs pro Stufe (Dev/Staging/Live), Arbeitsplan Vertrag 8.

| Typ | Name | Was es bringt | Preis-Idee (Robux) |
|---|---|---|---|
| Gamepass | VIP | +50 % Kraft, Chat-Tag | OFFEN (Richtwert 250–350) |
| Gamepass | 2× Kraft | verdoppelt Kraft aus Training | OFFEN |
| Gamepass | Auto-Training | trainiert automatisch | OFFEN |
| Gamepass | +1 / +2 Pet-Slots | mehr Pets gleichzeitig | OFFEN |
| Gamepass | 3 Eier auf einmal | spart Zeit, Odds unverändert | OFFEN **[prüfen, Policy]** |
| Dev Product | **Kristall-Pakete** (Stufen) | Kristalle für Waffen/Fähigkeiten/Attribute | OFFEN |
| Dev Product | Zeit-Boosts | 2× Kraft / 2× Kristalle für 30 min | OFFEN |
| Kosmetik (Update 1) | Auren, Trails, Emotes | nur Optik, direkt kaufbar, keine Kisten | OFFEN |
| Abo / Season Pass | — | später | — |

**Nicht erlaubt:** Trophäen-Pakete, Trophäen-Boosts, Umtausch Kristalle → Trophäen, Robux-Eier, Kisten. Nichts ist nur per Robux erhältlich (außer Kosmetik). Keine FOMO-Timer, keine Casino-Optik.

## 8. Look & Feel
- **Stil:** Low-Poly/Cartoon, jede Ära mit eigener Farbwelt. **Design von Anfang an:** Platzhalter nutzen sofort den Style Guide. Style Guide entsteht in Woche 0 in Claude Design und liegt dann in `docs/style/`.
- **UI-Referenzen:** OFFEN (Mockups aus Claude Design).
- **Sounds/Musik:** OFFEN. Nur eigene oder lizenzfreie, keine fremden Marken/Musik.

## 9. Launch-Umfang (Version 1)
- **Was MUSS rein:** Steinzeit komplett + Ära 2 als Ziel, Training/Kraft, Bosse (3 pro Ära), Trophäen + Kristalle, Speichern, 1 Ei (6–8 Pets, Odds, Pity) + festes Pet im Shop, Pets ausrüsten, Kristall-Shop (Waffen, Fähigkeiten, Attribute), Rebirth, Ära-Sprung, ein Kampfsystem für Bosse und Arena, Arena im eigenen Server (2–3 Fähigkeiten, PvP-Deckel), 1 Leaderboard, Daily Reward + 3 tägliche Quests, 2–3 Game Passes + Kristall-Pakete, Analytics-Events (Boss-Sieg, Ära-Sprung, Rebirth, Arena-Teilnahme, Käufe).
- **Was kommt später (Updates):** Ära 3+, vollständiger Skilltree, Ranked-Matchmaking + Saisons, Season Pass, Kosmetik, Daily-/Event-Shop, Events, wöchentliche Quests, Codes. Trading, Kisten und Robux-Eier vorerst gar nicht.
- **Erfolgsmessung:** D1, D7, Ø Session, Anteil mit Boss-Sieg, Anteil mit Arena-Runde, Anteil mit Ära-Sprung, Kaufrate, Zeit bis zum vollen Build ohne Kauf. Richtwert D1 ab ca. 20–25 %.

## 10. Entscheidungen (Log)
| Datum | Entscheidung | Wer |
|---|---|---|
| 2026-10-20 | Thema Zeitalter-Simulator mit PvP; Vorschläge der Konzept-Analyse angenommen | Team |
| 2026-10-20 | PvP-Format A (Arena-Kampf mit Fähigkeiten), Core Loop bestätigt | Team |
| 2026-10-21 | Design von Anfang an statt graues Graybox | Team |
| 2026-10-22 | Produkt-IDs pro Stufe | Team (Hinweis Christophers KI) |
| 2026-10-22 | **Option (a):** Ei-Währung (Trophäen) nie mit Robux kaufbar | Team |
| 2026-10-22 | Wirtschaft v3: Kraft, Trophäen (nur erspielt), Kristalle (erspielt + kaufbar); Bosse und Arena mit demselben Kampfsystem; PvP-Deckel; Details `docs/WIRTSCHAFT.md` | Team (Vorschlag Claude, Review Christopher offen) |
