# kuru_category_api.api.CategoryApi

## Load the API package
```dart
import 'package:kuru_category_api/api.dart';
```

All URIs are relative to *http://localhost:9190/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createCategory**](CategoryApi.md#createcategory) | **POST** /category/CreateCategory | CreateCategory
[**getCategoryById**](CategoryApi.md#getcategorybyid) | **POST** /category/GetCategoryById | GetCategoryById
[**getCategoryOverview**](CategoryApi.md#getcategoryoverview) | **GET** /category/GetCategoryOverview | GetCategoryOverview
[**getCategoryOverviewWithDepth**](CategoryApi.md#getcategoryoverviewwithdepth) | **GET** /category/GetCategoryOverviewWithDepth | GetCategoryOverviewWithDepth
[**getCategoryTree**](CategoryApi.md#getcategorytree) | **GET** /category/GetCategoryTree | GetCategoryTree
[**removeCategory**](CategoryApi.md#removecategory) | **POST** /category/RemoveCategory | RemoveCategory
[**updateCategory**](CategoryApi.md#updatecategory) | **PUT** /category/UpdateCategory | UpdateCategory


# **createCategory**
> CreateCategory200Response createCategory(createCategoryRequest)

CreateCategory

### Example
```dart
import 'package:kuru_category_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruCategoryApi().getCategoryApi();
final CreateCategoryRequest createCategoryRequest = ; // CreateCategoryRequest | 

try {
    final response = api.createCategory(createCategoryRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CategoryApi->createCategory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createCategoryRequest** | [**CreateCategoryRequest**](CreateCategoryRequest.md)|  | 

### Return type

[**CreateCategory200Response**](CreateCategory200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCategoryById**
> GetCategoryById200Response getCategoryById(getCategoryByIdRequest)

GetCategoryById

### Example
```dart
import 'package:kuru_category_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruCategoryApi().getCategoryApi();
final GetCategoryByIdRequest getCategoryByIdRequest = ; // GetCategoryByIdRequest | 

try {
    final response = api.getCategoryById(getCategoryByIdRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CategoryApi->getCategoryById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **getCategoryByIdRequest** | [**GetCategoryByIdRequest**](GetCategoryByIdRequest.md)|  | 

### Return type

[**GetCategoryById200Response**](GetCategoryById200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCategoryOverview**
> GetCategoryOverview200Response getCategoryOverview()

GetCategoryOverview

### Example
```dart
import 'package:kuru_category_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruCategoryApi().getCategoryApi();

try {
    final response = api.getCategoryOverview();
    print(response);
} catch on DioException (e) {
    print('Exception when calling CategoryApi->getCategoryOverview: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetCategoryOverview200Response**](GetCategoryOverview200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCategoryOverviewWithDepth**
> GetCategoryOverview200Response getCategoryOverviewWithDepth(depth)

GetCategoryOverviewWithDepth

### Example
```dart
import 'package:kuru_category_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruCategoryApi().getCategoryApi();
final int depth = 56; // int | 

try {
    final response = api.getCategoryOverviewWithDepth(depth);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CategoryApi->getCategoryOverviewWithDepth: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **depth** | **int**|  | 

### Return type

[**GetCategoryOverview200Response**](GetCategoryOverview200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCategoryTree**
> GetCategoryTree200Response getCategoryTree(categoryId)

GetCategoryTree

### Example
```dart
import 'package:kuru_category_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruCategoryApi().getCategoryApi();
final String categoryId = categoryId_example; // String | 

try {
    final response = api.getCategoryTree(categoryId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CategoryApi->getCategoryTree: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryId** | **String**|  | 

### Return type

[**GetCategoryTree200Response**](GetCategoryTree200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeCategory**
> RemoveCategory200Response removeCategory(removeCategoryRequest)

RemoveCategory

### Example
```dart
import 'package:kuru_category_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruCategoryApi().getCategoryApi();
final RemoveCategoryRequest removeCategoryRequest = ; // RemoveCategoryRequest | 

try {
    final response = api.removeCategory(removeCategoryRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CategoryApi->removeCategory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **removeCategoryRequest** | [**RemoveCategoryRequest**](RemoveCategoryRequest.md)|  | 

### Return type

[**RemoveCategory200Response**](RemoveCategory200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCategory**
> UpdateCategory200Response updateCategory(updateCategoryRequest)

UpdateCategory

### Example
```dart
import 'package:kuru_category_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruCategoryApi().getCategoryApi();
final UpdateCategoryRequest updateCategoryRequest = ; // UpdateCategoryRequest | 

try {
    final response = api.updateCategory(updateCategoryRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CategoryApi->updateCategory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateCategoryRequest** | [**UpdateCategoryRequest**](UpdateCategoryRequest.md)|  | 

### Return type

[**UpdateCategory200Response**](UpdateCategory200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

