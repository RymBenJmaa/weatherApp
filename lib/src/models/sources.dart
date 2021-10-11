class SourcesData {
  ///Name of the source
  final String title;

  ///URL of the source
  final String url;

  SourcesData({
    required this.title,
    required this.url,
  });
  factory SourcesData.fromJson(Map<String, dynamic> json) {
    return SourcesData(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
