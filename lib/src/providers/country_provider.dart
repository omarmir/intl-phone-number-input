import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';

const String PropertyName = 'alpha_2_code';

Future<List<DropdownMenuItem<Country>>> getDropdownButtons(List<Country> countryList) async {
  List<DropdownMenuItem<Country>> dropdownList = new List<DropdownMenuItem<Country>>();

  countryList.forEach((country) {
    dropdownList.add(
      new DropdownMenuItem(
        value: country,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              country?.flagUri != null
              ? Image.asset(
                  country?.flagUri,
                  width: 32.0,
                  package: 'intl_phone_number_input'
                )
              : SizedBox(width: 100,),
              SizedBox(width: 12.0),
              Text(
                country.dialCode,
              )
            ],
          ),
        ),
      )
    );
  });

  return dropdownList;
}

Future<List<DropdownMenuItem<Country>>> getInitialOnlyDropdownButton(Country country) async {
  List<DropdownMenuItem<Country>> dropdownList = new List<DropdownMenuItem<Country>>();

  dropdownList.add(
    new DropdownMenuItem(
      value: country,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            country?.flagUri != null
            ? Image.asset(
                country?.flagUri,
                width: 32.0,
                package: 'intl_phone_number_input'
              )
            : SizedBox(width: 100,),
            SizedBox(width: 12.0),
            Text(
              country.dialCode,
            )
          ],
        ),
      ),
    )
  );

  Country loadMore = Country(countryCode: 'More...', dialCode: '_more_', flagUri: null, name: 'More...');
  dropdownList.add(
    new DropdownMenuItem(
      value: loadMore,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              loadMore.name,
            )
          ],
        ),
      ),
    )
  );

  return dropdownList;
}

List<Country> decodeCountryJson(String jsonString) {
    List jsonList = jsonDecode(jsonString);
    List<Country> countryList = jsonList.map((country) => Country.fromJson(country)).toList();

    return countryList;
}

class CountryProvider {

  static Future<List<Country>> getCountriesDataFromJsonFile({@required BuildContext context, @required List<Country> countries}) async {
    if (countries != null && countries.isNotEmpty) {
      return countries;
    }
    Stopwatch sw = new Stopwatch();
    sw.start();
    String jsonString = await rootBundle.loadString('packages/intl_phone_number_input/src/models/countries.json');
    sw.stop();
    print(sw.elapsedMilliseconds);
    return compute(decodeCountryJson,jsonString);
  }

  static Future<List<DropdownMenuItem<Country>>> getDropdownItemsFromList(List<Country> countryList) async {
    return compute(getDropdownButtons, countryList);
  }

  static Future<List<DropdownMenuItem<Country>>> getDropdownItemsFromCountry(Country country) async {
    return compute(getInitialOnlyDropdownButton, country);
  }

}