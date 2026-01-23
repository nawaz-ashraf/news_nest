// Loading State Enum
enum LoadingState {
  initial, // Not yet loaded
  loading, // Currently fetching
  loaded, // Successfully loaded
  error, // Error occurred
  loadingMore, // Loading pagination
}
