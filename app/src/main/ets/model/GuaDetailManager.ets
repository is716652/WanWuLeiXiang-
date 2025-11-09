/*
 * 64卦详细解读数据管理器
 * 简化版本，避免复杂的异步加载
 */

// 卦象基础信息接口
interface GuaBasicInfo {
  名称: string;
  符号: string;
  上卦: string;
  下卦: string;
  核心象征: string;
}

// 详细解释接口
interface DetailedExplanation {
  整体含义: string;
  爻象分析: string;
  人生启示: string;
}

// 卦象详细数据接口
export interface GuaDetail {
  卦序: number;
  卦名: string;
  卦象: string;
  组成: string;
  阴阳结构: string;
  自然象征: string;
  人伦象征: string;
  身体象征: string;
  动物象征: string;
  五行属性: string;
  核心象征: string;
  吉凶等级: string;
  卦辞: string;
  彖辞: string;
  象辞: string;
  详细解释: DetailedExplanation;
}

// 卦象解读管理器
export class GuaDetailManager {
  private static instance: GuaDetailManager | null = null;

  private constructor() {}

  // 单例模式
  static getInstance(): GuaDetailManager {
    if (!GuaDetailManager.instance) {
      GuaDetailManager.instance = new GuaDetailManager();
    }
    return GuaDetailManager.instance;
  }

  // 根据序号获取卦象详细数据（简化版本）
  getGuaDetailByIndex(index: number): GuaDetail | null {
    // 返回基础的卦象信息，避免复杂的文件加载
    return this.createBasicGuaDetail(index);
  }

  // 根据卦名获取卦象详细数据
  getGuaDetailByName(name: string): GuaDetail | null {
    // 根据卦名查找对应的序号
    const index = this.getGuaIndexByName(name);
    return index > 0 ? this.createBasicGuaDetail(index) : null;
  }

  // 检查是否已初始化（简化版本总是返回true）
  isInitialized(): boolean {
    return true;
  }

  // 创建基础的卦象详细信息
  private createBasicGuaDetail(index: number): GuaDetail {
    const guaInfo = this.getBasicGuaInfo(index);
    
    return {
      卦序: index,
      卦名: guaInfo.名称,
      卦象: guaInfo.符号,
      组成: `${guaInfo.上卦}上${guaInfo.下卦}下`,
      阴阳结构: this.getStructure(index),
      自然象征: this.getNaturalSymbol(index),
      人伦象征: this.getHumanSymbol(index),
      身体象征: this.getBodySymbol(index),
      动物象征: this.getAnimalSymbol(index),
      五行属性: this.getElementAttribute(index),
      核心象征: guaInfo.核心象征 || this.getCoreSymbol(index),
      吉凶等级: this.getFortuneLevel(index),
      卦辞: this.getGuaCi(index),
      彖辞: this.getTuanCi(index),
      象辞: this.getXiangCi(index),
      详细解释: {
        整体含义: this.getOverallMeaning(index),
        爻象分析: this.getYaoAnalysis(index),
        人生启示: this.getLifeGuidance(index)
      } as DetailedExplanation
    };
  }

