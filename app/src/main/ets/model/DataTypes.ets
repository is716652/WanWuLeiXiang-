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

// 八卦数据结构
export interface BaguaItem {
  name: string;
  symbol: string;
  basicInfo: string[];
  categories: LeiXiangCategory[];
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
