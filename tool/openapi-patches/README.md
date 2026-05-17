# OpenAPI patches

Per spec §3.1 / §9.2: when `../gen-barcode/openapi/<module>.openapi.json`
disagrees with the BE handler / `.d.ts` / service `resData`, copy the file
here and edit only the divergent shapes. The `tool/codegen.sh` script
auto-detects patched copies and uses them in place of upstream.

**Source-of-truth ordering (per CLAUDE.md):**
1. `be/core/dto/<module>/*.dto.ts` — request body validation
2. `be/core/domains/<domain>/api/<module>.route.ts` — handler
3. `be/types/<module>.d.ts` — generated TS response types
4. `be/core/domains/<domain>/services/<module>.service.ts` — `resData`
5. `openapi/<module>.openapi.json` — cross-check only

Never modify upstream openapi files in `../gen-barcode/` from this repo.
