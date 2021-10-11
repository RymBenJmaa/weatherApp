class LocationData {
  ///Name of the location
  final String title;

  ///(City|Region / State / Province|Country|Continent)
  final String locationType;

  ///floats, comma separated
  final String latLong;

  ///Where On Earth ID
  final int woeid;

  ///Only returned on a lattlong search (meters)
  final int distance;

  LocationData({
    required this.title,
    required this.locationType,
    required this.latLong,
    required this.woeid,
    required this.distance,
  });
  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      title: json['title'] ?? '',
      locationType: json['location_type'] ?? '',
      latLong: json['latt_long'] ?? '',
      woeid: json['woeid'] ?? -1,
      distance: json['distance'] ?? -1,
    );
  }
}
