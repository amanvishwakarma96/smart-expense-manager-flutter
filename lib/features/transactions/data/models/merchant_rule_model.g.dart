// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_rule_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMerchantRuleModelCollection on Isar {
  IsarCollection<MerchantRuleModel> get merchantRuleModels => this.collection();
}

const MerchantRuleModelSchema = CollectionSchema(
  name: r'MerchantRuleModel',
  id: 3104443779698437440,
  properties: {
    r'mappedCategoryId': PropertySchema(
      id: 0,
      name: r'mappedCategoryId',
      type: IsarType.long,
    ),
    r'merchantPattern': PropertySchema(
      id: 1,
      name: r'merchantPattern',
      type: IsarType.string,
    ),
  },

  estimateSize: _merchantRuleModelEstimateSize,
  serialize: _merchantRuleModelSerialize,
  deserialize: _merchantRuleModelDeserialize,
  deserializeProp: _merchantRuleModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'merchantPattern': IndexSchema(
      id: -5639745983445286140,
      name: r'merchantPattern',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'merchantPattern',
          type: IndexType.hash,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _merchantRuleModelGetId,
  getLinks: _merchantRuleModelGetLinks,
  attach: _merchantRuleModelAttach,
  version: '3.3.2',
);

int _merchantRuleModelEstimateSize(
  MerchantRuleModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.merchantPattern.length * 3;
  return bytesCount;
}

void _merchantRuleModelSerialize(
  MerchantRuleModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mappedCategoryId);
  writer.writeString(offsets[1], object.merchantPattern);
}

MerchantRuleModel _merchantRuleModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MerchantRuleModel(
    id: id,
    mappedCategoryId: reader.readLongOrNull(offsets[0]) ?? 0,
    merchantPattern: reader.readStringOrNull(offsets[1]) ?? '',
  );
  return object;
}

P _merchantRuleModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _merchantRuleModelGetId(MerchantRuleModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _merchantRuleModelGetLinks(
  MerchantRuleModel object,
) {
  return [];
}

void _merchantRuleModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  MerchantRuleModel object,
) {
  object.id = id;
}

extension MerchantRuleModelQueryWhereSort
    on QueryBuilder<MerchantRuleModel, MerchantRuleModel, QWhere> {
  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MerchantRuleModelQueryWhere
    on QueryBuilder<MerchantRuleModel, MerchantRuleModel, QWhereClause> {
  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterWhereClause>
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

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterWhereClause>
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

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterWhereClause>
  merchantPatternEqualTo(String merchantPattern) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'merchantPattern',
          value: [merchantPattern],
        ),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterWhereClause>
  merchantPatternNotEqualTo(String merchantPattern) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'merchantPattern',
                lower: [],
                upper: [merchantPattern],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'merchantPattern',
                lower: [merchantPattern],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'merchantPattern',
                lower: [merchantPattern],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'merchantPattern',
                lower: [],
                upper: [merchantPattern],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension MerchantRuleModelQueryFilter
    on QueryBuilder<MerchantRuleModel, MerchantRuleModel, QFilterCondition> {
  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
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

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
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

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
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

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
  mappedCategoryIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mappedCategoryId', value: value),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
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

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
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

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
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

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
  merchantPatternEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'merchantPattern',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
  merchantPatternGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'merchantPattern',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
  merchantPatternLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'merchantPattern',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
  merchantPatternBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'merchantPattern',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
  merchantPatternStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'merchantPattern',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
  merchantPatternEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'merchantPattern',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
  merchantPatternContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'merchantPattern',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
  merchantPatternMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'merchantPattern',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
  merchantPatternIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'merchantPattern', value: ''),
      );
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterFilterCondition>
  merchantPatternIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'merchantPattern', value: ''),
      );
    });
  }
}

extension MerchantRuleModelQueryObject
    on QueryBuilder<MerchantRuleModel, MerchantRuleModel, QFilterCondition> {}

extension MerchantRuleModelQueryLinks
    on QueryBuilder<MerchantRuleModel, MerchantRuleModel, QFilterCondition> {}

extension MerchantRuleModelQuerySortBy
    on QueryBuilder<MerchantRuleModel, MerchantRuleModel, QSortBy> {
  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterSortBy>
  sortByMappedCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mappedCategoryId', Sort.asc);
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterSortBy>
  sortByMappedCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mappedCategoryId', Sort.desc);
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterSortBy>
  sortByMerchantPattern() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'merchantPattern', Sort.asc);
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterSortBy>
  sortByMerchantPatternDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'merchantPattern', Sort.desc);
    });
  }
}

extension MerchantRuleModelQuerySortThenBy
    on QueryBuilder<MerchantRuleModel, MerchantRuleModel, QSortThenBy> {
  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterSortBy>
  thenByMappedCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mappedCategoryId', Sort.asc);
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterSortBy>
  thenByMappedCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mappedCategoryId', Sort.desc);
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterSortBy>
  thenByMerchantPattern() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'merchantPattern', Sort.asc);
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QAfterSortBy>
  thenByMerchantPatternDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'merchantPattern', Sort.desc);
    });
  }
}

extension MerchantRuleModelQueryWhereDistinct
    on QueryBuilder<MerchantRuleModel, MerchantRuleModel, QDistinct> {
  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QDistinct>
  distinctByMappedCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mappedCategoryId');
    });
  }

  QueryBuilder<MerchantRuleModel, MerchantRuleModel, QDistinct>
  distinctByMerchantPattern({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'merchantPattern',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension MerchantRuleModelQueryProperty
    on QueryBuilder<MerchantRuleModel, MerchantRuleModel, QQueryProperty> {
  QueryBuilder<MerchantRuleModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MerchantRuleModel, int, QQueryOperations>
  mappedCategoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mappedCategoryId');
    });
  }

  QueryBuilder<MerchantRuleModel, String, QQueryOperations>
  merchantPatternProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'merchantPattern');
    });
  }
}
