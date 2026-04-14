import 'package:go_router/go_router.dart';
import '../../screens/welcome/welcome_screen.dart';
import '../../screens/calculator/madhab/madhab_selection_screen.dart';
import '../../screens/calculator/haul/haul_confirmation_screen.dart';
import '../../screens/calculator/gold_silver/gold_silver_screen.dart';
import '../../screens/calculator/cash/cash_screen.dart';
import '../../screens/calculator/jewellery/jewellery_screen.dart';
import '../../screens/calculator/investments/investments_screen.dart';
import '../../screens/calculator/business/business_screen.dart';
import '../../screens/calculator/debts_owed/debts_owed_screen.dart';
import '../../screens/calculator/debts_receivable/debts_receivable_screen.dart';
import '../../screens/calculator/large_liabilities/large_liabilities_screen.dart';
import '../../screens/calculator/unpaid_zakat/unpaid_zakat_screen.dart';
import '../../screens/calculator/nisab/nisab_screen.dart';
import '../../screens/calculator/results/results_screen.dart';
import '../../screens/runs/saved_runs_screen.dart';
import '../../screens/runs/run_detail_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/recipients/zakat_recipients_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const WelcomeScreen()),
    GoRoute(
      path: '/calculator/madhab',
      builder: (_, __) => const MadhabSelectionScreen(),
    ),
    GoRoute(
      path: '/calculator/haul',
      builder: (_, __) => const HaulConfirmationScreen(),
    ),
    GoRoute(
      path: '/calculator/gold-silver',
      builder: (_, __) => const GoldSilverScreen(),
    ),
    GoRoute(
      path: '/calculator/cash',
      builder: (_, __) => const CashScreen(),
    ),
    GoRoute(
      path: '/calculator/jewellery',
      builder: (_, __) => const JewelleryScreen(),
    ),
    GoRoute(
      path: '/calculator/investments',
      builder: (_, __) => const InvestmentsScreen(),
    ),
    GoRoute(
      path: '/calculator/business',
      builder: (_, __) => const BusinessScreen(),
    ),
    GoRoute(
      path: '/calculator/debts-owed',
      builder: (_, __) => const DebtsOwedScreen(),
    ),
    GoRoute(
      path: '/calculator/debts-receivable',
      builder: (_, __) => const DebtsReceivableScreen(),
    ),
    GoRoute(
      path: '/calculator/large-liabilities',
      builder: (_, __) => const LargeLiabilitiesScreen(),
    ),
    GoRoute(
      path: '/calculator/unpaid-zakat',
      builder: (_, __) => const UnpaidZakatScreen(),
    ),
    GoRoute(
      path: '/calculator/nisab',
      builder: (_, __) => const NisabScreen(),
    ),
    GoRoute(
      path: '/calculator/results',
      builder: (_, __) => const ResultsScreen(),
    ),
    GoRoute(
      path: '/runs',
      builder: (_, __) => const SavedRunsScreen(),
    ),
    GoRoute(
      path: '/runs/:runId',
      builder: (_, state) =>
          RunDetailScreen(runId: state.pathParameters['runId']!),
    ),
    GoRoute(
      path: '/settings',
      builder: (_, __) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/recipients',
      builder: (_, __) => const ZakatRecipientsScreen(),
    ),
  ],
);
