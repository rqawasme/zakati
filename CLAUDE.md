# Zakati — Claude Code Guide

## Project

**Zakati** is a Flutter mobile app for calculating Zakat, built by **Safi Solutions**.
It is an educational companion that walks users through their Zakat calculation step by step
with Islamic framing, contextual learning, and encouragement.

---

## Environment

- Flutter is installed on **Windows** at `G:\flutter_windows_3.3.0-stable\flutter`
- Claude Code runs in **WSL2** — the Flutter binary cannot be executed from WSL
- All `flutter` commands must be run by the user from **Windows PowerShell**
- Files are edited via WSL at `/mnt/c/Users/Rashonmyeed/Documents/Zakati/`
- Git is managed by the user — do not run `git push` or any destructive git commands

---

## Tech Stack

| Concern | Package |
|---|---|
| Framework | Flutter (Material Design 3) |
| State | `flutter_riverpod` 3.x — `Notifier` / `NotifierProvider` (not `StateNotifier`) |
| Navigation | `go_router` 17.x — linear stepper, no bottom nav |
| Storage | `hive` + `hive_flutter` — Hive adapters are hand-authored in `.g.dart` files, do NOT run build_runner |
| Fonts | `google_fonts` — Poppins throughout, Amiri for Arabic text |
| HTTP | `dio` — wired up but not yet used (reserved for future price APIs) |
| Formatting | `intl` — all currency formatting via `CurrencyFormatter` |

---

## Architecture

```
lib/
├── main.dart                        # Hive init, ProviderScope, MaterialApp.router
├── core/
│   ├── router/app_router.dart       # All go_router routes
│   ├── theme/                       # AppColors, AppTextStyles, AppTheme
│   └── utils/
│       ├── zakat_calculator.dart    # Pure Maliki calculation logic
│       ├── currency_formatter.dart  # CurrencyFormatter.format(amount, symbol: sym)
│       └── currencies.dart          # kCurrencies list + hardcoded exchange rates
├── models/
│   ├── zakat_calculation_state.dart # Immutable state, copyWith, resetCalculation()
│   ├── jewellery_item.dart          # HiveType(typeId: 1)
│   ├── zakat_run.dart               # HiveType(typeId: 0), fromState factory
│   └── *.g.dart                     # Hand-authored Hive adapters — do not regenerate
├── providers/
│   ├── zakat_provider.dart          # ZakatNotifier (NotifierProvider)
│   └── runs_provider.dart           # RunsNotifier (NotifierProvider), 30-run cap
├── screens/
│   ├── welcome/                     # WelcomeScreen — settings gear in AppBar
│   ├── settings/                    # SettingsScreen — currency + weight unit
│   ├── recipients/                  # ZakatRecipientsScreen — 4-tab madhab view of the 8 asnaf
│   ├── calculator/                  # 11 steps + nisab + results
│   └── runs/                        # SavedRunsScreen + RunDetailScreen
└── widgets/shared/
    ├── app_toast.dart               # AppToast.show() — overlay toast below AppBar (never bottom)
    ├── education_card.dart          # Gold-accented info card
    ├── step_progress_bar.dart       # Linear progress, step X of 11
    ├── zakati_app_bar.dart          # Consistent sage green AppBar; accepts optional `bottom` widget
    └── currency_input_field.dart    # CurrencyInputField + WeightInputField (reads from provider)
```

---

## Navigation Flow

```
/                          WelcomeScreen
/settings                  SettingsScreen
/recipients                Zakat Recipients — 4-tab educational screen (all madhabs)
/calculator/madhab         Step 1  — Madhab selection
/calculator/haul           Step 2  — Haul info (informational only, no input)
/calculator/gold-silver    Step 3  — Gold & silver weight
/calculator/cash           Step 4  — Cash & savings
/calculator/jewellery      Step 5  — Jewellery items
/calculator/investments    Step 6  — Coming soon
/calculator/business       Step 7  — Coming soon
/calculator/debts-owed     Step 8  — Debts owed
/calculator/debts-receivable Step 9 — Debts receivable
/calculator/large-liabilities Step 10 — Large liabilities
/calculator/unpaid-zakat   Step 11 — Unpaid previous Zakat
/calculator/nisab          Transitional — auto-computes, no input
/calculator/results        Results screen
/runs                      Saved runs list
/runs/:runId               Read-only run detail
```

---

## Brand & Design Rules

