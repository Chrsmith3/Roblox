# Wirtschaft v4 nach Review — chris, 2026-10-22
**Branch:** chris/wirtschaft-v4 (basiert auf julius/dev-staging-live-briefing) · **Commit/PR:** PR folgt

**Gemacht:** Review von Wirtschaft v3 eingearbeitet in `docs/WIRTSCHAFT.md` (v4), `docs/GDD.md` (v0.3) und `docs/ARBEITSPLAN.md`: Bosskampf als Mischung (Kraft = Grundschaden, Fähigkeiten = Extra), Rebirth innerhalb der Ära + Ära-Sprung mit Mindest-Rebirths und Kraft-Reset, Auto-Training gibt nur Kraft, Policy-Check beim Ei immer aktiv (Pet-Shop als Alternative), neu in v1: Codes, Einladen- und Gruppen-Belohnung, Starter-Pack, Server-Boost, Leaderboard Ära + Rebirths. Content-Dauer/Update-Rhythmus und PvP-Deckel-Reihenfolge ergänzt.
**Testen:** Docs lesen. Kein Code, nichts in Studio.
**Offen / kaputt:** Alle Zahlen (Ökonomie-Tabelle), Update-Plan nach Launch.
**Studio-Änderungen (nicht im Git):** keine
**Für andere wichtig:** Kern bekommt neu `CodeService`, Einladen/Gruppe, Starter-Pack, Server-Boost; `EggService` muss vor jedem Öffnen `CanBuyPaidRandomItems` prüfen.
