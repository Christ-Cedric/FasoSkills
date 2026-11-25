import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/request_bloc.dart';

class RequestQuoteScreen extends StatefulWidget {
  const RequestQuoteScreen({super.key});

  @override
  State<RequestQuoteScreen> createState() => _RequestQuoteScreenState();
}

class _RequestQuoteScreenState extends State<RequestQuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _cityController = TextEditingController(text: 'Ouagadougou');
  final _addressController = TextEditingController();
  String _selectedCategory = 'plomberie';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<RequestBloc>().add(
            CreateRequestSubmitted(
              title: _titleController.text.trim(),
              description: _descController.text.trim(),
              categoryId: _selectedCategory,
              city: _cityController.text.trim(),
              address: _addressController.text.trim(),
            ),
          );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une demande'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Décrivez votre besoin',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor),
              ),
              const SizedBox(height: 4),
              const Text(
                'Les artisans recevront votre demande et vous proposeront leurs devis.',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Corps de métier',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: AppTheme.inputFillColor,
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'plomberie', child: Text('Plomberie')),
                  DropdownMenuItem(
                      value: 'electricite', child: Text('Électricité')),
                  DropdownMenuItem(
                      value: 'menuiserie', child: Text('Menuiserie')),
                  DropdownMenuItem(
                      value: 'maconnerie', child: Text('Maçonnerie')),
                  DropdownMenuItem(value: 'peinture', child: Text('Peinture')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titre de la demande (ex: Fuite d’eau cuisine)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: AppTheme.inputFillColor,
                ),
                validator: (v) => v == null || v.trim().length < 5
                    ? 'Minimum 5 caractères requis'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description détaillée',
                  hintText:
                      'Précisez l’urgence, la panne constatée, les contraintes...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: AppTheme.inputFillColor,
                ),
                validator: (v) => v == null || v.trim().length < 10
                    ? 'Minimum 10 caractères requis'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'Ville',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: AppTheme.inputFillColor,
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ville requise' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Quartier / Adresse (facultatif)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: AppTheme.inputFillColor,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Publier la demande',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
