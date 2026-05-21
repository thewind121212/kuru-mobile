# kuru_product_api.model.StockMoveHistoryResponse

## Load the model package
```dart
import 'package:kuru_product_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**orgId** | **String** |  | 
**productId** | **String** |  | 
**type** | **String** |  | 
**sourceType** | **String** |  | 
**qtyBase** | **double** |  | 
**uomLabel** | **String** |  | [optional] 
**uomQty** | **double** |  | [optional] 
**uomRatio** | **double** |  | [optional] 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**actorUserId** | **String** |  | 
**allocations** | [**BuiltList&lt;StockMoveAllocationResponse&gt;**](StockMoveAllocationResponse.md) |  | [optional] 
**variantId** | **String** |  | [optional] 
**variantName** | **String** |  | [optional] 
**warehouseName** | **String** |  | [optional] 
**fromWarehouseName** | **String** |  | [optional] 
**toWarehouseName** | **String** |  | [optional] 
**reason** | **String** |  | [optional] 
**note** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


