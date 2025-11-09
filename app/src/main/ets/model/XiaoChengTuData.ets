/*
 * 小成图数据模型
 * 包含小成图起卦的核心逻辑和数据结构
 */

// 八经卦数据
export interface BaGua {
  名称: string;
  符号: string;
  二进制: string;  // 从下往上：初爻、二爻、三爻
  五行: string;
  方位: string;
  数字: number;
}

// 重卦信息
export interface ZhongGua {
  名称: string;
  符号: string;
  上卦: string;
  下卦: string;
  序号: number;
  宫属: string;
  世次: string;
  世爻: string;
  应爻: string;
}

// 小成图结果
export interface XiaoChengTuResult {
  上卦: BaGua;
  下卦: BaGua;
  重卦: ZhongGua;
  起卦方式: string;
  时间: Date;
  解说: string;
}

// 八经卦基础数据
export const BA_GUA_DATA: BaGua[] = [
  { 名称: '乾', 符号: '☰', 二进制: '111', 五行: '金', 方位: '西北', 数字: 1 },
  { 名称: '兑', 符号: '☱', 二进制: '110', 五行: '金', 方位: '西', 数字: 2 },
  { 名称: '离', 符号: '☲', 二进制: '101', 五行: '火', 方位: '南', 数字: 3 },
  { 名称: '震', 符号: '☳', 二进制: '100', 五行: '木', 方位: '东', 数字: 4 },
  { 名称: '巽', 符号: '☴', 二进制: '011', 五行: '木', 方位: '东南', 数字: 5 },
  { 名称: '坎', 符号: '☵', 二进制: '010', 五行: '水', 方位: '北', 数字: 6 },
  { 名称: '艮', 符号: '☶', 二进制: '001', 五行: '土', 方位: '东北', 数字: 7 },
  { 名称: '坤', 符号: '☷', 二进制: '000', 五行: '土', 方位: '西南', 数字: 8 }
];

