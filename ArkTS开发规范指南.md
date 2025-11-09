# ArkTS 开发规范指南

## 概述
本文档总结了HarmonyOS ArkTS语言的核心规范和限制，帮助开发者在项目开发过程中避免常见的编译错误。

## 🚫 核心禁用规则

### 1. 类型系统限制

#### 禁止使用的类型
- `any` 类型：完全禁止使用
- `unknown` 类型：不允许使用
- 索引签名：`[key: string]: T` 语法禁止
- 对象字面量类型：`{ name: string, age: number }` 内联类型定义禁止

#### ❌ 错误示例
```typescript
// 禁止使用any
let data: any = { name: "test" };

// 禁止使用索引签名
interface User {
  [key: string]: string; // ❌ 错误
}

// 禁止内联对象字面量类型
function processUser(user: { name: string, age: number }) { // ❌ 错误
  // ...
}
```

#### ✅ 正确做法
```typescript
// 定义明确的接口
interface User {
  name: string;
  age: number;
}

let data: User = { name: "test", age: 25 };

function processUser(user: User) { // ✅ 正确
  // ...
}
```

### 2. 循环语句限制

#### 禁止的循环方式
- `for...in` 循环：用于对象遍历时禁止
- `for...of` 循环：用于对象遍历时禁止

#### ❌ 错误示例
```typescript
const obj = { a: 1, b: 2, c: 3 };

// 禁止用于对象
for (const key in obj) { // ❌ 错误
  console.log(key, obj[key]);
}

for (const value of obj) { // ❌ 错误
  console.log(value);
}
```

#### ✅ 正确做法
```typescript
const obj = { a: 1, b: 2, c: 3 };

// 使用传统循环遍历对象键
const keys = Object.keys(obj);
for (let i = 0; i < keys.length; i++) {
  const key = keys[i];
  console.log(key, obj[key as keyof typeof obj]);
}

// 数组可以使用for...of
const arr = [1, 2, 3];
for (const item of arr) { // ✅ 数组可以使用
  console.log(item);
}
```

### 3. 属性访问限制

#### 禁止动态索引访问
- `obj[key]` 语法禁止
- 必须使用明确的属性名或类型安全的访问方式

#### ❌ 错误示例
```typescript
const user = { name: "张三", age: 25 };
const propertyName = "name";

// 禁止动态索引访问
const value = user[propertyName]; // ❌ 错误
```

#### ✅ 正确做法
```typescript
interface User {
  name: string;
  age: number;
}

const user: User = { name: "张三", age: 25 };
const propertyName = "name";

// 使用switch语句或类型断言
let value: string | number;
switch (propertyName) {
  case "name":
    value = user.name;
    break;
  case "age":
    value = user.age;
    break;
  default:
    value = "";
}

// 或使用Map
const userMap = new Map<string, string | number>();
userMap.set("name", "张三");
userMap.set("age", 25);
const mapValue = userMap.get(propertyName);
```

### 4. 对象处理限制

#### 禁止未类型化的对象字面量
- 所有对象必须预先定义接口
- 不允许使用隐式类型推断的对象

#### ❌ 错误示例
```typescript
// 禁止未类型化的对象字面量
const config = {
  api: "https://api.example.com",
  timeout: 5000
}; // ❌ 错误

function createData() {
  return { id: 1, name: "test" }; // ❌ 错误
}
```

#### ✅ 正确做法
```typescript
// 定义接口
interface Config {
  api: string;
  timeout: number;
}

interface Data {
  id: number;
  name: string;
}

const config: Config = {
  api: "https://api.example.com",
  timeout: 5000
}; // ✅ 正确

function createData(): Data {
  return { id: 1, name: "test" }; // ✅ 正确
}
```

## 📝 推荐替代方案

### 1. 使用Map/Record替代动态对象

#### 传统对象方式（❌ 禁止）
```typescript
const dynamicData: { [key: string]: string } = {};
dynamicData["field1"] = "value1";
```

