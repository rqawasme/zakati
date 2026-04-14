# Zakati

**Zakati** is a Flutter mobile app for calculating Zakat, built by **Safi Solutions**.

Zakat is the third pillar of Islam — an obligatory annual act of worship in which Muslims give 2.5% of their qualifying wealth to those in need. Zakati walks users through the full calculation step by step with education, Islamic context, and encouragement along the way.

---

## Features

- **Step-by-step Zakat calculator** — guided flow covering gold, silver, cash, jewellery, investments, debts, and liabilities
- **Maliki madhab** — fully implemented with correct nisab selection logic (gold nisab by default; silver nisab only when silver is the sole zakatable asset)
- **Nisab screen** — shows today's nisab threshold in local currency with an explanation of which threshold applies and why
- **Jewellery handling** — Maliki ruling correctly applied: beautification jewellery is exempt, investment jewellery is zakatable
- **Zakat recipients** — educational screen covering all four Sunni madhabs with per-madhab descriptions of the eight categories (asnaf), including key differences such as the Hanafi position on Mu'allafatu Qulubuhum and the Shafi'i distribution requirement
- **Currency support** — 12 currencies with approximate exchange rates (live API planned)
- **Weight unit toggle** — grams or troy oz throughout, with consistent internal storage in grams
- **Saved runs** — up to 30 past calculations stored locally via Hive, viewable in read-only detail
- **Results breakdown** — itemised view of all assets and deductions with Zakat due highlighted

---

## Screenshots

_Coming soon._

---

## Getting Started

### Prerequisites

- Flutter SDK (stable channel) — Windows installation required; see environment note below
- Android Studio or VS Code with Flutter extension
- A connected Android device or emulator

### Environment

Zakati is developed in a WSL2 environment but Flutter itself runs on Windows. All `flutter` commands must be run from **Windows PowerShell**, not WSL.

```powershell
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Build release APK
flutter build apk --release
```

---

## Project Structure

```
lib/
├── main.dart                        # Entry point — Hive init, ProviderScope
├── core/
│   ├── router/app_router.dart       # All routes (go_router)
│   ├── theme/                       # AppColors, AppTextStyles, AppTheme
│   └── utils/
│       ├── zakat_calculator.dart    # Pure Maliki calculation logic
│       ├── currency_formatter.dart  # Monetary display formatting
│       └── currencies.dart          # Supported currencies + exchange rates
├── models/                          # Immutable data models + Hive adapters
├── providers/                       # Riverpod state (ZakatNotifier, RunsNotifier)
├── screens/
│   ├── welcome/                     # Home screen
│   ├── settings/                    # Currency + weight unit preferences
│   ├── recipients/                  # Zakat recipients — 4-tab madhab view
│   ├── calculator/                  # 11-step calculator flow
│   └── runs/                        # Saved runs list + detail
└── widgets/shared/                  # Reusable components
```

---

## Tech Stack

| Concern | Choice |
|---|---|
| Framework | Flutter (Material Design 3) |
| State management | flutter_riverpod 3.x (`Notifier` / `NotifierProvider`) |
| Navigation | go_router 17.x |
| Local storage | Hive + hive_flutter |
| Fonts | Google Fonts — Poppins (UI), Amiri (Arabic text) |
| HTTP client | dio (reserved for live price APIs) |
| Number formatting | intl |

---

## Calculation Formula (Maliki)

```
Zakatable Wealth =
  Gold value
  + Silver value
  + Cash (bank + in hand)
  + Jewellery held for investment (at current gold/silver price)
  + Debts receivable
  − Debts owed
  − Large liabilities (monthly amount × 12)
  − Unpaid previous Zakat

Zakat Due = Zakatable Wealth × 2.5%  (if Zakatable Wealth ≥ Nisab)
```

**Nisab selection (Maliki rule):**
- Silver nisab (595g of silver) — only when silver is the *sole* zakatable asset
- Gold nisab (85g of gold) — in all other cases

---

## Zakat Recipients (Asnaf)

The app includes a dedicated educational screen covering all eight Quranic categories of Zakat recipients (Quran 9:60), with madhab-specific descriptions for Maliki, Hanafi, Shafi'i, and Hanbali.

Key inter-madhab differences:

| Category | Maliki | Hanafi | Shafi'i | Hanbali |
|---|---|---|---|---|
| Mu'allafatu Qulubuhum | Valid | Abrogated | Valid | Valid |
| Who is more destitute? | Fuqara | Masakin | Fuqara | Fuqara |
| Must distribute to all 8? | No | No | Yes | No |
| Fi Sabilillah scope | Fighters (some extend) | Fighters only | Fighters only | Fighters (some extend) |

---

## Roadmap

- [ ] Live gold and silver price API (GoldAPI.io or Metals.live)
- [ ] Live exchange rate API (Frankfurter or Open Exchange Rates)
- [ ] Investments screen — stocks, crypto, investment funds
- [ ] Business assets screen
- [ ] Hanafi, Shafi'i, and Hanbali calculation logic
- [ ] Language preference setting
- [ ] iOS support and App Store release

---

## Islamic Disclaimer

Zakati is an educational tool intended to assist with Zakat estimation. It is not a fatwa and does not replace the advice of a qualified scholar. If you have specific questions about your Zakat obligation, please consult a knowledgeable Islamic authority.

---

## Built by Safi Solutions
