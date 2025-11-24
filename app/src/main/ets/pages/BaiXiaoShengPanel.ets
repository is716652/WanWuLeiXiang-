import { router } from '@kit.ArkUI';
import common from '@ohos.app.ability.common';
import { KnowledgeBase, KBItem } from '../model/KnowledgeBase';
import { AIServiceManager, ModelName } from '../model/AIServiceManager';
import { CombinationAnalyzer } from '../model/CombinationAnalyzer';

@Entry
@Component
struct BaiXiaoShengPanel {
  private kb: KnowledgeBase = KnowledgeBase.getInstance();
  private ai: AIServiceManager = AIServiceManager.getInstance();
  private analyzer: CombinationAnalyzer = CombinationAnalyzer.getInstance();
  @State query: string = '';
  @State modeIndex: number = 0; // 0: 本地 1: 联网
  @State localResults: KBItem[] = [];
  @State aiReply: string = '';
  @State bannerHint: string = '';
  @State hasSearched: boolean = false;

  aboutToAppear(): void {
    // 默认：加载部分 rawfile 下的数据（示例）
    const ctx = getContext(this) as common.UIAbilityContext;
    // 仅示例加载，避免重复加载
    if (this.kb.getCount() === 0) {
      const jsonFiles: string[] = [
        'gua_01_qian.json','gua_64_weiji.json','bagua_qian.json',
        'dizhi_zi.json','dizhi_chou.json','dizhi_yin.json','dizhi_mao.json','dizhi_chen.json','dizhi_si.json','dizhi_wu.json','dizhi_wei.json','dizhi_shen.json','dizhi_you.json','dizhi_xu.json','dizhi_hai.json',
        'tiangan_jia.json','tiangan_yi.json','tiangan_bing.json','tiangan_ding.json','tiangan_wu.json','tiangan_ji.json','tiangan_geng.json','tiangan_xin.json','tiangan_ren.json','tiangan_gui.json',
        'rules/combination_rules.json'
      ];
      const mdFiles: string[] = [
        'calendar/calendar_data.md'
      ];
      // 异步加载
      this.kb.loadJsonFiles(jsonFiles, ctx).then(() => {});
      this.kb.loadMdFiles(mdFiles, ctx).then(() => {});
      const arktsSummary: string = 'ArkTS规范要点：禁止 any/unknown、索引签名、可选链、展开、解构；明确接口与返回类型；传统循环与 Map/Record 替代动态对象。';
      const cliSummary: string = '命令行编译：hvigorw clean assembleHap；ohpm install 管理依赖；codelinter 代码检查；常见路径和故障排除。';
      this.kb.registerExternalDoc('doc_arkts', 'ArkTS开发规范指南.md', arktsSummary, ['doc','规范','ArkTS']);
      this.kb.registerExternalDoc('doc_cli', '鸿蒙命令行编译助手.md', cliSummary, ['doc','编译','hvigorw']);
      const hetu: string = '河图：天地生成之数（生数/成数），天一生水地六成之、地二生火天七成之、天三生木地八成之、地四生金天九成之、天五生土地十成之；用于五行数理与方位关系的基础。';
      this.kb.registerExternalDoc('doc_hetu', '河图简介', hetu, ['河图','五行','数理','先天','生成']);
      const luoshu: string = '洛书：九宫数（后天数理），一北坎水、二西南坤土、三东震木、四西兑金、五中宫土、六北坎水、七南离火、八东南巽木、九西北乾金；用于九宫方位与数理应用。';
      this.kb.registerExternalDoc('doc_luoshu', '洛书简介', luoshu, ['洛书','九宫','后天','方位','数理']);
    }
  }

