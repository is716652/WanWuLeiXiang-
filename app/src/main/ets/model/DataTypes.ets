/**
 * 数据模型定义
 */

// 类象分类
export interface LeiXiangCategory {
  name: string;
  items: string[];
}

// 天干数据结构
export interface TianGanItem {
  name: string;
  type: string;
  basicInfo: string[];
  ancientText?: string;
  categories: LeiXiangCategory[];
}

// 地支数据结构
export interface DiZhiItem {
  name: string;
  direction: string;
  nature: string;
  features: string[];
  categories: LeiXiangCategory[];
  specialNotes?: string[];
}

// 扩展数据文件结构
export interface ExtendedDataFile {
  name: string;
  extendedCategories: ExtendedLeiXiang[];
}

// 子分类结构
export interface SubcategoryItem {
  name: string;        // 子分类名称，如"乾为天", "乾为始"
  items: string[];     // 具体象义条目
}

// 八卦扩展象义分组（用于详细类象展示）
export interface ExtendedLeiXiang {
  category: string;      // 大分类名称，如"象意", "物体", "建筑物"
  subcategories: SubcategoryItem[];  // 子分类
}

// 八卦数据结构
export interface BaguaItem {
  name: string;
  symbol: string;
  basicInfo: string[];
  categories: LeiXiangCategory[];  // 基础类象（已有）
  extendedCategories?: ExtendedLeiXiang[];  // 扩展详细类象（新增）
}

// 六十甲子纳音数据结构
export interface NaYinXiangYi {
  本义: string;
  性格: string;
  事业: string;
  感情: string;
  健康: string;
  风水: string;
  吉色: string | string[];
  吉数: string | number[];
  吉方: string | string[];
}

export interface NaYinItem {
  name: string;  // 例如 "甲子 乙丑"
  纳音: string;  // 例如 "海中金"
  天干: string[];
  地支: string[];
  象义: NaYinXiangYi;
}
