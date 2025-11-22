import { AIServiceManager, ModelName } from '../model/AIServiceManager';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct AgentConfigPage {
  private ai: AIServiceManager = AIServiceManager.getInstance();
  @State selected: ModelName = 'DeepSeek';
  @State deepseekKey: string = '';
  @State qwenKey: string = '';
  @State doubaoKey: string = '';
  @State minimaxKey: string = '';
  @State allowInternet: boolean = false;

  aboutToAppear(): void {
    const cfg = this.ai.getConfig();
    this.selected = cfg.selectedModel;
    this.deepseekKey = cfg.deepseekKey;
    this.qwenKey = cfg.qwenKey;
    this.doubaoKey = cfg.doubaoKey;
    this.minimaxKey = cfg.minimaxKey;
    this.allowInternet = cfg.allowInternet;
  }

  save(): void {
    this.ai.updateConfig({
      selectedModel: this.selected,
      deepseekKey: this.deepseekKey,
      qwenKey: this.qwenKey,
      doubaoKey: this.doubaoKey,
      minimaxKey: this.minimaxKey,
      allowInternet: this.allowInternet
    });
    router.back();
  }

  build() {
    Column() {
      // 顶部标题
      Row() {
        Button() { Text('←').fontSize(20).fontColor('#FFFFFF') }
          .width(36).height(36)
          .backgroundColor('rgba(255,255,255,0.15)')
          .borderRadius(18)
          .onClick(() => { router.back(); })
        Text('AI 增强配置')
          .fontSize(22).fontWeight(600).fontColor('#FFFFFF')
          .layoutWeight(1).textAlign(TextAlign.Center)
        // 占位
        Blank().width(36).height(36)
      }
      .width('100%').height(56)
      .padding({ left: 12, right: 12 })
      .backgroundColor('#7B1FA2')

      // 模型选择
      Column({ space: 8 }) {
        Text('选择模型').fontSize(14).fontColor('#666666')
        Row({ space: 8 }) {
          this.ModelChip('DeepSeek')
          this.ModelChip('Qwen')
          this.ModelChip('Doubao')
          this.ModelChip('MiniMax')
        }
      }
      .width('92%').padding(12).margin({ top: 12 })

      // API Keys
      Column({ space: 12 }) {
        Text('API Keys').fontSize(14).fontColor('#666666')
        this.KeyInput('DeepSeek Key', this.deepseekKey, (v: string) => { this.deepseekKey = v; })
        this.KeyInput('Qwen Key', this.qwenKey, (v: string) => { this.qwenKey = v; })
        this.KeyInput('Doubao Key', this.doubaoKey, (v: string) => { this.doubaoKey = v; })
        this.KeyInput('MiniMax Key', this.minimaxKey, (v: string) => { this.minimaxKey = v; })
      }
      .width('92%').padding(12)

      // 联网策略
      Column({ space: 8 }) {
        Text('联网策略').fontSize(14).fontColor('#666666')
        Row({ space: 8 }) {
          Button() { Text(this.allowInternet ? '已开启' : '已关闭').fontSize(13) }
            .backgroundColor(this.allowInternet ? '#E8F5E9' : '#FFEBEE')
            .fontColor(this.allowInternet ? '#2E7D32' : '#C62828')
            .padding({ left: 10, right: 10, top: 4, bottom: 4 })
            .borderRadius(12)
            .onClick(() => { this.allowInternet = !this.allowInternet; })
          Text(this.allowInternet ? '允许联网（本地优先）' : '禁用联网（仅本地）')
            .fontSize(13).fontColor('#333333')
        }
      }
      .width('92%').padding(12)

      // 保存按钮
      Button() { Text('保存配置').fontSize(16).fontColor('#FFFFFF') }
        .width('92%').padding({ top: 12, bottom: 12 })
        .backgroundColor('#7B1FA2').borderRadius(8)
        .margin({ top: 8, bottom: 24 })
        .onClick(() => { this.save(); })
    }
    .width('100%').height('100%').backgroundColor('#F5F7FA')
  }

  @Builder
  ModelChip(name: ModelName) {
    Button() { Text(name).fontSize(13) }
      .backgroundColor(this.selected === name ? '#1a237e' : '#EEEEEE')
      .fontColor(this.selected === name ? '#FFFFFF' : '#333333')
      .padding({ left: 12, right: 12, top: 6, bottom: 6 })
      .borderRadius(16)
      .onClick(() => { this.selected = name; })
  }

  @Builder
  KeyInput(label: string, value: string, onChange: (v: string) => void) {
    Column({ space: 6 }) {
      Text(label).fontSize(12).fontColor('#777777')
      TextInput({ text: value, placeholder: '输入 ' + label })
        .height(40).backgroundColor('#FFFFFF')
        .borderRadius(8)
        .onChange((v: string) => { onChange(v); })
    }
    .width('100%')
  }
}
