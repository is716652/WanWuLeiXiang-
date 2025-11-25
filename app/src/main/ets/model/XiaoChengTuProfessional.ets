/*
 * 小成图专业版数据模型
 * 基于苏国圣-卢德君《小成图解读》专业理论
 * 包含装卦、四象占法、用神取用等专业功能
 * 
 * 核心原理：
 * 1. 装卦系统：主卦、变卦、互卦组合成九宫格
 * 2. 天盘地盘：天盘为上卦（外部环境），地盘为后天八卦（固定不变）
 * 3. 四象占法：阴阳得配失配、向心离心判断吉凶生克
 * 4. 用神取用：乾为父、坤为母、艮为子女、兑为婚姻等
 * 
 * 严格遵循ArkTS规范：无索引签名、无解构、使用Map
 */

import { BaGua, ZhongGua, LIU_SHI_SI_GUA_DATA, BA_GUA_DATA } from './XiaoChengTuData';

// ============= 接口定义 =============

// 主卦、变卦、互卦
export interface GuaPair {
  shangGua: string;  // 上卦
  xiaGua: string;    // 下卦
  zhongGua: string;  // 重卦名称
}

// 装卦结果 - 完整的小成图九宫格
export interface ZhuangGuaResult {
  // 主卦信息
  zhuGua: GuaPair;
  // 变卦信息
  bianGua: GuaPair;
  // 主卦互卦
  zhuHuGua: GuaPair;
  // 变卦互卦
  bianHuGua: GuaPair;
  // 中宫
  zhongGong: string;
  // 天盘九宫（上卦所落位置）
  tianPan: Map<string, string>;  
  // 地盘九宫（后天八卦固定）
  diPan: Map<string, string>;    
  // 动爻
  dongYao: number;
}

// 九宫位置枚举
export enum JiuGongPosition {
  QIAN = '乾',
  KUN = '坤',
  ZEN = '震',
  XUN = '巽',
  KAN = '坎',
  LI = '离',
  GEN = '艮',
  DUI = '兑',
  ZHONG = '中'
}

// 四象类型（阴阳得配失配 + 向心离心）
export enum SiXiangType {
  JI = '吉',           // 吉象
  XIONG = '凶',        // 凶象
  SHENG = '生',        // 相生
  KE = '克',           // 相克
  XIAN_XIONG_HOU_JI = '先凶后吉',  // 先凶后吉
  XIAN_JI_HOU_XIONG = '先吉后凶'   // 先吉后凶
}

// 四象方向类型
export enum SiXiangDirection {
  XIANG_XIN = '向心',    // 上降下升
  LI_XIN = '离心',       // 上升下降
  WAI_YIN = '外引',      // 上升下升
  NEI_YIN = '内引'       // 上降下降
}

// 四象占法结果
export interface SiXiangResult {
  父母: SiXiangType;
  子女: SiXiangType;
  婚姻: SiXiangType;
  事业: SiXiangType;
  财运: SiXiangType;
  健康: SiXiangType;
  阳宅: SiXiangType;
  阴宅: SiXiangType;
}

// 用神位置
export interface YongShenPosition {
  名称: string;        // 用神名称
  宫位: string;        // 用神所在宫位
  天盘卦: string;      // 天盘落的卦
  地盘卦: string;      // 地盘的卦
  四象: SiXiangType;   // 四象吉凶
  方向: SiXiangDirection;  // 向心离心
  五行关系: string;    // 五行生克关系
  分析: string;        // 详细分析
}

// 专业预测结果
export interface ProfessionalResult {
  装卦: ZhuangGuaResult;
  四象: SiXiangResult;
  用神位置: Map<string, YongShenPosition>;
  详细分析: string;
}

// ============= 装卦核心类 =============

export class XiaoChengTuProfessional {
  // 八卦五行映射
  private baGuaWuxing: Map<string, string>;
  
  // 八卦阴阳属性
  private baGuaYinYang: Map<string, string>;
  
  // 后天八卦方位（地盘固定）
  private houTianBaGua: Map<string, string>;
  
  // 八卦先天数
  private xianTianShu: Map<string, number>;

