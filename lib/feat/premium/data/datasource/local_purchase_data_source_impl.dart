import 'package:finances_control/feat/premium/data/datasource/local_purchase_data_source.dart';
import 'package:finances_control/feat/premium/data/model/local_entitlement_model.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPurchaseDataSourceImpl implements LocalPurchaseDataSource {
  static const String _entitlementKey = 'user_entitlement';

  @override
  Future<void> saveEntitlement(Entitlement entitlement) async {
    final prefs = await SharedPreferences.getInstance();
    final model = LocalEntitlementModel.fromDomain(entitlement);
    await prefs.setString(_entitlementKey, model.value);
  }

  @override
  Future<Entitlement?> getEntitlement() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_entitlementKey);
    
    if (value == null) return null;
    
    final model = LocalEntitlementModel(value);
    return model.toDomain();
  }
}