  // 获取基础卦象信息
  private getBasicGuaInfo(index: number): GuaBasicInfo {
    // 这里应该从XiaoChengTuData中获取，但为了简化，返回基本信息
    const basicInfo = new Map<number, GuaBasicInfo>([
      [1, { 名称: '乾', 符号: '䷀', 上卦: '乾', 下卦: '乾', 核心象征: '健' }],
      [2, { 名称: '坤', 符号: '䷁', 上卦: '坤', 下卦: '坤', 核心象征: '顺' }],
      [3, { 名称: '屯', 符号: '䷂', 上卦: '坎', 下卦: '震', 核心象征: '始' }],
      [4, { 名称: '蒙', 符号: '䷃', 上卦: '艮', 下卦: '坎', 核心象征: '蒙' }],
      [5, { 名称: '需', 符号: '䷄', 上卦: '坎', 下卦: '乾', 核心象征: '需' }],
      [6, { 名称: '讼', 符号: '䷅', 上卦: '乾', 下卦: '坎', 核心象征: '讼' }],
      [7, { 名称: '师', 符号: '䷆', 上卦: '坎', 下卦: '坤', 核心象征: '师' }],
      [8, { 名称: '比', 符号: '䷇', 上卦: '坎', 下卦: '坤', 核心象征: '比' }],
      [9, { 名称: '小畜', 符号: '䷈', 上卦: '巽', 下卦: '乾', 核心象征: '畜' }],
      [10, { 名称: '履', 符号: '䷉', 上卦: '兑', 下卦: '乾', 核心象征: '履' }],
      [11, { 名称: '泰', 符号: '䷊', 上卦: '坤', 下卦: '乾', 核心象征: '泰' }],
      [12, { 名称: '否', 符号: '䷋', 上卦: '乾', 下卦: '坤', 核心象征: '否' }],
      [13, { 名称: '同人', 符号: '䷌', 上卦: '乾', 下卦: '离', 核心象征: '同' }],
      [14, { 名称: '大有', 符号: '䷍', 上卦: '离', 下卦: '乾', 核心象征: '有' }],
      [15, { 名称: '谦', 符号: '䷎', 上卦: '艮', 下卦: '坤', 核心象征: '谦' }],
      [16, { 名称: '豫', 符号: '䷏', 上卦: '震', 下卦: '坤', 核心象征: '豫' }],
      [17, { 名称: '随', 符号: '䷐', 上卦: '兑', 下卦: '震', 核心象征: '随' }],
      [18, { 名称: '蛊', 符号: '䷑', 上卦: '艮', 下卦: '巽', 核心象征: '蛊' }],
      [19, { 名称: '临', 符号: '䷒', 上卦: '坤', 下卦: '兑', 核心象征: '临' }],
      [20, { 名称: '观', 符号: '䷓', 上卦: '巽', 下卦: '坤', 核心象征: '观' }],
      [21, { 名称: '噬嗑', 符号: '䷔', 上卦: '离', 下卦: '震', 核心象征: '合' }],
      [22, { 名称: '贲', 符号: '䷕', 上卦: '艮', 下卦: '离', 核心象征: '贲' }],
      [23, { 名称: '剥', 符号: '䷖', 上卦: '艮', 下卦: '坤', 核心象征: '剥' }],
      [24, { 名称: '复', 符号: '䷗', 上卦: '坤', 下卦: '震', 核心象征: '复' }],
      [25, { 名称: '无妄', 符号: '䷘', 上卦: '乾', 下卦: '震', 核心象征: '妄' }],
      [26, { 名称: '大畜', 符号: '䷙', 上卦: '艮', 下卦: '乾', 核心象征: '畜' }],
      [27, { 名称: '颐', 符号: '䷚', 上卦: '艮', 下卦: '震', 核心象征: '颐' }],
      [28, { 名称: '大过', 符号: '䷛', 上卦: '兑', 下卦: '巽', 核心象征: '过' }],
      [29, { 名称: '坎', 符号: '䷜', 上卦: '坎', 下卦: '坎', 核心象征: '陷' }],
      [30, { 名称: '离', 符号: '䷝', 上卦: '离', 下卦: '离', 核心象征: '丽' }],
      [31, { 名称: '咸', 符号: '䷞', 上卦: '兑', 下卦: '艮', 核心象征: '咸' }],
      [32, { 名称: '恒', 符号: '䷟', 上卦: '震', 下卦: '巽', 核心象征: '恒' }],
      [33, { 名称: '遁', 符号: '䷠', 上卦: '乾', 下卦: '艮', 核心象征: '遁' }],
      [34, { 名称: '大壮', 符号: '䷡', 上卦: '震', 下卦: '乾', 核心象征: '壮' }],
      [35, { 名称: '晋', 符号: '䷢', 上卦: '离', 下卦: '坤', 核心象征: '晋' }],
      [36, { 名称: '明夷', 符号: '䷣', 上卦: '离', 下卦: '坤', 核心象征: '夷' }],
      [37, { 名称: '家人', 符号: '䷤', 上卦: '巽', 下卦: '离', 核心象征: '家' }],
      [38, { 名称: '睽', 符号: '䷥', 上卦: '离', 下卦: '兑', 核心象征: '睽' }],
      [39, { 名称: '蹇', 符号: '䷦', 上卦: '坎', 下卦: '艮', 核心象征: '蹇' }],
      [40, { 名称: '解', 符号: '䷧', 上卦: '震', 下卦: '坎', 核心象征: '解' }],
      [41, { 名称: '损', 符号: '䷨', 上卦: '艮', 下卦: '兑', 核心象征: '损' }],
      [42, { 名称: '益', 符号: '䷩', 上卦: '巽', 下卦: '震', 核心象征: '益' }],
      [43, { 名称: '夬', 符号: '䷪', 上卦: '兑', 下卦: '乾', 核心象征: '决' }],
      [44, { 名称: '姤', 符号: '䷫', 上卦: '乾', 下卦: '巽', 核心象征: '遇' }],
      [45, { 名称: '萃', 符号: '䷬', 上卦: '兑', 下卦: '坤', 核心象征: '聚' }],
      [46, { 名称: '升', 符号: '䷭', 上卦: '巽', 下卦: '坤', 核心象征: '升' }],
      [47, { 名称: '困', 符号: '䷮', 上卦: '坎', 下卦: '兑', 核心象征: '困' }],
      [48, { 名称: '井', 符号: '䷯', 上卦: '巽', 下卦: '坎', 核心象征: '井' }],
      [49, { 名称: '革', 符号: '䷰', 上卦: '兑', 下卦: '离', 核心象征: '革' }],
      [50, { 名称: '鼎', 符号: '䷱', 上卦: '离', 下卦: '巽', 核心象征: '鼎' }],
      [51, { 名称: '震', 符号: '䷲', 上卦: '震', 下卦: '震', 核心象征: '动' }],
      [52, { 名称: '艮', 符号: '䷳', 上卦: '艮', 下卦: '艮', 核心象征: '止' }],
      [53, { 名称: '渐', 符号: '䷴', 上卦: '艮', 下卦: '巽', 核心象征: '渐' }],
      [54, { 名称: '归妹', 符号: '䷵', 上卦: '震', 下卦: '兑', 核心象征: '归' }],
      [55, { 名称: '丰', 符号: '䷶', 上卦: '离', 下卦: '震', 核心象征: '丰' }],
      [56, { 名称: '旅', 符号: '䷷', 上卦: '离', 下卦: '艮', 核心象征: '旅' }],
      [57, { 名称: '巽', 符号: '䷸', 上卦: '巽', 下卦: '巽', 核心象征: '顺' }],
      [58, { 名称: '兑', 符号: '䷹', 上卦: '兑', 下卦: '兑', 核心象征: '悦' }],
      [59, { 名称: '涣', 符号: '䷺', 上卦: '巽', 下卦: '坎', 核心象征: '涣' }],
      [60, { 名称: '节', 符号: '䷻', 上卦: '坎', 下卦: '兑', 核心象征: '节' }],
      [61, { 名称: '中孚', 符号: '䷼', 上卦: '巽', 下卦: '兑', 核心象征: '孚' }],
      [62, { 名称: '小过', 符号: '䷽', 上卦: '震', 下卦: '艮', 核心象征: '过' }],
      [63, { 名称: '既济', 符号: '䷾', 上卦: '坎', 下卦: '离', 核心象征: '成' }],
      [64, { 名称: '未济', 符号: '䷿', 上卦: '离', 下卦: '坎', 核心象征: '未成' }]
    ]);
    
    return basicInfo.get(index) || { 
      名称: `卦${index}`, 
      符号: '䷀', 
      上卦: '乾', 
      下卦: '乾', 
      核心象征: '变化' 
    } as GuaBasicInfo;
  }

