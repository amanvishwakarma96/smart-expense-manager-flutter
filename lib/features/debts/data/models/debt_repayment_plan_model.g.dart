// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_repayment_plan_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDebtRepaymentPlanModelCollection on Isar {
  IsarCollection<DebtRepaymentPlanModel> get debtRepaymentPlanModels =>
      this.collection();
}

const DebtRepaymentPlanModelSchema = CollectionSchema(
  name: r'DebtRepaymentPlanModel',
  id: -8198535692269344508,
  properties: {
    r'annualInterestRatePct': PropertySchema(
      id: 0,
      name: r'annualInterestRatePct',
      type: IsarType.double,
    ),
    r'baselineRepaidAmount': PropertySchema(
      id: 1,
      name: r'baselineRepaidAmount',
      type: IsarType.double,
    ),
    r'cadence': PropertySchema(
      id: 2,
      name: r'cadence',
      type: IsarType.byte,
      enumMap: _DebtRepaymentPlanModelcadenceEnumValueMap,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'debtId': PropertySchema(id: 4, name: r'debtId', type: IsarType.long),
    r'firstDueDate': PropertySchema(
      id: 5,
      name: r'firstDueDate',
      type: IsarType.dateTime,
    ),
    r'installmentAmount': PropertySchema(
      id: 6,
      name: r'installmentAmount',
      type: IsarType.double,
    ),
    r'isPaused': PropertySchema(id: 7, name: r'isPaused', type: IsarType.bool),
    r'startingOutstanding': PropertySchema(
      id: 8,
      name: r'startingOutstanding',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _debtRepaymentPlanModelEstimateSize,
  serialize: _debtRepaymentPlanModelSerialize,
  deserialize: _debtRepaymentPlanModelDeserialize,
  deserializeProp: _debtRepaymentPlanModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'debtId': IndexSchema(
      id: 7945793207552902711,
      name: r'debtId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'debtId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _debtRepaymentPlanModelGetId,
  getLinks: _debtRepaymentPlanModelGetLinks,
  attach: _debtRepaymentPlanModelAttach,
  version: '3.3.2',
);

int _debtRepaymentPlanModelEstimateSize(
  DebtRepaymentPlanModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _debtRepaymentPlanModelSerialize(
  DebtRepaymentPlanModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.annualInterestRatePct);
  writer.writeDouble(offsets[1], object.baselineRepaidAmount);
  writer.writeByte(offsets[2], object.cadence.index);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeLong(offsets[4], object.debtId);
  writer.writeDateTime(offsets[5], object.firstDueDate);
  writer.writeDouble(offsets[6], object.installmentAmount);
  writer.writeBool(offsets[7], object.isPaused);
  writer.writeDouble(offsets[8], object.startingOutstanding);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

DebtRepaymentPlanModel _debtRepaymentPlanModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DebtRepaymentPlanModel(
    annualInterestRatePct: reader.readDoubleOrNull(offsets[0]) ?? 0,
    baselineRepaidAmount: reader.readDoubleOrNull(offsets[1]) ?? 0,
    cadence:
        _DebtRepaymentPlanModelcadenceValueEnumMap[reader.readByteOrNull(
          offsets[2],
        )] ??
        RepaymentCadence.monthly,
    debtId: reader.readLongOrNull(offsets[4]) ?? 0,
    firstDueDate: reader.readDateTime(offsets[5]),
    id: id,
    installmentAmount: reader.readDoubleOrNull(offsets[6]) ?? 0,
    isPaused: reader.readBoolOrNull(offsets[7]) ?? false,
    startingOutstanding: reader.readDoubleOrNull(offsets[8]) ?? 0,
  );
  object.createdAt = reader.readDateTime(offsets[3]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  return object;
}

P _debtRepaymentPlanModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 2:
      return (_DebtRepaymentPlanModelcadenceValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              RepaymentCadence.monthly)
          as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 8:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DebtRepaymentPlanModelcadenceEnumValueMap = {'weekly': 0, 'monthly': 1};
const _DebtRepaymentPlanModelcadenceValueEnumMap = {
  0: RepaymentCadence.weekly,
  1: RepaymentCadence.monthly,
};

Id _debtRepaymentPlanModelGetId(DebtRepaymentPlanModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _debtRepaymentPlanModelGetLinks(
  DebtRepaymentPlanModel object,
) {
  return [];
}

void _debtRepaymentPlanModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  DebtRepaymentPlanModel object,
) {
  object.id = id;
}

extension DebtRepaymentPlanModelByIndex
    on IsarCollection<DebtRepaymentPlanModel> {
  Future<DebtRepaymentPlanModel?> getByDebtId(int debtId) {
    return getByIndex(r'debtId', [debtId]);
  }

  DebtRepaymentPlanModel? getByDebtIdSync(int debtId) {
    return getByIndexSync(r'debtId', [debtId]);
  }

  Future<bool> deleteByDebtId(int debtId) {
    return deleteByIndex(r'debtId', [debtId]);
  }

  bool deleteByDebtIdSync(int debtId) {
    return deleteByIndexSync(r'debtId', [debtId]);
  }

  Future<List<DebtRepaymentPlanModel?>> getAllByDebtId(List<int> debtIdValues) {
    final values = debtIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'debtId', values);
  }

  List<DebtRepaymentPlanModel?> getAllByDebtIdSync(List<int> debtIdValues) {
    final values = debtIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'debtId', values);
  }

  Future<int> deleteAllByDebtId(List<int> debtIdValues) {
    final values = debtIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'debtId', values);
  }

  int deleteAllByDebtIdSync(List<int> debtIdValues) {
    final values = debtIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'debtId', values);
  }

  Future<Id> putByDebtId(DebtRepaymentPlanModel object) {
    return putByIndex(r'debtId', object);
  }

  Id putByDebtIdSync(DebtRepaymentPlanModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'debtId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDebtId(List<DebtRepaymentPlanModel> objects) {
    return putAllByIndex(r'debtId', objects);
  }

  List<Id> putAllByDebtIdSync(
    List<DebtRepaymentPlanModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'debtId', objects, saveLinks: saveLinks);
  }
}

