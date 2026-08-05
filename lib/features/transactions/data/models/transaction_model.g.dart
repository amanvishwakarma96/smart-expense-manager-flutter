// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransactionModelCollection on Isar {
  IsarCollection<TransactionModel> get transactionModels => this.collection();
}

const TransactionModelSchema = CollectionSchema(
  name: r'TransactionModel',
  id: -8282894918172491246,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.double),
    r'categoryId': PropertySchema(
      id: 1,
      name: r'categoryId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'encryptedAccountTail': PropertySchema(
      id: 3,
      name: r'encryptedAccountTail',
      type: IsarType.string,
    ),
    r'encryptedMerchant': PropertySchema(
      id: 4,
      name: r'encryptedMerchant',
      type: IsarType.string,
    ),
    r'encryptedOriginalSmsText': PropertySchema(
      id: 5,
      name: r'encryptedOriginalSmsText',
      type: IsarType.string,
    ),
    r'isManual': PropertySchema(id: 6, name: r'isManual', type: IsarType.bool),
    r'isRecurring': PropertySchema(
      id: 7,
      name: r'isRecurring',
      type: IsarType.bool,
    ),
    r'smsFingerprint': PropertySchema(
      id: 8,
      name: r'smsFingerprint',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 9,
      name: r'status',
      type: IsarType.byte,
      enumMap: _TransactionModelstatusEnumValueMap,
    ),
    r'timestamp': PropertySchema(
      id: 10,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'type': PropertySchema(
      id: 11,
      name: r'type',
      type: IsarType.byte,
      enumMap: _TransactionModeltypeEnumValueMap,
    ),
  },

  estimateSize: _transactionModelEstimateSize,
  serialize: _transactionModelSerialize,
  deserialize: _transactionModelDeserialize,
  deserializeProp: _transactionModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'smsFingerprint': IndexSchema(
      id: -7569193713664207826,
      name: r'smsFingerprint',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'smsFingerprint',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _transactionModelGetId,
  getLinks: _transactionModelGetLinks,
  attach: _transactionModelAttach,
  version: '3.3.2',
);

int _transactionModelEstimateSize(
  TransactionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.encryptedAccountTail.length * 3;
  bytesCount += 3 + object.encryptedMerchant.length * 3;
  bytesCount += 3 + object.encryptedOriginalSmsText.length * 3;
  {
    final value = object.smsFingerprint;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _transactionModelSerialize(
  TransactionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeLong(offsets[1], object.categoryId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.encryptedAccountTail);
  writer.writeString(offsets[4], object.encryptedMerchant);
  writer.writeString(offsets[5], object.encryptedOriginalSmsText);
  writer.writeBool(offsets[6], object.isManual);
  writer.writeBool(offsets[7], object.isRecurring);
  writer.writeString(offsets[8], object.smsFingerprint);
  writer.writeByte(offsets[9], object.status.index);
  writer.writeDateTime(offsets[10], object.timestamp);
  writer.writeByte(offsets[11], object.type.index);
}

TransactionModel _transactionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransactionModel(
    amount: reader.readDoubleOrNull(offsets[0]) ?? 0,
    categoryId: reader.readLongOrNull(offsets[1]),
    encryptedAccountTail: reader.readStringOrNull(offsets[3]) ?? '',
    encryptedMerchant: reader.readStringOrNull(offsets[4]) ?? '',
    encryptedOriginalSmsText: reader.readStringOrNull(offsets[5]) ?? '',
    id: id,
    isManual: reader.readBoolOrNull(offsets[6]) ?? false,
    isRecurring: reader.readBoolOrNull(offsets[7]) ?? false,
    smsFingerprint: reader.readStringOrNull(offsets[8]),
    status:
        _TransactionModelstatusValueEnumMap[reader.readByteOrNull(
          offsets[9],
        )] ??
        TransactionStatus.pending,
    timestamp: reader.readDateTime(offsets[10]),
    type:
        _TransactionModeltypeValueEnumMap[reader.readByteOrNull(offsets[11])] ??
        TransactionType.debit,
  );
  object.createdAt = reader.readDateTime(offsets[2]);
  return object;
}

P _transactionModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (_TransactionModelstatusValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              TransactionStatus.pending)
          as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (_TransactionModeltypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              TransactionType.debit)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TransactionModelstatusEnumValueMap = {'pending': 0, 'confirmed': 1};
const _TransactionModelstatusValueEnumMap = {
  0: TransactionStatus.pending,
  1: TransactionStatus.confirmed,
};
const _TransactionModeltypeEnumValueMap = {'debit': 0, 'credit': 1};
const _TransactionModeltypeValueEnumMap = {
  0: TransactionType.debit,
  1: TransactionType.credit,
};

Id _transactionModelGetId(TransactionModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _transactionModelGetLinks(TransactionModel object) {
  return [];
}

void _transactionModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  TransactionModel object,
) {
  object.id = id;
}

extension TransactionModelByIndex on IsarCollection<TransactionModel> {
  Future<TransactionModel?> getBySmsFingerprint(String? smsFingerprint) {
    return getByIndex(r'smsFingerprint', [smsFingerprint]);
  }

  TransactionModel? getBySmsFingerprintSync(String? smsFingerprint) {
    return getByIndexSync(r'smsFingerprint', [smsFingerprint]);
  }

  Future<bool> deleteBySmsFingerprint(String? smsFingerprint) {
    return deleteByIndex(r'smsFingerprint', [smsFingerprint]);
  }

  bool deleteBySmsFingerprintSync(String? smsFingerprint) {
    return deleteByIndexSync(r'smsFingerprint', [smsFingerprint]);
  }

  Future<List<TransactionModel?>> getAllBySmsFingerprint(
    List<String?> smsFingerprintValues,
  ) {
    final values = smsFingerprintValues.map((e) => [e]).toList();
    return getAllByIndex(r'smsFingerprint', values);
  }

  List<TransactionModel?> getAllBySmsFingerprintSync(
    List<String?> smsFingerprintValues,
  ) {
    final values = smsFingerprintValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'smsFingerprint', values);
  }

  Future<int> deleteAllBySmsFingerprint(List<String?> smsFingerprintValues) {
    final values = smsFingerprintValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'smsFingerprint', values);
  }

  int deleteAllBySmsFingerprintSync(List<String?> smsFingerprintValues) {
    final values = smsFingerprintValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'smsFingerprint', values);
  }

  Future<Id> putBySmsFingerprint(TransactionModel object) {
    return putByIndex(r'smsFingerprint', object);
  }

  Id putBySmsFingerprintSync(TransactionModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'smsFingerprint', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySmsFingerprint(List<TransactionModel> objects) {
    return putAllByIndex(r'smsFingerprint', objects);
  }

  List<Id> putAllBySmsFingerprintSync(
    List<TransactionModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'smsFingerprint', objects, saveLinks: saveLinks);
  }
}

