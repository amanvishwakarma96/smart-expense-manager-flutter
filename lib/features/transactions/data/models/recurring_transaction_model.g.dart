// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecurringTransactionModelCollection on Isar {
  IsarCollection<RecurringTransactionModel> get recurringTransactionModels =>
      this.collection();
}

const RecurringTransactionModelSchema = CollectionSchema(
  name: r'RecurringTransactionModel',
  id: 6130514885703977993,
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
    r'encryptedMerchant': PropertySchema(
      id: 3,
      name: r'encryptedMerchant',
      type: IsarType.string,
    ),
    r'frequency': PropertySchema(
      id: 4,
      name: r'frequency',
      type: IsarType.byte,
      enumMap: _RecurringTransactionModelfrequencyEnumValueMap,
    ),
    r'isActive': PropertySchema(id: 5, name: r'isActive', type: IsarType.bool),
    r'nextDueAt': PropertySchema(
      id: 6,
      name: r'nextDueAt',
      type: IsarType.dateTime,
    ),
    r'purposeCode': PropertySchema(
      id: 7,
      name: r'purposeCode',
      type: IsarType.string,
    ),
    r'reminderDaysBefore': PropertySchema(
      id: 8,
      name: r'reminderDaysBefore',
      type: IsarType.long,
    ),
    r'reminderEnabled': PropertySchema(
      id: 9,
      name: r'reminderEnabled',
      type: IsarType.bool,
    ),
    r'scheduleDay': PropertySchema(
      id: 10,
      name: r'scheduleDay',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 11,
      name: r'type',
      type: IsarType.byte,
      enumMap: _RecurringTransactionModeltypeEnumValueMap,
    ),
  },

  estimateSize: _recurringTransactionModelEstimateSize,
  serialize: _recurringTransactionModelSerialize,
  deserialize: _recurringTransactionModelDeserialize,
  deserializeProp: _recurringTransactionModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _recurringTransactionModelGetId,
  getLinks: _recurringTransactionModelGetLinks,
  attach: _recurringTransactionModelAttach,
  version: '3.3.2',
);

int _recurringTransactionModelEstimateSize(
  RecurringTransactionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.encryptedMerchant.length * 3;
  bytesCount += 3 + object.purposeCode.length * 3;
  return bytesCount;
}

void _recurringTransactionModelSerialize(
  RecurringTransactionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeLong(offsets[1], object.categoryId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.encryptedMerchant);
  writer.writeByte(offsets[4], object.frequency.index);
  writer.writeBool(offsets[5], object.isActive);
  writer.writeDateTime(offsets[6], object.nextDueAt);
  writer.writeString(offsets[7], object.purposeCode);
  writer.writeLong(offsets[8], object.reminderDaysBefore);
  writer.writeBool(offsets[9], object.reminderEnabled);
  writer.writeLong(offsets[10], object.scheduleDay);
  writer.writeByte(offsets[11], object.type.index);
}

RecurringTransactionModel _recurringTransactionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecurringTransactionModel(
    amount: reader.readDoubleOrNull(offsets[0]) ?? 0,
    categoryId: reader.readLongOrNull(offsets[1]),
    encryptedMerchant: reader.readStringOrNull(offsets[3]) ?? '',
    frequency:
        _RecurringTransactionModelfrequencyValueEnumMap[reader.readByteOrNull(
          offsets[4],
        )] ??
        RecurringFrequency.monthly,
    id: id,
    isActive: reader.readBoolOrNull(offsets[5]) ?? true,
    nextDueAt: reader.readDateTime(offsets[6]),
    purposeCode: reader.readStringOrNull(offsets[7]) ?? '',
    reminderDaysBefore: reader.readLongOrNull(offsets[8]) ?? 1,
    reminderEnabled: reader.readBoolOrNull(offsets[9]) ?? false,
    scheduleDay: reader.readLongOrNull(offsets[10]) ?? 1,
    type:
        _RecurringTransactionModeltypeValueEnumMap[reader.readByteOrNull(
          offsets[11],
        )] ??
        TransactionType.debit,
  );
  object.createdAt = reader.readDateTime(offsets[2]);
  return object;
}

