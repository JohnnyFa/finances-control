import 'package:finances_control/feat/premium/domain/entitlement.dart';

class LocalEntitlementModel {
  final String value;

  const LocalEntitlementModel(this.value);

  Entitlement toDomain() {
    switch (value) {
      case 'premium':
        return Entitlement.premium;
      case 'no_ads':
        return Entitlement.noAds;
      default:
        return Entitlement.free;
    }
  }

  static LocalEntitlementModel fromDomain(Entitlement entitlement) {
    switch (entitlement) {
      case Entitlement.premium:
        return const LocalEntitlementModel('premium');
      case Entitlement.noAds:
        return const LocalEntitlementModel('no_ads');
      case Entitlement.free:
        return const LocalEntitlementModel('free');
    }
  }
}