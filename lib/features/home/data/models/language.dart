class Language {
  final String name;
  final String name_variable;
  final String name_abbreviation;
  Language({
    required this.name,
    required this.name_variable,
    required this.name_abbreviation,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
        name: json['name']?.toString() ?? '',
        name_variable: json['name_variable']?.toString() ?? '',
        name_abbreviation: json['name_abbreviation']?.toString() ?? '');
  }
}
