# kuru_product_api.api.ProductApi

## Load the API package
```dart
import 'package:kuru_product_api/api.dart';
```

All URIs are relative to *http://localhost:9190/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adjustContainerLot**](ProductApi.md#adjustcontainerlot) | **PATCH** /product/AdjustContainerLot | AdjustContainerLot
[**adjustProductStock**](ProductApi.md#adjustproductstock) | **PATCH** /product/AdjustProductStock | AdjustProductStock
[**createContainerLots**](ProductApi.md#createcontainerlots) | **POST** /product/CreateContainerLots | CreateContainerLots
[**createProduct**](ProductApi.md#createproduct) | **POST** /product/CreateProduct | CreateProduct
[**createProductVariant**](ProductApi.md#createproductvariant) | **POST** /product/CreateProductVariant | CreateProductVariant
[**deleteContainerLot**](ProductApi.md#deletecontainerlot) | **DELETE** /product/DeleteContainerLot | DeleteContainerLot
[**deleteProduct**](ProductApi.md#deleteproduct) | **DELETE** /product/DeleteProduct | DeleteProduct
[**deleteProductVariant**](ProductApi.md#deleteproductvariant) | **DELETE** /product/DeleteProductVariant | DeleteProductVariant
[**getContainerLots**](ProductApi.md#getcontainerlots) | **GET** /product/GetContainerLots | GetContainerLots
[**getProductById**](ProductApi.md#getproductbyid) | **GET** /product/GetProductById | GetProductById
[**getProductOverview**](ProductApi.md#getproductoverview) | **GET** /product/GetProductOverview | GetProductOverview
[**getProductVariants**](ProductApi.md#getproductvariants) | **GET** /product/GetProductVariants | GetProductVariants
[**getStockHistory**](ProductApi.md#getstockhistory) | **GET** /product/GetStockHistory | GetStockHistory
[**saveProductVariants**](ProductApi.md#saveproductvariants) | **PATCH** /product/SaveProductVariants | SaveProductVariants
[**updateProductBarcodes**](ProductApi.md#updateproductbarcodes) | **PATCH** /product/UpdateProductBarcodes | UpdateProductBarcodes
[**updateProductInfo**](ProductApi.md#updateproductinfo) | **PATCH** /product/UpdateProductInfo | UpdateProductInfo
[**updateProductUmos**](ProductApi.md#updateproductumos) | **PATCH** /product/UpdateProductUmos | UpdateProductUmos
[**updateProductVariant**](ProductApi.md#updateproductvariant) | **PATCH** /product/UpdateProductVariant | UpdateProductVariant


# **adjustContainerLot**
> AdjustContainerLot200Response adjustContainerLot(adjustContainerLotRequest)

AdjustContainerLot

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final AdjustContainerLotRequest adjustContainerLotRequest = ; // AdjustContainerLotRequest | 

try {
    final response = api.adjustContainerLot(adjustContainerLotRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->adjustContainerLot: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adjustContainerLotRequest** | [**AdjustContainerLotRequest**](AdjustContainerLotRequest.md)|  | 

### Return type

[**AdjustContainerLot200Response**](AdjustContainerLot200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adjustProductStock**
> AdjustProductStock200Response adjustProductStock(adjustProductStockRequest)

AdjustProductStock

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final AdjustProductStockRequest adjustProductStockRequest = ; // AdjustProductStockRequest | 

try {
    final response = api.adjustProductStock(adjustProductStockRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->adjustProductStock: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adjustProductStockRequest** | [**AdjustProductStockRequest**](AdjustProductStockRequest.md)|  | 

### Return type

[**AdjustProductStock200Response**](AdjustProductStock200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createContainerLots**
> CreateContainerLots200Response createContainerLots(createContainerLotsRequest)

CreateContainerLots

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final CreateContainerLotsRequest createContainerLotsRequest = ; // CreateContainerLotsRequest | 

try {
    final response = api.createContainerLots(createContainerLotsRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->createContainerLots: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createContainerLotsRequest** | [**CreateContainerLotsRequest**](CreateContainerLotsRequest.md)|  | 

### Return type

[**CreateContainerLots200Response**](CreateContainerLots200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createProduct**
> CreateProduct200Response createProduct(createProductRequest)

CreateProduct

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final CreateProductRequest createProductRequest = ; // CreateProductRequest | 

try {
    final response = api.createProduct(createProductRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->createProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createProductRequest** | [**CreateProductRequest**](CreateProductRequest.md)|  | 

### Return type

[**CreateProduct200Response**](CreateProduct200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createProductVariant**
> CreateProductVariant200Response createProductVariant(createProductVariantRequest)

CreateProductVariant

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final CreateProductVariantRequest createProductVariantRequest = ; // CreateProductVariantRequest | 

try {
    final response = api.createProductVariant(createProductVariantRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->createProductVariant: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createProductVariantRequest** | [**CreateProductVariantRequest**](CreateProductVariantRequest.md)|  | 

### Return type

[**CreateProductVariant200Response**](CreateProductVariant200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteContainerLot**
> DeleteContainerLot200Response deleteContainerLot(deleteContainerLotRequest)

DeleteContainerLot

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final DeleteContainerLotRequest deleteContainerLotRequest = ; // DeleteContainerLotRequest | 

try {
    final response = api.deleteContainerLot(deleteContainerLotRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->deleteContainerLot: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deleteContainerLotRequest** | [**DeleteContainerLotRequest**](DeleteContainerLotRequest.md)|  | 

### Return type

[**DeleteContainerLot200Response**](DeleteContainerLot200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteProduct**
> DeleteProduct200Response deleteProduct(deleteProductRequest)

DeleteProduct

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final DeleteProductRequest deleteProductRequest = ; // DeleteProductRequest | 

try {
    final response = api.deleteProduct(deleteProductRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->deleteProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deleteProductRequest** | [**DeleteProductRequest**](DeleteProductRequest.md)|  | 

### Return type

[**DeleteProduct200Response**](DeleteProduct200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteProductVariant**
> DeleteProductVariant200Response deleteProductVariant(deleteProductVariantRequest)

DeleteProductVariant

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final DeleteProductVariantRequest deleteProductVariantRequest = ; // DeleteProductVariantRequest | 

try {
    final response = api.deleteProductVariant(deleteProductVariantRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->deleteProductVariant: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deleteProductVariantRequest** | [**DeleteProductVariantRequest**](DeleteProductVariantRequest.md)|  | 

### Return type

[**DeleteProductVariant200Response**](DeleteProductVariant200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getContainerLots**
> GetContainerLots200Response getContainerLots(productId, variantId)

GetContainerLots

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final String productId = productId_example; // String | 
final String variantId = variantId_example; // String | 

try {
    final response = api.getContainerLots(productId, variantId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->getContainerLots: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **String**|  | 
 **variantId** | **String**|  | [optional] 

### Return type

[**GetContainerLots200Response**](GetContainerLots200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProductById**
> GetProductById200Response getProductById(productId)

GetProductById

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final String productId = productId_example; // String | 

try {
    final response = api.getProductById(productId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->getProductById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **String**|  | 

### Return type

[**GetProductById200Response**](GetProductById200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProductOverview**
> GetProductOverview200Response getProductOverview(searchString, categoryIds, distributorIds, page, limit, warehouseIds, attributeFilters, minPrice, maxPrice, brandIds)

GetProductOverview

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final String searchString = searchString_example; // String | 
final BuiltList<String> categoryIds = ; // BuiltList<String> | 
final BuiltList<String> distributorIds = ; // BuiltList<String> | 
final int page = 56; // int | 
final int limit = 56; // int | 
final BuiltList<String> warehouseIds = ; // BuiltList<String> | 
final BuiltList<String> attributeFilters = ; // BuiltList<String> | 
final double minPrice = 1.2; // double | 
final double maxPrice = 1.2; // double | 
final BuiltList<String> brandIds = ; // BuiltList<String> | 

try {
    final response = api.getProductOverview(searchString, categoryIds, distributorIds, page, limit, warehouseIds, attributeFilters, minPrice, maxPrice, brandIds);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->getProductOverview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **searchString** | **String**|  | [optional] 
 **categoryIds** | [**BuiltList&lt;String&gt;**](String.md)|  | [optional] 
 **distributorIds** | [**BuiltList&lt;String&gt;**](String.md)|  | [optional] 
 **page** | **int**|  | [optional] 
 **limit** | **int**|  | [optional] 
 **warehouseIds** | [**BuiltList&lt;String&gt;**](String.md)|  | [optional] 
 **attributeFilters** | [**BuiltList&lt;String&gt;**](String.md)|  | [optional] 
 **minPrice** | **double**|  | [optional] 
 **maxPrice** | **double**|  | [optional] 
 **brandIds** | [**BuiltList&lt;String&gt;**](String.md)|  | [optional] 

### Return type

[**GetProductOverview200Response**](GetProductOverview200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProductVariants**
> GetProductVariants200Response getProductVariants(productId)

GetProductVariants

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final String productId = productId_example; // String | 

try {
    final response = api.getProductVariants(productId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->getProductVariants: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **String**|  | 

### Return type

[**GetProductVariants200Response**](GetProductVariants200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getStockHistory**
> GetStockHistory200Response getStockHistory(productId, warehouseId, fromDate, toDate, page, limit, variantId, type)

GetStockHistory

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final String productId = productId_example; // String | 
final String warehouseId = warehouseId_example; // String | 
final DateTime fromDate = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime toDate = 2013-10-20T19:20:30+01:00; // DateTime | 
final int page = 56; // int | 
final int limit = 56; // int | 
final String variantId = variantId_example; // String | 
final String type = type_example; // String | 

try {
    final response = api.getStockHistory(productId, warehouseId, fromDate, toDate, page, limit, variantId, type);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->getStockHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **String**|  | [optional] 
 **warehouseId** | **String**|  | [optional] 
 **fromDate** | **DateTime**|  | [optional] 
 **toDate** | **DateTime**|  | [optional] 
 **page** | **int**|  | [optional] 
 **limit** | **int**|  | [optional] 
 **variantId** | **String**|  | [optional] 
 **type** | **String**|  | [optional] 

### Return type

[**GetStockHistory200Response**](GetStockHistory200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveProductVariants**
> SaveProductVariants200Response saveProductVariants(saveProductVariantsRequest)

SaveProductVariants

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final SaveProductVariantsRequest saveProductVariantsRequest = ; // SaveProductVariantsRequest | 

try {
    final response = api.saveProductVariants(saveProductVariantsRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->saveProductVariants: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **saveProductVariantsRequest** | [**SaveProductVariantsRequest**](SaveProductVariantsRequest.md)|  | 

### Return type

[**SaveProductVariants200Response**](SaveProductVariants200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateProductBarcodes**
> UpdateProductBarcodes200Response updateProductBarcodes(updateProductBarcodesRequest)

UpdateProductBarcodes

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final UpdateProductBarcodesRequest updateProductBarcodesRequest = ; // UpdateProductBarcodesRequest | 

try {
    final response = api.updateProductBarcodes(updateProductBarcodesRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->updateProductBarcodes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateProductBarcodesRequest** | [**UpdateProductBarcodesRequest**](UpdateProductBarcodesRequest.md)|  | 

### Return type

[**UpdateProductBarcodes200Response**](UpdateProductBarcodes200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateProductInfo**
> UpdateProductInfo200Response updateProductInfo(updateProductInfoRequest)

UpdateProductInfo

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final UpdateProductInfoRequest updateProductInfoRequest = ; // UpdateProductInfoRequest | 

try {
    final response = api.updateProductInfo(updateProductInfoRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->updateProductInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateProductInfoRequest** | [**UpdateProductInfoRequest**](UpdateProductInfoRequest.md)|  | 

### Return type

[**UpdateProductInfo200Response**](UpdateProductInfo200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateProductUmos**
> UpdateProductUmos200Response updateProductUmos(updateProductUmosRequest)

UpdateProductUmos

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final UpdateProductUmosRequest updateProductUmosRequest = ; // UpdateProductUmosRequest | 

try {
    final response = api.updateProductUmos(updateProductUmosRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->updateProductUmos: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateProductUmosRequest** | [**UpdateProductUmosRequest**](UpdateProductUmosRequest.md)|  | 

### Return type

[**UpdateProductUmos200Response**](UpdateProductUmos200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateProductVariant**
> UpdateProductVariant200Response updateProductVariant(updateProductVariantRequest)

UpdateProductVariant

### Example
```dart
import 'package:kuru_product_api/api.dart';
// TODO Configure API key authorization: supertokensSession
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('supertokensSession').apiKeyPrefix = 'Bearer';

final api = KuruProductApi().getProductApi();
final UpdateProductVariantRequest updateProductVariantRequest = ; // UpdateProductVariantRequest | 

try {
    final response = api.updateProductVariant(updateProductVariantRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProductApi->updateProductVariant: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateProductVariantRequest** | [**UpdateProductVariantRequest**](UpdateProductVariantRequest.md)|  | 

### Return type

[**UpdateProductVariant200Response**](UpdateProductVariant200Response.md)

### Authorization

[supertokensSession](../README.md#supertokensSession)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

