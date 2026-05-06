import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/utils/expense_category_detector.dart';

@Deprecated('Use ExpenseCategoryDetector instead.')
class CategoryDetector {
  static Category detect(String description) {
    return ExpenseCategoryDetector.detect(description);
  }
}
