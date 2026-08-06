import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/searchId/search_bloc.dart';

class SearchIDScreen extends StatelessWidget {
  const SearchIDScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchIDBloc(repository: InMemorySearchRepository()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  static const Color headerBg = Color(0xFFE9F1FF);
  static const Color hintColor = Color(0xFF9AA0A6);
  static const Color iconColor = Color(0xFF1C1C1E);

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Autofocus + show the cursor immediately, matching the reference
    // screen where the search field is already active.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---------------- Header: back arrow + search bar ----------------
            Container(
              decoration: const BoxDecoration(
                color: headerBg,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(12, 20, 24, 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back, color: iconColor),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          const Icon(Icons.search, color: hintColor, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              cursorColor: iconColor,
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: "Poopins",
                                color: iconColor,
                              ),
                              decoration: const InputDecoration(
                                isCollapsed: true,
                                border: InputBorder.none,
                                hintText: 'Search by name, phone, or ID',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: hintColor,
                                ),
                              ),
                              onChanged: (value) {
                                context.read<SearchIDBloc>().add(
                                  SearchQueryChanged(value),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- Results area ----------------
            Expanded(
              child: BlocBuilder<SearchIDBloc, SearchState>(
                builder: (context, state) {
                  switch (state.status) {
                    case SearchStatus.initial:
                      return const SizedBox.shrink();

                    case SearchStatus.loading:
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: AppLoader(
                            color: const Color(0xFF6D28D9),
                            size: 40,
                          ),
                        ),
                      );

                    case SearchStatus.empty:
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Text(
                            'No results for "${state.query}"',
                            style: const TextStyle(
                              fontSize: 14,
                              color: hintColor,
                            ),
                          ),
                        ),
                      );

                    case SearchStatus.failure:
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Text(
                            state.errorMessage ?? 'Something went wrong',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );

                    case SearchStatus.loaded:
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: state.results.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = state.results[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: headerBg,
                              child: Text(
                                item.name.isNotEmpty
                                    ? item.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(color: iconColor),
                              ),
                            ),
                            title: Text(item.name),
                            subtitle: Text('${item.phone}  •  ${item.id}'),
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
