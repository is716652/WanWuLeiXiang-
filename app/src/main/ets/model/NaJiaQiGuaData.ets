/**
 * 纳甲起卦数据模型
 * 专业六爻纳甲起卦，包含纳甲装卦、世应、六亲、六神
 */

import { NAJIA_DATA, NaJiaItem, NaJiaYao, getWuXingColor } from './NaJiaData';

// 爻的类型枚举
export enum NaJiaYaoType {
  OLD_YANG = 'OLD_YANG',     // 老阳 (变爻)
  YOUNG_YIN = 'YOUNG_YIN',   // 少阴
  YOUNG_YANG = 'YOUNG_YANG', // 少阳
  OLD_YIN = 'OLD_YIN'        // 老阴 (变爻)
}

// 六亲类型
export enum LiuQin {
  XIONG_DI = '兄弟',
  ZI_SUN = '子孙',
  QI_CAI = '妻财',
  GUAN_GUI = '官鬼',
  FU_MU = '父母'
}

// 六神类型
export enum LiuShen {
  QING_LONG = '青龙',
  ZHU_QUE = '朱雀',
  GOU_CHEN = '勾陈',
  TENG_SHE = '螣蛇',
  BAI_HU = '白虎',
  XUAN_WU = '玄武'
}

// 单爻完整信息
export interface NaJiaYaoInfo {
  position: number;           // 爻位 1-6
  positionName: string;       // 爻位名称
  yaoType: NaJiaYaoType;      // 爻类型
  yaoSymbol: string;          // 爻符号 — / -- / O / X
  isYang: boolean;            // 是否为阳爻
  isChanging: boolean;        // 是否为变爻
  naJia: string;              // 纳甲 (如 甲子)
  wuXing: string;             // 五行
  liuQin: LiuQin;             // 六亲
  liuShen: LiuShen;           // 六神
  isShiYao: boolean;          // 是否为世爻
  isYingYao: boolean;         // 是否为应爻
  randomValue: number;        // 随机数值
}

// 卦象信息
export interface NaJiaGuaInfo {
  name: string;               // 卦名
  symbol: string;             // 卦象符号
  code: number;               // 卦序号 1-64
  upperGua: string;           // 上卦
  lowerGua: string;           // 下卦
  gongShu: string;            // 宫属
  shiCi: string;              // 世次
  yaoList: NaJiaYaoInfo[];    // 六爻列表
}

// 起卦结果
export interface NaJiaQiGuaResult {
  benGua: NaJiaGuaInfo;       // 本卦
  bianGua: NaJiaGuaInfo;      // 变卦
  changingCount: number;      // 变爻数量
  riGan: string;              // 日干
  riZhi: string;              // 日支
  timestamp: number;          // 起卦时间
  question: string;           // 问卦内容
}

// 八卦到五行的映射
function getBaGuaWuXing(gua: string): string {
  switch (gua) {
    case '乾': case '兑': return '金';
    case '震': case '巽': return '木';
    case '坎': return '水';
    case '离': return '火';
    case '艮': case '坤': return '土';
    default: return '土';
  }
}

// 地支到五行的映射
function getDiZhiWuXing(diZhi: string): string {
  switch (diZhi) {
    case '子': case '亥': return '水';
    case '寅': case '卯': return '木';
    case '巳': case '午': return '火';
    case '申': case '酉': return '金';
    case '辰': case '戌': case '丑': case '未': return '土';
    default: return '土';
  }
}

// 五行生克关系判断六亲
function getLiuQin(guaWuXing: string, yaoWuXing: string): LiuQin {
  // 五行相生相克表
  const shengMap: Map<string, string> = new Map();
  shengMap.set('木', '火');
  shengMap.set('火', '土');
  shengMap.set('土', '金');
  shengMap.set('金', '水');
  shengMap.set('水', '木');

  const keMap: Map<string, string> = new Map();
  keMap.set('木', '土');
  keMap.set('土', '水');
  keMap.set('水', '火');
  keMap.set('火', '金');
  keMap.set('金', '木');

  if (guaWuXing === yaoWuXing) {
    return LiuQin.XIONG_DI; // 同我者为兄弟
  } else if (shengMap.get(guaWuXing) === yaoWuXing) {
    return LiuQin.ZI_SUN;   // 我生者为子孙
  } else if (shengMap.get(yaoWuXing) === guaWuXing) {
    return LiuQin.FU_MU;    // 生我者为父母
  } else if (keMap.get(guaWuXing) === yaoWuXing) {
    return LiuQin.QI_CAI;   // 我克者为妻财
  } else {
    return LiuQin.GUAN_GUI; // 克我者为官鬼
  }
}

