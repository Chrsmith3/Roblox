# Game Design Document (GDD)

Das ist die "Bibel" des Spiels. Claude baut nach diesem Dokument. Was hier nicht steht, wird nicht gebaut.
Status: **v0.1 (2026-10-22)**. Enthält nur, was das Team beschlossen hat. **OFFEN** = noch zu entscheiden, nicht bauen, bevor es hier steht. Wer was baut: `docs/ARBEITSPLAN.md`.

## 1. Pitch
- **Arbeitstitel:** OFFEN (Platzhalter im Code: `SimulatorGame`)
- **In einem Satz:** Sammle Ressourcen deiner Ära, werde stärker und spring in die nächste Epoche, vom Höhlenmenschen bis in die Zukunft. Miss dich in der Arena mit Spielern auf deiner Stufe und hol dir Belohnungen, die es nur dort gibt.
- **Vorbilder / Referenz-Spiele:** Pet-Simulatoren (Welten mit eigener Währung + universelle Währung), Armdrück-/Stärke-Simulatoren (Simulator + PvP). Kein aktives Spiel mit dem Zeitalter-Thema gefunden (Stand 2026-10-20).
- **Was ist unser Twist?** Die Welten sind **Zeitalter** (Steinzeit bis 3000 n. Chr., open end): Jede neue Ära verändert sichtbar Welt, Ausrüstung und Pets. Dazu PvP als fester Teil: Was du im Simulator sammelst, hilft dir (gedeckelt) in der Arena.

## 2. Core Loop (die 30 Sekunden, die man immer wieder macht)
1. Spieler baut Ressourcen seiner Ära ab (z. B. Steine/Holz in der Steinzeit).
2. bekommt dafür die Ära-Währung.
3. gibt das aus für Upgrades und Eier (Pets).
4. wird dadurch stärker → farmt schneller, springt irgendwann in die nächste Ära → zurück zu 1.

Zweiter Loop (optional, aber lohnend): Arena-Runde (60–90 s) → Belohnung für Teilnahme und Platzierung → PvP-exklusive Belohnungen.

## 3. Progression
- **Währungen:** eine **Ära-Währung** pro Zeitalter (gilt nur dort) + eine **universelle Währung** (bleibt über alle Ären). Namen: OFFEN.
- **Zonen/Welten:** Zeitalter, beginnend mit **Steinzeit (Ära 1)** und **Ära 2** (welche: OFFEN, z. B. Antike). Weitere Ären kommen per Update (open end bis 3000 n. Chr.).
- **Rebirth (Vorschlag, Team bestätigt die Regel in Woche 0):** innerhalb einer Ära; setzt Ära-Währung und Ära-Upgrades zurück, gibt einen dauerhaften Multiplikator.
- **Ära-Sprung (Vorschlag, wie oben):** nach X Rebirths + Kosten in universeller Währung; Pets und universelle Währung bleiben erhalten. X und Kosten: OFFEN (Ökonomie-Tabelle).
- **Upgrades:** OFFEN (Ökonomie-Tabelle).
- **Skilltree:** nicht in v1. Später **ein** Baum, jede Ära schaltet einen Ast mit 3–5 Knoten frei; Fähigkeiten wirken auch im PvP.
- **Tycoon-/Idle-Basis:** nicht geplant.

## 4. Sammel-System (Pets)
- **Was sammelt man?** Pets. Jedes Pet hat zwei Wirkungen: einen **Farm-Bonus** im Simulator und einen **PvP-Bonus** in der Arena (z. B. Farm +5 % → PvP +5 % Tempo). PvP-Boni sind insgesamt **gedeckelt** (Richtwert max. 15–20 %, genaue Zahl OFFEN).
- **Seltenheiten:** OFFEN (Vorschlag: Common, Rare, Epic, Legendary, Mythic).
- **Wie bekommt man sie?** Eier. Prinzip „sicher oder Glück“: entweder ein festes Upgrade kaufen oder ein Ei öffnen.
- **Ei-Regeln (beschlossen):**
  - Alle möglichen Ergebnisse mit Prozent-Odds **vor** dem Öffnen anzeigen, Summe 100 %.
  - **Pity-Zähler:** nach N Öffnungen ohne seltenes Pet ist eins garantiert; Zähler sichtbar, serverseitig gespeichert. N: OFFEN.
  - **Bis das Team die Ei-Währung festlegt:** Eier wie Paid Random Items behandeln, also zusätzlich `MonetizationService.CanBuyPaidRandomItems(player)` prüfen und sonst eine Alternative anbieten. Grund: Ein Ei zählt laut Roblox auch dann als Paid Random Item, wenn die Währung (auch indirekt) für Robux kaufbar ist. Entscheidung (a) Ei-Währung nie als Paket kaufbar, oder (b) sichere Regel beibehalten: OFFEN (siehe `docs/ARBEITSPLAN.md`, Vertrag 9).
