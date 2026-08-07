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
        return 'Requested data was not found.';
      case 408:
        return 'The request is taking longer than expected. Please try again later.';
      case 500:
      case 502:
      case 503:
        return 'Something went wrong on our server. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  static String mapNoInternet() {
    return 'No internet connection. Please check your network and try again.';
  }

  static String mapTimeout() {
    return 'The request is taking longer than expected. Please try again later.';
  }

  static String mapUnknown() {
    return 'Something went wrong. Please try again later.';
  }
}