  constructor() {
    // 初始化八卦五行
    this.baGuaWuxing = new Map();
    this.baGuaWuxing.set('乾', '金');
    this.baGuaWuxing.set('兑', '金');
    this.baGuaWuxing.set('离', '火');
    this.baGuaWuxing.set('震', '木');
    this.baGuaWuxing.set('巽', '木');
    this.baGuaWuxing.set('坎', '水');
    this.baGuaWuxing.set('艮', '土');
    this.baGuaWuxing.set('坤', '土');

    // 初始化八卦阴阳属性
    this.baGuaYinYang = new Map();
    this.baGuaYinYang.set('乾', '阳');
    this.baGuaYinYang.set('震', '阳');
    this.baGuaYinYang.set('坎', '阳');
    this.baGuaYinYang.set('艮', '阳');
    this.baGuaYinYang.set('坤', '阴');
    this.baGuaYinYang.set('巽', '阴');
    this.baGuaYinYang.set('离', '阴');
    this.baGuaYinYang.set('兑', '阴');

    // 初始化后天八卦方位（地盘）
    this.houTianBaGua = new Map();
    this.houTianBaGua.set('乾', '乾');  // 西北
    this.houTianBaGua.set('坤', '坤');  // 西南
    this.houTianBaGua.set('震', '震');  // 正东
    this.houTianBaGua.set('巽', '巽');  // 东南
    this.houTianBaGua.set('坎', '坎');  // 正北
    this.houTianBaGua.set('离', '离');  // 正南
    this.houTianBaGua.set('艮', '艮');  // 东北
    this.houTianBaGua.set('兑', '兑');  // 正西
    
    // 先天八卦数
    this.xianTianShu = new Map();
    this.xianTianShu.set('乾', 1);
    this.xianTianShu.set('兑', 2);
    this.xianTianShu.set('离', 3);
    this.xianTianShu.set('震', 4);
    this.xianTianShu.set('巽', 5);
    this.xianTianShu.set('坎', 6);
    this.xianTianShu.set('艮', 7);
    this.xianTianShu.set('坤', 8);
  }

  /**
   * 执行装卦 - 生成完整的小成图九宫格
   * 根据苏国圣老师的理论：
   * 1. 主卦、变卦、互卦组合成九宫
   * 2. 天盘为上卦（动态），地盘为后天八卦（固定）
   * 3. 中宫根据特定规则确定
   */
  performZhuangGua(zhongGua: ZhongGua, dongYao: number): ZhuangGuaResult {
    // 1. 获取主卦信息
    const zhuGua: GuaPair = {
      shangGua: zhongGua.上卦,
      xiaGua: zhongGua.下卦,
      zhongGua: zhongGua.名称
    };

    // 2. 计算变卦（动爻变化）
    const bianGua = this.calculateBianGua(zhongGua, dongYao);

    // 3. 计算互卦
    const zhuHuGua = this.calculateHuGua(zhongGua);
    const bianHuGua = this.calculateHuGua(bianGua);

    // 4. 计算中宫
    const zhongGong = this.calculateZhongGong(zhuGua, bianGua);

    // 5. 装天盘（九宫格）
    const tianPan = this.fillTianPan(zhuGua, bianGua, zhuHuGua, bianHuGua);

    // 6. 装地盘（后天八卦固定）
    const diPan = this.fillDiPan();

    return {
      zhuGua,
      bianGua,
      zhuHuGua,
      bianHuGua,
      zhongGong,
      tianPan,
      diPan,
      dongYao
    };
  }

  /**
   * 填充天盘
   */
  private fillTianPan(tianPan: Map<string, string>, shangGua: BaGua): void {
    // 天盘：上卦落中宫，按顺序排八宫
    const startIndex = this.getGuaIndex(shangGua.名称);
    
    for (let i = 0; i < this.jiuGongOrder.length; i++) {
      const position = this.jiuGongOrder[i];
      const guaIndex = (startIndex + i) % 8;
      const guaName = this.getGuaNameByIndex(guaIndex);
      tianPan.set(position, guaName);
    }
  }

  /**
   * 填充地盘
   */
  private fillDiPan(diPan: Map<string, string>, xiaGua: BaGua): void {
    // 地盘：下卦落中宫，按顺序排八宫
    const startIndex = this.getGuaIndex(xiaGua.名称);
    
    for (let i = 0; i < this.jiuGongOrder.length; i++) {
      const position = this.jiuGongOrder[i];
      const guaIndex = (startIndex + i) % 8;
      const guaName = this.getGuaNameByIndex(guaIndex);
      diPan.set(position, guaName);
    }
  }

  /**
   * 填充人盘（天地相合）
   */
  private fillRenPan(
    renPan: Map<string, string>,
    tianPan: Map<string, string>,
    diPan: Map<string, string>
  ): void {
    for (let i = 0; i < this.jiuGongOrder.length; i++) {
      const position = this.jiuGongOrder[i];
      const tianGua = tianPan.get(position);
      const diGua = diPan.get(position);
      
      if (tianGua && diGua) {
        // 组合卦名：天卦+地卦
        const combinedGua = tianGua + diGua;
        renPan.set(position, combinedGua);
      }
    }
  }

