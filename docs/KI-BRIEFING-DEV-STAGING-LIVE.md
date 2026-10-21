# Briefing für die KI von Christopher und Gregor: Ablauf Dev → Staging → Live

> Anweisung an dich, die KI: Lies dieses Dokument und erkläre deinem Menschen (Christopher bzw. Gregor) den Ablauf **konkret und Schritt für Schritt**, auf Deutsch, mit Klickwegen in Roblox Studio. Pass den Erklärstil an `CLAUDE.local.md` an. Er soll es verstehen, nicht nur abnicken: frage nach jedem Abschnitt kurz, ob etwas unklar ist, und lass ihn die Schritte in seinem Dev-Experience selbst ausprobieren. Dieses Dokument ist ein **Entwurf des Teams (Stand 2026-10-21)**, ändere nichts am Spiel, solange dein Mensch nichts dazu sagt.

## Worum geht es

Wir bauen zu dritt ein Roblox-Spiel (Zeitalter-Simulator mit PvP-Arena). Damit nichts Kaputtes bei echten Spielern landet und niemand die Arbeit der anderen überschreibt, gibt es **drei Stufen**. Jede Stufe ist ein **eigenes Experience** in Roblox.

**Warum eigene Experiences und nicht nur eigene Places?** Spielstände (Data Stores) gehören in Roblox zum *Experience*, nicht zum einzelnen Place (Roblox-Doku). Ein Test im Live-Experience würde echte Spielerdaten berühren. Getrennte Experiences = getrennte Daten.

## Die drei Stufen

| Stufe | Wo | Wer arbeitet hier | Wichtigste Regeln |
|---|---|---|---|
| **Dev** | Eigenes Experience je Person (Name steht in der eigenen `CLAUDE.local.md`) | Du und dein Mensch allein | Code kommt per **Rojo** vom eigenen Git-Branch. Hier darf alles ausprobiert werden. Data-Store-Zugriff in Studio darf nur hier eingeschaltet sein. |
| **Staging** | Gemeinsames Experience, **Team Create an** | Alle drei | Hier kommen Code aus `main` und Karte/Modelle zusammen, hier wird gemeinsam getestet. Rojo-Sync in Staging macht nur, wer unter „Studio" in `.team/OFFEN.md` die Zeile `Rojo-Sync: <kürzel>` hält. Bevor jemand in der Karte baut, sagt er den Bereich in `OFFEN.md` an. |
| **Live** | Eigenes Experience, **Team Create aus** | Genau **eine** Person (der Publisher) | Wird nie von Hand gebaut. Es bekommt nur den getesteten Staging-Stand. Wer Publisher ist, legt das Team fest. |

## Was du als KI (nicht) tun darfst

- Das Studio-MCP und Rojo wirken auf den **gerade geöffneten Place**. Prüfe deshalb vor jedem Eingriff, **welcher Place offen ist** (Name des Experiences). Im Live-Place arbeitest du **nie**.
- Vor größeren Eingriffen per MCP: Place sichern (Version speichern bzw. als .rbxl exportieren).
- Code nur aus Dateien im Repo (`src/`) per Rojo ändern, nie Skripte direkt in Studio (Repo-`CLAUDE.md`).
- Keine API-Keys oder Zugangsdaten in Dateien. Open-Cloud-Keys höchstens als Umgebungsvariable.
- Nichts pushen, nichts veröffentlichen ohne ausdrückliches OK deines Menschen.

## Der Weg einer Änderung (Beispiel)

1. Dein Mensch arbeitet auf seinem Branch (`<kürzel>/<feature>`) in seinem **Dev**-Experience, testet dort per Playtest.
2. Fertig → Commit auf dem Branch → Pull Request → Review durch eine andere Person → Merge nach `main` (siehe `.team/README.md`).
3. Der Rojo-Sync-Halter synchronisiert `main` ins **Staging**. Das Team testet dort zusammen.
4. Wenn alles passt, veröffentlicht der **Publisher** den Staging-Stand nach **Live** (nächster Abschnitt).

## Release-Ablauf (nur Publisher)

1. Vorher: Staging getestet, alle PRs gemergt, Team einverstanden.
2. **Backup:** Live-Place als .rbxl sichern.
3. Staging-Place in Studio öffnen. **File ⟩ Publish to Roblox As…** ⟩ Live-Experience wählen ⟩ **Überschreiben**, Versionsnotiz eintragen. Achtung: Falsches Ziel überschreibt diesen Place.
4. **Wenn das nicht klappt** (Fehlermeldung oder es passiert stillschweigend nichts): (a) Auf dem Live-Place Team Create ausschalten, (b) oder Staging als .rbxl speichern, in einem neuen Baseplate öffnen und von dort veröffentlichen. Beide Fälle sind in Foren gemeldet, ob sie bei uns auftreten, zeigt der Praxistest.
5. Rauchtest live: Beitreten, Farmen, Shop öffnen, Datenspeichern prüfen.
6. Kurzen Eintrag in `.team/` bzw. `OFFEN.md`.

## Rückgängig machen

Studio ⟩ **Window ⟩ Version History** ⟩ Version wählen ⟩ **Restore**. Das legt eine **neue** Version an und veröffentlicht **nichts**, danach muss erneut veröffentlicht werden. Roblox empfiehlt, vorher die Zusammenarbeit auszuschalten (Live Collaborators ⟩ ⋯ ⟩ Disable Team Create), damit niemand gleichzeitig editiert. Im Staging also vorher alle informieren.

## Zwei Fallen, die du deinem Menschen erklären sollst

1. **Veröffentlichen überschreibt den ganzen Place.** Alles, was nicht im Staging-Stand ist, geht auf Live verloren. Deshalb baut niemand direkt in Live.
2. **Packages nie auf Auto-Update für Live.** Wiederverwendbare Modelle (z. B. Pets) können als Package in der Roblox-Gruppe liegen. Auf Live das Update **manuell** halten, sonst landet jede Änderung sofort live.
3. **Animationen/Assets** immer unter der **Roblox-Gruppe** hochladen, der das Spiel gehört, sonst spielen Animationen im Spiel nicht ab.

## Was noch nicht sicher ist (Woche-0-Praxistest)

Wir testen einmal zu dritt in einem Wegwerf-Experience (ca. 30 Minuten): (a) klappt Publish-as direkt zwischen zwei Experiences oder nur über die .rbxl-Datei? (b) Restore mit und ohne Team Create, (c) Package-Update auf manuell, (d) schreibt ein Test in Dev nie in die Live-Daten? Melde das Ergebnis deinem Menschen, damit es in den Arbeitsplan eingetragen wird.

## Kontrollfragen zum Schluss (frage sie deinen Menschen)

1. Warum ist Live ein eigenes Experience und nicht nur ein weiterer Place?
2. Wer darf nach Live veröffentlichen, und woher kommt der Stand?
3. Was machst du, wenn nach einem Release etwas kaputt ist?
4. Welche Stufe darfst du mit dem Studio-MCP verändern, und was prüfst du vorher?

## Quellen (Roblox-Doku)

- Publish: https://create.roblox.com/docs/en-us/production/publishing/publish-experiences-and-places.md
- Data Stores: https://create.roblox.com/docs/cloud-services/data-stores/best-practices
- Version History: https://create.roblox.com/docs/projects/version-history
- Collaboration / Team Create: https://create.roblox.com/docs/projects/collaboration
- Packages: https://create.roblox.com/docs/projects/assets/packages
- Animationen: https://create.roblox.com/docs/projects/transfer-animations
