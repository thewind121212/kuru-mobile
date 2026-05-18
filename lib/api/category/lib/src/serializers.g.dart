// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers =
    (Serializers().toBuilder()
          ..add(ApiErrorResponse.serializer)
          ..add(ApiErrorResponseError.serializer)
          ..add(CategoryResponse.serializer)
          ..add(CreateCategory200Response.serializer)
          ..add(CreateCategoryRequest.serializer)
          ..add(CreateCategoryResponse.serializer)
          ..add(GetCategoryById200Response.serializer)
          ..add(GetCategoryByIdRequest.serializer)
          ..add(GetCategoryOverview200Response.serializer)
          ..add(GetCategoryOverviewResponse.serializer)
          ..add(GetCategoryOverviewWithDepthRequest.serializer)
          ..add(GetCategoryTree200Response.serializer)
          ..add(GetCategoryTreeRequest.serializer)
          ..add(GetCategoryTreeResponse.serializer)
          ..add(RemoveCategory200Response.serializer)
          ..add(RemoveCategoryRequest.serializer)
          ..add(RemoveCategoryResponse.serializer)
          ..add(UpdateCategory200Response.serializer)
          ..add(UpdateCategoryRequest.serializer)
          ..add(UpdateCategoryResponse.serializer)
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CategoryResponse)]),
            () => ListBuilder<CategoryResponse>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CategoryResponse)]),
            () => ListBuilder<CategoryResponse>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject),
            ]),
            () => MapBuilder<String, JsonObject?>(),
          ))
        .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
