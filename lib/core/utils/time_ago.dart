import 'package:my_project/l10n/app_localizations.dart';

String formatTimeAgo(DateTime time, AppLocalizations l10n) {
  final difference = DateTime.now().difference(time);

  if (difference.inSeconds < 60) {
    return "${difference.inSeconds}s";
  } else if (difference.inMinutes < 60) {
    return l10n.minutesAgo(difference.inMinutes);
  } else if (difference.inHours < 24) {
    return "${difference.inHours}h";
  } else {
    return "${difference.inDays}d";
  }
}