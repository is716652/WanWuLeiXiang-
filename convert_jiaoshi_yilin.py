# -*- coding: utf-8 -*-
"""
将焦氏易林TXT文件转换为JSON格式
"""
import json
import re
import os

# 卦的映射信息
GUA_INFO = {
    "五十、鼎": {
        "guaName": "鼎",
        "guaNumber": 50,
        "guaSymbol": "䷱",
        "upperTrigram": "离",
        "lowerTrigram": "巽",
        "upperTrigramMeaning": "火",
        "lowerTrigramMeaning": "风",
        "upperTrigramAttribute": "明",
        "lowerTrigramAttribute": "人"
    },
    "五一、震": {
        "guaName": "震",
        "guaNumber": 51,
        "guaSymbol": "䷲",
        "upperTrigram": "震",
        "lowerTrigram": "震",
        "upperTrigramMeaning": "雷",
        "lowerTrigramMeaning": "雷",
        "upperTrigramAttribute": "动",
        "lowerTrigramAttribute": "动"
    },
    "五二、艮": {
        "guaName": "艮",
        "guaNumber": 52,
        "guaSymbol": "䷳",
        "upperTrigram": "艮",
        "lowerTrigram": "艮",
        "upperTrigramMeaning": "山",
        "lowerTrigramMeaning": "山",
        "upperTrigramAttribute": "止",
        "lowerTrigramAttribute": "止"
    },
    "五三、渐": {
        "guaName": "渐",
        "guaNumber": 53,
        "guaSymbol": "䷴",
        "upperTrigram": "巽",
        "lowerTrigram": "艮",
        "upperTrigramMeaning": "风",
        "lowerTrigramMeaning": "山",
        "upperTrigramAttribute": "人",
        "lowerTrigramAttribute": "止"
    },
    "五四、归妹": {
        "guaName": "归妹",
        "guaNumber": 54,
        "guaSymbol": "䷵",
        "upperTrigram": "震",
        "lowerTrigram": "兑",
        "upperTrigramMeaning": "雷",
        "lowerTrigramMeaning": "泽",
        "upperTrigramAttribute": "动",
        "lowerTrigramAttribute": "悦"
    },
    "五五、风": {
        "guaName": "丰",
        "guaNumber": 55,
        "guaSymbol": "䷶",
        "upperTrigram": "震",
        "lowerTrigram": "离",
        "upperTrigramMeaning": "雷",
        "lowerTrigramMeaning": "火",
        "upperTrigramAttribute": "动",
        "lowerTrigramAttribute": "明"
    }
}

# 六十四卦名称映射
GUA_NAMES = [
    "乾", "坤", "屯", "蒙", "需", "讼", "师", "比", "小畜", "履",
    "泰", "否", "同人", "大有", "谦", "豫", "随", "蛊", "临", "观",
    "噬嗑", "贲", "剥", "复", "无妄", "大畜", "颐", "大过", "坎", "离",
    "咸", "恒", "遁", "大壮", "晋", "明夷", "家人", "睽", "蹇", "解",
    "损", "益", "夬", "姤", "萃", "升", "困", "井", "革", "鼎",
    "震", "艮", "渐", "归妹", "丰", "旅", "巽", "兑", "涣", "节",
    "中孚", "小过", "既济", "未济"
]

