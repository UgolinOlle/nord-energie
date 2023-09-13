class Note {
  final String text;

  Note({
    required this.text,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      text: json['text'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}
