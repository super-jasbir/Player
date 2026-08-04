/// Central registry for image assets.
///
/// RULE (imported from minimart): every NEW image must be referenced through a
/// constant here instead of a raw string literal at the call site. This keeps
/// asset paths in one place and makes renames/refactors safe.
///
/// Legacy images scattered across the codebase as raw strings are intentionally
/// left as-is; only add NEW images here.
class AppImages {
  const AppImages._();

  static const String _base = 'assets/images';

  // ---- Walkthrough / splash (new UI) ----
  static const String splashBackground = '$_base/splash_background.jpg';
  static const String spendrathonCard = '$_base/ic_spendrathon_card.png';
  static const String paperclip = '$_base/ic_paperclip.png';
  static const String sparkle = '$_base/ic_sparkle.png';
  static const String icCamera = '$_base/ic_camera.png';

  // ---- Onboarding (new-user / nationality) ----
  // Layered: office background + the receptionist standing in front.
  static const String regionBackground = '$_base/region_bg.png';
  static const String regionReceptionist = '$_base/region_receptionist.png';

  // ---- Shop ----
  static const String _shop = '$_base/shop';
  static const String shopBackground = '$_shop/shop_bg.png';
  /// The shopkeeper cutout that sits over [shopBackground] (Figma: 390x684
  /// at y=51). Also used, cropped to a circle, as the default avatar.
  static const String shopKeeper = '$_shop/ic_shop_lady.png';
  static const String shopBasket = '$_shop/ic_basket.svg';
  static const String shopHome = '$_shop/ic_home.svg';
  static const String shopStar = '$_shop/ic_star.svg';
  static const String shopCoin = '$_shop/ic_coin.svg';
  static const String shopSearch = '$_shop/ic_search.svg';

  // ---- Wallet ----
  static const String _wallet = '$_base/wallet';
  /// Blurred cityscape scene behind the wallet screen (Figma: full-bleed).
  static const String walletBackground = '$_wallet/wallet_bg.png';
  static const String walletAvatar = '$_wallet/wallet_avatar.png';
  static const String walletStar = '$_wallet/ic_star.svg';
  static const String walletStarChip = '$_wallet/ic_star_chip.svg';
  static const String walletHome = '$_wallet/ic_home.svg';
  static const String walletLogo = '$_wallet/ic_spend_logo.png';

  // ---- Mystery box ----
  static const String _mysteryBox = '$_base/mysterybox';

  /// One shelving rack: four bays, used as the repeating unit of the shelf
  /// wall so any number of boxes can be displayed.
  static const String mysteryBoxShelf = '$_mysteryBox/ic_shelf.png';

  /// Fallback gift-box art when the API record has no image.
  static const String mysteryBoxGift = '$_mysteryBox/ic_box.png';
}
