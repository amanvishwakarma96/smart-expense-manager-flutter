// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_challenge_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeeklyChallengeModelCollection on Isar {
  IsarCollection<WeeklyChallengeModel> get weeklyChallengeModels =>
      this.collection();
}

const WeeklyChallengeModelSchema = CollectionSchema(
  name: r'WeeklyChallengeModel',
  id: -9071225573265040680,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'finalizedAt': PropertySchema(
      id: 1,
      name: r'finalizedAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 2,
      name: r'status',
      type: IsarType.byte,
      enumMap: _WeeklyChallengeModelstatusEnumValueMap,
    ),
    r'targetAmount': PropertySchema(
      id: 3,
      name: r'targetAmount',
      type: IsarType.double,
    ),
    r'targetDays': PropertySchema(
      id: 4,
      name: r'targetDays',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.byte,
      enumMap: _WeeklyChallengeModeltypeEnumValueMap,
    ),
    r'weekStart': PropertySchema(
      id: 6,
      name: r'weekStart',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _weeklyChallengeModelEstimateSize,
  serialize: _weeklyChallengeModelSerialize,
  deserialize: _weeklyChallengeModelDeserialize,
  deserializeProp: _weeklyChallengeModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _weeklyChallengeModelGetId,
  getLinks: _weeklyChallengeModelGetLinks,
  attach: _weeklyChallengeModelAttach,
  version: '3.3.2',
);

int _weeklyChallengeModelEstimateSize(
  WeeklyChallengeModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _weeklyChallengeModelSerialize(
  WeeklyChallengeModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.finalizedAt);
  writer.writeByte(offsets[2], object.status.index);
  writer.writeDouble(offsets[3], object.targetAmount);
  writer.writeLong(offsets[4], object.targetDays);
  writer.writeByte(offsets[5], object.type.index);
  writer.writeDateTime(offsets[6], object.weekStart);
}

WeeklyChallengeModel _weeklyChallengeModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeeklyChallengeModel(
    finalizedAt: reader.readDateTimeOrNull(offsets[1]),
    id: id,
    status:
        _WeeklyChallengeModelstatusValueEnumMap[reader.readByteOrNull(
          offsets[2],
        )] ??
        WeeklyChallengeStatus.active,
    targetAmount: reader.readDoubleOrNull(offsets[3]) ?? 0,
    targetDays: reader.readLongOrNull(offsets[4]) ?? 0,
    type:
        _WeeklyChallengeModeltypeValueEnumMap[reader.readByteOrNull(
          offsets[5],
        )] ??
        WeeklyChallengeType.spendingCap,
    weekStart: reader.readDateTime(offsets[6]),
  );
  object.createdAt = reader.readDateTime(offsets[0]);
  return object;
}

P _weeklyChallengeModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (_WeeklyChallengeModelstatusValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              WeeklyChallengeStatus.active)
          as P;
    case 3:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (_WeeklyChallengeModeltypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              WeeklyChallengeType.spendingCap)
          as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _WeeklyChallengeModelstatusEnumValueMap = {
  'active': 0,
  'won': 1,
  'missed': 2,
};
const _WeeklyChallengeModelstatusValueEnumMap = {
  0: WeeklyChallengeStatus.active,
  1: WeeklyChallengeStatus.won,
  2: WeeklyChallengeStatus.missed,
};
const _WeeklyChallengeModeltypeEnumValueMap = {
  'spendingCap': 0,
  'noSpendDays': 1,
};
const _WeeklyChallengeModeltypeValueEnumMap = {
  0: WeeklyChallengeType.spendingCap,
  1: WeeklyChallengeType.noSpendDays,
};

Id _weeklyChallengeModelGetId(WeeklyChallengeModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weeklyChallengeModelGetLinks(
  WeeklyChallengeModel object,
) {
  return [];
}

void _weeklyChallengeModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  WeeklyChallengeModel object,
) {
  object.id = id;
}

