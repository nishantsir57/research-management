class ReviewerHighlight {
  ReviewerHighlight({
    required this.id,
    required this.startIndex,
    required this.endIndex,
    required this.comment,
    this.text,
  });

  final String id;
  final int startIndex;
  final int endIndex;
  final String comment;
  final String? text;

  factory ReviewerHighlight.fromMap(Map<String, dynamic> data) {
    return ReviewerHighlight(
      id: data['id'] as String? ?? '',
      startIndex: data['startIndex'] as int? ?? 0,
      endIndex: data['endIndex'] as int? ?? 0,
      comment: data['comment'] as String? ?? '',
      text: data['text'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startIndex': startIndex,
      'endIndex': endIndex,
      'comment': comment,
      'text': text,
    };
  }
}