// 根据日干获取六神起始
function getLiuShenList(riGan: string): LiuShen[] {
  // 甲乙日起青龙，丙丁日起朱雀，戊日起勾陈，己日起螣蛇，庚辛日起白虎，壬癸日起玄武
  let startIndex = 0;
  switch (riGan) {
    case '甲': case '乙': startIndex = 0; break;
    case '丙': case '丁': startIndex = 1; break;
    case '戊': startIndex = 2; break;
    case '己': startIndex = 3; break;
    case '庚': case '辛': startIndex = 4; break;
    case '壬': case '癸': startIndex = 5; break;
    default: startIndex = 0;
  }

  const allLiuShen: LiuShen[] = [
    LiuShen.QING_LONG,
    LiuShen.ZHU_QUE,
    LiuShen.GOU_CHEN,
    LiuShen.TENG_SHE,
    LiuShen.BAI_HU,
    LiuShen.XUAN_WU
  ];

  const result: LiuShen[] = [];
  for (let i = 0; i < 6; i++) {
    result.push(allLiuShen[(startIndex + i) % 6]);
  }
  return result;
}

// 获取当前日干支
function getCurrentRiGanZhi(): RiGanZhiResult {
  const now = new Date();
  // 简化计算：使用公式计算日干支
  const baseDate = new Date(1900, 0, 31); // 1900年1月31日为甲子日
  const diffDays = Math.floor((now.getTime() - baseDate.getTime()) / (24 * 60 * 60 * 1000));

  const tianGan: string[] = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  const diZhi: string[] = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  const ganIndex = diffDays % 10;
  const zhiIndex = diffDays % 12;

  const result: RiGanZhiResult = {
    riGan: tianGan[ganIndex],
    riZhi: diZhi[zhiIndex]
  };
  return result;
}

// 日干支结果接口
interface RiGanZhiResult {
  riGan: string;
  riZhi: string;
}

// 生成单个爻
function generateYao(position: number): YaoGenerateResult {
  const randomValue = Math.floor(Math.random() * 100) + 1;

  let yaoType: NaJiaYaoType;
  let yaoSymbol: string;
  let isYang: boolean;
  let isChanging: boolean;

  if (randomValue <= 20) {
    yaoType = NaJiaYaoType.OLD_YANG;
    yaoSymbol = 'O';
    isYang = true;
    isChanging = true;
  } else if (randomValue <= 49) {
    yaoType = NaJiaYaoType.YOUNG_YIN;
    yaoSymbol = '--';
    isYang = false;
    isChanging = false;
  } else if (randomValue <= 79) {
    yaoType = NaJiaYaoType.YOUNG_YANG;
    yaoSymbol = '—';
    isYang = true;
    isChanging = false;
  } else {
    yaoType = NaJiaYaoType.OLD_YIN;
    yaoSymbol = 'X';
    isYang = false;
    isChanging = true;
  }

  const result: YaoGenerateResult = {
    position: position,
    yaoType: yaoType,
    yaoSymbol: yaoSymbol,
    isYang: isYang,
    isChanging: isChanging,
    randomValue: randomValue
  };
  return result;
}

// 爻生成结果接口
interface YaoGenerateResult {
  position: number;
  yaoType: NaJiaYaoType;
  yaoSymbol: string;
  isYang: boolean;
  isChanging: boolean;
  randomValue: number;
}

// 根据六爻获取八卦
function getTrigramFromYaos(yao1: boolean, yao2: boolean, yao3: boolean): string {
  const code = (yao3 ? 4 : 0) + (yao2 ? 2 : 0) + (yao1 ? 1 : 0);
  switch (code) {
    case 0: return '坤';
    case 1: return '震';
    case 2: return '坎';
    case 3: return '兑';
    case 4: return '艮';
    case 5: return '巽';
    case 6: return '离';
    case 7: return '乾';
    default: return '乾';
  }
}