- **Primary colour:** Sage Green `#4A7C59` — buttons, AppBar, progress bar, active states
- **Accent colour:** Warm Gold `#B5862A` — nisab displays, jewellery labels, Zakat due amount, education card borders
- **Background:** Warm White `#F9F7F2` — never pure white
- **Font:** Poppins everywhere; Amiri for Arabic text (Bismillah on WelcomeScreen, Arabic asnaf names on recipients screen)
- Card border radius: `16`, shadow: `black 6% opacity, blur 8, offset (0,2)`
- Education cards: 3px left border in gold, `#FBF3E2` background fill
- All screens: `SingleChildScrollView`, horizontal padding `24`
- Continue button always fixed at bottom inside `SafeArea`
- **No SnackBars anywhere** — always use `AppToast.show(context, message)` (slides in just below AppBar)

---

## State

`ZakatCalculationState` is immutable with `copyWith`. Key fields:

- `currency`, `currencySymbol`, `exchangeRateFromUSD`, `weightUnit` — set in SettingsScreen
- `goldWeightGrams`, `silverWeightGrams` — always stored in grams internally; `WeightInputField` converts to/from oz
- `goldPricePerOz`, `silverPricePerOz` — hardcoded USD prices (see TODOs)
- `nisabUsed` — `'gold'` or `'silver'`, computed by `ZakatCalculator.determineNisab()`
- `breakdown` — `Map<String, double>` computed by `ZakatCalculator.compute()`
- `resetCalculation()` — resets inputs but preserves currency & weight unit prefs

All monetary formatting must pass the symbol: `CurrencyFormatter.format(amount, symbol: sym)`.

---

## Madhab Logic

- **Maliki** — fully implemented. Jewellery for beautification is exempt; investment jewellery is zakatable.
  - Nisab: gold nisab (85g) used in all cases *except* when silver is the sole zakatable asset, in which case silver nisab (595g) applies.
  - `ZakatCalculator.determineNisab()` implements this rule.
- **Hanafi / Shafi'i / Hanbali** — show `AppToast.show(context, 'Coming soon, insha\'Allah.')` and block progression.
- Zakat rate: **2.5%**
- Formula: `gold + silver + cash + jewellery(investment) + debtsReceivable − debtsOwed − (largeLiabilitiesMonthly × 12) − unpaidPreviousZakat`

---

## Zakat Recipients Screen

`/recipients` — `ZakatRecipientsScreen`

- Tabs: Maliki · Hanafi · Shafi'i · Hanbali (uses `DefaultTabController` + `TabBar` in AppBar `bottom`)
- Each tab renders identically structured content via `_MadhabView`:
  1. Quran 9:60 Arabic + English translation card
  2. Distribution rule info block (key madhab difference — Shafi'i requires all 8 categories)
  3. Al-Fuqara vs Al-Masakin info block (who is worse off differs by madhab)
  4. 8 numbered asnaf cards, each with Arabic name (Amiri), transliteration, madhab-specific description, and a badge where notable (e.g. "Abrogated in Hanafi" for Mu'allafatu Qulubuhum)
- All content is self-contained in the screen file as `const` data — no provider needed.

### Key inter-madhab differences encoded in the screen

| Point | Maliki | Hanafi | Shafi'i | Hanbali |
|---|---|---|---|---|
| Mu'allafatu Qulubuhum | Valid | Abrogated | Valid | Valid |
| Fuqara vs Masakin (worse off) | Fuqara | Masakin | Fuqara | Fuqara |
| Fi Sabilillah scope | Fighters (some extend) | Fighters only | Fighters only | Fighters (some extend) |
| Must distribute to all 8? | No | No | Yes | No |
| Al-Riqab today | Inapplicable | Inapplicable | Inapplicable | Some extend to captive ransom |

---

## Hive / Persistence

- Box name: `'zakat_runs'`, cap: **30 runs**
- `ZakatRun` — `typeId: 0`, fields 0–21 (fields 20–21 are `currency` and `currencySymbol`)
- `JewelleryItem` — `typeId: 1`, fields 0–5
- Adapters are hand-written in `.g.dart` files. **Do not run `build_runner`** — it is not in the dependencies and the generated files are maintained manually.
- New fields added to Hive models must: (1) get a new `@HiveField` index, (2) be added to the hand-authored `.g.dart` adapter, (3) use a nullable read with a default for backwards compatibility (e.g. `fields[20] as String? ?? 'CAD'`).

---

## Key TODOs

- `currencies.dart` — integrate live exchange rate API (Frankfurter, Open Exchange Rates, etc.)
- `zakat_calculator.dart` / `nisab_screen.dart` — replace hardcoded gold ($6,000/oz) and silver ($40/oz) prices with live API (GoldAPI.io or Metals.live)
- `investments_screen.dart` — implement stocks, crypto, and investment asset logic
- `business_screen.dart` — implement business asset calculation
- `settings_screen.dart` — consider adding language preference
- Madhab calculation logic for Hanafi, Shafi'i, Hanbali (recipients screen already covers educational content for all four)
