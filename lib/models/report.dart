import 'package:cloud_firestore/cloud_firestore.dart';

/// نوع البلاغ: مفقود أو موجود.
enum ReportType {
  lost, // مفقود
  found; // موجود

  String get label => this == ReportType.lost ? 'مفقود' : 'موجود';

  static ReportType fromString(String value) =>
      value == 'found' ? ReportType.found : ReportType.lost;
}

/// حالة البلاغ.
enum ReportStatus {
  open, // مفتوح
  resolved; // تم الحل

  String get label => this == ReportStatus.open ? 'مفتوح' : 'تم الحل';

  static ReportStatus fromString(String value) =>
      value == 'resolved' ? ReportStatus.resolved : ReportStatus.open;
}

/// نموذج البلاغ عن غرض مفقود أو موجود.
class Report {
  final String id;
  final ReportType type;
  final String category; // نوع الصنف
  final String title; // اسم/وصف المنتج
  final String building; // المبنى/الموقع
  final String notes; // ملاحظات
  final String imageUrl; // رابط الصورة في Storage
  final ReportStatus status;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final DateTime createdAt;

  const Report({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.building,
    required this.notes,
    required this.imageUrl,
    required this.status,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'category': category,
        'title': title,
        'building': building,
        'notes': notes,
        'imageUrl': imageUrl,
        'status': status.name,
        'ownerId': ownerId,
        'ownerName': ownerName,
        'ownerPhone': ownerPhone,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory Report.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? <String, dynamic>{};
    return Report(
      id: doc.id,
      type: ReportType.fromString((map['type'] ?? 'lost') as String),
      category: (map['category'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      building: (map['building'] ?? '') as String,
      notes: (map['notes'] ?? '') as String,
      imageUrl: (map['imageUrl'] ?? '') as String,
      status: ReportStatus.fromString((map['status'] ?? 'open') as String),
      ownerId: (map['ownerId'] ?? '') as String,
      ownerName: (map['ownerName'] ?? '') as String,
      ownerPhone: (map['ownerPhone'] ?? '') as String,
      createdAt:
          (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
