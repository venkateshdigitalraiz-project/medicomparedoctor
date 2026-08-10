part of 'language_bloc.dart';

/// Simple model representing a language option.
class LanguageModel extends Equatable {
  final String code;
  final String name;

  const LanguageModel({required this.code, required this.name});

  @override
  List<Object?> get props => [code, name];
}

class LanguageState extends Equatable {
  final List<LanguageModel> allLanguages;
  final String searchQuery;
  final LanguageModel selectedLanguage;
  final bool isApplied;

  const LanguageState({
    required this.allLanguages,
    required this.searchQuery,
    required this.selectedLanguage,
    this.isApplied = false,
  });

  /// Languages filtered by the current search query.
  List<LanguageModel> get filteredLanguages {
    if (searchQuery.trim().isEmpty) return allLanguages;
    final q = searchQuery.toLowerCase();
    return allLanguages
        .where((lang) => lang.name.toLowerCase().contains(q))
        .toList();
  }

  factory LanguageState.initial() {
    const languages = [
      LanguageModel(code: 'en', name: 'English'),
      LanguageModel(code: 'te', name: 'Telugu'),
      LanguageModel(code: 'hi', name: 'Hindi'),
      LanguageModel(code: 'ta', name: 'Tamil'),
      LanguageModel(code: 'hi2', name: 'Hindi'),
      LanguageModel(code: 'kn', name: 'Kannada'),
    ];
    return LanguageState(
      allLanguages: languages,
      searchQuery: '',
      selectedLanguage: languages[0],
    );
  }

  LanguageState copyWith({
    List<LanguageModel>? allLanguages,
    String? searchQuery,
    LanguageModel? selectedLanguage,
    bool? isApplied,
  }) {
    return LanguageState(
      allLanguages: allLanguages ?? this.allLanguages,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  @override
  List<Object?> get props => [
    allLanguages,
    searchQuery,
    selectedLanguage,
    isApplied,
  ];
}
