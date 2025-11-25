/*
 * 小成图专业版 - 完全重写
 * 基于苏国圣-卢德君《小成图解读》177页专业理论
 * 
 * 核心原理：
 * 1. 装卦：主卦变卦为四正，上下左右分；主互变互为四隅，巽坤艮乾装
 * 2. 天盘地盘：天盘为上卦所落九宫，地盘为后天八卦固定
 * 3. 四象占法：阴阳得配失配 + 向心离心 = 吉凶生克
 * 4. 用神取用：乾父、坤母、艮子女、兑婚姻、震事业、巽财运等
 */

import { ZhongGua, LIU_SHI_SI_GUA_DATA } from './XiaoChengTuData';

// ============= 接口定义 =============

// 卦对信息
export interface GuaPair {
  shangGua: string;    // 上卦
  xiaGua: string;      // 下卦
  zhongGua: string;    // 重卦名称
  guaXiang: string;    // 卦象符号
}

// 小成图九宫格装卦结果
export interface XiaoChengTuJiuGong {
  // 九宫八个位置的卦
  qianGong: string;    // 乾宫（西北）
  kunGong: string;     // 坤宫（西南）
  zhenGong: string;    // 震宫（正东）
  xunGong: string;     // 巽宫（东南）
  kanGong: string;     // 坎宫（正北）
  liGong: string;      // 离宫（正南）
  genGong: string;     // 艮宫（东北）
  duiGong: string;     // 兑宫（正西）
  zhongGong: string;   // 中宫
}

// 四象方向
export enum SiXiangFangXiang {
  XIANG_XIN = '向心',  // 上降下升
  LI_XIN = '离心',     // 上升下降
  WAI_YIN = '外引',    // 上升下升  
  NEI_YIN = '内引'     // 上降下降
}

// 四象吉凶
export enum SiXiangJiXiong {
  JI = '吉',
  XIONG = '凶',
  SHENG = '生',
  KE = '克',
  XIAN_XIONG_HOU_JI = '先凶后吉',
  XIAN_JI_HOU_XIONG = '先吉后凶'
}

// 四象分析结果
export interface SiXiangAnalysis {
  fangXiang: SiXiangFangXiang;  // 方向
  dePei: boolean;                // 是否得配
  jiXiong: SiXiangJiXiong;      // 吉凶
  wuxingGuanxi: string;          // 五行关系
  shuoming: string;              // 说明
}

// 用神信息
export interface YongShenInfo {
  mingCheng: string;      // 用神名称
  gongWei: string;        // 所在宫位
  tianPanGua: string;     // 天盘卦
  diPanGua: string;       // 地盘卦
  siXiang: SiXiangAnalysis; // 四象分析
  fenXi: string;          // 详细分析
}

// 完整装卦结果
export interface WanZhengZhuangGua {
  // 基础卦象
  zhuGua: GuaPair;        // 主卦
  bianGua: GuaPair;       // 变卦
  zhuHuGua: GuaPair;      // 主卦互卦
  bianHuGua: GuaPair;     // 变卦互卦
  dongYao: number;        // 动爻
  
  // 天盘地盘
  tianPan: XiaoChengTuJiuGong;  // 天盘九宫
  diPan: XiaoChengTuJiuGong;    // 地盘九宫
  
  // 用神分析
  yongShen: YongShenInfo[];     // 所有用神
  
  // 起卦信息
  qiGuaShiJian: Date;           // 起卦时间
  qiGuaFangShi: string;         // 起卦方式
}

// ============= 核心类 =============

export class XiaoChengTuPro {
  // 八卦五行
  private wuxing: Map<string, string>;
  // 八卦阴阳
  private yinyang: Map<string, string>;
  // 八卦升降
  private shengjiang: Map<string, string>;
  
