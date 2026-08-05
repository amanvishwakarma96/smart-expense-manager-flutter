// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_goal_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSavingsGoalModelCollection on Isar {
  IsarCollection<SavingsGoalModel> get savingsGoalModels => this.collection();
}

const SavingsGoalModelSchema = CollectionSchema(
  name: r'SavingsGoalModel',
  id: -5019217194559033104,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'encryptedName': PropertySchema(
      id: 1,
      name: r'encryptedName',
      type: IsarType.string,
    ),
    r'hexColor': PropertySchema(
      id: 2,
      name: r'hexColor',
      type: IsarType.string,
    ),
    r'iconName': PropertySchema(
      id: 3,
      name: r'iconName',
      type: IsarType.string,
    ),
    r'isArchived': PropertySchema(
      id: 4,
      name: r'isArchived',
      type: IsarType.bool,
    ),
    r'savedAmount': PropertySchema(
      id: 5,
      name: r'savedAmount',
      type: IsarType.double,
    ),
    r'targetAmount': PropertySchema(
      id: 6,
      name: r'targetAmount',
      type: IsarType.double,
    ),
    r'targetDate': PropertySchema(
      id: 7,
      name: r'targetDate',
      type: IsarType.dateTime,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _savingsGoalModelEstimateSize,
  serialize: _savingsGoalModelSerialize,
  deserialize: _savingsGoalModelDeserialize,
  deserializeProp: _savingsGoalModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _savingsGoalModelGetId,
  getLinks: _savingsGoalModelGetLinks,
  attach: _savingsGoalModelAttach,
  version: '3.3.2',
);

int _savingsGoalModelEstimateSize(
  SavingsGoalModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.encryptedName.length * 3;
  bytesCount += 3 + object.hexColor.length * 3;
  bytesCount += 3 + object.iconName.length * 3;
  return bytesCount;
}

void _savingsGoalModelSerialize(
  SavingsGoalModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.encryptedName);
  writer.writeString(offsets[2], object.hexColor);
  writer.writeString(offsets[3], object.iconName);
  writer.writeBool(offsets[4], object.isArchived);
  writer.writeDouble(offsets[5], object.savedAmount);
  writer.writeDouble(offsets[6], object.targetAmount);
  writer.writeDateTime(offsets[7], object.targetDate);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

SavingsGoalModel _savingsGoalModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavingsGoalModel(
    encryptedName: reader.readStringOrNull(offsets[1]) ?? '',
    hexColor: reader.readStringOrNull(offsets[2]) ?? 'CBB8FF',
    iconName: reader.readStringOrNull(offsets[3]) ?? 'savings',
    id: id,
    isArchived: reader.readBoolOrNull(offsets[4]) ?? false,
    savedAmount: reader.readDoubleOrNull(offsets[5]) ?? 0,
    targetAmount: reader.readDoubleOrNull(offsets[6]) ?? 0,
    targetDate: reader.readDateTimeOrNull(offsets[7]),
  );
  object.createdAt = reader.readDateTime(offsets[0]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  return object;
}

P _savingsGoalModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? 'CBB8FF') as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? 'savings') as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 6:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _savingsGoalModelGetId(SavingsGoalModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _savingsGoalModelGetLinks(SavingsGoalModel object) {
  return [];
}

void _savingsGoalModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  SavingsGoalModel object,
) {
  object.id = id;
}

