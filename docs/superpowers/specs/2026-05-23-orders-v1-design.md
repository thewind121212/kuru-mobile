# Orders v1 — design

**Date:** 2026-05-23
**Branch:** `feat/orders-v1` (planned — currently on `feat/product-variants-create-edit-view`)
**Status:** design — awaiting plan
**Scope:** Order module only (list + detail + create + status/payment actions). POS module is a separate, later spec.

## 1. Context

Catalog (Brand / Category / Product) shipped through `v0.4.x`. The next domain to bring online is **Orders** — viewing past sales, recording new sales, managing status + payments. The BE supports the full set of order endpoints under `/api/v1/order/*` (see `gen-barcode/be/core/domains/order/api/`).

This spec covers shipping a **mobile-native Order module** that mirrors the web `order-module/` capability while skipping the parts that depend on mobile modules we haven't built yet (Customer, Tax, Store). POS-style cart UX (`pos-module/` on web) is **deliberately out of scope** — it will be built later as a separate screen on top of the Order primitives.

### 1.1 Non-goals (deferred)

- POS-style barcode-scan cart flow (separate spec)
- Customer attach via picker (mobile has no Customer module — text inputs only)
- Tax via `taxRateId` (mobile has no Tax module — manual % input only)
- Store picker (single-store assumption — uses current org's default)
- `AddOrderItem` / `UpdateOrderItem` / `DeleteOrderItem` (edit committed order)
- `RefundOrder`
- Multi-payment timeline editing (one-at-a-time via sheet only)
- Draft persistence to disk (in-memory only)
- Order stats / KPI dashboard (`GetOrderStats` endpoint exists, defer to future Home overhaul)

## 2. Backend contract (source of truth)

Read order per CLAUDE.md: DTO → route → .d.ts → service → (openapi for cross-check only).

### 2.1 Endpoints

| Verb  | Path                                | Returns                                 |
|-------|-------------------------------------|-----------------------------------------|
| POST  | `/api/v1/order/CreateOrder`         | HTTP 201, `{ orderId?, orderNumber? }`  |
| GET   | `/api/v1/order/GetOrderById`        | HTTP 200, `OrderResponse`               |
| GET   | `/api/v1/order/GetOrderOverview`    | HTTP 200, `{ orders[], total, page, limit }` |
| POST  | `/api/v1/order/UpdateOrderStatus`   | HTTP 200, `{ success, error? }`         |
| POST  | `/api/v1/order/AddOrderPayment`     | HTTP 201, `{ success, error?, paymentId? }` |
| POST  | `/api/v1/order/VoidOrder`           | HTTP 200, `{ success, error? }`         |

All authenticated routes require the `x-org-id` header (attached automatically by the dio interceptor from `currentOrgIdProvider`).

Endpoints **defined on BE but not used in v1**: `AddOrderItem`, `UpdateOrderItem`, `DeleteOrderItem`, `RefundOrder`, `GetOrderStats`.

### 2.2 Shapes

```ts
// Request bodies (Zod-validated; hand-built in repo, not from openapi)
CreateOrderRequest {
  orgId: string (required)
  idempotencyKey: UUIDv4 (required)
  items: OrderItemInput[] (min 1)
  customerId?: string
  customerName?: string
  customerPhone?: string
  note?: string
  discountType?: "PERCENTAGE" | "FIXED"
  discountValue?: number (>= 0)
  taxRateId?: string
  storeId?: string
  saleChannel?: "SHOP" | "ECOMMERCE"
  payment?: { method, amount (>=0), reference?, note? }
}

OrderItemInput {
  productId: string (required)
  variantId?: string
  productName: string (required)
  variantName?: string
  imageUrl?: string
  barcode?: string
  baseUnitCode: string (required)
  qty: number (>0)
  unitPrice: number (>=0)
  discountType?: "PERCENTAGE" | "FIXED"
  discountValue?: number (>=0)
}

UpdateOrderStatusRequest {
  orderId: string
  status: "DRAFT" | "PENDING" | "COMPLETED" | "CANCELLED"
  storeId?: string
  cancelledReason?: string (required by service when CANCELLED)
  note?: string
}

AddOrderPaymentRequest {
  orderId: string
  method: "CASH" | "BANK_TRANSFER" | "CARD" | "OTHER"
  amount: number (>0)
  reference?: string
  note?: string
  idempotencyKey: UUIDv4 (required)
}

VoidOrderRequest { orderId: string }

GetOrderOverviewRequest {
  orgId: string
  searchString?: string
  status?: OrderStatus
  paymentStatus?: "UNPAID" | "PARTIAL" | "PAID"
  page?: number
  limit?: number
  fromDate?: string
  toDate?: string
  saleChannel?: "SHOP" | "ECOMMERCE"
  storeId?: string
  customerId?: string
  customerType?: "WALK_IN" | "CUSTOMER"
  customerSearch?: string
  minTotalAmount?: number
  maxTotalAmount?: number
}

// Response shapes (mirrored 1:1 into mobile models)
OrderResponse {
  id, orgId, orderNumber
  status, paymentStatus
  customerId?, customerName?, customerPhone?, note?
  subtotal, discountType?, discountValue?, discountAmount
  taxRateId?, taxAmount
  totalAmount, paidAmount, changeAmount
  storeId?, storeName?
  fulfilledAt?, fulfilledBy?
  createdAt, updatedAt, createdBy
  items: OrderItemResponse[]
  payments: OrderPaymentResponse[]
  itemCount, saleChannel
}

OrderOverviewResponse {
  id, orgId, orderNumber
  status, paymentStatus
  customerName?
  totalAmount, paidAmount, itemCount
  createdAt
  saleChannel, storeId?, storeName?
}
```

### 2.3 Known BE behaviors

- **CreateOrder returns HTTP 201**, not 200. Repository must accept both (mirrors `CreateStore` 201 caveat from CLAUDE.md).
- **AddOrderPayment returns HTTP 201**.
- `error.message` for 400 is user-readable — surface verbatim.
- `cancelledReason` is **required by service** (not by Zod) when `status === "CANCELLED"`. Mobile enforces in UI before submitting.
- `idempotencyKey` must be UUIDv4 (Zod rejects other formats).
- Order has **two independent statuses**: order status (DRAFT/PENDING/COMPLETED/CANCELLED) and payment status (UNPAID/PARTIAL/PAID). Both surface in UI as separate badges.

## 3. Decisions

| #  | Decision                                                                 | Rationale |
|----|--------------------------------------------------------------------------|-----------|
| 1  | Top-level module location: `lib/features/orders/`                        | Orders are a separate domain — not under Catalog. Sibling to settings/etc. |
| 2  | Bottom-nav tab order: Home / Catalog / Orders / Settings (4 tabs)       | Orders is core workflow, needs first-class entry. "+" FAB stays as POS placeholder (untouched). |
| 3  | Codegen `lib/api/order/` from `order.openapi.json`; hand-build bodies   | Same pattern as Brand/Category/Product. Wire transport, Zod = contract. |
| 4  | Create flow approach: cart-as-screen + add-product `KModalSheet`        | Approach C. Uses already-shipped flat-design idioms. Scales to long carts on phone. |
| 5  | Customer attach via text inputs only (no picker)                         | Customer module doesn't exist on mobile yet. BE accepts `customerName` + `customerPhone` as free text. Upgrade to picker when Customer module ships. |
| 6  | Tax via manual % input (no `taxRateId`)                                  | Tax module doesn't exist on mobile. Compute tax client-side from `manualTaxPercent`. Send no `taxRateId` to BE. Upgrade when Tax module ships. |
| 7  | Save-as-draft path included in Create screen                             | Lets staff create unpaid orders ahead of payment. Two paths: "Save as draft" + "Pay". |
| 8  | Refund deferred to v2                                                    | Refund needs method + reason + partial vs full + idempotency edge cases. Out of v1 scope. |
| 9  | Item editing post-create deferred                                         | Workaround = void + recreate. AddOrderItem/UpdateOrderItem/DeleteOrderItem unused in v1. |
| 10 | Idempotency: notifier holds UUIDv4, retries reuse                        | Per-call regen would create duplicate orders on retry. Notifier-scoped key cleared on success. |
| 11 | Money: VND, no decimals; discount %: one decimal max                    | Matches Vietnamese-locale UX. Use `intl` `NumberFormat`. |
| 12 | No draft persistence to disk                                              | Cart lives in Riverpod state. Backgrounded app may retain in-memory; explicit pop clears. Revisit if user reports loss. |

## 4. Navigation + routing

```
Bottom shell tabs:
├── /home       → HomeStubScreen
├── /catalog    → CatalogLauncherScreen
├── /orders     → OrderListScreen                  (NEW tab)
│   ├── /orders/new   → OrderCreateScreen          (full-screen push, outside shell)
│   └── /orders/:id   → OrderDetailScreen          (full-screen push, outside shell)
└── /settings   → SettingsScreen
```

### 4.1 Router edits (`lib/app/router.dart`)

- Add Orders branch to the `StatefulShellRoute.indexedStack` branches list (4th branch, between Catalog and Settings).
- Add `/orders/new` + `/orders/:id` as **top-level** `GoRoute`s (not nested in the shell) so they get full-screen presentation w/o the bottom nav.
- The auth-state redirect already gates these paths under "must have a session + at least one org".

### 4.2 `MainShell` + `KuruBottomNav` edits

- Add 4th `KuruBottomNavItem`: icon = `TablerIcons.receipt` (or `shopping_cart`), label = `l.navOrders` (new ARB key).
- `KuruBottomNav` layout should already handle 4 tabs — verify equal spacing. If 4 tabs degrade the visual, fall back to scrollable tab strip.
- "+" floating action **unchanged** (still POS placeholder snackbar).

### 4.3 New ARB keys (vi + en mirror)

```
navOrders              "Đơn hàng"     / "Orders"
orderListTitle         "Đơn hàng"     / "Orders"
orderListEmpty         "Chưa có đơn"  / "No orders yet"
orderListEmptyCta      "Tạo đơn đầu tiên" / "Create first order"
orderCreateTitle       "Đơn mới"      / "New order"
orderDetailTitle       "Chi tiết đơn" / "Order details"
// + status labels, payment status labels, method labels, action labels, errors
// Full ARB diff lives in the plan, not this spec.
```

## 5. Module structure

```
lib/api/order/                            ─ generated dart-dio (kuru_order_api sub-pkg)

lib/features/orders/
├── data/
│   └── order_repository.dart
├── models/
│   ├── order_summary.dart                ─ list-row VM
│   ├── order_detail.dart                 ─ detail VM
│   ├── order_line_item.dart              ─ cart line / detail line
│   ├── order_payment.dart                ─ payment row
│   ├── order_status.dart                 ─ enum + fromWire/toWire/label/color
│   ├── order_payment_status.dart         ─ enum
│   ├── order_payment_method.dart         ─ enum
│   ├── order_sale_channel.dart           ─ enum
│   ├── discount_type.dart                ─ enum (shared line + order)
│   ├── order_overview_page.dart          ─ paginated result
│   ├── order_list_filters.dart           ─ UI filter state
│   ├── order_cart_draft.dart             ─ in-memory create state
│   └── order_cart_totals.dart            ─ pure-fn totals + result type
├── providers/
│   ├── order_repository_provider.dart
│   ├── order_filters_provider.dart       ─ search/status/paymentStatus/dateRange/page
│   ├── order_list_provider.dart          ─ paginated, filterable
│   ├── order_list_accumulator_provider.dart  ─ infinite-scroll buffer
│   ├── order_detail_provider.dart        ─ family(orderId)
│   ├── order_cart_provider.dart          ─ mutable cart notifier
│   └── order_cart_totals_provider.dart   ─ derived totals
├── widgets/
│   ├── order_list_row.dart
│   ├── order_status_badge.dart
│   ├── order_payment_status_badge.dart
│   ├── order_filter_sheet.dart
│   ├── cart_line_row.dart
│   ├── add_line_sheet.dart
│   ├── product_search_results.dart
│   └── order_payment_sheet.dart
├── order_list_screen.dart
├── order_detail_screen.dart
└── order_create_screen.dart

test/features/orders/
├── data/order_repository_test.dart
├── models/
│   ├── order_summary_test.dart
│   ├── order_detail_test.dart
│   ├── order_line_item_test.dart
│   ├── order_payment_test.dart
│   ├── order_status_test.dart
│   ├── order_cart_totals_test.dart
│   └── ... (one per model)
├── providers/
│   └── order_cart_provider_test.dart
├── widgets/
│   ├── add_line_sheet_test.dart
│   ├── order_payment_sheet_test.dart
│   └── order_status_badge_test.dart (golden)
├── order_list_screen_test.dart
├── order_detail_screen_test.dart
└── order_create_screen_test.dart
```

## 6. Data models

All models are freezed + json_serializable, one file each, with JSON round-trip tests. Enum types include `fromWire(String)`, `toWire()`, `.label(BuildContext)` (i18n), and `.color(BuildContext)` (theme-driven badge color).

### 6.1 Enums

```dart
enum OrderStatus { draft, pending, completed, cancelled }
// wire: "DRAFT" | "PENDING" | "COMPLETED" | "CANCELLED"

enum OrderPaymentStatus { unpaid, partial, paid }
// wire: "UNPAID" | "PARTIAL" | "PAID"

enum OrderPaymentMethod { cash, bankTransfer, card, other }
// wire: "CASH" | "BANK_TRANSFER" | "CARD" | "OTHER"

enum OrderSaleChannel { shop, ecommerce }
// wire: "SHOP" | "ECOMMERCE"; default shop

enum DiscountType { percentage, fixed }
// wire: "PERCENTAGE" | "FIXED"
```

Unknown wire value → log warning + return default (status → draft, paymentStatus → unpaid, method → other, channel → shop). Never throw on unknown enum.

### 6.2 `OrderSummary` (list row)

Mirrors BE `OrderOverviewResponse`:

```dart
@freezed
class OrderSummary with _$OrderSummary {
  const factory OrderSummary({
    required String id,
    required String orgId,
    required String orderNumber,
    required OrderStatus status,
    required OrderPaymentStatus paymentStatus,
    String? customerName,
    required double totalAmount,
    required double paidAmount,
    required int itemCount,
    required DateTime createdAt,
    required OrderSaleChannel saleChannel,
    String? storeId,
    String? storeName,
  }) = _OrderSummary;
}
```

### 6.3 `OrderLineItem`

Mirrors `OrderItemResponse`; `id`/`orderId` null in cart state, set after server response:

```dart
@freezed
class OrderLineItem with _$OrderLineItem {
  const factory OrderLineItem({
    String? id,
    String? orderId,
    required String productId,
    String? variantId,
    required String productName,
    String? variantName,
    String? imageUrl,
    String? barcode,
    required String baseUnitCode,
    required double qty,
    required double unitPrice,
    DiscountType? discountType,
    double? discountValue,
    @Default(0) double discountAmount,
    @Default(0) double totalAmount,
  }) = _OrderLineItem;
}
```

### 6.4 `OrderPayment`

```dart
@freezed
class OrderPayment with _$OrderPayment {
  const factory OrderPayment({
    required String id,
    required String orderId,
    required OrderPaymentMethod method,
    required double amount,
    String? reference,
    String? note,
    required DateTime paidAt,
  }) = _OrderPayment;
}
```

### 6.5 `OrderDetail`

Full mirror of `OrderResponse`:

```dart
@freezed
class OrderDetail with _$OrderDetail {
  const factory OrderDetail({
    required String id,
    required String orgId,
    required String orderNumber,
    required OrderStatus status,
    required OrderPaymentStatus paymentStatus,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? note,
    required double subtotal,
    DiscountType? discountType,
    double? discountValue,
    @Default(0) double discountAmount,
    String? taxRateId,
    @Default(0) double taxAmount,
    required double totalAmount,
    @Default(0) double paidAmount,
    @Default(0) double changeAmount,
    String? storeId,
    String? storeName,
    DateTime? fulfilledAt,
    String? fulfilledBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String createdBy,
    @Default([]) List<OrderLineItem> items,
    @Default([]) List<OrderPayment> payments,
    required int itemCount,
    required OrderSaleChannel saleChannel,
  }) = _OrderDetail;
}
```

### 6.6 `OrderOverviewPage`

```dart
@freezed
class OrderOverviewPage with _$OrderOverviewPage {
  const factory OrderOverviewPage({
    required List<OrderSummary> orders,
    required int total,
    required int page,
    required int limit,
  }) = _OrderOverviewPage;
}
```

### 6.7 `OrderListFilters` (UI state)

```dart
@freezed
class OrderListFilters with _$OrderListFilters {
  const factory OrderListFilters({
    String? search,
    OrderStatus? status,
    OrderPaymentStatus? paymentStatus,
    DateTime? fromDate,
    DateTime? toDate,
    OrderSaleChannel? saleChannel,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _OrderListFilters;
}
```

### 6.8 `OrderCartDraft` (create-screen in-memory state)

```dart
@freezed
class OrderCartDraft with _$OrderCartDraft {
  const factory OrderCartDraft({
    @Default([]) List<OrderLineItem> items,
    String? customerName,
    String? customerPhone,
    String? note,
    DiscountType? discountType,
    double? discountValue,
    double? manualTaxPercent,
    @Default(OrderSaleChannel.shop) OrderSaleChannel saleChannel,
    String? idempotencyKey,           // set on first submit, cleared on success
  }) = _OrderCartDraft;
}
```

### 6.9 `OrderCartTotals` (derived)

Pure function `computeOrderCartTotals(OrderCartDraft) → OrderCartTotals`:

```dart
@freezed
class OrderCartTotals with _$OrderCartTotals {
  const factory OrderCartTotals({
    required double subtotal,            // sum of line totals (post line-discount)
    required double orderDiscountAmount, // % or fixed against subtotal, capped
    required double taxAmount,           // manualTaxPercent applied to (subtotal - orderDiscount)
    required double total,               // subtotal - orderDiscount + taxAmount
  }) = _OrderCartTotals;
}
```

Compute rules:
- Line discount: `qty * unitPrice` is the base; % is `value / 100 * base`, fixed is `min(value, base)`.
- Line total: `qty * unitPrice - lineDiscountAmount`.
- Subtotal: sum of all line totals.
- Order discount: % is `value / 100 * subtotal`, fixed is `min(value, subtotal)`.
- Tax: `(subtotal - orderDiscount) * manualTaxPercent / 100`, capped at 0 minimum.
- Total: `subtotal - orderDiscount + taxAmount`, never negative.

## 7. Repository

`lib/features/orders/data/order_repository.dart`. Constructor takes generated `OrdersApi`, `Dio`, `Logger`, and an injectable `String Function() uuidFactory` (for test determinism, default `() => Uuid().v4()`).

Methods (all `async`, throw typed `ApiException` on failure):

```dart
Future<OrderOverviewPage> getOrderOverview({
  required String orgId,
  required OrderListFilters filters,
});

Future<OrderDetail> getOrderById(String orderId);

Future<String> createOrder({
  required String orgId,
  required String idempotencyKey,
  required OrderCartDraft draft,
  OrderPaymentInput? payment,
});  // returns new orderId

Future<void> updateOrderStatus({
  required String orderId,
  required OrderStatus status,
  String? cancelledReason,    // required by service if status == cancelled
  String? note,
});

Future<String> addOrderPayment({
  required String orderId,
  required String idempotencyKey,
  required OrderPaymentMethod method,
  required double amount,
  String? reference,
  String? note,
});  // returns paymentId

Future<void> voidOrder({required String orderId});
```

### 7.1 Body construction rules

- Always hand-built `Map<String, dynamic>` (Zod is the contract).
- Optional fields included only when non-null AND (for strings) non-empty after trim.
- `idempotencyKey` passed in from caller — repo does not generate (caller manages retry semantics).
- `customerName` / `customerPhone` / `note` trimmed before send.
- `payment.amount` and discount values sent as plain `double` (BE accepts JSON numbers).

### 7.2 Response parsing

- 200 OR 201 both treated as success (mirrors CLAUDE.md CreateStore note).
- Envelope: `{ success: true, data: ..., timestamp: ... }` → return `.data`.
- Envelope error: `{ success: false, error: { message, code }, ... }` → translated by dio interceptor to `ApiException` already.

### 7.3 Logging

Every endpoint logs entry + outcome via `log` (package:logger):
- `→ Order.CreateOrder orgId=... items=N total=...`
- `← Order.CreateOrder 201 orderId=...`
- `← Order.CreateOrder 400 message=...`

## 8. Providers

All `riverpod_annotation`-generated. Files mirror the module structure (one provider per file).

### 8.1 Singletons + derived

```dart
@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) =>
  OrderRepository(
    api: ref.watch(ordersApiProvider),
    dio: ref.watch(dioProvider),
    log: log,
  );
```

### 8.2 List filters + paginated fetch

```dart
@riverpod
class OrderFilters extends _$OrderFilters {
  @override OrderListFilters build() => const OrderListFilters();
  void setSearch(String? s)                  { state = state.copyWith(search: s, page: 1); }
  void setStatus(OrderStatus? s)             { state = state.copyWith(status: s, page: 1); }
  void setPaymentStatus(OrderPaymentStatus? s) { state = state.copyWith(paymentStatus: s, page: 1); }
  void setDateRange(DateTime? from, DateTime? to) { state = state.copyWith(fromDate: from, toDate: to, page: 1); }
  void setSaleChannel(OrderSaleChannel? c)   { state = state.copyWith(saleChannel: c, page: 1); }
  void nextPage()                            { state = state.copyWith(page: state.page + 1); }
  void reset()                               { state = const OrderListFilters(); }
}

@riverpod
Future<OrderOverviewPage> orderList(OrderListRef ref) async {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) throw const NoOrgSelectedException();
  final filters = ref.watch(orderFiltersProvider);
  return ref.watch(orderRepositoryProvider).getOrderOverview(
    orgId: orgId,
    filters: filters,
  );
}
```

Infinite scroll: a separate `OrderListAccumulator` notifier holds the appended `List<OrderSummary>` across pages and resets when filters (other than `page`) change. Subscribes to `orderListProvider`'s `.future` to append each page.

### 8.3 Detail

```dart
@riverpod
Future<OrderDetail> orderDetail(OrderDetailRef ref, String orderId) =>
  ref.watch(orderRepositoryProvider).getOrderById(orderId);
```

### 8.4 Cart (create screen)

```dart
@riverpod
class OrderCart extends _$OrderCart {
  @override OrderCartDraft build() => const OrderCartDraft();

  void addLine(OrderLineItem item);          // merges same (productId, variantId) by summing qty; clears idempotencyKey
  void updateLineAt(int index, OrderLineItem item); // clears idempotencyKey
  void removeLineAt(int index);              // clears idempotencyKey
  void setCustomer({String? name, String? phone}); // clears idempotencyKey
  void setNote(String? note);                // clears idempotencyKey
  void setOrderDiscount(DiscountType? type, double? value); // clears idempotencyKey
  void setManualTaxPercent(double? pct);     // clears idempotencyKey
  void setSaleChannel(OrderSaleChannel c);   // clears idempotencyKey
  void ensureIdempotencyKey(String Function() factory); // sets if null; never overwrites
  void clear();                              // resets entire draft including key
}

@riverpod
OrderCartTotals orderCartTotals(OrderCartTotalsRef ref) =>
  computeOrderCartTotals(ref.watch(orderCartProvider));
```

### 8.5 Mutations

Mutations are **imperative methods called from screen actions** (not wrapped in providers). After success:

```dart
ref.invalidate(orderListProvider);
ref.invalidate(orderListAccumulatorProvider);
ref.invalidate(orderDetailProvider(orderId));  // if detail visible
```

This mirrors the existing `lib/features/catalog/products/` pattern.

## 9. Screens

### 9.1 Order List Screen — `/orders`

Layout (top to bottom):

1. `KPageHeader` — title "Đơn hàng", trailing `KIconBtn` (filter icon) → opens `order_filter_sheet`.
2. `KSearchBar` (sticky) — debounced 300ms → `OrderFilters.setSearch`.
3. `KTabNav` (scrollable pill tabs) — `All / Draft / Pending / Completed / Cancelled` → `OrderFilters.setStatus`.
4. **Active-filter chip strip** — renders when payment status / date range / sale channel set. Each chip = label + clear button.
5. **List body**:
    - Loading first page → `KSkeleton` placeholders (5 rows).
    - Empty → `KEmptyState` (different copy for "no orders ever" vs "no matches for filters") with optional CTA "+ Create order".
    - Populated → `ListView` of `OrderListRow` (uses `KListRow`):
       - Leading: nothing (no thumbnail) — or small icon for channel (shop / ecom).
       - Title: order number (`#A-1234`).
       - Subtitle: `customerName ?? l.orderWalkIn` + " • " + `itemCount items` + " • " + relative date.
       - Trailing column: total amount (bold) + `OrderStatusBadge` + `OrderPaymentStatusBadge` (small).
6. **Pagination**: infinite scroll. `ScrollController.position.atEdge` + `pixels > 0` → `OrderFilters.nextPage()`. `OrderListAccumulator` appends.
7. **Pull-to-refresh**: `ref.invalidate(orderListProvider)` + accumulator reset.
8. **FAB**: `FloatingActionButton.extended` (or `KPrimaryBtn` in footer) — "+ Đơn mới" → `context.push('/orders/new')`.

Error handling:
- 401 → `KNotify.info("Session expired")` + `signOut()`.
- 5xx → `KNotify.networkError(retry: () => ref.invalidate(orderListProvider))`.

### 9.2 Order Detail Screen — `/orders/:id`

Layout (vertical scroll):

1. App bar: back, title = `#orderNumber`, trailing overflow `KPopupMenu` → action items (Cancel / Void), each enabled per the matrix below.
2. **Header card** (`Card`, M3 18-radius):
    - Row of badges: `OrderStatusBadge` + `OrderPaymentStatusBadge`.
    - Total amount large (24sp).
    - `paidAmount` + `changeAmount` small grey line underneath (if non-zero).
    - `createdAt` formatted + `createdBy` (display name if resolvable, else id).
    - `storeName` if present.
3. **Customer section** (only if `customerName` or `customerPhone` non-null):
    - Icon + name + phone. Tap phone → `launchUrl(Uri.parse("tel:..."))`.
4. **Items section** — list of read-only line rows: thumbnail + name + variant + `qty × unitPrice = totalAmount`. Discount badge if line has discount.
5. **Summary card** — Subtotal / Order discount (if any) / Tax (if any) / Total.
6. **Payments section** — list of `OrderPayment` rows: method icon + amount + reference + paidAt. Footer button `KSecondaryBtn` "+ Add payment" → opens `order_payment_sheet` (reused from create screen) **if** `paymentStatus != paid && status != cancelled`.
7. **Note** (if present) — italicized block.
8. **Footer** (pinned): `KPrimaryBtn` "Mark completed" if `status == pending && paymentStatus == paid`. Hidden otherwise.

Action matrix (encoded in widget visibility/enabled state):

| Order status | + Payment | Cancel | Void | Mark completed |
|--------------|-----------|--------|------|----------------|
| DRAFT        | ✓         | ✓      | ✗    | ✗              |
| PENDING      | ✓         | ✓      | ✗    | only if paid   |
| COMPLETED    | ✗         | ✗      | ✓    | ✗              |
| CANCELLED    | ✗         | ✗      | ✗    | ✗              |

Action UX:
- **Cancel order**: `showKConfirmDialog` with required `KTextField` "Reason" (min 1 char). Button disabled until non-empty. Confirm → `updateOrderStatus(CANCELLED, cancelledReason: reason)`.
- **Void**: `showKConfirmDialog` (no reason field). Confirm → `voidOrder`.
- **Add payment**: `showKModalSheet` with payment form (method dropdown, amount `KTextField` defaulted to outstanding, reference, note). Confirm → `addOrderPayment`.
- **Mark completed**: inline `showKConfirmDialog` "Mark as completed?". Confirm → `updateOrderStatus(COMPLETED)`.

After any mutation:
- Invalidate `orderDetailProvider(orderId)` + `orderListProvider` + accumulator.
- Show `KNotify.success("Đã cập nhật")`.

404 → `KEmptyState` "Order not found" with back CTA.

### 9.3 Order Create Screen — `/orders/new`

Layout (vertical scroll, single screen, no steps):

1. App bar: back (with unsaved-cart `showKConfirmDialog` if `items.isNotEmpty`), title "Đơn mới", trailing `KIconBtn` "Clear cart" (only when non-empty).
2. **Cart section**:
    - Empty state: illustration + `KSecondaryBtn` "+ Thêm sản phẩm" (opens `add_line_sheet`).
    - Non-empty: list of `CartLineRow`:
       - Image + name + variant
       - `qty × unitPrice = totalAmount` line
       - Trailing: inline `−`/qty number/`+` stepper. Tap the row body (not the stepper) → opens `add_line_sheet` in edit mode pre-filled.
       - Swipe-to-remove (Dismissible) OR overflow menu w/ Remove action.
    - Below list: `KSecondaryBtn` "+ Thêm sản phẩm khác".
3. **Customer section** (always visible, optional fields):
    - `KTextField` "Khách hàng" (optional text).
    - `KTextField` "Số điện thoại" (optional, `keyboardType: TextInputType.phone`, no validation per BE — it's free text).
4. **Note section**:
    - `KTextField` "Ghi chú" (optional, multiline, max 3 lines visible).
5. **Order-level adjustments**:
    - Order discount: `KSelect` (None / % / Fixed) + amount `KTextField` (shown only when type ≠ none).
    - Manual tax %: `KTextField` (number, range 0–100, optional).
6. **Totals card** (computed live from `orderCartTotalsProvider`):
    - Subtotal
    - Order discount (if any, negative)
    - Tax (if any)
    - **Total** (bold, 22sp)
7. **Footer** (pinned, safe-area aware) — two buttons side by side:
    - `KSecondaryBtn` "Lưu nháp" (Save as draft) — disabled if cart empty.
    - `KPrimaryBtn` "Thanh toán" (Pay) — disabled if cart empty. Opens `order_payment_sheet`.

**Submit flow**:

- **Save as draft**:
   1. Cart notifier `ensureIdempotencyKey(uuid.v4)`.
   2. Repo `createOrder(orgId, idempotencyKey, draft, payment: null)`.
   3. On success: `KNotify.success("Đã lưu nháp")`, invalidate list, clear cart, `context.go('/orders/$newId')`.
   4. On 400: `KNotify.warning(error.message)`, key retained, cart kept.

- **Pay**:
   1. Cart notifier `ensureIdempotencyKey`.
   2. Open `order_payment_sheet` w/ defaults (method = cash, amount = total).
   3. On confirm: repo `createOrder(orgId, idempotencyKey, draft, payment: input)`.
   4. Same success path as draft.

### 9.4 `add_line_sheet` — bottom sheet

`showKModalSheet`. Two-stage flow inside one sheet:

**Stage 1 — search**:
- Header: `KSearchBar` (autofocus on open). Debounced 250ms.
- Body: `productSearchResultsProvider(query)` → list of product rows. Each row: thumbnail + name + base unit price + variant count. Tap → if has variants, go to variant picker (radio chips); else jump straight to stage 2.

**Stage 2 — line editor**:
- Read-only product header (image + name + variant).
- Qty stepper (− / number input / +) — defaults to 1, min 0.001 (allow decimal qty per BE schema).
- Unit price editable `KTextField` — defaults to the price returned in the search result (variant `salePrice` if variant selected, else product base price). Sheet never makes an extra `getProductById` call.
- Line discount: `KSelect` (None / % / Fixed) + amount field.
- Footer: `KPrimaryBtn` "Thêm vào đơn" (or "Cập nhật" in edit mode) → `OrderCart.addLine` or `updateLineAt` → sheet closes.

Edit mode: caller passes existing `OrderLineItem` + index. Sheet skips stage 1, opens directly at stage 2 pre-filled.

### 9.5 `order_payment_sheet` — bottom sheet

`showKModalSheet` with `loadingBody` while submit awaits.

- Title "Thanh toán".
- Method `KSelect` — Cash / Bank transfer / Card / Other. Default cash.
- Amount `KTextField` — number, defaults to `cartTotals.total`.
- Reference `KTextField` — optional.
- Note `KTextField` — optional.
- Confirm button: callback to caller (either `createOrder` w/ payment or `addOrderPayment` for detail-screen reuse).

Sheet does not own the network call — caller passes `Future<void> Function(OrderPaymentInput)` so it can be reused by Create screen + Detail-screen add-payment.

### 9.6 `order_filter_sheet` — bottom sheet

`showKModalSheet`. Fields:
- Payment status: `KSelect` (All / Unpaid / Partial / Paid).
- Sale channel: `KSelect` (All / Shop / Ecommerce).
- Date range: from + to date pickers (`showDatePicker` or inline date wheel).
- Footer: "Apply" → `OrderFilters` setters. "Reset" → `OrderFilters.reset()`.

## 10. Error handling

Per CLAUDE.md BE contract:

| HTTP | code              | UI behavior |
|------|-------------------|-------------|
| 400  | (any)             | `KNotify.warning(error.message)`. Form-level errors land in `KFormField.errorText`. |
| 401  | (any)             | `KNotify.info("Session expired")` + `signOut()` + redirect to /login. |
| 403  | (any)             | `KNotify.warning(error.message)`. Disable triggering action button. |
| 404  | (detail only)     | `KEmptyState` "Order not found" w/ back CTA. |
| 429  | `RATE_LIMITED`    | `KNotify.warning("Try again in a moment")`. Disable button 2s. |
| 500  | "Session does not exist" body | Treat as 401 (BE bug — mirror `AuthRepository._interpretMfaError`). |
| 5xx  | (other)           | `KNotify.networkError("Đã có lỗi xảy ra", retry: <invalidator>)`. |

## 11. Idempotency

`OrderCartDraft.idempotencyKey` lives on the cart notifier:
- Generated lazily on first submit attempt (Save draft or Pay).
- Retained across retries of the same submit (same key → BE dedupes).
- Cleared when:
   - Submit succeeds (cart wiped).
   - User explicitly clears cart.
   - User edits the cart materially (line add/remove/change) → invalidate the key so a new submission gets a fresh one. Rationale: if the user changed the cart, they want a new order, not a retry of the previous attempt.

Add-payment sheet on Detail screen owns its own key (sheet-scoped):
- Generated on sheet open.
- Reused across retries within the sheet.
- Cleared on sheet close.

## 12. Cart edge cases

- Same `(productId, variantId)` added twice → merge into existing line by summing `qty`.
- Edit qty to 0 → auto-remove on confirm.
- Negative unit price or qty rejected at input level (field validation).
- Line discount cap: % capped at 100, fixed capped at `qty * unitPrice`.
- Order discount: % capped at 100, fixed capped at subtotal.
- Manual tax %: clamped to `[0, 100]`.
- Total never negative (capped at 0 — though BE wouldn't accept zero-amount orders anyway; surface as field error).
- Back-button w/ items in cart → `showKConfirmDialog` "Discard cart?" (Discard / Keep editing).
- Cart state in Riverpod is not persisted to disk (Decision #12).

## 13. Money + date formatting

- VND, no decimals: `NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0)`. Or symbol-suffix per Vietnamese convention — match what Settings/Catalog already uses.
- Discount % shown with up to 1 decimal: `NumberFormat.decimalPattern('vi_VN')` with `maximumFractionDigits: 1`.
- Created/updated dates: `DateFormat.yMMMd('vi_VN').add_Hm()`.
- Relative date on list rows: hand-rolled helper (`Hôm nay 13:42`, `Hôm qua 09:15`, `2 ngày trước`, fallback to absolute > 7d). Avoid the `timeago` package unless it's already a dependency.

## 14. Codegen

Add to `tool/codegen.sh`:

```bash
order)    echo "../gen-barcode/openapi/order.openapi.json" ;;
```

Plus add `order` to the `MODULES` default list.

Generated output lands in `lib/api/order/`. Apply the dart-dio library-version override fix from the `openapi-codegen` skill (this is done by codegen.sh already — verify on first run).

Add path-dep to root `pubspec.yaml`:

```yaml
  kuru_order_api:
    path: lib/api/order
```

## 15. Testing

Target ~65 new tests. Existing suite is 136; target ~200 after Order ships.

### 15.1 Unit tests

- **Models** (`test/features/orders/models/`): one file per model. JSON round-trip + enum `fromWire`/`toWire` exhaustive coverage. Unknown enum value → default + log warning (test the default, not the log).
- **`order_cart_totals_test.dart`**: table-driven, ~12 cases covering empty cart / single line / line discount % / line discount fixed > base (cap) / order % discount / order fixed discount / tax math / discount + tax composition / over-100% discount (cap) / over-100% tax (cap) / negative inputs (clamped).
- **`order_repository_test.dart`** (mock `Dio` via mocktail): per method —
   - Builds correct body (only non-null fields included after trim).
   - Builds correct query params (filters → query string).
   - Parses 200 success envelope.
   - Parses 201 (CreateOrder, AddOrderPayment).
   - Throws `BadRequestException(message)` on 400 envelope.
   - Throws `UnauthorizedException` on 401.
   - Throws `NotFoundException` on 404 (detail only).
   - `cancelledReason` only sent when status == CANCELLED.
   - UUID injection: pass a fixed factory, assert that value lands in body.

### 15.2 Provider tests

- **`order_cart_provider_test.dart`**: addLine merges same product+variant; updateLineAt / removeLineAt; ensureIdempotencyKey generates once and is stable; clear resets all; material edits invalidate idempotencyKey.

### 15.3 Widget tests

- **`order_list_screen_test.dart`**: skeletons → rows; empty state; status tab change updates filter; search debounce (300ms before fetch fires); tap row → router push `/orders/:id`; 5xx → `KNotify.networkError` + retry callback; pull-to-refresh.
- **`order_detail_screen_test.dart`**: header / customer / items / payments / actions render for each of 4 statuses; action matrix enforcement (each status renders correct enabled/disabled/hidden buttons); mark-completed flow; cancel flow w/ reason validation; add-payment flow; 404 → empty state.
- **`order_create_screen_test.dart`**: empty cart → CTA + buttons disabled; add line via sheet; same product twice → qty sums; tap line → edit-mode sheet pre-filled; qty=0 → line removed on confirm; totals reflect math; back w/ items → discard dialog; Save-as-draft → repo called w/o payment; Pay → opens sheet → repo called w/ payment; 400 → warning + cart retained + key retained.
- **`widgets/add_line_sheet_test.dart`**: search query triggers `productSearchResultsProvider`; product w/o variants skips picker; product w/ variants blocks confirm until selected; edit mode pre-fills + button label "Update".
- **`widgets/order_payment_sheet_test.dart`**: defaults amount to total; method dropdown enumerates 4 values; submit triggers caller callback w/ correct payload; loading state during await.
- **`widgets/order_status_badge_test.dart`** (golden): 4 statuses × 3 payment statuses × light/dark × indigo/purple → small golden grid (or trimmed key combinations only).

### 15.4 Test harness rules

- No `pumpAndSettle()` anywhere `KPrimaryBtn` / `KSpinner` / `KSkeleton` / `KModalSheet` confirm-spinner present. Use `pump()` + `pump(Duration(milliseconds: 50))`.
- Inject `uuidFactory` into `OrderRepository` for deterministic UUIDs in tests.
- Override `appBootstrapProvider` w/ `BootstrapAuthed(user)` per CLAUDE.md.
- Override `orderRepositoryProvider` w/ `_FakeOrderRepository` (mocktail) in screen tests.
- Fixed clock (`Clock.fixed`) for relative-date assertions.

## 16. Open follow-ups (post-merge)

- Hook Orders into Home screen overview when that lands (KPI card + recent orders list).
- Wire Customer module → upgrade text inputs to a customer picker bottom sheet.
- Wire Tax module → swap manual % for `taxRateId` picker.
- Wire Store module → add store picker if/when org has multiple stores.
- Build POS module as a separate flow on top of `OrderRepository.createOrder` + barcode scan widget.
- Implement Refund flow + UI.
- Implement edit-after-create flow (AddOrderItem / UpdateOrderItem / DeleteOrderItem) if real usage demands it.
- Decide whether to persist cart draft to disk (e.g., crash recovery for long carts).
