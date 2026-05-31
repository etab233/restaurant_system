import 'package:string_similarity/string_similarity.dart';

class SearchUtils {
  static String normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[أإآا]'), 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .trim();
  }

   static double mealScore(String mealName, String query) {
    final words = normalize(mealName).split(' ');
    final q = normalize(query);

    double bestScore = 0;

    for (final word in words) {
      final score = StringSimilarity.compareTwoStrings(word, q);

      if (score > bestScore) {
        bestScore = score;
      }
    }

    return bestScore;
  }
}