def parse_txt_file(file_path, gua_key):
    """解析TXT文件"""
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    # 获取卦信息
    gua_info = GUA_INFO[gua_key].copy()
    
    # 查找description行
    for line in lines:
        if "下" in line and "为" in line and "上" in line:
            gua_info["description"] = line.strip().replace("五十、鼎", "").replace("五一、震", "").replace("五二、艮", "").replace("五三、渐", "").replace("五四、归妹", "").replace("五五、风", "").strip()
            break
    
    # 解析本卦
    ben_gua = {}
    zhi_gua_list = []
    
    current_target = None
    current_text = ""
    current_yiyi = ""
    current_xiangzheng = ""
    
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        
        # 跳过空行和标题行
        if not line or "下" in line and "上" in line:
            i += 1
            continue
        
        # 检查是否是本卦描述
        if i < 10 and "【义译】" not in line and "【象证】" not in line and "．" not in line:
            if not ben_gua.get("text"):
                ben_gua["text"] = line
                i += 1
                continue
        
        # 检查是否是本卦的义译
        if "【义译】" in line and not ben_gua.get("yiyi"):
            ben_gua["yiyi"] = line.replace("【义译】", "").strip()
            i += 1
            continue
        
        # 检查是否是本卦的象证
        if "【象证】" in line and not ben_gua.get("xiangzheng"):
            ben_gua["xiangzheng"] = line.replace("【象证】", "").strip()
            i += 1
            continue
        
        # 检查是否是之卦标题（格式：数字．卦名：）
        match = re.match(r'(\d+)．(.+?)[:：](.+)', line)
        if match:
            # 保存上一个之卦
            if current_target and current_text:
                zhi_gua_list.append({
                    "targetGua": current_target,
                    "guaNumber": GUA_NAMES.index(current_target) + 1 if current_target in GUA_NAMES else 0,
                    "text": current_text.strip(),
                    "yiyi": current_yiyi.strip(),
                    "xiangzheng": current_xiangzheng.strip()
                })
            
            # 开始新的之卦
            current_target = match.group(2).strip()
            current_text = match.group(3).strip()
            current_yiyi = ""
            current_xiangzheng = ""
            i += 1
            continue
        
        # 检查义译
        if "【义译】" in line:
            current_yiyi = line.replace("【义译】", "").strip()
            i += 1
            continue
        
        # 检查象证
        if "【象证】" in line:
            current_xiangzheng = line.replace("【象证】", "").strip()
            i += 1
            continue
        
        i += 1
    
    # 保存最后一个之卦
    if current_target and current_text:
        zhi_gua_list.append({
            "targetGua": current_target,
            "guaNumber": GUA_NAMES.index(current_target) + 1 if current_target in GUA_NAMES else 0,
            "text": current_text.strip(),
            "yiyi": current_yiyi.strip(),
            "xiangzheng": current_xiangzheng.strip()
        })
    
    return {
        "guaInfo": gua_info,
        "benGua": ben_gua,
        "zhiGua": zhi_gua_list
    }

def convert_file(txt_path, json_path, gua_key):
    """转换单个文件"""
    print(f"转换 {txt_path} -> {json_path}")
    data = parse_txt_file(txt_path, gua_key)
    
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"  - 本卦: {data['benGua'].get('text', '无')[:20]}...")
    print(f"  - 之卦数量: {len(data['zhiGua'])}")

def main():
    """主函数"""
    base_dir = "资料/京房象数易学/焦氏易林64卦"
    output_dir = "app/src/main/resources/rawfile/JiaoshiYilin"
    
    files_to_convert = [
        ("五十、鼎.txt", "ding.json", "五十、鼎"),
        ("五一、震.txt", "zhen.json", "五一、震"),
        ("五二、艮.txt", "gen.json", "五二、艮"),
        ("五三、渐.txt", "jian_gradual.json", "五三、渐"),  # 第53卦 渐
        ("五四、归妹.txt", "guimei.json", "五四、归妹"),
        ("五五、风.txt", "feng.json", "五五、风")
    ]
    
    for txt_file, json_file, gua_key in files_to_convert:
        txt_path = os.path.join(base_dir, txt_file)
        json_path = os.path.join(output_dir, json_file)
        
        if os.path.exists(txt_path):
            try:
                convert_file(txt_path, json_path, gua_key)
            except Exception as e:
                print(f"错误: {e}")
        else:
            print(f"文件不存在: {txt_path}")
    
    print("\n转换完成!")

if __name__ == "__main__":
    main()
