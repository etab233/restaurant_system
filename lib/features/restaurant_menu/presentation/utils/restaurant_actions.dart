import 'package:url_launcher/url_launcher.dart';

Future<void> openMap({
  required double lat,
  required double lng,
  required String name,
}) async {
  final Uri url = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$name&center=$lat,$lng',
  );
  await launchUrl(url, mode: LaunchMode.externalApplication);
}

Future<void> makePhoneCall(String phoneNumber) async {
  final url = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(url, mode: LaunchMode.externalApplication);
}