# Team-Workflow (3 Personen, 3 KIs) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. KIs ohne Superpowers: Tasks der Reihe nach abarbeiten, jeden Verifikationsschritt wirklich ausführen.

**Goal:** Christopher, Julius und Gregor arbeiten gleichzeitig mit je eigener KI am Repo, ohne Git-Konflikte, doppelte Arbeit oder überschriebene Studio-Stände, und jede KI ist beim Start in wenigen Lesezugriffen auf dem aktuellen Stand.

**Architecture:** Drei Ebenen. (1) Git ist die erste Quelle der Wahrheit: ein Branch pro Person und Feature, Merge nach `main` nur per Pull Request. (2) `.team/` im Repo: jede Person schreibt nur in ihren eigenen Ordner (eine Datei pro Aufgabe, nie zwei Schreiber pro Datei), dazu eine kleine gemeinsame `OFFEN.md` mit einer Zeile pro Person bzw. Punkt. (3) Persönliches liegt in `CLAUDE.local.md` (gitignored), Gemeinsames in der Repo-`CLAUDE.md`, die nur auf `.team/README.md` als einzige Regelquelle verweist.

**Tech Stack:** Git + GitHub (privates Repo `Chrsmith3/Roblox`, `gh` CLI), Claude Code (`CLAUDE.md` / `CLAUDE.local.md`), Rojo 7.7.1, Roblox Studio (Team Create).

**Spec:** Entscheidungen aus der Session vom 19./20.10.2026 (Julius + Claude), zusammengefasst im Abschnitt „Entscheidungen" unten.

## Entscheidungen

- Eigener Ordner pro Person statt einer gemeinsamen Handoff-Datei (drei Schreiber in einer Datei = Merge-Konflikte, wachsende Datei).
- Regeln stehen **nur** in `.team/README.md`; Repo-`CLAUDE.md` verweist mit einem Absatz darauf (eine Quelle, kein Auseinanderdriften).
- Map/Modelle leben in Team Create, nicht im Git; Studio-Änderungen werden im Eintrag explizit genannt.
- Persönliche KI-Einstellungen in `CLAUDE.local.md`, nie im Repo. Vault-, Selvo- oder Finanzinhalte nie ins Repo.
- Nichts wird gepusht ohne OK der Person, deren KI arbeitet; `.team/`-Einführung braucht das OK von Christopher und Gregor (per PR-Approval).

## Global Constraints

- Personen-Kürzel (Ordner- und Branch-Präfix), exakt: `chris`, `julius`, `gregor`.
- Branch-Namen: `<kürzel>/<feature-kebab-case>`, z. B. `julius/pets-datastore`. Kein direkter Push auf `main`.
- Eintragsdatei: `.team/<kürzel>/YYYY-MM-DD-<kurztitel-kebab-case>.md`, max. 15 Zeilen, Vorlage `.team/_vorlage.md`.
- `OFFEN.md` max. ~40 Zeilen; Erledigtes wird gelöscht, nicht abgehakt.
- Sprache Deutsch; Code-Namen Englisch (bestehende Repo-Regel).
- Rojo verbindet sich nur mit dem **eigenen Dev-Place** einer Person, nie mit der gemeinsamen Team-Create-Session, außer der Person, die laut `OFFEN.md` gerade „Rojo-Sync" für Team Create hält.

## Review Focus

1. Jemand vergisst den Eintrag → die KI der anderen muss trotzdem den Stand sehen: Session-Start liest immer auch `git log --oneline origin/main -10` und `gh pr list` (Task 2, Session-Routine).
2. Zwei KIs fangen am selben System an → vor Arbeitsbeginn „In Arbeit" in `OFFEN.md` prüfen und eigene Zeile setzen; bei Überschneidung stoppen und Mensch fragen (Task 2).
3. Zwei Rojo-Verbindungen auf Team Create überschreiben Skripte → Rojo-Regel + „Rojo-Sync"-Zeile in `OFFEN.md` (Task 2).
4. `CLAUDE.local.md` landet versehentlich im Commit → `git check-ignore` muss sie melden (Task 1, Verifikation).
5. Mac + Windows erzeugen Zeilenende-Diffs in jeder Datei → `.gitattributes` mit `* text=auto eol=lf` (Task 1, Verifikation per `git ls-files --eol`).

