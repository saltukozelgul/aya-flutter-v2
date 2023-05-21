extension StringExtension on String {
  String capitalizeFirstChar() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
