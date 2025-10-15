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