// 六十四卦数据（简化版，包含宫属、世次信息）
export const LIU_SHI_SI_GUA_DATA: ZhongGua[] = [
  // 乾宫
  { 名称: '乾', 符号: '䷀', 上卦: '乾', 下卦: '乾', 序号: 1, 宫属: '乾宫', 世次: '本宫', 世爻: '上九', 应爻: '初三' },
  { 名称: '姤', 符号: '䷫', 上卦: '乾', 下卦: '巽', 序号: 44, 宫属: '乾宫', 世次: '一世', 世爻: '初爻', 应爻: '四爻' },
  { 名称: '遁', 符号: '䷠', 上卦: '乾', 下卦: '艮', 序号: 33, 宫属: '乾宫', 世次: '二世', 世爻: '二爻', 应爻: '五爻' },
  { 名称: '否', 符号: '䷋', 上卦: '乾', 下卦: '坤', 序号: 12, 宫属: '乾宫', 世次: '三世', 世爻: '三爻', 应爻: '上爻' },
  { 名称: '观', 符号: '䷓', 上卦: '巽', 下卦: '坤', 序号: 20, 宫属: '乾宫', 世次: '四世', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '剥', 符号: '䷖', 上卦: '艮', 下卦: '坤', 序号: 23, 宫属: '乾宫', 世次: '五世', 世爻: '五爻', 应爻: '二爻' },
  { 名称: '晋', 符号: '䷢', 上卦: '离', 下卦: '坤', 序号: 35, 宫属: '乾宫', 世次: '游魂', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '大有', 符号: '䷍', 上卦: '离', 下卦: '乾', 序号: 14, 宫属: '乾宫', 世次: '归魂', 世爻: '三爻', 应爻: '上爻' },
  // 坤宫
  { 名称: '坤', 符号: '䷁', 上卦: '坤', 下卦: '坤', 序号: 2, 宫属: '坤宫', 世次: '本宫', 世爻: '上六', 应爻: '初六' },
  { 名称: '复', 符号: '䷗', 上卦: '坤', 下卦: '震', 序号: 24, 宫属: '坤宫', 世次: '一世', 世爻: '初爻', 应爻: '四爻' },
  { 名称: '临', 符号: '䷒', 上卦: '坤', 下卦: '兑', 序号: 19, 宫属: '坤宫', 世次: '二世', 世爻: '二爻', 应爻: '五爻' },
  { 名称: '泰', 符号: '䷊', 上卦: '坤', 下卦: '乾', 序号: 11, 宫属: '坤宫', 世次: '三世', 世爻: '三爻', 应爻: '上爻' },
  { 名称: '大壮', 符号: '䷡', 上卦: '震', 下卦: '乾', 序号: 34, 宫属: '坤宫', 世次: '四世', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '夬', 符号: '䷪', 上卦: '兑', 下卦: '乾', 序号: 43, 宫属: '坤宫', 世次: '五世', 世爻: '五爻', 应爻: '二爻' },
  { 名称: '需', 符号: '䷄', 上卦: '坎', 下卦: '乾', 序号: 5, 宫属: '坤宫', 世次: '游魂', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '比', 符号: '䷇', 上卦: '坎', 下卦: '坤', 序号: 8, 宫属: '坤宫', 世次: '归魂', 世爻: '三爻', 应爻: '上爻' },
  // 震宫
  { 名称: '震', 符号: '䷲', 上卦: '震', 下卦: '震', 序号: 51, 宫属: '震宫', 世次: '本宫', 世爻: '上六', 应爻: '初三' },
  { 名称: '豫', 符号: '䷏', 上卦: '震', 下卦: '坤', 序号: 16, 宫属: '震宫', 世次: '一世', 世爻: '初爻', 应爻: '四爻' },
  { 名称: '解', 符号: '䷧', 上卦: '震', 下卦: '坎', 序号: 40, 宫属: '震宫', 世次: '二世', 世爻: '二爻', 应爻: '五爻' },
  { 名称: '恒', 符号: '䷟', 上卦: '震', 下卦: '巽', 序号: 32, 宫属: '震宫', 世次: '三世', 世爻: '三爻', 应爻: '上爻' },
  { 名称: '升', 符号: '䷭', 上卦: '巽', 下卦: '坤', 序号: 46, 宫属: '震宫', 世次: '四世', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '井', 符号: '䷯', 上卦: '巽', 下卦: '坎', 序号: 48, 宫属: '震宫', 世次: '五世', 世爻: '五爻', 应爻: '二爻' },
  { 名称: '大过', 符号: '䷛', 上卦: '兑', 下卦: '巽', 序号: 28, 宫属: '震宫', 世次: '游魂', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '随', 符号: '䷐', 上卦: '兑', 下卦: '震', 序号: 17, 宫属: '震宫', 世次: '归魂', 世爻: '三爻', 应爻: '上爻' },
  // 巽宫
  { 名称: '巽', 符号: '䷥', 上卦: '巽', 下卦: '巽', 序号: 57, 宫属: '巽宫', 世次: '本宫', 世爻: '上九', 应爻: '初三' },
  { 名称: '小畜', 符号: '䷈', 上卦: '巽', 下卦: '乾', 序号: 9, 宫属: '巽宫', 世次: '一世', 世爻: '初爻', 应爻: '四爻' },
  { 名称: '家人', 符号: '䷤', 上卦: '巽', 下卦: '离', 序号: 37, 宫属: '巽宫', 世次: '二世', 世爻: '二爻', 应爻: '五爻' },
  { 名称: '益', 符号: '䷩', 上卦: '巽', 下卦: '震', 序号: 42, 宫属: '巽宫', 世次: '三世', 世爻: '三爻', 应爻: '上爻' },
  { 名称: '无妄', 符号: '䷘', 上卦: '乾', 下卦: '震', 序号: 25, 宫属: '巽宫', 世次: '四世', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '噬嗑', 符号: '䷔', 上卦: '离', 下卦: '震', 序号: 21, 宫属: '巽宫', 世次: '五世', 世爻: '五爻', 应爻: '二爻' },
  { 名称: '颐', 符号: '䷚', 上卦: '艮', 下卦: '震', 序号: 27, 宫属: '巽宫', 世次: '游魂', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '蛊', 符号: '䷑', 上卦: '艮', 下卦: '巽', 序号: 18, 宫属: '巽宫', 世次: '归魂', 世爻: '三爻', 应爻: '上爻' },
  // 坎宫
  { 名称: '坎', 符号: '䷜', 上卦: '坎', 下卦: '坎', 序号: 29, 宫属: '坎宫', 世次: '本宫', 世爻: '上六', 应爻: '初三' },
  { 名称: '节', 符号: '䷻', 上卦: '坎', 下卦: '兑', 序号: 60, 宫属: '坎宫', 世次: '一世', 世爻: '初爻', 应爻: '四爻' },
  { 名称: '屯', 符号: '䷂', 上卦: '坎', 下卦: '震', 序号: 3, 宫属: '坎宫', 世次: '二世', 世爻: '二爻', 应爻: '五爻' },
  { 名称: '既济', 符号: '䷾', 上卦: '坎', 下卦: '离', 序号: 63, 宫属: '坎宫', 世次: '三世', 世爻: '三爻', 应爻: '上爻' },
  { 名称: '革', 符号: '䷰', 上卦: '兑', 下卦: '离', 序号: 49, 宫属: '坎宫', 世次: '四世', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '丰', 符号: '䷶', 上卦: '离', 下卦: '震', 序号: 55, 宫属: '坎宫', 世次: '五世', 世爻: '五爻', 应爻: '二爻' },
  { 名称: '明夷', 符号: '䷣', 上卦: '离', 下卦: '坤', 序号: 36, 宫属: '坎宫', 世次: '游魂', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '师', 符号: '䷆', 上卦: '坎', 下卦: '坤', 序号: 7, 宫属: '坎宫', 世次: '归魂', 世爻: '三爻', 应爻: '上爻' },
  // 离宫
  { 名称: '离', 符号: '䷝', 上卦: '离', 下卦: '离', 序号: 30, 宫属: '离宫', 世次: '本宫', 世爻: '上九', 应爻: '初三' },
  { 名称: '旅', 符号: '䷷', 上卦: '离', 下卦: '艮', 序号: 56, 宫属: '离宫', 世次: '一世', 世爻: '初爻', 应爻: '四爻' },
  { 名称: '鼎', 符号: '䷱', 上卦: '离', 下卦: '巽', 序号: 50, 宫属: '离宫', 世次: '二世', 世爻: '二爻', 应爻: '五爻' },
  { 名称: '未济', 符号: '䷿', 上卦: '离', 下卦: '坎', 序号: 64, 宫属: '离宫', 世次: '三世', 世爻: '三爻', 应爻: '上爻' },
  { 名称: '蒙', 符号: '䷃', 上卦: '艮', 下卦: '坎', 序号: 4, 宫属: '离宫', 世次: '四世', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '涣', 符号: '䷺', 上卦: '巽', 下卦: '坎', 序号: 59, 宫属: '离宫', 世次: '五世', 世爻: '五爻', 应爻: '二爻' },
  { 名称: '讼', 符号: '䷥', 上卦: '乾', 下卦: '坎', 序号: 6, 宫属: '离宫', 世次: '游魂', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '同人', 符号: '䷌', 上卦: '乾', 下卦: '离', 序号: 13, 宫属: '离宫', 世次: '归魂', 世爻: '三爻', 应爻: '上爻' },
  // 艮宫
  { 名称: '艮', 符号: '䷳', 上卦: '艮', 下卦: '艮', 序号: 52, 宫属: '艮宫', 世次: '本宫', 世爻: '上九', 应爻: '初三' },
  { 名称: '贲', 符号: '䷕', 上卦: '艮', 下卦: '离', 序号: 22, 宫属: '艮宫', 世次: '一世', 世爻: '初爻', 应爻: '四爻' },
  { 名称: '大畜', 符号: '䷙', 上卦: '艮', 下卦: '乾', 序号: 26, 宫属: '艮宫', 世次: '二世', 世爻: '二爻', 应爻: '五爻' },
  { 名称: '损', 符号: '䷨', 上卦: '艮', 下卦: '兑', 序号: 41, 宫属: '艮宫', 世次: '三世', 世爻: '三爻', 应爻: '上爻' },
  { 名称: '睽', 符号: '䷥', 上卦: '兑', 下卦: '离', 序号: 38, 宫属: '艮宫', 世次: '四世', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '履', 符号: '䷉', 上卦: '兑', 下卦: '乾', 序号: 10, 宫属: '艮宫', 世次: '五世', 世爻: '五爻', 应爻: '二爻' },
  { 名称: '中孚', 符号: '䷼', 上卦: '巽', 下卦: '兑', 序号: 61, 宫属: '艮宫', 世次: '游魂', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '渐', 符号: '䷴', 上卦: '艮', 下卦: '巽', 序号: 53, 宫属: '艮宫', 世次: '归魂', 世爻: '三爻', 应爻: '上爻' },
  // 兑宫
  { 名称: '兑', 符号: '䷹', 上卦: '兑', 下卦: '兑', 序号: 58, 宫属: '兑宫', 世次: '本宫', 世爻: '上六', 应爻: '初三' },
  { 名称: '困', 符号: '䷮', 上卦: '兑', 下卦: '坎', 序号: 47, 宫属: '兑宫', 世次: '一世', 世爻: '初爻', 应爻: '四爻' },
  { 名称: '萃', 符号: '䷬', 上卦: '兑', 下卦: '坤', 序号: 45, 宫属: '兑宫', 世次: '二世', 世爻: '二爻', 应爻: '五爻' },
  { 名称: '咸', 符号: '䷞', 上卦: '兑', 下卦: '艮', 序号: 31, 宫属: '兑宫', 世次: '三世', 世爻: '三爻', 应爻: '上爻' },
  { 名称: '蹇', 符号: '䷦', 上卦: '坎', 下卦: '艮', 序号: 39, 宫属: '兑宫', 世次: '四世', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '谦', 符号: '䷎', 上卦: '坤', 下卦: '艮', 序号: 15, 宫属: '兑宫', 世次: '五世', 世爻: '五爻', 应爻: '二爻' },
  { 名称: '小过', 符号: '䷽', 上卦: '震', 下卦: '艮', 序号: 62, 宫属: '兑宫', 世次: '游魂', 世爻: '四爻', 应爻: '初爻' },
  { 名称: '归妹', 符号: '䷵', 上卦: '震', 下卦: '兑', 序号: 54, 宫属: '兑宫', 世次: '归魂', 世爻: '三爻', 应爻: '上爻' }
];

