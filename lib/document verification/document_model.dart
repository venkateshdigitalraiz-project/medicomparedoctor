import 'package:flutter/material.dart';

/// Upload status for a single required document.
enum DocumentStatus { notUploaded, pending, selected, approved, rejected }

/// Represents one required document card on the Doctor Verification screen.
class DocumentModel {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final DocumentStatus status;
  final String? fileName;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.status = DocumentStatus.notUploaded,
    this.fileName,
  });

  DocumentModel copyWith({
    DocumentStatus? status,
    String? fileName,
    bool clearFileName = false,
  }) {
    return DocumentModel(
      id: id,
      title: title,
      subtitle: subtitle,
      icon: icon,
      status: status ?? this.status,
      fileName: clearFileName ? null : (fileName ?? this.fileName),
    );
  }

  /// Seed data matching the four documents in the design.
  static List<DocumentModel> initialDocuments() {
    return const [
      DocumentModel(
        id: 'registration_certificate',
        title: 'Registration Certificate',
        subtitle: 'Official medical council document',
        icon: Icons.verified_outlined,
        status: DocumentStatus.pending,
      ),
      DocumentModel(
        id: 'medical_license',
        title: 'Medical License',
        subtitle: 'Valid practicing license',
        icon: Icons.badge_outlined,
        status: DocumentStatus.notUploaded,
      ),
      DocumentModel(
        id: 'qualification_degree',
        title: 'Qualification Degree',
        subtitle: 'MBBS/MD or equivalent',
        icon: Icons.school_outlined,
        status: DocumentStatus.notUploaded,
      ),
      DocumentModel(
        id: 'government_id',
        title: 'Government ID',
        subtitle: 'Passport, Driving License, etc.',
        icon: Icons.badge,
        status: DocumentStatus.selected,
        fileName: 'passport_copy_final.pdf',
      ),
    ];
  }
}
