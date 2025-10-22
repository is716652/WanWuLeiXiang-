import { router } from '@kit.ArkUI';
import { JingFangData, JingFangGuaItem } from '../model/JingFangData';

@Entry
@Component
struct JingFangTablePage {
  @State selectedGong: string = '乾宫';
  @State currentGuaList: JingFangGuaItem[] = [];
  private jingFangData: JingFangData = JingFangData.getInstance();
  private gongList: string[] = [];

  aboutToAppear(): void {
    this.gongList = this.jingFangData.getGongList();
    this.currentGuaList = this.jingFangData.getGuaByGong(this.selectedGong);
  }

  // 切换宫位
  switchGong(gong: string): void {
    this.selectedGong = gong;
    this.currentGuaList = this.jingFangData.getGuaByGong(gong);
  }

  // 获取宫位对应的五行颜色
  getGongColor(gong: string): string {
    const colors: Record<string, string> = {
      '乾宫': '#d4af37',  // 金色
      '兑宫': '#d4af37',  // 金色
      '震宫': '#4a7c59',  // 木色
      '巽宫': '#4a7c59',  // 木色
      '坎宫': '#1e3a8a',  // 水色
      '离宫': '#dc2626',  // 火色
      '艮宫': '#ca8a04',  // 土色
      '坤宫': '#ca8a04'   // 土色
    };
    return colors[gong] || '#666666';
  }