// 小成图起卦方式
export enum QI_GUA_METHOD {
  TIME_BASED = '时间起卦',
  NUMBER_BASED = '数字起卦',
  RANDOM = '随机起卦',
  MANUAL = '手动选择'
}

// 起卦工具类
export class XiaoChengTuUtil {
  /**
   * 时间起卦法（按当前时间）
   */
  static timeBasedQiGua(): XiaoChengTuResult {
    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth() + 1;
    const day = now.getDate();
    const hour = now.getHours();
    const minute = now.getMinutes();
    const second = now.getSeconds();

    // 上卦：年月日相加除以8取余
    const upperIndex = ((year + month + day) % 8) || 8;
    // 下卦：年月日时相加除以8取余
    const lowerIndex = ((year + month + day + hour) % 8) || 8;
    // 动爻：年月日时分相加除以6取余
    // const dongYao = ((year + month + day + hour + minute + second) % 6) || 6;

    const upperGua = BA_GUA_DATA[upperIndex - 1];
    const lowerGua = BA_GUA_DATA[lowerIndex - 1];

    return XiaoChengTuUtil.createResult(upperGua, lowerGua, QI_GUA_METHOD.TIME_BASED);
  }

  /**
   * 数字起卦法
   */
  static numberBasedQiGua(upperNum: number, lowerNum: number): XiaoChengTuResult {
    const upperIndex = (upperNum % 8) || 8;
    const lowerIndex = (lowerNum % 8) || 8;

    const upperGua = BA_GUA_DATA[upperIndex - 1];
    const lowerGua = BA_GUA_DATA[lowerIndex - 1];

    return XiaoChengTuUtil.createResult(upperGua, lowerGua, QI_GUA_METHOD.NUMBER_BASED);
  }

