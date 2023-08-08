import '../../../../../data/models/tag.dart';
import '../../../../../data/providers/api_provider.dart';

class AddTagRepository {
  Future<List<TagModel>> autoCompleteTags(String keyword) async {
    return ApiProvider.autoCompleteTags(keyword: keyword).then((value) {
      List<TagModel> tags = [];

      if (value.success) {
        tags = value.data!;
      } else {
        throw Exception(value.message);
      }

      return tags;
    });
  }
}