#### Map方式（✅ 推荐）
```typescript
const dynamicData = new Map<string, string>();
dynamicData.set("field1", "value1");
const value = dynamicData.get("field1");
```

#### Record方式（✅ 推荐）
```typescript
type StringRecord = Record<string, string>;
const data: StringRecord = {
  field1: "value1",
  field2: "value2"
};
```

### 2. 使用传统循环

#### ❌ 禁止方式
```typescript
const obj = { a: 1, b: 2 };
for (const key in obj) {
  console.log(obj[key]);
}
```

#### ✅ 推荐方式
```typescript
const obj = { a: 1, b: 2 };
const keys = Object.keys(obj);
for (let i = 0; i < keys.length; i++) {
  const key = keys[i];
  console.log(obj[key as keyof typeof obj]);
}
```

### 3. 明确接口定义

#### ❌ 内联类型（禁止）
```typescript
function process(data: { name: string, value: number }) {
  // ...
}
```

#### ✅ 预定义接口（推荐）
```typescript
interface DataItem {
  name: string;
  value: number;
}

function process(data: DataItem) {
  // ...
}
```

## 🛠️ 实用技巧

### 1. 快速错误定位
- 根据编译错误代码快速识别问题类型
- 常见错误代码对应特定规范违反

### 2. 类型安全优先
- 优先使用类型安全的API和方法
- 避免类型断言，使用类型守卫

### 3. 清晰的接口层次
- 为所有数据结构定义明确的接口
- 使用接口继承构建类型层次

### 4. 枚举和联合类型
```typescript
// 使用枚举提高可读性
enum Status {
  Active = "active",
  Inactive = "inactive"
}

// 使用联合类型限制取值范围
type Theme = "light" | "dark" | "auto";
```

## 🎯 常见场景解决方案

### 1. 动态属性访问

#### 场景：根据字符串键访问对象属性
```typescript
interface User {
  name: string;
  age: number;
  email: string;
}

function getProperty(obj: User, key: string): string | number {
  switch (key) {
    case "name":
      return obj.name;
    case "age":
      return obj.age;
    case "email":
      return obj.email;
    default:
      throw new Error(`Unknown property: ${key}`);
  }
}
```

### 2. 数组对象处理

#### 场景：处理对象数组
```typescript
interface Item {
  id: number;
  name: string;
}

function findItem(items: Item[], id: number): Item | undefined {
  for (let i = 0; i < items.length; i++) {
    if (items[i].id === id) {
      return items[i];
    }
  }
  return undefined;
}
```

### 3. 配置对象管理

#### 场景：应用配置管理
```typescript
interface AppConfig {
  apiUrl: string;
  timeout: number;
  retries: number;
}

class ConfigManager {
  private static config: AppConfig = {
    apiUrl: "",
    timeout: 5000,
    retries: 3
  };

  static getConfig(): AppConfig {
    return this.config;
  }

  static updateConfig(newConfig: Partial<AppConfig>): void {
    this.config = { ...this.config, ...newConfig };
  }
}
```

## 📋 检查清单

在提交代码前，请确认：

- [ ] 没有使用 `any` 或 `unknown` 类型
- [ ] 没有使用索引签名 `[key: string]: T`
- [ ] 没有使用内联对象字面量类型
- [ ] 对象访问使用明确的属性名，而非动态索引
- [ ] 对象遍历使用传统循环而非 `for...in`
- [ ] 所有对象都有明确的接口定义
- [ ] 静态方法中使用 `ClassName.method()` 而非 `this.method()`

## 🚨 常见编译错误及解决方案

### Error: Property access is not allowed
**原因**：使用了动态索引访问
**解决**：使用switch语句或Map替代

### Error: Index signature is not allowed
**原因**：定义了索引签名
**解决**：使用Map或Record类型

### Error: Object literal type is not allowed
**原因**：使用了内联对象类型
**解决**：预定义接口

### Error: 'this' cannot be used in static context
**原因**：静态方法中使用了this
**解决**：使用类名.方法名调用

---

*本文档将持续更新，请遵循最新版本进行开发。*