  // 触发检索
  onSearch(): void {
    if (this.modeIndex === 0) {
      const results: KBItem[] = this.kb.search(this.query);
      const out: KBItem[] = [];
      const trimmed: string = this.query.trim();
      this.hasSearched = true;
      if (trimmed !== '') {
        try {
          const report: KBItem = this.analyzer.analyze(trimmed, this.kb);
          out.push(report);
          this.bannerHint = this.analyzer.getHintFor(trimmed);
        } catch (e) {
          this.bannerHint = '解析异常，已切换为卡片查询，请稍后重试';
        }
      }
      for (let i = 0; i < results.length; i++) {
        const itRes: KBItem = results[i];
        if (itRes.id === 'rules/combination_rules.json') {
          continue;
        }
        out.push(itRes);
      }
      this.localResults = out;
    } else {
      const allowed = this.ai.isQueryAllowed(this.query);
      if (!allowed) {
        this.aiReply = '仅限本项目领域问题（易学/类象/六十四卦/京房/纳音/天干地支/河图洛书/焦氏易林/小成图/指南针等）。';
        return;
      }
      const cfg = this.ai.getConfig();
      if (!cfg.allowInternet) {
        this.aiReply = '当前配置为“本地库优先”，已禁用联网。请在配置页启用联网。';
        return;
      }
      this.ai.askLLM(this.query, '').then((r: string) => {
        this.aiReply = r;
      });
    }
  }

  // UI 配色
  getAccentColor(): string {
    return '#7B1FA2';
  }

