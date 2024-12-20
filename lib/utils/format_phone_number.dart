String formatPhoneNumber(String phoneNumber) {
  String cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

  if (cleanedNumber.length == 10) {
    return cleanedNumber;
  }

  if (cleanedNumber.length > 10) {
    return cleanedNumber.substring(cleanedNumber.length - 10);
  }

  return '';
}
