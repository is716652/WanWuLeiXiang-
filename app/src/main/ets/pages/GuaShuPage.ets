import { router } from '@kit.ArkUI';
import { GuaShuData, GuaShuItem } from '../model/GuaShuData';

@Entry
@Component
struct GuaShuPage {
  @State guaShuList: GuaShuItem[] = [];
  @State searchText: string = '';
  @State filteredList: GuaShuItem[] = [];
  private guaShuData: GuaShuData = GuaShuData.getInstance();

  aboutToAppear(): void {
    this.guaShuList = this.guaShuData.getGuaShuList();
    this.filteredList = this.guaShuList;
  }

  // 搜索功能
  onSearchChange(value: string): void {
    this.searchText = value;
    if (value.trim() === '') {
      this.filteredList = this.guaShuList;
    } else {
      this.filteredList = this.guaShuData.searchGuaShu(value);
    }
  }

  // 获取卦数对应的八卦名称
  getGuaName(number: number): string {
    const guaNames: Record<number, string> = {
      1: '乾', 2: '兑', 3: '离', 4: '震',
      5: '巽', 6: '坎', 7: '艮', 8: '坤'
    };
    return guaNames[number] || '';
  }

  // 获取卦数对应的颜色
  getGuaColor(number: number): string {
    const colors: Record<number, string> = {
      1: '#FFD700', // 乾-金色
      2: '#E8E8E8', // 兑-银白
      3: '#FF6B6B', // 离-红色
      4: '#4ECDC4', // 震-青色
      5: '#95E1D3', // 巽-绿色
      6: '#3498DB', // 坎-蓝色
      7: '#F39C12', // 艮-黄色
      8: '#8B4513'  // 坤-褐色
    };
    return colors[number] || '#CCCCCC';
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

        Text('六十四卦卦数图')
          .fontSize(24)
          .fontWeight(600)
          .fontColor('#FFFFFF')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 40 })
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#1a237e')

      // 说明卡片
      Column({ space: 8 }) {
        Row({ space: 8 }) {
          Text('📊')
            .fontSize(20)
          Text('先天八卦数')
            .fontSize(16)
            .fontWeight(600)
            .fontColor('#1a237e')
        }

        Text('乾1  兑2  离3  震4  巽5  坎6  艮7  坤8')
          .fontSize(14)
          .fontColor('#666666')
          .lineHeight(22)
          .margin({ top: 4 })
      }
      .width('90%')
      .padding(16)
      .margin({ top: 16, bottom: 8 })
      .backgroundColor('#E3F2FD')
      .borderRadius(12)

      // 搜索框
      Search({
        value: this.searchText,
        placeholder: '搜索卦名或简义...'
      })
        .width('90%')
        .height(45)
        .margin({ top: 8, bottom: 16 })
        .backgroundColor('#F5F5F5')
        .onChange((value: string) => {
          this.onSearchChange(value);
        })

      // 卦数列表
      List({ space: 12 }) {
        ForEach(this.filteredList, (item: GuaShuItem) => {
          ListItem() {
            this.GuaShuCard(item)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, bottom: 16 })
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F0F4F8')
  }

  @Builder
  GuaShuCard(item: GuaShuItem) {
    Column({ space: 0 }) {
      // 顶部：序号和卦象
      Row() {
        // 序号
        Text(`${item.序号}`)
          .fontSize(18)
          .fontWeight(700)
          .fontColor('#FFFFFF')
          .width(40)
          .height(40)
          .textAlign(TextAlign.Center)
          .backgroundColor('#1a237e')
          .borderRadius(20)

        // 卦象
        Text(item.卦象)
          .fontSize(48)
          .fontWeight(700)
          .fontColor('#1a237e')
          .margin({ left: 16 })

        Blank()

        // 卦名
        Column({ space: 4 }) {
          Text(item.卦名)
            .fontSize(20)
            .fontWeight(700)
            .fontColor('#1a237e')
        }
        .alignItems(HorizontalAlign.End)
      }
      .width('100%')
      .padding(16)

      // 分隔线
      Divider()
        .color('#E0E0E0')
        .strokeWidth(1)

      // 中间：卦数信息
      Row({ space: 20 }) {
        // 上卦
        Column({ space: 8 }) {
          Text('上卦')
            .fontSize(14)
            .fontColor('#666666')

          Row({ space: 8 }) {
            Text(this.getGuaName(item.上卦数))
              .fontSize(18)
              .fontWeight(600)
              .fontColor('#FFFFFF')
              .width(40)
              .height(40)
              .textAlign(TextAlign.Center)
              .backgroundColor(this.getGuaColor(item.上卦数))
              .borderRadius(20)

            Text(`${item.上卦数}`)
              .fontSize(24)
              .fontWeight(700)
              .fontColor(this.getGuaColor(item.上卦数))
          }
        }

        // 分隔符
        Text('—')
          .fontSize(24)
          .fontColor('#CCCCCC')
          .margin({ top: 20 })

        // 下卦
        Column({ space: 8 }) {
          Text('下卦')
            .fontSize(14)
            .fontColor('#666666')

          Row({ space: 8 }) {
            Text(this.getGuaName(item.下卦数))
              .fontSize(18)
              .fontWeight(600)
              .fontColor('#FFFFFF')
              .width(40)
              .height(40)
              .textAlign(TextAlign.Center)
              .backgroundColor(this.getGuaColor(item.下卦数))
              .borderRadius(20)

            Text(`${item.下卦数}`)
              .fontSize(24)
              .fontWeight(700)
              .fontColor(this.getGuaColor(item.下卦数))
          }
        }

        Blank()

        // 卦数组合
        Column({ space: 4 }) {
          Text('卦数')
            .fontSize(12)
            .fontColor('#999999')

          Text(`(${item.上卦数}, ${item.下卦数})`)
            .fontSize(20)
            .fontWeight(600)
            .fontColor('#1a237e')
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })

      // 分隔线
      Divider()
        .color('#E0E0E0')
        .strokeWidth(1)

      // 底部：简义
      Row({ space: 8 }) {
        Text('简义')
          .fontSize(14)
          .fontColor('#999999')
          .width(50)

        Text(item.简义)
          .fontSize(15)
          .fontColor('#333333')
          .lineHeight(22)
          .layoutWeight(1)
      }
      .width('100%')
      .padding(16)
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
