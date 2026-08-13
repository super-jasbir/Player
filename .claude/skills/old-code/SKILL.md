---
name: old-code
description: Quick reference for the "player" Flutter app (Spendrathon) — its architecture, the game/merchant flow, navigation, controllers, data models, and the reset/completion mechanics. Read this before touching game, merchant, or reset/completion code.
---

# player app (Spendrathon) — quick reference

Flutter + **GetX** app. A player joins a "game" in a zone, visits merchant outlets
("stations"/"shops"), shows a QR to each merchant, and completes shops to earn points.

## Tech / conventions
- State + navigation: **GetX** (`Get.put`, `Get.find`, `Get.to`, `Get.toNamed`, `Get.offAll`, `Obx`, `.obs`).
- Responsive sizing: `flutter_screenutil` (`.w`, `.h`, `.sp`, `.r`).
- Two UI generations coexist. The **new** UI (frosted/blur, `HomeBlurredBackground`,
  `BlurContainerWrapper`, accent blue `#0288D1`) replaced an **old** UI that used
  `assets/images/m2|m3/*` backgrounds and `AppComponents.text`. Old UI is often left
  commented at the bottom of a file (e.g. `GameMerchantList.dart`) — labeled "OLD UI".
- Home page = `HomeScreenPlayer()` (`lib/3dView/home_screen_player.dart`), reached with
  `Get.offAll(HomeScreenPlayer())`. (A `/homeScreen` route → `HomeScreen()` also exists but
  the game flow uses `HomeScreenPlayer`.)
- Routes: `lib/routes/app_routes.dart` (names) + `lib/routes/app_pages.dart` (GetPage bindings).
  **Note the naming trap:** `AppRoutes.gameList = "/gameList"` maps to **`GameDetailScreen`**,
  NOT the game *list*. The list of games is `GameListScreen` (pushed elsewhere, not via that route).

## The game flow (screen order)
1. **`GameListScreen`** (`lib/game/game_list_screen.dart`) — vertical list of games (`GameData`).
   Each card shows status. Tap a `COMPLETED` game → reset dialog (`_showResetDialog`,
   calls `getResetGameFromList`). Tap a non-completed game → `Get.toNamed(AppRoutes.gameList)`.
2. **`GameDetailScreen`** (`lib/game/game_detail_screen.dart`, route `/gameList`) — yellow
   frosted card with game info + Terms checkbox + **HALAL / NON-HALAL** buttons. Selecting a
   type → `getGameDetail(...)` → `SelectHalalNonHalal`.
3. **`SelectHalalNonHalal`** (`lib/game/selecthalalnonhalal/select_halal_non_halal.dart`) —
   start game → `Get.to(GameMerchantList())`.
4. **`GameMerchantList`** (`lib/game/merchant/GameMerchantList.dart`) — list of outlets
   (`OutletDetail`). Per card: **SHOW QR** button (pending) or **COMPLETE** badge (done).
   QR flow: show QR → poll `getPlayerPaymentDetail` → congrats → selfie capture → amount →
   SUBMIT (`_submitCompletion` → `merchantC.gameComplete`) → points → share → close.

## Controllers
- **`GameController`** (`lib/game/game_controller.dart`): `gameList`, `outletList`, `gameInfo`,
  `gameData` (currently selected `GameData`), `playername`, `resetFromList`.
  - `getGameList(zone, cb)`, `getGameDetail(gameId, type, cb)`, `getProfileInfo()`.
  - **Reset APIs (two of them):**
    - `getResetGame(gameID)` → endpoint `api/reset-game` — resets an **in-progress** game.
      On success (when `resetFromList == false`) it calls `Get.back()`.
    - `getResetGameFromList(gameID)` → endpoint `api/resetCompletedGame` — resets a
      **completed** game from the list. Uses `resetFromList = true`, then reloads `gameList`.
- **`MerchantController`** (`lib/merchant/merchant_controller.dart`): QR/payment + selfie upload.
  - `gameComplete(gameUniqueId, startGame, endGame, gameName, lastIndex, outletId, outletName, cb)`
    posts to `gameCompletion`. Sets `start_timer_count` on the **first** completion
    (`startGame == null`) and `end_timer_count` on the **last** (`lastIndex == true`).

## Data models (`lib/data/modal/game/`)
- **`GameData`** (`game_list_response.dart`): `gameUniqueId`, `gameName`, `status`
  (`"COMPLETED"`, `"GAME NOT STARTED YET"`, or in-progress), `start_timer_count`,
  `end_timer_count`, `CompletedTime`, `totalOutlet`, `prize`.
  - `start_timer_count != null` ⟺ **at least one shop has been completed** (set on first
    `gameComplete`). Main branch used this to gate the in-game reset button.
- **`OutletDetail`** (`game_detail_response.dart`): a shop/station. `isGameStarted == 1` ⟺
  **this shop is completed**. `GameInfo` carries the game timers.

## "Is this the last shop?" logic (used for the timer end + home redirect)
In `GameMerchantList._submitCompletion`:
```dart
final completedCount = controller.outletList.where((o) => o.isGameStarted == 1).length;
final lastItem = completedCount == (controller.outletList.length - 1); // this submit finishes them all
```

## Reset dialog UI (dark card + warning badge)
The reusable "reset" dialog (dark `#2C2C2C` card, warning `CircleAvatar` at top) lives in
`GameListScreen._showResetDialog` and (ported) `GameDetailScreen`. List variant text:
"…Restart the game? Your previously completed game data will be remain in system."
In-game variant text: "…reset your game? This action will remove all completed stations detail."

## Sounds
`SoundService` (`lib/core/services/sound_service.dart`): `startTimerLoop`/`stopTimer` while the
game timer runs, `playGameComplete()` on completion. `NoTapSound` widget suppresses the global
tap sound for a child (used on back buttons).

## Branches
`main` = older/original UI & flow (good reference for original reset behavior). `m2` = current
working branch with the new frosted UI.
