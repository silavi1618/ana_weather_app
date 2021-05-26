import 'package:flutter/material.dart';

import '../constants.dart';

class WeatherCard extends StatelessWidget {
  final String cityName;
  final String main;
  final bool isCurrentLocation;
  final bool isRemovable;
  final VoidCallback onRemove;

  const WeatherCard(
      {Key? key,
      required this.cityName,
      required this.main,
      required this.onRemove,
      this.isCurrentLocation = false,
      this.isRemovable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: cardColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Visibility(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "Current Location",
                    style: TextStyle(color: Colors.black26, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            visible: isCurrentLocation,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  cityName,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  main,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          Visibility(child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              onSurface: Colors.white,
                              backgroundColor: Colors.red,
                            ),
                            onPressed: onRemove,
                            child: Text('Remove'),
                          ),
                        ),
                        visible: isRemovable,)
                      
                    
        ],
      ),
    );
  }
}
