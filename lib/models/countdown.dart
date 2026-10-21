sealed class Countdown {
  const Countdown();

  factory Countdown.fromDateTime(DateTime target, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final difference = target.difference(current);

    if (difference.isNegative) {
      final elapsed = current.difference(target);
      if (elapsed.inHours < 3) {
        return Started(elapsed);
      }
      return const Ended();
    }
    return Upcoming(difference);
  }
}

final class Upcoming extends Countdown {
  final Duration remaining;
  const Upcoming(this.remaining);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Upcoming && other.remaining.inMinutes == remaining.inMinutes;

  @override
  int get hashCode => remaining.inMinutes.hashCode;
}

final class Started extends Countdown {
  final Duration elapsed;
  const Started(this.elapsed);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Started && other.elapsed.inMinutes == elapsed.inMinutes;

  @override
  int get hashCode => elapsed.inMinutes.hashCode;
}

final class Ended extends Countdown {
  const Ended();

  @override
  bool operator ==(Object other) => identical(this, other) || other is Ended;

  @override
  int get hashCode => 0;
}