  /**
   * 随机起卦法
   */
  static randomQiGua(): XiaoChengTuResult {
    const upperIndex = Math.floor(Math.random() * 8);
    const lowerIndex = Math.floor(Math.random() * 8);

    const upperGua = BA_GUA_DATA[upperIndex];
    const lowerGua = BA_GUA_DATA[lowerIndex];

    return XiaoChengTuUtil.createResult(upperGua, lowerGua, QI_GUA_METHOD.RANDOM);
  }

  /**
   * 手动选择起卦法
   */
  static manualQiGua(upperGuaName: string, lowerGuaName: string): XiaoChengTuResult {
    const upperGua = BA_GUA_DATA.find(gua => gua.名称 === upperGuaName) || BA_GUA_DATA[0];
    const lowerGua = BA_GUA_DATA.find(gua => gua.名称 === lowerGuaName) || BA_GUA_DATA[0];

    return XiaoChengTuUtil.createResult(upperGua, lowerGua, QI_GUA_METHOD.MANUAL);
  }

  /**
   * 创建起卦结果
   */
  private static createResult(upperGua: BaGua, lowerGua: BaGua, method: QI_GUA_METHOD): XiaoChengTuResult {
    // 查找对应的重卦
    const zhongGua = LIU_SHI_SI_GUA_DATA.find(gua => 
      gua.上卦 === upperGua.名称 && gua.下卦 === lowerGua.名称
    );

    if (!zhongGua) {
      // 如果找不到对应的卦，创建一个默认的结果
      return {
        上卦: upperGua,
        下卦: lowerGua,
        重卦: {
          名称: `${upperGua.名称}${lowerGua.名称}`,
          符号: `${upperGua.符号}${lowerGua.符号}`,
          上卦: upperGua.名称,
          下卦: lowerGua.名称,
          序号: 0,
          宫属: '未知',
          世次: '未知',
          世爻: '未知',
          应爻: '未知'
        },
        起卦方式: method,
        时间: new Date(),
        解说: XiaoChengTuUtil.generateExplanation(upperGua, lowerGua, null)
      };
    }

    return {
      上卦: upperGua,
      下卦: lowerGua,
      重卦: zhongGua,
      起卦方式: method,
      时间: new Date(),
      解说: XiaoChengTuUtil.generateExplanation(upperGua, lowerGua, zhongGua)
    };
  }