  constructor() {
    // 初始化五行
    this.wuxing = new Map();
    this.wuxing.set('乾', '金');
    this.wuxing.set('兑', '金');
    this.wuxing.set('离', '火');
    this.wuxing.set('震', '木');
    this.wuxing.set('巽', '木');
    this.wuxing.set('坎', '水');
    this.wuxing.set('艮', '土');
    this.wuxing.set('坤', '土');
    
    // 初始化阴阳（四阳卦：乾坎艮震，四阴卦：巽离坤兑）
    this.yinyang = new Map();
    this.yinyang.set('乾', '阳');
    this.yinyang.set('坎', '阳');
    this.yinyang.set('艮', '阳');
    this.yinyang.set('震', '阳');
    this.yinyang.set('巽', '阴');
    this.yinyang.set('离', '阴');
    this.yinyang.set('坤', '阴');
    this.yinyang.set('兑', '阴');
    
    // 初始化升降（四阳卦主升，但坎水下降；四阴卦主降，但离火上升）
    this.shengjiang = new Map();
    this.shengjiang.set('乾', '升');
    this.shengjiang.set('艮', '升');
    this.shengjiang.set('震', '升');
    this.shengjiang.set('坎', '降');  // 坎水至阴而下降
    this.shengjiang.set('巽', '降');
    this.shengjiang.set('坤', '降');
    this.shengjiang.set('兑', '降');
    this.shengjiang.set('离', '升');  // 离火至阳而上升
  }
  
  /**
   * 完整装卦流程
   */
  performZhuangGua(
    zhongGua: ZhongGua,
    dongYao: number,
    qiGuaFangShi: string
  ): WanZhengZhuangGua {
    // 1. 构建主卦
    const zhuGua: GuaPair = {
      shangGua: zhongGua.上卦,
      xiaGua: zhongGua.下卦,
      zhongGua: zhongGua.名称,
      guaXiang: zhongGua.符号
    };
    
    // 2. 计算变卦
    const bianZhongGua = this.getBianGua(zhongGua, dongYao);
    const bianGua: GuaPair = {
      shangGua: bianZhongGua.上卦,
      xiaGua: bianZhongGua.下卦,
      zhongGua: bianZhongGua.名称,
      guaXiang: bianZhongGua.符号
    };
    
    // 3. 计算互卦
    const zhuHuGua = this.getHuGua(zhongGua);
    const bianHuGua = this.getHuGua(bianZhongGua);
    
    // 4. 装天盘（九宫格）
    const tianPan = this.zhuangTianPan(zhuGua, bianGua, zhuHuGua, bianHuGua);
    
    // 5. 装地盘（后天八卦固定）
    const diPan = this.zhuangDiPan();
    
    // 6. 用神分析
    const yongShen = this.analyzeYongShen(tianPan, diPan);
    
    return {
      zhuGua,
      bianGua,
      zhuHuGua,
      bianHuGua,
      dongYao,
      tianPan,
      diPan,
      yongShen,
      qiGuaShiJian: new Date(),
      qiGuaFangShi
    };
  }
  
  /**
   * 计算变卦（根据动爻）
   * 动爻变化：阳爻变阴，阴爻变阳
   */
  private getBianGua(zhongGua: ZhongGua, dongYao: number): ZhongGua {
    // 获取上下卦的二进制
    const shangGuaBinary = this.getGuaBinary(zhongGua.上卦);  // 上三爻（4、5、6）
    const xiaGuaBinary = this.getGuaBinary(zhongGua.下卦);   // 下三爻（1、2、3）
    
    // 构建六爻：下卦在下（初爻、二爻、三爻），上卦在上（四爻、五爻、六爻）
    let liuYao = xiaGuaBinary + shangGuaBinary;
    
    // 根据动爻位置变化对应的爻（索引从0开始，但动爻从1开始）
    const yaoIndex = dongYao - 1;  // 转换为数组索引
    const oldYao = liuYao[yaoIndex];
    const newYao = oldYao === '1' ? '0' : '1';  // 阴阳互变
    
    // 更新六爻
    liuYao = liuYao.substring(0, yaoIndex) + newYao + liuYao.substring(yaoIndex + 1);
    
    // 分解为上下卦
    const newXiaGuaBinary = liuYao.substring(0, 3);  // 下三爻
    const newShangGuaBinary = liuYao.substring(3, 6); // 上三爻
    
    // 根据二进制查找对应的卦
    const shangGuaMing = this.getGuaByBinary(newShangGuaBinary);
    const xiaGuaMing = this.getGuaByBinary(newXiaGuaBinary);
    
    // 查找对应的重卦
    const bianZhongGua = LIU_SHI_SI_GUA_DATA.find(g => 
      g.上卦 === shangGuaMing && g.下卦 === xiaGuaMing
    );
    
    if (bianZhongGua) {
      return bianZhongGua;
    }
    
    // 如果找不到，返回原卦
    console.warn(`未找到变卦: ${shangGuaMing}${xiaGuaMing}`);
    return zhongGua;
  }
  
