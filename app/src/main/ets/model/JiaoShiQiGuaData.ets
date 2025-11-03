/**
 * 焦氏易林起卦数据模型
 * 基于六爻同时生成法，模拟传统硬币起卦
 */

// 爻的类型枚举
export enum YaoType {
  OLD_YANG = 'OLD_YANG',     // 老阳 (变爻)
  YOUNG_YIN = 'YOUNG_YIN',   // 少阴
  YOUNG_YANG = 'YOUNG_YANG', // 少阳
  OLD_YIN = 'OLD_YIN'        // 老阴 (变爻)
}

// 爻信息接口
export interface YaoInfo {
  type: YaoType;           // 爻的类型
  symbol: string;          // 爻的符号 (—, --, O, X)
  name: string;            // 爻的名称
  isChanging: boolean;     // 是否为变爻
  position: number;        // 爻位 (1-6)
  randomValue: number;     // 生成的随机数
}

// 卦信息接口
export interface GuaInfo {
  name: string;            // 卦名
  symbol: string;          // 卦象符号
  code: number;            // 卦序号 (1-64)
  upperGua: string;        // 上卦
  lowerGua: string;        // 下卦
  yaoList: YaoInfo[];      // 六爻列表
}

// 起卦结果接口
export interface QiGuaResult {
  benGua: GuaInfo;         // 本卦
  zhiGua: GuaInfo;         // 之卦
  changingYaoCount: number; // 变爻数量
  timestamp: number;       // 起卦时间戳
  question?: string;       // 问卦内容
}

// 卦基础数据接口
interface GuaBaseData {
  name: string;
  symbol: string;
  upper: string;
  lower: string;
}

// 焦氏易林起卦核心算法

/**
 * 生成单个爻
 * 基于随机数确定爻的类型
 */
function generateYao(position: number): YaoInfo {
  const randomValue = Math.floor(Math.random() * 100) + 1; // 1-100
  
  let type: YaoType;
  let symbol: string;
  let name: string;
  let isChanging: boolean;
  
  if (randomValue <= 20) {
    // 老阳 (变爻) - 20%概率
    type = YaoType.OLD_YANG;
    symbol = 'O';
    name = '老阳';
    isChanging = true;
  } else if (randomValue <= 49) {
    // 少阴 - 29%概率
    type = YaoType.YOUNG_YIN;
    symbol = '--';
    name = '少阴';
    isChanging = false;
  } else if (randomValue <= 79) {
    // 少阳 - 30%概率
    type = YaoType.YOUNG_YANG;
    symbol = '—';
    name = '少阳';
    isChanging = false;
  } else {
    // 老阴 (变爻) - 21%概率
    type = YaoType.OLD_YIN;
    symbol = 'X';
    name = '老阴';
    isChanging = true;
  }
  
  const yaoInfo: YaoInfo = {
    type: type,
    symbol: symbol,
    name: name,
    isChanging: isChanging,
    position: position,
    randomValue: randomValue
  };
  
  return yaoInfo;
}

/**
 * 根据六爻生成卦序号
 */
function getGuaCode(yaoList: YaoInfo[]): number {
  // 将爻转换为二进制数组 (1为阳，0为阴)
  const binaryArray: number[] = [];
  
  // 从下到上 (初爻到上爻)
  for (let i = 0; i < 6; i++) {
    const yao = yaoList[i];
    if (yao.type === YaoType.OLD_YANG || yao.type === YaoType.YOUNG_YANG) {
      binaryArray.push(1); // 阳爻
    } else {
      binaryArray.push(0); // 阴爻
    }
  }
  
  // 计算卦序号 (从上到下计算)
  let code = 0;
  for (let i = 5; i >= 0; i--) {
    code = code * 2 + binaryArray[i];
  }
  
  return code + 1; // 卦序号从1开始
}

/**
 * 获取卦数据
 */
