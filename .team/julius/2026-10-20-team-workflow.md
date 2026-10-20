# Team-Workflow eingeführt — julius, 2026-10-20
**Branch:** julius/team-workflow · **Commit/PR:** PR folgt

**Gemacht:** `.team/` mit Regeln (`README.md`), `OFFEN.md`, Eintrags-Vorlage und Vorlage für `CLAUDE.local.md`. `CLAUDE.local.md` ignoriert, `.gitattributes` für gleiche Zeilenenden auf Mac/Windows. Verweise in `CLAUDE.md` und `README.md`.
**Testen:** `.team/README.md` lesen; `.team/_claude-local-vorlage.md` nach `CLAUDE.local.md` kopieren und ausfüllen; `git status` darf sie nicht zeigen. Konflikt-Probe (zwei Branches, Einträge + OFFEN.md) lief ohne Merge-Konflikt.
**Offen / kaputt:** Branch-Schutz für `main` fehlt noch (nur Repo-Owner).
**Studio-Änderungen (nicht im Git):** keine
**Für andere wichtig:** Ab jetzt eigener Branch `<kürzel>/<feature>`, Merge nur per PR mit Approval.
