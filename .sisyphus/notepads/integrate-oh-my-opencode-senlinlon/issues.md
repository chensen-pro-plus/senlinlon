# Issues & Gotchas - integrate-oh-my-opencode-senlinlon

Session started: 2026-01-27T07:54:37.901Z

## Problems Encountered

(To be populated as work progresses)

## Workarounds Applied

(To be populated as work progresses)

## [2026-01-27T07:54:37Z] Task 7 - TypeCheck Failures

**Problem**: TypeScript compilation failing due to test file errors
**Error**: `ToolContext` type has evolved in opencode - now requires `metadata` and `ask` properties

**Affected Test Files**:
- `src/tools/session-manager/tools.test.ts`
- `src/tools/skill-mcp/tools.test.ts` (6 errors)
- `src/tools/skill/tools.test.ts` (8 errors)
- `../sdk/js/src/gen/client/client.gen.ts` (cannot find name 'BodyInit')

**Root Cause**: oh-my-opencode was developed against an older version of opencode's `@opencode-ai/plugin` package. The `ToolContext` interface has been updated.

**Action Required**: Update test mocks to include the new required properties