extension WeeklyChallengeModelQueryWhereSort
    on QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QWhere> {
  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WeeklyChallengeModelQueryWhere
    on QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QWhereClause> {
  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterWhereClause>
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

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterWhereClause>
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

extension WeeklyChallengeModelQueryFilter
    on
        QueryBuilder<
          WeeklyChallengeModel,
          WeeklyChallengeModel,
          QFilterCondition
        > {
  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
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
    WeeklyChallengeModel,
    WeeklyChallengeModel,
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
    WeeklyChallengeModel,
    WeeklyChallengeModel,
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
    WeeklyChallengeModel,
    WeeklyChallengeModel,
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
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  finalizedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'finalizedAt'),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  finalizedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'finalizedAt'),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  finalizedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'finalizedAt', value: value),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  finalizedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'finalizedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  finalizedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'finalizedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  finalizedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'finalizedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
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
    WeeklyChallengeModel,
    WeeklyChallengeModel,
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
    WeeklyChallengeModel,
    WeeklyChallengeModel,
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
    WeeklyChallengeModel,
    WeeklyChallengeModel,
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
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  statusEqualTo(WeeklyChallengeStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  statusGreaterThan(WeeklyChallengeStatus value, {bool include = false}) {
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

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  statusLessThan(WeeklyChallengeStatus value, {bool include = false}) {
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

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  statusBetween(
    WeeklyChallengeStatus lower,
    WeeklyChallengeStatus upper, {
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

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  targetAmountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'targetAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  targetAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  targetAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  targetAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetAmount',
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
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  targetDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetDays', value: value),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  targetDaysGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  targetDaysLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  targetDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetDays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  typeEqualTo(WeeklyChallengeType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  typeGreaterThan(WeeklyChallengeType value, {bool include = false}) {
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
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  typeLessThan(WeeklyChallengeType value, {bool include = false}) {
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
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  typeBetween(
    WeeklyChallengeType lower,
    WeeklyChallengeType upper, {
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

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  weekStartEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'weekStart', value: value),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  weekStartGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weekStart',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  weekStartLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weekStart',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WeeklyChallengeModel,
    WeeklyChallengeModel,
    QAfterFilterCondition
  >
  weekStartBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weekStart',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension WeeklyChallengeModelQueryObject
    on
        QueryBuilder<
          WeeklyChallengeModel,
          WeeklyChallengeModel,
          QFilterCondition
        > {}

extension WeeklyChallengeModelQueryLinks
    on
        QueryBuilder<
          WeeklyChallengeModel,
          WeeklyChallengeModel,
          QFilterCondition
        > {}

extension WeeklyChallengeModelQuerySortBy
    on QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QSortBy> {
  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByFinalizedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalizedAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByFinalizedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalizedAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByTargetAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetAmount', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByTargetAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetAmount', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByTargetDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDays', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByTargetDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDays', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByWeekStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStart', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  sortByWeekStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStart', Sort.desc);
    });
  }
}

extension WeeklyChallengeModelQuerySortThenBy
    on QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QSortThenBy> {
  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByFinalizedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalizedAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByFinalizedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalizedAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByTargetAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetAmount', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByTargetAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetAmount', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByTargetDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDays', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByTargetDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDays', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByWeekStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStart', Sort.asc);
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QAfterSortBy>
  thenByWeekStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStart', Sort.desc);
    });
  }
}

extension WeeklyChallengeModelQueryWhereDistinct
    on QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QDistinct> {
  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QDistinct>
  distinctByFinalizedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalizedAt');
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QDistinct>
  distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QDistinct>
  distinctByTargetAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetAmount');
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QDistinct>
  distinctByTargetDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetDays');
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QDistinct>
  distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeModel, QDistinct>
  distinctByWeekStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekStart');
    });
  }
}

extension WeeklyChallengeModelQueryProperty
    on
        QueryBuilder<
          WeeklyChallengeModel,
          WeeklyChallengeModel,
          QQueryProperty
        > {
  QueryBuilder<WeeklyChallengeModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeeklyChallengeModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<WeeklyChallengeModel, DateTime?, QQueryOperations>
  finalizedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalizedAt');
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeStatus, QQueryOperations>
  statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<WeeklyChallengeModel, double, QQueryOperations>
  targetAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetAmount');
    });
  }

  QueryBuilder<WeeklyChallengeModel, int, QQueryOperations>
  targetDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetDays');
    });
  }

  QueryBuilder<WeeklyChallengeModel, WeeklyChallengeType, QQueryOperations>
  typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<WeeklyChallengeModel, DateTime, QQueryOperations>
  weekStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekStart');
    });
  }
}
