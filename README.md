```markdown
# 🧱 Flutter BLoC Template with GoRouter

A **production-ready Flutter starter template** featuring:
- 🔹 BLoC state management  
- 🔹 GoRouter navigation  
- 🔹 Clean architecture (data/domain/presentation layers)  
- 🔹 Dependency Injection with GetIt  
- 🔹 REST API integration (Dio)  
- 🔹 Secure Storage, Shared Preferences  
- 🔹 Theming with Cubit (light/dark mode)  
- 🔹 Connectivity & Notification services  
- 🔹 Firebase Dynamic Links  
- 🔹 Logger utilities  

> ⚡️ Perfect foundation for building scalable, testable, and maintainable Flutter apps.


## 🚀 Features

✅ **BLoC Pattern** — Scalable state management  
✅ **GoRouter** — Declarative and deep-linkable navigation  
✅ **Dependency Injection** — Clean, modular setup using GetIt  
✅ **Network Layer** — Configurable Dio client with interceptors  
✅ **Theming** — Dynamic light/dark mode with persistent preference  
✅ **Authentication Flow** — Ready-to-use login/logout system  
✅ **Connectivity Handling** — Snackbar alert for offline mode  
✅ **Secure & Shared Storage** — Local persistence made easy  
✅ **Notifications & Dynamic Links** — Firebase-ready service layer  
✅ **Logging** — Centralized app logger with error tracking  
```

```

🧩 Folder Structure

lib/
├── app.dart                      # App root with MultiBlocProviders
├── core/
│    ├── api/                     # API client & interceptors (Dio)
│    ├── di.dart                  # Dependency injection setup (GetIt)
│    ├── router/                  # GoRouter setup & route guards
│    ├── services/                # Connectivity, Notifications, Dynamic Links
│    ├── storage/                 # SecureStorage & SharedPreferences wrappers
│    ├── theme/                   # ThemeCubit + light/dark themes
│    ├── utils/                   # Logger, Validators, App constants
│    └── constants/               # AppStrings, TextStyles, Colors
│
├── features/
│    ├── auth/                    # Auth feature module
│    │    ├── bloc/               # AuthBloc + states + events
│    │    ├── data/               # AuthApi & repository impl
│    │    ├── domain/             # Abstract AuthRepository
│    │    └── presentation/       # UI screens (login, signup, etc.)
│    ├── home/                    # Home feature (Bloc + UI)
│    ├── profile/                 # Profile feature (Bloc + UI)
│    └── ...                      # Add future modules easily
│
└── widgets/  # Shared widgets (buttons, forms, etc.)
```



🧠 Architecture Overview


UI → Bloc → Repository → API / Storage


**Presentation Layer** → Flutter UI + BLoC (state management)  
**Domain Layer** → Abstract Repositories (business rules)  
**Data Layer** → APIs, Storage, and data sources  

Follows **Clean Architecture** + **SOLID principles**.

---

## ⚙️ Dependency Injection (GetIt)

All dependencies are registered in `core/di.dart`.

```dart
getIt.registerLazySingleton<ApiClient>(() => ApiClient(...));
getIt.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(apiClient: getIt<ApiClient>()),
);
getIt.registerFactory<AuthBloc>(
  () => AuthBloc(repository: getIt<AuthRepository>()),
);
````

### Registration Rules:

| Layer                | Registration            | Reason                  |
| -------------------- | ----------------------- | ----------------------- |
| API / Repo / Service | `registerLazySingleton` | Shared across app       |
| Bloc / Cubit         | `registerFactory`       | Fresh per screen / flow |

---

## 🧭 Navigation (GoRouter)

Declarative route management with support for route guards:

```dart
final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_) => const SplashPage()),
    GoRoute(path: '/login', builder: (_) => const LoginPage()),
    GoRoute(path: '/home', builder: (_) => const HomePage()),
    GoRoute(path: '/profile', builder: (_) => const ProfilePage()),
  ],
  redirect: (context, state) => AuthGuard.handleRedirect(context, state),
);
```

✅ Clean URL-based navigation
✅ Auth guard integration
✅ Easy deep link handling

---

## 🎨 Theming

Managed by `ThemeCubit`
Persisted using `SharedPreferences`

```dart
context.read<ThemeCubit>().toggleTheme();
```

📁 `lib/core/theme/`

* `light_theme.dart`
* `dark_theme.dart`
* `theme_cubit.dart`

---

## 🔌 Connectivity

The app continuously checks internet availability using `ConnectivityBloc`.

If disconnected:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('No internet connection'),
    backgroundColor: Colors.red,
  ),
);
```