// 获取卦的世应位置
function getShiYingPosition(gongShu: string, shiCi: string): ShiYingResult {
  let shiPos = 6;
  let yingPos = 3;

  switch (shiCi) {
    case '本宫卦': shiPos = 6; yingPos = 3; break;
    case '一世卦': shiPos = 1; yingPos = 4; break;
    case '二世卦': shiPos = 2; yingPos = 5; break;
    case '三世卦': shiPos = 3; yingPos = 6; break;
    case '四世卦': shiPos = 4; yingPos = 1; break;
    case '五世卦': shiPos = 5; yingPos = 2; break;
    case '游魂卦': shiPos = 4; yingPos = 1; break;
    case '归魂卦': shiPos = 3; yingPos = 6; break;
    default: shiPos = 6; yingPos = 3;
  }

  const result: ShiYingResult = {
    shiPos: shiPos,
    yingPos: yingPos
  };
  return result;
}

// 世应结果接口
interface ShiYingResult {
  shiPos: number;
  yingPos: number;
}

// 获取爻位名称
function getPositionName(position: number): string {
  switch (position) {
    case 1: return '初爻';
    case 2: return '二爻';
    case 3: return '三爻';
    case 4: return '四爻';
    case 5: return '五爻';
    case 6: return '上爻';
    default: return '';
  }
}

// 64卦数据
interface GuaData {
  name: string;
  symbol: string;
  upper: string;
  lower: string;
  gongShu: string;
  shiCi: string;
}

