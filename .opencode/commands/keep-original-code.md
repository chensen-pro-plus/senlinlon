---
description: 修改代码时保留原代码为注释
---

# 代码修改规则

修改任何代码时，必须：

1. **保留原代码为注释** - 不要删除原作者的代码，注释掉
2. **添加清晰的标记** - 使用注释标记修改的开始和结束
3. **说明修改原因** - 简要说明为什么修改

## 注释格式

```typescript
// ========== 二次开发修改: [修改目的] ==========
新代码...
// ========== 原作者代码 (已注释) ==========
// 原代码...
// 原代码...
// ========== 原作者代码结束 ==========
```

## 示例

```typescript
export async function defaultModel() {
  const cfg = await Config.get()
  if (cfg.model) return parseModel(cfg.model)

  // ========== 二次开发修改: 使用硬编码的默认模型 ==========
  return parseModel(DEFAULT_MODEL)
  // ========== 原作者代码 (已注释) ==========
  // const provider = await list()
  //   .then((val) => Object.values(val))
  //   .then((x) => x.find((p) => !cfg.provider || Object.keys(cfg.provider).includes(p.id)))
  // if (!provider) throw new Error("no providers found")
  // const [model] = sort(Object.values(provider.models))
  // if (!model) throw new Error("no models found")
  // return {
  //   providerID: provider.id,
  //   modelID: model.id,
  // }
  // ========== 原作者代码结束 ==========
}
```

## 新增代码

如果是新增代码（不是替换），只需标记：

```typescript
// ========== 二次开发新增: [功能说明] ==========
新增代码...
// ========== 新增结束 ==========
```