  // 获取爻的阴阳类型（根据卦象推测）
  getYaoType(guaName: string, yaoIndex: number): string {
    // 这里简化处理，返回 "—" 或 "- -"
    // 实际应用中可以根据具体卦象判断
    return "—";
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Button() {
          Text('←')
            .fontSize(24)
            .fontColor('#FFFFFF')
        }
        .width(40)
        .height(40)
        .backgroundColor('rgba(255, 255, 255, 0.1)')
        .borderRadius(20)
        .onClick(() => {
          router.back();
        })

        Text('京房重卦法表格')
          .fontSize(22)
          .fontWeight(600)
          .fontColor('#FFFFFF')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 占位
        Column()
          .width(40)
          .height(40)
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#1a237e')

      // 理论说明卡片
      Column({ space: 10 }) {
        Row({ space: 8 }) {
          Text('📚')
            .fontSize(20)
          Text('重卦法理论')
            .fontSize(16)
            .fontWeight(600)
            .fontColor('#1a237e')
        }

        Text('从本宫卦开始，逐爻变化（阳变阴，阴变阳），经过一世至五世、游魂、归魂，共八卦为一宫。')
          .fontSize(14)
          .fontColor('#666666')
          .lineHeight(22)

        Row({ space: 16 }) {
          Column({ space: 4 }) {
            Text('变化规则')
              .fontSize(13)
              .fontWeight(600)
              .fontColor('#1a237e')
            Text('一至五世：初爻→二爻→三爻→四爻→五爻')
              .fontSize(12)
              .fontColor('#666666')
          }
          .alignItems(HorizontalAlign.Start)

          Column({ space: 4 }) {
            Text('特殊卦')
              .fontSize(13)
              .fontWeight(600)
              .fontColor('#1a237e')
            Text('游魂：四爻回变  归魂：下三爻复原')
              .fontSize(12)
              .fontColor('#666666')
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('92%')
      .padding(16)
      .margin({ top: 16, bottom: 12 })
      .backgroundColor('#E8EAF6')
      .borderRadius(12)

      // 宫位选择器
      Scroll() {
        Row({ space: 10 }) {
          ForEach(this.gongList, (gong: string) => {
            Text(gong)
              .fontSize(15)
              .fontWeight(this.selectedGong === gong ? 600 : 400)
              .fontColor(this.selectedGong === gong ? '#FFFFFF' : this.getGongColor(gong))
              .padding({ left: 16, right: 16, top: 8, bottom: 8 })
              .backgroundColor(this.selectedGong === gong ? this.getGongColor(gong) : '#F5F5F5')
              .borderRadius(20)
              .border({
                width: 2,
                color: this.getGongColor(gong)
              })
              .onClick(() => {
                this.switchGong(gong);
              })
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .width('100%')
      .height(50)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)

      // 表格内容
      Scroll() {
        Column({ space: 0 }) {
          // 表头
          this.TableHeader()

          // 表格行
          ForEach(this.currentGuaList, (item: JingFangGuaItem, index: number) => {
            this.TableRow(item, index)
          })
        }
        .width('100%')
        .margin({ top: 12 })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 12, right: 12, bottom: 16 })
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7FA')
  }

  @Builder
  TableHeader() {
    Row() {
      // 序号
      Text('序号')
        .fontSize(13)
        .fontWeight(700)
        .fontColor('#FFFFFF')
        .width('10%')
        .textAlign(TextAlign.Center)

      // 世次
      Text('世次')
        .fontSize(13)
        .fontWeight(700)
        .fontColor('#FFFFFF')
        .width('15%')
        .textAlign(TextAlign.Center)

      // 卦象
      Text('卦象')
        .fontSize(13)
        .fontWeight(700)
        .fontColor('#FFFFFF')
        .width('10%')
        .textAlign(TextAlign.Center)

      // 卦名
      Text('卦名')
        .fontSize(13)
        .fontWeight(700)
        .fontColor('#FFFFFF')
        .width('20%')
        .textAlign(TextAlign.Center)

      // 世爻
      Text('世爻')
        .fontSize(13)
        .fontWeight(700)
        .fontColor('#FFFFFF')
        .width('13%')
        .textAlign(TextAlign.Center)

      // 应爻
      Text('应爻')
        .fontSize(13)
        .fontWeight(700)
        .fontColor('#FFFFFF')
        .width('13%')
        .textAlign(TextAlign.Center)

      // 简释
      Text('卦变说明')
        .fontSize(13)
        .fontWeight(700)
        .fontColor('#FFFFFF')
        .width('19%')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height(50)
    .backgroundColor(this.getGongColor(this.selectedGong))
    .borderRadius({ topLeft: 12, topRight: 12 })
    .padding({ left: 8, right: 8 })
  }

  @Builder
  TableRow(item: JingFangGuaItem, index: number) {
    Column({ space: 0 }) {
      Row() {
        // 序号
        Text(`${item.序号}`)
          .fontSize(16)
          .fontWeight(700)
          .fontColor(this.getGongColor(item.宫属))
          .width('10%')
          .textAlign(TextAlign.Center)

        // 世次
        Column({ space: 2 }) {
          Text(item.世次)
            .fontSize(13)
            .fontWeight(600)
            .fontColor(this.getShiCiTextColor(item.世次))
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .backgroundColor(this.getShiCiBgColor(item.世次))
            .borderRadius(8)
        }
        .width('15%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

        // 卦象
        Text(item.卦象)
          .fontSize(32)
          .fontWeight(700)
          .fontColor('#1a237e')
          .width('10%')
          .textAlign(TextAlign.Center)

        // 卦名
        Text(item.卦名)
          .fontSize(15)
          .fontWeight(600)
          .fontColor('#1a237e')
          .width('20%')
          .textAlign(TextAlign.Center)

        // 世爻
        Text(item.世爻)
          .fontSize(14)
          .fontWeight(600)
          .fontColor('#1565C0')
          .width('13%')
          .textAlign(TextAlign.Center)

        // 应爻
        Text(item.应爻)
          .fontSize(14)
          .fontWeight(600)
          .fontColor('#2E7D32')
          .width('13%')
          .textAlign(TextAlign.Center)

        // 简释
        Text(item.简释)
          .fontSize(12)
          .fontColor('#666666')
          .width('19%')
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
      .height(70)
      .padding({ left: 8, right: 8 })

      // 分隔线（最后一行不显示）
      if (index < this.currentGuaList.length - 1) {
        Divider()
          .color('#E0E0E0')
          .strokeWidth(1)
      }
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(index === this.currentGuaList.length - 1 ? { bottomLeft: 12, bottomRight: 12 } : 0)
  }

  // 获取世次文字颜色
  getShiCiTextColor(shiCi: string): string {
    if (shiCi === '本宫卦') return '#FFFFFF';
    if (shiCi === '游魂卦') return '#FFFFFF';
    if (shiCi === '归魂卦') return '#FFFFFF';
    return '#FFFFFF';
  }

  // 获取世次背景颜色
  getShiCiBgColor(shiCi: string): string {
    if (shiCi === '本宫卦') return '#1a237e';
    if (shiCi === '游魂卦') return '#C62828';
    if (shiCi === '归魂卦') return '#2E7D32';
    return '#0277BD';
  }
}
