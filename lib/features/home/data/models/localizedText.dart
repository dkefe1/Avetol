class LocalizedText {
  final String key;
  final String value;
  LocalizedText({required this.key, required this.value});

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
        key: json['key']?.toString() ?? '',
        value: json['value']?.toString() ?? '');
  }
}
