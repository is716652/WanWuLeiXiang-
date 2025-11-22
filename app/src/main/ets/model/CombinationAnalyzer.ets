import { KBItem, KnowledgeBase } from './KnowledgeBase';

export interface RuleCard {
  id: string;
  title: string;
  matchTokens: string[];
}

export interface RuleComboSummary {
  id: string;
  title: string;
  fn: string;
  use: string[];
}

export interface KeyValue {
  key: string;
  value: string;
}

export interface GuaTransformItem {
  code: string;
  name: string;
  wrong: string;
  overturn: string;
  mutual: string[];
}

export interface CalendarMaps {
  year_ganzhi: KeyValue[];
  ganzhi_nayin: KeyValue[];
  month_guaqi: KeyValue[];
}

export interface RulesMaps {
  gua_transform: GuaTransformItem[];
  calendar: CalendarMaps;
}

export interface RulesSchema {
  version: string;
  cards: RuleCard[];
  combos: RuleComboSummary[];
  maps: RulesMaps;
}

export class CombinationAnalyzer {
  private static instance: CombinationAnalyzer;

  private constructor() {}

  private rulesLoaded: boolean = false;
  private ruleCards: RuleCard[] = [];
  private ruleCombos: RuleComboSummary[] = [];
  private mapGuaTransform: GuaTransformItem[] = [];
  private mapYearGanzhi: KeyValue[] = [];
  private mapGanzhiNayin: KeyValue[] = [];
  private mapMonthGuaqi: KeyValue[] = [];

  static getInstance(): CombinationAnalyzer {
    if (!CombinationAnalyzer.instance) {
      CombinationAnalyzer.instance = new CombinationAnalyzer();
    }
    return CombinationAnalyzer.instance;
  }

  getHintFor(query: string): string {
    const key: string = query.trim();
    const tokens: string[] = this.splitTokens(key);
    const foundCards: string[] = [];
    for (let i = 0; i < this.ruleCards.length; i++) {
      const c = this.ruleCards[i];
      let hit: boolean = false;
      for (let t = 0; t < c.matchTokens.length; t++) {
        const token = c.matchTokens[t];
        for (let k = 0; k < tokens.length; k++) {
          if (tokens[k].indexOf(token) >= 0) { hit = true; break; }
        }
        if (hit) { break; }
      }
      if (hit) { foundCards.push(c.title); }
    }
    if (foundCards.length > 0) {
      return '检测到组合：' + key + '。请到卡片中自行查阅：' + foundCards.join('、');
    }
    return '';
  }

  analyze(query: string, kb: KnowledgeBase): KBItem {
    const key: string = query.trim();
    const summaryLines: string[] = [];
    summaryLines.push('【组合解析报告】');
    this.loadRules(kb);

    // 解析地支
    const dizhiAll: string[] = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];
    const ganAll: string[] = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'];
    const baguaAll: string[] = ['乾','坤','震','巽','坎','离','艮','兑'];

    const tokens: string[] = this.splitTokens(key);
    const zhiFound: string[] = this.pickFrom(tokens, dizhiAll);
    const ganFound: string[] = this.pickFrom(tokens, ganAll);
    const baguaFound: string[] = this.pickFrom(tokens, baguaAll);

    // 地支关系
    if (zhiFound.length > 0) {
      summaryLines.push('· 地支识别: ' + zhiFound.join(' '));
      const heResults: string[] = this.calcDizhiHe(zhiFound);
      const chongResults: string[] = this.calcDizhiChong(zhiFound);
      const sanheResults: string[] = this.calcDizhiSanHe(zhiFound);
      if (heResults.length > 0) { summaryLines.push('  六合: ' + heResults.join('、')); }
      if (chongResults.length > 0) { summaryLines.push('  六冲: ' + chongResults.join('、')); }
      if (sanheResults.length > 0) { summaryLines.push('  三合/三会: ' + sanheResults.join('、')); }
    }

    // 天干关系
    if (ganFound.length > 0) {
      summaryLines.push('· 天干识别: ' + ganFound.join(' '));
      const wuHe: string[] = this.calcTianganWuHe(ganFound);
      if (wuHe.length > 0) { summaryLines.push('  五合: ' + wuHe.join('、')); }
      summaryLines.push('  生克提示: 以五行生克为准（木火土金水），可参考纳音/五行映射）。');
    }

