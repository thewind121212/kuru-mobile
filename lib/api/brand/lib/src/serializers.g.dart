// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers =
    (Serializers().toBuilder()
          ..add(ApiErrorResponse.serializer)
          ..add(ApiErrorResponseError.serializer)
          ..add(BrandOverviewItem.serializer)
          ..add(BrandResponse.serializer)
          ..add(CreateBrand200Response.serializer)
          ..add(CreateBrandRequest.serializer)
          ..add(CreateBrandResponse.serializer)
          ..add(DeleteBrand200Response.serializer)
          ..add(DeleteBrandRequest.serializer)
          ..add(DeleteBrandResponse.serializer)
          ..add(GetBrandById200Response.serializer)
          ..add(GetBrandByIdRequest.serializer)
          ..add(GetBrandOverview200Response.serializer)
          ..add(GetBrandOverviewRequest.serializer)
          ..add(GetBrandOverviewResponse.serializer)
          ..add(UpdateBrand200Response.serializer)
          ..add(UpdateBrandRequest.serializer)
          ..add(UpdateBrandResponse.serializer)
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(BrandOverviewItem),
            ]),
            () => ListBuilder<BrandOverviewItem>(),
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
