import 'package:get/get.dart';

import 'models/quiz_question.dart';

/// Drives the SPENDATHON quiz flow: holds the question list, the current
/// question index, the player's per-question selection and the running score.
///
/// The screens (intro -> question -> result) all read from this single
/// controller so progress survives navigation between them.
class QuizController extends GetxController {
  /// Points awarded per correct answer (Figma result card: "You earned 20
  /// points" for the sample run).
  static const int pointsPerCorrect = 5;

  /// Sample question bank. Swap this for an API response when the quiz
  /// endpoint is available — the screens only depend on [QuizQuestion].
  final List<QuizQuestion> questions = const [
    QuizQuestion(
      question: "What is Singapore also known as?",
      options: ["The Lion City", "The Garden City", "Both A & B"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "What is the national flower of Singapore?",
      options: ["Orchid (Vanda Miss Joaquim)", "Rose", "Lotus"],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: "Which currency is used in Singapore?",
      options: ["Malaysian Ringgit", "Singapore Dollar", "US Dollar"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "What is the tallest observation wheel in Singapore?",
      options: ["London Eye", "Singapore Flyer", "High Roller"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "Merlion is a mascot of Singapore. What is its body?",
      options: ["Lion", "Fish", "Dragon"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "Which of these is a famous hawker food in Singapore?",
      options: ["Chilli Crab", "Hainanese Chicken Rice", "Both A & B"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "What language is one of Singapore's official languages?",
      options: ["Malay", "French", "Japanese"],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: "Sentosa is best described as a?",
      options: ["Shopping mall", "Resort island", "Business district"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "Which iconic hotel has a rooftop infinity pool?",
      options: ["Marina Bay Sands", "Raffles Hotel", "Fullerton Hotel"],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: "What colour(s) are on the Singapore flag?",
      options: ["Red & White", "Blue & Yellow", "Green & White"],
      correctIndex: 0,
    ),
  ];

  /// Zero-based index of the question currently on screen.
  final RxInt currentIndex = 0.obs;

  /// The option the player tapped for the current question, or null.
  final RxnInt selectedOption = RxnInt();

  /// Number of correct answers so far.
  final RxInt correctCount = 0.obs;

  /// Answers already recorded, keyed by question index -> chosen option.
  final Map<int, int> _answers = {};

  int get total => questions.length;

  QuizQuestion get current => questions[currentIndex.value];

  bool get isLastQuestion => currentIndex.value >= total - 1;

  int get earnedPoints => correctCount.value * pointsPerCorrect;

  /// Reset the whole run — called when the player taps START QUIZ.
  void start() {
    currentIndex.value = 0;
    selectedOption.value = null;
    correctCount.value = 0;
    _answers.clear();
  }

  void selectOption(int index) {
    selectedOption.value = index;
  }

  /// Record the current selection and advance. Returns true when the quiz is
  /// finished (the caller then routes to the result screen).
  bool submitAndAdvance() {
    final int? chosen = selectedOption.value;
    if (chosen == null) return false;

    // Only count the first time an answer is recorded for this question.
    if (!_answers.containsKey(currentIndex.value)) {
      _answers[currentIndex.value] = chosen;
      if (chosen == current.correctIndex) correctCount.value++;
    }

    if (isLastQuestion) return true;

    currentIndex.value++;
    selectedOption.value = _answers[currentIndex.value];
    return false;
  }
}
