/// Centralized HTTP status and API error messages mapper.
class ErrorMapper {
  static String mapStatusCode(int code) {
    switch (code) {
      case 400:
        return 'Invalid request. Please try again.';
      case 401:
        return 'Unauthorized access. Please log in again.';
      case 403:
        return "You don't have permission to perform this action.";
      case 404:
        return 'Your session has expired. Please log in again.';
      case 408:
        return 'Request timed out. Please try again.';
      case 500:
      case 502:
      case 503:
        return 'Server is busy. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  static String mapNoInternet() {
    return 'No Internet Connection. Please check your network.';
  }

  static String mapTimeout() {
    return 'Request timed out. Please try again.';
  }

  static String mapUnknown() {
    return 'Something went wrong. Please try again.';
  }
}
