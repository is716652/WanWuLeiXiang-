# -*- coding: utf-8 -*-
import json
import re

# 定义卦象信息映射
gua_info_map = {
    "鼎": {
        "guaNumber": 50,
        "guaSymbol": "䷱",
        "upperTrigram": "离",
        "lowerTrigram": "巽",
        "upperTrigramMeaning": "火",
        "lowerTrigramMeaning": "风",
        "upperTrigramAttribute": "明",
        "lowerTrigramAttribute": "入",
        "filename": "ding.json"
    },
    "震": {
        "guaNumber": 51,
        "guaSymbol": "䷲",
        "upperTrigram": "震",
        "lowerTrigram": "震",
        "upperTrigramMeaning": "雷",
        "lowerTrigramMeaning": "雷",
        "upperTrigramAttribute": "动",
        "lowerTrigramAttribute": "动",
        "filename": "zhen.json"
    },
    "艮": {
        "guaNumber": 52,
        "guaSymbol": "䷳",
        "upperTrigram": "艮",
        "lowerTrigram": "艮",
        "upperTrigramMeaning": "山",
        "lowerTrigramMeaning": "山",
        "upperTrigramAttribute": "止",
        "lowerTrigramAttribute": "止",
        "filename": "gen.json"
    },
    "渐": {
        "guaNumber": 53,
        "guaSymbol": "䷴",
        "upperTrigram": "巽",
        "lowerTrigram": "艮",
        "upperTrigramMeaning": "风",
        "lowerTrigramMeaning": "山",
        "upperTrigramAttribute": "入",
        "lowerTrigramAttribute": "止",
        "filename": "jian_gradual.json"
    },
    "归妹": {
        "guaNumber": 54,
        "guaSymbol": "䷵",
        "upperTrigram": "震",
        "lowerTrigram": "兑",
        "upperTrigramMeaning": "雷",
        "lowerTrigramMeaning": "泽",
        "upperTrigramAttribute": "动",
        "lowerTrigramAttribute": "悦",
        "filename": "guimei.json"
    },
    "丰": {
        "guaNumber": 55,
        "guaSymbol": "䷶",
        "upperTrigram": "震",
        "lowerTrigram": "离",
        "upperTrigramMeaning": "雷",
        "lowerTrigramMeaning": "火",
        "upperTrigramAttribute": "动",
        "lowerTrigramAttribute": "明",
        "filename": "feng.json"
    }
}

# 文件映射（文件名和卦名）
file_mappings = {
    "五十": ("鼎", "鼎"),
    "五一": ("震", "震"),
    "五二": ("艮", "艮"),
    "五三": ("渐", "渐"),
    "五四": ("归妹", "归妹"),
    "五五": ("风", "丰")  # 文件名是"风"，卦名是"丰"
}