// 获取卦数据
function getGuaData(upper: string, lower: string): GuaData {
  // 64卦完整映射表
  const guaMap: Map<string, GuaData> = new Map();

  // 乾宫八卦
  guaMap.set('乾乾', { name: '乾为天', symbol: '䷀', upper: '乾', lower: '乾', gongShu: '乾宫', shiCi: '本宫卦' });
  guaMap.set('乾巽', { name: '天风姤', symbol: '䷫', upper: '乾', lower: '巽', gongShu: '乾宫', shiCi: '一世卦' });
  guaMap.set('乾艮', { name: '天山遁', symbol: '䷠', upper: '乾', lower: '艮', gongShu: '乾宫', shiCi: '二世卦' });
  guaMap.set('乾坤', { name: '天地否', symbol: '䷋', upper: '乾', lower: '坤', gongShu: '乾宫', shiCi: '三世卦' });
  guaMap.set('巽坤', { name: '风地观', symbol: '䷓', upper: '巽', lower: '坤', gongShu: '乾宫', shiCi: '四世卦' });
  guaMap.set('艮坤', { name: '山地剥', symbol: '䷖', upper: '艮', lower: '坤', gongShu: '乾宫', shiCi: '五世卦' });
  guaMap.set('离坤', { name: '火地晋', symbol: '䷢', upper: '离', lower: '坤', gongShu: '乾宫', shiCi: '游魂卦' });
  guaMap.set('离乾', { name: '火天大有', symbol: '䷍', upper: '离', lower: '乾', gongShu: '乾宫', shiCi: '归魂卦' });

  // 坤宫八卦
  guaMap.set('坤坤', { name: '坤为地', symbol: '䷁', upper: '坤', lower: '坤', gongShu: '坤宫', shiCi: '本宫卦' });
  guaMap.set('坤震', { name: '地雷复', symbol: '䷗', upper: '坤', lower: '震', gongShu: '坤宫', shiCi: '一世卦' });
  guaMap.set('坤兑', { name: '地泽临', symbol: '䷒', upper: '坤', lower: '兑', gongShu: '坤宫', shiCi: '二世卦' });
  guaMap.set('坤乾', { name: '地天泰', symbol: '䷊', upper: '坤', lower: '乾', gongShu: '坤宫', shiCi: '三世卦' });
  guaMap.set('震乾', { name: '雷天大壮', symbol: '䷡', upper: '震', lower: '乾', gongShu: '坤宫', shiCi: '四世卦' });
  guaMap.set('兑乾', { name: '泽天夬', symbol: '䷪', upper: '兑', lower: '乾', gongShu: '坤宫', shiCi: '五世卦' });
  guaMap.set('坎乾', { name: '水天需', symbol: '䷄', upper: '坎', lower: '乾', gongShu: '坤宫', shiCi: '游魂卦' });
  guaMap.set('坎坤', { name: '水地比', symbol: '䷇', upper: '坎', lower: '坤', gongShu: '坤宫', shiCi: '归魂卦' });

  // 震宫八卦
  guaMap.set('震震', { name: '震为雷', symbol: '䷲', upper: '震', lower: '震', gongShu: '震宫', shiCi: '本宫卦' });
  guaMap.set('震坤', { name: '雷地豫', symbol: '䷏', upper: '震', lower: '坤', gongShu: '震宫', shiCi: '一世卦' });
  guaMap.set('震坎', { name: '雷水解', symbol: '䷧', upper: '震', lower: '坎', gongShu: '震宫', shiCi: '二世卦' });
  guaMap.set('震巽', { name: '雷风恒', symbol: '䷟', upper: '震', lower: '巽', gongShu: '震宫', shiCi: '三世卦' });
  guaMap.set('坤巽', { name: '地风升', symbol: '䷭', upper: '坤', lower: '巽', gongShu: '震宫', shiCi: '四世卦' });
  guaMap.set('坎巽', { name: '水风井', symbol: '䷯', upper: '坎', lower: '巽', gongShu: '震宫', shiCi: '五世卦' });
  guaMap.set('兑巽', { name: '泽风大过', symbol: '䷛', upper: '兑', lower: '巽', gongShu: '震宫', shiCi: '游魂卦' });
  guaMap.set('兑震', { name: '泽雷随', symbol: '䷐', upper: '兑', lower: '震', gongShu: '震宫', shiCi: '归魂卦' });

  // 巽宫八卦
  guaMap.set('巽巽', { name: '巽为风', symbol: '䷸', upper: '巽', lower: '巽', gongShu: '巽宫', shiCi: '本宫卦' });
  guaMap.set('巽乾', { name: '风天小畜', symbol: '䷈', upper: '巽', lower: '乾', gongShu: '巽宫', shiCi: '一世卦' });
  guaMap.set('巽离', { name: '风火家人', symbol: '䷤', upper: '巽', lower: '离', gongShu: '巽宫', shiCi: '二世卦' });
  guaMap.set('巽震', { name: '风雷益', symbol: '䷩', upper: '巽', lower: '震', gongShu: '巽宫', shiCi: '三世卦' });
  guaMap.set('乾震', { name: '天雷无妄', symbol: '䷘', upper: '乾', lower: '震', gongShu: '巽宫', shiCi: '四世卦' });
  guaMap.set('离震', { name: '火雷噬嗑', symbol: '䷔', upper: '离', lower: '震', gongShu: '巽宫', shiCi: '五世卦' });
  guaMap.set('艮震', { name: '山雷颐', symbol: '䷚', upper: '艮', lower: '震', gongShu: '巽宫', shiCi: '游魂卦' });
  guaMap.set('艮巽', { name: '山风蛊', symbol: '䷑', upper: '艮', lower: '巽', gongShu: '巽宫', shiCi: '归魂卦' });

  // 坎宫八卦
  guaMap.set('坎坎', { name: '坎为水', symbol: '䷜', upper: '坎', lower: '坎', gongShu: '坎宫', shiCi: '本宫卦' });
  guaMap.set('坎兑', { name: '水泽节', symbol: '䷻', upper: '坎', lower: '兑', gongShu: '坎宫', shiCi: '一世卦' });
  guaMap.set('坎震', { name: '水雷屯', symbol: '䷂', upper: '坎', lower: '震', gongShu: '坎宫', shiCi: '二世卦' });
  guaMap.set('坎离', { name: '水火既济', symbol: '䷾', upper: '坎', lower: '离', gongShu: '坎宫', shiCi: '三世卦' });
  guaMap.set('兑离', { name: '泽火革', symbol: '䷰', upper: '兑', lower: '离', gongShu: '坎宫', shiCi: '四世卦' });
  guaMap.set('震离', { name: '雷火丰', symbol: '䷶', upper: '震', lower: '离', gongShu: '坎宫', shiCi: '五世卦' });
  guaMap.set('坤离', { name: '地火明夷', symbol: '䷣', upper: '坤', lower: '离', gongShu: '坎宫', shiCi: '游魂卦' });
  guaMap.set('坤坎', { name: '地水师', symbol: '䷆', upper: '坤', lower: '坎', gongShu: '坎宫', shiCi: '归魂卦' });

  // 离宫八卦
  guaMap.set('离离', { name: '离为火', symbol: '䷝', upper: '离', lower: '离', gongShu: '离宫', shiCi: '本宫卦' });
  guaMap.set('离艮', { name: '火山旅', symbol: '䷷', upper: '离', lower: '艮', gongShu: '离宫', shiCi: '一世卦' });
  guaMap.set('离巽', { name: '火风鼎', symbol: '䷱', upper: '离', lower: '巽', gongShu: '离宫', shiCi: '二世卦' });
  guaMap.set('离坎', { name: '火水未济', symbol: '䷿', upper: '离', lower: '坎', gongShu: '离宫', shiCi: '三世卦' });
  guaMap.set('艮坎', { name: '山水蒙', symbol: '䷃', upper: '艮', lower: '坎', gongShu: '离宫', shiCi: '四世卦' });
  guaMap.set('巽坎', { name: '风水涣', symbol: '䷺', upper: '巽', lower: '坎', gongShu: '离宫', shiCi: '五世卦' });
  guaMap.set('乾坎', { name: '天水讼', symbol: '䷅', upper: '乾', lower: '坎', gongShu: '离宫', shiCi: '游魂卦' });
  guaMap.set('乾离', { name: '天火同人', symbol: '䷌', upper: '乾', lower: '离', gongShu: '离宫', shiCi: '归魂卦' });

  // 艮宫八卦
  guaMap.set('艮艮', { name: '艮为山', symbol: '䷳', upper: '艮', lower: '艮', gongShu: '艮宫', shiCi: '本宫卦' });
  guaMap.set('艮离', { name: '山火贲', symbol: '䷕', upper: '艮', lower: '离', gongShu: '艮宫', shiCi: '一世卦' });
  guaMap.set('艮乾', { name: '山天大畜', symbol: '䷙', upper: '艮', lower: '乾', gongShu: '艮宫', shiCi: '二世卦' });
  guaMap.set('艮兑', { name: '山泽损', symbol: '䷨', upper: '艮', lower: '兑', gongShu: '艮宫', shiCi: '三世卦' });
  guaMap.set('离兑', { name: '火泽睽', symbol: '䷥', upper: '离', lower: '兑', gongShu: '艮宫', shiCi: '四世卦' });
  guaMap.set('乾兑', { name: '天泽履', symbol: '䷉', upper: '乾', lower: '兑', gongShu: '艮宫', shiCi: '五世卦' });
  guaMap.set('巽兑', { name: '风泽中孚', symbol: '䷼', upper: '巽', lower: '兑', gongShu: '艮宫', shiCi: '游魂卦' });
  guaMap.set('巽艮', { name: '风山渐', symbol: '䷴', upper: '巽', lower: '艮', gongShu: '艮宫', shiCi: '归魂卦' });

  // 兑宫八卦
  guaMap.set('兑兑', { name: '兑为泽', symbol: '䷹', upper: '兑', lower: '兑', gongShu: '兑宫', shiCi: '本宫卦' });
  guaMap.set('兑坎', { name: '泽水困', symbol: '䷮', upper: '兑', lower: '坎', gongShu: '兑宫', shiCi: '一世卦' });
  guaMap.set('兑坤', { name: '泽地萃', symbol: '䷬', upper: '兑', lower: '坤', gongShu: '兑宫', shiCi: '二世卦' });
  guaMap.set('兑艮', { name: '泽山咸', symbol: '䷞', upper: '兑', lower: '艮', gongShu: '兑宫', shiCi: '三世卦' });
  guaMap.set('坎艮', { name: '水山蹇', symbol: '䷦', upper: '坎', lower: '艮', gongShu: '兑宫', shiCi: '四世卦' });
  guaMap.set('坤艮', { name: '地山谦', symbol: '䷎', upper: '坤', lower: '艮', gongShu: '兑宫', shiCi: '五世卦' });
  guaMap.set('震艮', { name: '雷山小过', symbol: '䷽', upper: '震', lower: '艮', gongShu: '兑宫', shiCi: '游魂卦' });
  guaMap.set('震兑', { name: '雷泽归妹', symbol: '䷵', upper: '震', lower: '兑', gongShu: '兑宫', shiCi: '归魂卦' });

  const key = upper + lower;
  const data = guaMap.get(key);
  if (data) {
    return data;
  }
  // 默认返回
  return { name: '未知卦', symbol: '䷀', upper: upper, lower: lower, gongShu: '乾宫', shiCi: '本宫卦' };
}

