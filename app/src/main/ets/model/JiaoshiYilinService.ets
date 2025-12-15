/**
 * 焦氏易林服务
 * 提供卦象查询和解卦功能
 */

import { resourceManager } from '@kit.LocalizationKit';
import util from '@ohos.util';

export interface GuaInfo {
  guaName: string;
  guaNumber: number;
  guaSymbol: string;
  upperTrigram: string;
  lowerTrigram: string;
  upperTrigramMeaning: string;
  lowerTrigramMeaning: string;
  upperTrigramAttribute: string;
  lowerTrigramAttribute: string;
  description: string;
}

export interface BenGuaInfo {
  text: string;
  yiyi: string;
  xiangzheng: string;
}

export interface ZhiGuaInfo {
  targetGua: string;
  guaNumber: number;
  text: string;
  yiyi: string;
  xiangzheng: string;
}

export interface JiaoshiYilinData {
  guaInfo: GuaInfo;
  benGua: BenGuaInfo;
  zhiGua: ZhiGuaInfo[];
}

export interface JieGuaResult {
  benGuaInfo: JiaoshiYilinData | null;
  zhiGuaInfo: ZhiGuaInfo | null;
  isAvailable: boolean;
  message: string;
}

/**
 * 卦名到文件名的映射
 */
const guaNameToFile: Record<string, string> = {
  '乾': 'qian',
  '坤': 'kun', 
  '屯': 'zhun',
  '蒙': 'meng',
  '需': 'xu',
  '讼': 'song',
  '师': 'shi',
  '比': 'bi',
  '小畜': 'xiaoxu',
  '履': 'lv',
  '泰': 'tai',
  '否': 'pi',
  '同人': 'tongren',
  '大有': 'dayou',
  '谦': 'qian_modesty',
  '豫': 'yu',
  // 新增三卦映射
  '随': 'sui',
  '蛊': 'gu',
  '临': 'lin',
  // 新增：观、噬嗑
  '观': 'guan',
  '噬嗑': 'shihe',
  // 新增：坎、离
  '坎': 'kan',
  '离': 'li',
  // 新增：咸、恒、遁、大壮（31-34）
  '咸': 'xian',
  '恒': 'heng',
  '遁': 'dun',
  '大壮': 'dazhuang',
  // 新增：晋、明夷、家人、睽、蹇、解、损、益（35-42）
  '晋': 'jin',
  '明夷': 'mingyi',
  '家人': 'jiaren',
  '睽': 'kui',
  '蹇': 'jian',
  '解': 'jie',
  '损': 'sun',
  '益': 'yi_benefit',
  // 新增：夬、姤、萃（43-45）
  '夬': 'guai',
  '姤': 'gou',
  '萃': 'cui',
  // 新增：升、困、井、革（46-49）
  '升': 'sheng',
  '困': 'kun_difficulty',
  '井': 'jing',
  '革': 'ge',
  // 新增：旅、巽（56-57）
  '旅': 'lv_travel',
  '巽': 'xun'
};

/**
 * 可用的卦名列表
 */
export const availableGuaNames = Object.keys(guaNameToFile);

/**
 * 检查卦是否可用
 */
export function isGuaAvailable(guaName: string): boolean {
  return guaNameToFile[guaName] !== undefined;
}

/**
 * 加载卦数据
 */
export async function loadGuaData(guaName: string): Promise<JiaoshiYilinData | null> {
  try {
    const fileName = guaNameToFile[guaName];
    if (!fileName) {
      return null;
    }

    const context = getContext();
    const mgr = context.resourceManager;
    const fileData = await mgr.getRawFileContent(`JiaoshiYilin/${fileName}.json`);
    const textDecoder = util.TextDecoder.create('utf-8');
    const jsonString = textDecoder.decodeWithStream(fileData);
    const data = JSON.parse(jsonString) as JiaoshiYilinData;
    return data;
  } catch (error) {
    console.error('加载卦数据失败:', error);
    return null;
  }
}

/**
 * 解卦功能
 * @param benGuaName 本卦名称
 * @param zhiGuaName 之卦名称（可选）
 * @returns 解卦结果
 */
export async function performJieGua(benGuaName: string, zhiGuaName?: string): Promise<JieGuaResult> {
  // 检查本卦是否可用
  if (!isGuaAvailable(benGuaName)) {
    return {
      benGuaInfo: null,
      zhiGuaInfo: null,
      isAvailable: false,
      message: `抱歉，${benGuaName}卦的易林数据暂未收录。\n目前已收录：${availableGuaNames.join('、')}等${availableGuaNames.length}卦。\n完整64卦数据正在整理中...`
    };
  }

  // 加载本卦数据
  const benGuaData = await loadGuaData(benGuaName);
  if (!benGuaData) {
    return {
      benGuaInfo: null,
      zhiGuaInfo: null,
      isAvailable: false,
      message: `加载${benGuaName}卦数据失败，请稍后重试。`
    };
  }

  let zhiGuaInfo: ZhiGuaInfo | null = null;
  let message = '';

  // 如果有之卦，查找对应的之卦信息
  if (zhiGuaName) {
    zhiGuaInfo = benGuaData.zhiGua.find(zg => zg.targetGua === zhiGuaName) || null;
    
    if (zhiGuaInfo) {
      message = `${benGuaName}之${zhiGuaName}卦象解析`;
    } else {
      message = `找到${benGuaName}卦，但未找到对应的${zhiGuaName}之卦信息。`;
    }
  } else {
    message = `${benGuaName}卦象解析（本卦）`;
  }

  return {
    benGuaInfo: benGuaData,
    zhiGuaInfo: zhiGuaInfo,
    isAvailable: true,
    message: message
  };
}

/**
 * 获取卦象组合的解释
 */
export function getGuaCombinationExplanation(benGuaName: string, zhiGuaName?: string): string {
  if (zhiGuaName) {
    return `本卦${benGuaName}为当前状况，之卦${zhiGuaName}为发展趋势。变爻指示了变化的关键点。`;
  } else {
    return `卦象稳定，无变爻，当前状况相对稳定，可参考本卦的整体含义。`;
  }
}