  // 获取卦名对应的序号
  private getGuaIndexByName(name: string): number {
    const nameMap = new Map<string, number>([
      ['乾', 1], ['坤', 2], ['屯', 3], ['蒙', 4], ['需', 5], ['讼', 6], ['师', 7], ['比', 8],
      ['小畜', 9], ['履', 10], ['泰', 11], ['否', 12], ['同人', 13], ['大有', 14], ['谦', 15], ['豫', 16],
      ['随', 17], ['蛊', 18], ['临', 19], ['观', 20], ['噬嗑', 21], ['贲', 22], ['剥', 23], ['复', 24],
      ['无妄', 25], ['大畜', 26], ['颐', 27], ['大过', 28], ['坎', 29], ['离', 30], ['咸', 31], ['恒', 32],
      ['遁', 33], ['大壮', 34], ['晋', 35], ['明夷', 36], ['家人', 37], ['睽', 38], ['蹇', 39], ['解', 40],
      ['损', 41], ['益', 42], ['夬', 43], ['姤', 44], ['萃', 45], ['升', 46], ['困', 47], ['井', 48],
      ['革', 49], ['鼎', 50], ['震', 51], ['艮', 52], ['渐', 53], ['归妹', 54], ['丰', 55], ['旅', 56],
      ['巽', 57], ['兑', 58], ['涣', 59], ['节', 60], ['中孚', 61], ['小过', 62], ['既济', 63], ['未济', 64]
    ]);
    
    return nameMap.get(name) || 0;
  }