  /**
   * 计算互卦（传统算法）
   * 上互卦：取原卦的 2、3、4 爻（从下往上数）
   * 下互卦：取原卦的 3、4、5 爻
   */
  private getHuGua(zhongGua: ZhongGua): GuaPair {
    // 获取上下卦的六爻二进制
    const shangGuaBinary = this.getGuaBinary(zhongGua.上卦);  // 上三爻（4、5、6）
    const xiaGuaBinary = this.getGuaBinary(zhongGua.下卦);   // 下三爻（1、2、3）
    
    // 构建六爻：下卦在下（初爻、二爻、三爻），上卦在上（四爻、五爻、六爻）
    const liuYao = xiaGuaBinary + shangGuaBinary;
    
    // 提取互卦的爻
    // 上互：2、3、4爻（索引1、2、3）
    const shangHuBinary = liuYao[1] + liuYao[2] + liuYao[3];
    // 下互：3、4、5爻（索引2、3、4）  
    const xiaHuBinary = liuYao[2] + liuYao[3] + liuYao[4];
    
    // 根据二进制查找对应的卦
    const shangHuGua = this.getGuaByBinary(shangHuBinary);
    const xiaHuGua = this.getGuaByBinary(xiaHuBinary);
    
    // 查找对应的重卦
    const huZhongGua = LIU_SHI_SI_GUA_DATA.find(g => 
      g.上卦 === shangHuGua && g.下卦 === xiaHuGua
    );
    
    if (huZhongGua) {
      return {
        shangGua: huZhongGua.上卦,
        xiaGua: huZhongGua.下卦,
        zhongGua: huZhongGua.名称,
        guaXiang: huZhongGua.符号
      };
    }
    
    // 如果找不到重卦，返回一个组合
    return {
      shangGua: shangHuGua,
      xiaGua: xiaHuGua,
      zhongGua: `${shangHuGua}${xiaHuGua}`,
      guaXiang: '☰'
    };
  }
  
  /**
   * 获取卦的二进制表示
   */
  private getGuaBinary(guaMing: string): string {
    const baGuaMap = new Map<string, string>([
      ['乾', '111'],
      ['兑', '110'],
      ['离', '101'],
      ['震', '100'],
      ['巽', '011'],
      ['坎', '010'],
      ['艮', '001'],
      ['坤', '000']
    ]);
    return baGuaMap.get(guaMing) || '000';
  }
  
  /**
   * 根据二进制查找卦名
   */
  private getGuaByBinary(binary: string): string {
    const binaryToGuaMap = new Map<string, string>([
      ['111', '乾'],
      ['110', '兑'],
      ['101', '离'],
      ['100', '震'],
      ['011', '巽'],
      ['010', '坎'],
      ['001', '艮'],
      ['000', '坤']
    ]);
    return binaryToGuaMap.get(binary) || '坤';
  }
  
