# 📦 完整JSON数据文件创建清单

## 已创建的JSON文件

### ✅ 天干文件（4/10）
1. tiangan_jia.json - 甲木 ✓
2. tiangan_yi.json - 乙木 ✓
3. tiangan_bing.json - 丙火 ✓
4. tiangan_ding.json - 丁火 ✓

### ⏳ 待创建的天干文件（6个）
根据 `资料/AI整理的/天干类象.md` 创建以下文件：

5. **tiangan_wu.json** - 戊土
6. **tiangan_ji.json** - 己土
7. **tiangan_geng.json** - 庚金
8. **tiangan_xin.json** - 辛金
9. **tiangan_ren.json** - 壬水
10. **tiangan_gui.json** - 癸水

### ✅ 地支文件（1/12）
1. dizhi_zi.json - 子水 ✓

### ⏳ 待创建的地支文件（11个）
根据 `资料/AI整理的/地支类象.md` 创建以下文件：

2. **dizhi_chou.json** - 丑土
3. **dizhi_yin.json** - 寅木
4. **dizhi_mao.json** - 卯木
5. **dizhi_chen.json** - 辰土
6. **dizhi_si.json** - 巳火
7. **dizhi_wu.json** - 午火
8. **dizhi_wei.json** - 未土
9. **dizhi_shen.json** - 申金
10. **dizhi_you.json** - 酉金
11. **dizhi_xu.json** - 戌土
12. **dizhi_hai.json** - 亥水

### ⏳ 八卦文件（全部待创建8个）
根据 `资料/AI整理的/八卦万物类象.md` 创建：

1. **bagua_qian.json** - 乾卦 ☰
2. **bagua_kun.json** - 坤卦 ☷
3. **bagua_zhen.json** - 震卦 ☳
4. **bagua_xun.json** - 巽卦 ☴
5. **bagua_kan.json** - 坎卦 ☵
6. **bagua_li.json** - 离卦 ☲
7. **bagua_gen.json** - 艮卦 ☶
8. **bagua_dui.json** - 兑卦 ☱

---

## 📝 数据创建模板

### 天干JSON模板
```json
{
  "name": "天干名称（如：甲木）",
  "type": "阴阳+五行（如：阳木）",
  "basicInfo": [
    "在天为XXX",
    "性质描述",
    "其他基本信息"
  ],
  "ancientText": "古典论述原文（可选）",
  "categories": [
    {
      "name": "分类名称",
      "items": [
        "具体内容1",
        "具体内容2"
      ]
    }
  ]
}
```

### 地支JSON模板
```json
{
  "name": "地支名称（如：子水）",
  "direction": "方位（如：正北方）",
  "nature": "性质（如：阴水，癸水的根）",
  "features": [
    "特征1",
    "特征2"
  ],
  "categories": [
    {
      "name": "分类名称",
      "items": [
        "具体内容"
      ]
    }
  ],
  "specialNotes": ["特殊说明（可选）"]
}
```

### 八卦JSON模板
```json
{
  "name": "卦名（如：乾卦）",
  "symbol": "卦象符号（如：☰）",
  "basicMeaning": [
    "基本象义1",
    "基本象义2"
  ],
  "categories": [
    {
      "name": "类象分类",
      "items": [
        "具体内容"
      ]
    }
  ]
}
```

---

## 🔧 快速创建方法

### 方法1：手动创建
根据模板和文档内容，逐个创建JSON文件到 `app/src/main/resources/rawfile/` 目录

### 方法2：批量脚本
创建一个PowerShell脚本来批量生成占位文件，然后填充内容

---

## ✨ 优势说明

### 分文件存储的好处：
1. **性能优化**：按需加载，不会一次性加载所有数据
2. **内存管理**：避免大对象导致内存溢出
3. **维护便利**：每个文件独立，修改某个类象不影响其他
4. **加载速度**：并发加载多个小文件比加载一个大文件更快
5. **扩展性强**：后续添加新数据只需新增文件

### 数据结构特点：
- 完全遵循原文档内容
- 支持多级分类
- 保留古典论述
- 包含所有详细类象

---

## 📚 参考文档
- 天干：`d:\DevEcoStudioProjects\AnalogicalCategorizationAllThings\资料\AI整理的\天干类象.md`
- 地支：`d:\DevEcoStudioProjects\AnalogicalCategorizationAllThings\资料\AI整理的\地支类象.md`
- 八卦：`d:\DevEcoStudioProjects\AnalogicalCategorizationAllThings\资料\AI整理的\八卦万物类象.md`

---

## 📋 当前进度
- 天干：4/10 (40%)
- 地支：1/12 (8%)
- 八卦：0/8 (0%)
- **总计**：5/30 (17%)

剩余25个文件需要根据文档内容创建。每个文件都应包含该项的**完整类象信息**！
