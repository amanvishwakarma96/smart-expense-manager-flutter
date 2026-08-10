class DuplicateTransactionCandidate {
  const DuplicateTransactionCandidate({
    required this.id,
    required this.amount,
    required this.merchant,
    required this.accountTail,
    required this.timestamp,
  });

  final int id;
  final double amount;
  final String merchant;
  final String accountTail;
  final DateTime timestamp;
}

class DuplicateTransactionDetector {
  const DuplicateTransactionDetector();

  static const double amountTolerance = 1;
  static const Duration timeWindow = Duration(minutes: 5);

  int? findPossibleDuplicate({
    required double amount,
    required String merchant,
    required String accountTail,
    required DateTime timestamp,
    required Iterable<DuplicateTransactionCandidate> existing,
  }) {
    final String normalizedAccount = accountTail.trim();
    if (normalizedAccount.isEmpty) {
      return null;
    }

    final List<DuplicateTransactionCandidate> matches =
        existing
            .where((item) {
              if (item.accountTail.trim().isEmpty ||
                  item.accountTail.trim() != normalizedAccount) {
                return false;
              }
              if ((item.amount - amount).abs() > amountTolerance) {
                return false;
              }
              if (!_merchantsMatch(item.merchant, merchant)) {
                return false;
              }
              final int delta = item.timestamp
                  .difference(timestamp)
                  .inMilliseconds
                  .abs();
              return delta <= timeWindow.inMilliseconds;
            })
            .toList(growable: false)
          ..sort((a, b) {
            final int aDelta = a.timestamp
                .difference(timestamp)
                .inMilliseconds
                .abs();
            final int bDelta = b.timestamp
                .difference(timestamp)
                .inMilliseconds
                .abs();
            final int timeComparison = aDelta.compareTo(bDelta);
            return timeComparison != 0 ? timeComparison : a.id.compareTo(b.id);
          });

    return matches.isEmpty ? null : matches.first.id;
  }

  bool _merchantsMatch(String first, String second) {
    final String left = _normalizeMerchant(first);
    final String right = _normalizeMerchant(second);
    if (left.isEmpty || right.isEmpty) {
      return false;
    }
    if (left.contains(right) || right.contains(left)) {
      return true;
    }
    return _levenshtein(left, right) <= 2;
  }

  String _normalizeMerchant(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  int _levenshtein(String left, String right) {
    if (left == right) {
      return 0;
    }
    if (left.isEmpty) {
      return right.length;
    }
    if (right.isEmpty) {
      return left.length;
    }

    List<int> previous = List<int>.generate(right.length + 1, (index) => index);
    for (int i = 1; i <= left.length; i += 1) {
      final List<int> current = List<int>.filled(right.length + 1, 0);
      current[0] = i;
      for (int j = 1; j <= right.length; j += 1) {
        final int substitutionCost =
            left.codeUnitAt(i - 1) == right.codeUnitAt(j - 1) ? 0 : 1;
        final int deletion = previous[j] + 1;
        final int insertion = current[j - 1] + 1;
        final int substitution = previous[j - 1] + substitutionCost;
        current[j] = _min3(deletion, insertion, substitution);
      }
      previous = current;
    }
    return previous[right.length];
  }

  int _min3(int first, int second, int third) {
    final int pair = first < second ? first : second;
    return pair < third ? pair : third;
  }
}