P _recurringTransactionModelDeserializeProp<P>(
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
      return (_RecurringTransactionModelfrequencyValueEnumMap[reader
                  .readByteOrNull(offset)] ??
              RecurringFrequency.monthly)
          as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 8:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 9:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 10:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 11:
      return (_RecurringTransactionModeltypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              TransactionType.debit)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _RecurringTransactionModelfrequencyEnumValueMap = {
  'weekly': 0,
  'monthly': 1,
};
const _RecurringTransactionModelfrequencyValueEnumMap = {
  0: RecurringFrequency.weekly,
  1: RecurringFrequency.monthly,
};
const _RecurringTransactionModeltypeEnumValueMap = {'debit': 0, 'credit': 1};
const _RecurringTransactionModeltypeValueEnumMap = {
  0: TransactionType.debit,
  1: TransactionType.credit,
};

Id _recurringTransactionModelGetId(RecurringTransactionModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recurringTransactionModelGetLinks(
  RecurringTransactionModel object,
) {
  return [];
}

void _recurringTransactionModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  RecurringTransactionModel object,
) {
  object.id = id;
}

extension RecurringTransactionModelQueryWhereSort
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QWhere
        > {
  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecurringTransactionModelQueryWhere
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QWhereClause
        > {
  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterWhereClause
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterWhereClause
  >
  idBetween(
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
}

extension RecurringTransactionModelQueryFilter
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QFilterCondition
        > {
  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  categoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'categoryId'),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  categoryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'categoryId'),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  categoryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categoryId', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  encryptedMerchantIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedMerchant', value: ''),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  encryptedMerchantIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'encryptedMerchant', value: ''),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  frequencyEqualTo(RecurringFrequency value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'frequency', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  frequencyGreaterThan(RecurringFrequency value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'frequency',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  frequencyLessThan(RecurringFrequency value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'frequency',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  frequencyBetween(
    RecurringFrequency lower,
    RecurringFrequency upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'frequency',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  nextDueAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nextDueAt', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  nextDueAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nextDueAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  nextDueAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nextDueAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  nextDueAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nextDueAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  purposeCodeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'purposeCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  purposeCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'purposeCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  purposeCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'purposeCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  purposeCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'purposeCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  purposeCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'purposeCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  purposeCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'purposeCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  purposeCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'purposeCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  purposeCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'purposeCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  purposeCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'purposeCode', value: ''),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  purposeCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'purposeCode', value: ''),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  reminderDaysBeforeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reminderDaysBefore', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  reminderDaysBeforeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'reminderDaysBefore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  reminderDaysBeforeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'reminderDaysBefore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  reminderDaysBeforeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'reminderDaysBefore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  reminderEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reminderEnabled', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  scheduleDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scheduleDay', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  scheduleDayGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scheduleDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  scheduleDayLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scheduleDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  scheduleDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scheduleDay',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  typeEqualTo(TransactionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
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

extension RecurringTransactionModelQueryObject
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QFilterCondition
        > {}

extension RecurringTransactionModelQueryLinks
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QFilterCondition
        > {}

extension RecurringTransactionModelQuerySortBy
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QSortBy
        > {
  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByEncryptedMerchant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedMerchant', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByEncryptedMerchantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedMerchant', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByNextDueAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextDueAt', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByNextDueAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextDueAt', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByPurposeCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purposeCode', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByPurposeCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purposeCode', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByReminderDaysBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDaysBefore', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByReminderDaysBeforeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDaysBefore', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByScheduleDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleDay', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByScheduleDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleDay', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension RecurringTransactionModelQuerySortThenBy
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QSortThenBy
        > {
  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByEncryptedMerchant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedMerchant', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByEncryptedMerchantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedMerchant', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByNextDueAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextDueAt', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByNextDueAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextDueAt', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByPurposeCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purposeCode', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByPurposeCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purposeCode', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByReminderDaysBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDaysBefore', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByReminderDaysBeforeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDaysBefore', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByScheduleDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleDay', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByScheduleDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleDay', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension RecurringTransactionModelQueryWhereDistinct
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QDistinct
        > {
  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByEncryptedMerchant({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedMerchant',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frequency');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByNextDueAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextDueAt');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByPurposeCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purposeCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByReminderDaysBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderDaysBefore');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderEnabled');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByScheduleDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduleDay');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension RecurringTransactionModelQueryProperty
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QQueryProperty
        > {
  QueryBuilder<RecurringTransactionModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecurringTransactionModel, double, QQueryOperations>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<RecurringTransactionModel, int?, QQueryOperations>
  categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<RecurringTransactionModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<RecurringTransactionModel, String, QQueryOperations>
  encryptedMerchantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedMerchant');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringFrequency, QQueryOperations>
  frequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frequency');
    });
  }

  QueryBuilder<RecurringTransactionModel, bool, QQueryOperations>
  isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<RecurringTransactionModel, DateTime, QQueryOperations>
  nextDueAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextDueAt');
    });
  }

  QueryBuilder<RecurringTransactionModel, String, QQueryOperations>
  purposeCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purposeCode');
    });
  }

  QueryBuilder<RecurringTransactionModel, int, QQueryOperations>
  reminderDaysBeforeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderDaysBefore');
    });
  }

  QueryBuilder<RecurringTransactionModel, bool, QQueryOperations>
  reminderEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderEnabled');
    });
  }

  QueryBuilder<RecurringTransactionModel, int, QQueryOperations>
  scheduleDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduleDay');
    });
  }

  QueryBuilder<RecurringTransactionModel, TransactionType, QQueryOperations>
  typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
