import 'package:flutter/foundation.dart';

@immutable
abstract class SubscriptionState {}

// Начальное состояние (до проверки)
class SubscriptionInitial extends SubscriptionState {}

// Состояние загрузки (во время обращения к SharedPreferences)
class SubscriptionLoading extends SubscriptionState {}

// Подписка активна (пользователь купил)
class SubscriptionActive extends SubscriptionState {}

// Подписки нет (нужно показать пейвол)
class SubscriptionInactive extends SubscriptionState {}