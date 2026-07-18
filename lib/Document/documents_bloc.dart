import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ---------- MODEL ----------
enum DocStatus { verified, pending, rejected }

class DocumentItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final DocStatus status;

  const DocumentItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.status,
  });

  DocumentItem copyWith({DocStatus? status}) => DocumentItem(
        id: id,
        title: title,
        subtitle: subtitle,
        icon: icon,
        iconBg: iconBg,
        iconColor: iconColor,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [id, title, subtitle, status];
}

/// ---------- EVENTS ----------
abstract class DocumentsEvent extends Equatable {
  const DocumentsEvent();
  @override
  List<Object?> get props => [];
}

class LoadDocuments extends DocumentsEvent {}

class RefreshDocuments extends DocumentsEvent {}

/// ---------- STATE ----------
class DocumentsState extends Equatable {
  final List<DocumentItem> documents;
  final bool isLoading;
  final DateTime lastUpdated;

  const DocumentsState({
    required this.documents,
    required this.isLoading,
    required this.lastUpdated,
  });

  int get verifiedCount =>
      documents.where((d) => d.status == DocStatus.verified).length;

  int get totalCount => documents.length;

  double get verificationPercent =>
      totalCount == 0 ? 0 : verifiedCount / totalCount;

  bool get allVerified => verifiedCount == totalCount && totalCount > 0;

  DocumentsState copyWith({
    List<DocumentItem>? documents,
    bool? isLoading,
    DateTime? lastUpdated,
  }) {
    return DocumentsState(
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory DocumentsState.initial() => DocumentsState(
        documents: const [],
        isLoading: false,
        lastUpdated: DateTime.now(),
      );

  @override
  List<Object?> get props => [documents, isLoading, lastUpdated];
}

/// ---------- BLOC ----------
class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  DocumentsBloc() : super(DocumentsState.initial()) {
    on<LoadDocuments>(_onLoad);
    on<RefreshDocuments>(_onRefresh);
  }

  List<DocumentItem> _mockDocuments() => const [
        DocumentItem(
          id: 'reg_cert',
          title: 'Registration Certificate',
          subtitle: 'Official medical council doc',
          icon: Icons.description_rounded,
          iconBg: Color(0xFFEDE9FE),
          iconColor: Color(0xFF7C5CFC),
          status: DocStatus.verified,
        ),
        DocumentItem(
          id: 'med_license',
          title: 'Medical License',
          subtitle: 'Valid practicing license',
          icon: Icons.badge_rounded,
          iconBg: Color(0xFFD7F5E9),
          iconColor: Color(0xFF12A150),
          status: DocStatus.verified,
        ),
        DocumentItem(
          id: 'qual_degree',
          title: 'Qualification Degree',
          subtitle: 'MBBS/MD or equivalent',
          icon: Icons.school_rounded,
          iconBg: Color(0xFFDCEBFF),
          iconColor: Color(0xFF2F80ED),
          status: DocStatus.verified,
        ),
        DocumentItem(
          id: 'gov_id',
          title: 'Government ID Proof',
          subtitle: 'Passport, Driving License, etc.',
          icon: Icons.badge_outlined,
          iconBg: Color(0xFFFFE8D2),
          iconColor: Color(0xFFE8871E),
          status: DocStatus.verified,
        ),
      ];

  Future<void> _onLoad(
      LoadDocuments event, Emitter<DocumentsState> emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 400));
    emit(state.copyWith(
      documents: _mockDocuments(),
      isLoading: false,
      lastUpdated: DateTime(2026, 6, 22),
    ));
  }

  Future<void> _onRefresh(
      RefreshDocuments event, Emitter<DocumentsState> emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(isLoading: false, lastUpdated: DateTime.now()));
  }
}