function getGuaData(code: number): GuaBaseData | null {
  let result: GuaBaseData | null = null;
  
  switch (code) {
    case 1: 
      result = { name: '乾', symbol: '䷀', upper: '乾', lower: '乾' };
      break;
    case 2: 
      result = { name: '坤', symbol: '䷁', upper: '坤', lower: '坤' };
      break;
    case 3: 
      result = { name: '屯', symbol: '䷂', upper: '坎', lower: '震' };
      break;
    case 4: 
      result = { name: '蒙', symbol: '䷃', upper: '艮', lower: '坎' };
      break;
    case 5: 
      result = { name: '需', symbol: '䷄', upper: '坎', lower: '乾' };
      break;
    case 6: 
      result = { name: '讼', symbol: '䷅', upper: '乾', lower: '坎' };
      break;
    case 7: 
      result = { name: '师', symbol: '䷆', upper: '坤', lower: '坎' };
      break;
    case 8: 
      result = { name: '比', symbol: '䷇', upper: '坎', lower: '坤' };
      break;
    case 9: 
      result = { name: '小畜', symbol: '䷈', upper: '巽', lower: '乾' };
      break;
    case 10: 
      result = { name: '履', symbol: '䷉', upper: '乾', lower: '兑' };
      break;
    case 11: 
      result = { name: '泰', symbol: '䷊', upper: '坤', lower: '乾' };
      break;
    case 12: 
      result = { name: '否', symbol: '䷋', upper: '乾', lower: '坤' };
      break;
    case 13: 
      result = { name: '同人', symbol: '䷌', upper: '乾', lower: '离' };
      break;
    case 14: 
      result = { name: '大有', symbol: '䷍', upper: '离', lower: '乾' };
      break;
    case 15: 
      result = { name: '谦', symbol: '䷎', upper: '坤', lower: '艮' };
      break;
    case 16: 
      result = { name: '豫', symbol: '䷏', upper: '震', lower: '坤' };
      break;
    case 17: 
      result = { name: '随', symbol: '䷐', upper: '兑', lower: '震' };
      break;
    case 18: 
      result = { name: '蛊', symbol: '䷑', upper: '艮', lower: '巽' };
      break;
    case 19: 
      result = { name: '临', symbol: '䷒', upper: '坤', lower: '兑' };
      break;
    case 20: 
      result = { name: '观', symbol: '䷓', upper: '巽', lower: '坤' };
      break;
    case 21: 
      result = { name: '噬嗑', symbol: '䷔', upper: '离', lower: '震' };
      break;
    case 22: 
      result = { name: '贲', symbol: '䷕', upper: '艮', lower: '离' };
      break;
    case 23: 
      result = { name: '剥', symbol: '䷖', upper: '艮', lower: '坤' };
      break;
    case 24: 
      result = { name: '复', symbol: '䷗', upper: '坤', lower: '震' };
      break;
    case 25: 
      result = { name: '无妄', symbol: '䷘', upper: '乾', lower: '震' };
      break;
    case 26: 
      result = { name: '大畜', symbol: '䷙', upper: '艮', lower: '乾' };
      break;
    case 27: 
      result = { name: '颐', symbol: '䷚', upper: '艮', lower: '震' };
      break;
    case 28: 
      result = { name: '大过', symbol: '䷛', upper: '兑', lower: '巽' };
      break;
    case 29: 
      result = { name: '坎', symbol: '䷜', upper: '坎', lower: '坎' };
      break;
    case 30: 
      result = { name: '离', symbol: '䷝', upper: '离', lower: '离' };
      break;
    case 31: 
      result = { name: '咸', symbol: '䷞', upper: '兑', lower: '艮' };
      break;
    case 32: 
      result = { name: '恒', symbol: '䷟', upper: '震', lower: '巽' };
      break;
    case 33: 
      result = { name: '遁', symbol: '䷠', upper: '乾', lower: '艮' };
      break;
    case 34: 
      result = { name: '大壮', symbol: '䷡', upper: '震', lower: '乾' };
      break;
    case 35: 
      result = { name: '晋', symbol: '䷢', upper: '离', lower: '坤' };
      break;
    case 36: 
      result = { name: '明夷', symbol: '䷣', upper: '坤', lower: '离' };
      break;
    case 37: 
      result = { name: '家人', symbol: '䷤', upper: '巽', lower: '离' };
      break;
    case 38: 
      result = { name: '睽', symbol: '䷥', upper: '离', lower: '兑' };
      break;
    case 39: 
      result = { name: '蹇', symbol: '䷦', upper: '坎', lower: '艮' };
      break;
    case 40: 
      result = { name: '解', symbol: '䷧', upper: '震', lower: '坎' };
      break;
    case 41: 
      result = { name: '损', symbol: '䷨', upper: '艮', lower: '兑' };
      break;
    case 42: 
      result = { name: '益', symbol: '䷩', upper: '巽', lower: '震' };
      break;
    case 43: 
      result = { name: '夬', symbol: '䷪', upper: '兑', lower: '乾' };
      break;
    case 44: 
      result = { name: '姤', symbol: '䷫', upper: '乾', lower: '巽' };
      break;
    case 45: 
      result = { name: '萃', symbol: '䷬', upper: '兑', lower: '坤' };
      break;
    case 46: 
      result = { name: '升', symbol: '䷭', upper: '坤', lower: '巽' };
      break;
    case 47: 
      result = { name: '困', symbol: '䷮', upper: '兑', lower: '坎' };
      break;
    case 48: 
      result = { name: '井', symbol: '䷯', upper: '坎', lower: '巽' };
      break;
    case 49: 
      result = { name: '革', symbol: '䷰', upper: '兑', lower: '离' };
      break;
    case 50: 
      result = { name: '鼎', symbol: '䷱', upper: '离', lower: '巽' };
      break;
    case 51: 
      result = { name: '震', symbol: '䷲', upper: '震', lower: '震' };
      break;
    case 52: 
      result = { name: '艮', symbol: '䷳', upper: '艮', lower: '艮' };
      break;
    case 53: 
      result = { name: '渐', symbol: '䷴', upper: '巽', lower: '艮' };
      break;
    case 54: 
      result = { name: '归妹', symbol: '䷵', upper: '震', lower: '兑' };
      break;
    case 55: 
      result = { name: '丰', symbol: '䷶', upper: '震', lower: '离' };
      break;
    case 56: 
      result = { name: '旅', symbol: '䷷', upper: '离', lower: '艮' };
      break;
    case 57: 
      result = { name: '巽', symbol: '䷸', upper: '巽', lower: '巽' };
      break;
    case 58: 
      result = { name: '兑', symbol: '䷹', upper: '兑', lower: '兑' };
      break;
    case 59: 
      result = { name: '涣', symbol: '䷺', upper: '巽', lower: '坎' };
      break;
    case 60: 
      result = { name: '节', symbol: '䷻', upper: '坎', lower: '兑' };
      break;
    case 61: 
      result = { name: '中孚', symbol: '䷼', upper: '巽', lower: '兑' };
      break;
    case 62: 
      result = { name: '小过', symbol: '䷽', upper: '震', lower: '艮' };
      break;
    case 63: 
      result = { name: '既济', symbol: '䷾', upper: '坎', lower: '离' };
      break;
    case 64: 
      result = { name: '未济', symbol: '䷿', upper: '离', lower: '坎' };
      break;
    default:
      result = { name: `未知卦${code}`, symbol: '䷀', upper: '乾', lower: '乾' };
      break;
  }
  
  return result;
}

