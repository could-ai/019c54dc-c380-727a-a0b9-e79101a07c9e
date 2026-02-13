import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/prompts.dart';
import '../services/mock_ai_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedLevel;
  PlatformFile? _selectedFile;
  bool _isGenerating = false;

  final List<String> _levels = [
    'Grade 9-10',
    'Undergraduate',
    'PhD / Researcher',
  ];

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _generateNotes() async {
    if (_selectedLevel == null || _selectedFile == null) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      // In a real app, we would extract text from the PDF here.
      // String extractedText = await PDFTextExtractor.extract(_selectedFile!.path);
      String extractedText = "Content from ${_selectedFile!.name}...";

      // Construct the prompt for debugging/verification purposes
      // This shows how the "Brain" works as requested
      final fullPrompt = AppPrompts.constructPrompt(_selectedLevel!, extractedText);
      debugPrint('--- SENDING TO AI ---\n$fullPrompt\n---------------------');

      // Call the mock service
      final notes = await MockAIService.generateNotes(_selectedLevel!, _selectedFile!.name);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            notes: notes,
            studentLevel: _selectedLevel!,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating notes: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'AI Study Architect',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Upload your textbook or research paper, select your level, and get tailored study notes instantly.',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // File Upload Section
            _buildUploadSection(),
            
            const SizedBox(height: 24),
            
            // Level Selection Section
            _buildLevelSelection(),
            
            const Spacer(),
            
            // Generate Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: (_selectedFile != null && _selectedLevel != null && !_isGenerating)
                    ? _generateNotes
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isGenerating
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Generate Notes',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 48,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          if (_selectedFile != null) ...[
            Text(
              _selectedFile!.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              '${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Change File'),
            ),
          ] else ...[
            const Text(
              'Select a PDF file',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _pickFile,
              child: const Text('Browse Files'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLevelSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Student Level',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedLevel,
              hint: const Text('Choose your academic level'),
              isExpanded: true,
              icon: const Icon(Icons.school_outlined),
              items: _levels.map((String level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLevel = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
