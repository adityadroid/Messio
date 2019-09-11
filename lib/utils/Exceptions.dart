abstract class MessioException implements Exception{
    String errorMessage();
}
class UserNotFoundException extends MessioException{
  @override
  String errorMessage() => 'No user found for provided uid/username';

}
class UsernameMappingUndefinedException extends MessioException{
  @override
  String errorMessage() =>'User not found';

}
class ContactAlreadyExistsException extends MessioException{
  @override
  String errorMessage() => 'Contact already exists!';
}