  /**
   * 填充神盘（归藏卦）
   */
  private fillShenPan(
    shenPan: Map<string, string>,
    renPan: Map<string, string>
  ): void {
    // 神盘使用归藏法则
    for (let i = 0; i < this.jiuGongOrder.length; i++) {
      const position = this.jiuGongOrder[i];
      const renGua = renPan.get(position);
      
      if (renGua) {
        // 归藏变换
        const guiCangGua = this.calculateGuiCang(renGua);
        shenPan.set(position, guiCangGua);
      }
    }
  }

  /**
   * 计算归藏卦
   */
  private calculateGuiCang(guaName: string): string {
    // 简化版：取第一个字作为归藏
    if (guaName.length >= 1) {
      return guaName.charAt(0);
    }
    return '乾';
  }

  /**
   * 获取卦索引
   */
  private getGuaIndex(guaName: string): number {
    const index = this.baGuaOrder.get(guaName);
    if (index !== undefined) {
      return index;
    }
    return 0;
  }

  /**
   * 根据索引获取卦名
   */
  private getGuaNameByIndex(index: number): string {
    const entries: Array<[string, number]> = [];
    this.baGuaOrder.forEach((value, key) => {
      entries.push([key, value]);
    });

    for (let i = 0; i < entries.length; i++) {
      const entry = entries[i];
      if (entry[1] === index) {
        return entry[0];
      }
    }
    return '乾';
  }

  /**
   * 四象占法分析
   */
  analyzeSiXiang(zhuangGua: ZhuangGuaResult): SiXiangResult {
    const result: SiXiangResult = {
      父母: SiXiangType.JI,
      子女: SiXiangType.JI,
      婚姻: SiXiangType.JI,
      事业: SiXiangType.JI,
      财运: SiXiangType.JI,
      健康: SiXiangType.JI,
      阳宅: SiXiangType.JI,
      阴宅: SiXiangType.JI
    };

    // 父母：乾宫和坤宫
    result.父母 = this.judgeSiXiang(
      zhuangGua.diPan.get('乾'),
      zhuangGua.tianPan.get('乾')
    );

    // 子女：艮宫
    result.子女 = this.judgeSiXiang(
      zhuangGua.diPan.get('艮'),
      zhuangGua.tianPan.get('艮')
    );

    // 婚姻：兑宫
    result.婚姻 = this.judgeSiXiang(
      zhuangGua.diPan.get('兑'),
      zhuangGua.tianPan.get('兑')
    );

    // 事业：震宫
    result.事业 = this.judgeSiXiang(
      zhuangGua.diPan.get('震'),
      zhuangGua.tianPan.get('震')
    );

    // 财运：巽宫
    result.财运 = this.judgeSiXiang(
      zhuangGua.diPan.get('巽'),
      zhuangGua.tianPan.get('巽')
    );

    // 健康：坎宫和离宫
    result.健康 = this.judgeSiXiang(
      zhuangGua.diPan.get('坎'),
      zhuangGua.tianPan.get('坎')
    );

    // 阳宅：艮宫
    result.阳宅 = this.judgeSiXiang(
      zhuangGua.diPan.get('艮'),
      zhuangGua.tianPan.get('艮')
    );

    // 阴宅：坤宫
    result.阴宅 = this.judgeSiXiang(
      zhuangGua.diPan.get('坤'),
      zhuangGua.tianPan.get('坤')
    );

    return result;
  }

  /**
   * 判断四象吉凶
   */
  private judgeSiXiang(diGua: string | undefined, tianGua: string | undefined): SiXiangType {
    if (!diGua || !tianGua) {
      return SiXiangType.JI;
    }

    // 简化判断：同则吉，异则凶
    if (diGua === tianGua) {
      return SiXiangType.JI;
    }

    // 五行生克判断
    const relation = this.getWuxingRelation(diGua, tianGua);
    if (relation === '生') {
      return SiXiangType.SHENG;
    } else if (relation === '克') {
      return SiXiangType.KE;
    }

    return SiXiangType.XIONG;
  }

  /**
   * 获取五行关系
   */
  private getWuxingRelation(gua1: string, gua2: string): string {
    // 简化处理
    const wuxing1 = this.getGuaWuxing(gua1);
    const wuxing2 = this.getGuaWuxing(gua2);

    if (this.isSheng(wuxing1, wuxing2)) {
      return '生';
    } else if (this.isKe(wuxing1, wuxing2)) {
      return '克';
    }

    return '和';
  }

