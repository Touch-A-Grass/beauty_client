import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppFormatters {
  const AppFormatters._();

  static MaskTextInputFormatter createPhoneFormatter() =>
      MaskTextInputFormatter(mask: '+# (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
}
