// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_stock_history_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetStockHistoryResponse extends GetStockHistoryResponse {
  @override
  final BuiltList<StockMoveHistoryResponse>? moves;
  @override
  final int page;
  @override
  final int limit;
  @override
  final int total;

  factory _$GetStockHistoryResponse([
    void Function(GetStockHistoryResponseBuilder)? updates,
  ]) => (GetStockHistoryResponseBuilder()..update(updates))._build();

  _$GetStockHistoryResponse._({
    this.moves,
    required this.page,
    required this.limit,
    required this.total,
  }) : super._();
  @override
  GetStockHistoryResponse rebuild(
    void Function(GetStockHistoryResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetStockHistoryResponseBuilder toBuilder() =>
      GetStockHistoryResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetStockHistoryResponse &&
        moves == other.moves &&
        page == other.page &&
        limit == other.limit &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, moves.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetStockHistoryResponse')
          ..add('moves', moves)
          ..add('page', page)
          ..add('limit', limit)
          ..add('total', total))
        .toString();
  }
}

class GetStockHistoryResponseBuilder
    implements
        Builder<GetStockHistoryResponse, GetStockHistoryResponseBuilder> {
  _$GetStockHistoryResponse? _$v;

  ListBuilder<StockMoveHistoryResponse>? _moves;
  ListBuilder<StockMoveHistoryResponse> get moves =>
      _$this._moves ??= ListBuilder<StockMoveHistoryResponse>();
  set moves(ListBuilder<StockMoveHistoryResponse>? moves) =>
      _$this._moves = moves;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  GetStockHistoryResponseBuilder() {
    GetStockHistoryResponse._defaults(this);
  }

  GetStockHistoryResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _moves = $v.moves?.toBuilder();
      _page = $v.page;
      _limit = $v.limit;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetStockHistoryResponse other) {
    _$v = other as _$GetStockHistoryResponse;
  }

  @override
  void update(void Function(GetStockHistoryResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetStockHistoryResponse build() => _build();

  _$GetStockHistoryResponse _build() {
    _$GetStockHistoryResponse _$result;
    try {
      _$result =
          _$v ??
          _$GetStockHistoryResponse._(
            moves: _moves?.build(),
            page: BuiltValueNullFieldError.checkNotNull(
              page,
              r'GetStockHistoryResponse',
              'page',
            ),
            limit: BuiltValueNullFieldError.checkNotNull(
              limit,
              r'GetStockHistoryResponse',
              'limit',
            ),
            total: BuiltValueNullFieldError.checkNotNull(
              total,
              r'GetStockHistoryResponse',
              'total',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'moves';
        _moves?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GetStockHistoryResponse',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
