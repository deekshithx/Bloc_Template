// lib/core/services/dynamic_link_service.dart
// Skeleton dynamic link service: integrate with Firebase Dynamic Links when ready.

class DynamicLinkService {
  DynamicLinkService();

  /// Call this from app init to prepare handling links.
  Future<void> init() async {
    // TODO: Integrate Firebase Dynamic Links:
    // - FirebaseDynamicLinks.instance.getInitialLink()
    // - FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData data) { ... })
  }

  /// Handle the incoming link payload and return a path to navigate to (optional).
  String? handleLink(Uri uri) {
    // Example: if uri.pathSegments contains 'invite', return '/signup?invite=...'
    // TODO: implement your own logic
    return null;
  }
}
