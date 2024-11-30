class Constants {
  static const bumbleLogo = 'assets/bumble_logo.png';
}

enum Genders {
  male("Male"),
  female("Female");

  final String value;

  const Genders(
    this.value,
  );
}
