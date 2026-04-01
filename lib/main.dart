import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/subscription_cubit.dart';
import 'cubit/subscription_state.dart';
import 'screens/main.dart';
import 'screens/onboarding.dart';
import 'screens/paywall.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Предоставляем Cubit всему дереву виджетов
    return BlocProvider(
      create: (context) => SubscriptionCubit(),
      child: MaterialApp(
        title: 'Paywall App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // Корневой виджет сам решит, что показать, опираясь на стейт
        home: const RootScreen(),
        routes: {
          '/paywall': (context) => const PaywallScreen(),
          '/main': (context) => const MainScreen(),
        },
      ),
    );
  }
}

// Умный виджет, который слушает состояние Cubit и переключает экраны
class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionLoading || state is SubscriptionInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is SubscriptionActive) {
          return const MainScreen();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }
}