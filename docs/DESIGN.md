# Design-Prinzipien: Look, HUD, erste Minuten, Handy-Performance

> Für Menschen **und KIs**. Wer UI, Icons, Karten, Modelle, Pets, Bosse, Effekte oder das Onboarding baut, hält sich an dieses Dokument. Spielinhalt: `docs/GDD.md`, Wirtschaft: `docs/WIRTSCHAFT.md`, Rollen: `docs/ARBEITSPLAN.md`.
> Stand: 2026-10-22 · Status: **v1, Vorschlag aus der Analyse von 6 Referenz-Screenshots** (Kraft-/Gym-Simulator mit Boss, Blasen-Simulator, Pet-Simulator, Fähigkeits-Simulator Welt 2, „Stehlen Sie ein Ei"). Konkrete Farben, Schrift und Icons legt der **Style Guide** fest (entsteht in Claude Design, liegt dann in `docs/style/`).
> **[Faustregel]** = Erfahrungswert, nicht offiziell · **[prüfen]** = vor Umsetzung gegenchecken.

## 1. Leitsatz

In unserem Genre entscheidet **nicht die Grafikqualität**, sondern **Lesbarkeit, eine klare nächste Aktion und ein starkes Belohnungsgefühl**. Das geht mit einfacher Grafik vollständig. **Detail gehört in Pets, Bosse und Eier, nicht in Boden und Wände.** Handy zuerst: Was auf einem schwachen Handy nicht flüssig läuft, wird vereinfacht.

## 2. Was wir von den Referenzen übernehmen

| Muster | Bei uns |
|---|---|
| Starter-Pet wählen, 3 Karten mit je einer Charakterzeile | 3 gleichwertige Steinzeit-Begleiter, kein Zufall, kein Robux |
| Genau **eine** Anweisung pro Moment, Zeigefinger/Pfeil auf das Objekt | Max. **5 Wörter** pro Anweisung |
| Mini-Quest mit Sofortbelohnung („0/1 → 25") | Erste Quest in Sekunden erfüllbar |
| Fernziel mit „?"-Meilensteinen | Ära-Fortschrittsleiste mit verdeckten Belohnungen bis zum Ära-Sprung |
| Quest-Banner oben + leuchtender Pfad am Boden | Quest-Tracker oben, Beam zum nächsten Ziel |
| Zuwachs pro Aktion sichtbar („+1.2k") | Kraft-Anzeige mit „+X pro Klick" |
| Kurze Zahlen (k, M) | `Shared/Util/Format` nutzen |
| Große Hauptaktion unten, Auto-Schalter als farbige Pillen | Trainieren unten rechts; Auto-Training grün, Auto-Kampf rot |
| Neue Welt = neue dominante Farbe | Eigene Palette pro Ära |
| Pets mit riesigem Kopf und großen Augen | Pet-Proportionsregel (Abschnitt 4) |
| Wenig Umgebungsdetail, große lesbare Figuren | Große Flächen + wenige Landmarken |
| Dicke runde Outline-Schrift, glänzende Icons mit Outline | Eine Schrift, ein Icon-Stil |

## 3. Was wir bewusst anders machen

1. **HUD nicht überladen:** höchstens **5–6 feste Elemente**, alles andere in Menüs.
2. **Keine Texte mitten im Bild** und keine winzige Schrift auf 3D-Schildern. Anweisungen oben am Rand; in der Welt nur wenige, große Beschriftungen.
3. **Eine Info, ein Ort:** nichts doppelt anzeigen.
4. **Keine Druck-Muster:** keine Countdown-Sales, keine „Nächstes Update"-Timer, keine Belohnungs-Timer mit Verfallsdruck. Daily-Streak ja, aber **beim Verpassen nicht auf 0 zurücksetzen** (höchstens kleinerer Bonus).
5. **Kein Kauf-Feed** („Spieler X hat Y gekauft"). **Ausnahme:** die Ansage beim **Server-Boost** aus `docs/WIRTSCHAFT.md` („<Name> hat 2× Kraft für alle gekauft"), weil sie allen im Server nützt; sie ist kurz, freundlich und erscheint nur einmal.
6. **Gesperrte Bereiche zeigen die Bedingung** (Kraft, Boss, Ära, Rebirths), **nie einen Robux-Preis**.
7. **Ein Shop-Button** für alle Käufe, Preise live von Roblox. Der Robux-Hinweis steht nur im Shop. Starter-Pack ohne Countdown.
8. **Eigene, saubere deutsche Texte**, nicht maschinell übersetzt. Alle Texte an einer Stelle sammeln (später Englisch).

## 4. Stil „Chunky Low-Poly"

- **Formen:** große, abgerundete Blöcke/Facetten, wenige Teile, glatte Materialien, keine feinen Details. Jedes wichtige Objekt hat eine eindeutige Silhouette (Keule, Schwert, Roboter). Keine eigenen Texturen auf Boden/Wänden, nur Material-Presets.
- **Paletten-Prinzip pro Ära:** 60 % Hauptfarbe · 30 % Nebenfarbe · 10 % Akzent. Der Akzent ist **nur für Interaktives** reserviert (Eier, Portale, Bosse, Trainings-Objekte, Shop). Gleiche Sättigung über alle Ären, nur Farbton und Helligkeit wechseln. Startvorschlag (Hex-Werte im Style Guide):

| Ära | Haupt | Neben | Akzent |
|---|---|---|---|
| Steinzeit | Grün | Braun | Orange |
| Antike | Sandgelb | Türkis | Rot |
| Mittelalter | Blaugrau | Violett | Gold |
| Neuzeit | Hellblau | Weiß | Orange |
| Zukunft | Dunkelblau | Neon-Cyan | Pink |
| 3000 n. Chr. | Schwarzlila | Neon-Grün | Magenta |

- **Kontrast:** Welt etwas weniger gesättigt, alles Interaktive kräftiger. Boss-Arenen mit auffälligem Bodenring. Szenen nie so dunkel, dass die Spielfigur verschwindet.
- **Schrift:** eine dicke, runde Outline-Schrift für UI und Welt; Text hell, Outline dunkel. Sie muss **in Roblox verfügbar** sein (eingebaute Schriften wie Fredoka One oder Luckiest Guy **[prüfen]**), sonst sieht das Mockup anders aus als das Spiel.
- **Icons:** dicke dunkle Outline, ein Glanzlicht, flacher Verlauf, gleiche Grundform. **Kraft, Trophäen und Kristalle** müssen in Form **und** Farbe sofort unterscheidbar sein.
- **Pets:** Kopf ≈ 70–80 % des Körpers, große Augen mit Lichtpunkt, kleine Gliedmaßen, 1 Haupt- + 1 Zweitfarbe, Ära-Thema (z. B. Mammut-Baby, Ritter-Hase, Roboter-Katze). **Seltenheit über Farbe, Aura und wenige Partikel**, nicht über mehr Geometrie.
- **Bosse:** groß, eindeutige Silhouette, Lebensbalken, Akzentfarbe der Ära. Der erste Boss jeder Ära ist kaum verlierbar.
- **Welt:** pro Ära **3–4 große Landmarken** (z. B. Vulkan, Pyramide, Burg, Raumschiff) statt vieler kleiner Deko-Teile.

## 5. HUD-Layout (Handy zuerst)

| Zone | Inhalt |
|---|---|
| Oben links | Roblox-Menü (fest), darunter **Kraft** mit „+X/Klick" |
| Oben mittig | nur **Quest-Tracker** (eine Zeile mit Fortschritt), sonst frei |
| Oben rechts | **Trophäen**, **Kristalle**; darunter Icons für Shop, Daily, Quests, Menü (Codes, Einladen, Gruppe, Einstellungen) |
| Unten links | Joystick (Roblox-Standard); aktive Boosts als kleine Chips **nur wenn aktiv** |
| Unten rechts (Daumenzone) | **Trainieren** (groß); im Kampf die **3 Fähigkeiten**; Auto-Schalter |
| Unten mittig | **Ära-Fortschrittsleiste** |

- Tippziele mindestens `UIStyle.Sizes.MinTouchTarget` (Projektregel), Haupt-Button deutlich größer. **[Faustregel]** ca. 48 px Minimum, Haupt-Button ca. 72 px+.
- Safe Area beachten (Notch, Roblox-Topbar). Roblox läuft auf Handys im **Querformat**: Layout auf ca. **812 × 375** testen (kleines Handy), zusätzlich Tablet.
- Nur Komponenten aus `client/UI/Components` und Werte aus `UIStyle` (Projektregel). Jede Aktion bekommt Feedback über `FeedbackController`; Belohnungen erst nach Server-Bestätigung anzeigen.

## 6. Die ersten 2 Minuten (Steinzeit)

| Zeit | Schritt | UI |
|---|---|---|
| 0–10 s | Spawn auf der Trainingswiese, kurzer Kameraschwenk | nur Logo |
| 10–25 s | **Starter-Begleiter wählen** (3 Karten, je 1 Wort); Holzkeule automatisch geschenkt | Auswahl-Fenster, Tippen wählt |
| 25–55 s | **Erstes Training:** Hand zeigt auf den Trainingsfelsen, Kraft-Zahl fliegt hoch + Sound; Quest 0/10 | Zeigefinger, Quest-Tracker, Trainieren-Button |
| 55–60 s | Quest erfüllt, Pfad leuchtet zum Mini-Boss: „Besiege den Höhlenbären!" | Beam |
| 60–90 s | **Mini-Boss** (10–15 s), erste Fähigkeit blinkt; auch nur mit Kraft schaffbar (siehe Bosskampf-Mischung in `docs/WIRTSCHAFT.md`) | Boss-Lebensbalken, 1 Fähigkeiten-Button |
| 90–105 s | **Erste Trophäen** + Satz „Trophäen kaufen Eier." Der Trophäen-Zähler erscheint erst jetzt | Belohnungs-Popup |
| 105–120 s | **Erstes Ei**, genau bezahlbar, Odds sichtbar, Schlüpfen überspringbar. Ist das Ei für den Spieler gesperrt (Policy-Check), führt der Pfeil stattdessen zum **Pet-Shop** | Ei-Stand, Odds-Fenster, Schlüpf-Screen |
| ab 2 min | Ära-Leiste mit „?" sichtbar; **Kristalle** ab ca. Minute 3 per Quest, dann Waffenstand; Arena als sichtbares, noch gesperrtes Ziel | Fernziel-Leiste |

Regeln: immer nur **eine** neue Währung und **eine** Aktion gleichzeitig; Tutorial überspringbar; UI-Elemente erscheinen erst, wenn sie gebraucht werden. Codes, Einladen und Gruppe tauchen frühestens nach dem ersten Ei auf.

## 7. Handy-Performance (Roblox-Doku, wo angegeben)

- **Draw Calls zuerst:** Beispiel-Zielwert der Doku für schwache Geräte ca. < 1.000 Draw Calls und ca. < 1 Mio. Dreiecke in der Szene; auf echtem Handy testen. (create.roblox.com/docs/performance-optimization/design)
- **Meshes:** hartes Limit 20.000 Dreiecke pro Mesh (…/art/modeling/specifications). Unser Budget **[Faustregel]**: Pets und Objekte ca. 1.000–3.000, Bosse bis ca. 5.000. Gleiche Meshes + gleiche Textur wiederverwenden (teilen sich Draw Calls), Packages nutzen. (…/performance-optimization/improve)
- **Texturen:** meist ≤ 512 × 512, Nebensächliches ≤ 256; eingebaute Materialien statt eigener Texturen; UI-Icons als Spritesheet. (…/improve)
- **StreamingEnabled an**; jede Ära als eigener, streambarer Bereich; SLIM (Level of Detail) prüfen. (…/workspace/streaming, …/workspace/streaming/slim)
- **MeshParts:** RenderFidelity Automatic/Performance; CollisionFidelity Box für kleine/statische Teile; Deko ohne CanCollide/CanTouch/CanQuery; Statisches Anchored. (…/improve)
- **Partikel:** auf Handys max. ca. 100/s pro Emitter, Raten niedrig halten (Overdraw). (…/effects/particle-emitters)
- **Transparenz:** möglichst nur 0 oder 1, keine gestapelten halbtransparenten Flächen.
- **Licht:** wenige Lichtquellen, kleine Reichweite, Schatten nur wo nötig (kleine/bewegte Teile `CastShadow` aus). Lighting-Technology eher ShadowMap/Voxel als Future **[prüfen, nur DevForum-Quellen]**. Der Look entsteht über Farben, nicht über Lichteffekte.
- **Unions:** sparsam, lieber Parts oder MeshParts **[prüfen, Doku unklar]**.
- **Skripte:** ereignisbasiert, keine teuren Berechnungen in jedem Frame.
- **Testen:** ein schwaches Referenz-Handy festlegen und regelmäßig darauf spielen; der Studio-Emulator zeigt Speicher nicht korrekt.

## 8. Arbeitsteilung Claude Design ↔ Studio

- **Claude Design (2D):** Style Guide (Hex-Paletten je Ära, Schrift, Outline-Regeln, Buttons), Icons (Währungen, Buttons, Eier, Pets, Ären), HUD-Mockup nach Abschnitt 5, Mockups der ersten 2 Minuten (Abschnitt 6), Pet- und Boss-Konzepte (Front/Seite, Proportionen), Moodboard je Ära. Export klein (UI bis 512 px). Style Guide als PDF/PNG nach `docs/style/`.
- **Roblox Studio (3D):** Welt nach Style Guide (große Flächen, 3–4 Landmarken), Materialien und Farben, Lighting/Skybox je Ära, Pets/Eier/Bosse als einfache Meshes (Studio-KI, Toolbox nur geprüft, ggf. Blender), MeshPart-Einstellungen, StreamingEnabled, Tags für den Code (Arbeitsplan Vertrag 2), Test auf echtem Handy.
- **UI im Spiel:** Mockup → Claude-Code-Handoff → Luau-UI mit `UIStyle` und den Komponenten.
- **Vor dem Start festlegen:** Palette als Hex-Liste in `UIStyle`, Pet-Proportionsregel, Dreiecks-Budget pro Objekttyp.

## 9. Noch offen

- Style Guide v1 (Hex-Werte, konkrete Schrift, Icon-Set) — Look
- Namen und Aussehen der 3 Starter-Begleiter; Name von Ära 2
- Dreiecks-Budgets und Referenz-Handy final festlegen
- Lighting-Technology nach Handy-Test festlegen
