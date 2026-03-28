import 'package:finances_control/core/remote_config/enum/remote_config_key.dart';
import 'package:finances_control/core/remote_config/implementation/app_remote_config.dart';
import 'package:finances_control/feat/ebooks/data/dto/ebook_dto.dart';
import 'package:finances_control/feat/ebooks/data/repo/ebooks_repository.dart';
import 'package:finances_control/feat/ebooks/domain/ebook.dart';

class EbooksRepositoryImpl implements EbooksRepository {
  final AppRemoteConfig remoteConfig;

  EbooksRepositoryImpl(this.remoteConfig);

  @override
  Future<List<Ebook>> getEbooks() async {
    final rawList = remoteConfig.getJsonList(RemoteConfigKey.ebooks);

    return rawList
        .map((json) => EbookDto.fromJson(json))
        .map((dto) {
          try {
            return dto.toDomain();
          } catch (e) {
            return null;
          }
        })
        .whereType<Ebook>()
        .toList();
  }
}
