// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_ledger_entry_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDebtLedgerEntryModelCollection on Isar {
  IsarCollection<DebtLedgerEntryModel> get debtLedgerEntryModels =>
      this.collection();
}

const DebtLedgerEntryModelSchema = CollectionSchema(
  name: r'DebtLedgerEntryModel',
  id: 2962809462198196443,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.double),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'debtId': PropertySchema(id: 2, name: r'debtId', type: IsarType.long),
    r'encryptedNote': PropertySchema(
      id: 3,
      name: r'encryptedNote',
      type: IsarType.string,
    ),
    r'linkedTransactionId': PropertySchema(
      id: 4,
      name: r'linkedTransactionId',
      type: IsarType.long,
    ),
    r'occurredAt': PropertySchema(
      id: 5,
      name: r'occurredAt',
      type: IsarType.dateTime,
    ),
    r'type': PropertySchema(
      id: 6,
      name: r'type',
      type: IsarType.byte,
      enumMap: _DebtLedgerEntryModeltypeEnumValueMap,
    ),
  },

  estimateSize: _debtLedgerEntryModelEstimateSize,
  serialize: _debtLedgerEntryModelSerialize,
  deserialize: _debtLedgerEntryModelDeserialize,
  deserializeProp: _debtLedgerEntryModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'debtId': IndexSchema(
      id: 7945793207552902711,
      name: r'debtId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'debtId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'linkedTransactionId': IndexSchema(
      id: 634670711283887622,
      name: r'linkedTransactionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'linkedTransactionId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _debtLedgerEntryModelGetId,
  getLinks: _debtLedgerEntryModelGetLinks,
  attach: _debtLedgerEntryModelAttach,
  version: '3.3.2',
);

int _debtLedgerEntryModelEstimateSize(
  DebtLedgerEntryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.encryptedNote.length * 3;
  return bytesCount;
}

void _debtLedgerEntryModelSerialize(
  DebtLedgerEntryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.debtId);
  writer.writeString(offsets[3], object.encryptedNote);
  writer.writeLong(offsets[4], object.linkedTransactionId);
  writer.writeDateTime(offsets[5], object.occurredAt);
  writer.writeByte(offsets[6], object.type.index);
}

DebtLedgerEntryModel _debtLedgerEntryModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DebtLedgerEntryModel(
    amount: reader.readDoubleOrNull(offsets[0]) ?? 0,
    debtId: reader.readLongOrNull(offsets[2]) ?? 0,
    encryptedNote: reader.readStringOrNull(offsets[3]) ?? '',
    id: id,
    linkedTransactionId: reader.readLongOrNull(offsets[4]),
    occurredAt: reader.readDateTime(offsets[5]),
    type:
        _DebtLedgerEntryModeltypeValueEnumMap[reader.readByteOrNull(
          offsets[6],
        )] ??
        DebtMovementType.decrease,
  );
  object.createdAt = reader.readDateTime(offsets[1]);
  return object;
}

P _debtLedgerEntryModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (_DebtLedgerEntryModeltypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              DebtMovementType.decrease)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DebtLedgerEntryModeltypeEnumValueMap = {'increase': 0, 'decrease': 1};
const _DebtLedgerEntryModeltypeValueEnumMap = {
  0: DebtMovementType.increase,
  1: DebtMovementType.decrease,
};

Id _debtLedgerEntryModelGetId(DebtLedgerEntryModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _debtLedgerEntryModelGetLinks(
  DebtLedgerEntryModel object,
) {
  return [];
}

void _debtLedgerEntryModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  DebtLedgerEntryModel object,
) {
  object.id = id;
}

extension DebtLedgerEntryModelQueryWhereSort
    on QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QWhere> {
  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhere>
  anyDebtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'debtId'),
      );
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhere>
  anyLinkedTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'linkedTransactionId'),
      );
    });
  }
}

