// TODO: Find and integrate a live exchange rate API to replace hardcoded rates.
// Options to evaluate: Open Exchange Rates (openexchangerates.org),
// Frankfurter (frankfurter.app — free, no key), ExchangeRate-API
// (exchangerate-api.com), or Fixer (fixer.io). Fetch on app launch and
// cache locally with a TTL (e.g. 24h via Hive). Fall back to hardcoded
// rates if the fetch fails.
// Rates are approximate as of early 2025, relative to USD.

class CurrencyOption {
  final String code;
  final String symbol;
  final String name;
  final double rateFromUSD;

  const CurrencyOption({
    required this.code,
    required this.symbol,
    required this.name,
    required this.rateFromUSD,
  });

  @override
  String toString() => '$name ($code)';
}

const List<CurrencyOption> kCurrencies = [
  CurrencyOption(code: 'CAD', symbol: '\$',  name: 'Canadian Dollar',      rateFromUSD: 1.36),
  CurrencyOption(code: 'USD', symbol: '\$',  name: 'US Dollar',            rateFromUSD: 1.00),
  CurrencyOption(code: 'GBP', symbol: '£',   name: 'British Pound',        rateFromUSD: 0.79),
  CurrencyOption(code: 'EUR', symbol: '€',   name: 'Euro',                 rateFromUSD: 0.92),
  CurrencyOption(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham',           rateFromUSD: 3.67),
  CurrencyOption(code: 'SAR', symbol: '﷼',   name: 'Saudi Riyal',          rateFromUSD: 3.75),
  CurrencyOption(code: 'PKR', symbol: '₨',   name: 'Pakistani Rupee',      rateFromUSD: 278.0),
  CurrencyOption(code: 'EGP', symbol: '£',   name: 'Egyptian Pound',       rateFromUSD: 48.0),
  CurrencyOption(code: 'MYR', symbol: 'RM',  name: 'Malaysian Ringgit',    rateFromUSD: 4.72),
  CurrencyOption(code: 'BDT', symbol: '৳',   name: 'Bangladeshi Taka',     rateFromUSD: 110.0),
  CurrencyOption(code: 'TRY', symbol: '₺',   name: 'Turkish Lira',         rateFromUSD: 32.0),
  CurrencyOption(code: 'IDR', symbol: 'Rp',  name: 'Indonesian Rupiah',    rateFromUSD: 15700.0),
];

CurrencyOption currencyByCode(String code) =>
    kCurrencies.firstWhere((c) => c.code == code,
        orElse: () => kCurrencies.first);
