import '../../../data/enums/result.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/media/media.dart';
import '../../../data/providers/api_provider.dart';

class SearchResultMediaPreviewListRepository {
  SearchResultMediaPreviewListRepository();

  Future<GroupResult<MediaModel>> getSearchResults({
    required int currentPage,
    required MediaType type,
    required String keyword,
  }) {
    return ApiProvider.searchMedia(
            keyword: keyword, type: type, pageNum: currentPage)
        .then((value) {
      List<MediaModel> previews = [];
      int count = 0;

      if (value.success) {
        previews = value.data!.results;
        count = value.data!.count;
      } else {
        throw Exception(value.message);
      }

      return GroupResult(results: previews, count: count);
    });
  }
}