extension DebtLedgerEntryModelQueryWhere
    on QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QWhereClause> {
  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
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

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
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

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
  debtIdEqualTo(int debtId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'debtId', value: [debtId]),
      );
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
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

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
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

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
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

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
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

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
  linkedTransactionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'linkedTransactionId',
          value: [null],
        ),
      );
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
  linkedTransactionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'linkedTransactionId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
  linkedTransactionIdEqualTo(int? linkedTransactionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'linkedTransactionId',
          value: [linkedTransactionId],
        ),
      );
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
  linkedTransactionIdNotEqualTo(int? linkedTransactionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'linkedTransactionId',
                lower: [],
                upper: [linkedTransactionId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'linkedTransactionId',
                lower: [linkedTransactionId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'linkedTransactionId',
                lower: [linkedTransactionId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'linkedTransactionId',
                lower: [],
                upper: [linkedTransactionId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
  linkedTransactionIdGreaterThan(
    int? linkedTransactionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'linkedTransactionId',
          lower: [linkedTransactionId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
  linkedTransactionIdLessThan(
    int? linkedTransactionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'linkedTransactionId',
          lower: [],
          upper: [linkedTransactionId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterWhereClause>
  linkedTransactionIdBetween(
    int? lowerLinkedTransactionId,
    int? upperLinkedTransactionId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'linkedTransactionId',
          lower: [lowerLinkedTransactionId],
          includeLower: includeLower,
          upper: [upperLinkedTransactionId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DebtLedgerEntryModelQueryFilter
    on
        QueryBuilder<
          DebtLedgerEntryModel,
          DebtLedgerEntryModel,
          QFilterCondition
        > {
  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  encryptedNoteEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedNote',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  encryptedNoteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'encryptedNote',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  encryptedNoteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'encryptedNote',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  encryptedNoteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'encryptedNote',
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  encryptedNoteStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'encryptedNote',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  encryptedNoteEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'encryptedNote',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  encryptedNoteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'encryptedNote',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  encryptedNoteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'encryptedNote',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  encryptedNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedNote', value: ''),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  encryptedNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'encryptedNote', value: ''),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  linkedTransactionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'linkedTransactionId'),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  linkedTransactionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'linkedTransactionId'),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  linkedTransactionIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'linkedTransactionId', value: value),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  linkedTransactionIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'linkedTransactionId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  linkedTransactionIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'linkedTransactionId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  linkedTransactionIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'linkedTransactionId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  occurredAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'occurredAt', value: value),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  occurredAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'occurredAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  occurredAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'occurredAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  occurredAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'occurredAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  typeEqualTo(DebtMovementType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  typeGreaterThan(DebtMovementType value, {bool include = false}) {
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  typeLessThan(DebtMovementType value, {bool include = false}) {
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
    DebtLedgerEntryModel,
    DebtLedgerEntryModel,
    QAfterFilterCondition
  >
  typeBetween(
    DebtMovementType lower,
    DebtMovementType upper, {
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

extension DebtLedgerEntryModelQueryObject
    on
        QueryBuilder<
          DebtLedgerEntryModel,
          DebtLedgerEntryModel,
          QFilterCondition
        > {}

extension DebtLedgerEntryModelQueryLinks
    on
        QueryBuilder<
          DebtLedgerEntryModel,
          DebtLedgerEntryModel,
          QFilterCondition
        > {}

extension DebtLedgerEntryModelQuerySortBy
    on QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QSortBy> {
  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByDebtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtId', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByDebtIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtId', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByEncryptedNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedNote', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByEncryptedNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedNote', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByLinkedTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTransactionId', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByLinkedTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTransactionId', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByOccurredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension DebtLedgerEntryModelQuerySortThenBy
    on QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QSortThenBy> {
  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByDebtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtId', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByDebtIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtId', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByEncryptedNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedNote', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByEncryptedNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedNote', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByLinkedTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTransactionId', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByLinkedTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTransactionId', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByOccurredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.desc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QAfterSortBy>
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension DebtLedgerEntryModelQueryWhereDistinct
    on QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QDistinct> {
  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QDistinct>
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QDistinct>
  distinctByDebtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'debtId');
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QDistinct>
  distinctByEncryptedNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedNote',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QDistinct>
  distinctByLinkedTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linkedTransactionId');
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QDistinct>
  distinctByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'occurredAt');
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtLedgerEntryModel, QDistinct>
  distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension DebtLedgerEntryModelQueryProperty
    on
        QueryBuilder<
          DebtLedgerEntryModel,
          DebtLedgerEntryModel,
          QQueryProperty
        > {
  QueryBuilder<DebtLedgerEntryModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DebtLedgerEntryModel, double, QQueryOperations>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DebtLedgerEntryModel, int, QQueryOperations> debtIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'debtId');
    });
  }

  QueryBuilder<DebtLedgerEntryModel, String, QQueryOperations>
  encryptedNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedNote');
    });
  }

  QueryBuilder<DebtLedgerEntryModel, int?, QQueryOperations>
  linkedTransactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedTransactionId');
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DateTime, QQueryOperations>
  occurredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occurredAt');
    });
  }

  QueryBuilder<DebtLedgerEntryModel, DebtMovementType, QQueryOperations>
  typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
