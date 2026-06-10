# Expense Ticket Detail API Requirement

## Problem

Mobile expense ticket detail must show the real branch that imported the product.

The web voucher list gets this from:

```ts
linkedPurchaseEntries[].warehouses[]
```

Mobile detail currently calls:

```http
GET /api/v1/expense/GetExpenseEntry?id=<expenseEntryId>
```

This endpoint must return the same linked import warehouse data as `ListExpenseEntries`.
Do not solve this in mobile by guessing from `storeId`, UUID, or cached list row data.

## Required Response Shape

`GetExpenseEntry` response `entry` must include:

```json
{
  "entry": {
    "id": "expense-1",
    "source": "PUSHED",
    "storeId": null,
    "linkedPurchaseEntries": [
      {
        "id": "pe-1",
        "entryNumber": "PE-20260525-0001",
        "warehouses": [
          {
            "id": "warehouse-1",
            "name": "Chi nhánh Quận 1"
          }
        ]
      }
    ]
  }
}
```

Rules:

- `linkedPurchaseEntries[].id` is the import or purchase entry id.
- `linkedPurchaseEntries[].entryNumber` is the import code shown in UI.
- `linkedPurchaseEntries[].warehouses[]` is the distinct line warehouse or branch list for that import.
- For multi-branch import, return all distinct warehouses in stable order.
- If no linked import exists, return an empty array or omit the field.
- `storeId` is not enough for import expense tickets, especially multi-warehouse imports.

## Backend Implementation Notes

In `gen-barcode`, `ListExpenseEntries` already does the correct branch resolution:

```ts
const purchaseEntryIds = Array.from(new Set(
  page.flatMap(r => (r.paymentAllocations ?? [])
    .map(a => a.purchaseEntry?.id)
    .filter((id): id is string => Boolean(id))),
));

const branchesByEntry = purchaseEntryIds.length > 0
  ? (await purchaseRpc.getEntryBranches({ orgId, purchaseEntryIds })).branchesByEntry
  : {};

entries: page.map(row => toEntryResponse(row, branchesByEntry))
```

`GetExpenseEntry` should do the same for the single row:

1. Fetch the expense entry with `paymentAllocations.purchaseEntry`.
2. Collect linked purchase entry ids.
3. Call `purchaseRpc.getEntryBranches({ orgId, purchaseEntryIds })`.
4. Return `toEntryResponse(row, branchesByEntry)`.

Likely backend areas:

- `be/core/domains/expense/services/expense.service.ts`
- `be/core/domains/expense/repo/expense-entry.repo.ts`

`findById` likely needs the same include as `list`:

```ts
include: {
  paymentAllocations: {
    select: {
      id: true,
      purchaseEntry: { select: { id: true, entryNumber: true } },
    },
    orderBy: { createdAt: "asc" },
  },
}
```

Then `GetExpenseEntry` can pass the resolved branch map into `toEntryResponse`.

## Mobile Expectation

Mobile reads this field directly:

```dart
entry.linkedImportWarehousesDeduped
```

Detail scope display priority:

1. `linkedPurchaseEntries[].warehouses[].name`
2. `storeName` only as non-import fallback
3. `Org-wide` when no branch/import scope exists
4. `Chưa có tên` only when API has branch scope but sends no name

## Acceptance Criteria

- `GET /api/v1/expense/GetExpenseEntry?id=<vendor-payment-expense-id>` returns `linkedPurchaseEntries[0].warehouses[0].name`.
- Mobile expense detail shows `Chi nhánh ...`, not `Chưa có tên`.
- Mobile does not show the warehouse UUID as branch name.
- Import reference still opens `/import/<linkedPurchaseEntries[0].id>`.
- `ListExpenseEntries` behavior remains unchanged.

## Test Case

Create or use an import with product lines assigned to `Chi nhánh Quận 1`, then pay it with an expense voucher.

Expected `GetExpenseEntry` detail response:

```json
{
  "linkedPurchaseEntries": [
    {
      "id": "<purchaseEntryId>",
      "entryNumber": "PE-...",
      "warehouses": [
        {
          "id": "<warehouseId>",
          "name": "Chi nhánh Quận 1"
        }
      ]
    }
  ]
}
```

Expected mobile detail:

```text
Phạm vi: Chi nhánh Quận 1
Phiếu nhập liên quan: PE-...
```