  /**
   * 装天盘 - 核心算法
   * 口诀：主卦变卦为四正，上下左右分
   *       主互变互为四隅，巽坤艮乾装
   * 
   * 九宫方位图：
   *   巽(东南)  离(正南)  坤(西南)
   *   震(正东)    中       兑(正西)
   *   艮(东北)  坎(正北)  乾(西北)
   */
  private zhuangTianPan(
    zhuGua: GuaPair,
    bianGua: GuaPair,
    zhuHuGua: GuaPair,
    bianHuGua: GuaPair
  ): XiaoChengTuJiuGong {
    // 主卦变卦为四正（震巽离坎）
    const zhenGong = zhuGua.shangGua;   // 主卦上卦 -> 震宫（正东）
    const liGong = zhuGua.xiaGua;       // 主卦下卦 -> 离宫（正南）
    const xunGong = bianGua.shangGua;   // 变卦上卦 -> 巽宫（东南）
    const kanGong = bianGua.xiaGua;     // 变卦下卦 -> 坎宫（正北）
    
    // 主互变互为四隅（乾坤艮兑）
    const genGong = zhuHuGua.shangGua;  // 主互上卦 -> 艮宫（东北）
    const kunGong = zhuHuGua.xiaGua;    // 主互下卦 -> 坤宫（西南）
    const qianGong = bianHuGua.shangGua; // 变互上卦 -> 乾宫（西北）
    const duiGong = bianHuGua.xiaGua;   // 变互下卦 -> 兑宫（正西）
    
    // 中宫计算
    const zhongGong = this.calculateZhongGong(zhuGua, bianGua);
    
    return {
      qianGong,
      kunGong,
      zhenGong,
      xunGong,
      kanGong,
      liGong,
      genGong,
      duiGong,
      zhongGong
    };
  }
  
  /**
   * 装地盘 - 后天八卦固定
   */
  private zhuangDiPan(): XiaoChengTuJiuGong {
    return {
      qianGong: '乾',   // 西北
      kunGong: '坤',    // 西南
      zhenGong: '震',   // 正东
      xunGong: '巽',    // 东南
      kanGong: '坎',    // 正北
      liGong: '离',     // 正南
      genGong: '艮',    // 东北
      duiGong: '兑',    // 正西
      zhongGong: '中'   // 中宫
    };
  }
  
  /**
   * 计算中宫 - 核心口诀
   * 主卦变卦八纯卦，中宫肯定是坤卦
   * 若是经卦乾或坤，中宫肯定还是坤
   * 主变同位异性卦，中宫是乾定不差
   */
  private calculateZhongGong(zhuGua: GuaPair, bianGua: GuaPair): string {
    // 1. 八纯卦判断
    if (zhuGua.shangGua === zhuGua.xiaGua || bianGua.shangGua === bianGua.xiaGua) {
      return '坤';
    }
    
    // 2. 乾坤判断
    if (zhuGua.shangGua === '乾' || zhuGua.xiaGua === '乾' ||
        zhuGua.shangGua === '坤' || zhuGua.xiaGua === '坤' ||
        bianGua.shangGua === '乾' || bianGua.xiaGua === '乾' ||
        bianGua.shangGua === '坤' || bianGua.xiaGua === '坤') {
      return '坤';
    }
    
    // 3. 同位异性卦
    const tongWeiYiXing = this.checkTongWeiYiXing(zhuGua, bianGua);
    if (tongWeiYiXing) {
      return '乾';
    }
    
    // 4. 默认归藏法
    return this.guiCangFa(zhuGua, bianGua);
  }
  
  /**
   * 检查同位异性卦
   */
  private checkTongWeiYiXing(zhuGua: GuaPair, bianGua: GuaPair): boolean {
    // 同位异性卦：否、履、恒、未济
    const tongWeiList = ['否', '履', '恒', '未济'];
    return tongWeiList.includes(zhuGua.zhongGua) || tongWeiList.includes(bianGua.zhongGua);
  }
  
  /**
   * 归藏法 - 长中少推其一
   */
  private guiCangFa(zhuGua: GuaPair, bianGua: GuaPair): string {
    // 简化：默认返回坎
    return '坎';
  }
  
