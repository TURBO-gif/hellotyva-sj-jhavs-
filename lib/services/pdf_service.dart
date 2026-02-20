import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/resume_model.dart';
import '../templates/resume_template_mapper.dart';

class PdfService {
  Future<List<int>> generateResumePdf({
    required ResumeModel resume,
    required bool isPremium,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) => ResumeTemplateMapper.buildPdf(
          resume: resume,
          templateId: resume.templateId,
          showWatermark: !isPremium,
        ),
      ),
    );

    return doc.save();
  }

  Future<void> downloadPdf(List<int> bytes) async {
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  Future<void> sharePdf({
    required List<int> bytes,
    required String fileName,
  }) async {
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }
}
