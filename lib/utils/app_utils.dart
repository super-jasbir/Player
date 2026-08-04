
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static Future<int?> showDatePickerDialogWithCallback(BuildContext context,
      Function(String, DateTime) callback, {DateTime? lastDate}) async {
    showDatePickerDialog(context, lastDate: lastDate).then((picked) {
      if (picked != null) {

      String formattedDate=  DateFormat("yyyy-MM-dd").format(picked);
        // String formattedDate =
        //     "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString()
        //     .padLeft(2, '0')}-${picked.year}";
        callback(formattedDate, picked);
      }
    });


    return null;
  }

 static Gradient yellowGradiant(){
    return const LinearGradient(
      colors: [
        Color(0xFFFEE20E), // Hex code for FEE20E
        Color(0xFFF6BA06), // Hex code for F6BA06
      ],
      begin: Alignment.topLeft, // Gradient start point
      end: Alignment.bottomRight, // Gradient end point
    );
  }


  static Future<DateTime?> showDatePickerDialog(BuildContext context,
      {DateTime? lastDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: lastDate == null ? DateTime(2050) : DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
    );

    if (picked != null) {
      String formattedDate =
          "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString()
          .padLeft(2, '0')}-${picked.year}";
      return picked;
    }

    return null;
  }

  static int calculateAge(DateTime dob) {
    try {
      // Parse the date in "yyyy-MM-dd" format


      // Get the current date
      DateTime today = DateTime.now();

      // Calculate age in years
      int age = today.year - dob.year;

      // Adjust if the birth date hasn't occurred yet this year


      return age;
    } catch (e) {
      print("Error calculating age: $e");
      return 0; // Return a default age of 0 in case of error
    }
  }

  static Widget seprator(double margin){
    return Container(
      margin: EdgeInsets.only(top: margin,bottom: margin),
      child: Divider(
        height: 1,
        color: Colors.grey.withOpacity(.3),
      ),
    );
  }
  static Widget glassView(){
    return Container(
      // Set the desired width
      height: 191, // Set the desired height
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3), // Semi-transparent color
        borderRadius: BorderRadius.circular(16), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4), // Shadow color
            offset: Offset(0, 4), // Shadow position
            blurRadius: 10, // Blur radius for softness
          ),
        ],
      ),
    );
  }

  static Widget remoteImageLoader(String image,
      {BoxFit boxFit = BoxFit.cover}) {
    return Image.network(
      image,
      fit: boxFit,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          image, // Your placeholder image
          fit:boxFit,
        );
      },
    );
  }

  static Widget ratingView(double initialRating,
      {double size = 20,
        bool ignoreGestures = true,
        Function(double)? ratingUpdate}) {
    return RatingBar.builder(
      wrapAlignment: WrapAlignment.start,
      initialRating: initialRating,
      unratedColor: Colors.grey,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: ignoreGestures,
      itemCount: 5,
      itemSize: size,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.orange,
        size: 25,
      ),
      onRatingUpdate: (rating) {
        ratingUpdate?.call(rating);
        // Callback when the user updates the rating
        print(rating);
      },
    );
  }



 static Widget outlinedText({
    required String text,
    double fontSize = 40,
    Color fillColor = Colors.white,
    Color strokeColor = Colors.black,
    double strokeWidth = 2,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return Stack(
      children: [
        // Stroke (outer)
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Fill (inner)
        Text(
          text,
          style: TextStyle(

            fontSize: fontSize,
            fontWeight: fontWeight,
            color: fillColor,
          ),
        ),
      ],
    );
  }

  static Widget dropDown(
      BuildContext context, Rx<String> selectedValue, List<String> mList) {
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(.5), width: .5),
      ),
      margin: EdgeInsets.only(top: 15),
      child: Row(
        children: [
          SizedBox(width: 12),
          Expanded(
            child: Obx(() => DropdownButton<String>(
              isExpanded: true,
              hint: Text("select"),
              // Use localized hint
              value: mList.contains(selectedValue.value)
                  ? selectedValue.value
                  : null,
              underline: const SizedBox(),
              onChanged: (newValue) {
                if (newValue != null) {
                  selectedValue.value = newValue;
                }
              },
              items: mList.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item), // Use localized text
                );
              }).toList(),
            )),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  static String calculateAge2(String dob) {
    try {
      // Parse the date in "yyyy-MM-dd" format

      // Get the current date
      var year = dob.split("/");
      int age = DateTime.now().year - int.parse(year[2]);

      // Calculate age in years

      // Adjust if the birth date hasn't occurred yet this year

      return age.toString();
    } catch (e) {
      print("Error calculating age: $e");
      return ""; // Return a default age of 0 in case of error
    }
  }

  String convertToAmPm(String time24) {
    final inputFormat = DateFormat("HH:mm:ss");
    final outputFormat = DateFormat("hh:mm a");

    final dateTime = inputFormat.parse(time24);
    return outputFormat.format(dateTime);
  }

}
