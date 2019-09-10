abstract class MessioException implements Exception{
    errorMessage();
}
class UserNotFoundException extends MessioException{
  @override
  errorMessage() {
    return 'No user found for provided uid/username';
  }
}
class UsernameMappingUndefinedException extends MessioException{
  @override
  errorMessage() {
    return 'No uid mapping for the provided username';
  }
}