part of 'text_fields.dart';

/// Primary text field
class DefaultTextField extends StatefulWidget {
  /// constructor
  const DefaultTextField({
    required this.controller,
    required this.validatorPattern,
    this.sanitizeInput = false,
    this.errorText,
    this.validationFunction,
    TextCapitalization? textCapitalization,
    this.autofillHints,
    this.maxLength,
    this.autocorrect,
    this.labelText,
    this.prefixText,
    this.onTap,
    this.suffixText,
    this.onFieldSubmitted,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly,
    this.inputFormatters,
    this.obscureText = false,
    this.minLines,
    this.maxLines = 1,
    bool? hasTrailingObscureIcon,
    super.key,
  })  : textCapitalization = textCapitalization ?? TextCapitalization.none,
        hasTrailingObscureIcon = hasTrailingObscureIcon ?? false;

  final bool sanitizeInput;

  ///
  final Iterable<String>? autofillHints;

  /// Passed down to the text field
  final TextEditingController controller;

  /// performs the validation
  final VoidCallback? validationFunction;

  ///
  final String validatorPattern;

  ///
  final bool? autocorrect;

  ///
  final bool? readOnly;

  ///
  final String? labelText;

  ///
  final String? prefixText;

  ///
  final String? suffixText;

  ///
  final int? maxLength;

  ///
  final void Function(String)? onFieldSubmitted;

  ///
  final VoidCallback? onChanged;

  ///
  final void Function()? onTap;

  ///
  final TextInputAction? textInputAction;

  ///
  final TextInputType? keyboardType;

  ///
  final String? errorText;

  ///
  final String? hintText;

  ///
  final Widget? prefixIcon;

  ///
  final bool hasTrailingObscureIcon;

  ///
  final Widget? suffixIcon;

  ///
  final List<TextInputFormatter>? inputFormatters;

  ///
  final TextCapitalization textCapitalization;

  ///
  final bool obscureText;

  ///
  final int? minLines;

  ///
  final int? maxLines;

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  final ValueNotifier<bool> _formIsValid = ValueNotifier(true);

  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final obscure = ValueNotifier<bool>(widget.hasTrailingObscureIcon);

    return ValueListenableBuilder(
        valueListenable: _formIsValid,
        builder: (context, isValid, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder(
                  valueListenable: obscure,
                  builder: (context, obscured, _) {
                    return TextField(
                      controller: widget.controller,
                      autofillHints: widget.autofillHints,
                      readOnly: widget.readOnly ?? false,
                      autocorrect: widget.autocorrect ?? false,
                      minLines: widget.minLines,
                      maxLines: widget.maxLines,
                      onTap: widget.onTap,
                      onTapOutside: (_) {
                        /// Disable the keyboard when user taps outside the text field or keyboard
                        final currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                      maxLength: widget.maxLength,
                      onChanged: (_) {
                        widget.onChanged?.call();

                        /// Pass the validation pattern to a regex
                        final regex = RegExp(widget.validatorPattern);
                        final text = widget.sanitizeInput ? widget.controller.text.sanitize : widget.controller.text;

                        final validator = regex.hasMatch(text);
                        widget.validationFunction?.call();

                        /// first check if the form input is valid
                        if (validator) {
                          /// immediately assign the validator to the value of [_formIsValid]
                          _formIsValid.value = validator;
                          _debounce?.cancel();
                        }

                        ///  if the form input isn't valid
                        else {
                          /// check if the debounce timer is active. if it is active cancel it
                          /// This approach is more efficient and effective to using the duration approach
                          if (_debounce?.isActive ?? false) _debounce?.cancel();

                          /// Restart the debounce timer to a duration of 3 seconds
                          _debounce = Timer(const Duration(seconds: 3), () {
                            /// assign the validator to the value of [_formIsValid] after the duration
                            _formIsValid.value = validator;
                          });
                        }
                      },
                      onSubmitted: widget.onFieldSubmitted,
                      obscureText: obscured,
                      keyboardType: widget.keyboardType,
                      textCapitalization: widget.textCapitalization,
                      textInputAction: widget.textInputAction ?? TextInputAction.next,
                      inputFormatters: widget.inputFormatters,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: widget.labelText,
                        prefixIcon: widget.prefixIcon,
                        prefixText: widget.prefixText,
                        suffixIcon: widget.hasTrailingObscureIcon
                            ? IconButton(
                                onPressed: () => obscure.value = !obscure.value,
                                icon: Icon(obscured ? Iconsax.eye : Iconsax.eye_slash),
                              )
                            : widget.suffixIcon,
                        suffixText: widget.suffixText,
                        counterStyle: context.bodyMedium,
                        hintText: widget.hintText,
                        enabledBorder: isValid
                            ? null
                            : OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8),
                              ),
                        focusedBorder: isValid
                            ? null
                            : OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8),
                              ),
                      ),
                    );
                  }),
              if (isValid)
                const SizedBox.shrink()
              else
                Text(widget.errorText ?? 'This field is not valid',
                        style: context.bodyMedium.copyWith(color: Colors.red))
                    .paddingOnly(top: 4),
            ],
          );
        });
  }
}
