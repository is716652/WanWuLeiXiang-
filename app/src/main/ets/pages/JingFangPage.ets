import { router } from '@kit.ArkUI';
import { JingFangData, JingFangGuaItem } from '../model/JingFangData';

@Entry
@Component
struct JingFangPage {
  @State selectedGong: string = '乾宫';
  @State currentGuaList: JingFangGuaItem[] = [];
  @State searchText: string = '';
  @State showSearch: boolean = false;
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
    this.showSearch = false;
    this.searchText = '';
  }

  // 搜索功能
  onSearchChange(value: string): void {
    this.searchText = value;
    if (value.trim() === '') {
      this.currentGuaList = this.jingFangData.getGuaByGong(this.selectedGong);
    } else {
      this.currentGuaList = this.jingFangData.searchGua(value);
    }
  }

  // 获取宫位对应的颜色
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

  // 获取世次对应的标签颜色
  getShiCiColor(shiCi: string): string {
    if (shiCi === '本宫卦') return '#1a237e';
    if (shiCi === '游魂卦') return '#C62828';
    if (shiCi === '归魂卦') return '#2E7D32';
    return '#0277BD';
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

        Text('京房八宫卦')
          .fontSize(24)
          .fontWeight(600)
          .fontColor('#FFFFFF')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button() {
          Text(this.showSearch ? '✕' : '🔍')
            .fontSize(20)
            .fontColor('#FFFFFF')
        }
        .width(40)
        .height(40)
        .backgroundColor('rgba(255, 255, 255, 0.1)')
        .borderRadius(20)
        .onClick(() => {
          this.showSearch = !this.showSearch;
          if (!this.showSearch) {
            this.searchText = '';
            this.currentGuaList = this.jingFangData.getGuaByGong(this.selectedGong);
          }
        })
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#1a237e')

      // 说明卡片
      Column({ space: 8 }) {
        Row({ space: 8 }) {
          Text('📖')
            .fontSize(20)
          Text('八宫卦体系')
            .fontSize(16)
            .fontWeight(600)
            .fontColor('#1a237e')
        }

        Text('从初爻开始逐爻变化，经过一世至五世、游魂、归魂，共八卦')
          .fontSize(14)
          .fontColor('#666666')
          .lineHeight(22)

        Row({ space: 12 }) {
          Text('世爻：主体')
            .fontSize(13)
            .fontColor('#666666')
          Text('应爻：客体')
            .fontSize(13)
            .fontColor('#666666')
          Text('初四、二五、三上相应')
            .fontSize(13)
            .fontColor('#666666')
        }
        .margin({ top: 4 })
      }
      .width('90%')
      .padding(16)
      .margin({ top: 16, bottom: 12 })
      .backgroundColor('#E3F2FD')
      .borderRadius(12)

      // 搜索框（条件显示）
      if (this.showSearch) {
        Search({
          value: this.searchText,
          placeholder: '搜索卦名、宫位或世次...'
        })
          .width('90%')
          .height(45)
          .margin({ bottom: 12 })
          .backgroundColor('#F5F5F5')
          .onChange((value: string) => {
            this.onSearchChange(value);
          })
      }

      // 宫位选择器（不在搜索模式时显示）
      if (!this.showSearch) {
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
      }

      // 卦列表
      List({ space: 12 }) {
        ForEach(this.currentGuaList, (item: JingFangGuaItem) => {
          ListItem() {
            this.GuaCard(item)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 12, bottom: 16 })
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F0F4F8')
  }

  @Builder
  GuaCard(item: JingFangGuaItem) {
    Column({ space: 0 }) {
      // 顶部：宫位和世次标签
      Row() {
        Text(item.宫属)
          .fontSize(14)
          .fontColor('#FFFFFF')
          .padding({ left: 12, right: 12, top: 4, bottom: 4 })
          .backgroundColor(this.getGongColor(item.宫属))
          .borderRadius(12)

        Blank()

        Text(item.世次)
          .fontSize(14)
          .fontWeight(600)
          .fontColor('#FFFFFF')
          .padding({ left: 12, right: 12, top: 4, bottom: 4 })
          .backgroundColor(this.getShiCiColor(item.世次))
          .borderRadius(12)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })

      // 分隔线
      Divider()
        .color('#E0E0E0')
        .strokeWidth(1)

      // 中间：序号、卦象、卦名
      Row() {
        // 序号
        Text(`${item.序号}`)
          .fontSize(18)
          .fontWeight(700)
          .fontColor('#FFFFFF')
          .width(36)
          .height(36)
          .textAlign(TextAlign.Center)
          .backgroundColor(this.getGongColor(item.宫属))
          .borderRadius(18)

        // 卦象
        Text(item.卦象)
          .fontSize(48)
          .fontWeight(700)
          .fontColor('#1a237e')
          .margin({ left: 16, right: 16 })

        // 卦名和简释
        Column({ space: 6 }) {
          Text(item.卦名)
            .fontSize(20)
            .fontWeight(700)
            .fontColor('#1a237e')

          Text(item.简释)
            .fontSize(13)
            .fontColor('#666666')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })

      // 分隔线
      Divider()
        .color('#E0E0E0')
        .strokeWidth(1)

      // 底部：世爻和应爻
      Row() {
        Column({ space: 6 }) {
          Text('世爻')
            .fontSize(12)
            .fontColor('#999999')

          Text(item.世爻)
            .fontSize(16)
            .fontWeight(600)
            .fontColor('#1a237e')
        }
        .width('50%')
        .alignItems(HorizontalAlign.Center)

        // 垂直分隔线
        Divider()
          .vertical(true)
          .height(40)
          .color('#E0E0E0')
          .strokeWidth(1)

        Column({ space: 6 }) {
          Text('应爻')
            .fontSize(12)
            .fontColor('#999999')

          Text(item.应爻)
            .fontSize(16)
            .fontWeight(600)
            .fontColor('#2E7D32')
        }
        .width('50%')
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .padding({ top: 12, bottom: 12 })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetX: 0,
      offsetY: 2
    })
  }
}
