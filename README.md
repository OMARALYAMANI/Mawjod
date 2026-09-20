# موجود (Mawjod) 📍

تطبيق المفقودات لطلاب جامعة الملك فهد للبترول والمعادن (KFUPM).
مبني بـ **Flutter + Firebase**. يمكّن الطلاب من الإبلاغ عن الأغراض المفقودة/الموجودة ومشاهدة البلاغات لحظياً.

> 📄 للتفاصيل الكاملة عن المشروع راجع ملف [`BRD.md`](BRD.md).

---

## 🗂️ هيكل المشروع

```
lib/
 ├─ core/          # الثوابت (constants) والثيم (theme)
 ├─ models/        # نماذج البيانات (Report, AppUser)
 ├─ services/      # خدمات Firebase (Auth, Firestore, Storage) — قادمة
 ├─ screens/       # الشاشات — قادمة
 ├─ widgets/       # عناصر واجهة قابلة لإعادة الاستخدام — قادمة
 └─ main.dart      # نقطة الانطلاق
assets/images/     # الصور
BRD.md             # وثيقة متطلبات العمل
```

## 📦 المكتبات المثبّتة

| المكتبة | الغرض |
|---|---|
| firebase_core | تهيئة Firebase |
| firebase_auth | تسجيل الدخول بإيميل الجامعة |
| cloud_firestore | قاعدة البيانات اللحظية للبلاغات |
| firebase_storage | تخزين صور البلاغات |
| image_picker | التقاط/اختيار الصور |
| provider | إدارة الحالة |
| google_fonts | الخط العربي (Cairo) |
| cached_network_image | عرض الصور بكفاءة |
| intl | تنسيق التواريخ |
| uuid | معرّفات فريدة |

## ▶️ التشغيل

```bash
flutter pub get
flutter run
```

---

## 🔥 خطوة مطلوبة: ربط Firebase

المشروع جاهز برمجياً، لكن يحتاج ربطه بمشروع Firebase **بحسابك** قبل تفعيل تسجيل الدخول والبلاغات. الخطوات (نسوّيها سوا):

1. تثبيت الأدوات:
   ```bash
   dart pub global activate flutterfire_cli
   npm install -g firebase-tools
   firebase login
   ```
2. إنشاء مشروع على [console.firebase.google.com](https://console.firebase.google.com) باسم `mawjod`.
3. الربط التلقائي (ينشئ `lib/firebase_options.dart`):
   ```bash
   flutterfire configure
   ```
4. من لوحة Firebase: تفعيل **Authentication → Email/Password**، و**Firestore Database**، و**Storage**.

> بعد هذه الخطوة نبدأ ربط الكود بالمصادقة والبلاغات (المرحلة 2 في خارطة الطريق).

---

## 🤖 AI-Use Disclosure (SWE 463 policy)

In accordance with the course policy, AI tools were used **only** for learning, debugging, and small suggestions — such as help scaffolding the initial Flutter project and drafting documentation. No complete application or unexplained AI-generated code was submitted, and all team members understand and can explain the code.

## 👥 Team

| Name | Role |
|---|---|
| Omar Alyamani | Team Lead & Backend (Firebase) |
| Abdullah Alshahrani | Create-Report feature & UI |
| Omar Aljughaiman | Feed, filtering & theming |
| Rakan Alseed | Auth, Profile & documentation |