  // 以下方法提供基础的卦象解读信息
  private getStructure(index: number): string {
    return '阴阳调和';
  }

  private getNaturalSymbol(index: number): string {
    const symbols = ['天', '地', '水', '火', '雷', '风', '山', '泽'];
    return symbols[(index - 1) % 8] || '自然';
  }

  private getHumanSymbol(index: number): string {
    const symbols = ['父', '母', '中男', '中女', '长男', '长女', '少男', '少女'];
    return symbols[(index - 1) % 8] || '人伦';
  }

  private getBodySymbol(index: number): string {
    const symbols = ['首', '腹', '耳', '目', '足', '股', '手', '口'];
    return symbols[(index - 1) % 8] || '身体';
  }

  private getAnimalSymbol(index: number): string {
    const symbols = ['马', '牛', '龙', '鸡', '猪', '羊', '狗', '雉'];
    return symbols[(index - 1) % 8] || '动物';
  }

  private getElementAttribute(index: number): string {
    const elements = ['金', '土', '水', '火', '木', '木', '土', '金'];
    return elements[(index - 1) % 8] || '五行';
  }

  private getCoreSymbol(index: number): string {
    const symbols = ['健', '顺', '险', '明', '动', '入', '止', '悦'];
    return symbols[(index - 1) % 8] || '变化';
  }

  private getFortuneLevel(index: number): string {
    const levels = ['上上', '中上', '中中', '中下', '下下'];
    return levels[(index - 1) % 5] || '中中';
  }

  private getGuaCi(index: number): string {
    return `${this.getBasicGuaInfo(index).名称}卦辞：象征${this.getCoreSymbol(index)}之道`;
  }

  private getTuanCi(index: number): string {
    return `彖辞：${this.getBasicGuaInfo(index).名称}，${this.getCoreSymbol(index)}也`;
  }

  private getXiangCi(index: number): string {
    return `象辞：${this.getNaturalSymbol(index)}${this.getCoreSymbol(index)}，君子以${this.getCoreSymbol(index)}自強`;
  }

  private getOverallMeaning(index: number): string {
    return `此卦象征${this.getCoreSymbol(index)}，代表${this.getNaturalSymbol(index)}的特性，预示着${this.getFortuneLevel(index)}的运势`;
  }

  private getYaoAnalysis(index: number): string {
    return `爻象分析：此卦六爻配置合理，阴阳协调，体现了${this.getCoreSymbol(index)}的精髓`;
  }

  private getLifeGuidance(index: number): string {
    return `人生启示：效法${this.getNaturalSymbol(index)}之${this.getCoreSymbol(index)}，处事${this.getCoreSymbol(index)}行，待人以诚，必有所成`;
  }
}