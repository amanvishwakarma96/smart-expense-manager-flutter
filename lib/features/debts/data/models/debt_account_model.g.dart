// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_account_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDebtAccountModelCollection on Isar {
  IsarCollection<DebtAccountModel> get debtAccountModels => this.collection();
}

const DebtAccountModelSchema = CollectionSchema(
  name: r'DebtAccountModel',
  id: -3967422619721196354,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dueDate': PropertySchema(
      id: 1,
      name: r'dueDate',
      type: IsarType.dateTime,
    ),
    r'encryptedCounterparty': PropertySchema(
      id: 2,
      name: r'encryptedCounterparty',
      type: IsarType.string,
    ),
    r'encryptedNote': PropertySchema(
      id: 3,
      name: r'encryptedNote',
      type: IsarType.string,
    ),
    r'isArchived': PropertySchema(
      id: 4,
      name: r'isArchived',
      type: IsarType.bool,
    ),
    r'kind': PropertySchema(
      id: 5,
      name: r'kind',
      type: IsarType.byte,
      enumMap: _DebtAccountModelkindEnumValueMap,
    ),
    r'openingBalance': PropertySchema(
      id: 6,
      name: r'openingBalance',
      type: IsarType.double,
    ),
    r'reminderDaysBefore': PropertySchema(
      id: 7,
      name: r'reminderDaysBefore',
      type: IsarType.long,
    ),
    r'reminderEnabled': PropertySchema(
      id: 8,
      name: r'reminderEnabled',
      type: IsarType.bool,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _debtAccountModelEstimateSize,
  serialize: _debtAccountModelSerialize,
  deserialize: _debtAccountModelDeserialize,
  deserializeProp: _debtAccountModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _debtAccountModelGetId,
  getLinks: _debtAccountModelGetLinks,
  attach: _debtAccountModelAttach,
  version: '3.3.2',
);

int _debtAccountModelEstimateSize(
  DebtAccountModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.encryptedCounterparty.length * 3;
  bytesCount += 3 + object.encryptedNote.length * 3;
  return bytesCount;
}

void _debtAccountModelSerialize(
  DebtAccountModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.dueDate);
  writer.writeString(offsets[2], object.encryptedCounterparty);
  writer.writeString(offsets[3], object.encryptedNote);
  writer.writeBool(offsets[4], object.isArchived);
  writer.writeByte(offsets[5], object.kind.index);
  writer.writeDouble(offsets[6], object.openingBalance);
  writer.writeLong(offsets[7], object.reminderDaysBefore);
  writer.writeBool(offsets[8], object.reminderEnabled);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

DebtAccountModel _debtAccountModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DebtAccountModel(
    dueDate: reader.readDateTimeOrNull(offsets[1]),
    encryptedCounterparty: reader.readStringOrNull(offsets[2]) ?? '',
    encryptedNote: reader.readStringOrNull(offsets[3]) ?? '',
    id: id,
    isArchived: reader.readBoolOrNull(offsets[4]) ?? false,
    kind:
        _DebtAccountModelkindValueEnumMap[reader.readByteOrNull(offsets[5])] ??
        DebtKind.borrowed,
    openingBalance: reader.readDoubleOrNull(offsets[6]) ?? 0,
    reminderDaysBefore: reader.readLongOrNull(offsets[7]) ?? 1,
    reminderEnabled: reader.readBoolOrNull(offsets[8]) ?? false,
  );
  object.createdAt = reader.readDateTime(offsets[0]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  return object;
}

P _debtAccountModelDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (_DebtAccountModelkindValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              DebtKind.borrowed)
          as P;
    case 6:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 7:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 8:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DebtAccountModelkindEnumValueMap = {'borrowed': 0, 'lent': 1, 'loan': 2};
const _DebtAccountModelkindValueEnumMap = {
  0: DebtKind.borrowed,
  1: DebtKind.lent,
  2: DebtKind.loan,
};

Id _debtAccountModelGetId(DebtAccountModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _debtAccountModelGetLinks(DebtAccountModel object) {
  return [];
}

void _debtAccountModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  DebtAccountModel object,
) {
  object.id = id;
}

