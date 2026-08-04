import '../../data/modal/RedeemableItemResponse.dart';

/// A shop item, built from the redeemable-item API
/// (`get-redeemableItem-list` / `get-redeemableItem-detail`).
///
/// The list endpoint carries only the summary fields; [ShopProduct.fromDetails]
/// fills in the gallery and description once the detail call returns.
class ShopProduct {
  const ShopProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.coinPrice,
    required this.cashPrice,
    this.images = const [],
    this.description = "",
    this.stock = "",
    this.sizes = const [],
    this.colours = const [],
    this.currency = "SGD",
  });

  /// Summary record from the list endpoint.
  factory ShopProduct.fromListItem(RedeemableItemList item) {
    final num price = num.tryParse(item.amountPaid ?? "") ?? 0;
    return ShopProduct(
      id: "${item.id ?? ''}",
      name: item.itemNameEn ?? "",
      image: item.redeemableItemImage ?? "",
      coinPrice: price.round(),
      cashPrice: price,
      stock: item.stock ?? "",
    );
  }

  /// Full record from the detail endpoint.
  factory ShopProduct.fromDetails(RedeemableDetails item) {
    final num price = num.tryParse(item.amountPaid ?? "") ?? 0;
    return ShopProduct(
      id: "${item.id ?? ''}",
      name: item.itemNameEn ?? "",
      image: item.redeemableItemImage ?? "",
      images: item.itemImages ?? const [],
      description: item.description ?? "",
      coinPrice: price.round(),
      cashPrice: price,
      stock: item.stock ?? "",
      // Swatches are not in the API response yet. The detail screen already
      // renders these sections when the lists are non-empty, so wiring them up
      // later is a change here and nowhere else.
      sizes: const [],
      colours: const [],
    );
  }

  final String id;
  final String name;

  /// Primary artwork URL.
  final String image;

  /// Gallery URLs; falls back to just [image] when the API sends none.
  final List<String> images;

  final String description;
  final String stock;

  /// Price in in-game coins (the star pill).
  final int coinPrice;

  /// Price in real currency (the "SGD 5" pill). The API exposes a single
  /// `amountPaid`, so both pills show the same figure until it splits them.
  final num cashPrice;
  final String currency;

  /// Size / colour options. Empty until the API returns swatches, in which
  /// case the detail screen hides those sections.
  final List<String> sizes;
  final List<String> colours;

  List<String> get gallery =>
      images.isNotEmpty ? images : (image.isEmpty ? const <String>[] : [image]);

  String get cashLabel =>
      "$currency ${cashPrice % 1 == 0 ? cashPrice.toInt() : cashPrice}";

  /// Merges the detail response into the summary the grid already showed, so
  /// the screen never blanks out while the detail call is in flight.
  ShopProduct mergedWith(ShopProduct detail) => ShopProduct(
        id: detail.id.isEmpty ? id : detail.id,
        name: detail.name.isEmpty ? name : detail.name,
        image: detail.image.isEmpty ? image : detail.image,
        images: detail.images.isEmpty ? images : detail.images,
        description:
            detail.description.isEmpty ? description : detail.description,
        stock: detail.stock.isEmpty ? stock : detail.stock,
        coinPrice: detail.coinPrice == 0 ? coinPrice : detail.coinPrice,
        cashPrice: detail.cashPrice == 0 ? cashPrice : detail.cashPrice,
        sizes: detail.sizes.isEmpty ? sizes : detail.sizes,
        colours: detail.colours.isEmpty ? colours : detail.colours,
        currency: detail.currency,
      );
}

/// One line in the cart: a product plus the chosen options and quantity.
class ShopCartItem {
  ShopCartItem({
    required this.product,
    this.size,
    this.colour,
    this.quantity = 1,
  });

  final ShopProduct product;
  final String? size;
  final String? colour;
  int quantity;

  num get cashTotal => product.cashPrice * quantity;
  int get coinTotal => product.coinPrice * quantity;

  /// True when this line refers to the same product/size/colour combination,
  /// so quantities merge instead of adding a duplicate row.
  bool matches(ShopProduct other, String? otherSize, String? otherColour) =>
      product.id == other.id && size == otherSize && colour == otherColour;
}

/// A saved delivery address.
class ShopAddress {
  const ShopAddress({
    required this.name,
    required this.phone,
    required this.street,
    this.apartment = "",
    required this.city,
    required this.zip,
    required this.country,
  });

  final String name;
  final String phone;
  final String street;
  final String apartment;
  final String city;
  final String zip;
  final String country;

  /// Multi-line body shown under the name on the address cards.
  String get formatted => [
        if (apartment.isNotEmpty) "$street, $apartment" else street,
        "$city $zip",
        country,
      ].join(",\n");
}

/// Demo addresses, replaced by the API later.
const List<ShopAddress> kDemoAddresses = [
  ShopAddress(
    name: "Jean Doe",
    phone: "+12 345 6789 9999",
    street: "1, Jurong West Central 2, #02-24",
    apartment: "Jurong Point Shopping Centre",
    city: "Singapore",
    zip: "648886",
    country: "Singapore",
  ),
  ShopAddress(
    name: "Jean Doe",
    phone: "+12 345 6789 9999",
    street: "1, Jurong West Central 2, #02-24",
    apartment: "Jurong Point Shopping Centre",
    city: "Singapore",
    zip: "648886",
    country: "Singapore",
  ),
];
