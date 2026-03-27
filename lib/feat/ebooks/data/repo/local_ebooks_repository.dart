import 'package:finances_control/feat/ebooks/data/repo/ebooks_repository.dart';
import 'package:finances_control/feat/ebooks/domain/ebook.dart';

class LocalEbooksRepository implements EbooksRepository {
  @override
  Future<List<Ebook>> getEbooks() async {
    return const [
      Ebook(id: '1', title: 'The Psychology of Money', author: 'Morgan Housel'),
      Ebook(id: '2', title: 'Rich Dad Poor Dad', author: 'Robert T. Kiyosaki'),
      Ebook(id: '3', title: 'I Will Teach You to Be Rich', author: 'Ramit Sethi'),
    ];
  }
}