SnackBar stays visible until reconnected.

---

## 🧰 Core Services

| Service                 | Description                                        |
| ----------------------- | -------------------------------------------------- |
| **ConnectivityService** | Detects network changes                            |
| **NotificationService** | Handles Firebase push notifications                |
| **DynamicLinkService**  | Supports Firebase dynamic links                    |
| **SecureStorage**       | Stores sensitive info like tokens                  |
| **SharedPreferences**   | Local lightweight persistence                      |
| **Logger**              | Centralized log utility for debug & error tracking |

---

## 🧱 Example: Authentication Flow

### AuthBloc event handler

```dart
on<LoginRequested>((event, emit) async {
  if (event.email.isEmpty || event.password.isEmpty) {
    emit(AuthFailure(message: 'Email and password required.'));
    return;
  }

  emit(AuthLoading());
  try {
    final user = await repository.login(
      email: event.email,
      password: event.password,
    );
    emit(AuthAuthenticated(user));
  } on UnauthorizedException {
    emit(AuthFailure(message: 'Invalid credentials.'));
  } catch (e) {
    emit(AuthFailure(message: e.toString()));
  }
});
```

### Repository example

```dart
@override
Future<User> login({required String email, required String password}) async {
  final resp = await authApi.login(email: email, password: password);
  if (resp.statusCode == 401) throw UnauthorizedException();
  // handle token + user parsing
  return User.fromJson(resp.data);
}
```

---

## 🧰 Tech Stack

| Layer                    | Package                                                       |
| ------------------------ | ------------------------------------------------------------- |
| **Framework**            | Flutter (3.35+)                                                |
| **State Management**     | flutter_bloc                                                  |
| **Routing**              | go_router                                                     |
| **Dependency Injection** | get_it                                                        |
| **Networking**           | dio                                                           |
| **Local Storage**        | shared_preferences, flutter_secure_storage                    |
| **Services**             | connectivity_plus, firebase_dynamic_links, firebase_messaging |
| **Logging**              | custom logger utility                                         |

---

## 🧩 Getting Started

### 1️⃣ Clone the repository

```bash
git https://github.com/deekshithx/Bloc_Template.git
cd Bloc_Template
```

### 2️⃣ Install dependencies

```bash
flutter pub get
```

### 3️⃣ Run the app

```bash
flutter run
```

### 4️⃣ (Optional)

Configure Firebase for notifications and dynamic links if you plan to enable those services.

---

## 🧪 Future Enhancements

* [ ] Add System Theme Sync
* [ ] Add Unit & Widget Tests
* [ ] Add Firebase Auth Integration
* [ ] Add Offline Mode with API Mocking
* [ ] Add Localization (i18n)

---

## 💡 Contributing

Pull requests are welcome!
If you'd like to suggest improvements or fix bugs, open an issue first.

---

## 🧑‍💻 Author

**Deekshith Shetty**
💼 GitHub: [@deekshithx](https://github.com/deekshithx)
🌐 LinkedIn: [@deekshithx](https://linkedin.com/in/deekshithx)

---

## 🌟 Acknowledgements

Built using:

* Flutter
* flutter_bloc
* go_router
* get_it
* dio
* firebase_dynamic_links
* connectivity_plus

---

## 🧭 Project Summary

> **Flutter BLoC Template** — a boilerplate project for scalable, modular app development using the BLoC pattern, GoRouter navigation, and GetIt dependency injection.

Start building production-grade apps faster, with clean architecture baked in from day one.

---

### ⭐ Found this useful?

Give the project a **star** on GitHub to help others discover it!