    // 八卦识别（简单属性）
    if (baguaFound.length > 0) {
      summaryLines.push('· 八卦识别: ' + baguaFound.join(' '));
      for (let i = 0; i < baguaFound.length; i++) {
        const line: string = this.descBagua(baguaFound[i]);
        if (line !== '') { summaryLines.push('  ' + line); }
      }
    }

    // 规则驱动计算：六十四卦变换 + 万年历
    // 六十四卦变换：按名称命中
    for (let bi = 0; bi < baguaFound.length; bi++) {
      const name: string = baguaFound[bi];
      for (let gi = 0; gi < this.mapGuaTransform.length; gi++) {
        const gt = this.mapGuaTransform[gi];
        if (gt.name === name) {
          summaryLines.push('· 六十四卦变换: ' + name + ' → 错卦 ' + gt.wrong + '，综卦 ' + gt.overturn + (gt.mutual.length > 0 ? ('，互卦 ' + gt.mutual.join('、')) : ''));
          break;
        }
      }
    }
    // 万年历：日期识别并计算（优先用映射，缺失则回退算法）
    const dateRegex = /\d{4}-\d{2}-\d{2}/;
    const dm = dateRegex.exec(query);
    if (dm) {
      const dateStr: string = dm[0];
      const yearStr: string = dateStr.substring(0, 4);
      const monthStr: string = dateStr.substring(5, 7);
      const ganzhi: string = this.calcYearGanzhi(yearStr);
      const nayin: string = this.findKV(this.mapGanzhiNayin, ganzhi);
      const guaqi: string = this.findKV(this.mapMonthGuaqi, monthStr);
      summaryLines.push('· 日期计算: ' + dateStr + ' → 年干支 ' + ganzhi + (nayin !== '' ? ('，纳音 ' + nayin) : '') + (guaqi !== '' ? ('，卦气 ' + guaqi) : ''));
    }

    // 六十四卦/焦氏易林/万年历提示（由知识库命中）
    summaryLines.push('· 关联提示: 六十四卦、焦氏易林、万年历等详解请参考本地知识库命中的卡片。');

