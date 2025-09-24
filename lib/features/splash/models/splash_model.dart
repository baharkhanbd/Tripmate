class SplashModel {
  bool _isLoading = true;
  bool _isInitialized = false;

  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  void setLoading(bool loading) {
    _isLoading = loading;
  }

  void setInitialized(bool initialized) {
    _isInitialized = initialized;
  }
}
