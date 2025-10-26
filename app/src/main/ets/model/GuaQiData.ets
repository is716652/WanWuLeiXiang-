/**
 * 卦气值日数据模型
 * 基于"六日七分"规则，从冬至开始的60卦轮值系统
 */

// 卦气值日项目接口
export interface GuaQiItem {
  index: number;           // 序号 1-60
  guaName: string;         // 卦名
  startTime: string;       // 开始时间 (MM-DD HH:mm)
  endTime: string;         // 结束时间 (MM-DD HH:mm)
  solarTerm: string;       // 当期节气段
  guaQiFeature: string;    // 卦气特征
  duration: string;        // 持续时长描述
}

// 年份卦气值日表接口
export interface YearGuaQi {
  year: number;
  dongzhiDate: string;     // 冬至日期
  guaQiList: GuaQiItem[];
}

// 六十值日卦固定顺序表（基于京房易学体系）
export const LIUSHI_ZHIRI_GUA_ORDER: string[] = [
  '中孚', '复', '屯', '谦', '睽', '升', '临', '小过', '蒙', '益',
  '渐', '泰', '履', '兑', '随', '无妄', '明夷', '贲', '既济', '家人',
  '丰', '革', '同人', '临', '观', '比', '剥', '坤', '师', '蒙',
  '坎', '涣', '解', '恒', '升', '井', '大过', '姤', '鼎', '巽',
  '恒', '鼎', '大壮', '豫', '解', '随', '蛊', '升', '讼', '旅',
  '未济', '困', '革', '蹇', '谦', '否', '萃', '晋', '豫', '观'
];



// 每卦值日时长：6日7分 = 8766分钟
export const GUA_DURATION_MINUTES = 8766;

/**
 * 获取冬至日期（简化处理）
 */
function getDongzhiDate(year: number): string {
  switch (year) {
    // 2010-2019年
    case 2010: return '12-22';
    case 2011: return '12-22';
    case 2012: return '12-21';
    case 2013: return '12-21';
    case 2014: return '12-22';
    case 2015: return '12-22';
    case 2016: return '12-21';
    case 2017: return '12-22';
    case 2018: return '12-22';
    case 2019: return '12-22';
    
    // 2020-2030年
    case 2020: return '12-21';
    case 2021: return '12-21';
    case 2022: return '12-22';
    case 2023: return '12-22';
    case 2024: return '12-21';
    case 2025: return '12-21';
    case 2026: return '12-21';
    case 2027: return '12-22';
    case 2028: return '12-21';
    case 2029: return '12-21';
    case 2030: return '12-21';
    
    // 2031-2040年
    case 2031: return '12-22';
    case 2032: return '12-21';
    case 2033: return '12-21';
    case 2034: return '12-22';
    case 2035: return '12-22';
    case 2036: return '12-21';
    case 2037: return '12-21';
    case 2038: return '12-22';
    case 2039: return '12-22';
    case 2040: return '12-21';
    
    default: return '12-21';
  }
}

/**
 * 生成指定年份的卦气值日表
 */
export function generateGuaQiTable(year: number): YearGuaQi {
  // 获取冬至日期（简化处理）
  const dongzhiDate = getDongzhiDate(year);
  
  // 解析冬至日期
  const dateParts = dongzhiDate.split('-');
  const month = parseInt(dateParts[0]);
  const day = parseInt(dateParts[1]);
  const dongzhiDateTime = new Date(year, month - 1, day, 0, 0, 0);
  
  const guaQiList: GuaQiItem[] = [];
  
  // 生成60卦的值日表
  for (let i = 0; i < 60; i++) {
    const guaName = LIUSHI_ZHIRI_GUA_ORDER[i];
    const startTime = new Date(dongzhiDateTime.getTime() + i * GUA_DURATION_MINUTES * 60 * 1000);
    const endTime = new Date(startTime.getTime() + GUA_DURATION_MINUTES * 60 * 1000);
    
    // 格式化时间（只显示月日时分）
    const formatTime = (date: Date): string => {
      const month = (date.getMonth() + 1).toString().padStart(2, '0');
      const day = date.getDate().toString().padStart(2, '0');
      const hour = date.getHours().toString().padStart(2, '0');
      const minute = date.getMinutes().toString().padStart(2, '0');
      return `${month}-${day} ${hour}:${minute}`;
    };
    
    // 确定当期节气段（简化处理）
    const startMonth = startTime.getMonth() + 1;
    let solarTerm = '';
    if (startMonth === 12 || startMonth === 1) {
      solarTerm = '冬至-小寒';
    } else if (startMonth === 1 || startMonth === 2) {
      solarTerm = '小寒-大寒';
    } else if (startMonth === 2 || startMonth === 3) {
      solarTerm = '大寒-立春';
    } else if (startMonth === 3 || startMonth === 4) {
      solarTerm = '立春-雨水';
    } else if (startMonth === 4 || startMonth === 5) {
      solarTerm = '雨水-惊蛰';
    } else if (startMonth === 5 || startMonth === 6) {
      solarTerm = '惊蛰-春分';
    } else if (startMonth === 6 || startMonth === 7) {
      solarTerm = '春分-清明';
    } else if (startMonth === 7 || startMonth === 8) {
      solarTerm = '清明-谷雨';
    } else if (startMonth === 8 || startMonth === 9) {
      solarTerm = '谷雨-立夏';
    } else if (startMonth === 9 || startMonth === 10) {
      solarTerm = '立夏-小满';
    } else if (startMonth === 10 || startMonth === 11) {
      solarTerm = '小满-芒种';
    } else {
      solarTerm = '芒种-夏至';
    }
    
    const guaQiItem: GuaQiItem = {
      index: i + 1,
      guaName: guaName,
      startTime: formatTime(startTime),
      endTime: formatTime(endTime),
      solarTerm: solarTerm,
      guaQiFeature: getGuaQiFeature(guaName),
      duration: '6日7分'
    };
    
    guaQiList.push(guaQiItem);
  }
  
  return {
    year: year,
    dongzhiDate: `${year}-${dongzhiDate}`,
    guaQiList: guaQiList
  };
}