// 获取纳甲数据
function getNaJiaForGua(guaName: string): NaJiaItem | null {
  for (let i = 0; i < NAJIA_DATA.length; i++) {
    if (NAJIA_DATA[i].bagua === guaName) {
      return NAJIA_DATA[i];
    }
  }
  return null;
}

// 构建完整卦象
function buildGuaInfo(
  yaoResults: YaoGenerateResult[],
  riGan: string,
  isBenGua: boolean
): NaJiaGuaInfo {
  // 获取上下卦
  const lowerGua = getTrigramFromYaos(yaoResults[0].isYang, yaoResults[1].isYang, yaoResults[2].isYang);
  const upperGua = getTrigramFromYaos(yaoResults[3].isYang, yaoResults[4].isYang, yaoResults[5].isYang);

  // 获取卦数据
  const guaData = getGuaData(upperGua, lowerGua);
  const guaWuXing = getBaGuaWuXing(guaData.gongShu.replace('宫', ''));

  // 获取世应位置
  const shiYing = getShiYingPosition(guaData.gongShu, guaData.shiCi);

  // 获取六神
  const liuShenList = getLiuShenList(riGan);

  // 获取上下卦的纳甲数据
  const lowerNaJia = getNaJiaForGua(lowerGua);
  const upperNaJia = getNaJiaForGua(upperGua);

  // 构建六爻信息
  const yaoList: NaJiaYaoInfo[] = [];
  for (let i = 0; i < 6; i++) {
    const yaoResult = yaoResults[i];
    const position = i + 1;

    // 获取纳甲
    let naJiaStr = '';
    let yaoWuXing = '';
    if (position <= 3 && lowerNaJia) {
      // 下卦 (初爻到三爻对应纳甲数据的后三个)
      const naJiaYao = lowerNaJia.yaoWei[5 - (position - 1)];
      if (naJiaYao) {
        naJiaStr = naJiaYao.najia;
        yaoWuXing = naJiaYao.wuxing;
      }
    } else if (position > 3 && upperNaJia) {
      // 上卦 (四爻到上爻对应纳甲数据的前三个)
      const naJiaYao = upperNaJia.yaoWei[5 - (position - 1)];
      if (naJiaYao) {
        naJiaStr = naJiaYao.najia;
        yaoWuXing = naJiaYao.wuxing;
      }
    }

    // 如果纳甲数据获取失败，使用地支推算
    if (!yaoWuXing && naJiaStr.length >= 2) {
      yaoWuXing = getDiZhiWuXing(naJiaStr.charAt(1));
    }

    const yaoInfo: NaJiaYaoInfo = {
      position: position,
      positionName: getPositionName(position),
      yaoType: yaoResult.yaoType,
      yaoSymbol: yaoResult.yaoSymbol,
      isYang: yaoResult.isYang,
      isChanging: isBenGua ? yaoResult.isChanging : false,
      naJia: naJiaStr,
      wuXing: yaoWuXing,
      liuQin: getLiuQin(guaWuXing, yaoWuXing),
      liuShen: liuShenList[i],
      isShiYao: position === shiYing.shiPos,
      isYingYao: position === shiYing.yingPos,
      randomValue: yaoResult.randomValue
    };
    yaoList.push(yaoInfo);
  }

  // 计算卦序号
  let code = 0;
  for (let i = 5; i >= 0; i--) {
    code = code * 2 + (yaoResults[i].isYang ? 1 : 0);
  }
  code = code + 1;

  const guaInfo: NaJiaGuaInfo = {
    name: guaData.name,
    symbol: guaData.symbol,
    code: code,
    upperGua: upperGua,
    lowerGua: lowerGua,
    gongShu: guaData.gongShu,
    shiCi: guaData.shiCi,
    yaoList: yaoList
  };

  return guaInfo;
}

