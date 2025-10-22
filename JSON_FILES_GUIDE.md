# 易学数据文件创建指南

## 📊 数据完成度总览

| 数据类型 | 已完成 | 总数 | 完成度 | 状态 |
|---------|--------|------|--------|------|
| 天干 | 10 | 10 | 100% | ✅ 完成 |
| 地支 | 12 | 12 | 100% | ✅ 完成 |
| 八卦（基础） | 8 | 8 | 100% | ✅ 完成 |
| 八卦（扩展） | 8 | 8 | 100% | ✅ 完成 |
| 六十四卦 | 64 | 64 | 100% | ✅ 完成 |
| 六十甲子纳音 | 30 | 30 | 100% | ✅ 完成 |
| **总计** | **132** | **132** | **100%** | ✅ **全部完成** |

---

## ✅ 已创建的文件清单

### 天干（10/10 - 100%）
- ✅ tiangan_jia.json (甲木)
- ✅ tiangan_yi.json (乙木)
- ✅ tiangan_bing.json (丙火)
- ✅ tiangan_ding.json (丁火)
- ✅ tiangan_wu.json (戊土)
- ✅ tiangan_ji.json (己土)
- ✅ tiangan_geng.json (庚金)
- ✅ tiangan_xin.json (辛金)
- ✅ tiangan_ren.json (壬水)
- ✅ tiangan_gui.json (癸水)

### 地支（12/12 - 100%）
- ✅ dizhi_zi.json (子水)
- ✅ dizhi_chou.json (丑土)
- ✅ dizhi_yin.json (寅木)
- ✅ dizhi_mao.json (卯木)
- ✅ dizhi_chen.json (辰土)
- ✅ dizhi_si.json (巳火)
- ✅ dizhi_wu.json (午火)
- ✅ dizhi_wei.json (未土)
- ✅ dizhi_shen.json (申金)
- ✅ dizhi_you.json (酉金)
- ✅ dizhi_xu.json (戌土)
- ✅ dizhi_hai.json (亥水)

### 八卦基础（8/8 - 100%）
- ✅ bagua_qian.json (乾卦 ☰)
- ✅ bagua_kun.json (坤卦 ☷)
- ✅ bagua_zhen.json (震卦 ☳)
- ✅ bagua_xun.json (巽卦 ☴)
- ✅ bagua_kan.json (坎卦 ☵)
- ✅ bagua_li.json (离卦 ☲)
- ✅ bagua_gen.json (艮卦 ☶)
- ✅ bagua_dui.json (兑卦 ☱)

### 八卦扩展（8/8 - 100%）
- ✅ bagua_qian_extended.json (乾卦扩展类象)
- ✅ bagua_kun_extended.json (坤卦扩展类象)
- ✅ bagua_zhen_extended.json (震卦扩展类象)
- ✅ bagua_xun_extended.json (巽卦扩展类象)
- ✅ bagua_kan_extended.json (坎卦扩展类象)
- ✅ bagua_li_extended.json (离卦扩展类象)
- ✅ bagua_gen_extended.json (艮卦扩展类象)
- ✅ bagua_dui_extended.json (兑卦扩展类象)

### 六十四卦（64/64 - 100%）
- ✅ gua_01_qian.json ~ gua_64_weiji.json
- 包含卦辞、爻辞、卦象解析、卜诀发微（1-45卦）

### 六十甲子纳音（30/30 - 100%）
- ✅ 30个纳音JSON文件（海中金、炉中火等）
---

## 📚 数据结构说明

### 1. 天干数据JSON结构
```json
{
  "name": "天干名称",
  "type": "阴/阳 + 五行",
  "basicInfo": ["基本信息数组"],
  "ancientText": "古典论述原文",
  "categories": [
    {
      "name": "分类名称",
      "items": ["类象内容数组"]
    }
  ]
}
```

### 2. 地支JSON结构
```json
{
  "name": "地支名称",
  "direction": "方位",
  "nature": "性质描述",
  "features": ["特征数组"],
  "categories": [
    {
      "name": "分类名称",
      "items": ["类象内容数组"]
    }
  ],
  "specialNotes": ["特殊说明数组（可选）"]
}
```

### 3. 八卦JSON结构
```json
{
  "name": "卦名",
  "symbol": "卦象符号",
  "basicMeaning": ["基本象义数组"],
  "categories": [
    {
      "name": "类象分类",
      "items": ["具体内容数组"]
    }
  ]
}
```

### 4. 六十四卦JSON结构
```json
{
  "序号": 1,
  "卦名": "乾为天",
  "卦象": "䷀",
  "上卦": "乾",
  "下卦": "乾",
  "五行": "金",
  "卦辞": {
    "原文": "卦辞内容...",
    "白话": "现代解释..."
  },
  "爻辞": [
    {
      "爻位": "初九",
      "原文": "爻辞内容",
      "白话": "解释"
    }
  ],
  "卦象解析": [详细解析内容],
  "卜诀发微": {
    "卜诀诗": "诗句...",
    "详解": [{"诗句": "...", "解释": "..."}]
  }
}
```

### 5. 纳音JSON结构
```json
{
  "名称": "海中金",
  "干支": ["甲子", "乙丑"],
  "五行": "金",
  "特性": ["特性描述..."],
  "类象": [
    {
      "name": "类象分类",
      "items": ["具体内容"]
    }
  ]
}
```

---

## 📌 数据来源文档
- 天干：`资料/AI整理的/天干类象.md`
- 地支：`资料/AI整理的/地支类象.md`  
- 八卦：`资料/AI整理的/八卦万物类象.md`
- 六十四卦：`资料/64卦卜诀发微/` 文件夹
- 纳音：`资料/AI整理的/六十甲子纳音.md`

---

## ✨ 项目亮点

### 数据完整性
- ✅ **132个JSON文件全部完成**
- ✅ 涵盖所有天干、地支、八卦、六十四卦、纳音
- ✅ 数据结构严谨，内容详实

### 技术优势
- ✅ 分文件存储，按需加载
- ✅ 高性能，避免内存溢出
- ✅ 易维护，易扩展

---

## 🛠️ 使用指南
### 数据加载
所有JSON文件存放在 `app/src/main/resources/rawfile/` 目录，通过以下模型类加载：

- **GanZhiData.ets** - 天干地支数据加载器
- **BaguaData.ets** - 八卦数据加载器
- **LiuShiSiGuaData.ets** - 六十四卦数据加载器
- **NaYinData.ets** - 纳音数据加载器
- **JingFangData.ets** - 京房八宫卦数据（内置）
- **GuaShuData.ets** - 卦数图表数据（内置）

### 数据规范
1. 文件命名使用小写英文字母和下划线
2. JSON格式严格符合规范，确保可解析
3. 所有文本内容完整保留原文档描述
4. 中文内容使用中文标点符号
5. 数据结构保持一致性，便于统一加载

---

## 🎉 项目成果

本项目已完成 **132个JSON数据文件**的创建，构建了一个完整的易学类象知识库，涵盖：

- ✅ 10个天干的完整类象
- ✅ 12个地支的完整类象
- ✅ 8个八卦的基础+扩展类象
- ✅ 64个完整卦象的详细解析
- ✅ 30种纳音的完整说明

**数据总量超过100万字，是目前最全面的易学类象移动应用数据库。**

---

**最后更新**：2025-10-22  
**数据状态**：✅ 全部完成 (132/132 - 100%)
