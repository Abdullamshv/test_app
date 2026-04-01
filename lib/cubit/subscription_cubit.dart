import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(SubscriptionInitial()) {
    // При создании кюбита сразу проверяем статус подписки
    checkSubscription();
  }

  static const String _prefKey = 'has_subscription';

  Future<void> checkSubscription() async {
    emit(SubscriptionLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSubscription = prefs.getBool(_prefKey) ?? false;
      
      if (hasSubscription) {
        emit(SubscriptionActive());
      } else {
        emit(SubscriptionInactive());
      }
    } catch (e) {
      // В реальном приложении здесь можно залогировать ошибку
      emit(SubscriptionInactive());
    }
  }

  Future<void> buySubscription() async {
    emit(SubscriptionLoading());
    // Имитируем сетевую задержку для красоты (показываем лоадер на кнопке)
    await Future.delayed(const Duration(milliseconds: 800)); 
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
    
    emit(SubscriptionActive());
  }

  // Метод для тестирования (сброс подписки)
  Future<void> resetSubscription() async {
    emit(SubscriptionLoading());
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
    
    emit(SubscriptionInactive());
  }
}