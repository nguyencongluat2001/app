import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:haiduong_sipas/config/app_colors.dart';
import 'package:haiduong_sipas/services/location_services.dart';
import 'package:haiduong_sipas/models/app_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class LocaltionWidget extends StatefulWidget {
  final String label;
  final String keyInput;
  dynamic data;
  LocaltionWidget({super.key, required this.label, required this.keyInput});

  @override
  State<LocaltionWidget> createState() => _LocaltionWidgetState();
}

class _LocaltionWidgetState extends State<LocaltionWidget> {
  final service = LocationService();
  String? initValue;
  @override
  void initState() {
    //getLocation();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up resources here
    super.dispose();
  }

  getLocation(appModel) async {
    final prefs = await SharedPreferences.getInstance();
    final locationData = await service.getLocation();
    var locality = '';
    var street = '';
    var district = '';
    var number = '';
    var location = '';

    if (locationData != null) {
      final placeMark = await service.getPlaceMark(locationData: locationData);
      String latitude = locationData.latitude!.toStringAsFixed(5);
      String longitude = locationData.longitude!.toStringAsFixed(5);
      await prefs.setString('latitude', latitude);
      await prefs.setString('longitude', longitude);
      if (placeMark != null) {
        locality = placeMark.administrativeArea ?? '';
        street = placeMark.thoroughfare ?? '';
        district = placeMark.subAdministrativeArea ?? '';
        number = placeMark.subThoroughfare ?? '';
      }

      if (number == '' || street == '') {
        location = "$district, $locality";
      } else {
        location = "$number $street, $district, $locality";
      }

      setState(() {
        initValue = location;
        appModel.setVote(initValue, "address_survey");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    TextEditingController controllerText =
        TextEditingController(text: appModel.dataVote["address_survey"]);
    return Container(
        padding: EdgeInsets.only(top: 8),
        child: TextField(
          controller: controllerText,
          onChanged: (newText) {
            appModel.setVote(newText,
                widget.keyInput); // Call your appModel method with newText
          },
          decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () async {
                  await getLocation(appModel);
                }, // Attach click event handler
                child: Icon(Icons.location_on), // Icon to display as suffixIcon
              ),
              labelText: widget.label,
              hintText: widget.label,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              filled: true,
              fillColor: AppColors.white.withOpacity(0.5)),
        ));
  }
}
