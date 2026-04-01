import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/subscription_cubit.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Сбросить подписку (для теста)',
            onPressed: () async {
              // Очищаем кэш через бизнес-логику Cubit
              await context.read<SubscriptionCubit>().resetSubscription();
              
              // Поскольку RootScreen слушает изменения, нам не обязательно
              // делать Navigator.pushReplacement. Если этот экран показан через RootScreen,
              // он обновится сам. Но если мы использовали push, нужно сбросить стек:
              if (!context.mounted) return;
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star_rounded, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'Спасибо за покупку!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Весь премиум контент теперь доступен.',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}