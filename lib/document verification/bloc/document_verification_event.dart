import 'package:equatable/equatable.dart';

abstract class DocumentVerificationEvent extends Equatable {
  const DocumentVerificationEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the screen first loads, to seed the document list.
class LoadDocuments extends DocumentVerificationEvent {
  const LoadDocuments();
}

/// Fired when the user taps "Upload PDF/JPG" or picks a replacement file.
class UploadDocument extends DocumentVerificationEvent {
  final String documentId;
  final String fileName;

  const UploadDocument({required this.documentId, required this.fileName});

  @override
  List<Object?> get props => [documentId, fileName];
}

/// Fired when the user removes a selected/uploaded file via the trash icon.
class RemoveDocument extends DocumentVerificationEvent {
  final String documentId;

  const RemoveDocument({required this.documentId});

  @override
  List<Object?> get props => [documentId];
}

/// Fired when the user taps the Submit button.
class SubmitVerification extends DocumentVerificationEvent {
  const SubmitVerification();
}
