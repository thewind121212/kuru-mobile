# kuru_product_api.model.CreateProductRequest

## Load the model package
```dart
import 'package:kuru_product_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**categoryId** | **String** |  | [optional] 
**distributorId** | **String** |  | [optional] 
**brandId** | **String** |  | [optional] 
**name** | **String** |  | 
**description** | **String** |  | [optional] 
**imageUrl** | **String** |  | [optional] 
**status** | **String** |  | [optional] 
**baseUnitCode** | **String** |  | [optional] 
**baseUnitLabel** | **String** |  | [optional] 
**sellPrice** | **double** |  | 
**exportPrice** | **double** |  | [optional] 
**containerLabel** | **String** |  | [optional] 
**containerSize** | **double** |  | [optional] 
**packs** | [**BuiltList&lt;CreateProductPackRequest&gt;**](CreateProductPackRequest.md) |  | [optional] 
**barcodes** | [**BuiltList&lt;CreateProductBarcodeRequest&gt;**](CreateProductBarcodeRequest.md) |  | [optional] 
**initialStocks** | [**BuiltList&lt;CreateProductStockRequest&gt;**](CreateProductStockRequest.md) |  | [optional] 
**demandStock** | **double** |  | 
**importPrice** | **double** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


