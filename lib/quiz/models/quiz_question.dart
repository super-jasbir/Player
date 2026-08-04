/// A single quiz question with a fixed list of options and the index of the
/// correct one. Options are shown in order as A / B / C ... cards.
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}