def parse_txt_to_json(input_file, gua_name):
    """解析TXT文件并转换为JSON格式"""
    
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    lines = content.strip().split('\n')
    
    # 获取卦象信息
    gua_info = gua_info_map[gua_name]
    
    # 提取描述（第一段内容）
    description_line = ""
    for i, line in enumerate(lines):
        if line.startswith("【义译】") or line.startswith("【象证】"):
            if i > 0:
                description_line = lines[i-1].strip()
            break
    
    # 构建JSON结构
    json_data = {
        "guaInfo": {
            "guaName": gua_name,
            "guaNumber": gua_info["guaNumber"],
            "guaSymbol": gua_info["guaSymbol"],
            "upperTrigram": gua_info["upperTrigram"],
            "lowerTrigram": gua_info["lowerTrigram"],
            "upperTrigramMeaning": gua_info["upperTrigramMeaning"],
            "lowerTrigramMeaning": gua_info["lowerTrigramMeaning"],
            "upperTrigramAttribute": gua_info["upperTrigramAttribute"],
            "lowerTrigramAttribute": gua_info["lowerTrigramAttribute"],
            "description": description_line if description_line else ""
        },
        "benGua": {
            "text": "",
            "yiyi": "",
            "xiangzheng": ""
        },
        "zhiGua": []
    }
    
    # 解析本卦和之卦
    current_gua = None
    current_text = []
    current_yiyi = ""
    current_xiangzheng = ""
    
    for line in lines:
        line = line.strip()
        if not line:
            continue
            
        # 检查是否是卦序号开头
        if re.match(r'^\d+[．、]', line):
            # 保存前一个卦
            if current_gua is not None:
                text_content = '\n'.join(current_text).strip()
                if current_gua == "benGua":
                    json_data["benGua"]["text"] = text_content
                    json_data["benGua"]["yiyi"] = current_yiyi
                    json_data["benGua"]["xiangzheng"] = current_xiangzheng
                else:
                    json_data["zhiGua"].append({
                        "targetGua": current_gua,
                        "guaNumber": get_gua_number(current_gua),
                        "text": text_content,
                        "yiyi": current_yiyi,
                        "xiangzheng": current_xiangzheng
                    })
            
            # 开始新卦
            current_text = []
            current_yiyi = ""
            current_xiangzheng = ""
            
            # 提取卦名
            match = re.match(r'^\d+[．、](.+?)[:：]', line)
            if match:
                current_gua = match.group(1).strip()
                # 移除卦序号部分
                line = re.sub(r'^\d+[．、].+?[:：]', '', line).strip()
                if line:
                    current_text.append(line)
            else:
                current_gua = "benGua"
                current_text.append(line)
        
        elif line.startswith("【义译】"):
            current_yiyi = line.replace("【义译】", "").strip()
        elif line.startswith("【象证】"):
            current_xiangzheng = line.replace("【象证】", "").strip()
        elif current_gua is not None:
            # 跳过包含卦名的标题行
            if not (line.startswith("下") or line.startswith("上") or line == gua_name):
                current_text.append(line)
    
    # 保存最后一个卦
    if current_gua is not None:
        text_content = '\n'.join(current_text).strip()
        if current_gua == "benGua":
            json_data["benGua"]["text"] = text_content
            json_data["benGua"]["yiyi"] = current_yiyi
            json_data["benGua"]["xiangzheng"] = current_xiangzheng
        else:
            json_data["zhiGua"].append({
                "targetGua": current_gua,
                "guaNumber": get_gua_number(current_gua),
                "text": text_content,
                "yiyi": current_yiyi,
                "xiangzheng": current_xiangzheng
            })
    
    return json_data

def get_gua_number(gua_name):
    """根据卦名返回卦序号"""
    gua_map = {
        "乾": 1, "坤": 2, "屯": 3, "蒙": 4, "需": 5, "讼": 6, "师": 7, "比": 8,
        "小畜": 9, "履": 10, "泰": 11, "否": 12, "同人": 13, "大有": 14, "谦": 15, "豫": 16,
        "随": 17, "蛊": 18, "临": 19, "观": 20, "噬嗑": 21, "贲": 22, "剥": 23, "复": 24,
        "无妄": 25, "大畜": 26, "颐": 27, "大过": 28, "坎": 29, "离": 30, "咸": 31, "恒": 32,
        "遁": 33, "大壮": 34, "晋": 35, "明夷": 36, "家人": 37, "睽": 38, "蹇": 39, "解": 40,
        "损": 41, "益": 42, "夬": 43, "姤": 44, "萃": 45, "升": 46, "困": 47, "井": 48,
        "革": 49, "鼎": 50, "震": 51, "艮": 52, "渐": 53, "归妹": 54, "丰": 55, "旅": 56,
        "巽": 57, "兑": 58, "涣": 59, "节": 60, "中孚": 61, "小过": 62, "既济": 63, "未济": 64
    }
    return gua_map.get(gua_name, 0)

# 转换所有文件
for file_key, (file_name, gua_name) in file_mappings.items():
    input_file = f"资料/京房象数易学/焦氏易林64卦/{file_key}、{file_name}.txt"
    output_file = f"app/src/main/resources/rawfile/JiaoshiYilin/{gua_info_map[gua_name]['filename']}"
    
    print(f"正在转换: {input_file} -> {output_file}")
    
    try:
        json_data = parse_txt_to_json(input_file, gua_name)
        
        # 写入JSON文件
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(json_data, f, ensure_ascii=False, indent=2)
        
        print(f"✓ 成功生成: {output_file}")
    except Exception as e:
        print(f"✗ 转换失败: {e}")

print("\n所有文件转换完成！")