/**
 * 创建卦信息
 */
function createGuaInfo(yaoList: YaoInfo[]): GuaInfo {
  const code = getGuaCode(yaoList);
  const guaData = getGuaData(code);
  
  if (!guaData) {
    throw new Error(`无效的卦序号: ${code}`);
  }
  
  const guaInfo: GuaInfo = {
    name: guaData.name,
    symbol: guaData.symbol,
    code: code,
    upperGua: guaData.upper,
    lowerGua: guaData.lower,
    yaoList: yaoList
  };
  
  return guaInfo;
}

/**
 * 生成变卦 (之卦)
 */
function generateZhiGua(benGua: GuaInfo): GuaInfo {
  const newYaoList: YaoInfo[] = [];
  
  for (let i = 0; i < benGua.yaoList.length; i++) {
    const originalYao = benGua.yaoList[i];
    let newYao: YaoInfo;
    
    if (originalYao.isChanging) {
      // 变爻需要转换
      if (originalYao.type === YaoType.OLD_YANG) {
        // 老阳变少阴
        newYao = {
          type: YaoType.YOUNG_YIN,
          symbol: '--',
          name: '少阴',
          isChanging: false,
          position: originalYao.position,
          randomValue: originalYao.randomValue
        } as YaoInfo;
      } else {
        // 老阴变少阳
        newYao = {
          type: YaoType.YOUNG_YANG,
          symbol: '—',
          name: '少阳',
          isChanging: false,
          position: originalYao.position,
          randomValue: originalYao.randomValue
        } as YaoInfo;
      }
    } else {
      // 非变爻保持不变
      newYao = {
        type: originalYao.type,
        symbol: originalYao.symbol,
        name: originalYao.name,
        isChanging: false,
        position: originalYao.position,
        randomValue: originalYao.randomValue
      } as YaoInfo;
    }
    
    newYaoList.push(newYao);
  }
  
  return createGuaInfo(newYaoList);
}

