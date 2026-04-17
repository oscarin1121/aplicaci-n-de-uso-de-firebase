class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  String get preferredName {
    if (displayName != null && displayName!.trim().isNotEmpty) {
      return displayName!.trim();
    }

    return email.split('@').first;
  }

  String get initials {
    final List<String> segments = preferredName
        .split(RegExp(r'[\s._-]+'))
        .where((String item) => item.isNotEmpty)
        .toList();

    if (segments.isEmpty) {
      return 'KD';
    }

    if (segments.length == 1) {
      final String value = segments.first;
      return value.substring(0, value.length >= 2 ? 2 : 1).toUpperCase();
    }

    return (segments.first[0] + segments[1][0]).toUpperCase();
  }
}
