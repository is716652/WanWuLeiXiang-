/*
 * 本地知识库：加载 rawfile JSON 数据和 rawfile 下的 Markdown 文档，提供关键词检索
 * 遵循 ArkTS 开发规范：不使用可选链/展开/索引签名/any 等
 */
import util from '@ohos.util';
import common from '@ohos.app.ability.common';

export interface KBItem {
  id: string;
  title: string;
  type: string; // 'json' | 'md'
  tags: string[];
  content: string;
}

export class KnowledgeBase {
  private static instance: KnowledgeBase;
  private items: KBItem[] = [];
  private tokenIndex: Map<string, string[]> = new Map();

  private constructor() {}

  static getInstance(): KnowledgeBase {
    if (!KnowledgeBase.instance) {
      KnowledgeBase.instance = new KnowledgeBase();
    }
    return KnowledgeBase.instance;
  }

  clear(): void {
    this.items = [];
  }

  getCount(): number {
    return this.items.length;
  }

  getAll(): KBItem[] {
    return this.items;
  }

  private indexItem(item: KBItem): void {
    // 基于标题与标签构建轻量索引（支持中文二字分词）
    const tokens: string[] = [];
    tokens.push(item.title);
    for (let i = 0; i < item.tags.length; i++) {
      tokens.push(item.tags[i]);
    }
    // 从标题生成二字分词
    const len: number = item.title.length;
    for (let i = 0; i < len - 1; i++) {
      const gram: string = item.title.substring(i, i + 2);
      tokens.push(gram);
    }
    for (let t = 0; t < tokens.length; t++) {
      const tk = tokens[t];
      if (tk === '') { continue; }
      const exists = this.tokenIndex.get(tk);
      if (exists) {
        let hasId: boolean = false;
        for (let k = 0; k < exists.length; k++) {
          if (exists[k] === item.id) { hasId = true; break; }
        }
        if (!hasId) { exists.push(item.id); }
      } else {
        this.tokenIndex.set(tk, [item.id]);
      }
    }
  }

  private getDizhiHan(fileName: string): string {
    const start: number = 'dizhi_'.length;
    const dotIndex: number = fileName.indexOf('.');
    let token: string = '';
    if (dotIndex > start) {
      token = fileName.substring(start, dotIndex);
    }
    switch (token) {
      case 'zi': return '子';
      case 'chou': return '丑';
      case 'yin': return '寅';
      case 'mao': return '卯';
      case 'chen': return '辰';
      case 'si': return '巳';
      case 'wu': return '午';
      case 'wei': return '未';
      case 'shen': return '申';
      case 'you': return '酉';
      case 'xu': return '戌';
      case 'hai': return '亥';
      default: return '';
    }
  }

  private getTianganHan(fileName: string): string {
    const start: number = 'tiangan_'.length;
    const dotIndex: number = fileName.indexOf('.');
    let token: string = '';
    if (dotIndex > start) {
      token = fileName.substring(start, dotIndex);
    }
    switch (token) {
      case 'jia': return '甲';
      case 'yi': return '乙';
      case 'bing': return '丙';
      case 'ding': return '丁';
      case 'wu': return '戊';
      case 'ji': return '己';
      case 'geng': return '庚';
      case 'xin': return '辛';
      case 'ren': return '壬';
      case 'gui': return '癸';
      default: return '';
    }
  }

  // 注册外部文档（用于非 rawfile 的 md 文档在运行时注入）
  registerExternalDoc(id: string, title: string, content: string, tags: string[]): void {
    const item: KBItem = { id: id, title: title, type: 'md', tags: tags, content: content };
    this.items.push(item);
    this.indexItem(item);
  }

  // 从 rawfile 加载 JSON 文件（传入文件名列表）
  async loadJsonFiles(fileNames: string[], ctx: common.UIAbilityContext): Promise<void> {
    for (let i = 0; i < fileNames.length; i++) {
      const name = fileNames[i];
      try {
        const data = await ctx.resourceManager.getRawFileContent(name);
        const text = new util.TextDecoder('utf-8').decodeWithStream(data);
        const tagsArr: string[] = ['rawfile', 'json'];
        if (name.indexOf('dizhi_') === 0) {
          tagsArr.push('地支');
          tagsArr.push('十二地支');
          const han: string = this.getDizhiHan(name);
          if (han !== '') { tagsArr.push(han); }
          tagsArr.push('干支');
        }
        if (name.indexOf('tiangan_') === 0) {
          tagsArr.push('天干');
          tagsArr.push('十天干');
          const han2: string = this.getTianganHan(name);
          if (han2 !== '') { tagsArr.push(han2); }
          tagsArr.push('干支');
        }
        const item: KBItem = {
          id: name,
          title: name,
          type: 'json',
          tags: tagsArr,
          content: text
        };
        this.items.push(item);
        this.indexItem(item);
      } catch (e) {
        // 忽略加载失败的文件
      }
    }
  }