extension DebtRepaymentPlanModelQueryWhereSort
    on QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QWhere> {
  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterWhere>
  anyDebtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'debtId'),
      );
    });
  }
}

extension DebtRepaymentPlanModelQueryWhere
    on
        QueryBuilder<
          DebtRepaymentPlanModel,
          DebtRepaymentPlanModel,
          QWhereClause
        > {
  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
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

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterWhereClause
  >
  debtIdEqualTo(int debtId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'debtId', value: [debtId]),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterWhereClause
  >
  debtIdNotEqualTo(int debtId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'debtId',
                lower: [],
                upper: [debtId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'debtId',
                lower: [debtId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'debtId',
                lower: [debtId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'debtId',
                lower: [],
                upper: [debtId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterWhereClause
  >
  debtIdGreaterThan(int debtId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'debtId',
          lower: [debtId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterWhereClause
  >
  debtIdLessThan(int debtId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'debtId',
          lower: [],
          upper: [debtId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterWhereClause
  >
  debtIdBetween(
    int lowerDebtId,
    int upperDebtId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'debtId',
          lower: [lowerDebtId],
          includeLower: includeLower,
          upper: [upperDebtId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DebtRepaymentPlanModelQueryFilter
    on
        QueryBuilder<
          DebtRepaymentPlanModel,
          DebtRepaymentPlanModel,
          QFilterCondition
        > {
  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  annualInterestRatePctEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'annualInterestRatePct',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  annualInterestRatePctGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'annualInterestRatePct',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  annualInterestRatePctLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'annualInterestRatePct',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  annualInterestRatePctBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'annualInterestRatePct',
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  baselineRepaidAmountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'baselineRepaidAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  baselineRepaidAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'baselineRepaidAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  baselineRepaidAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'baselineRepaidAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  baselineRepaidAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'baselineRepaidAmount',
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  cadenceEqualTo(RepaymentCadence value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cadence', value: value),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  cadenceGreaterThan(RepaymentCadence value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cadence',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  cadenceLessThan(RepaymentCadence value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cadence',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  cadenceBetween(
    RepaymentCadence lower,
    RepaymentCadence upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cadence',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  debtIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'debtId', value: value),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  debtIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'debtId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  debtIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'debtId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  debtIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'debtId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  firstDueDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'firstDueDate', value: value),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  firstDueDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'firstDueDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  firstDueDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'firstDueDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  firstDueDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'firstDueDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  installmentAmountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'installmentAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  installmentAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'installmentAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  installmentAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'installmentAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  installmentAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'installmentAmount',
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  isPausedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isPaused', value: value),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  startingOutstandingEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'startingOutstanding',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  startingOutstandingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startingOutstanding',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  startingOutstandingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startingOutstanding',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  startingOutstandingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startingOutstanding',
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
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DebtRepaymentPlanModel,
    DebtRepaymentPlanModel,
    QAfterFilterCondition
  >
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DebtRepaymentPlanModelQueryObject
    on
        QueryBuilder<
          DebtRepaymentPlanModel,
          DebtRepaymentPlanModel,
          QFilterCondition
        > {}

extension DebtRepaymentPlanModelQueryLinks
    on
        QueryBuilder<
          DebtRepaymentPlanModel,
          DebtRepaymentPlanModel,
          QFilterCondition
        > {}

extension DebtRepaymentPlanModelQuerySortBy
    on QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QSortBy> {
  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByAnnualInterestRatePct() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'annualInterestRatePct', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByAnnualInterestRatePctDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'annualInterestRatePct', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByBaselineRepaidAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baselineRepaidAmount', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByBaselineRepaidAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baselineRepaidAmount', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByCadence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cadence', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByCadenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cadence', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByDebtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtId', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByDebtIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtId', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByFirstDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDueDate', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByFirstDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDueDate', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByInstallmentAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installmentAmount', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByInstallmentAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installmentAmount', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByIsPaused() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByIsPausedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByStartingOutstanding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingOutstanding', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByStartingOutstandingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingOutstanding', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DebtRepaymentPlanModelQuerySortThenBy
    on
        QueryBuilder<
          DebtRepaymentPlanModel,
          DebtRepaymentPlanModel,
          QSortThenBy
        > {
  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByAnnualInterestRatePct() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'annualInterestRatePct', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByAnnualInterestRatePctDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'annualInterestRatePct', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByBaselineRepaidAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baselineRepaidAmount', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByBaselineRepaidAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baselineRepaidAmount', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByCadence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cadence', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByCadenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cadence', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByDebtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtId', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByDebtIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtId', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByFirstDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDueDate', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByFirstDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDueDate', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByInstallmentAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installmentAmount', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByInstallmentAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installmentAmount', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByIsPaused() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByIsPausedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByStartingOutstanding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingOutstanding', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByStartingOutstandingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingOutstanding', Sort.desc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DebtRepaymentPlanModelQueryWhereDistinct
    on QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QDistinct> {
  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QDistinct>
  distinctByAnnualInterestRatePct() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'annualInterestRatePct');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QDistinct>
  distinctByBaselineRepaidAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baselineRepaidAmount');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QDistinct>
  distinctByCadence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cadence');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QDistinct>
  distinctByDebtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'debtId');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QDistinct>
  distinctByFirstDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstDueDate');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QDistinct>
  distinctByInstallmentAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'installmentAmount');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QDistinct>
  distinctByIsPaused() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPaused');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QDistinct>
  distinctByStartingOutstanding() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startingOutstanding');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DebtRepaymentPlanModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DebtRepaymentPlanModelQueryProperty
    on
        QueryBuilder<
          DebtRepaymentPlanModel,
          DebtRepaymentPlanModel,
          QQueryProperty
        > {
  QueryBuilder<DebtRepaymentPlanModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, double, QQueryOperations>
  annualInterestRatePctProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'annualInterestRatePct');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, double, QQueryOperations>
  baselineRepaidAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baselineRepaidAmount');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, RepaymentCadence, QQueryOperations>
  cadenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cadence');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, int, QQueryOperations> debtIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'debtId');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DateTime, QQueryOperations>
  firstDueDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstDueDate');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, double, QQueryOperations>
  installmentAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'installmentAmount');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, bool, QQueryOperations>
  isPausedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPaused');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, double, QQueryOperations>
  startingOutstandingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startingOutstanding');
    });
  }

  QueryBuilder<DebtRepaymentPlanModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
