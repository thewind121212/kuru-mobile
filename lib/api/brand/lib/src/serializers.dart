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
import 'package:kuru_brand_api/src/date_serializer.dart';
import 'package:kuru_brand_api/src/model/date.dart';

import 'package:kuru_brand_api/src/model/api_error_response.dart';
import 'package:kuru_brand_api/src/model/api_error_response_error.dart';
import 'package:kuru_brand_api/src/model/brand_overview_item.dart';
import 'package:kuru_brand_api/src/model/brand_response.dart';
import 'package:kuru_brand_api/src/model/create_brand200_response.dart';
import 'package:kuru_brand_api/src/model/create_brand_request.dart';
import 'package:kuru_brand_api/src/model/create_brand_response.dart';
import 'package:kuru_brand_api/src/model/delete_brand200_response.dart';
import 'package:kuru_brand_api/src/model/delete_brand_request.dart';
import 'package:kuru_brand_api/src/model/delete_brand_response.dart';
import 'package:kuru_brand_api/src/model/get_brand_by_id200_response.dart';
import 'package:kuru_brand_api/src/model/get_brand_by_id_request.dart';
import 'package:kuru_brand_api/src/model/get_brand_overview200_response.dart';
import 'package:kuru_brand_api/src/model/get_brand_overview_request.dart';
import 'package:kuru_brand_api/src/model/get_brand_overview_response.dart';
import 'package:kuru_brand_api/src/model/update_brand200_response.dart';
import 'package:kuru_brand_api/src/model/update_brand_request.dart';
import 'package:kuru_brand_api/src/model/update_brand_response.dart';

part 'serializers.g.dart';

@SerializersFor([
  ApiErrorResponse,
  ApiErrorResponseError,
  BrandOverviewItem,
  BrandResponse,
  CreateBrand200Response,
  CreateBrandRequest,
  CreateBrandResponse,
  DeleteBrand200Response,
  DeleteBrandRequest,
  DeleteBrandResponse,
  GetBrandById200Response,
  GetBrandByIdRequest,
  GetBrandOverview200Response,
  GetBrandOverviewRequest,
  GetBrandOverviewResponse,
  UpdateBrand200Response,
  UpdateBrandRequest,
  UpdateBrandResponse,
])
Serializers serializers =
    (_$serializers.toBuilder()
          ..add(const OneOfSerializer())
          ..add(const AnyOfSerializer())
          ..add(const DateSerializer())
          ..add(Iso8601DateTimeSerializer()))
        .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
