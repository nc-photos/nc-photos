import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:np_collection/np_collection.dart';
import 'package:to_string/to_string.dart';

part 'search.g.dart';

@toString
class SearchCriteria {
  SearchCriteria(String input, this.filters) : input = input.trim();

  SearchCriteria copyWith({String? input, List<SearchFilter>? filters}) =>
      SearchCriteria(input ?? this.input, filters ?? List.of(this.filters));

  @override
  String toString() => _$toString();

  final String input;
  @Format(r"${$?.toReadableString()}")
  final List<SearchFilter> filters;
}

abstract class SearchFilter {
  Map<Symbol, Object> toQueryArgument();
  bool isSatisfy(File file);
}

enum SearchFileType { image, video }

@toString
class SearchFileTypeFilter implements SearchFilter {
  const SearchFileTypeFilter(this.type);

  @override
  Map<Symbol, Object> toQueryArgument() {
    if (type == SearchFileType.image) {
      return {#mimes: file_util.supportedImageFormatMimes};
    } else {
      return {#mimes: file_util.supportedVideoFormatMimes};
    }
  }

  @override
  isSatisfy(File file) {
    switch (type) {
      case SearchFileType.image:
        return file_util.isSupportedImageFormat(file);

      case SearchFileType.video:
        return file_util.isSupportedVideoFormat(file);
    }
  }

  @override
  String toString() => _$toString();

  final SearchFileType type;
}

@toString
class SearchFavoriteFilter implements SearchFilter {
  const SearchFavoriteFilter(this.value);

  @override
  Map<Symbol, Object> toQueryArgument() {
    return {#isFavorite: value};
  }

  @override
  isSatisfy(File file) => (file.isFavorite ?? false) == value;

  @override
  String toString() => _$toString();

  final bool value;
}

class SearchRepo {
  const SearchRepo(this.dataSrc);

  Future<List<FileDescriptor>> list(Account account, SearchCriteria criteria) =>
      dataSrc.list(account, criteria);

  final SearchDataSource dataSrc;
}

abstract class SearchDataSource {
  /// List all results from a given search criteria
  Future<List<FileDescriptor>> list(Account account, SearchCriteria criteria);
}
