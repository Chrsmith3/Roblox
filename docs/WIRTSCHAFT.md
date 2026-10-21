# Wirtschaft und Monetarisierung

> Für Menschen **und KIs**. Wer Währungen, Belohnungen, Shop, Käufe, Skilltree, Waffen, Fähigkeiten, Eier oder PvP-Boni baut, hält sich an dieses Dokument. Der Spielinhalt steht im GDD (`docs/GDD.md`), die Rollen im Arbeitsplan (`docs/ARBEITSPLAN.md`).
> Stand: 2026-10-22 · Status: **v3, vom Team angenommen** (Währungsprinzip, Option (a), PvP-Brücke, Kampfsystem). Zahlen sind **OFFEN** und kommen in die Ökonomie-Tabelle (Kern & Ökonomie, Woche 0/1). Arbeitsnamen der Währungen können sich ändern.

## 1. Das Prinzip in einem Absatz

Man **trainiert** und baut **Kraft** auf. Mit Kraft besiegt man **Bosse** (und misst sich in der Arena), und beides gibt **Trophäen** und **Kristalle**. **Trophäen** gibt es nur durch Spielen und bezahlen Eier, Pets und den Ära-Sprung. **Kristalle** kann man erspielen oder mit Robux kaufen und bezahlen Skilltree, Waffen, Fähigkeiten und Attribute. Bosse und Arena nutzen **dasselbe Kampfsystem**. Im PvP wirkt alles Erspielte und Gekaufte nur gedeckelt, damit dort Können zählt.

## 2. Werte und Währungen

| Name (Arbeitsname) | Art | Woher | Wofür | Mit Robux kaufbar? |
|---|---|---|---|---|
| **Kraft** | Wert (keine Währung) | Training (klicken/schlagen in der Ära) | Bosse besiegen; schaltet bessere Trainings-Werkzeuge frei; im PvP stark abgeflacht und gedeckelt | Nur über Multiplikatoren (2× Kraft) |
| **Trophäen** | Währung | **nur erspielt:** Bosse, Arena | Eier, festes Pet im Shop, Ära-Sprung | **Nie** |
| **Kristalle** | Währung | **erspielt und kaufbar** | Skilltree-Knoten, Waffen, Fähigkeiten, Attribute, Umskillen | Ja (Pakete) |

## 3. Harte Regeln (gelten für jede Rolle und jede KI)