  /**
   * 生成解说
   */
  private static generateExplanation(upperGua: BaGua, lowerGua: BaGua, zhongGua: ZhongGua | null): string {
    let explanation = `【小成图解说】\n\n`;
    explanation += `上卦为${upperGua.名称}（${upperGua.符号}），五行属${upperGua.五行}，方位在${upperGua.方位}。\n`;
    explanation += `下卦为${lowerGua.名称}（${lowerGua.符号}），五行属${lowerGua.五行}，方位在${lowerGua.方位}。\n\n`;

    // 五行生克关系
    const wuxingRelation = XiaoChengTuUtil.getWuxingRelation(upperGua.五行, lowerGua.五行);
    explanation += `五行关系：${wuxingRelation}\n\n`;

    if (zhongGua) {
      explanation += `重卦为${zhongGua.名称}（${zhongGua.符号}），属${zhongGua.宫属}，${zhongGua.世次}卦。\n`;
      explanation += `世爻在${zhongGua.世爻}，应爻在${zhongGua.应爻}。\n\n`;
      
      explanation += `【卦象解析】\n`;
      explanation += `上卦${upperGua.名称}为天，下卦${lowerGua.名称}为地，天地交感，化生万物。\n`;
      explanation += `此卦象征${upperGua.五行}${lowerGua.五行}相${wuxingRelation.includes('相生') ? '生' : '克'}之象，`;
      explanation += `预示着事物发展的趋势和变化。\n\n`;
      
      explanation += `【小成图原理】\n`;
      explanation += `小成图是通过八卦重合形成六十四卦的方法，体现了"天人合一"的哲学思想。\n`;
      explanation += `上卦代表天时、外部环境，下卦代表地利、内在条件，天地配合方能成事。\n`;
    }

    return explanation;
  }

  /**
   * 获取五行生克关系
   */
  private static getWuxingRelation(wuxing1: string, wuxing2: string): string {
    let sheng1 = '';
    let ke1 = '';
    let sheng2 = '';
    let ke2 = '';

    switch (wuxing1) {
      case '金':
        sheng1 = '水';
        ke1 = '木';
        break;
      case '木':
        sheng1 = '火';
        ke1 = '土';
        break;
      case '水':
        sheng1 = '木';
        ke1 = '火';
        break;
      case '火':
        sheng1 = '土';
        ke1 = '金';
        break;
      case '土':
        sheng1 = '金';
        ke1 = '水';
        break;
    }

    switch (wuxing2) {
      case '金':
        sheng2 = '水';
        ke2 = '木';
        break;
      case '木':
        sheng2 = '火';
        ke2 = '土';
        break;
      case '水':
        sheng2 = '木';
        ke2 = '火';
        break;
      case '火':
        sheng2 = '土';
        ke2 = '金';
        break;
      case '土':
        sheng2 = '金';
        ke2 = '水';
        break;
    }

    if (sheng1 === wuxing2) {
      return `${wuxing1}生${wuxing2}（相生关系，主发展、成长）`;
    } else if (ke1 === wuxing2) {
      return `${wuxing1}克${wuxing2}（相克关系，主制约、变化）`;
    } else if (sheng2 === wuxing1) {
      return `${wuxing2}生${wuxing1}（相生关系，主滋养、培育）`;
    } else if (ke2 === wuxing1) {
      return `${wuxing2}克${wuxing1}（相克关系，主冲突、挑战）`;
    } else {
      return `${wuxing1}与${wuxing2}（同类关系，主和谐、稳定）`;
    }
  }
}