# Teamarbeit — Regeln für Menschen und KIs

Gilt für jede Session in diesem Repo. Das ist die einzige Stelle mit diesen Regeln.

## Session-Start (in dieser Reihenfolge, nichts sonst auf Verdacht lesen)
1. `git fetch` und auf dem eigenen Branch `git pull --rebase` (neuer Branch: `git switch -c <kürzel>/<feature> origin/main`).
2. `.team/OFFEN.md` lesen.
3. Neue Einträge der anderen: `ls -t .team/chris .team/julius .team/gregor | head` — nur Dateien lesen, die neuer sind als dein letzter eigener Eintrag (max. 5).
4. `git log --oneline origin/main -10` und `gh pr list` — zeigt auch Arbeit ohne Eintrag.
5. Vor dem ersten Edit: In `OFFEN.md` unter „In Arbeit" deine Zeile setzen (wer, Branch, welche Systeme/Dateien). Überschneidet sich das mit einer fremden Zeile: **stoppen und den Menschen fragen.**

## Während der Arbeit
- Nur auf dem eigenen Branch arbeiten, ein Feature pro Branch. Nie direkt auf `main`.
- Nur in deinen eigenen Team-Ordner schreiben. In `OFFEN.md` nur deine eigenen Zeilen ändern oder neue Zeilen anfügen.
- Rojo nur mit deinem eigenen Dev-Place verbinden. Mit der gemeinsamen Team-Create-Session nur, wer unter „Studio" die Zeile `Rojo-Sync: <kürzel>` hält.
- Map/Modelle in Team Create: Bereich unter „Studio" ansagen, bevor gebaut wird.

## Session-Ende (nach jeder abgeschlossenen Aufgabe)
1. Eintrag `.team/<kürzel>/YYYY-MM-DD-<kurztitel>.md` nach `.team/_vorlage.md` (max. 15 Zeilen).
2. `OFFEN.md`: deine „In Arbeit"-Zeile aktualisieren oder löschen; Übergaben an andere eintragen; Erledigtes löschen.
3. Eintrag, `OFFEN.md` und Code im selben Commit. Push und Pull Request erst nach OK des eigenen Menschen.
4. PR-Beschreibung: 2–3 Sätze + Link zum Eintrag. Merge nach `main` nur mit Approval einer anderen Person.

## Aufräumen
Einträge älter als 30 Tage verschiebt, wer es bemerkt, nach `.team/<kürzel>/archiv/` (eigener Ordner) — fremde Ordner nur mit Absprache.
