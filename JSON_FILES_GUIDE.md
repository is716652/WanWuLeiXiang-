# 天干地支八卦数据文件创建指南

## 已创建的文件

### 天干（已创建4/10）
- ✅ tiangan_jia.json (甲木)
- ✅ tiangan_yi.json (乙木)
- ✅ tiangan_bing.json (丙火)
- ✅ tiangan_ding.json (丁火)
- ⏳ tiangan_wu.json (戊土) - 待创建
- ⏳ tiangan_ji.json (己土) - 待创建
- ⏳ tiangan_geng.json (庚金) - 待创建
- ⏳ tiangan_xin.json (辛金) - 待创建
- ⏳ tiangan_ren.json (壬水) - 待创建
- ⏳ tiangan_gui.json (癸水) - 待创建

### 地支（已创建1/12）
- ✅ dizhi_zi.json (子水)
- ⏳ dizhi_chou.json (丑土) - 待创建
- ⏳ dizhi_yin.json (寅木) - 待创建
- ⏳ dizhi_mao.json (卯木) - 待创建
- ⏳ dizhi_chen.json (辰土) - 待创建
- ⏳ dizhi_si.json (巳火) - 待创建
- ⏳ dizhi_wu.json (午火) - 待创建
- ⏳ dizhi_wei.json (未土) - 待创建
- ⏳ dizhi_shen.json (申金) - 待创建
- ⏳ dizhi_you.json (酉金) - 待创建
- ⏳ dizhi_xu.json (戌土) - 待创建
- ⏳ dizhi_hai.json (亥水) - 待创建

### 八卦（全部待创建0/8）
- ⏳ bagua_qian.json (乾卦) - 待创建
- ⏳ bagua_kun.json (坤卦) - 待创建
- ⏳ bagua_zhen.json (震卦) - 待创建
- ⏳ bagua_xun.json (巽卦) - 待创建
- ⏳ bagua_kan.json (坎卦) - 待创建
- ⏳ bagua_li.json (离卦) - 待创建
- ⏳ bagua_gen.json (艮卦) - 待创建
- ⏳ bagua_dui.json (兑卦) - 待创建

## JSON文件结构模板

### 天干JSON结构
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

### 地支JSON结构
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

### 八卦JSON结构
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

## 数据来源
- 天干：资料/AI整理的/天干类象.md
- 地支：资料/AI整理的/地支类象.md  
- 八卦：资料/AI整理的/八卦万物类象.md

## 注意事项
1. 文件名必须使用小写英文字母
2. JSON格式必须严格符合规范
3. 所有文本内容保留原文档中的完整描述
4. 中文符号使用中文标点
