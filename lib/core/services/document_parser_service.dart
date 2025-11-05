import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:xml/xml.dart';

class DocumentParserService {
  Future<String> extractText(File file) async {
    return extractTextFromBytes(
      await file.readAsBytes(),
      fileName: file.path,
      fallbackReader: () => file.readAsString(),
    );
  }

  Future<String> extractTextFromBytes(
    Uint8List bytes, {
    required String fileName,
    Future<String> Function()? fallbackReader,
  }) async {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.pdf')) {
      return _extractFromPdf(bytes);
    }
    if (lower.endsWith('.docx')) {
      return _extractFromDocx(bytes);
    }
    if (lower.endsWith('.txt') && fallbackReader != null) {
      return fallbackReader();
    }
    throw UnsupportedError('Unsupported file type for AI review extraction.');
  }

  Future<String> _extractFromPdf(Uint8List bytes) async {
    final document = PdfDocument(inputBytes: bytes);
    final buffer = StringBuffer();
    final extractor = PdfTextExtractor(document);
    for (var i = 0; i < document.pages.count; i++) {
      buffer.writeln(
        extractor.extractText(startPageIndex: i, endPageIndex: i).trim(),
      );
    }
    document.dispose();
    return buffer.toString();
  }

  Future<String> _extractFromDocx(Uint8List bytes) async {
    final archive = ZipDecoder().decodeBytes(bytes);
    final documentFile = archive.files.firstWhere(
      (file) => file.name == 'word/document.xml',
      orElse: () => throw UnsupportedError('Invalid DOCX file structure.'),
    );

    final xmlBytes = documentFile.content as List<int>;
    final xmlString = utf8.decode(xmlBytes);
    final document = XmlDocument.parse(xmlString);

    final buffer = StringBuffer();
    for (final node in document.findAllElements('w:t')) {
      buffer.write(node.innerText);
    }

    return buffer.toString();
  }
}