// 生成变卦的爻
function generateBianYao(yaoResults: YaoGenerateResult[]): YaoGenerateResult[] {
  const bianYaoResults: YaoGenerateResult[] = [];

  for (let i = 0; i < yaoResults.length; i++) {
    const originalYao = yaoResults[i];
    let newYao: YaoGenerateResult;

    if (originalYao.isChanging) {
      // 变爻需要转换
      if (originalYao.yaoType === NaJiaYaoType.OLD_YANG) {
        newYao = {
          position: originalYao.position,
          yaoType: NaJiaYaoType.YOUNG_YIN,
          yaoSymbol: '--',
          isYang: false,
          isChanging: false,
          randomValue: originalYao.randomValue
        };
      } else {
        newYao = {
          position: originalYao.position,
          yaoType: NaJiaYaoType.YOUNG_YANG,
          yaoSymbol: '—',
          isYang: true,
          isChanging: false,
          randomValue: originalYao.randomValue
        };
      }
    } else {
      newYao = {
        position: originalYao.position,
        yaoType: originalYao.yaoType,
        yaoSymbol: originalYao.yaoSymbol,
        isYang: originalYao.isYang,
        isChanging: false,
        randomValue: originalYao.randomValue
      };
    }
    bianYaoResults.push(newYao);
  }

  return bianYaoResults;
}

