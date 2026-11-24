# FitCheck – mobile app (Flutter)

## Setup

```bash
flutter pub get
dart run build_runner build
```

Generated files (`*.g.dart`, `*.freezed.dart`) are not committed. Re-run
`dart run build_runner build` after pulling changes to providers or models,
or keep `dart run build_runner watch` running while developing.

## Configuration

Optional: copy `env/app.env.example` to `env/app.env` (git-ignored) to override
the API base URL. Without it the app uses `http://10.0.2.2:5232/api`
(the local backend as seen from the Android emulator).
