class ApiConstants {
  static const String baseUrl = 'https://www.googleapis.com/books/v1';
  static const String searchEndpoint = '/volumes';
  
  // API Parameters
  static const String queryParam = 'q';
  static const String startIndexParam = 'startIndex';
  static const String maxResultsParam = 'maxResults';
  static const String orderByParam = 'orderBy';
  static const String filterParam = 'filter';
  static const String printTypeParam = 'printType';
  
  // Default values
  static const int defaultMaxResults = 10;
  static const int defaultStartIndex = 0;
  static const String defaultOrderBy = 'relevance';
  static const String defaultPrintType = 'books';
}
