/**
 * 先后天八卦图页面
 * 展示先天八卦图和后天八卦图的详细数据
 */

import router from '@ohos.router';

// 位置接口
interface Position {
  x: number;
  y: number;
}

// 八卦数据接口
interface BaGuaData {
  name: string;           // 卦名
  symbol: string;         // 卦符
  nature: string;         // 属性
  direction: string;      // 方位
  element: string;        // 五行
  family: string;         // 家庭成员
  number: number;         // 洛书数
  trigram: string;        // 三爻
  meaning: string;        // 含义
  color: string;          // 颜色
}

@Entry
@Component
struct XianTianBaGuaPage {
  @State selectedTab: number = 0; // 0: 先天八卦, 1: 后天八卦
  @State selectedGua: BaGuaData | null = null;

  // 先天八卦数据 - 严格按照资料顺序：乾南(上)、兑东南(右上)、离东(右)、震东北(右下)、巽西南(左下)、坎西(左)、艮西北(左上)、坤北(下)
  private xianTianBaGua: BaGuaData[] = [
    {
      name: '乾',
      symbol: '☰',
      nature: '天',
      direction: '南',
      element: '金',
      family: '父',
      number: 1,
      trigram: '☰☰☰',
      meaning: '天行健，君子以自强不息',
      color: '#FFD700'
    },
    {
      name: '兑',
      symbol: '☱',
      nature: '泽',
      direction: '东南',
      element: '金',
      family: '少女',
      number: 2,
      trigram: '☱☱☱',
      meaning: '丽泽，兑，君子以朋友讲习',
      color: '#FF69B4'
    },
    {
      name: '离',
      symbol: '☲',
      nature: '火',
      direction: '东',
      element: '火',
      family: '中女',
      number: 3,
      trigram: '☲☲☲',
      meaning: '明两作，离，大人以继明照于四方',
      color: '#FF4500'
    },
    {
      name: '震',
      symbol: '☳',
      nature: '雷',
      direction: '东北',
      element: '木',
      family: '长男',
      number: 4,
      trigram: '☳☳☳',
      meaning: '洊雷，震，君子以恐惧修省',
      color: '#006400'
    },
    {
      name: '巽',
      symbol: '☴',
      nature: '风',
      direction: '西南',
      element: '木',
      family: '长女',
      number: 5,
      trigram: '☴☴☴',
      meaning: '随风，巽，君子以申命行事',
      color: '#228B22'
    },
    {
      name: '坎',
      symbol: '☵',
      nature: '水',
      direction: '西',
      element: '水',
      family: '中男',
      number: 6,
      trigram: '☵☵☵',
      meaning: '水洊至，习坎，君子以常德行',
      color: '#0000CD'
    },
    {
      name: '艮',
      symbol: '☶',
      nature: '山',
      direction: '西北',
      element: '土',
      family: '少男',
      number: 7,
      trigram: '☶☶☶',
      meaning: '兼山，艮，君子以思不出其位',
      color: '#696969'
    },
    {
      name: '坤',
      symbol: '☷',
      nature: '地',
      direction: '北',
      element: '土',
      family: '母',
      number: 8,
      trigram: '☷☷☷',
      meaning: '地势坤，君子以厚德载物',
      color: '#8B4513'
    }
  ];

  // 后天八卦数据 - 按照传统排列：离南(上)、巽东南(右上)、震东(右)、坤西南(左下)、坎北(下)、乾西北(左上)、兑西(左)、艮东北(右下)
  private houTianBaGua: BaGuaData[] = [
    {
      name: '离',
      symbol: '☲',
      nature: '火',
      direction: '南',
      element: '火',
      family: '中女',
      number: 9,
      trigram: '☲☲☲',
      meaning: '明两作，离，大人以继明照于四方',
      color: '#FF4500'
    },
    {
      name: '巽',
      symbol: '☴',
      nature: '风',
      direction: '东南',
      element: '木',
      family: '长女',
      number: 4,
      trigram: '☴☴☴',
      meaning: '随风，巽，君子以申命行事',
      color: '#228B22'
    },
    {
      name: '震',
      symbol: '☳',
      nature: '雷',
      direction: '东',
      element: '木',
      family: '长男',
      number: 3,
      trigram: '☳☳☳',
      meaning: '洊雷，震，君子以恐惧修省',
      color: '#006400'
    },
    {
      name: '坤',
      symbol: '☷',
      nature: '地',
      direction: '西南',
      element: '土',
      family: '母',
      number: 2,
      trigram: '☷☷☷',
      meaning: '地势坤，君子以厚德载物',
      color: '#8B4513'
    },
    {
      name: '坎',
      symbol: '☵',
      nature: '水',
      direction: '北',
      element: '水',
      family: '中男',
      number: 1,
      trigram: '☵☵☵',
      meaning: '水洊至，习坎，君子以常德行',
      color: '#0000CD'
    },
    {
      name: '乾',
      symbol: '☰',
      nature: '天',
      direction: '西北',
      element: '金',
      family: '父',
      number: 6,
      trigram: '☰☰☰',
      meaning: '天行健，君子以自强不息',
      color: '#FFD700'
    },
    {
      name: '兑',
      symbol: '☱',
      nature: '泽',
      direction: '西',
      element: '金',
      family: '少女',
      number: 7,
      trigram: '☱☱☱',
      meaning: '丽泽，兑，君子以朋友讲习',
      color: '#FF69B4'
    },
    {
      name: '艮',
      symbol: '☶',
      nature: '山',
      direction: '东北',
      element: '土',
      family: '少男',
      number: 8,
      trigram: '☶☶☶',
      meaning: '兼山，艮，君子以思不出其位',
      color: '#696969'
    }
  ];

