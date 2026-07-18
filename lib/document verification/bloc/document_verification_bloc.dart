import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/document%20verification/bloc/document_verification_state.dart';
import 'package:medicompare/document%20verification/document_model.dart';
import 'package:medicompare/document%20verification/bloc/document_verification_event.dart';

class DocumentVerificationBloc
    extends Bloc<DocumentVerificationEvent, DocumentVerificationState> {
  DocumentVerificationBloc() : super(const DocumentVerificationState()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<UploadDocument>(_onUploadDocument);
    on<RemoveDocument>(_onRemoveDocument);
    on<SubmitVerification>(_onSubmitVerification);
  }

  void _onLoadDocuments(
    LoadDocuments event,
    Emitter<DocumentVerificationState> emit,
  ) {
    emit(state.copyWith(documents: DocumentModel.initialDocuments()));
  }

  void _onUploadDocument(
    UploadDocument event,
    Emitter<DocumentVerificationState> emit,
  ) {
    final updated = state.documents.map((doc) {
      if (doc.id == event.documentId) {
        return doc.copyWith(
          status: DocumentStatus.selected,
          fileName: event.fileName,
        );
      }
      return doc;
    }).toList();

    emit(state.copyWith(documents: updated, clearError: true));
  }

  void _onRemoveDocument(
    RemoveDocument event,
    Emitter<DocumentVerificationState> emit,
  ) {
    final updated = state.documents.map((doc) {
      if (doc.id == event.documentId) {
        return doc.copyWith(
          status: DocumentStatus.notUploaded,
          clearFileName: true,
        );
      }
      return doc;
    }).toList();

    emit(state.copyWith(documents: updated));
  }

  Future<void> _onSubmitVerification(
    SubmitVerification event,
    Emitter<DocumentVerificationState> emit,
  ) async {
    if (!state.canSubmit) {
      emit(
        state.copyWith(
          errorMessage:
              'Please upload all required documents before submitting.',
        ),
      );
      return;
    }

    emit(state.copyWith(submissionStatus: SubmissionStatus.submitting));

    try {
      // Replace with a real repository/API call, e.g.:
      // await verificationRepository.submit(state.documents);
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(submissionStatus: SubmissionStatus.success));
    } catch (_) {
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.failure,
          errorMessage:
              'Something went wrong while submitting. Please try again.',
        ),
      );
    }
  }
}