1. **Option (a) (Team, 2026-10-22):** Die Ei-Währung (Trophäen) ist **nie mit Robux kaufbar**, auch nicht indirekt.
2. **Kein Umtausch Kristalle → Trophäen**, keine Funktion, kein Shop-Eintrag und kein Boost, der Kristalle in Trophäen verwandelt oder Trophäen-Einnahmen für Robux erhöht (kein „2× Trophäen"-Boost). Sonst wäre es ein Umweg um Regel 1.
3. **Alles, was Kristalle kaufen, ist deterministisch.** Keine Waffen- oder Fähigkeiten-Kisten, kein Zufall. Zufall gibt es nur bei Eiern (mit Trophäen).
4. **Eier:** alle möglichen Ergebnisse mit Prozent-Odds vor dem Öffnen anzeigen (Summe 100 %), Pity-Zähler sichtbar und serverseitig gespeichert. Odds zeigen wir auch dann, wenn die Policy es wegen Regel 1 nicht verlangen würde. Der Policy-Check `MonetizationService.CanBuyPaidRandomItems` bleibt im Code; er ist nur relevant, falls je eine ei-bezogene Währung kaufbar würde (dann zuerst im Team klären).
5. **Nichts ist nur per Robux erhältlich** (außer Kosmetik). Robux kauft Zeitersparnis.
6. **Keine kaufbare Stärke über dem PvP-Deckel** (siehe Abschnitt 5).
7. Preise nie im Code, immer live von `MarketplaceService`. Käufe serverseitig, `ProcessReceipt` idempotent. Produkt-IDs pro Stufe (Dev/Staging/Live), Arbeitsplan Vertrag 8.
8. Keine FOMO-Timer, keine Casino-Optik (junge Zielgruppe). Keine Waffen-/Skin-Kisten.

## 4. Loop und Belohnungen

1. Trainieren → **Kraft** (+ kleine Menge Kristalle nebenbei).
2. Bosse der Ära besiegen (3 pro Ära: klein, mittel, Ära-Boss) → **Trophäen** und Kristalle.
3. Trophäen ausgeben: **Glück** = Ei öffnen, **sicher** = ein festes Pet im Shop kaufen (teurer als ein Ei).
4. Kristalle ausgeben: Skilltree, Waffen, Fähigkeiten, Attribute (sicherer, vorhersehbarer Fortschritt).
5. **Ära-Sprung:** Ära-Boss besiegt + X Trophäen. Pets, Trophäen, Kristalle und Skilltree bleiben (Vorschlag).
6. **Rebirth:** setzt Kraft und Trainings-Werkzeuge zurück, gibt dauerhaft +X % Kraft (Vorschlag).

**Was ein Boss gibt:**

| Ereignis | Trophäen | Kristalle |
|---|---|---|
| Boss besiegt (jedes Mal) | feste Menge, **Haupt-Ertrag** | kleine Menge |
| **Erster Sieg** gegen diesen Boss | normale Menge | **großer Bonus** (einmalig) |
| Ära-Boss zum ersten Mal | normale Menge | noch größerer Bonus, schaltet den Ära-Sprung frei |

Kristalle aus Boss-Wiederholungen bleiben bewusst klein: Sonst wäre Bosse-Farmen besser als Kaufen, und niemand kauft Pakete.

**Weitere Kristall-Quellen (erspielbar):**
- **Arena:** Teilnahme + Platzierung (dazu Trophäen)
- **Daily Reward + Streak**, **3 tägliche Quests**
- **Erfolge** (einmalig, z. B. Ära erreicht, 50 Arena-Siege)
- **Ära-Sprung-Bonus**
- kleine Rate beim Training

**Zielwert [Einschätzung, Zahlen offen]:** Ein Spieler ohne Kauf erreicht den vollständigen Build einer Ära in ca. 5–7 Tagen, ein zahlender in ca. 2–3. Zu schnell → niemand kauft, zu langsam → Frust und Abwanderung. Wird in der Ökonomie-Tabelle festgelegt und nach den ersten Messungen angepasst.

**Senken (damit nichts ins Leere läuft):** steigende Skilltree-Kosten, Waffen-Stufen, Umskillen gegen Gebühr.

## 5. Brücke PvE ↔ PvP

- **Ein Kampfsystem** für Bosse und Arena (Format A): gleiche Fähigkeiten, gleiche Steuerung, Treffer entscheidet der Server. Bosse sind damit das Training fürs PvP. „Arena & Feel" baut das System einmal.
- **Kraft** wirkt gegen Bosse **voll**, in der Arena **abgeflacht** (z. B. logarithmisch).
- **PvP-Deckel:** Alle Boni aus Pets, Skilltree, Waffen, Fähigkeiten, Kraft und gekauften Boosts zusammen wirken in der Arena höchstens mit ca. +20 % (Zahl OFFEN). Der Deckel steckt in `StatsService.GetPvPModifiers(player)`; die Arena rechnet nur mit dem Ergebnis.
- **Arena-Loadout:** 3 Fähigkeiten-Slots. Viele Fähigkeiten sind **Sidegrades** (andere Wirkung statt nur mehr Schaden). Skilltree-Punkte zählen in der Arena nur bis zu einer festen Obergrenze.
- **Belohnung:** Arena gibt Trophäen (Teilnahme + Platzierung) in einer Rate, die mit Bossfarmen vergleichbar ist, für gute Spieler etwas höher. Volle Belohnung nur gegen ähnlich starke Gegner (Kraft-/Rating-Bereich), abnehmend gegen denselben Gegner (gegen Absprachen und Zweitaccounts).
- **PvP-Meilensteine** statt eigener PvP-Währung: z. B. 10 / 50 / 200 Arena-Siege → Titel, Aura, exklusives PvP-Pet (gleicher Farm-Wert wie Ei-Pets, nur anders aussehend).
- **Matchmaking** nach Rating + Stärke-Stufe; v1 nur die Arena im eigenen Server, Ranked erst bei genug Spielern.

## 6. Womit wir Geld verdienen

**Game Passes (einmalig), v1:** VIP (+50 % Kraft, Chat-Tag), 2× Kraft, Auto-Training, +1/+2 Pet-Slots, 3 Eier auf einmal **[prüfen, ob das als Paid-Random-Item-Bezug gewertet wird; Odds ändern sich nicht]**.
**Developer Products (mehrfach):** **Kristall-Pakete** in Stufen, Zeit-Boosts (2× Kraft, 2× Kristalle für 30 min), später Boss-Abklingzeit überspringen.
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
- `CurrencyService`: Trophäen dürfen nur über erspielte Quellen (Boss, Arena) vergeben werden; es gibt keinen Handler, der sie aus einem Kauf vergibt.
- `StatsService.GetPvPModifiers(player)` liefert die gedeckelten Boni. `BossService` (Kern: Belohnungen) und das gemeinsame Kampfsystem (Arena & Feel) sind neu.
- Neue Remotes in `Net.luau` in eigenem Abschnitt, alles serverseitig validiert (Arbeitsplan Vertrag 5 und `CLAUDE.md`).

## 8. Noch offen (Team)

- Endgültige Namen der Währungen (Trophäen/Kristalle sind Arbeitsnamen)
- Alle Zahlen: Boss-Belohnungen, Kosten, Raten, Zielzeit (5–7 / 2–3 Tage), Paketgrößen, Preise, PvP-Deckel, Pity-Grenze
- Rebirth- und Ära-Sprung-Regel final (X Trophäen, was bleibt)
- Skilltree: Umfang pro Ära (Vorschlag: ein Baum, jede Ära schaltet einen Ast mit 3–5 Knoten frei)
- „3 Eier auf einmal" als Pass: policy-konform? (prüfen)
- Review durch Christopher (Spiele-Erfahrung): fehlt ein bewährtes Muster?
