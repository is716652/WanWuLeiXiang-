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
  '否': 'pi'
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
      message: `抱歉，${benGuaName}卦的易林数据暂未收录。\n目前已收录：${availableGuaNames.join('、')}等10卦。\n完整64卦数据正在整理中...`
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
    return `${benGuaName}之${zhiGuaName}：本卦${benGuaName}为当前状况，之卦${zhiGuaName}为发展趋势。变爻指示了变化的关键点。`;
  } else {
    return `${benGuaName}卦：卦象稳定，无变爻，当前状况相对稳定，可参考本卦的整体含义。`;
  }
}