/**
 * 执行纳甲起卦
 */
export function performNaJiaQiGua(question: string): NaJiaQiGuaResult {
  // 获取当前日干支
  const riGanZhi = getCurrentRiGanZhi();

  // 生成六爻
  const yaoResults: YaoGenerateResult[] = [];
  for (let i = 1; i <= 6; i++) {
    yaoResults.push(generateYao(i));
  }

  // 构建本卦
  const benGua = buildGuaInfo(yaoResults, riGanZhi.riGan, true);

  // 生成变卦
  const bianYaoResults = generateBianYao(yaoResults);
  const bianGua = buildGuaInfo(bianYaoResults, riGanZhi.riGan, false);

  // 统计变爻数量
  let changingCount = 0;
  for (let i = 0; i < yaoResults.length; i++) {
    if (yaoResults[i].isChanging) {
      changingCount++;
    }
  }

  const result: NaJiaQiGuaResult = {
    benGua: benGua,
    bianGua: bianGua,
    changingCount: changingCount,
    riGan: riGanZhi.riGan,
    riZhi: riGanZhi.riZhi,
    timestamp: Date.now(),
    question: question
  };

  return result;
}

/**
 * 获取六亲颜色
 */
export function getLiuQinColor(liuQin: LiuQin): string {
  switch (liuQin) {
    case LiuQin.FU_MU: return '#9C27B0';    // 父母 - 紫色
    case LiuQin.XIONG_DI: return '#2196F3'; // 兄弟 - 蓝色
    case LiuQin.ZI_SUN: return '#4CAF50';   // 子孙 - 绿色
    case LiuQin.QI_CAI: return '#FF9800';   // 妻财 - 橙色
    case LiuQin.GUAN_GUI: return '#F44336'; // 官鬼 - 红色
    default: return '#666666';
  }
}

/**
 * 获取六神颜色
 */
export function getLiuShenColor(liuShen: LiuShen): string {
  switch (liuShen) {
    case LiuShen.QING_LONG: return '#4CAF50'; // 青龙 - 绿色
    case LiuShen.ZHU_QUE: return '#F44336';   // 朱雀 - 红色
    case LiuShen.GOU_CHEN: return '#795548';  // 勾陈 - 棕色
    case LiuShen.TENG_SHE: return '#9C27B0';  // 螣蛇 - 紫色
    case LiuShen.BAI_HU: return '#FFFFFF';    // 白虎 - 白色
    case LiuShen.XUAN_WU: return '#212121';   // 玄武 - 黑色
    default: return '#666666';
  }
}

/**
 * 获取爻类型颜色
 */
export function getYaoTypeColor(yaoType: NaJiaYaoType): string {
  switch (yaoType) {
    case NaJiaYaoType.OLD_YANG: return '#FF4444';   // 老阳 - 红色
    case NaJiaYaoType.YOUNG_YANG: return '#FF8800'; // 少阳 - 橙色
    case NaJiaYaoType.YOUNG_YIN: return '#4488FF';  // 少阴 - 蓝色
    case NaJiaYaoType.OLD_YIN: return '#8844FF';    // 老阴 - 紫色
    default: return '#666666';
  }
}

// 重新导出五行颜色函数
export { getWuXingColor };
