import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../models/report.dart';
import '../state/app_state.dart';

/// شاشة إنشاء بلاغ جديد (مفقود / موجود).
class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  ReportType _type = ReportType.lost;
  String? _category;
  String? _building;
  bool _photoAdded = false; // محاكاة إرفاق صورة
  bool _submitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 900)); // محاكاة الرفع
    if (!mounted) return;

    final state = context.read<AppState>();
    final user = state.currentUser!;
    state.addReport(Report(
      id: 'r${DateTime.now().millisecondsSinceEpoch}',
      type: _type,
      category: _category!,
      title: _titleCtrl.text.trim(),
      building: _building!,
      notes: _notesCtrl.text.trim(),
      imageUrl: '',
      status: ReportStatus.open,
      ownerId: user.uid,
      ownerName: user.name,
      ownerPhone: user.phone,
      createdAt: DateTime.now(),
    ));

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نشر البلاغ بنجاح ✅'),
        backgroundColor: AppTheme.found,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إبلاغ عن غرض')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // نوع البلاغ
            const Text('نوع البلاغ', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<ReportType>(
              segments: const [
                ButtonSegment(
                    value: ReportType.lost,
                    label: Text('مفقود'),
                    icon: Icon(Icons.search)),
                ButtonSegment(
                    value: ReportType.found,
                    label: Text('موجود'),
                    icon: Icon(Icons.volunteer_activism)),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            const SizedBox(height: 20),

            // الصورة (محاكاة)
            GestureDetector(
              onTap: () => setState(() => _photoAdded = !_photoAdded),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: Colors.grey.shade400,
                      style: BorderStyle.solid,
                      width: 1.2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                        _photoAdded
                            ? Icons.check_circle
                            : Icons.add_a_photo_outlined,
                        size: 40,
                        color: _photoAdded
                            ? AppTheme.found
                            : Colors.grey.shade600),
                    const SizedBox(height: 8),
                    Text(_photoAdded
                        ? 'تمت إضافة صورة'
                        : 'إضافة صورة (كاميرا / معرض)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // نوع الصنف
            DropdownButtonFormField<String>(
              initialValue: _category,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'نوع الصنف'),
              items: kItemCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v),
              validator: (v) => v == null ? 'اختر نوع الصنف' : null,
            ),
            const SizedBox(height: 16),

            // اسم/وصف المنتج
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'اسم / وصف المنتج',
                hintText: 'مثال: سمّاعة AirPods بيضاء',
              ),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'الرجاء إدخال اسم المنتج' : null,
            ),
            const SizedBox(height: 16),

            // المبنى
            DropdownButtonFormField<String>(
              initialValue: _building,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'المبنى / الموقع'),
              items: kBuildings
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (v) => setState(() => _building = v),
              validator: (v) => v == null ? 'اختر المبنى' : null,
            ),
            const SizedBox(height: 16),

            // ملاحظات
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'ملاحظات (اختياري)',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _submitting ? null : _submit,
              icon: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send),
              label: Text(_submitting ? 'جارٍ النشر...' : 'نشر البلاغ'),
            ),
          ],
        ),
      ),
    );
  }
}