    const content: string = summaryLines.join('\n');
    const id: string = 'analysis_' + this.nowTick();
    const item: KBItem = { id: id, title: '组合解析报告', type: 'md', tags: ['组合解析','本地规则'], content: content };
    kb.registerExternalDoc(item.id, item.title, item.content, item.tags);
    return item;
  }

  private loadRules(kb: KnowledgeBase): void {
    if (this.rulesLoaded) { return; }
    const items: KBItem[] = kb.getAll();
    let text: string = '';
    for (let i = 0; i < items.length; i++) {
      const it = items[i];
      if (it.id === 'rules/combination_rules.json' && it.type === 'json') {
        text = it.content;
        break;
      }
    }
    if (text === '') { this.rulesLoaded = true; return; }
    // 解析为固定结构（避免使用 any/unknown）
    const parsed = JSON.parse(text) as RulesSchema;
    this.ruleCards = parsed.cards;
    this.ruleCombos = parsed.combos;
    this.mapGuaTransform = parsed.maps.gua_transform;
    this.mapYearGanzhi = parsed.maps.calendar.year_ganzhi;
    this.mapGanzhiNayin = parsed.maps.calendar.ganzhi_nayin;
    this.mapMonthGuaqi = parsed.maps.calendar.month_guaqi;
    this.rulesLoaded = true;
  }

  private splitTokens(text: string): string[] {
    let normalized: string = text;
    normalized = normalized.replace('，', ' ');
    normalized = normalized.replace('、', ' ');
    normalized = normalized.replace('与', ' ');
    normalized = normalized.replace('和', ' ');
    normalized = normalized.replace(',', ' ');
    const arr: string[] = normalized.split(' ');
    const out: string[] = [];
    for (let i = 0; i < arr.length; i++) {
      const t = arr[i].trim();
      if (t !== '') { out.push(t); }
    }
    // 追加中文二字分词
    const len: number = text.length;
    for (let i = 0; i < len - 1; i++) {
      const gram: string = text.substring(i, i + 2);
      const hasSpace: boolean = gram.indexOf(' ') >= 0;
      const hasCommaCn: boolean = gram.indexOf('，') >= 0;
      const hasCommaEn: boolean = gram.indexOf(',') >= 0;
      const hasDunhao: boolean = gram.indexOf('、') >= 0;
      if (hasSpace || hasCommaCn || hasCommaEn || hasDunhao) {
        continue;
      }
      out.push(gram);
    }
    return out;
  }

  private pickFrom(tokens: string[], dict: string[]): string[] {
    const res: string[] = [];
    for (let i = 0; i < dict.length; i++) {
      const d = dict[i];
      for (let j = 0; j < tokens.length; j++) {
        if (tokens[j].indexOf(d) >= 0) {
          // 去重
          let exists: boolean = false;
          for (let k = 0; k < res.length; k++) { if (res[k] === d) { exists = true; break; } }
          if (!exists) { res.push(d); }
        }
      }
    }
    return res;
  }

  private calcDizhiHe(zhi: string[]): string[] {
    const pairs: Array<string[]> = [['子','丑'],['寅','亥'],['卯','戌'],['辰','酉'],['巳','申'],['午','未']];
    return this.pickPairs(zhi, pairs, '');
  }

  private calcDizhiChong(zhi: string[]): string[] {
    const pairs: Array<string[]> = [['子','午'],['丑','未'],['寅','申'],['卯','酉'],['辰','戌'],['巳','亥']];
    return this.pickPairs(zhi, pairs, '');
  }

  private calcDizhiSanHe(zhi: string[]): string[] {
    const groups: Array<string[]> = [['申','子','辰'],['亥','卯','未'],['寅','午','戌'],['巳','酉','丑']];
    const res: string[] = [];
    for (let i = 0; i < groups.length; i++) {
      const g = groups[i];
      if (this.containsAll(zhi, g)) {
        res.push(g.join(''));
      }
    }
    return res;
  }

  private calcTianganWuHe(gan: string[]): string[] {
    const pairs: Array<string[]> = [['甲','己'],['乙','庚'],['丙','辛'],['丁','壬'],['戊','癸']];
    return this.pickPairs(gan, pairs, '');
  }

  private pickPairs(input: string[], pairs: Array<string[]>, joiner: string): string[] {
    const res: string[] = [];
    for (let i = 0; i < pairs.length; i++) {
      const p = pairs[i];
      if (this.containsAll(input, p)) {
        const label: string = joiner === '' ? (p[0] + p[1]) : (p[0] + joiner + p[1]);
        res.push(label);
      }
    }
    return res;
  }

  private containsAll(have: string[], need: string[]): boolean {
    for (let i = 0; i < need.length; i++) {
      let found: boolean = false;
      for (let j = 0; j < have.length; j++) {
        if (have[j] === need[i]) { found = true; break; }
      }
      if (!found) { return false; }
    }
    return true;
  }

  private descBagua(name: string): string {
    // 简要属性描述（后天常用）
    if (name === '离') { return '离：火，南方，九宫数 9。'; }
    if (name === '坎') { return '坎：水，北方，九宫数 1。'; }
    if (name === '震') { return '震：雷，东方，九宫数 3。'; }
    if (name === '巽') { return '巽：风，东南，九宫数 4。'; }
    if (name === '坤') { return '坤：地，西南，九宫数 2。'; }
    if (name === '乾') { return '乾：天，西北，九宫数 6。'; }
    if (name === '兑') { return '兑：泽，西方，九宫数 7。'; }
    if (name === '艮') { return '艮：山，东北，九宫数 8。'; }
    return '';
  }

  private findKV(arr: KeyValue[], key: string): string {
    for (let i = 0; i < arr.length; i++) {
      if (arr[i].key === key) { return arr[i].value; }
    }
    return '';
  }

  private calcYearGanzhi(yearStr: string): string {
    // 优先映射
    const m = this.findKV(this.mapYearGanzhi, yearStr);
    if (m !== '') { return m; }
    // 回退算法：以1984年甲子为基准
    const year: number = parseInt(yearStr);
    const base: number = 1984; // 甲子
    const offset: number = year - base;
    const ganArr: string[] = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'];
    const zhiArr: string[] = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];
    let idxGan: number = offset % 10;
    let idxZhi: number = offset % 12;
    if (idxGan < 0) { idxGan += 10; }
    if (idxZhi < 0) { idxZhi += 12; }
    return ganArr[idxGan] + zhiArr[idxZhi];
  }

  private nowTick(): string {
    const d = new Date();
    const y = d.getFullYear();
    const m = d.getMonth() + 1;
    const da = d.getDate();
    const h = d.getHours();
    const mi = d.getMinutes();
    const s = d.getSeconds();
    return '' + y + m + da + h + mi + s;
  }
}
