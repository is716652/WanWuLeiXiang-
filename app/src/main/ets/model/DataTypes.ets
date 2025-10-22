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

// 六十四卦爻辞详解(使用Record类型替代索引签名)
export type YaoCiDetail = Record<string, string>;

// 爻辞列表项(用于ForEach遍历)
export interface YaoCiEntry {
  key: string;
  value: string;
}

// 六十四卦卜诀发微
export interface BuJueFaWei {
  卜诀诗: string;  // 八句卜诀诗
  详解: BuJueDetailItem[];  // 每句的详细解释
}

// 卜诀详解项
export interface BuJueDetailItem {
  诗句: string;  // 原诗句
  解释: string;  // 详细解释内容
}

// 六十四卦详细解释
export interface GuaDetailExplain {
  整体含义: string;
  爻象分析: string;
  人生启示: string;
  应用领域: string;
  吉凶判断: string;
}

// 六十四卦数据结构
export interface LiuShiSiGuaItem {
  卦序: number;
  卦名: string;
  卦象: string;  // Unicode卦象符号
  组成: string;  // 如"乾上乾下"
  阴阳结构: string;
  自然象征: string;
  人伦象征: string;
  身体象征: string;
  动物象征: string;
  五行属性: string;
  核心象征: string;
  卦辞: string;
  彖辞: string;
  象辞: string;
  详细解释: GuaDetailExplain;
  爻辞详解: YaoCiDetail;
  吉凶等级?: string;  // 如"上上"、"中上"等
  卜诀发微?: BuJueFaWei;  // 卜诀发微内容
}
