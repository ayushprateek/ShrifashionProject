import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:package_info_plus/package_info_plus.dart';

class DynamicLinksService {
  static Future<String> createDynamicLink(String parameter) async {

    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // print(packageInfo.packageName);
    // String uriPrefix = "https://shrifashion.page.link";
    //
    // final DynamicLinkParameters parameters = DynamicLinkParameters(
    //   uriPrefix: uriPrefix,
    //   link: Uri.parse('https://shuchibusiness.in/$parameter'),
    //   androidParameters: AndroidParameters(
    //     packageName: packageInfo.packageName,
    //     minimumVersion: 125,
    //   ),
    //   iosParameters: IosParameters(
    //     bundleId: packageInfo.packageName,
    //     minimumVersion: packageInfo.version,
    //     appStoreId: '123456789',
    //   ),
    //   googleAnalyticsParameters: GoogleAnalyticsParameters(
    //     campaign: 'example-promo',
    //     medium: 'social',
    //     source: 'orkut',
    //   ),
    //   itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
    //     providerToken: '123456',
    //     campaignToken: 'example-promo',
    //   ),
    //   socialMetaTagParameters: SocialMetaTagParameters(
    //       title: 'Example of a Dynamic Link',
    //       description: 'This link works whether app is installed or not!',
    //       imageUrl: Uri.parse(
    //           "https://images.pexels.com/photos/3841338/pexels-photo-3841338.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260")),
    // );

    // final Uri dynamicUrl = await parameters.buildUrl();
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // The Dynamic Link URI domain. You can view created URIs on your Firebase console
      uriPrefix: 'https://shrifashion.page.link',
      // The deep Link passed to your application which you can use to affect change
      link: Uri.parse('https://shuchibusiness.in/$parameter'),
      // Android application details needed for opening correct app on device/Play Store
      androidParameters:  AndroidParameters(
        packageName: "com.shrisolutions.shrifashion",
        minimumVersion: 1,
      ),
      // iOS application details needed for opening correct app on device/App Store
      // iosParameters:  IOSParameters(
      //   bundleId: iosBundleId,
      //   minimumVersion: '2',
      // ),
    );

    // final Uri uri = await dynamicLinks.buildLink(parameters);
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl.toString();
  }

  static void initDynamicLinks() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDynamicLink(data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          _handleDynamicLink(dynamicLink);
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  static _handleDynamicLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data?.link;

    if (deepLink == null) {
      return;
    }
    if (deepLink.pathSegments.contains('refer')) {
      var title = deepLink.queryParameters['code'];
      if (title != null) {
        print("refercode=$title");


      }
    }
  }
}


//DynamicLinksService.createDynamicLink("/product_id=113");

