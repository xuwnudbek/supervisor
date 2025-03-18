extension NullableDatetimeExtension on DateTime? {
  String? get format {
    if (this == null) return "Nomalum";

    return "${this!.day < 10 ? "0${this!.day}" : this!.day}.${this!.month < 10 ? "0${this!.month}" : this!.month}.${this!.year}";
  }

  String? get toYMDHM {
    if (this == null) return "Nomalum";

    return "${this!.year}-${this!.month.toString().padLeft(2, "0")}-${this!.day.toString().padLeft(2, "0")} ${this!.hour.toString().padLeft(2, "0")}:${this!.minute.toString().padLeft(2, "0")}";
  }
}
