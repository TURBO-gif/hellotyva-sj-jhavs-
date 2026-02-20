import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/resume_model.dart';

class ResumeTemplateMapper {
  static Widget buildPreview({
    required ResumeModel resume,
    required int templateId,
    required bool showWatermark,
  }) {
    switch (templateId) {
      case 2:
        return _modernPreview(resume, showWatermark);
      case 3:
        return _professionalPreview(resume, showWatermark);
      case 1:
      default:
        return _basicPreview(resume, showWatermark);
    }
  }

  static pw.Widget buildPdf({
    required ResumeModel resume,
    required int templateId,
    required bool showWatermark,
  }) {
    switch (templateId) {
      case 2:
        return _modernPdf(resume, showWatermark);
      case 3:
        return _professionalPdf(resume, showWatermark);
      case 1:
      default:
        return _basicPdf(resume, showWatermark);
    }
  }

  static Widget _baseSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  static Widget _basicPreview(ResumeModel resume, bool showWatermark) {
    return _previewContainer(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resume.fullName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text('${resume.phone} | ${resume.email}'),
          Text(resume.address),
        ],
      ),
      body: [
        _baseSection('Career Objective', resume.objective),
        _baseSection('Education', resume.education),
        _baseSection('Skills', resume.skills.join(', ')),
        _baseSection('Projects', resume.projects),
        _baseSection('Experience', resume.experience),
      ],
      showWatermark: showWatermark,
    );
  }

  static Widget _modernPreview(ResumeModel resume, bool showWatermark) {
    return _previewContainer(
      header: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              resume.fullName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(resume.phone),
              Text(resume.email),
            ],
          ),
        ],
      ),
      body: [
        _baseSection('Address', resume.address),
        _baseSection('Career Objective', resume.objective),
        _baseSection('Education', resume.education),
        _baseSection('Skills', resume.skills.join(', ')),
        _baseSection('Projects', resume.projects),
        _baseSection('Experience', resume.experience),
      ],
      showWatermark: showWatermark,
    );
  }

  static Widget _professionalPreview(ResumeModel resume, bool showWatermark) {
    return _previewContainer(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resume.fullName.toUpperCase(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const Divider(color: Colors.black, thickness: 1),
          Text('${resume.phone} | ${resume.email} | ${resume.address}'),
        ],
      ),
      body: [
        _baseSection('Career Objective', resume.objective),
        _baseSection('Education', resume.education),
        _baseSection('Core Skills', resume.skills.join(' • ')),
        _baseSection('Academic Projects', resume.projects),
        _baseSection('Experience / Internships', resume.experience),
      ],
      showWatermark: showWatermark,
    );
  }

  static Widget _previewContainer({
    required Widget header,
    required List<Widget> body,
    required bool showWatermark,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: 16),
          ...body,
          if (showWatermark)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Created with Resume Builder App',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _basicPdf(ResumeModel resume, bool showWatermark) {
    return _pdfContainer(
      header: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            resume.fullName,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text('${resume.phone} | ${resume.email}'),
          pw.Text(resume.address),
        ],
      ),
      sections: _basePdfSections(resume),
      showWatermark: showWatermark,
    );
  }

  static pw.Widget _modernPdf(ResumeModel resume, bool showWatermark) {
    return _pdfContainer(
      header: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Text(
              resume.fullName,
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [pw.Text(resume.phone), pw.Text(resume.email)],
          ),
        ],
      ),
      sections: <pw.Widget>[
        _pdfSection('Address', resume.address),
        ..._basePdfSections(resume),
      ],
      showWatermark: showWatermark,
    );
  }

  static pw.Widget _professionalPdf(ResumeModel resume, bool showWatermark) {
    return _pdfContainer(
      header: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            resume.fullName.toUpperCase(),
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(thickness: 1),
          pw.Text('${resume.phone} | ${resume.email} | ${resume.address}'),
        ],
      ),
      sections: <pw.Widget>[
        _pdfSection('Career Objective', resume.objective),
        _pdfSection('Education', resume.education),
        _pdfSection('Core Skills', resume.skills.join(' • ')),
        _pdfSection('Academic Projects', resume.projects),
        _pdfSection('Experience / Internships', resume.experience),
      ],
      showWatermark: showWatermark,
    );
  }

  static List<pw.Widget> _basePdfSections(ResumeModel resume) {
    return <pw.Widget>[
      _pdfSection('Career Objective', resume.objective),
      _pdfSection('Education', resume.education),
      _pdfSection('Skills', resume.skills.join(', ')),
      _pdfSection('Projects', resume.projects),
      _pdfSection('Experience', resume.experience),
    ];
  }

  static pw.Widget _pdfContainer({
    required pw.Widget header,
    required List<pw.Widget> sections,
    required bool showWatermark,
  }) {
    return pw.Container(
      color: PdfColor.fromInt(0xffffffff),
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          header,
          pw.SizedBox(height: 16),
          ...sections,
          if (showWatermark)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 16),
              child: pw.Text(
                'Created with Resume Builder App',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _pdfSection(String title, String content) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
          ),
          pw.SizedBox(height: 5),
          pw.Text(content),
        ],
      ),
    );
  }
}
