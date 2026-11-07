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
  resolved; // تم العثور عليه

  String get label =>
      this == ReportStatus.open ? 'مفتوح' : 'تم العثور عليه';

  static ReportStatus fromString(String value) =>
      value == 'resolved' ? ReportStatus.resolved : ReportStatus.open;
}

/// نموذج البلاغ عن غرض مفقود أو موجود.
///
/// نموذج Dart نقي حتى يعمل في أي منصة بدون باك-إند.
/// ستُضاف دوال التحويل من/إلى Firestore في طبقة الخدمات (services) في المرحلة 3.
class Report {
  final String id;
  final ReportType type;
  final String category; // نوع الصنف
  final String title; // اسم/وصف المنتج
  final String building; // المبنى/الموقع (قد يكون فارغاً إذا غير محدّد)
  final bool approximateLocation; // المكان تقريبي/غير مؤكد
  final String notes; // ملاحظات
  final String imageUrl; // رابط/مسار الصورة
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
    this.approximateLocation = false,
    required this.notes,
    required this.imageUrl,
    required this.status,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.createdAt,
  });

  Report copyWith({ReportStatus? status}) => Report(
        id: id,
        type: type,
        category: category,
        title: title,
        building: building,
        approximateLocation: approximateLocation,
        notes: notes,
        imageUrl: imageUrl,
        status: status ?? this.status,
        ownerId: ownerId,
        ownerName: ownerName,
        ownerPhone: ownerPhone,
        createdAt: createdAt,
      );

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'category': category,
        'title': title,
        'building': building,
        'approximateLocation': approximateLocation,
        'notes': notes,
        'imageUrl': imageUrl,
        'status': status.name,
        'ownerId': ownerId,
        'ownerName': ownerName,
        'ownerPhone': ownerPhone,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Report.fromMap(String id, Map<String, dynamic> map) => Report(
        id: id,
        type: ReportType.fromString((map['type'] ?? 'lost') as String),
        category: (map['category'] ?? '') as String,
        title: (map['title'] ?? '') as String,
        building: (map['building'] ?? '') as String,
        approximateLocation: (map['approximateLocation'] ?? false) as bool,
        notes: (map['notes'] ?? '') as String,
        imageUrl: (map['imageUrl'] ?? '') as String,
        status: ReportStatus.fromString((map['status'] ?? 'open') as String),
        ownerId: (map['ownerId'] ?? '') as String,
        ownerName: (map['ownerName'] ?? '') as String,
        ownerPhone: (map['ownerPhone'] ?? '') as String,
        createdAt: DateTime.tryParse((map['createdAt'] ?? '') as String) ??
            DateTime.now(),
      );
}