  aboutToAppear() {
    this.selectedGua = this.xianTianBaGua[0];
  }

  /**
   * 获取当前数据源
   */
  getCurrentData(): BaGuaData[] {
    return this.selectedTab === 0 ? this.xianTianBaGua : this.houTianBaGua;
  }

  /**
   * 创建八卦圆形图
   */
  @Builder
  createBaGuaCircle() {
    Stack() {
      // 背景圆
      Circle({ width: 300, height: 300 })
        .fill('#FFFFFF')
        .stroke('#E0E0E0')
        .strokeWidth(2)



      // 八卦位置
      ForEach(this.getCurrentData(), (gua: BaGuaData, index: number) => {
        Column({ space: 2 }) {
          Text(gua.symbol)
            .fontSize(20)
            .fontColor(gua.color)
            .fontWeight(FontWeight.Bold)

          Text(gua.name)
            .fontSize(12)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)

          Text(gua.direction)
            .fontSize(8)
            .fontColor('#666666')
        }
        .position(this.getGuaPosition(index, this.selectedTab === 0))
        .markAnchor({ x: '50%', y: '50%' }) // 设置锚点为中心
        .onClick(() => {
          this.selectedGua = gua;
        })
      })
    }
    .width(320)
    .height(320)
    .margin(20)
  }

  /**
   * 获取八卦位置 - 使用数学计算确保圆形分布
   */
  getGuaPosition(index: number, isXianTian: boolean): Position {
    const centerX = 160; // 中心X坐标 (320/2)
    const centerY = 160; // 中心Y坐标 (320/2)
    const radius = 110;  // 半径

    // 传统坐标系：上南下北，左东右西（东在左边180°，西在右边0°）
    // 先天八卦严格按照资料：乾南(上270°)、兑东南(上与左之间225°)、离东(左180°)、震东北(左与上之间135°)、巽西南(左与下之间315°)、坎西(右0°)、艮西北(右与上之间45°)、坤北(下90°)
    const xianTianAngles = [270, 225, 180, 135, 315, 0, 45, 90];
    
    // 后天八卦按照传统排列：离南(上270°)、巽东南(上与左之间225°)、震东(左180°)、坤西南(左与下之间315°)、坎北(下90°)、乾西北(右与上之间45°)、兑西(右0°)、艮东北(左与上之间135°)
    const houTianAngles = [270, 225, 180, 315, 90, 45, 0, 135];

    const angles = isXianTian ? xianTianAngles : houTianAngles;
    const angle = (angles[index] * Math.PI) / 180; // 转换为弧度

    const x = centerX + radius * Math.cos(angle);
    const y = centerY + radius * Math.sin(angle);

    return { x: x, y: y };
  }

  /**
   * 创建八卦详情卡片
   */
  @Builder
  createGuaDetailCard() {
    if (this.selectedGua) {
      Column({ space: 16 }) {
        // 标题
        Row() {
          Text(this.selectedGua.symbol)
            .fontSize(32)
            .fontColor(this.selectedGua.color)
            .fontWeight(FontWeight.Bold)

          Column({ space: 4 }) {
            Text(this.selectedGua.name)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')

            Text(this.selectedGua.nature)
              .fontSize(14)
              .fontColor('#666666')
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 12 })
        }
        .alignItems(VerticalAlign.Center)

        // 详细信息
        Column({ space: 12 }) {
          Row({ space: 20 }) {
            Column({ space: 4 }) {
              Text('方位')
                .fontSize(12)
                .fontColor('#999999')
              Text(this.selectedGua.direction)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }

            Column({ space: 4 }) {
              Text('五行')
                .fontSize(12)
                .fontColor('#999999')
              Text(this.selectedGua.element)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }

            Column({ space: 4 }) {
              Text('家庭')
                .fontSize(12)
                .fontColor('#999999')
              Text(this.selectedGua.family)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }

            Column({ space: 4 }) {
              Text('洛书数')
                .fontSize(12)
                .fontColor('#999999')
              Text(this.selectedGua.number.toString())
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)

          Divider()
            .color('#E0E0E0')

          Column({ space: 8 }) {
            Text('卦辞含义')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')

            Text(this.selectedGua.meaning)
              .fontSize(13)
              .fontColor('#666666')
              .lineHeight(18)
              .textAlign(TextAlign.Start)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .padding(16)
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .shadow({
        radius: 8,
        color: '#1A000000',
        offsetX: 0,
        offsetY: 4
      })
    }
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Button('返回')
          .fontSize(16)
          .fontColor('#8E24AA')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            router.back();
          })

        Text('先后天八卦图')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('')
          .width(60)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // 标签切换
      Row({ space: 0 }) {
        Button('先天八卦图')
          .fontSize(14)
          .fontColor(this.selectedTab === 0 ? '#FFFFFF' : '#8E24AA')
          .backgroundColor(this.selectedTab === 0 ? '#8E24AA' : '#F3E5F5')
          .borderRadius(8)
          .height(36)
          .layoutWeight(1)
          .margin({ right: 8 })
          .onClick(() => {
            this.selectedTab = 0;
            this.selectedGua = this.xianTianBaGua[0];
          })

        Button('后天八卦图')
          .fontSize(14)
          .fontColor(this.selectedTab === 1 ? '#FFFFFF' : '#8E24AA')
          .backgroundColor(this.selectedTab === 1 ? '#8E24AA' : '#F3E5F5')
          .borderRadius(8)
          .height(36)
          .layoutWeight(1)
          .margin({ left: 8 })
          .onClick(() => {
            this.selectedTab = 1;
            this.selectedGua = this.houTianBaGua[0];
          })
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')

      // 可滚动内容
      Scroll() {
        Column({ space: 20 }) {
          // 说明文字
          Column({ space: 8 }) {
            Text(this.selectedTab === 0 ? '先天八卦图' : '后天八卦图')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')

            Text(this.selectedTab === 0 ? 
              '伏羲所创，体现宇宙本源秩序，为体' : 
              '文王所创，体现万物生成规律，为用')
              .fontSize(13)
              .fontColor('#666666')
              .textAlign(TextAlign.Center)

            Text('点击卦象可查看详细信息')
              .fontSize(12)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .padding(16)

          // 八卦圆形图
          this.createBaGuaCircle()

          // 卦象详情卡片
          if (this.selectedGua) {
            this.createGuaDetailCard()
          }

          // 理论说明
          Column({ space: 12 }) {
            Text('理论说明')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .textAlign(TextAlign.Start)
              .width('100%')

            if (this.selectedTab === 0) {
              Text('先天八卦，又称伏羲八卦，体现宇宙的本源状态和自然秩序。')
                .fontSize(13)
                .fontColor('#666666')
                .lineHeight(18)
                .textAlign(TextAlign.Start)

              Text('• 乾坤定上下，坎离分左右')
                .fontSize(12)
                .fontColor('#666666')
                .textAlign(TextAlign.Start)
                .width('100%')

              Text('• 震巽居东北西南，艮兑位西北东南')
                .fontSize(12)
                .fontColor('#666666')
                .textAlign(TextAlign.Start)
                .width('100%')

              Text('• 体现"对待之理"，相对而立，阴阳平衡')
                .fontSize(12)
                .fontColor('#666666')
                .textAlign(TextAlign.Start)
                .width('100%')
            } else {
              Text('后天八卦，又称文王八卦，体现万物在时空中运行的规律。')
                .fontSize(13)
                .fontColor('#666666')
                .lineHeight(18)
                .textAlign(TextAlign.Start)

              Text('• 离南坎北，震东兑西')
                .fontSize(12)
                .fontColor('#666666')
                .textAlign(TextAlign.Start)
                .width('100%')

              Text('• 乾坤居西北西南，艮巽位东北东南')
                .fontSize(12)
                .fontColor('#666666')
                .textAlign(TextAlign.Start)
                .width('100%')

              Text('• 体现"流行之理"，顺应时序，生生不息')
                .fontSize(12)
                .fontColor('#666666')
                .textAlign(TextAlign.Start)
                .width('100%')
            }
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#F8F9FA')
          .borderRadius(12)
        }
        .width('100%')
        .padding({ top: 20, bottom: 20 })
      }
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}