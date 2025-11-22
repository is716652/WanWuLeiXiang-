/**
 * 河图洛书页面
 * 展示河图洛书的数理结构和象数关系
 */

import router from '@ohos.router';

@Entry
@Component
struct HeTuLuoShuPage {
  @State currentTab: number = 0; // 0-河图 1-洛书

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Button('返回')
          .fontSize(16)
          .fontColor('#1A237E')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            router.back();
          })

        Text('河图洛书')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button() {
          Text('🤖').fontSize(18).fontColor('#1A237E')
        }
          .width(36).height(36)
          .backgroundColor('rgba(26,35,126,0.06)')
          .borderRadius(18)
          .onClick(() => { router.pushUrl({ url: 'pages/BaiXiaoShengPanel' }); })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // Tab切换
      Row({ space: 0 }) {
        Text('河图')
          .fontSize(16)
          .fontWeight(this.currentTab === 0 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.currentTab === 0 ? '#1A237E' : '#666666')
          .padding(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .backgroundColor(this.currentTab === 0 ? '#E8EAF6' : '#F5F5F5')
          .onClick(() => {
            this.currentTab = 0;
          })

        Text('洛书')
          .fontSize(16)
          .fontWeight(this.currentTab === 1 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.currentTab === 1 ? '#1A237E' : '#666666')
          .padding(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .backgroundColor(this.currentTab === 1 ? '#E8EAF6' : '#F5F5F5')
          .onClick(() => {
            this.currentTab = 1;
          })
      }
      .width('100%')

      // 内容区域
      Scroll() {
        Column() {
          if (this.currentTab === 0) {
            this.buildHeTuContent()
          } else {
            this.buildLuoShuContent()
          }
        }
        .width('100%')
        .padding(20)
      }
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  buildHeTuContent() {
    Column({ space: 20 }) {
      // 河图标题
      Text('河图 - 天地生成之数')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A237E')
        .textAlign(TextAlign.Center)
        .width('100%')

      // 河图说明
      Column({ space: 8 }) {
        Text('河图口诀')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Text('天一生水，地六成之')
          .fontSize(14)
          .fontColor('#666666')

        Text('地二生火，天七成之')
          .fontSize(14)
          .fontColor('#666666')

        Text('天三生木，地八成之')
          .fontSize(14)
          .fontColor('#666666')

        Text('地四生金，天九成之')
          .fontSize(14)
          .fontColor('#666666')

        Text('天五生土，地十成之')
          .fontSize(14)
          .fontColor('#666666')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFF9C4')
      .borderRadius(12)

      // 河图数理结构
      Column({ space: 8 }) {
        Text('河图数理结构')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Text('（十字+中心结构，非九宫格）')
          .fontSize(12)
          .fontColor('#999999')

        // 河图图形展示（十字结构）
        Column({ space: 4 }) {
          // 上方：南方火（二生、七成）
          Column({ space: 2 }) {
            this.buildHeTuCell('七', '火成', '#FF6B6B', 70)
            this.buildHeTuCell('二', '火生', '#FF8A80', 70)
          }

          // 中间横排：木、土、金
          Row({ space: 4 }) {
            // 左：东方木（三生、八成）
            Column({ space: 2 }) {
              this.buildHeTuCell('八', '木成', '#66BB6A', 70)
              this.buildHeTuCell('三', '木生', '#81C784', 70)
            }

            // 中：中央土（五生、十成）
            Column({ space: 2 }) {
              this.buildHeTuCell('十', '土成', '#FFA726', 70)
              this.buildHeTuCell('五', '土生', '#FFD54F', 70)
            }

            // 右：西方金（四生、九成）
            Column({ space: 2 }) {
              this.buildHeTuCell('九', '金成', '#BDBDBD', 70)
              this.buildHeTuCell('四', '金生', '#E0E0E0', 70)
            }
          }
          .justifyContent(FlexAlign.Center)

          // 下方：北方水（一生、六成）
          Column({ space: 2 }) {
            this.buildHeTuCell('一', '水生', '#42A5F5', 70)
            this.buildHeTuCell('六', '水成', '#1976D2', 70)
          }
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
      }
      .width('100%')

      // 河图五行配置
      Column({ space: 12 }) {
        Text('河图五行配置')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        this.buildWuXingItem('北方', '水', '一六', '坎', '#42A5F5')
        this.buildWuXingItem('南方', '火', '二七', '离', '#FF6B6B')
        this.buildWuXingItem('东方', '木', '三八', '震巽', '#81C784')
        this.buildWuXingItem('西方', '金', '四九', '兑乾', '#E0E0E0')
        this.buildWuXingItem('中央', '土', '五十', '中宫', '#FFD54F')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)

      // 河图原理说明
      Column({ space: 8 }) {
        Text('河图象数原理')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Text('• 生数：1, 2, 3, 4, 5 （奇数为天，偶数为地）')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')

        Text('• 成数：6, 7, 8, 9, 10 （生数+5）')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')

        Text('• 天数之和：1+3+5+7+9 = 25')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')

        Text('• 地数之和：2+4+6+8+10 = 30')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')

        Text('• 天地之数：25+30 = 55（大衍之数）')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')

        Text('• 方位对应：水北火南，木东金西，土中')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#E3F2FD')
      .borderRadius(12)
    }
  }

  @Builder
  buildLuoShuContent() {
    Column({ space: 20 }) {
      // 洛书标题
      Text('洛书 - 九宫数理')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A237E')
        .textAlign(TextAlign.Center)
        .width('100%')

      // 洛书口诀
      Column({ space: 8 }) {
        Text('洛书口诀')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Text('戴九履一，左三右七')
          .fontSize(14)
          .fontColor('#666666')

        Text('二四为肩，六八为足')
          .fontSize(14)
          .fontColor('#666666')

        Text('五居中央，纵横皆十五')
          .fontSize(14)
          .fontColor('#666666')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFE0B2')
      .borderRadius(12)

      // 洛书九宫图
      Column({ space: 8 }) {
        Text('洛书九宫数理')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        // 洛书3x3宫格
        Column({ space: 4 }) {
          // 第一行：4 9 2
          Row({ space: 4 }) {
            this.buildLuoShuCell('四', '巽', '东南', '#81C784')
            this.buildLuoShuCell('九', '离', '正南', '#FF6B6B')
            this.buildLuoShuCell('二', '坤', '西南', '#FFD54F')
          }
          .justifyContent(FlexAlign.Center)

          // 第二行：3 5 7
          Row({ space: 4 }) {
            this.buildLuoShuCell('三', '震', '正东', '#66BB6A')
            this.buildLuoShuCell('五', '中', '中宫', '#FFA726')
            this.buildLuoShuCell('七', '兑', '正西', '#E0E0E0')
          }
          .justifyContent(FlexAlign.Center)

          // 第三行：8 1 6
          Row({ space: 4 }) {
            this.buildLuoShuCell('八', '艮', '东北', '#BDBDBD')
            this.buildLuoShuCell('一', '坎', '正北', '#42A5F5')
            this.buildLuoShuCell('六', '乾', '西北', '#9E9E9E')
          }
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
      }
      .width('100%')

      // 洛书配置表
      Column({ space: 12 }) {
        Text('洛书九宫配置')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        this.buildLuoShuConfig('一宫', '坎', '正北', '水', '#42A5F5')
        this.buildLuoShuConfig('二宫', '坤', '西南', '土', '#FFD54F')
        this.buildLuoShuConfig('三宫', '震', '正东', '木', '#66BB6A')
        this.buildLuoShuConfig('四宫', '巽', '东南', '木', '#81C784')
        this.buildLuoShuConfig('五宫', '中', '中宫', '土', '#FFA726')
        this.buildLuoShuConfig('六宫', '乾', '西北', '金', '#9E9E9E')
        this.buildLuoShuConfig('七宫', '兑', '正西', '金', '#E0E0E0')
        this.buildLuoShuConfig('八宫', '艮', '东北', '土', '#BDBDBD')
        this.buildLuoShuConfig('九宫', '离', '正南', '火', '#FF6B6B')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)

      // 洛书特点说明
      Column({ space: 8 }) {
        Text('洛书数理特点')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Text('• 纵横斜和：任意一条线三数之和均为15')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')

        Text('• 奇偶排列：四角为偶（2,4,6,8），四正为奇（1,3,7,9）')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')

        Text('• 对宫之和：相对两宫数字之和为10（如1+9=10）')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')

        Text('• 中央为5：五居中央，土德中和')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')

        Text('• 后天八卦：洛书配后天八卦方位')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')

        Text('• 应用广泛：奇门遁甲、九宫飞星、玄空风水等')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F3E5F5')
      .borderRadius(12)
    }
  }

  // 河图单元格
  @Builder
  buildHeTuCell(number: string, label: string, color: string, size: number) {
    Column({ space: 4 }) {
      Text(number)
        .fontSize(size === 80 ? 28 : 20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')

      Text(label)
        .fontSize(size === 80 ? 12 : 10)
        .fontColor('#FFFFFF')
    }
    .width(size)
    .height(size)
    .backgroundColor(color)
    .borderRadius(8)
    .justifyContent(FlexAlign.Center)
  }

  // 洛书单元格
  @Builder
  buildLuoShuCell(number: string, gua: string, direction: string, color: string) {
    Column({ space: 6 }) {
      Text(number)
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')

      Text(gua)
        .fontSize(14)
        .fontColor('#FFFFFF')

      Text(direction)
        .fontSize(10)
        .fontColor('rgba(255, 255, 255, 0.8)')
    }
    .width(90)
    .height(90)
    .backgroundColor(color)
    .borderRadius(8)
    .justifyContent(FlexAlign.Center)
  }

  // 河图五行条目
  @Builder
  buildWuXingItem(direction: string, element: string, numbers: string, gua: string, color: string) {
    Row({ space: 12 }) {
      Text(direction)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width(50)

      Column() {
        Row() {
          Text('')
            .width(20)
            .height(20)
            .backgroundColor(color)
            .borderRadius(4)
        }
      }
      .width(30)
      .alignItems(HorizontalAlign.Center)

      Text(element)
        .fontSize(14)
        .fontColor('#666666')
        .width(40)

      Text(`数：${numbers}`)
        .fontSize(14)
        .fontColor('#666666')
        .width(70)

      Text(`卦：${gua}`)
        .fontSize(14)
        .fontColor('#666666')
        .layoutWeight(1)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#F8F9FA')
    .borderRadius(8)
  }

  // 洛书配置条目
  @Builder
  buildLuoShuConfig(gong: string, gua: string, direction: string, element: string, color: string) {
    Row({ space: 12 }) {
      Text(gong)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width(50)

      Column() {
        Row() {
          Text('')
            .width(20)
            .height(20)
            .backgroundColor(color)
            .borderRadius(4)
        }
      }
      .width(30)
      .alignItems(HorizontalAlign.Center)

      Text(gua)
        .fontSize(14)
        .fontColor('#666666')
        .width(40)

      Text(direction)
        .fontSize(14)
        .fontColor('#666666')
        .width(60)

      Text(`五行：${element}`)
        .fontSize(14)
        .fontColor('#666666')
        .layoutWeight(1)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#F8F9FA')
    .borderRadius(8)
  }
}
