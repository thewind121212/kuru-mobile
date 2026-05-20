//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:kuru_category_api/src/date_serializer.dart';
import 'package:kuru_category_api/src/model/date.dart';

import 'package:kuru_category_api/src/model/api_error_response.dart';
import 'package:kuru_category_api/src/model/api_error_response_error.dart';
import 'package:kuru_category_api/src/model/category_response.dart';
import 'package:kuru_category_api/src/model/create_category200_response.dart';
import 'package:kuru_category_api/src/model/create_category_request.dart';
import 'package:kuru_category_api/src/model/create_category_response.dart';
import 'package:kuru_category_api/src/model/get_category_by_id200_response.dart';
import 'package:kuru_category_api/src/model/get_category_by_id_request.dart';
import 'package:kuru_category_api/src/model/get_category_overview200_response.dart';
import 'package:kuru_category_api/src/model/get_category_overview_response.dart';
import 'package:kuru_category_api/src/model/get_category_overview_with_depth_request.dart';
import 'package:kuru_category_api/src/model/get_category_tree200_response.dart';
import 'package:kuru_category_api/src/model/get_category_tree_request.dart';
import 'package:kuru_category_api/src/model/get_category_tree_response.dart';
import 'package:kuru_category_api/src/model/remove_category200_response.dart';
import 'package:kuru_category_api/src/model/remove_category_request.dart';
import 'package:kuru_category_api/src/model/remove_category_response.dart';
import 'package:kuru_category_api/src/model/update_category200_response.dart';
import 'package:kuru_category_api/src/model/update_category_request.dart';
import 'package:kuru_category_api/src/model/update_category_response.dart';

part 'serializers.g.dart';

@SerializersFor([
  ApiErrorResponse,
  ApiErrorResponseError,
  CategoryResponse,
  CreateCategory200Response,
  CreateCategoryRequest,
  CreateCategoryResponse,
  GetCategoryById200Response,
  GetCategoryByIdRequest,
  GetCategoryOverview200Response,
  GetCategoryOverviewResponse,
  GetCategoryOverviewWithDepthRequest,
  GetCategoryTree200Response,
  GetCategoryTreeRequest,
  GetCategoryTreeResponse,
  RemoveCategory200Response,
  RemoveCategoryRequest,
  RemoveCategoryResponse,
  UpdateCategory200Response,
  UpdateCategoryRequest,
  UpdateCategoryResponse,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
