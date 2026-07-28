import 'package:equatable/equatable.dart';

abstract class DocumentVerificationEvent extends Equatable {
  const DocumentVerificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocuments extends DocumentVerificationEvent {
  const LoadDocuments();
}

class UploadDocument extends DocumentVerificationEvent {
  final String documentId;
  final String fileName;

  const UploadDocument({required this.documentId, required this.fileName});

  @override
  List<Object?> get props => [documentId, fileName];
}

class RemoveDocument extends DocumentVerificationEvent {
  final String documentId;

  const RemoveDocument({required this.documentId});

  @override
  List<Object?> get props => [documentId];
}

class SubmitVerification extends DocumentVerificationEvent {
  const SubmitVerification();
}
