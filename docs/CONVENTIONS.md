# App Conventions (New UI)

These conventions were imported from the **minimart** app and apply to **all new
screens**. Legacy screens are intentionally left untouched — do not mass-migrate
them; just follow these rules whenever you build or touch something new.

---

## 1. Localization (l10n)

The app uses Flutter's built-in `gen-l10n`. Three locales are supported:
**English (`en`)**, **Malay (`ms`)**, **Chinese (`zh`)**.

### Layout
| Path | Purpose |
|------|---------|
| `l10n.yaml` | gen-l10n config (arb dir, output class/dir). |
| `lib/l10n/app_en.arb` | English source strings (the template). |
| `lib/l10n/app_ms.arb` | Malay translations. |
| `lib/l10n/app_zh.arb` | Chinese translations. |
| `lib/generated/l10n/` | **Generated** — do not edit by hand. |

`main.dart` registers `AppLocalizations.delegate` + the `GlobalMaterial/Widgets/
Cupertino` delegates and `AppLocalizations.supportedLocales` on `GetMaterialApp`.

### Adding a string
1. Add the key + value to **`lib/l10n/app_en.arb`** (template).
2. Add the same key to `app_ms.arb` and `app_zh.arb` with translations.
3. Regenerate:
   ```bash
   flutter gen-l10n
   ```
   (also runs automatically on `flutter run`/`build` because `generate: true`).

### Using a string in a widget
```dart
final l10n = AppLocalizations.of(context);
Text(l10n.getStarted);
```

> ❌ Do not hardcode user-facing strings on new screens.
> The legacy `EnglishLanguage` / `MalayLanguage` / `ChineseLanguage` constant
> classes in `lib/app_constant/` are the OLD system — migrate strings into the
> `.arb` files as you touch each screen.

---

## 2. Images

Rule imported from minimart: **every NEW image is referenced through a constant
in `lib/core/theme/app_images.dart`**, never as a raw string at the call site.

```dart
// app_images.dart
static const String sparkle = '$_base/ic_sparkle.png';

// usage
Image.asset(AppImages.sparkle);
```

- Old images referenced as raw strings across the codebase are left as-is.
- When you add a new image: drop it in `assets/images/`, add a constant to
  `AppImages`, and reference the constant.

---

## 3. Fonts & Typography

- **Inter** is imported from minimart and is the default family for new screens
  (`AppFonts.family`). It is declared in `pubspec.yaml` at weights 400/500/600/700.
- Legacy screens keep Montserrat/Satoshi — do not switch them.
- Sizing uses **`flutter_screenutil`** against the Figma frame `390 x 844`
  (initialized in `main.dart`). Use `.sp` for font sizes, `.w/.h/.r` for
  dimensions/radii on new screens.

Typography scale lives in `lib/core/theme/app_text_styles.dart` (`AppTextStyles`).

---

## 4. Reusable widgets (`lib/common_widgets.dart`)

Prefer these over hand-rolled widgets on new screens:

| Widget | Use |
|--------|-----|
| `TextRegular(text, ...)` | Inter, weight 400. Replaces raw `Text`. |
| `TextMedium(text, ...)` | Inter, weight 500 (override via `fontWeight`). |
| `AppButton(title:, onPressed:, ...)` | Primary gradient CTA. Supports `leadingImage`, `isLoading`, `isDisabled`, custom `gradientColors`. |
| `BlurContainerWrapper(child:, ...)` | Frosted-glass card (see below). |

### `BlurContainerWrapper`
A bottom-anchored frosted-glass card that **actually blurs** the background
behind it (via `BackdropFilter`), matching the Figma walkthrough.

- Has a `minHeight` but **grows to fit its child**.
- `showClip: true/false` toggles the paperclip pinned above the top edge.
- Tunable: `blurSigma`, `padding`, `borderRadius`, and clip position/size.

```dart
Align(
  alignment: Alignment.bottomCenter,
  child: BlurContainerWrapper(
    showClip: true,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [ /* content */ ],
    ),
  ),
)
```

Reference implementation: the walkthrough screen in
`lib/ui/splash/WalkthroughImageApp.dart`.
