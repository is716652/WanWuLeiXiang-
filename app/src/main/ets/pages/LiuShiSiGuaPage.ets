import { router } from '@kit.ArkUI';
import { loadLiuShiSiGuaSummary, loadSingleGua } from '../model/LiuShiSiGuaData';
import { LiuShiSiGuaItem, YaoCiEntry, BuJueDetailItem } from '../model/DataTypes';

@Entry
@Component
struct LiuShiSiGuaPage {
  @State guaList: LiuShiSiGuaItem[] = [];
  @State selectedGua: LiuShiSiGuaItem | null = null;
  @State showDetail: boolean = false;
  @State isLoading: boolean = true;
  @State yaoCiList: Array<YaoCiEntry> = [];  // 爻辞列表
  private scroller: Scroller = new Scroller();

  async aboutToAppear() {
    try {
      this.guaList = await loadLiuShiSiGuaSummary();
      this.isLoading = false;
    } catch (error) {
      console.error('加载六十四卦数据失败:', error);
      this.isLoading = false;
    }
  }

  // 拦截系统返回键
  onBackPress(): boolean | void {
    if (this.showDetail) {
      this.showDetail = false;
      this.selectedGua = null;
      return true;
    }
    return false;
  }

  build() {
    Column() {
      // 顶部导航栏
      this.buildHeader();

      // 主内容区域
      if (!this.showDetail) {
        // 六十四卦列表
        this.buildGuaList();
      } else {
        // 详情页
        this.buildDetailView();
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7FA')
  }

  @Builder
  buildHeader() {
    Row() {
      Image($r('sys.symbol.chevron_left'))
        .width(24)
        .height(24)
        .fillColor('#FFFFFF')
        .onClick(() => {
          if (this.showDetail) {
            this.showDetail = false;
            this.selectedGua = null;
          } else {
            router.back();
          }
        })

      Text(this.showDetail && this.selectedGua ? `${this.selectedGua.卦序}. ${this.selectedGua.卦名}卦` : '六十四卦详解')
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#FFFFFF')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Row()
        .width(24)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#F39C12')
  }

  @Builder
  buildGuaList() {
    Column() {
      if (this.isLoading) {
        Text('加载中...')
          .fontSize(16)
          .fontColor('#999')
          .margin({ top: 100 })
      } else {
        Scroll(this.scroller) {
          Column({ space: 12 }) {
            Text('请选择卦象')
              .fontSize(16)
              .fontColor('#7F8C8D')
              .margin({ top: 20, bottom: 8 })

            // 使用Grid布局展示64卦
            GridRow({
              columns: 4,
              gutter: { x: 10, y: 10 }
            }) {
              ForEach(this.guaList, (item: LiuShiSiGuaItem) => {
                GridCol() {
                  this.buildGuaCard(item);
                }
              })
            }
            .width('100%')
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 20 })
        }
        .scrollBar(BarState.Auto)
        .edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1)
      }
    }
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  buildGuaCard(item: LiuShiSiGuaItem) {
    Column({ space: 8 }) {
      // 卦象符号
      Text(item.卦象)
        .fontSize(32)
        .fontColor('#F39C12')

      // 卦序
      Text(`${item.卦序}`)
        .fontSize(12)
        .fontColor('#95A5A6')

      // 卦名
      Text(item.卦名)
        .fontSize(16)
        .fontWeight(600)
        .fontColor('#2C3E50')

      // 吉凶等级
      if (item.吉凶等级) {
        Text(item.吉凶等级)
          .fontSize(11)
          .fontColor(this.getJiXiongColor(item.吉凶等级))
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .backgroundColor(this.getJiXiongBgColor(item.吉凶等级))
          .borderRadius(4)
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({
      radius: 8,
      color: 'rgba(243, 156, 18, 0.1)',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(async () => {
      // 按需加载详细数据
      const detailData = await loadSingleGua(item.卦序);
      if (detailData) {
        this.selectedGua = detailData;
        // 将爻辞详解转换为数组
        this.yaoCiList = Object.entries(detailData.爻辞详解).map((entry): YaoCiEntry => {
          return {
            key: entry[0],
            value: entry[1]
          };
        });
        this.showDetail = true;
      }
    })
  }

  // 获取吉凶颜色
  getJiXiongColor(level: string): string {
    if (level.includes('上上')) return '#27AE60';
    if (level.includes('上')) return '#2ECC71';
    if (level.includes('中上')) return '#3498DB';
    if (level.includes('中中')) return '#F39C12';
    if (level.includes('中下')) return '#E67E22';
    if (level.includes('下')) return '#E74C3C';
    return '#95A5A6';
  }

  // 获取吉凶背景色
  getJiXiongBgColor(level: string): string {
    if (level.includes('上上')) return 'rgba(39, 174, 96, 0.1)';
    if (level.includes('上')) return 'rgba(46, 204, 113, 0.1)';
    if (level.includes('中上')) return 'rgba(52, 152, 219, 0.1)';
    if (level.includes('中中')) return 'rgba(243, 156, 18, 0.1)';
    if (level.includes('中下')) return 'rgba(230, 126, 34, 0.1)';
    if (level.includes('下')) return 'rgba(231, 76, 60, 0.1)';
    return 'rgba(149, 165, 166, 0.1)';
  }

  @Builder
  buildDetailView() {
    Scroll() {
      Column({ space: 20 }) {
        if (this.selectedGua) {
          // 顶部卡片
          this.buildTopCard();

          // 卦辞彖辞象辞
          this.buildGuaCiSection();

          // 详细解释
          this.buildDetailExplain();

          // 卜诀发微
          this.buildBuJueFaWei();

          // 爻辞详解
          this.buildYaoCiDetail();
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 24 })
    }
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1)
  }

  @Builder
  buildTopCard() {
    Column({ space: 16 }) {
      // 卦象和卦名
      Row({ space: 20 }) {
        Text(this.selectedGua ? this.selectedGua.卦象 : '')
          .fontSize(80)
          .fontColor('#F39C12')

        Column({ space: 8 }) {
          Text(`${this.selectedGua?.卦序}. ${this.selectedGua?.卦名}卦`)
            .fontSize(28)
            .fontWeight(700)
            .fontColor('#2C3E50')

          Text(this.selectedGua?.组成 || '')
            .fontSize(14)
            .fontColor('#7F8C8D')

          if (this.selectedGua?.吉凶等级) {
            Text(this.selectedGua.吉凶等级)
              .fontSize(14)
              .fontColor(this.getJiXiongColor(this.selectedGua.吉凶等级))
              .padding({ left: 12, right: 12, top: 4, bottom: 4 })
              .backgroundColor(this.getJiXiongBgColor(this.selectedGua.吉凶等级))
              .borderRadius(8)
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')

      // 基本信息标签
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
        this.buildInfoTag('核心', this.selectedGua?.核心象征 || '')
        this.buildInfoTag('自然', this.selectedGua?.自然象征 || '')
        this.buildInfoTag('人伦', this.selectedGua?.人伦象征 || '')
        this.buildInfoTag('五行', this.selectedGua?.五行属性 || '')
        this.buildInfoTag('动物', this.selectedGua?.动物象征 || '')
        this.buildInfoTag('身体', this.selectedGua?.身体象征 || '')
      }
      .width('100%')
    }
    .width('100%')
    .padding(24)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({
      radius: 16,
      color: 'rgba(243, 156, 18, 0.15)',
      offsetX: 0,
      offsetY: 4
    })
  }

  @Builder
  buildInfoTag(label: string, value: string) {
    Row({ space: 4 }) {
      Text(label + ':')
        .fontSize(12)
        .fontColor('#95A5A6')
      Text(value)
        .fontSize(12)
        .fontColor('#F39C12')
        .fontWeight(500)
    }
    .padding({ left: 10, right: 10, top: 6, bottom: 6 })
    .backgroundColor('rgba(243, 156, 18, 0.08)')
    .borderRadius(8)
    .margin(4)
  }

  @Builder
  buildGuaCiSection() {
    Column({ space: 16 }) {
      // 卦辞
      this.buildTextSection('卦辞', this.selectedGua?.卦辞 || '', '#E74C3C')

      // 彖辞
      this.buildTextSection('彖辞', this.selectedGua?.彖辞 || '', '#3498DB')

      // 象辞
      this.buildTextSection('象辞', this.selectedGua?.象辞 || '', '#27AE60')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  buildTextSection(title: string, content: string, color: string) {
    Column({ space: 10 }) {
      Row() {
        Text('◆')
          .fontSize(14)
          .fontColor(color)
          .margin({ right: 8 })

        Text(title)
          .fontSize(16)
          .fontWeight(600)
          .fontColor('#2C3E50')
      }

      Text(content)
        .fontSize(14)
        .fontColor('#34495E')
        .lineHeight(24)
        .padding({ left: 22 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildDetailExplain() {
    if (this.selectedGua?.详细解释) {
      Column({ space: 12 }) {
        Text('详细解释')
          .fontSize(18)
          .fontWeight(700)
          .fontColor('#F39C12')
          .margin({ bottom: 8 })

        this.buildExplainItem('整体含义', this.selectedGua.详细解释.整体含义)
        this.buildExplainItem('爻象分析', this.selectedGua.详细解释.爻象分析)
        this.buildExplainItem('人生启示', this.selectedGua.详细解释.人生启示)
        this.buildExplainItem('应用领域', this.selectedGua.详细解释.应用领域)
        this.buildExplainItem('吉凶判断', this.selectedGua.详细解释.吉凶判断)
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({
        radius: 8,
        color: 'rgba(0, 0, 0, 0.06)',
        offsetX: 0,
        offsetY: 2
      })
    }
  }

  @Builder
  buildExplainItem(title: string, content: string) {
    Column({ space: 8 }) {
      Text('● ' + title)
        .fontSize(14)
        .fontWeight(600)
        .fontColor('#7F8C8D')

      Text(content)
        .fontSize(14)
        .fontColor('#34495E')
        .lineHeight(22)
        .padding({ left: 16 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildBuJueFaWei() {
    if (this.selectedGua && this.selectedGua.卜诀发微) {
      Column({ space: 12 }) {
        Text('卜诀发微')
          .fontSize(18)
          .fontWeight(700)
          .fontColor('#9C27B0')
          .margin({ bottom: 8 })

        // 卜诀诗
        Column({ space: 8 }) {
          Text('卜诀诗')
            .fontSize(15)
            .fontWeight(600)
            .fontColor('#7F8C8D')

          Text(this.selectedGua.卜诀发微.卜诀诗)
            .fontSize(14)
            .fontColor('#34495E')
            .lineHeight(24)
            .padding(12)
            .width('100%')
            .backgroundColor('#F3E5F5')
            .borderRadius(8)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        // 详细解释
        ForEach(this.selectedGua.卜诀发微.详解, (item: BuJueDetailItem) => {
          this.buildBuJueDetailItem(item.诗句, item.解释);
        })
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({
        radius: 8,
        color: 'rgba(156, 39, 176, 0.1)',
        offsetX: 0,
        offsetY: 2
      })
    }
  }

  @Builder
  buildBuJueDetailItem(shiJu: string, jieShi: string) {
    Column({ space: 8 }) {
      Row({ space: 8 }) {
        Text('◆')
          .fontSize(14)
          .fontColor('#9C27B0')

        Text(shiJu)
          .fontSize(14)
          .fontWeight(600)
          .fontColor('#2C3E50')
          .layoutWeight(1)
      }
      .width('100%')

      Text(jieShi)
        .fontSize(13)
        .fontColor('#7F8C8D')
        .lineHeight(22)
        .padding({ left: 22 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FAFAFA')
    .borderRadius(8)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildYaoCiDetail() {
    if (this.selectedGua?.爻辞详解) {
      Column({ space: 12 }) {
        Text('爻辞详解')
          .fontSize(18)
          .fontWeight(700)
          .fontColor('#F39C12')
          .margin({ bottom: 8 })

        // 遍历爻辞数组
        ForEach(this.yaoCiList, (item: YaoCiEntry) => {
          this.buildYaoCiItem(item.key, item.value);
        })
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({
        radius: 8,
        color: 'rgba(0, 0, 0, 0.06)',
        offsetX: 0,
        offsetY: 2
      })
    }
  }

  @Builder
  buildYaoCiItem(yaoMing: string, content: string) {
    Row({ space: 12 }) {
      Text(yaoMing)
        .fontSize(13)
        .fontColor('#FFFFFF')
        .fontWeight(600)
        .padding({ left: 10, right: 10, top: 6, bottom: 6 })
        .backgroundColor('#F39C12')
        .borderRadius(8)

      Text(content)
        .fontSize(13)
        .fontColor('#34495E')
        .lineHeight(20)
        .layoutWeight(1)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#F8F9FA')
    .borderRadius(8)
    .alignItems(VerticalAlign.Top)
  }
}
