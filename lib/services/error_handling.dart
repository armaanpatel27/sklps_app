class ErrorHandling {
  //returns errorString based on errorCode passed
  String errorHandling(String errorCode) {
    switch(errorCode) {
      case "invalid-email":
        return "The entered email is invalid";
      case "auth/user-disabled":
        return "The entered email has been disabled";
      case "user-not-found":
        return "The entered email does not correspond with a user";
      case "wrong-password":
        return "The entered password is incorrect";
      case "account-exists-with-different-credential":
        return "The entered email is already in use";
      case "email-already-in-use":
        return "The entered email is already in use";
      case "too-many-requests":
        return "Too many requests. Please try again later";
    }
    return "An error occurred";
  }
}