/**
 * 分卦值日数据模型
 * 基于"六日七分"规则，每卦6天分别由六爻统领
 */

// 爻位信息接口
export interface YaoInfo {
  yaoPosition: string;     // 爻位 (初爻、二爻、三爻、四爻、五爻、上爻)
  yaoSymbol: string;       // 爻象 (如：初九、六二等)
  yaoText: string;         // 爻辞
  yaoMeaning: string;      // 爻义解释
  dayIndex: number;        // 第几日 (1-6)
  date: string;           // 具体日期 (MM-DD)
  time: string;           // 时间段 (HH:mm-HH:mm)
}

// 分卦值日项目接口
export interface FenGuaZhiRiItem {
  guaName: string;         // 卦名
  guaIndex: number;        // 卦序号 (1-60)
  startDate: string;       // 卦值日开始日期
  endDate: string;         // 卦值日结束日期
  solarTerm: string;       // 当期节气段
  yaoList: YaoInfo[];      // 六爻值日列表
  guaQiFeature: string;    // 卦气特征
}

// 年份分卦值日表接口
export interface YearFenGuaZhiRi {
  year: number;
  dongzhiDate: string;
  fenGuaList: FenGuaZhiRiItem[];
}

// 六十四卦爻辞数据（简化版，重点展示分卦值日概念）

// 每日时长：24小时 = 1440分钟
const DAY_DURATION_MINUTES = 1440;

/**
 * 获取卦的爻辞数据（如果没有数据则生成通用版本）
 */
function getGuaYaoData(guaName: string): YaoInfo[] {
  switch (guaName) {
    case '中孚':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '虞吉，有它不燕。', yaoMeaning: '爻气初现，需安守诚信，谨慎初始之变', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '鸣鹤在阴，其子和之。', yaoMeaning: '阴阳感应，同类相求，是沟通、呼应之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '得敌，或鼓或罢，或泣或歌。', yaoMeaning: '爻位不中不正，面临对立，情绪多变，是反复不定之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '月几望，马匹亡，无咎。', yaoMeaning: '阴爻居阴位，柔顺得正。接近圆满时需舍弃赘余，是权衡与抉择之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '有孚挛如，无咎。', yaoMeaning: '君位中正，以诚信维系天下，是团结、巩固、发布政令的吉日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '翰音登于天，贞凶。', yaoMeaning: '诚信过度而至于虚声，名不副实，是需警惕浮华、务实避凶之日', dayIndex: 6, date: '', time: '' }
      ];
    case '复':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '不远复，无祗悔，元吉。', yaoMeaning: '一阳来复，及时回归正道，是反省改过的吉日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '休复，吉。', yaoMeaning: '柔顺而复，安然回归，是休养生息的平和之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '频复，厉无咎。', yaoMeaning: '反复不定，虽有危险但无大咎，是需要坚持的考验之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '中行独复。', yaoMeaning: '独自行走正道，是坚持原则、不随波逐流之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '敦复，无悔。', yaoMeaning: '敦厚诚实地回归，是诚心改过、重新开始的好日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '迷复，凶，有灾眚。', yaoMeaning: '迷失方向，复归无路，是需要警惕迷失、避免灾祸之日', dayIndex: 6, date: '', time: '' }
      ];
    case '屯':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '磐桓，利居贞，利建侯。', yaoMeaning: '创始之初，宜守正道，是建立基础的重要之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '屯如邅如，乘马班如。', yaoMeaning: '进退两难，行进艰难，是需要耐心等待时机之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '即鹿无虞，惟入于林中。', yaoMeaning: '盲目追求，缺乏指导，是容易迷失方向的危险之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '乘马班如，求婚媾。', yaoMeaning: '寻求合作，建立联盟，是沟通协调、寻求帮助之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '屯其膏，小贞吉，大贞凶。', yaoMeaning: '积蓄实力，小事可成，大事宜缓，是积累准备之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '乘马班如，泣血涟如。', yaoMeaning: '困难重重，进退维谷，是最艰难困苦的考验之日', dayIndex: 6, date: '', time: '' }
      ];
    default:
      break;
  }
  
  // 如果没有具体爻辞数据，生成通用版本
  const yaoPositions = ['初爻', '二爻', '三爻', '四爻', '五爻', '上爻'];
  const yaoSymbols = ['初九', '六二', '六三', '六四', '九五', '上九']; // 简化处理
  
  const result: YaoInfo[] = [];
  for (let index = 0; index < yaoPositions.length; index++) {
    const position = yaoPositions[index];
    const yaoInfo: YaoInfo = {
      yaoPosition: position,
      yaoSymbol: yaoSymbols[index],
      yaoText: `${guaName}${position}爻辞`,
      yaoMeaning: `${guaName}卦${position}主导之日，宜观察${position}爻象变化`,
      dayIndex: index + 1,
      date: '',
      time: ''
    };
    result.push(yaoInfo);
  }
  
  return result;
}

