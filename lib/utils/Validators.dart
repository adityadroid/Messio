class Validators {
  static final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp imageUrlRegExp = RegExp(
    r'(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)',
  );

  static final RegExp ageRegExp = RegExp(
    r'^[1-9][1-9]?$|^100$',
  );

  static isValidEmail(String email) {
    return emailRegExp.hasMatch(email);
  }

  static isValidImageUrl(String imageUrl){
    return imageUrlRegExp.hasMatch(imageUrl);
  }

  static isValidUsername(String username) {
    return true; // No solution as of now. Will implement later
  }

  static isValidAge(int age){
    return ageRegExp.hasMatch(age.toString());
  }
}