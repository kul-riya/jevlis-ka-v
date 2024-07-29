// Register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// Login exceptions

class UserNotLoggedInAuthException implements Exception {}

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class PhoneVerificationAuthException implements Exception {}

// Generic exceptions

class GenericAuthException implements Exception {}
