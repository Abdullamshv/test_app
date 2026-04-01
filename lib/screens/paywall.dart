import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cubit/subscription_cubit.dart';
import '../widgets/subscription.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  int selectedIndex = 1; // 1 - Год (значение по умолчанию)
  bool isLoading = true; // Флаг для ожидания загрузки из памяти

  @override
  void initState() {
    super.initState();
    _loadSelectedSubscription();
  }

  // 1. Читаем сохраненный выбор при запуске экрана
  Future<void> _loadSelectedSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Если ничего не сохранено, оставляем 1 (Год)
      selectedIndex = prefs.getInt('selected_subscription_index') ?? 1;
      isLoading = false; 
    });
  }

  // 2. Сохраняем выбор каждый раз, когда пользователь кликает на вариант
  Future<void> _updateSelectedSubscription(int index) async {
    setState(() {
      selectedIndex = index;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_subscription_index', index);
  }

  Future<void> _buySubscription() async {
    await context.read<SubscriptionCubit>().buySubscription();
    
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    // Пока грузим данные из памяти, показываем лоадер, чтобы не моргал UI
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Определяем текст для нового виджета на основе индекса
    final String currentPlanName = selectedIndex == 0 ? '1 Месяц (\$9.99)' : '1 Год (\$4.99/мес)';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Премиум доступ',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Выберите план, который подходит именно вам.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              
              // --- НОВЫЙ ВИДЖЕТ ---
              // Отображает текущую сохраненную подписку
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.deepPurple.shade200, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Текущий выбор:',
                      style: TextStyle(fontSize: 14, color: Colors.deepPurple, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentPlanName,
                      style: const TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
              // --------------------

              const SizedBox(height: 32),
              
              SubscriptionOption(
                title: '1 Месяц',
                price: '\$9.99 / мес',
                isSelected: selectedIndex == 0,
                onTap: () => _updateSelectedSubscription(0),
              ),
              const SizedBox(height: 16),
              
              SubscriptionOption(
                title: '1 Год',
                price: '\$4.99 / мес',
                badgeText: 'Выгода 50%',
                isSelected: selectedIndex == 1,
                onTap: () => _updateSelectedSubscription(1),
              ),
              
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _buySubscription,
                  child: const Text('Продолжить', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}