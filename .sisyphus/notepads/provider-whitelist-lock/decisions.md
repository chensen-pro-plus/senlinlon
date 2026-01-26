# Architectural Decisions

## Key Decisions

(Will be populated as tasks are executed)

## [2026-01-26] Key Architectural Decisions

### 1. Provider Injection Before Config Loading
**Decision**: Inject DEFAULT_PROVIDERS into database BEFORE processing user's config.provider
**Rationale**: Ensures our hardcoded providers exist first, then user config can only modify apiKey
**Location**: Line 768 in state() function, before line 829 (configProviders)

### 2. Force baseURL Override After All Loading
**Decision**: Apply whitelist filtering AFTER all provider loading is complete
**Rationale**: Let the system load naturally, then enforce our rules at the end
**Location**: Lines 1076-1109, right before return statement

### 3. Skip Instead of Error on Missing apiKey
**Decision**: Skip providers without apiKey with log.info, don't throw error
**Rationale**: Better UX - user can configure only the keys they need
**Location**: Lines 774-777

### 4. Two-Stage Provider Check
**Decision**: First check whitelist, then check baseURL domain
**Rationale**: Fast rejection of unauthorized providers, then validate our own providers
**Location**: Lines 1081-1107

### 5. Simplified defaultModel()
**Decision**: Remove complex provider selection, use DEFAULT_MODEL directly
**Rationale**: We control all providers, no need for dynamic selection
**Impact**: Reduced function from 15 lines to 7 lines
