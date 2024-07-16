class CloudStorageException implements Exception {
  const CloudStorageException();
}

// CRUD exceptions

class CouldNotCreateCartException extends CloudStorageException {}

class CouldNotReadCartException extends CloudStorageException {}

class CouldNotReadCartItemsException extends CloudStorageException {}

class CouldNotUpdateCartException extends CloudStorageException {}

class CouldNotDeleteCartException extends CloudStorageException {}

class CouldNotDeleteCartItemsException extends CloudStorageException {}
