import 'package:finances_control/feat/ebooks/domain/ebook.dart';

abstract class EbooksRepository {
  Future<List<Ebook>> getEbooks();
}
