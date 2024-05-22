///
class BaseModel<T> {
  ///
  BaseModel({required this.title, required this.data, this.subtitle});

  /// Optional subtitle of base model for display purposes
  final String title;

  /// Optional subtitle of base model for display purposes
  final String? subtitle;

  /// Data of the base model, this can be any data type
  final T data;
}
