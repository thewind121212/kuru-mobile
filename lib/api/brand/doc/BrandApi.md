# kuru_brand_api.api.BrandApi

## Load the API package
```dart
import 'package:kuru_brand_api/api.dart';
```

All URIs are relative to *http://localhost:9190/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createBrand**](BrandApi.md#createbrand) | **POST** /brand/CreateBrand | CreateBrand
[**deleteBrand**](BrandApi.md#deletebrand) | **POST** /brand/DeleteBrand | DeleteBrand
[**getBrandById**](BrandApi.md#getbrandbyid) | **GET** /brand/GetBrandById | GetBrandById
[**getBrandOverview**](BrandApi.md#getbrandoverview) | **GET** /brand/GetBrandOverview | GetBrandOverview
[**updateBrand**](BrandApi.md#updatebrand) | **PATCH** /brand/UpdateBrand | UpdateBrand


# **createBrand**
> CreateBrand200Response createBrand(createBrandRequest)

CreateBrand

### Example
```dart
import 'package:kuru_brand_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruBrandApi().getBrandApi();
final CreateBrandRequest createBrandRequest = ; // CreateBrandRequest | 

try {
    final response = api.createBrand(createBrandRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BrandApi->createBrand: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createBrandRequest** | [**CreateBrandRequest**](CreateBrandRequest.md)|  | 

### Return type

[**CreateBrand200Response**](CreateBrand200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteBrand**
> DeleteBrand200Response deleteBrand(deleteBrandRequest)

DeleteBrand

### Example
```dart
import 'package:kuru_brand_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruBrandApi().getBrandApi();
final DeleteBrandRequest deleteBrandRequest = ; // DeleteBrandRequest | 

try {
    final response = api.deleteBrand(deleteBrandRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BrandApi->deleteBrand: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deleteBrandRequest** | [**DeleteBrandRequest**](DeleteBrandRequest.md)|  | 

### Return type

[**DeleteBrand200Response**](DeleteBrand200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBrandById**
> GetBrandById200Response getBrandById(brandId)

GetBrandById

### Example
```dart
import 'package:kuru_brand_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruBrandApi().getBrandApi();
final String brandId = brandId_example; // String | 

try {
    final response = api.getBrandById(brandId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BrandApi->getBrandById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **brandId** | **String**|  | 

### Return type

[**GetBrandById200Response**](GetBrandById200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBrandOverview**
> GetBrandOverview200Response getBrandOverview(searchString, page, limit)

GetBrandOverview

### Example
```dart
import 'package:kuru_brand_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruBrandApi().getBrandApi();
final String searchString = searchString_example; // String | 
final int page = 56; // int | 
final int limit = 56; // int | 

try {
    final response = api.getBrandOverview(searchString, page, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BrandApi->getBrandOverview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **searchString** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **limit** | **int**|  | [optional] 

### Return type

[**GetBrandOverview200Response**](GetBrandOverview200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateBrand**
> UpdateBrand200Response updateBrand(updateBrandRequest)

UpdateBrand

### Example
```dart
import 'package:kuru_brand_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruBrandApi().getBrandApi();
final UpdateBrandRequest updateBrandRequest = ; // UpdateBrandRequest | 

try {
    final response = api.updateBrand(updateBrandRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BrandApi->updateBrand: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateBrandRequest** | [**UpdateBrandRequest**](UpdateBrandRequest.md)|  | 

### Return type

[**UpdateBrand200Response**](UpdateBrand200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

