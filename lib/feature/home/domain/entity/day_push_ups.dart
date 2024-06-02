abstract class DayPushUps {
  final int value;
  final String date;
  DayPushUps(
    this.value,
    this.date,
  );
}

class BaseDayPushUps extends DayPushUps {
  final int season;

  BaseDayPushUps({required this.season, required value, required date})
      : super(value, date);
}

class EmptyDayPushUps extends DayPushUps {
  EmptyDayPushUps() : super(-1, '');
}

class ZeroDayPushUps extends DayPushUps {
  ZeroDayPushUps(String date) : super(0, date);
}
