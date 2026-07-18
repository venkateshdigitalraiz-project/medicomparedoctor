import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/document%20verification/bloc/document_verification_bloc.dart';
import 'package:medicompare/document%20verification/document_model.dart';
import 'package:medicompare/document%20verification/bloc/document_verification_event.dart';
import 'status_chip.dart';

class DocumentCard extends StatelessWidget {
  final DocumentModel document;

  const DocumentCard({super.key, required this.document});

  Future<void> _pickFile(BuildContext context) async {
    // Hook up file_picker / image_picker here. Kept simple so this
    // sample compiles without extra native permissions configured.
    //
    // Example with file_picker:
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf', 'jpg', 'jpeg'],
    // );
    // if (result == null) return;
    // final fileName = result.files.single.name;

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
            color: Colors.black.withOpacity(0.04),
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
          // const SizedBox(height: 12),
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
              // padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
