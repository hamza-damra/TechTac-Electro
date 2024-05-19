class MyValidators {
  static String? displayNamevalidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Display name cannot be empty';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Display name must be between 3 and 20 characters';
    }
    return null; // Return null if display name is valid
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? cityValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a city';
    }
    return null;
  }

  static String? zipCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a zip code';
    }
    if (!RegExp(r'^\d{5}(?:[-\s]\d{4})?$').hasMatch(value)) {
      return 'Please enter a valid zip code';
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? addressValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an address';
    }
    return null;
  }
}
