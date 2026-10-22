# Wirtschaft und Monetarisierung

> Für Menschen **und KIs**. Wer Währungen, Belohnungen, Shop, Käufe, Skilltree, Waffen, Fähigkeiten, Eier oder PvP-Boni baut, hält sich an dieses Dokument. Der Spielinhalt steht im GDD (`docs/GDD.md`), die Rollen im Arbeitsplan (`docs/ARBEITSPLAN.md`).
> Stand: 2026-10-22 · Status: **v4, vom Team angenommen** (v3 + Review Christopher: Bosskampf-Mischung, Rebirth/Ära-Sprung, Auto-Training-Deckel, Policy-Check bei Eiern, Wachstums- und Monetarisierungs-Muster). Zahlen sind **OFFEN** und kommen in die Ökonomie-Tabelle (Kern & Ökonomie, Woche 0/1). Arbeitsnamen der Währungen können sich ändern.

## 1. Das Prinzip in einem Absatz

Man **trainiert** und baut **Kraft** auf. **Kraft bestimmt den Grundschaden**, Fähigkeiten geben Extra-Schaden und Effekte. Damit besiegt man **Bosse** (und misst sich in der Arena), und beides gibt **Trophäen** und **Kristalle**. **Trophäen** gibt es nur durch Spielen und bezahlen Eier, Pets und den Ära-Sprung. **Kristalle** kann man erspielen oder mit Robux kaufen und bezahlen Skilltree, Waffen, Fähigkeiten und Attribute. Bosse und Arena nutzen **dasselbe Kampfsystem**. Im PvP wirkt alles Erspielte und Gekaufte nur gedeckelt, damit dort Können zählt.

## 2. Werte und Währungen

| Name (Arbeitsname) | Art | Woher | Wofür | Mit Robux kaufbar? |
|---|---|---|---|---|
| **Kraft** | Wert (keine Währung) | Training (klicken/schlagen in der Ära, auch Auto-Training) | Bosse besiegen; schaltet bessere Trainings-Werkzeuge frei; im PvP stark abgeflacht und gedeckelt | Nur über Multiplikatoren (2× Kraft) |
| **Trophäen** | Währung | **nur erspielt:** Bosse, Arena | Eier, festes Pet im Shop, Ära-Sprung | **Nie** |
| **Kristalle** | Währung | **erspielt und kaufbar** | Skilltree-Knoten, Waffen, Fähigkeiten, Attribute, Umskillen | Ja (Pakete) |

## 3. Harte Regeln (gelten für jede Rolle und jede KI)

