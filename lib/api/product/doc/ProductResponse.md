# kuru_product_api.model.ProductResponse

## Load the model package
```dart
import 'package:kuru_product_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**orgId** | **String** |  | 
**categoryId** | **String** |  | [optional] 
**distributorId** | **String** |  | [optional] 
**description** | **String** |  | [optional] 
**imageUrl** | **String** |  | [optional] 
**name** | **String** |  | 
**status** | **String** |  | 
**isDelete** | **bool** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**updatedAt** | [**DateTime**](DateTime.md) |  | 
**baseUnitCode** | **String** |  | 
**sellPrice** | **double** |  | 
**umos** | [**BuiltList&lt;ProductUOMResponse&gt;**](ProductUOMResponse.md) |  | [optional] 
**barcodes** | [**BuiltList&lt;ProductBarcodeResponse&gt;**](ProductBarcodeResponse.md) |  | [optional] 
**internalBarcode** | **String** |  | [optional] 
**baseUnitLabel** | **String** |  | [optional] 
**exportPrice** | **double** |  | [optional] 
**containerLabel** | **String** |  | [optional] 
**containerSize** | **double** |  | [optional] 
**stocks** | [**BuiltList&lt;ProductStockResponse&gt;**](ProductStockResponse.md) |  | [optional] 
**demandStock** | **double** |  | 
**importPrice** | **double** |  | [optional] 
**variants** | [**BuiltList&lt;ProductVariantResponse&gt;**](ProductVariantResponse.md) |  | [optional] 
**avgCost** | **double** |  | 
**totalCostValue** | **double** |  | 
**totalQtyImported** | **double** |  | 
**brandId** | **String** |  | [optional] 
**brandName** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


