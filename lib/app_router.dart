import 'package:budget_envelopes/features/envelope/presentation/pages/envelope_add_page.dart';
import 'package:budget_envelopes/features/envelope/presentation/pages/envelope_details.dart';
import 'package:budget_envelopes/features/envelope/presentation/pages/overview.dart';
import 'package:budget_envelopes/features/envelope/presentation/pages/transaction_add.dart';
import 'package:go_router/go_router.dart';

import 'features/home/presentation/pages/home_page.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/envelope',
      builder: (context, state) => const OverView(),
    ),
    GoRoute(
      path: '/envelope/add',
      builder: (context, state) => const EnvelopeAddPage(),
    ),
    GoRoute(
      path: '/envelope/details',
      builder: (context, state) => EnvelopeDetails(),
    ),
    GoRoute(
      path: '/envelope/transaction',
      builder: (context, state) => const TransactionAdd(),
    )
  ],
);