  build() {
    Column() {
      // 顶部栏
      Row() {
        Button() {
          Text('←').fontSize(20).fontColor('#FFFFFF')
        }
        .width(36).height(36)
        .backgroundColor('rgba(255,255,255,0.15)')
        .borderRadius(18)
        .onClick(() => { router.back(); })

        Text('百晓生 · 智能体')
          .fontSize(22)
          .fontWeight(600)
          .fontColor('#FFFFFF')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button() {
          Text('⚙').fontSize(18).fontColor('#FFFFFF')
        }
        .width(36).height(36)
        .backgroundColor('rgba(255,255,255,0.15)')
        .borderRadius(18)
        .onClick(() => { router.pushUrl({ url: 'pages/AgentConfigPage' }); })
      }
      .width('100%').height(56)
      .padding({ left: 12, right: 12 })
      .backgroundColor(this.getAccentColor())

      // 模式切换
      Row({ space: 8 }) {
        Button() { Text('本地').fontSize(14) }
          .backgroundColor(this.modeIndex === 0 ? '#1a237e' : '#EEEEEE')
          .fontColor(this.modeIndex === 0 ? '#FFFFFF' : '#333333')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .borderRadius(16)
          .onClick(() => { this.modeIndex = 0; })

        Button() { Text('联网').fontSize(14) }
          .backgroundColor(this.modeIndex === 1 ? '#C62828' : '#EEEEEE')
          .fontColor(this.modeIndex === 1 ? '#FFFFFF' : '#333333')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .borderRadius(16)
          .onClick(() => { this.modeIndex = 1; })
      }
      .padding({ left: 16, right: 16, top: 12 })

      // 查询输入
      Row({ space: 8 }) {
        TextInput({ placeholder: '输入组合或查询（如：子丑寅卯｜甲乙丙丁｜离 坎｜日期 2025-11-22｜乾 错卦）', text: this.query })
          .onChange((v: string) => { this.query = v; this.bannerHint = ''; })
          .layoutWeight(1)
          .height(44)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
        Button() { Text('搜索').fontSize(15) }
          .backgroundColor(this.getAccentColor())
          .fontColor('#FFFFFF')
          .padding({ left: 16, right: 16 })
          .borderRadius(8)
          .onClick(() => { this.onSearch(); })
      }
      .padding({ left: 16, right: 16, top: 8 })

      if (this.bannerHint !== '') {
        Row() {
          Text(this.bannerHint).fontSize(12).fontColor('#0D47A1')
        }
        .padding({ left: 16, right: 16, top: 6 })
      }

      // 引导示例（仅在无查询且无结果时显示）
      if (this.query === '' && this.localResults.length === 0) {
        Row({ space: 8 }) {
          this.InputChip('子丑寅卯')
          this.InputChip('甲乙丙丁')
          this.InputChip('离 坎')
          this.InputChip('日期 2025-11-22')
          this.InputChip('乾 错卦')
        }
        .padding({ left: 16, right: 16, top: 4 })
      }

      // 结果区
      if (this.modeIndex === 0) {
        if (this.localResults.length > 0) {
          List({ space: 8 }) {
            ForEach(this.localResults, (it: KBItem) => {
              ListItem() {
                Column({ space: 6 }) {
                  Text(this.friendlyTitle(it)).fontSize(16).fontWeight(600).fontColor('#1a237e')
                  if (this.friendlyTags(it).length > 0) {
                    Text(this.friendlyTags(it).join(' · ')).fontSize(12).fontColor('#777777')
                  }
                  if (it.type === 'json') {
                    ForEach(this.summarizeJson(it.content), (line: string) => {
                      Text('• ' + line).fontSize(13).fontColor('#333333')
                    })
                  } else {
                    Text(it.content).fontSize(13).fontColor('#333333').maxLines(6)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                }
                .width('100%').padding(12)
                .backgroundColor('#FFFFFF').borderRadius(12)
                .shadow({ radius: 8, color: 'rgba(0,0,0,0.08)', offsetX: 0, offsetY: 2 })
              }
            })
          }
          .layoutWeight(1)
          .padding({ left: 16, right: 16, top: 8, bottom: 16 })
        } else {
          if (this.hasSearched) {
            Column() {
              Text('未找到相关资料').fontSize(16).fontColor('#333333')
              Text('提示：可尝试更短的关键词（如“洛书”、“河图”），或切换到联网模式').fontSize(12).fontColor('#777777').lineHeight(18)
            }
            .layoutWeight(1)
            .padding({ left: 16, right: 16, top: 12 })
          } else {
            // 初始进入不显示空态，Chip引导已在上方展示
          }
        }
      } else {
        Column() {
          Text(this.aiReply).fontSize(14).fontColor('#333333').lineHeight(22)
        }
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 12 })
      }
    }
    .width('100%').height('100%')
    .backgroundColor('#F3F4F6')
  }

  @Builder
  InputChip(text: string) {
    Button() { Text(text).fontSize(12) }
      .backgroundColor('#EEEEEE')
      .fontColor('#333333')
      .padding({ left: 10, right: 10, top: 4, bottom: 4 })
      .borderRadius(14)
      .onClick(() => { this.query = text; this.onSearch(); })
  }

  private summarizeJson(text: string): string[] {
    const cleaned: string = text.replace('{', '').replace('}', '').replace('\n', '').replace('\r', '');
    const parts: string[] = cleaned.split(',');
    const out: string[] = [];
    for (let i = 0; i < parts.length; i++) {
      const seg: string = parts[i];
      const idx: number = seg.indexOf(':');
      if (idx <= 0) { continue; }
      let k: string = seg.substring(0, idx);
      let v: string = seg.substring(idx + 1);
      k = k.replace('"', '').replace('"', '').trim();
      v = v.replace('"', '').replace('"', '').trim();
      if (k !== '' && v !== '') {
        out.push(k + '：' + v);
      }
      if (out.length >= 6) { break; }
    }
    if (out.length === 0) {
      out.push('此卡片为结构化数据，点击进入详细查看');
    }
    return out;
  }

  private friendlyTitle(it: KBItem): string {
    const id: string = it.id;
    if (id.indexOf('gua_') === 0 && id.indexOf('.json') > 0) {
      return '六十四卦 · ' + it.title.replace('.json', '');
    }
    if (id.indexOf('dizhi_') === 0) {
      return '地支 · ' + it.title.replace('.json', '');
    }
    if (id.indexOf('tiangan_') === 0) {
      return '天干 · ' + it.title.replace('.json', '');
    }
    if (id.indexOf('bagua_') === 0) {
      return '八卦 · ' + it.title.replace('.json', '');
    }
    if (id.indexOf('JiaoshiYilin/') >= 0) {
      return '焦氏易林 · ' + it.title.replace('.json', '');
    }
    if (id.indexOf('calendar/') >= 0) {
      return '万年历 · ' + it.title.replace('.json', '').replace('calendar_data', '');
    }
    return it.title.replace('.json', '').replace('.md', '');
  }

  private friendlyTags(it: KBItem): string[] {
    const out: string[] = [];
    for (let i = 0; i < it.tags.length; i++) {
      const t: string = it.tags[i];
      if (t === 'rawfile' || t === 'json' || t === 'md') { continue; }
      if (t === 'doc') { continue; }
      out.push(t);
    }
    return out;
  }
}
