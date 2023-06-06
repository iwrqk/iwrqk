import '../../data/enums/result.dart';
import '../../data/enums/types.dart';
import '../../data/models/media/media.dart';
import '../../data/models/resolution.dart';
import '../../data/providers/api_provider.dart';

class MediaDetailRepository {
  MediaDetailRepository();

  Future<ApiResult<Object>> getMedia(String id, MediaType type) async {
    return type == MediaType.video
        ? ApiProvider.getVideo(id)
        : ApiProvider.getImage(id);
  }

  Future<ApiResult<List<ResolutionModel>>> getVideoResolutions(
    String url,
    String xversion,
  ) {
    return ApiProvider.getVideoResolutions(url, xversion);
  }

  Future<ApiResult<List<MediaModel>>> getMoreFromUser({
    required String userId,
    required String mediaId,
    required MediaType type,
  }) async {
    ApiResult<GroupResult<MediaModel>> result = await ApiProvider.getMedia(
      path: type == MediaType.video ? "/videos" : "/images",
      queryParameters: {"user": userId, "exclude": mediaId, "limit": 6},
      type: type,
    );
    return ApiResult(
      data: result.data?.results,
      message: result.message,
      success: result.success,
    );
  }

  Future<ApiResult<List<MediaModel>>> getMoreLikeThis({
    required String mediaId,
    required MediaType type,
  }) async {
    ApiResult<GroupResult<MediaModel>> result = await ApiProvider.getMedia(
        path: "/${type.value}/$mediaId/related", type: type);

    return ApiResult(
      data: result.data?.results,
      message: result.message,
      success: result.success,
    );
  }
}
