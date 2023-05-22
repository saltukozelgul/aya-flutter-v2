extension StringExtension on String {
  String capitalizeFirstChar() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String trFormattedDate() {
    final date = DateTime.parse(this);
    final day = date.day;
    final month = date.month;
    final year = date.year;
    switch (month) {
      case 1:
        return "$day Ocak $year";
      case 2:
        return "$day Şubat $year";
      case 3:
        return "$day Mart $year";
      case 4:
        return "$day Nisan $year";
      case 5:
        return "$day Mayıs $year";
      case 6:
        return "$day Haziran $year";
      case 7:
        return "$day Temmuz $year";
      case 8:
        return "$day Ağustos $year";
      case 9:
        return "$day Eylül $year";
      case 10:
        return "$day Ekim $year";
      case 11:
        return "$day Kasım $year";
      case 12:
        return "$day Aralık $year";
      default:
        return "$day $month $year";
    }
  }
}