extension SavingsGoalModelQueryWhereSort
    on QueryBuilder<SavingsGoalModel, SavingsGoalModel, QWhere> {
  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SavingsGoalModelQueryWhere
    on QueryBuilder<SavingsGoalModel, SavingsGoalModel, QWhereClause> {
  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterWhereClause>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterWhereClause> idBetween(
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

extension SavingsGoalModelQueryFilter
    on QueryBuilder<SavingsGoalModel, SavingsGoalModel, QFilterCondition> {
  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  encryptedNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  encryptedNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'encryptedName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  encryptedNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'encryptedName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  encryptedNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'encryptedName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  encryptedNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'encryptedName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  encryptedNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'encryptedName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  encryptedNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'encryptedName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  encryptedNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'encryptedName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  encryptedNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedName', value: ''),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  encryptedNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'encryptedName', value: ''),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  hexColorEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hexColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  hexColorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hexColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  hexColorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hexColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  hexColorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hexColor',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  hexColorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'hexColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  hexColorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'hexColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  hexColorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'hexColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  hexColorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'hexColor',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  hexColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hexColor', value: ''),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  hexColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'hexColor', value: ''),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  iconNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'iconName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  iconNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'iconName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  iconNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'iconName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  iconNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'iconName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  iconNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'iconName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  iconNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'iconName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  iconNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'iconName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  iconNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'iconName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  iconNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'iconName', value: ''),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  iconNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'iconName', value: ''),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  isArchivedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isArchived', value: value),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  savedAmountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'savedAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  savedAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'savedAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  savedAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'savedAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  savedAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'savedAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  targetDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'targetDate'),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  targetDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'targetDate'),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  targetDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetDate', value: value),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  targetDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  targetDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  targetDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterFilterCondition>
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

extension SavingsGoalModelQueryObject
    on QueryBuilder<SavingsGoalModel, SavingsGoalModel, QFilterCondition> {}

extension SavingsGoalModelQueryLinks
    on QueryBuilder<SavingsGoalModel, SavingsGoalModel, QFilterCondition> {}

extension SavingsGoalModelQuerySortBy
    on QueryBuilder<SavingsGoalModel, SavingsGoalModel, QSortBy> {
  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByEncryptedName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedName', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByEncryptedNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedName', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByHexColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexColor', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByHexColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexColor', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByIconName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByIconNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortBySavedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedAmount', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortBySavedAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedAmount', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByTargetAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetAmount', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByTargetAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetAmount', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByTargetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDate', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByTargetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDate', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SavingsGoalModelQuerySortThenBy
    on QueryBuilder<SavingsGoalModel, SavingsGoalModel, QSortThenBy> {
  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByEncryptedName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedName', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByEncryptedNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedName', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByHexColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexColor', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByHexColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexColor', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByIconName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByIconNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenBySavedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedAmount', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenBySavedAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedAmount', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByTargetAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetAmount', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByTargetAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetAmount', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByTargetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDate', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByTargetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDate', Sort.desc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SavingsGoalModelQueryWhereDistinct
    on QueryBuilder<SavingsGoalModel, SavingsGoalModel, QDistinct> {
  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QDistinct>
  distinctByEncryptedName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QDistinct>
  distinctByHexColor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hexColor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QDistinct>
  distinctByIconName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QDistinct>
  distinctByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isArchived');
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QDistinct>
  distinctBySavedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'savedAmount');
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QDistinct>
  distinctByTargetAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetAmount');
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QDistinct>
  distinctByTargetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetDate');
    });
  }

  QueryBuilder<SavingsGoalModel, SavingsGoalModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension SavingsGoalModelQueryProperty
    on QueryBuilder<SavingsGoalModel, SavingsGoalModel, QQueryProperty> {
  QueryBuilder<SavingsGoalModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SavingsGoalModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SavingsGoalModel, String, QQueryOperations>
  encryptedNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedName');
    });
  }

  QueryBuilder<SavingsGoalModel, String, QQueryOperations> hexColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hexColor');
    });
  }

  QueryBuilder<SavingsGoalModel, String, QQueryOperations> iconNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconName');
    });
  }

  QueryBuilder<SavingsGoalModel, bool, QQueryOperations> isArchivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isArchived');
    });
  }

  QueryBuilder<SavingsGoalModel, double, QQueryOperations>
  savedAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savedAmount');
    });
  }

  QueryBuilder<SavingsGoalModel, double, QQueryOperations>
  targetAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetAmount');
    });
  }

  QueryBuilder<SavingsGoalModel, DateTime?, QQueryOperations>
  targetDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetDate');
    });
  }

  QueryBuilder<SavingsGoalModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