---

### Task 1: Git-Grundlagen (Ignore, Zeilenenden, persönliche CLAUDE.local.md)

**Files:**
- Modify: `.gitignore` (am Ende anhängen)
- Create: `.gitattributes`
- Create: `.team/_claude-local-vorlage.md`
- Create (lokal, ignoriert): `CLAUDE.local.md` für Julius

**Interfaces:**
- Produces: `.team/_claude-local-vorlage.md` (Task 5 gibt sie Chris und Gregor), Ignore-Regel für `CLAUDE.local.md`.

- [ ] **Step 0: Arbeitsbranch anlegen**

Run: `git switch main && git pull && git switch -c julius/team-workflow`
Expected: `Switched to a new branch 'julius/team-workflow'`

- [ ] **Step 1: Verifizieren, dass die Datei noch nicht ignoriert wird**

Run: `touch CLAUDE.local.md && git check-ignore -v CLAUDE.local.md; echo "exit=$?"`
Expected: keine Ausgabe, `exit=1`

- [ ] **Step 2: `.gitignore` ergänzen**

```gitignore

# Persönliche KI-Einstellungen (jede Person hat ihre eigene, nie committen)
CLAUDE.local.md
.claude/settings.local.json
```

- [ ] **Step 3: `.gitattributes` anlegen**

```gitattributes
# Gleiche Zeilenenden auf Mac und Windows
* text=auto eol=lf
*.rbxl binary
*.rbxm binary
```

- [ ] **Step 4: Verifizieren**

Run: `git check-ignore -v CLAUDE.local.md && git add --renormalize . && git status -s`
Expected: `.gitignore:…:CLAUDE.local.md	CLAUDE.local.md`; `git status -s` zeigt nur `.gitignore` und `.gitattributes` (keine massenhaft geänderten `.luau`-Dateien — sonst Zeilenenden prüfen, bevor committet wird).

- [ ] **Step 5: `.team/_claude-local-vorlage.md` anlegen** (Vorlage, wird ins Repo committet)

```markdown
# CLAUDE.local.md — persönlich, nicht im Git
<!-- Kopieren nach CLAUDE.local.md im Repo-Root und ausfüllen. -->

Ich bin **<Name>**, Kürzel **<chris|julius|gregor>**. Mein Team-Ordner: `.team/<kürzel>/`. Meine Branches: `<kürzel>/<feature>`.
Rechner: <Mac|Windows>. Mein Dev-Place in Studio: <Name des eigenen Test-Places>.

- Erklärstil: <z. B. kurz, mit Klickwegen>
- Commits: <KI darf selbst committen | vorher fragen>. Push und PR: immer erst nach meinem OK.
- Eigene Notizen außerhalb des Repos: <optional, Pfad>
```

- [ ] **Step 6: Julius' `CLAUDE.local.md` ausfüllen**

Inhalt nach Vorlage mit: Julius, `julius`, Mac (+ PC zum Testen), Erklärstil „kurz, Deutsch, genaue Klickwege", Commits „vorher fragen", eigene Notizen: Vault `/Users/julius/Julius´AI Brain/03 Projects/Projekt Roblox/(C) Handoff.md` (dort Stand nach jeder Aufgabe überschreiben). Dev-Place-Name: offen lassen (`<noch anlegen>`).

Run: `git status -s`
Expected: `CLAUDE.local.md` taucht **nicht** auf.

- [ ] **Step 7: Commit**

```bash
git add .gitignore .gitattributes .team/_claude-local-vorlage.md
git commit -m "chore: CLAUDE.local.md ignorieren, Zeilenenden vereinheitlichen"
```

---

### Task 2: `.team/` — Regeln, gemeinsame Liste, Vorlage, Personen-Ordner

**Files:**
- Create: `.team/README.md` (einzige Regelquelle)
- Create: `.team/OFFEN.md`
- Create: `.team/_vorlage.md`
- Create: `.team/chris/.gitkeep`, `.team/julius/.gitkeep`, `.team/gregor/.gitkeep`

**Interfaces:**
- Consumes: Kürzel und Branch-Schema aus Global Constraints.
- Produces: Pfad `.team/README.md` (Task 3 verweist darauf), Abschnittsnamen in `OFFEN.md`: `## In Arbeit`, `## Übergaben`, `## Entscheidungen offen`, `## Studio` (Task 4 testet Zeilen darin).

