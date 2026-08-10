part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the user searches inside the language list.
class LanguageSearchChanged extends LanguageEvent {
  final String query;
  const LanguageSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Fired when the user taps a language row (radio selection).
class LanguageSelected extends LanguageEvent {
  final LanguageModel language;
  const LanguageSelected(this.language);

  @override
  List<Object?> get props => [language];
}

/// Fired when the user taps the "Apply Language" button.
class LanguageApplied extends LanguageEvent {
  const LanguageApplied();
}