/**
 * 执行起卦
 * 六爻同时生成法
 */
export function performQiGua(question?: string): QiGuaResult {
  // 生成六个爻 (从初爻到上爻)
  const yaoList: YaoInfo[] = [];
  for (let i = 1; i <= 6; i++) {
    yaoList.push(generateYao(i));
  }
  
  // 生成本卦
  const benGua = createGuaInfo(yaoList);
  
  // 生成之卦
  const zhiGua = generateZhiGua(benGua);
  
  // 统计变爻数量
  const changingYaoCount = yaoList.filter(yao => yao.isChanging).length;
  
  const result: QiGuaResult = {
    benGua: benGua,
    zhiGua: zhiGua,
    changingYaoCount: changingYaoCount,
    timestamp: Date.now(),
    question: question
  };
  
  return result;
}

/**
 * 获取爻的颜色
 */
export function getYaoColor(yao: YaoInfo): string {
  switch (yao.type) {
    case YaoType.OLD_YANG:
      return '#FF4444'; // 老阳 - 红色
    case YaoType.YOUNG_YANG:
      return '#FF8800'; // 少阳 - 橙色
    case YaoType.YOUNG_YIN:
      return '#4488FF'; // 少阴 - 蓝色
    case YaoType.OLD_YIN:
      return '#8844FF'; // 老阴 - 紫色
    default:
      return '#666666';
  }
}

/**
 * 获取卦的颜色 (基于五行)
 */
export function getGuaColor(guaName: string): string {
  switch (guaName) {
    case '乾': case '兑': case '履': case '夬': case '姤': case '大畜': case '大壮': case '泰': case '需': case '小畜':
      return '#FFD700'; // 金 - 金色
    case '震': case '巽': case '随': case '蛊': case '益': case '恒': case '升': case '井': case '大过': case '渐':
      return '#22AA22'; // 木 - 绿色
    case '离': case '同人': case '大有': case '噬嗑': case '贲': case '明夷': case '家人': case '睽': case '革': case '鼎':
      return '#FF4444'; // 火 - 红色
    case '坤': case '艮': case '谦': case '豫': case '剥': case '复': case '颐': case '损': case '萃': case '升':
      return '#AA6600'; // 土 - 棕色
    case '坎': case '蒙': case '师': case '比': case '临': case '观': case '蹇': case '解': case '困': case '井':
      return '#4444FF'; // 水 - 蓝色
    default:
      return '#8E24AA'; // 默认紫色
  }
}