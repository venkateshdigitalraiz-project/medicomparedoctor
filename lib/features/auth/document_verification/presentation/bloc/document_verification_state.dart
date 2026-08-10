import 'package:equatable/equatable.dart';
import 'package:medicompare/features/auth/document_verification/data/models/document_model.dart';

enum SubmissionStatus { idle, submitting, success, failure }

class DocumentVerificationState extends Equatable {
  final List<DocumentModel> documents;
  final SubmissionStatus submissionStatus;
  final String? errorMessage;

  const DocumentVerificationState({
    this.documents = const [],
    this.submissionStatus = SubmissionStatus.idle,
    this.errorMessage,
  });

  int get completedCount => documents
      .where(
        (d) =>
            d.status == DocumentStatus.selected ||
            d.status == DocumentStatus.approved,
      )
      .length;

  int get totalCount => documents.length;

  bool get canSubmit =>
      documents.isNotEmpty &&
      documents.every(
        (d) =>
            d.status == DocumentStatus.selected ||
            d.status == DocumentStatus.approved,
      ) &&
      submissionStatus != SubmissionStatus.submitting;

  DocumentVerificationState copyWith({
    List<DocumentModel>? documents,
    SubmissionStatus? submissionStatus,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DocumentVerificationState(
      documents: documents ?? this.documents,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [documents, submissionStatus, errorMessage];
}