  /**
   * 用神分析
   */
  private analyzeYongShen(
    tianPan: XiaoChengTuJiuGong,
    diPan: XiaoChengTuJiuGong
  ): YongShenInfo[] {
    const yongShenList: YongShenInfo[] = [];
    
    // 1. 父亲 - 乾宫
    yongShenList.push(this.createYongShen(
      '父亲',
      '乾',
      tianPan.qianGong,
      diPan.qianGong
    ));
    
    // 2. 母亲 - 坤宫
    yongShenList.push(this.createYongShen(
      '母亲',
      '坤',
      tianPan.kunGong,
      diPan.kunGong
    ));
    
    // 3. 子女 - 艮宫
    yongShenList.push(this.createYongShen(
      '子女',
      '艮',
      tianPan.genGong,
      diPan.genGong
    ));
    
    // 4. 婚姻 - 兑宫
    yongShenList.push(this.createYongShen(
      '婚姻',
      '兑',
      tianPan.duiGong,
      diPan.duiGong
    ));
    
    // 5. 事业 - 震宫
    yongShenList.push(this.createYongShen(
      '事业',
      '震',
      tianPan.zhenGong,
      diPan.zhenGong
    ));
    
    // 6. 财运 - 巽宫
    yongShenList.push(this.createYongShen(
      '财运',
      '巽',
      tianPan.xunGong,
      diPan.xunGong
    ));
    
    // 7. 健康 - 坎宫
    yongShenList.push(this.createYongShen(
      '健康',
      '坎',
      tianPan.kanGong,
      diPan.kanGong
    ));
    
    // 8. 阳宅 - 艮宫
    yongShenList.push(this.createYongShen(
      '阳宅',
      '艮',
      tianPan.genGong,
      diPan.genGong
    ));
    
    // 9. 阴宅 - 坤宫
    yongShenList.push(this.createYongShen(
      '阴宅',
      '坤',
      tianPan.kunGong,
      diPan.kunGong
    ));
    
    return yongShenList;
  }
  
  /**
   * 创建用神信息
   */
  private createYongShen(
    mingCheng: string,
    gongWei: string,
    tianGua: string,
    diGua: string
  ): YongShenInfo {
    const siXiang = this.analyzeSiXiang(tianGua, diGua);
    
    return {
      mingCheng,
      gongWei,
      tianPanGua: tianGua,
      diPanGua: diGua,
      siXiang,
      fenXi: this.generateYongShenFenXi(mingCheng, siXiang)
    };
  }
  
  /**
   * 四象分析 - 核心算法
   * 1. 判断方向：向心、离心、外引、内引
   * 2. 判断得配：阴阳是否搭配
   * 3. 得出吉凶：根据方向+得配组合
   */
  private analyzeSiXiang(shangGua: string, xiaGua: string): SiXiangAnalysis {
    // 1. 获取升降
    const shangSheng = this.shengjiang.get(shangGua) === '升';
    const xiaSheng = this.shengjiang.get(xiaGua) === '升';
    
    // 2. 判断方向
    let fangXiang: SiXiangFangXiang;
    if (!shangSheng && xiaSheng) {
      fangXiang = SiXiangFangXiang.XIANG_XIN;  // 上降下升
    } else if (shangSheng && !xiaSheng) {
      fangXiang = SiXiangFangXiang.LI_XIN;     // 上升下降
    } else if (shangSheng && xiaSheng) {
      fangXiang = SiXiangFangXiang.WAI_YIN;    // 上升下升
    } else {
      fangXiang = SiXiangFangXiang.NEI_YIN;    // 上降下降
    }
    
    // 3. 判断得配（阴阳是否搭配）
    const shangYin = this.yinyang.get(shangGua);
    const xiaYin = this.yinyang.get(xiaGua);
    const dePei = shangYin !== xiaYin;  // 异性为得配
    
    // 4. 判断吉凶
    let jiXiong: SiXiangJiXiong;
    if (fangXiang === SiXiangFangXiang.XIANG_XIN) {
      // 向心：得配吉，失配凶
      jiXiong = dePei ? SiXiangJiXiong.JI : SiXiangJiXiong.XIONG;
    } else if (fangXiang === SiXiangFangXiang.LI_XIN) {
      // 离心：得配凶，失配吉
      jiXiong = dePei ? SiXiangJiXiong.XIONG : SiXiangJiXiong.JI;
    } else if (fangXiang === SiXiangFangXiang.WAI_YIN) {
      // 外引：得配吉，失配先凶后吉
      jiXiong = dePei ? SiXiangJiXiong.JI : SiXiangJiXiong.XIAN_XIONG_HOU_JI;
    } else {
      // 内引：得配吉，失配先吉后凶
      jiXiong = dePei ? SiXiangJiXiong.JI : SiXiangJiXiong.XIAN_JI_HOU_XIONG;
    }
    
    // 5. 五行关系
    const wuxingGuanxi = this.getWuxingGuanxi(shangGua, xiaGua);
    
    // 6. 说明
    const shuoming = this.generateSiXiangShuoMing(fangXiang, dePei, jiXiong, wuxingGuanxi);
    
    return {
      fangXiang,
      dePei,
      jiXiong,
      wuxingGuanxi,
      shuoming
    };
  }
  
