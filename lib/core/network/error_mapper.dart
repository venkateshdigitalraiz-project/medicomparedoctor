/// Centralized HTTP status and API error messages mapper.
class ErrorMapper {
  static String mapStatusCode(int code) {
    switch (code) {
      case 400:
        return 'Invalid request. Please try again.';
      case 401:
        return 'Your session has expired. Please log in again.';
      case 403:
        return "You don't have permission to perform this action.";
      case 404:
        return 'Server is busy. Please try again later.';
      case 408:
        return 'Request timed out. Please try again.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
      case 502:
      case 503:
        return 'Server is busy. Please try again later.';
      default:
        return 'Server is busy. Please try again later.';
    }
  }

  static String mapNoInternet() {
    return 'No Internet Connection. Please check your network.';
  }
}
