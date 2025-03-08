class Constants {
  static const bumbleLogo = 'assets/images/bumble_logo.png';
  static const defaultPfp = 'assets/images/default_pfp.png';
}

enum Genders {
  male("Male"),
  female("Female");

  final String value;

  const Genders(
    this.value,
  );
}
