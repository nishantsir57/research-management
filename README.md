# Kohinchha – Research Management Suite

Kohinchha is a multi-role research management platform built with Flutter and Firebase.  
It enables students, reviewers, and admins to collaborate on research submissions, reviews, and community discussions across web and mobile.

## Key Features

- **Role-based access** – dedicated experiences for students, reviewers, and admins.
- **Submission workflow** – students can submit papers (PDF/DOC/text), set visibility, track statuses, and resubmit after revisions.
- **Reviewer tools** – assignment dashboards, AI pre-review summaries, highlight annotations, and structured decision capture.
- **Admin controls** – department & subject management, reviewer approvals, reassignment, and AI toggle.
- **Social layer** – public discussions, comments on published papers, and connection requests between researchers.
- **Gemini integration** – optional AI pre-review using Google Gemini (configurable by admin).

## Project Structure (selected)

```
lib/
  app/                    // Router, theming, entry widgets
  core/                   // Shared constants, services, utilities
  data/                   // Freezed data models
  features/
    auth/                 // Authentication flows and providers
    dashboard/            // Role-specific dashboards
    submissions/          // Paper repositories, controllers, detail views
    discussions/          // Public discussions
    networking/           // Connections between users
    review/               // Reviewer workspace
    admin/                // Admin management tools
```

## Prerequisites

- Flutter 3.22+ with Dart 3.8+
- Firebase project configured via `firebase_options.dart`
- Optional: Google Gemini API key (`--dart-define=GEMINI_API_KEY=your_key`)

## Setup & Run

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
# Web
flutter run -d chrome --dart-define=GEMINI_API_KEY=your_key
# Mobile (example)
flutter run --dart-define=GEMINI_API_KEY=your_key
```

_Note:_ The Gemini key is only required if AI pre-review is enabled by the admin.

## Firebase Collections Used

- `users` – profile, role, connections, reviewer approvals.
- `departments` – departments with embedded subject arrays.
- `papers` – research submissions, status, AI review, review history.
- `papers/{id}/comments` – threaded paper comments.
- `discussionThreads` & subcollection `comments`.
- `connectionRequests` – pending/accepted network links.
- `settings/app` – global feature toggles (AI pre-review, registration flags, etc.).

## Testing & Verification

- Automated code generation: `flutter pub run build_runner build`.
- Custom logic currently validated through manual flows:
  - New student signup, submission, and visibility updates.
  - Reviewer login, review submission with highlights.
  - Admin department creation and reviewer approval.
  - Public discussions and connection requests.

Add your own integration/widget tests to suit institutional QA requirements.

## Extending

- Integrate institution-specific authentication (e.g., SSO) by extending `AuthRepository`.
- Add analytics or notifications via Firebase Cloud Messaging (providers scaffolded in core services).
- Enhance highlight tooling by replacing excerpt-based approach with a custom text editor widget.

---

For general Flutter help see the [Flutter docs](https://docs.flutter.dev/).