- **MVP:** 1 Ei mit 6–8 Pets.
- **Equip-Slots, Fusion, Trading?** Slots: OFFEN. Fusion: nicht in v1. Trading: nicht in v1 (Scam-Moderation).

## 5. Social
- **PvP: Format A, Arena-Kampf mit Fähigkeiten.**
  - Runde: Beitreten → Countdown → 60–90 s Kampf → Ergebnis.
  - 1v1 oder Jeder-gegen-jeden: OFFEN (Arena-Konzept in Woche 0).
  - Fähigkeiten mit Abklingzeit (MVP: 3, notfalls 2), eher Projektil/Fläche als präziser Nahkampf. **Der Server entscheidet jeden Treffer.**
  - Touch-Buttons für Fähigkeiten (mobile-first).
  - Belohnung für **Teilnahme und Platzierung**, nicht nur für Siege; abnehmende Belohnung gegen denselben Gegner (gegen Absprachen/Zweitaccounts).
  - PvP ist optional, aber lohnend. PvP-exklusive Belohnungen eher Kosmetik/Titel/PvP-Pets mit gleichwertigem (nicht besserem) Farm-Wert. Genaue Belohnungen: OFFEN.
  - v1: Arena **im eigenen Server**. Ranked mit Skill-Matchmaking erst später, wenn genug Spieler da sind.
- **Leaderboards:** 1 Leaderboard in v1 (welche Größe: OFFEN).
- **Server-weite Events:** später (Phase 2).

## 6. Retention (damit Spieler wiederkommen)
- Daily Rewards / Streaks: **Daily Reward in v1.**
- Quests (täglich/wöchentlich): später.
- Codes: später.
- Zeitlich begrenzte Events: später (z. B. Währung pro Sekunde/gefarmtem Element während des Events). Kein manipulatives Design (keine FOMO-Timer, keine Casino-Optik).
- Offline-Earnings: nicht geplant.
- Daily-/Event-Shop: später.

## 7. Monetarisierung
Nur offizielle Wege (Game Passes, Developer Products). Preise nie im Code. Produkt-IDs pro Stufe (Dev/Staging/Live), siehe Arbeitsplan Vertrag 8.

| Typ | Name | Was es bringt | Preis-Idee (Robux) |
|---|---|---|---|
| Gamepass | 2× Währung | verdoppelt Farm-Ertrag | OFFEN |
| Gamepass | Auto-Farm | farmt automatisch | OFFEN |
| Gamepass | +1 Pet-Slot | ein Pet mehr ausrüsten | OFFEN |
| Dev Product | Währungspakete | **nur zulässig für eine Währung, mit der man keine Eier kaufen kann**, solange Entscheidung (a)/(b) offen ist | OFFEN |
| Abo | — | nicht in v1 | — |

Kein Pay-to-win in der Arena: gekaufte Boni zählen dort nur im Rahmen des PvP-Deckels. Luck-Boosts für Robux: nicht in v1.

## 8. Look & Feel
- **Stil:** Low-Poly/Cartoon, jede Ära mit eigener Farbwelt. **Design von Anfang an:** Platzhalter nutzen sofort den Style Guide. Style Guide entsteht in Woche 0 in Claude Design und liegt dann in `docs/style/`.
- **UI-Referenzen:** OFFEN (Mockups aus Claude Design).
- **Sounds/Musik:** OFFEN. Nur eigene oder lizenzfreie, keine fremden Marken/Musik.

## 9. Launch-Umfang (Version 1)
- **Was MUSS rein:** Steinzeit komplett + Ära 2 als Ziel, Farm-Loop, 2 Währungen, Speichern, 1 Ei (6–8 Pets, Odds, Pity), Pets ausrüsten, Rebirth, Ära-Sprung, Arena im eigenen Server (2–3 Fähigkeiten), 1 Leaderboard, Daily Reward, 2–3 Game Passes, Analytics-Events (Ära-Sprung, Rebirth, Arena-Teilnahme, Käufe).
- **Was kommt später (Updates):** Ära 3+, Skilltree, Ranked-Matchmaking + Saisons, Daily-/Event-Shop, Events, Quests, Codes. Trading und Robux-Eier vorerst gar nicht.
- **Erfolgsmessung:** D1, D7, Ø Session, Anteil mit Arena-Runde, Anteil mit Ära-Sprung, Kaufrate. Richtwert D1 ab ca. 20–25 %.

## 10. Entscheidungen (Log)
| Datum | Entscheidung | Wer |
|---|---|---|
| 2026-10-20 | Thema Zeitalter-Simulator mit PvP; Vorschläge der Konzept-Analyse angenommen | Team |
| 2026-10-20 | PvP-Format A (Arena-Kampf mit Fähigkeiten), Core Loop bestätigt | Team |
| 2026-10-21 | Design von Anfang an statt graues Graybox | Team |
| 2026-10-22 | Eier bis zur Entscheidung wie Paid Random Items behandeln; Produkt-IDs pro Stufe | Team (Hinweis Christophers KI) |
