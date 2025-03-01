class Paging<T> {
  final List<T> data;
  final bool hasNext;

  const Paging({
    this.data = const [],
    this.hasNext = true,
  });

  Paging<T> next(List<T> data, {bool refresh = false}) => Paging<T>(
        data: refresh ? data : this.data + data,
        hasNext: data.isNotEmpty,
      );
}
