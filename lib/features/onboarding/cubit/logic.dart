import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshop/features/onboarding/cubit/state.dart';

class OnboardingLogic extends Cubit<OnboardingState>{
  OnboardingLogic(): super(InitState());

  // Variables
  final PageController controller = PageController();

  void changePage() {
    controller.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    emit(ChangePage());
  }

  // Navigation
  void nextPage() {
    emit(NextPageState());
  }
}