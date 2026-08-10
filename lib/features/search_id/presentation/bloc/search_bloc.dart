import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ---------------------------------------------------------------
/// A single search result row. Swap this for your real model
/// (e.g. Patient, Contact, etc.) as needed.
/// ---------------------------------------------------------------
class SearchResultItem {
  final String id;
  final String name;
  final String phone;

  const SearchResultItem({
    required this.id,
    required this.name,
    required this.phone,
  });
}

/// ---------------------------------------------------------------
/// Repository contract — replace SearchRepository's implementation
/// with a real API/DB call. Kept abstract so the Bloc doesn't care
/// where results come from.
/// ---------------------------------------------------------------
abstract class SearchRepository {
  Future<List<SearchResultItem>> search(String query);
}

/// Simple in-memory implementation for demo purposes.
class InMemorySearchRepository implements SearchRepository {
  final List<SearchResultItem> _all = const [
    SearchResultItem(id: 'P-1001', name: 'Ananya Rao', phone: '+91 9876543210'),
    SearchResultItem(
      id: 'P-1002',
      name: 'Rahul Mehta',
      phone: '+91 9123456780',
    ),
    SearchResultItem(id: 'P-1003', name: 'Sara Khan', phone: '+91 9988776655'),
  ];

  @override
  Future<List<SearchResultItem>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
    return _all
        .where(
          (item) =>
              item.name.toLowerCase().contains(q) ||
              item.phone.toLowerCase().contains(q) ||
              item.id.toLowerCase().contains(q),
        )
        .toList();
  }
}

// ------------------------------- Events -------------------------------

abstract class SearchEvent {
  const SearchEvent();
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
}

class SearchCleared extends SearchEvent {
  const SearchCleared();
}

// ------------------------------- States -------------------------------

enum SearchStatus { initial, loading, loaded, empty, failure }

class SearchState {
  final SearchStatus status;
  final String query;
  final List<SearchResultItem> results;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<SearchResultItem>? results,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      errorMessage: errorMessage,
    );
  }
}

// -------------------------------- Bloc ---------------------------------

class SearchIDBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  SearchIDBloc({required this.repository}) : super(const SearchState()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      // Debounce so we don't hit the repository on every keystroke.
      transformer: _debounce(const Duration(milliseconds: 350)),
    );
    on<SearchCleared>(_onCleared);
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query;

    if (query.trim().isEmpty) {
      emit(
        state.copyWith(
          status: SearchStatus.initial,
          query: query,
          results: const [],
        ),
      );
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading, query: query));

    try {
      final results = await repository.search(query);
      emit(
        state.copyWith(
          status: results.isEmpty ? SearchStatus.empty : SearchStatus.loaded,
          results: results,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(const SearchState());
  }
}

/// Small debounce transformer so we avoid pulling in an extra package
/// (e.g. rxdart / bloc_concurrency) just for this.
EventTransformer<E> _debounce<E>(Duration duration) {
  return (events, mapper) => events
      .transform(_DebounceStreamTransformer(duration))
      .asyncExpand(mapper);
}

class _DebounceStreamTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration duration;
  _DebounceStreamTransformer(this.duration);

  @override
  Stream<T> bind(Stream<T> stream) {
    late StreamController<T> controller;
    Timer? timer;

    controller = StreamController<T>(
      onListen: () {
        stream.listen(
          (data) {
            timer?.cancel();
            timer = Timer(duration, () => controller.add(data));
          },
          onError: controller.addError,
          onDone: () {
            timer?.cancel();
            controller.close();
          },
        );
      },
      onCancel: () => timer?.cancel(),
    );

    return controller.stream;
  }
}
