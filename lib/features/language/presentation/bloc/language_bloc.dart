import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState.initial()) {
    on<LanguageSearchChanged>(_onSearchChanged);
    on<LanguageSelected>(_onLanguageSelected);
    on<LanguageApplied>(_onLanguageApplied);
  }

  void _onSearchChanged(
    LanguageSearchChanged event,
    Emitter<LanguageState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onLanguageSelected(
    LanguageSelected event,
    Emitter<LanguageState> emit,
  ) {
    emit(state.copyWith(selectedLanguage: event.language, isApplied: false));
  }

  void _onLanguageApplied(
    LanguageApplied event,
    Emitter<LanguageState> emit,
  ) {
    // Here you would persist the choice (SharedPreferences, repository, etc.)
    emit(state.copyWith(isApplied: true));
  }
}