- [ ] **Step 1: `.team/README.md` schreiben** (exakter Inhalt)

```markdown
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
```

- [ ] **Step 2: `.team/OFFEN.md` schreiben**

```markdown
# Offen — eine Zeile pro Punkt, Erledigtes löschen

## In Arbeit
<!-- Format: - <kürzel> · <branch> · <Systeme/Dateien> · seit YYYY-MM-DD -->

## Übergaben
<!-- Format: - von <kürzel> an <kürzel>: <was> -->

## Entscheidungen offen
- GDD (`docs/GDD.md`) gemeinsam ausfüllen — alle
- Roblox-Gruppe als Owner + Einnahmen-Split — alle

## Studio
<!-- Format: - Rojo-Sync: <kürzel> | - Baut an: <Bereich> · <kürzel> -->
```

- [ ] **Step 3: `.team/_vorlage.md` schreiben**

```markdown
# <Titel> — <kürzel>, YYYY-MM-DD
**Branch:** <kürzel>/<feature> · **Commit/PR:** <hash oder #nr>

**Gemacht:** <1–3 Zeilen>
**Testen:** <Schritte in Studio, erwartete Ausgabe>
**Offen / kaputt:** <oder „nichts">
**Studio-Änderungen (nicht im Git):** <Map/Modelle/Settings oder „keine">
**Für andere wichtig:** <neue Remotes, DataTemplate-Felder, Config-Werte oder „nichts">
```

- [ ] **Step 4: Personen-Ordner anlegen**

Run: `mkdir -p .team/chris .team/julius .team/gregor && touch .team/chris/.gitkeep .team/julius/.gitkeep .team/gregor/.gitkeep && find .team -type f | sort`
Expected: 7 Dateien (`README.md`, `OFFEN.md`, `_vorlage.md`, `_claude-local-vorlage.md`, drei `.gitkeep`).

- [ ] **Step 5: Commit**

```bash
git add .team
git commit -m "docs: .team-Ordner mit Regeln, OFFEN.md und Vorlage"
```

---

### Task 3: Verweis in Repo-`CLAUDE.md` und README

**Files:**
- Modify: `CLAUDE.md:60-` (Abschnitt `## Arbeitsweise mit Claude`)
- Modify: `README.md:58-62` (Abschnitt `## GitHub`)

**Interfaces:**
- Consumes: `.team/README.md` aus Task 2.

- [ ] **Step 1: In `CLAUDE.md` direkt über `## Arbeitsweise mit Claude` einfügen**

```markdown
## Teamarbeit (zuerst lesen)
Drei Personen arbeiten gleichzeitig mit eigenen KIs. **Vor jeder Arbeit `.team/README.md` lesen und befolgen** (Session-Start, eigene Branches, eigener Team-Ordner, `OFFEN.md`, Session-Ende). Persönliche Einstellungen stehen in `CLAUDE.local.md` (nicht im Git).
```

Im Abschnitt `## Arbeitsweise mit Claude` die Zeile „Nach jedem funktionierenden Schritt: Git-Commit." ersetzen durch: „Nach jedem funktionierenden Schritt: Commit auf dem eigenen Branch (siehe `.team/README.md`)."

- [ ] **Step 2: README-Abschnitt `## GitHub` ersetzen**

Inhalt: drei Zeilen — (1) Branch pro Feature `<kürzel>/<feature>`, nie direkt auf `main`; (2) Merge per Pull Request mit Approval einer anderen Person; (3) Ablauf für Mensch + KI in `.team/README.md`, persönliche KI-Einstellungen: `.team/_claude-local-vorlage.md` nach `CLAUDE.local.md` kopieren.

- [ ] **Step 3: Verifizieren**

Run: `grep -n "team/README.md" CLAUDE.md README.md`
Expected: mindestens ein Treffer in jeder Datei.

- [ ] **Step 4: Commit**

```bash
git add CLAUDE.md README.md docs/superpowers/plans/2026-10-20-team-workflow.md
git commit -m "docs: Teamarbeit-Regeln in CLAUDE.md und README verlinken, Plan beilegen"
```

---

### Task 4: Konflikt-Probe (lokal, nichts pushen)

