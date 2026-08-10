// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_learning_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMerchantLearningModelCollection on Isar {
  IsarCollection<MerchantLearningModel> get merchantLearningModels =>
      this.collection();
}

const MerchantLearningModelSchema = CollectionSchema(
  name: r'MerchantLearningModel',
  id: 1974082277606607599,
  properties: {
    r'confidence': PropertySchema(
      id: 0,
      name: r'confidence',
      type: IsarType.long,
    ),
    r'encryptedMerchant': PropertySchema(
      id: 1,
      name: r'encryptedMerchant',
      type: IsarType.string,
    ),
    r'mappedCategoryId': PropertySchema(
      id: 2,
      name: r'mappedCategoryId',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 3,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _merchantLearningModelEstimateSize,
  serialize: _merchantLearningModelSerialize,
  deserialize: _merchantLearningModelDeserialize,
  deserializeProp: _merchantLearningModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _merchantLearningModelGetId,
  getLinks: _merchantLearningModelGetLinks,
  attach: _merchantLearningModelAttach,
  version: '3.3.2',
);

int _merchantLearningModelEstimateSize(
  MerchantLearningModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.encryptedMerchant.length * 3;
  return bytesCount;
}

void _merchantLearningModelSerialize(
  MerchantLearningModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.confidence);
  writer.writeString(offsets[1], object.encryptedMerchant);
  writer.writeLong(offsets[2], object.mappedCategoryId);
  writer.writeDateTime(offsets[3], object.updatedAt);
}

MerchantLearningModel _merchantLearningModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MerchantLearningModel(
    confidence: reader.readLongOrNull(offsets[0]) ?? 1,
    encryptedMerchant: reader.readStringOrNull(offsets[1]) ?? '',
    id: id,
    mappedCategoryId: reader.readLongOrNull(offsets[2]) ?? 0,
    updatedAt: reader.readDateTime(offsets[3]),
  );
  return object;
}

P _merchantLearningModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _merchantLearningModelGetId(MerchantLearningModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _merchantLearningModelGetLinks(
  MerchantLearningModel object,
) {
  return [];
}

void _merchantLearningModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  MerchantLearningModel object,
) {
  object.id = id;
}

extension MerchantLearningModelQueryWhereSort
    on QueryBuilder<MerchantLearningModel, MerchantLearningModel, QWhere> {
  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MerchantLearningModelQueryWhere
    on
        QueryBuilder<
          MerchantLearningModel,
          MerchantLearningModel,
          QWhereClause
        > {
  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterWhereClause>
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

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterWhereClause>
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

extension MerchantLearningModelQueryFilter
    on
        QueryBuilder<
          MerchantLearningModel,
          MerchantLearningModel,
          QFilterCondition
        > {
  QueryBuilder<
    MerchantLearningModel,
    MerchantLearningModel,
    QAfterFilterCondition
  >
  confidenceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'confidence', value: value),
      );
    });
  }

  QueryBuilder<
    MerchantLearningModel,
    MerchantLearningModel,
    QAfterFilterCondition
  >
  confidenceGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'confidence',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MerchantLearningModel,
    MerchantLearningModel,
    QAfterFilterCondition
  >
  confidenceLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'confidence',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MerchantLearningModel,
    MerchantLearningModel,
    QAfterFilterCondition
  >
  confidenceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'confidence',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
    QAfterFilterCondition
  >
  mappedCategoryIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mappedCategoryId', value: value),
      );
    });
  }

  QueryBuilder<
    MerchantLearningModel,
    MerchantLearningModel,
    QAfterFilterCondition
  >
  mappedCategoryIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mappedCategoryId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MerchantLearningModel,
    MerchantLearningModel,
    QAfterFilterCondition
  >
  mappedCategoryIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mappedCategoryId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MerchantLearningModel,
    MerchantLearningModel,
    QAfterFilterCondition
  >
  mappedCategoryIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mappedCategoryId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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
    MerchantLearningModel,
    MerchantLearningModel,
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

extension MerchantLearningModelQueryObject
    on
        QueryBuilder<
          MerchantLearningModel,
          MerchantLearningModel,
          QFilterCondition
        > {}

extension MerchantLearningModelQueryLinks
    on
        QueryBuilder<
          MerchantLearningModel,
          MerchantLearningModel,
          QFilterCondition
        > {}

extension MerchantLearningModelQuerySortBy
    on QueryBuilder<MerchantLearningModel, MerchantLearningModel, QSortBy> {
  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  sortByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  sortByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  sortByEncryptedMerchant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedMerchant', Sort.asc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  sortByEncryptedMerchantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedMerchant', Sort.desc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  sortByMappedCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mappedCategoryId', Sort.asc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  sortByMappedCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mappedCategoryId', Sort.desc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MerchantLearningModelQuerySortThenBy
    on QueryBuilder<MerchantLearningModel, MerchantLearningModel, QSortThenBy> {
  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  thenByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  thenByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  thenByEncryptedMerchant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedMerchant', Sort.asc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  thenByEncryptedMerchantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedMerchant', Sort.desc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  thenByMappedCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mappedCategoryId', Sort.asc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  thenByMappedCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mappedCategoryId', Sort.desc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MerchantLearningModelQueryWhereDistinct
    on QueryBuilder<MerchantLearningModel, MerchantLearningModel, QDistinct> {
  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QDistinct>
  distinctByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence');
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QDistinct>
  distinctByEncryptedMerchant({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedMerchant',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QDistinct>
  distinctByMappedCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mappedCategoryId');
    });
  }

  QueryBuilder<MerchantLearningModel, MerchantLearningModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension MerchantLearningModelQueryProperty
    on
        QueryBuilder<
          MerchantLearningModel,
          MerchantLearningModel,
          QQueryProperty
        > {
  QueryBuilder<MerchantLearningModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MerchantLearningModel, int, QQueryOperations>
  confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<MerchantLearningModel, String, QQueryOperations>
  encryptedMerchantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedMerchant');
    });
  }

  QueryBuilder<MerchantLearningModel, int, QQueryOperations>
  mappedCategoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mappedCategoryId');
    });
  }

  QueryBuilder<MerchantLearningModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