  /**
   * 获取五行关系
   */
  private getWuxingGuanxi(gua1: string, gua2: string): string {
    const wx1 = this.wuxing.get(gua1) || '土';
    const wx2 = this.wuxing.get(gua2) || '土';
    
    if (wx1 === wx2) {
      return '比和';
    }
    
    // 相生关系
    if ((wx1 === '金' && wx2 === '水') ||
        (wx1 === '水' && wx2 === '木') ||
        (wx1 === '木' && wx2 === '火') ||
        (wx1 === '火' && wx2 === '土') ||
        (wx1 === '土' && wx2 === '金')) {
      return `${wx1}生${wx2}`;
    }
    
    // 相克关系
    if ((wx1 === '金' && wx2 === '木') ||
        (wx1 === '木' && wx2 === '土') ||
        (wx1 === '土' && wx2 === '水') ||
        (wx1 === '水' && wx2 === '火') ||
        (wx1 === '火' && wx2 === '金')) {
      return `${wx1}克${wx2}`;
    }
    
    // 被生
    if ((wx2 === '金' && wx1 === '水') ||
        (wx2 === '水' && wx1 === '木') ||
        (wx2 === '木' && wx1 === '火') ||
        (wx2 === '火' && wx1 === '土') ||
        (wx2 === '土' && wx1 === '金')) {
      return `${wx2}生${wx1}`;
    }
    
    // 被克
    return `${wx2}克${wx1}`;
  }
  
  /**
   * 生成四象说明
   */
  private generateSiXiangShuoMing(
    fangXiang: SiXiangFangXiang,
    dePei: boolean,
    jiXiong: SiXiangJiXiong,
    wuxing: string
  ): string {
    const deStr = dePei ? '阴阳得配' : '阴阳失配';
    return `${fangXiang}，${deStr}，${wuxing}，为${jiXiong}象`;
  }
  
  /**
   * 生成用神分析
   */
  private generateYongShenFenXi(mingCheng: string, siXiang: SiXiangAnalysis): string {
    let fenXi = `${mingCheng}用神分析：\n`;
    fenXi += `四象：${siXiang.shuoming}\n`;
    
    if (siXiang.jiXiong === SiXiangJiXiong.JI) {
      fenXi += `吉象显现，${mingCheng}方面顺利吉祥。`;
    } else if (siXiang.jiXiong === SiXiangJiXiong.XIONG) {
      fenXi += `凶象显现，${mingCheng}方面需要注意防范。`;
    } else if (siXiang.jiXiong === SiXiangJiXiong.XIAN_XIONG_HOU_JI) {
      fenXi += `先凶后吉，${mingCheng}方面初期波折，后期转好。`;
    } else if (siXiang.jiXiong === SiXiangJiXiong.XIAN_JI_HOU_XIONG) {
      fenXi += `先吉后凶，${mingCheng}方面初期顺利，后期需谨慎。`;
    } else if (siXiang.jiXiong === SiXiangJiXiong.SHENG) {
      fenXi += `相生之象，${mingCheng}方面得助力，利于发展。`;
    } else {
      fenXi += `相克之象，${mingCheng}方面有阻碍，需化解。`;
    }
    
    return fenXi;
  }
}
