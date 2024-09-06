//purpose: validation for textformfields
import 'package:email_validator/email_validator.dart';

class TextFieldValidation {
  String? validateName(value) {
    if (value == null || value.isEmpty) {
      return 'Enter your name';
    } else if (value is String && value.length < 3) {
      return "Name must be longer than 3 characters";
    }
    return null;
  }

  String? validateEmail(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!EmailValidator.validate(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validatePhone(value) {
    if (value == null || value.isEmpty) {
      return "Please enter a phone number";
    } else if (value.length != 12 ||
        double.tryParse(value.substring(0, 3)) == null ||
        double.tryParse(value.substring(4, 7)) == null ||
        double.tryParse(value.substring(8, 12)) == null ||
        value.substring(3, 4) != "-" ||
        value.substring(7, 8) != "-") {
      return "Check if number matches format above";
    } else {
      return null;
    }
  }

  String? validatePassword(value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    } else if (value.length < 8) {
      return "Password has to be longer than 8 characters";
    }
    return null;
  }

  String? validateConfirmPassword(value, password) {
    if (value == null || value.isEmpty) {
      return "Please enter your password again";
    } else if (value == password) {
      return null;
    }
    return ("Passwords do not match");
  }
}
