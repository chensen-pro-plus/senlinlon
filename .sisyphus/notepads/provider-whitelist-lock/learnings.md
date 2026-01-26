# Learnings

## Code Patterns

(Will be populated as tasks are executed)

## [2026-01-26] Tasks 1 & 2 Complete

### Config Schema Extension
- Successfully added `claudeKey`, `geminiKey`, `gptKey` to `Config.Info` schema
- Fields are optional strings with descriptive messages
- Placed logically after `small_model` field
- Location: `packages/opencode/src/config/config.ts:930-932`

### DEFAULT_PROVIDERS Constants
- Added hardcoded provider configurations for my-claude, my-gemini, my-gpt
- Each provider has: npm, name, api, baseURL, configKey, models
- DEFAULT_MODEL: "my-claude/claude-opus-4-5-thinking"
- ALLOWED_DOMAINS: ["ccmaxhub.de5.net", "codexhub.de5.net"]
- Helper function `isAllowedBaseURL()` validates domain whitelist
- Location: `packages/opencode/src/provider/provider.ts:44-110`

### Verification
- Typecheck passes cleanly
- No conflicts with existing code
- Ready for Task 3 (provider injection)

## [2026-01-26] Task 5 Complete - All Tasks Finished

### defaultModel() Simplification
- Removed complex provider/model selection logic
- Now returns parseModel(DEFAULT_MODEL) as fallback
- User's cfg.model still takes precedence
- Location: `packages/opencode/src/provider/provider.ts:1344-1350`

## Implementation Summary

### What Was Built
1. **Config Schema Extension** (config.ts:930-932)
   - claudeKey, geminiKey, gptKey optional string fields
   - Allows user-friendly API key configuration

2. **Hardcoded Provider Definitions** (provider.ts:44-110)
   - DEFAULT_PROVIDERS with my-claude, my-gemini, my-gpt
   - Each has npm, name, api, baseURL, configKey, models
   - DEFAULT_MODEL: "my-claude/claude-opus-4-5-thinking"
   - ALLOWED_DOMAINS: ["ccmaxhub.de5.net", "codexhub.de5.net"]
   - isAllowedBaseURL() domain validator

3. **Provider Injection** (provider.ts:768-827)
   - Reads user apiKeys from config[configKey]
   - Skips providers without configured apiKey
   - Injects into database and providers with full Model structure
   - Uses user's apiKey with hardcoded baseURL

4. **Whitelist Filtering** (provider.ts:1076-1109)
   - Blocks all providers not in ALLOWED_PROVIDERS
   - Forces baseURL to hardcoded values (prevents override)
   - Validates baseURL domains against ALLOWED_DOMAINS
   - Deletes providers with invalid baseURL

5. **Default Model** (provider.ts:1344-1350)
   - Simplified to use DEFAULT_MODEL constant
   - Respects user's cfg.model if set

### Security Features
✅ Provider whitelist - only my-claude, my-gemini, my-gpt allowed
✅ baseURL lockdown - hardcoded, user cannot change
✅ Domain whitelist - only ccmaxhub.de5.net, codexhub.de5.net
✅ User-configurable apiKeys - simple top-level config

### User Experience
- User configures: { "claudeKey": "xxx", "geminiKey": "xxx", "gptKey": "xxx" }
- Configured providers automatically available
- No complex provider structure needed
- Cannot accidentally misconfigure baseURL or add unauthorized providers
