enum IwrState {
  none,
  loading,
  success,
  fail,
  noMore,
  requireLogin,
}

class IwrStateData<T> {
  final T? data;
  final IwrState state;

  const IwrStateData({this.data, required this.state});
}
