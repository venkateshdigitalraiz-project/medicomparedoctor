import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/auth/document_verification/presentation/bloc/document_verification_bloc.dart';
import 'package:medicompare/features/auth/document_verification/data/models/document_model.dart';
import 'package:medicompare/features/auth/document_verification/presentation/bloc/document_verification_event.dart';
import 'status_chip.dart';

class DocumentCard extends StatelessWidget {
  final DocumentModel document;

  const DocumentCard({super.key, required this.document});

  Future<void> _pickFile(BuildContext context) async {
    const fileName = 'uploaded_document.pdf'; // placeholder for the demo

    context.read<DocumentVerificationBloc>().add(
      UploadDocument(documentId: document.id, fileName: fileName),
    );
  }

  void _removeFile(BuildContext context) {
    context.read<DocumentVerificationBloc>().add(
      RemoveDocument(documentId: document.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = document.fileName != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3ECFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(document.icon, color: const Color(0xFF3A3A3A)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F24),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      document.subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF8B8B94),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              StatusChip(status: document.status),
            ],
          ),
          if (!hasFile)
            GestureDetector(
              onTap: () => _pickFile(context),
              child: Row(
                children: [
                  SizedBox(width: 44, height: 44),
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 18,
                    color: Color(0xFF6C2BD9),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Upload PDF/JPG',
                    style: TextStyle(
                      color: document.status == DocumentStatus.notUploaded
                          ? const Color(0xFFB5B5BD)
                          : const Color(0xFF6C2BD9),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE4E4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf,
                      size: 16,
                      color: Color(0xFFE05353),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      document.fileName!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Color(0xFF4A4A52),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _removeFile(context),
                    child: const Icon(
                      Icons.auto_delete,
                      size: 25,
                      color: Color(0xFFE05353),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