1. **Option (a) (Team, 2026-10-22):** Die Ei-Währung (Trophäen) ist **nie mit Robux kaufbar**, auch nicht indirekt.
2. **Kein Umtausch Kristalle → Trophäen**, keine Funktion, kein Shop-Eintrag und kein Boost, der Kristalle in Trophäen verwandelt oder Trophäen-Einnahmen für Robux erhöht (kein „2× Trophäen"-Boost). Sonst wäre es ein Umweg um Regel 1.
3. **Alles, was Kristalle kaufen, ist deterministisch.** Keine Waffen- oder Fähigkeiten-Kisten, kein Zufall. Zufall gibt es nur bei Eiern (mit Trophäen).
4. **Eier:** alle möglichen Ergebnisse mit Prozent-Odds vor dem Öffnen anzeigen (Summe 100 %), Pity-Zähler sichtbar und serverseitig gespeichert. **Der Policy-Check `MonetizationService.CanBuyPaidRandomItems` ist beim Ei immer aktiv** (Review Christopher, 2026-10-22): Gekaufte Kraft-Boosts (VIP, 2× Kraft, Auto-Training, Zeit-Boosts) machen Bosse schneller und damit indirekt auch Trophäen. Ob Roblox das als Paid Random Item wertet, ist unklar, also gehen wir auf Nummer sicher. Eingeschränkte Spieler können kein Ei öffnen, aber jedes Pet **direkt im Shop** mit Trophäen kaufen (das ist die von Roblox verlangte Alternative).
5. **Nichts ist nur per Robux erhältlich** (außer Kosmetik). Robux kauft Zeitersparnis.
6. **Keine kaufbare Stärke über dem PvP-Deckel** (siehe Abschnitt 5).
7. Preise nie im Code, immer live von `MarketplaceService`. Käufe serverseitig, `ProcessReceipt` idempotent. Produkt-IDs pro Stufe (Dev/Staging/Live), Arbeitsplan Vertrag 8.
8. Keine FOMO-Timer, keine Casino-Optik (junge Zielgruppe). Keine Waffen-/Skin-Kisten.
9. **Auto-Training / AFK gibt nur Kraft**, keine Kristalle und keine Trophäen. Bosse brauchen aktive Spieler. Kein Anti-AFK-Trick: Roblox entfernt inaktive Spieler nach ca. 20 Minuten, das ist unser natürlicher Deckel.

## 4. Loop und Belohnungen

1. Trainieren → **Kraft** (+ kleine Menge Kristalle nebenbei, nur bei aktivem Training).
2. Bosse der Ära besiegen (3 pro Ära: klein, mittel, Ära-Boss) → **Trophäen** und Kristalle.
3. Trophäen ausgeben: **Glück** = Ei öffnen, **sicher** = ein festes Pet im Shop kaufen (teurer als ein Ei).
4. Kristalle ausgeben: Skilltree, Waffen, Fähigkeiten, Attribute (sicherer, vorhersehbarer Fortschritt).
5. **Rebirth** (kleiner Kreislauf **innerhalb** einer Ära): setzt Kraft und Trainings-Werkzeuge zurück, gibt dauerhaft +X % Kraft.
6. **Ära-Sprung** (großer Schritt): Ära-Boss besiegt + X Trophäen. Der **Ära-Boss verlangt mindestens Y Rebirths** (Vorschlag Y = 3), damit Rebirth einen klaren Zweck hat. Der Ära-Sprung **setzt Kraft zurück**, die neue Ära gibt aber pro Klick ein Vielfaches (sonst explodieren die Zahlen und alte Bosse/Werkzeuge werden sinnlos). Pets, Trophäen, Kristalle, Skilltree und Rebirth-Bonus bleiben.

**Bosskampf (Mischung, Review Christopher):** Kraft bestimmt den **Grundschaden pro Treffer** (Haupt-Fortschritt). Fähigkeiten geben **Extra-Schaden und Effekte** (z. B. Betäuben, Schild, Flächenschaden) und sind das Training fürs PvP. Jeder Boss ist auch **nur mit Kraft** schaffbar (dann langsamer), damit sich niemand ohne gute Fähigkeiten blockiert fühlt.

**Was ein Boss gibt:**

| Ereignis | Trophäen | Kristalle |
|---|---|---|
| Boss besiegt (jedes Mal) | feste Menge, **Haupt-Ertrag** | kleine Menge |
| **Erster Sieg** gegen diesen Boss | normale Menge | **großer Bonus** (einmalig) |
| Ära-Boss zum ersten Mal | normale Menge | noch größerer Bonus, schaltet den Ära-Sprung frei |

Kristalle aus Boss-Wiederholungen bleiben bewusst klein: Sonst wäre Bosse-Farmen besser als Kaufen, und niemand kauft Pakete. Der **erste Boss belohnt großzügig** (schnelles Erfolgserlebnis), danach werden Kristalle knapper. Das ist der Moment, in dem der erste Kauf am wahrscheinlichsten ist.

**Weitere Kristall-Quellen (erspielbar):**
- **Arena:** Teilnahme + Platzierung (dazu Trophäen)
- **Daily Reward + Streak**, **3 tägliche Quests**
- **Erfolge** (einmalig, z. B. Ära erreicht, 50 Arena-Siege)
- **Ära-Sprung-Bonus**
- kleine Rate beim **aktiven** Training (nicht bei Auto-Training)
- **Codes** (v1, für TikTok/Shorts: „Code im Video → Kristalle")
- **Freunde einladen** über den Share-Link (Belohnung für beide; Roblox zahlt uns dafür zusätzlich Creator Rewards)
- **Gruppen-Beitritt** (einmalig; so erreichen wir die Spieler bei jedem Update)

**Zielwert [Einschätzung, Zahlen offen]:** Ein Spieler ohne Kauf erreicht den vollständigen Build einer Ära in ca. 5–7 Tagen, ein zahlender in ca. 2–3. Zu schnell → niemand kauft, zu langsam → Frust und Abwanderung. Wird in der Ökonomie-Tabelle festgelegt und nach den ersten Messungen angepasst.

**Content-Dauer:** Mit 2 Ären zum Launch ist ein Gratis-Spieler nach ca. 2 Wochen durch. Simulator-Spieler erwarten etwa **wöchentlich** etwas Neues (neuer Boss, neues Ei, Event). Der Update-Plan nach dem Launch gehört deshalb in den Arbeitsplan.

**Senken (damit nichts ins Leere läuft):** steigende Skilltree-Kosten, Waffen-Stufen, Umskillen gegen Gebühr.

## 5. Brücke PvE ↔ PvP

- **Ein Kampfsystem** für Bosse und Arena (Format A): gleiche Fähigkeiten, gleiche Steuerung, Treffer entscheidet der Server. Bosse sind damit das Training fürs PvP. „Arena & Feel" baut das System einmal.
- **Kraft** wirkt gegen Bosse **voll**, in der Arena **abgeflacht** (z. B. logarithmisch).
- **PvP-Deckel:** Alle Boni aus Pets, Skilltree, Waffen, Fähigkeiten, Kraft und gekauften Boosts zusammen wirken in der Arena höchstens mit ca. +20 % (Zahl OFFEN). Reihenfolge: **erst** Kraft abflachen, **dann** alles zusammenrechnen und deckeln, in **einer** Formel. Der Deckel steckt in `StatsService.GetPvPModifiers(player)`; die Arena rechnet nur mit dem Ergebnis.
- **Arena-Loadout:** 3 Fähigkeiten-Slots. Viele Fähigkeiten sind **Sidegrades** (andere Wirkung statt nur mehr Schaden). Skilltree-Punkte zählen in der Arena nur bis zu einer festen Obergrenze.
- **Belohnung:** Arena gibt Trophäen (Teilnahme + Platzierung) in einer Rate, die mit Bossfarmen vergleichbar ist, für gute Spieler etwas höher. Volle Belohnung nur gegen ähnlich starke Gegner (Kraft-/Rating-Bereich), abnehmend gegen denselben Gegner (gegen Absprachen und Zweitaccounts).
- **PvP-Meilensteine** statt eigener PvP-Währung: z. B. 10 / 50 / 200 Arena-Siege → Titel, Aura, exklusives PvP-Pet (gleicher Farm-Wert wie Ei-Pets, nur anders aussehend).
- **Matchmaking** nach Rating + Stärke-Stufe; v1 nur die Arena im eigenen Server, Ranked erst bei genug Spielern.

## 6. Womit wir Geld verdienen

**Game Passes (einmalig), v1:** VIP (+50 % Kraft, Chat-Tag), 2× Kraft, Auto-Training, +1/+2 Pet-Slots, 3 Eier auf einmal (unkritisch, solange die Odds gleich bleiben; der Policy-Check aus Regel 4 gilt trotzdem).
**Developer Products (mehrfach):** **Kristall-Pakete** in Stufen, Zeit-Boosts (2× Kraft, 2× Kristalle für 30 min), später Boss-Abklingzeit überspringen.
**Starter-Pack (v1):** einmalig kaufbar (Server prüft das), günstiges Kristall-Paket mit Bonus. **Ohne Countdown** (kein FOMO). In Simulatoren erfahrungsgemäß einer der häufigsten Käufe.
**Server-Boost (v1):** Dev Product, z. B. 2× Kraft für **alle** im Server für 15 min, mit Ansage „<Name> hat 2× Kraft für alle gekauft". Sozial und bewährt. Nie für Trophäen (Regel 2).
**Kosmetik** (Update 1): Auren, Trails, Arena-Emotes, direkt kaufen, **keine Kisten**.
**Später:** Season Pass (Gratis- + Premium-Spur; Trophäen nur auf der Gratis-Spur), Private Server.
**Nicht:** Trophäen-Pakete, Trophäen-Boosts, Robux-Eier, Kisten, Umtausch Kristalle → Trophäen.

Preis-Richtwerte aus Referenzspielen (Sekundärquellen, Roblox behält 30 %): 99–199 R$ gilt als guter Einstiegsbereich, VIP/Auto-Training eher 250–600 R$. Konkrete Preise: OFFEN, Ökonomie-Tabelle.

## 6a. Referenzspiele (warum so)

| Spiel | Muster | Lehre |
|---|---|---|
| Arm Wrestle Simulator, Gym League | Klicken → Stärke → Bosse → Wins → Pets/neue Welten | Bewährter Grind-Kern; Auto-Training und Trainings-Multiplikatoren sind Bestseller |
| Muscle Legends, Saber Simulator | Stärke entscheidet direkt den PvP-Kampf | Neue verlieren nur und hören auf → Deckel nötig |
| Blox Fruits | Dieselben Fähigkeiten in PvE und PvP, PvP-Belohnung nur gegen ähnlich Starke | Vorbild für die Brücke |
| Rivals | Faires PvP, Geld nur für Optik | PvP-Spieler zahlen fürs Angeben, nicht für Stärke |

## 7. Folgen für den Code (für „Kern & Ökonomie" und „Arena & Feel")

- `Config/GameConfig.luau`: `Currencies` ersetzen. `Trophies` (Anzeige, nicht kaufbar) und `Crystals`; `Coins` entfällt. `DataTemplate.luau`: neue Felder `Trophies`, `Crystals`, `Stats.Strength`, Pity-Zähler je Ei (neue Felder statt umbenennen, solange noch kein Release; danach nur mit Migration).
- `Config/Products.luau`: `CoinsSmall`/`GemsSmall` ersetzen durch Kristall-Pakete (`Handler` z. B. `GrantCrystals`). **Keine** Produkte, die Trophäen vergeben. Produkt-IDs pro Stufe nach `game.GameId`.
- `CurrencyService`: Trophäen dürfen nur über erspielte Quellen (Boss, Arena) vergeben werden; es gibt keinen Handler, der sie aus einem Kauf vergibt. Kristalle aus Training nur bei aktivem Training (Auto-Training gibt nur Kraft).
- `EggService`: vor jedem Öffnen `MonetizationService.CanBuyPaidRandomItems(player)` prüfen; bei `false` Ei sperren und auf den Pet-Shop verweisen.
- `Products.luau`: Starter-Pack (Server merkt sich den Kauf im `DataTemplate`, Prompt danach nicht mehr anzeigen) und Server-Boost (gilt für alle im Server, Ansage an alle).
- Neu (Kern): `CodeService` (Codes in Config, je Spieler nur einmal einlösbar, serverseitig), Einladen-Belohnung (Share-Link/`SocialService`), Gruppen-Belohnung (`Player:IsInGroup`, einmalig).
- Leaderboard v1: **höchste Ära + Rebirths**.
- `StatsService.GetPvPModifiers(player)` liefert die gedeckelten Boni. `BossService` (Kern: Belohnungen) und das gemeinsame Kampfsystem (Arena & Feel) sind neu.
- Neue Remotes in `Net.luau` in eigenem Abschnitt, alles serverseitig validiert (Arbeitsplan Vertrag 5 und `CLAUDE.md`).

## 8. Noch offen (Team)

- Endgültige Namen der Währungen (Trophäen/Kristalle sind Arbeitsnamen)
- Alle Zahlen: Boss-Belohnungen, Kosten, Raten, Zielzeit (5–7 / 2–3 Tage), Paketgrößen, Preise, PvP-Deckel, Pity-Grenze
- Rebirth- und Ära-Sprung-Zahlen (X Trophäen, Y Rebirths, Kraft-Faktor pro Ära, Rebirth-Bonus)
- Skilltree: Umfang pro Ära (Vorschlag: ein Baum, jede Ära schaltet einen Ast mit 3–5 Knoten frei)
- Update-Plan nach dem Launch (wöchentlich: neuer Boss / neues Ei / Event)
- Belohnungen für Codes, Einladen und Gruppen-Beitritt; Größe und Preis Starter-Pack; Dauer Server-Boost
