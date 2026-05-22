# 🛠️ Shams Al Kananah (شمس الكنانة)
### *A Premium Hardware, Tools, Electrical, and Plumbing E-Commerce Application*

---

[![Flutter](https://img.shields.io/badge/Flutter-3.5.0%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase&logoColor=white)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/State_Management-Riverpod-388E3C?logo=dart&logoColor=white)](https://riverpod.dev)
[![Material 3](https://img.shields.io/badge/Design_System-Material_3-6750A4)](https://m3.material.io/)

**Shams Al Kananah (شمس الكنانة)** is a modern, feature-rich, high-performance mobile e-commerce platform custom-built using Flutter. Tailored specifically for the industrial and hardware retail sectors, the application provides a smooth, native experience for purchasing **Electrical, Plumbing, Hardware, and Tools**. It features a comprehensive backend powered by Firebase, robust reactive state management via Riverpod, and a bilingual interface that seamlessly caters to both Arabic and English-speaking users.

---

## 🌟 Key Features

### 🛒 High-Fidelity Storefront & Catalog
* **Dynamic Categorization:** Easy exploration across **Electrical, Plumbing, Hardware, and Tools**.
* **Visual Cards:** High-quality product cards complete with high-resolution imagery, pricing, and live rating scores (with review counters).
* **Smart Search:** Search by name or category with reactive caching via a custom `SearchHistoryProvider`.

### 🔄 State-of-the-Art State Management & Local Storage
* **Reactive Riverpod Architecture:** Decoupled, predictable state handling that ensures instant UI updates when modifying the cart, user profile, or wishlist.
* **Persistent Preferences:** The app saves user configuration (such as selected language and theme mode) locally, preserving user choices across app restarts using `shared_preferences`.

### 🌍 Professional Bilingual Engine (AR / EN)
* **Instant Language Toggle:** Swap between English and Arabic at the click of a button.
* **Smart Translations:** Powered by a customized native localization wrapper (`localeProvider` & `translationProvider`), dynamically switching layouts, fonts, and text directionality (LTR/RTL).

### 🎨 Premium Visual Theme (Light & Dark)
* **Material 3 Design:** Built entirely around the premium Material 3 spec.
* **Signature Design System:** Features a bespoke brand palette featuring **Classic Corporate Navy** as the primary focus, combined with a **Vibrant CTA Orange** (Daraz-style) accent.
* **Flexible Light/Dark Modes:** Dynamic system-wide color adjusting to reduce eye strain.

### 📊 Real-Time Admin Dashboard
* **Dynamic KPIs:** Live statistical widgets showcasing **Gross Revenue**, **Total Orders**, **Total Products**, and **Active Users**.
* **Order Stream:** Interactive list displaying real-time customer orders, showing purchase details, prices in SAR, and color-coded status badges (Pending, Shipped, Delivered, Cancelled).

### 🔒 Enterprise-Grade Firebase Integration
* **Authentication:** Secure user onboarding via `firebase_auth` with multi-step registration.
* **Real-time Database:** Reactive CRUD operations powered by `cloud_firestore`.
* **Cloud Asset Management:** Distributed media hosting through `firebase_storage` for high-quality product images.

---

## 🎨 Design & Palette System

The application's design system is designed to convey trust, utility, and modern professionalism:

| Color Token | Hex Code | Purpose & Application |
| :--- | :--- | :--- |
| **Primary Navy** | `#1E2C47` | Core branding, App bars, primary action buttons, headers |
| **CTA Orange** | `#F37B24` | Call-To-Actions, Add-to-cart buttons, highlighting, ratings |
| **Accent Gold** | `#FBE9B6` | Highlights, promotional blocks, selective visual interest |
| **Background Slate** | `#F8F9FA` | Main interface backdrop (light mode) for a clean look |
| **Text Dark** | `#1A2231` | High-contrast readability for headers and body copy |
| **Success Green** | `#2DB75B` | Successful checkouts, order delivered badge, active states |
| **Price Red** | `#E53B19` | Highly visible product listing price points |

---

## 📁 Clean Architecture Blueprint

The project is structured under a highly modular clean-code architectural model inside the `lib/` directory to maximize decoupling and ease scale:

```bash
lib/
├── data/              # Static & offline mock seed data (e.g. dummy_data.dart)
├── models/            # Strongly-typed data models representing domain entities
│   ├── cart_item.dart
│   ├── order.dart
│   ├── product.dart
│   └── user.dart
├── providers/         # Riverpod state managers handling reactive application state
│   ├── auth_provider.dart
│   ├── cart_provider.dart
│   ├── locale_provider.dart
│   ├── orders_provider.dart
│   ├── products_provider.dart
│   ├── theme_provider.dart
│   └── wishlist_provider.dart
├── screens/           # Modular view screens (pages)
│   ├── auth/          # Authentication flows (Login, Registration, Selection)
│   ├── home_screen.dart
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   ├── admin_dashboard.dart
│   └── profile_screen.dart
├── services/          # Decoupled logic singletons for external API interactions (Firebase)
│   ├── auth_service.dart
│   └── order_service.dart
├── utils/             # Reusable design tokens, app configurations, and colors
└── widgets/           # Highly reusable global presentation components (cards, app drawers)
```

---

## 🚀 Getting Started

### Prerequisites

To successfully set up, run, and compile the **Shams Al Kananah** application, verify you have the following installed on your machine:

1. **Flutter SDK** (Version `^3.5.0`)
2. **Dart SDK** (Version corresponding to Flutter release)
3. **Java Development Kit (JDK)** / **Android Studio** for Android builds
4. **Xcode** (macOS only) for compilation to iOS platforms

### 📥 1. Installation

Clone the repository and navigate to the project root:

```bash
# Clone the repository
git clone https://github.com/your-username/shams-al-kananah.git

# Navigate into the project folder
cd "E-Commerce App(Shamas Al Kananah)"
```

### 📦 2. Fetch Dependencies

Download the required Flutter packages and platform plugins:

```bash
flutter pub get
```

### 🔥 3. Configure Firebase

Ensure that you have set up your Firebase application:

#### For Android
* Place your generated `google-services.json` inside the `android/app/` directory.

#### For iOS
* Add your generated `GoogleService-Info.plist` to your Xcode project root under the `Runner` folder.

#### For Web & Desktop
* Firebase configurations are handled inside `lib/firebase_options.dart`. Update this file with your project's unique API keys if needed.

### 🏃 4. Running the App

Run the application locally on your preferred connected simulator, emulator, or real device:

```bash
# Verify connected devices
flutter devices

# Run in Debug mode
flutter run
```

To run specifically on one target platform (e.g. Chrome, Android, iOS):

```bash
# For Android emulator/device
flutter run -d android

# For iOS simulator/device
flutter run -d ios

# For Web
flutter run -d chrome
```

---

## 🔧 Building for Production

Compile highly optimized distribution packages for your target platforms:

#### Android (App Bundle)
```bash
flutter build appbundle --release
```

#### iOS (Xcode IPA)
```bash
flutter build ipa --release
```

#### Web (Static Assets)
```bash
flutter build web --release
```

---

## 🤝 Contributing

Contributions to improve Shams Al Kananah are always welcome! 

1. **Fork** the Repository.
2. **Create** your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. **Commit** your Changes (`git commit -m 'Add some AmazingFeature'`).
4. **Push** to the Branch (`git push origin feature/AmazingFeature`).
5. **Open** a Pull Request.

---

## 📜 License

This project is proprietary and confidential. All rights reserved. Built for **Shams Al Kananah** (شمس الكنانة).