/**
 * 格式化日期为 MM-DD 格式
 */
function formatDate(date: Date): string {
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const day = date.getDate().toString().padStart(2, '0');
  return `${month}-${day}`;
}

/**
 * 格式化时间为 HH:mm 格式
 */
function formatTime(date: Date): string {
  const hour = date.getHours().toString().padStart(2, '0');
  const minute = date.getMinutes().toString().padStart(2, '0');
  return `${hour}:${minute}`;
}

/**
 * 获取冬至日期（复用GuaQiData中的逻辑）
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
 * 获取卦气特征描述（复用GuaQiData中的逻辑）
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
 * 生成指定年份的分卦值日表
 */
export function generateFenGuaZhiRiTable(year: number): YearFenGuaZhiRi {
  // 六十值日卦固定顺序表（复用GuaQiData中的数据）
  const LIUSHI_ZHIRI_GUA_ORDER: string[] = [
    '中孚', '复', '屯', '谦', '睽', '升', '临', '小过', '蒙', '益',
    '渐', '泰', '履', '兑', '随', '无妄', '明夷', '贲', '既济', '家人',
    '丰', '革', '同人', '临', '观', '比', '剥', '坤', '师', '蒙',
    '坎', '涣', '解', '恒', '升', '井', '大过', '姤', '鼎', '巽',
    '恒', '鼎', '大壮', '豫', '解', '随', '蛊', '升', '讼', '旅',
    '未济', '困', '革', '蹇', '谦', '否', '萃', '晋', '豫', '观'
  ];

  // 获取冬至日期
  const dongzhiDate = getDongzhiDate(year);
  
  // 解析冬至日期
  const dateParts = dongzhiDate.split('-');
  const month = parseInt(dateParts[0]);
  const day = parseInt(dateParts[1]);
  const dongzhiDateTime = new Date(year, month - 1, day, 0, 0, 0);
  
  const fenGuaList: FenGuaZhiRiItem[] = [];
  
  // 每卦值日时长：6日7分 = 8766分钟
  const GUA_DURATION_MINUTES = 8766;
  
  // 生成60卦的分卦值日表
  for (let i = 0; i < 60; i++) {
    const guaName = LIUSHI_ZHIRI_GUA_ORDER[i];
    const guaStartTime = new Date(dongzhiDateTime.getTime() + i * GUA_DURATION_MINUTES * 60 * 1000);
    const guaEndTime = new Date(guaStartTime.getTime() + GUA_DURATION_MINUTES * 60 * 1000);
    
    // 获取该卦的爻辞数据
    const yaoData = getGuaYaoData(guaName);
    
    // 为每一爻计算具体的日期和时间
    const yaoList: YaoInfo[] = [];
    for (let yaoIndex = 0; yaoIndex < yaoData.length; yaoIndex++) {
      const yao = yaoData[yaoIndex];
      // 每日开始时间 = 卦开始时间 + yaoIndex * 24小时
      const dayStartTime = new Date(guaStartTime.getTime() + yaoIndex * DAY_DURATION_MINUTES * 60 * 1000);
      const dayEndTime = new Date(dayStartTime.getTime() + DAY_DURATION_MINUTES * 60 * 1000);
      
      const yaoInfo: YaoInfo = {
        yaoPosition: yao.yaoPosition,
        yaoSymbol: yao.yaoSymbol,
        yaoText: yao.yaoText,
        yaoMeaning: yao.yaoMeaning,
        dayIndex: yao.dayIndex,
        date: formatDate(dayStartTime),
        time: `${formatTime(dayStartTime)}-${formatTime(dayEndTime)}`
      };
      
      yaoList.push(yaoInfo);
    }
    
    // 确定当期节气段（简化处理）
    const startMonth = guaStartTime.getMonth() + 1;
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
    
    const fenGuaItem: FenGuaZhiRiItem = {
      guaName: guaName,
      guaIndex: i + 1,
      startDate: formatDate(guaStartTime),
      endDate: formatDate(guaEndTime),
      solarTerm: solarTerm,
      yaoList: yaoList,
      guaQiFeature: getGuaQiFeature(guaName)
    };
    
    fenGuaList.push(fenGuaItem);
  }
  
  return {
    year: year,
    dongzhiDate: `${year}-${dongzhiDate}`,
    fenGuaList: fenGuaList
  };
}

/**
 * 获取爻位颜色（基于爻的阴阳属性）
 */
export function getYaoColor(yaoSymbol: string): string {
  if (yaoSymbol.includes('九')) {
    return '#FF6B35'; // 阳爻 - 橙红色
  } else if (yaoSymbol.includes('六')) {
    return '#4A90E2'; // 阴爻 - 蓝色
  } else {
    return '#8E24AA'; // 默认紫色
  }
}