/**
 * 获取卦气特征描述
 */
function getGuaQiFeature(guaName: string): string {
  switch (guaName) {
    case '中孚': return '阳气初生，微温';
    case '复': return '一阳来复，草木萌动';
    case '屯': return '创始艰难，郁结未通';
    case '谦': return '谦和卑下，地中有山';
    case '睽': return '二女相违，乖异求同';
    case '升': return '地中生木，柔顺上进';
    case '临': return '二阳渐长，临近春意';
    case '小过': return '小有过越，雷在山上';
    case '蒙': return '山下出泉，启蒙教育';
    case '益': return '风雷相益，损上益下';
    case '渐': return '山上有木，渐进发展';
    case '泰': return '天地交泰，万物通达';
    case '履': return '天泽履，礼仪之道';
    case '兑': return '泽泽相连，和悦欢乐';
    case '随': return '泽中有雷，随时而动';
    case '无妄': return '天下雷行，无妄而动';
    case '明夷': return '地火明夷，光明受伤';
    case '贲': return '山火贲，文明装饰';
    case '既济': return '水火既济，功德圆满';
    case '家人': return '风火家人，齐家治国';
    case '丰': return '雷火丰，盛大丰满';
    case '革': return '泽火革，变革更新';
    case '同人': return '天火同人，同心协力';
    case '观': return '风地观，观察省思';
    case '比': return '水地比，亲密比附';
    case '剥': return '山地剥，剥落衰败';
    case '坤': return '地地坤，厚德载物';
    case '师': return '地水师，众人之师';
    case '坎': return '水水坎，险阻重重';
    case '涣': return '风水涣，涣散离析';
    case '解': return '雷水解，解除困难';
    case '恒': return '雷风恒，恒久不变';
    case '井': return '水风井，井养不穷';
    case '大过': return '泽风大过，大有过越';
    case '姤': return '天风姤，天下有风';
    case '鼎': return '火风鼎，革故鼎新';
    case '巽': return '风风巽，谦逊顺从';
    case '大壮': return '雷天大壮，刚健有力';
    case '豫': return '雷地豫，和乐安逸';
    case '蛊': return '山风蛊，整治腐败';
    case '讼': return '天水讼，争讼不休';
    case '旅': return '火山旅，行旅在外';
    case '未济': return '火水未济，事未完成';
    case '困': return '泽水困，困顿艰难';
    case '蹇': return '水山蹇，艰难险阻';
    case '否': return '天地否，闭塞不通';
    case '萃': return '泽地萃，聚集荟萃';
    case '晋': return '火地晋，光明上进';
    default: return '卦气特征';
  }
}

/**
 * 获取卦气颜色（基于五行）
 */
export function getGuaQiColor(guaName: string): string {
  // 根据卦名首字判断五行颜色
  const firstChar = guaName.charAt(0);
  
  switch (firstChar) {
    case '中': case '复': case '蒙': case '坎': case '涣': case '解': case '井': case '师': case '比': case '困': case '蹇': case '讼':
      return '#4444FF'; // 水 - 蓝色
    case '屯': case '升': case '益': case '渐': case '无': case '观': case '恒': case '姤': case '巽': case '蛊': case '丰':
      return '#22AA22'; // 木 - 绿色
    case '明': case '贲': case '家': case '革': case '同': case '鼎': case '旅': case '未': case '晋':
      return '#FF4444'; // 火 - 红色
    case '谦': case '泰': case '剥': case '坤': case '大': case '豫': case '否': case '萃':
      return '#AA6600'; // 土 - 棕色
    case '睽': case '履': case '兑': case '随':
      return '#FFD700'; // 金 - 金色
    default:
      return '#8E24AA'; // 默认紫色
  }
}