extension DebtAccountModelQueryWhereSort
    on QueryBuilder<DebtAccountModel, DebtAccountModel, QWhere> {
  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DebtAccountModelQueryWhere
    on QueryBuilder<DebtAccountModel, DebtAccountModel, QWhereClause> {
  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterWhereClause>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterWhereClause> idBetween(
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

extension DebtAccountModelQueryFilter
    on QueryBuilder<DebtAccountModel, DebtAccountModel, QFilterCondition> {
  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  dueDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dueDate'),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  dueDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dueDate'),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  dueDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dueDate', value: value),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  dueDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dueDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  dueDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dueDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  dueDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dueDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  encryptedCounterpartyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedCounterparty',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  encryptedCounterpartyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'encryptedCounterparty',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  encryptedCounterpartyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'encryptedCounterparty',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  encryptedCounterpartyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'encryptedCounterparty',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  encryptedCounterpartyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'encryptedCounterparty',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  encryptedCounterpartyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'encryptedCounterparty',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  encryptedCounterpartyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'encryptedCounterparty',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  encryptedCounterpartyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'encryptedCounterparty',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  encryptedCounterpartyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedCounterparty', value: ''),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  encryptedCounterpartyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'encryptedCounterparty',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  encryptedNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedNote', value: ''),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  encryptedNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'encryptedNote', value: ''),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  isArchivedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isArchived', value: value),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  kindEqualTo(DebtKind value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'kind', value: value),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  kindGreaterThan(DebtKind value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'kind',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  kindLessThan(DebtKind value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'kind',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  kindBetween(
    DebtKind lower,
    DebtKind upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'kind',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  openingBalanceEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'openingBalance',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  openingBalanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'openingBalance',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  openingBalanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'openingBalance',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  openingBalanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'openingBalance',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  reminderDaysBeforeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reminderDaysBefore', value: value),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  reminderEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reminderEnabled', value: value),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterFilterCondition>
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

extension DebtAccountModelQueryObject
    on QueryBuilder<DebtAccountModel, DebtAccountModel, QFilterCondition> {}

extension DebtAccountModelQueryLinks
    on QueryBuilder<DebtAccountModel, DebtAccountModel, QFilterCondition> {}

extension DebtAccountModelQuerySortBy
    on QueryBuilder<DebtAccountModel, DebtAccountModel, QSortBy> {
  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByEncryptedCounterparty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedCounterparty', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByEncryptedCounterpartyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedCounterparty', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByEncryptedNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedNote', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByEncryptedNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedNote', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy> sortByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByOpeningBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingBalance', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByOpeningBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingBalance', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByReminderDaysBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDaysBefore', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByReminderDaysBeforeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDaysBefore', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DebtAccountModelQuerySortThenBy
    on QueryBuilder<DebtAccountModel, DebtAccountModel, QSortThenBy> {
  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByEncryptedCounterparty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedCounterparty', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByEncryptedCounterpartyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedCounterparty', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByEncryptedNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedNote', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByEncryptedNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedNote', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy> thenByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByOpeningBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingBalance', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByOpeningBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingBalance', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByReminderDaysBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDaysBefore', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByReminderDaysBeforeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDaysBefore', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DebtAccountModelQueryWhereDistinct
    on QueryBuilder<DebtAccountModel, DebtAccountModel, QDistinct> {
  QueryBuilder<DebtAccountModel, DebtAccountModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QDistinct>
  distinctByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dueDate');
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QDistinct>
  distinctByEncryptedCounterparty({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedCounterparty',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QDistinct>
  distinctByEncryptedNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedNote',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QDistinct>
  distinctByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isArchived');
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QDistinct> distinctByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kind');
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QDistinct>
  distinctByOpeningBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openingBalance');
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QDistinct>
  distinctByReminderDaysBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderDaysBefore');
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QDistinct>
  distinctByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderEnabled');
    });
  }

  QueryBuilder<DebtAccountModel, DebtAccountModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DebtAccountModelQueryProperty
    on QueryBuilder<DebtAccountModel, DebtAccountModel, QQueryProperty> {
  QueryBuilder<DebtAccountModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DebtAccountModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DebtAccountModel, DateTime?, QQueryOperations>
  dueDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dueDate');
    });
  }

  QueryBuilder<DebtAccountModel, String, QQueryOperations>
  encryptedCounterpartyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedCounterparty');
    });
  }

  QueryBuilder<DebtAccountModel, String, QQueryOperations>
  encryptedNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedNote');
    });
  }

  QueryBuilder<DebtAccountModel, bool, QQueryOperations> isArchivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isArchived');
    });
  }

  QueryBuilder<DebtAccountModel, DebtKind, QQueryOperations> kindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kind');
    });
  }

  QueryBuilder<DebtAccountModel, double, QQueryOperations>
  openingBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openingBalance');
    });
  }

  QueryBuilder<DebtAccountModel, int, QQueryOperations>
  reminderDaysBeforeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderDaysBefore');
    });
  }

  QueryBuilder<DebtAccountModel, bool, QQueryOperations>
  reminderEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderEnabled');
    });
  }

  QueryBuilder<DebtAccountModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