  /**
   * 获取卦的五行
   */
  private getGuaWuxing(guaName: string): string {
    if (guaName === '乾' || guaName === '兑') {
      return '金';
    } else if (guaName === '震' || guaName === '巽') {
      return '木';
    } else if (guaName === '坎') {
      return '水';
    } else if (guaName === '离') {
      return '火';
    } else if (guaName === '坤' || guaName === '艮') {
      return '土';
    }
    return '土';
  }

  /**
   * 判断是否相生
   */
  private isSheng(wuxing1: string, wuxing2: string): boolean {
    if (wuxing1 === '金' && wuxing2 === '水') return true;
    if (wuxing1 === '水' && wuxing2 === '木') return true;
    if (wuxing1 === '木' && wuxing2 === '火') return true;
    if (wuxing1 === '火' && wuxing2 === '土') return true;
    if (wuxing1 === '土' && wuxing2 === '金') return true;
    return false;
  }

  /**
   * 判断是否相克
   */
  private isKe(wuxing1: string, wuxing2: string): boolean {
    if (wuxing1 === '金' && wuxing2 === '木') return true;
    if (wuxing1 === '木' && wuxing2 === '土') return true;
    if (wuxing1 === '土' && wuxing2 === '水') return true;
    if (wuxing1 === '水' && wuxing2 === '火') return true;
    if (wuxing1 === '火' && wuxing2 === '金') return true;
    return false;
  }

  /**
   * 用神取用
   */
  analyzeYongShen(zhuangGua: ZhuangGuaResult): Map<string, YongShenPosition> {
    const yongShenMap = new Map<string, YongShenPosition>();

    // 父亲用神：乾宫
    const fuQinPos: YongShenPosition = {
      宫位: '乾',
      落宫: zhuangGua.diPan.get('乾') || '乾',
      四象: this.judgeSiXiang(
        zhuangGua.diPan.get('乾'),
        zhuangGua.tianPan.get('乾')
      )
    };
    yongShenMap.set('父亲', fuQinPos);

    // 母亲用神：坤宫
    const muQinPos: YongShenPosition = {
      宫位: '坤',
      落宫: zhuangGua.diPan.get('坤') || '坤',
      四象: this.judgeSiXiang(
        zhuangGua.diPan.get('坤'),
        zhuangGua.tianPan.get('坤')
      )
    };
    yongShenMap.set('母亲', muQinPos);

    // 子女用神：艮宫
    const ziNvPos: YongShenPosition = {
      宫位: '艮',
      落宫: zhuangGua.diPan.get('艮') || '艮',
      四象: this.judgeSiXiang(
        zhuangGua.diPan.get('艮'),
        zhuangGua.tianPan.get('艮')
      )
    };
    yongShenMap.set('子女', ziNvPos);

    // 婚姻用神：兑宫
    const hunYinPos: YongShenPosition = {
      宫位: '兑',
      落宫: zhuangGua.diPan.get('兑') || '兑',
      四象: this.judgeSiXiang(
        zhuangGua.diPan.get('兑'),
        zhuangGua.tianPan.get('兑')
      )
    };
    yongShenMap.set('婚姻', hunYinPos);

    return yongShenMap;
  }

  /**
   * 生成详细分析文本
   */
  generateDetailedAnalysis(
    zhuangGua: ZhuangGuaResult,
    siXiang: SiXiangResult,
    yongShen: Map<string, YongShenPosition>
  ): string {
    let analysis = '【小成图专业分析】\n\n';

    analysis += '一、四盘数据\n';
    analysis += this.formatPanData('天盘', zhuangGua.tianPan);
    analysis += this.formatPanData('地盘', zhuangGua.diPan);
    analysis += this.formatPanData('人盘', zhuangGua.renPan);
    analysis += this.formatPanData('神盘', zhuangGua.shenPan);

    analysis += '\n二、四象占法\n';
    analysis += `父母：${siXiang.父母}\n`;
    analysis += `子女：${siXiang.子女}\n`;
    analysis += `婚姻：${siXiang.婚姻}\n`;
    analysis += `事业：${siXiang.事业}\n`;
    analysis += `财运：${siXiang.财运}\n`;
    analysis += `健康：${siXiang.健康}\n`;

    analysis += '\n三、用神分析\n';
    yongShen.forEach((pos, key) => {
      analysis += `${key}：${pos.宫位}宫落${pos.落宫}，四象为${pos.四象}\n`;
    });

    return analysis;
  }

  /**
   * 格式化盘数据
   */
  private formatPanData(panName: string, panData: Map<string, string>): string {
    let result = `${panName}：\n`;
    
    for (let i = 0; i < this.jiuGongOrder.length; i++) {
      const position = this.jiuGongOrder[i];
      const gua = panData.get(position);
      if (gua) {
        result += `  ${position}宫：${gua}\n`;
      }
    }
    
    return result;
  }
}
