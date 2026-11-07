# موجود (Mawjod) 📍

تطبيق المفقودات لطلاب جامعة الملك فهد للبترول والمعادن (KFUPM) — مبني بـ **Flutter**.
يُمكّن الطالب من الإبلاغ عن غرض مفقود (صورة + صنف + موقع)، وتصفّح المفقودات، والتواصل مع الناشر مباشرة (اتصال / واتساب).

> 📄 وثائق المشروع: [`BRD.md`](BRD.md) · تصميم المرحلة 2: `GroupXX_Phase2_Design.docx`

---

## 🎯 الغرض (Project Purpose)
الطلاب يفقدون أغراضهم في مباني الجامعة ومرافقها، والقنوات الحالية (مجموعة تليجرام) غير فعّالة. «موجود» يجمع بلاغات المفقودات في مكان واحد منظّم وقابل للتصفية، ويربط من فقد غرضاً بمن قد يجده.

## ▶️ التشغيل والاختبار (Setup / Run)
```bash
flutter pub get
flutter run        # أو: flutter run -d chrome
flutter test       # تشغيل اختبارات الوحدة
```
**حساب تجريبي جاهز لاختبار الدكتور** (مزروع تلقائياً عند أول تشغيل):
- الإيميل: `s202249820@kfupm.edu.sa`
- كلمة المرور: `123456`

يمكن أيضاً إنشاء حساب جديد بأي إيميل ينتهي بـ `@kfupm.edu.sa`.

## ✅ مميزات Phase 3 المنفّذة (Implemented Features)
- [x] **المصادقة:** تسجيل دخول + إنشاء حساب (مقيّد بإيميل الجامعة) مع **حفظ الجلسة** (تبقى بعد إغلاق التطبيق).
- [x] **إنشاء بلاغ (تدفّق كامل end-to-end):** إدخال + تحقّق → حفظ في المستودع → ظهور فوري في القائمة.
- [x] **قائمة المفقودات:** قراءة من المستودع، تصفية حسب الصنف، الأحدث أولاً.
- [x] **بلاغاتي:** توسيع الكارت للتفاصيل، زر «وجدته» يحوّل الحالة إلى «تم العثور عليه»، وحذف.
- [x] **تفاصيل البلاغ:** صورة + اتصال (`tel:`) + واتساب (`wa.me`).
- [x] **خيار «لست متأكداً من المكان»** للموقع التقريبي/غير المحدّد.
- [x] **حالات الواجهة:** تحميل / فراغ / خطأ (إعادة محاولة) / نجاح / أخطاء تحقّق.
- [x] **الإشعارات** (شاشة عرض؛ منطق المطابقة مؤجّل لـ Phase 4).

## 🗂️ هيكل المشروع (Organization)
```
lib/
 ├─ core/            constants.dart · theme.dart · ui_helpers.dart
 ├─ models/          app_user.dart · report.dart
 ├─ data/            mock_data.dart        # بيانات بذرة أولية
 ├─ repositories/    report_repository.dart · auth_repository.dart   # طبقة البيانات
 ├─ state/           app_state.dart        # Provider / ChangeNotifier
 ├─ screens/         login · signup · root_nav · home_feed · create_report
 │                   report_details · my_reports · notifications · profile
 ├─ widgets/         report_card.dart · state_views.dart · kfupm_logo.dart
 └─ main.dart        # AuthGate + تهيئة المستودعات
test/                repository_test.dart · widget_test.dart
```

## 🧱 إدارة الحالة ومصدر البيانات (State & Data)
- **الحالة:** **Provider (ChangeNotifier)** عبر `AppState` للحالة المشتركة (المستخدم + البلاغات + الفلتر)، و`setState` للحالة المحلية (التحميل، إظهار كلمة المرور، توسيع الكارت).
- **مصدر البيانات:** **طبقة Repository** (`ReportRepository` / `AuthRepository` كواجهات abstract) مع تطبيق محلي يحفظ البيانات على الجهاز عبر **`shared_preferences`** (persistence حقيقي، تبقى البيانات بعد إغلاق التطبيق).
- **خطة Phase 4:** استبدال التطبيق المحلي بـ Firebase (Firestore + Auth + Storage) — يكفي إضافة `FirestoreReportRepository` و`FirebaseAuthRepository` دون تغيير بقية التطبيق، لأن كل شيء يعتمد على الواجهات.

## 📦 المكتبات (Packages)
| المكتبة | الغرض |
|---|---|
| provider | إدارة الحالة المشتركة |
| shared_preferences | التخزين المحلي الدائم (طبقة البيانات) |
| url_launcher | فتح الاتصال (`tel:`) وواتساب (`wa.me`) |
| image_picker | التقاط/اختيار صورة البلاغ |
| google_fonts | الخط العربي (Cairo) |
| intl · uuid | تنسيق التواريخ · معرّفات فريدة |
| firebase_core · firebase_auth · cloud_firestore · firebase_storage | مُضافة للاستخدام في Phase 4 |

> صور العيّنة في البطاقات روابط تجريبية من `picsum.photos` (لغرض العرض فقط).

## ⚠️ مشاكل معروفة / أعمال Phase 4 (Known Issues)
- التخزين محلي على الجهاز (غير مشترك بين الأجهزة بعد) — سيُربط بـ Firestore في Phase 4 ليصبح لحظياً.
- الإشعارات شاشة عرض فقط؛ منطق مطابقة الصنف وإرسال التنبيه يُنفّذ في Phase 4.
- تعديل بيانات الملف الشخصي وإرفاق صورة فعلية للبلاغ: واجهات جاهزة، التنفيذ الكامل في Phase 4.

## 🤖 AI-Use Disclosure (SWE 463 policy)
AI tools were used **only** for learning, debugging, and small suggestions (project scaffolding and drafting documentation), as permitted by the course policy. No complete application or unexplained AI-generated code was submitted; every team member understands and can explain the submitted code.

## 👥 Team
| Name | ID | Role |
|---|---|---|
| Omar Alyamani | 202249820 | Team Lead — repositories, state, data model |
| Abdullah Alshahrani | — | Create Report & Report Details (url_launcher) |
| Omar Aljughaiman | — | Home feed, filtering & Material 3 RTL theme |
| Rakan Alseed | — | Auth/Signup, Profile, My Reports, Notifications, docs |
