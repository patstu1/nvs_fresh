/// Case helpers to enforce NVS typographic rules.
/// - Section names and usernames: UPPERCASE (display only)
/// - All other copy: lowercase (display only)
library;

String nvsUpper(String input) => input.toUpperCase();

String nvsLower(String input) => input.toLowerCase();
