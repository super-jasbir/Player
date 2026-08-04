import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../common_widgets.dart';
import '../core/theme/app_fonts.dart';
import 'cart_controller.dart';
import 'models/shop_product.dart';
import 'widgets/shop_chrome.dart';
import 'widgets/shop_widgets.dart';

/// ADDRESS form: name, phone, street, apartment, city / ZIP and country.
/// Saving appends the address to [CartController] and returns to the list.
class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final CartController cart = CartController.to;

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _street = TextEditingController();
  final _apartment = TextEditingController();
  final _city = TextEditingController();
  final _zip = TextEditingController();

  String _dialCode = "+65";
  String _country = "Singapore";

  @override
  void dispose() {
    for (final c in [_name, _phone, _street, _apartment, _city, _zip]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    cart.addAddress(
      ShopAddress(
        name: _name.text.trim(),
        phone: "$_dialCode ${_phone.text.trim()}".trim(),
        street: _street.text.trim(),
        apartment: _apartment.text.trim(),
        city: _city.text.trim(),
        zip: _zip.text.trim(),
        country: _country,
      ),
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ShopLightBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  const ShopPanelHeader(title: "ADDRESS"),
                  SizedBox(height: 24.h),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        ShopField(
                          label: "Name",
                          child: ShopTextField(
                            hint: "Enter your name",
                            controller: _name,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ShopField(
                          label: "Phone",
                          child: Row(
                            children: [
                              _DialCodePicker(
                                value: _dialCode,
                                onChanged: (v) => setState(() => _dialCode = v),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: ShopTextField(
                                  hint: "Enter your phone number",
                                  controller: _phone,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ShopField(
                          label: "Street address",
                          child: ShopTextField(
                            hint: "123 Main Street",
                            controller: _street,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ShopField(
                          label: "Apartment, suite, unit (optional)",
                          child: ShopTextField(
                            hint: "Apt 5B",
                            controller: _apartment,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              child: ShopField(
                                label: "City",
                                child: ShopTextField(
                                  hint: "SINGAPORE",
                                  controller: _city,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: ShopField(
                                label: "ZIP code",
                                child: ShopTextField(
                                  hint: "94105",
                                  controller: _zip,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        ShopField(
                          label: "Country",
                          child: _CountryPicker(
                            value: _country,
                            onChanged: (v) => setState(() => _country = v),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    title: "SAVE",
                    radius: 16,
                    gradientColors: const [
                      Color(0xFFB3E5FC),
                      Color(0xFF29B6F6),
                      Color(0xFF0288D1),
                    ],
                    textStyle: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    onPressed: _save,
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Flag + dial-code dropdown sitting to the left of the phone field.
class _DialCodePicker extends StatelessWidget {
  const _DialCodePicker({required this.value, required this.onChanged});

  static const Map<String, String> _codes = {
    "+65": "🇸🇬",
    "+60": "🇲🇾",
    "+86": "🇨🇳",
    "+1": "🇺🇸",
  };

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 107.w,
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFDCE6EF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: 16.w, color: kShopBlue),
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 12.sp,
            color: const Color(0xFF1F2937),
          ),
          items: [
            for (final entry in _codes.entries)
              DropdownMenuItem(
                value: entry.key,
                child: Text("${entry.value}  ${entry.key}"),
              ),
          ],
          onChanged: (v) => v == null ? null : onChanged(v),
        ),
      ),
    );
  }
}

/// Country dropdown for the last field on the form.
class _CountryPicker extends StatelessWidget {
  const _CountryPicker({required this.value, required this.onChanged});

  static const Map<String, String> _countries = {
    "Singapore": "🇸🇬",
    "Malaysia": "🇲🇾",
    "China": "🇨🇳",
    "United States": "🇺🇸",
  };

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFDCE6EF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: 16.w, color: kShopBlue),
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 12.sp,
            color: const Color(0xFF1F2937),
          ),
          items: [
            for (final entry in _countries.entries)
              DropdownMenuItem(
                value: entry.key,
                child: Text("${entry.value}  ${entry.key}"),
              ),
          ],
          onChanged: (v) => v == null ? null : onChanged(v),
        ),
      ),
    );
  }
}