Beweist, dass zwei Personen gleichzeitig Einträge schreiben und `OFFEN.md` ändern können, ohne Merge-Konflikt.

**Files:** keine dauerhaften (Wegwerf-Branches `probe/a`, `probe/b`).

**Interfaces:**
- Consumes: Abschnittsnamen `## In Arbeit` und `## Übergaben` aus Task 2.

- [ ] **Step 1: Zwei parallele Branches simulieren**

```bash
git switch -c probe/a julius/team-workflow
printf '# Probe\n' > .team/chris/2026-10-20-probe.md
sed -i '' '/^## In Arbeit/a\
- chris · chris/probe · ShopService · seit 2026-10-20
' .team/OFFEN.md
git add .team && git commit -qm "probe a"

git switch -c probe/b julius/team-workflow
printf '# Probe\n' > .team/gregor/2026-10-20-probe.md
sed -i '' '/^## Übergaben/a\
- von gregor an julius: Zone-1-Map fertig
' .team/OFFEN.md
git add .team && git commit -qm "probe b"
```

- [ ] **Step 2: Mergen und prüfen**

Run: `git switch probe/a && git merge --no-edit probe/b && grep -c "probe\|Zone-1" .team/OFFEN.md`
Expected: Merge ohne `CONFLICT`, Ausgabe `2`.

- [ ] **Step 3: Aufräumen**

Run: `git switch julius/team-workflow && git branch -D probe/a probe/b && git status -sb`
Expected: auf `julius/team-workflow`, sauber, keine Probe-Dateien.

> Hinweis: Zwei Personen, die **direkt untereinander** in denselben Abschnitt eine Zeile anfügen, können einen kleinen Konflikt bekommen (beide hängen an derselben Stelle an). Lösung: beide Zeilen behalten. Steht so in keiner Regel, weil es in 10 Sekunden lösbar ist.

---

### Task 5: Einführung im Team

**Files:**
- Create: `.team/julius/2026-10-20-team-workflow.md` (erster echter Eintrag, nach Vorlage)
- Modify: `.team/OFFEN.md` (Übergaben an chris und gregor)

- [ ] **Step 1: Eigenen Eintrag schreiben und `OFFEN.md` ergänzen**

Eintrag nach `.team/_vorlage.md`: Gemacht = Team-Workflow eingeführt; Testen = `.team/README.md` lesen, `CLAUDE.local.md` aus Vorlage anlegen; Studio-Änderungen = keine. In `OFFEN.md` unter `## Übergaben`:
- `von julius an chris: PR „Team-Workflow" reviewen; Branch-Schutz für main aktivieren (Settings ⟩ Branches ⟩ Add rule: main, „Require a pull request before merging", 1 Approval)`
- `von julius an gregor: PR reviewen; CLAUDE.local.md aus .team/_claude-local-vorlage.md anlegen`

- [ ] **Step 2: Commit, dann OK von Julius einholen**

```bash
git add .team
git commit -m "docs: erster Team-Eintrag (julius)"
```

Julius fragen: „Darf ich `julius/team-workflow` pushen und den PR öffnen?" — erst nach Ja weiter.

- [ ] **Step 3: Push und Pull Request**

```bash
git push -u origin julius/team-workflow
gh pr create --base main --title "Team-Workflow: .team-Ordner, Branch-Regeln, CLAUDE.local.md" --body "Regeln für gleichzeitiges Arbeiten mit drei KIs. Bitte .team/README.md lesen und per Approval zustimmen. Eintrag: .team/julius/2026-10-20-team-workflow.md"
```

Expected: PR-URL wird ausgegeben.

- [ ] **Step 4: Nach Merge (durch Christopher oder Gregor) — Abschluss prüfen**

Run: `git switch main && git pull && test -f .team/README.md && git check-ignore -q CLAUDE.local.md && echo OK`
Expected: `OK`. Danach im Vault `(C) Handoff.md` überschreiben (Phase: Team-Workflow aktiv) und eine Zeile ins Iteration Log.

**Nicht Teil dieses Plans (je Person selbst):** `CLAUDE.local.md` von Chris und Gregor anlegen, eigene Dev-Places in Studio erstellen, Branch-Schutz (nur Christopher als Repo-Owner kann ihn setzen).