extension TransactionModelQueryWhereSort
    on QueryBuilder<TransactionModel, TransactionModel, QWhere> {
  QueryBuilder<TransactionModel, TransactionModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TransactionModelQueryWhere
    on QueryBuilder<TransactionModel, TransactionModel, QWhereClause> {
  QueryBuilder<TransactionModel, TransactionModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterWhereClause>
  smsFingerprintIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'smsFingerprint', value: [null]),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterWhereClause>
  smsFingerprintIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'smsFingerprint',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterWhereClause>
  smsFingerprintEqualTo(String? smsFingerprint) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'smsFingerprint',
          value: [smsFingerprint],
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterWhereClause>
  smsFingerprintNotEqualTo(String? smsFingerprint) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'smsFingerprint',
                lower: [],
                upper: [smsFingerprint],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'smsFingerprint',
                lower: [smsFingerprint],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'smsFingerprint',
                lower: [smsFingerprint],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'smsFingerprint',
                lower: [],
                upper: [smsFingerprint],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension TransactionModelQueryFilter
    on QueryBuilder<TransactionModel, TransactionModel, QFilterCondition> {
  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  amountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  categoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'categoryId'),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  categoryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'categoryId'),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  categoryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categoryId', value: value),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  categoryIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'categoryId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  categoryIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'categoryId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  categoryIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'categoryId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedAccountTailEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedAccountTail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedAccountTailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'encryptedAccountTail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedAccountTailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'encryptedAccountTail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedAccountTailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'encryptedAccountTail',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedAccountTailStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'encryptedAccountTail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedAccountTailEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'encryptedAccountTail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedAccountTailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'encryptedAccountTail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedAccountTailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'encryptedAccountTail',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedAccountTailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedAccountTail', value: ''),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedAccountTailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'encryptedAccountTail',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedMerchantEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedMerchant',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedMerchantGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'encryptedMerchant',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedMerchantLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'encryptedMerchant',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedMerchantBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'encryptedMerchant',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedMerchantStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'encryptedMerchant',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedMerchantEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'encryptedMerchant',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedMerchantContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'encryptedMerchant',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedMerchantMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'encryptedMerchant',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedMerchantIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedMerchant', value: ''),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedMerchantIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'encryptedMerchant', value: ''),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedOriginalSmsTextEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedOriginalSmsText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedOriginalSmsTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'encryptedOriginalSmsText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedOriginalSmsTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'encryptedOriginalSmsText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedOriginalSmsTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'encryptedOriginalSmsText',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedOriginalSmsTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'encryptedOriginalSmsText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedOriginalSmsTextEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'encryptedOriginalSmsText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedOriginalSmsTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'encryptedOriginalSmsText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedOriginalSmsTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'encryptedOriginalSmsText',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedOriginalSmsTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedOriginalSmsText',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  encryptedOriginalSmsTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'encryptedOriginalSmsText',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  isManualEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isManual', value: value),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  isRecurringEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isRecurring', value: value),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  smsFingerprintIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'smsFingerprint'),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  smsFingerprintIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'smsFingerprint'),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  smsFingerprintEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'smsFingerprint',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  smsFingerprintGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'smsFingerprint',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  smsFingerprintLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'smsFingerprint',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  smsFingerprintBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'smsFingerprint',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  smsFingerprintStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'smsFingerprint',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  smsFingerprintEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'smsFingerprint',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  smsFingerprintContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'smsFingerprint',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  smsFingerprintMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'smsFingerprint',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  smsFingerprintIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'smsFingerprint', value: ''),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  smsFingerprintIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'smsFingerprint', value: ''),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  statusEqualTo(TransactionStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  statusGreaterThan(TransactionStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  statusLessThan(TransactionStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  statusBetween(
    TransactionStatus lower,
    TransactionStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timestamp', value: value),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  timestampGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timestamp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  timestampLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timestamp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timestamp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  typeEqualTo(TransactionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  typeGreaterThan(TransactionType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  typeLessThan(TransactionType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterFilterCondition>
  typeBetween(
    TransactionType lower,
    TransactionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TransactionModelQueryObject
    on QueryBuilder<TransactionModel, TransactionModel, QFilterCondition> {}

extension TransactionModelQueryLinks
    on QueryBuilder<TransactionModel, TransactionModel, QFilterCondition> {}

extension TransactionModelQuerySortBy
    on QueryBuilder<TransactionModel, TransactionModel, QSortBy> {
  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByEncryptedAccountTail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedAccountTail', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByEncryptedAccountTailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedAccountTail', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByEncryptedMerchant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedMerchant', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByEncryptedMerchantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedMerchant', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByEncryptedOriginalSmsText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedOriginalSmsText', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByEncryptedOriginalSmsTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedOriginalSmsText', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByIsManual() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManual', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByIsManualDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManual', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByIsRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortBySmsFingerprint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smsFingerprint', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortBySmsFingerprintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smsFingerprint', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension TransactionModelQuerySortThenBy
    on QueryBuilder<TransactionModel, TransactionModel, QSortThenBy> {
  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByEncryptedAccountTail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedAccountTail', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByEncryptedAccountTailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedAccountTail', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByEncryptedMerchant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedMerchant', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByEncryptedMerchantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedMerchant', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByEncryptedOriginalSmsText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedOriginalSmsText', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByEncryptedOriginalSmsTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedOriginalSmsText', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByIsManual() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManual', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByIsManualDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManual', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByIsRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenBySmsFingerprint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smsFingerprint', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenBySmsFingerprintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smsFingerprint', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QAfterSortBy>
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension TransactionModelQueryWhereDistinct
    on QueryBuilder<TransactionModel, TransactionModel, QDistinct> {
  QueryBuilder<TransactionModel, TransactionModel, QDistinct>
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QDistinct>
  distinctByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId');
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QDistinct>
  distinctByEncryptedAccountTail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedAccountTail',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QDistinct>
  distinctByEncryptedMerchant({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedMerchant',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QDistinct>
  distinctByEncryptedOriginalSmsText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedOriginalSmsText',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QDistinct>
  distinctByIsManual() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isManual');
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QDistinct>
  distinctByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRecurring');
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QDistinct>
  distinctBySmsFingerprint({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'smsFingerprint',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QDistinct>
  distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QDistinct>
  distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<TransactionModel, TransactionModel, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension TransactionModelQueryProperty
    on QueryBuilder<TransactionModel, TransactionModel, QQueryProperty> {
  QueryBuilder<TransactionModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TransactionModel, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<TransactionModel, int?, QQueryOperations> categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<TransactionModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TransactionModel, String, QQueryOperations>
  encryptedAccountTailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedAccountTail');
    });
  }

  QueryBuilder<TransactionModel, String, QQueryOperations>
  encryptedMerchantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedMerchant');
    });
  }

  QueryBuilder<TransactionModel, String, QQueryOperations>
  encryptedOriginalSmsTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedOriginalSmsText');
    });
  }

  QueryBuilder<TransactionModel, bool, QQueryOperations> isManualProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isManual');
    });
  }

  QueryBuilder<TransactionModel, bool, QQueryOperations> isRecurringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRecurring');
    });
  }

  QueryBuilder<TransactionModel, String?, QQueryOperations>
  smsFingerprintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'smsFingerprint');
    });
  }

  QueryBuilder<TransactionModel, TransactionStatus, QQueryOperations>
  statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<TransactionModel, DateTime, QQueryOperations>
  timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<TransactionModel, TransactionType, QQueryOperations>
  typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
