import '../../../data/enums/result.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/media/media.dart';
import '../../../global_widgets/sliver_refresh/controller.dart';
import 'repository.dart';

class SearchResultMediaPreviewListController
    extends SliverRefreshController<MediaModel> {
  final SearchResultMediaPreviewListRepository repository =
      SearchResultMediaPreviewListRepository();

  late MediaType _type;
  late String _keyword;

  void initConfig(MediaType type, String keyword) {
    _type = type;
    _keyword = keyword;
  }

  Future<void> resetKeyword(String keyword) async {
    _keyword = keyword;
    await refreshData(showSplash: true, showFooter: false);
  }

  @override
  Future<GroupResult<MediaModel>> getNewData(int currentPage) {
    return repository.getSearchResults(
      currentPage: currentPage,
      type: _type,
      keyword: _keyword,
    );
  }
}