  // 从 rawfile 下的 md 文档加载（例如 calendar/calendar_data.md）
  async loadMdFiles(fileNames: string[], ctx: common.UIAbilityContext): Promise<void> {
    for (let i = 0; i < fileNames.length; i++) {
      const name = fileNames[i];
      try {
        const data = await ctx.resourceManager.getRawFileContent(name);
        const text = new util.TextDecoder('utf-8').decodeWithStream(data);
        const item: KBItem = {
          id: name,
          title: name,
          type: 'md',
          tags: ['rawfile', 'md'],
          content: text
        };
        this.items.push(item);
        this.indexItem(item);
      } catch (e) {
        // 忽略加载失败的文件
      }
    }
  }

  // 简单关键词检索（支持多关键词；标题/内容/标签任一命中；中文二字分词回退）
  search(keyword: string): KBItem[] {
    const key = keyword.trim();
    if (key === '') {
      return [];
    }
    // 规范化分词：将常见连接符替换为空格，再按空格分割
    let normalized: string = key;
    normalized = normalized.replace('，', ' ');
    normalized = normalized.replace('、', ' ');
    normalized = normalized.replace('与', ' ');
    normalized = normalized.replace('和', ' ');
    normalized = normalized.replace(',', ' ');
    const tokens: string[] = normalized.split(' ');

    const results: KBItem[] = [];
    // 先用索引命中
    const idSet: Set<string> = new Set<string>();
    for (let t = 0; t < tokens.length; t++) {
      const token = tokens[t];
      if (token === '') { continue; }
      const ids = this.tokenIndex.get(token);
      if (ids) {
        for (let k = 0; k < ids.length; k++) {
          idSet.add(ids[k]);
        }
      }
    }
    if (idSet.size > 0) {
      for (let i = 0; i < this.items.length; i++) {
        const it = this.items[i];
        if (idSet.has(it.id)) {
          results.push(it);
        }
      }
    }
    // 若索引未命中，继续扫描匹配
    if (results.length === 0) {
      for (let i = 0; i < this.items.length; i++) {
        const it = this.items[i];
        let matched: boolean = false;
        for (let t = 0; t < tokens.length; t++) {
          const token = tokens[t];
          if (token === '') {
            continue;
          }
          const inTitle = it.title.indexOf(token) >= 0;
          const inContent = it.content.indexOf(token) >= 0;
          let inTags = false;
          for (let j = 0; j < it.tags.length; j++) {
            if (it.tags[j].indexOf(token) >= 0) {
              inTags = true;
              break;
            }
          }
          if (inTitle || inContent || inTags) {
            matched = true;
            break;
          }
        }
        if (matched) {
          results.push(it);
        }
      }
    }

    // 若无命中，进行中文二字分词回退匹配（如“洛书是啥”→“洛书”“书是”“是啥”）
    if (results.length === 0) {
      const grams: string[] = [];
      const len: number = key.length;
      for (let i = 0; i < len - 1; i++) {
        const gram: string = key.substring(i, i + 2);
        // 跳过包含空格或标点的gram
        const hasSpace: boolean = gram.indexOf(' ') >= 0;
        const hasCommaCn: boolean = gram.indexOf('，') >= 0;
        const hasCommaEn: boolean = gram.indexOf(',') >= 0;
        const hasDunhao: boolean = gram.indexOf('、') >= 0;
        if (hasSpace || hasCommaCn || hasCommaEn || hasDunhao) {
          continue;
        }
        grams.push(gram);
      }
      for (let i = 0; i < this.items.length; i++) {
        const it = this.items[i];
        let hit: boolean = false;
        for (let g = 0; g < grams.length; g++) {
          const gram = grams[g];
          const inTitle = it.title.indexOf(gram) >= 0;
          const inContent = it.content.indexOf(gram) >= 0;
          let inTags = false;
          for (let j = 0; j < it.tags.length; j++) {
            if (it.tags[j].indexOf(gram) >= 0) {
              inTags = true;
              break;
            }
          }
          if (inTitle || inContent || inTags) {
            hit = true;
            break;
          }
        }
        if (hit) {
          results.push(it);
        }
      }
    }

    return results;
  }
}
