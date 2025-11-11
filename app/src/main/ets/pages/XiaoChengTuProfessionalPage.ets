import { router } from '@kit.ArkUI';
import { XiaoChengTuUtil, XiaoChengTuResult } from '../model/XiaoChengTuData';
import {
  XiaoChengTuProfessional,
  ZhuangGuaResult,
  SiXiangResult,
  YongShenPosition,
  SiXiangType
} from '../model/XiaoChengTuProfessional';

@Entry
@Component
struct XiaoChengTuProfessionalPage {
  @State currentResult: XiaoChengTuResult | null = null;
  @State zhuangGuaResult: ZhuangGuaResult | null = null;
  @State siXiangResult: SiXiangResult | null = null;
  @State yongShenMap: Map<string, YongShenPosition> | null = null;
  @State detailedAnalysis: string = '';
  @State showResult: boolean = false;

  private professional: XiaoChengTuProfessional = new XiaoChengTuProfessional();

  aboutToAppear(): void {
    // 自动进行时间起卦
    this.performProfessionalQiGua();
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Button() {
          Text('← 返回')
            .fontSize(18)
            .fontColor('#FFFFFF')
        }
        .type(ButtonType.Normal)
        .backgroundColor('rgba(255, 255, 255, 0.1)')
        .onClick(() => {
          router.back();
        })

        Text('小成图专业预测')
          .fontSize(24)
          .fontWeight(600)
          .fontColor('#FFD700')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank()
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor('rgba(0, 0, 0, 0.3)')

      Scroll() {
        Column({ space: 24 }) {
          // 说明卡片
          this.buildIntroCard()

          // 起卦按钮
          Button('开始专业起卦')
            .width('60%')
            .height(50)
            .fontSize(18)
            .fontWeight(600)
            .fontColor('#000000')
            .backgroundColor('#FFD700')
            .borderRadius(25)
            .onClick(() => {
              this.performProfessionalQiGua();
            })

          // 结果展示
          if (this.showResult && this.currentResult && this.zhuangGuaResult) {
            this.buildBasicResult()
            this.buildFourPanDisplay()
            this.buildSiXiangDisplay()
            this.buildYongShenDisplay()
            this.buildDetailedAnalysis()
          }
        }
        .width('100%')
        .padding(20)
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      angle: 135,
      colors: [
        ['#1a1a2e', 0.0],
        ['#16213e', 0.5],
        ['#0f3460', 1.0]
      ]
    })
  }

  @Builder
  buildIntroCard() {
    Column({ space: 16 }) {
      Text('🔮 小成图专业预测系统')
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#FFD700')

      Text(`小成图专业预测包含：
• 装卦系统：天盘、地盘、人盘、神盘
• 四象占法：吉凶生克分析
• 用神取用：精准定位预测对象
• 专业断事：父母、子女、婚姻、事业、财运等`)
        .fontSize(14)
        .fontColor('rgba(255, 255, 255, 0.9)')
        .lineHeight(22)
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 215, 0, 0.1)')
    .borderRadius(12)
    .borderWidth(1)
    .borderColor('rgba(255, 215, 0, 0.3)')
  }

  @Builder
  buildBasicResult() {
    if (this.currentResult) {
      Column({ space: 16 }) {
      Text('📿 基础卦象')
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#FFD700')

      Row({ space: 20 }) {
        Column({ space: 8 }) {
          Text('上卦')
            .fontSize(14)
            .fontColor('rgba(255, 255, 255, 0.7)')
          Text(this.currentResult.上卦.符号)
            .fontSize(48)
            .fontColor('#FFD700')
          Text(this.currentResult.上卦.名称)
            .fontSize(18)
            .fontWeight(600)
            .fontColor('#FFFFFF')
        }

        Column({ space: 8 }) {
          Text('重卦')
            .fontSize(14)
            .fontColor('rgba(255, 255, 255, 0.7)')
          Text(this.currentResult.重卦.符号)
            .fontSize(56)
            .fontColor('#FFD700')
          Text(this.currentResult.重卦.名称)
            .fontSize(20)
            .fontWeight(600)
            .fontColor('#FFFFFF')
        }

        Column({ space: 8 }) {
          Text('下卦')
            .fontSize(14)
            .fontColor('rgba(255, 255, 255, 0.7)')
          Text(this.currentResult.下卦.符号)
            .fontSize(48)
            .fontColor('#FFD700')
          Text(this.currentResult.下卦.名称)
            .fontSize(18)
            .fontWeight(600)
            .fontColor('#FFFFFF')
        }
      }
      .justifyContent(FlexAlign.SpaceAround)
      .width('100%')
      }
      .width('100%')
      .padding(20)
      .backgroundColor('rgba(255, 255, 255, 0.05)')
      .borderRadius(12)
    }
  }

  @Builder
  buildFourPanDisplay() {
    if (this.zhuangGuaResult) {
      Column({ space: 16 }) {
      Text('🎯 四盘数据')
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#FFD700')

      // 天盘
      this.buildSinglePan('天盘（上卦）', this.zhuangGuaResult.tianPan, '#FF6B6B')
      
      // 地盘
      this.buildSinglePan('地盘（下卦）', this.zhuangGuaResult.diPan, '#4ECDC4')
      
      // 人盘
      this.buildSinglePan('人盘（天地合）', this.zhuangGuaResult.renPan, '#95E1D3')
      
      // 神盘
      this.buildSinglePan('神盘（归藏）', this.zhuangGuaResult.shenPan, '#F38181')
      }
      .width('100%')
      .padding(20)
      .backgroundColor('rgba(255, 255, 255, 0.05)')
      .borderRadius(12)
    }
  }

  @Builder
  buildSinglePan(title: string, panData: Map<string, string>, color: string) {
    Column({ space: 12 }) {
      Text(title)
        .fontSize(16)
        .fontWeight(600)
        .fontColor(color)

      Grid() {
        GridItem() {
          this.buildPanCell('乾', panData.get('乾') || '-')
        }
        GridItem() {
          this.buildPanCell('坤', panData.get('坤') || '-')
        }
        GridItem() {
          this.buildPanCell('震', panData.get('震') || '-')
        }
        GridItem() {
          this.buildPanCell('巽', panData.get('巽') || '-')
        }
        GridItem() {
          this.buildPanCell('坎', panData.get('坎') || '-')
        }
        GridItem() {
          this.buildPanCell('离', panData.get('离') || '-')
        }
        GridItem() {
          this.buildPanCell('艮', panData.get('艮') || '-')
        }
        GridItem() {
          this.buildPanCell('兑', panData.get('兑') || '-')
        }
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .rowsGap(8)
      .columnsGap(8)
      .height(120)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('rgba(255, 255, 255, 0.03)')
    .borderRadius(8)
  }

  @Builder
  buildPanCell(position: string, gua: string) {
    Column({ space: 4 }) {
      Text(position)
        .fontSize(12)
        .fontColor('rgba(255, 255, 255, 0.6)')
      Text(gua)
        .fontSize(14)
        .fontWeight(600)
        .fontColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgba(255, 215, 0, 0.1)')
    .borderRadius(6)
  }

  @Builder
  buildSiXiangDisplay() {
    if (this.siXiangResult) {
      Column({ space: 16 }) {
      Text('☯ 四象占法')
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#FFD700')

      Grid() {
        GridItem() {
          this.buildSiXiangItem('父母', this.siXiangResult.父母)
        }
        GridItem() {
          this.buildSiXiangItem('子女', this.siXiangResult.子女)
        }
        GridItem() {
          this.buildSiXiangItem('婚姻', this.siXiangResult.婚姻)
        }
        GridItem() {
          this.buildSiXiangItem('事业', this.siXiangResult.事业)
        }
        GridItem() {
          this.buildSiXiangItem('财运', this.siXiangResult.财运)
        }
        GridItem() {
          this.buildSiXiangItem('健康', this.siXiangResult.健康)
        }
        GridItem() {
          this.buildSiXiangItem('阳宅', this.siXiangResult.阳宅)
        }
        GridItem() {
          this.buildSiXiangItem('阴宅', this.siXiangResult.阴宅)
        }
      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .rowsGap(12)
      .columnsGap(12)
      .height(300)
      }
      .width('100%')
      .padding(20)
      .backgroundColor('rgba(255, 255, 255, 0.05)')
      .borderRadius(12)
    }
  }

  @Builder
  buildSiXiangItem(name: string, type: SiXiangType) {
    Column({ space: 8 }) {
      Text(name)
        .fontSize(14)
        .fontColor('rgba(255, 255, 255, 0.8)')
      Text(type)
        .fontSize(18)
        .fontWeight(600)
        .fontColor(this.getSiXiangColor(type))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgba(255, 215, 0, 0.08)')
    .borderRadius(8)
    .borderWidth(1)
    .borderColor(this.getSiXiangColor(type))
  }

  @Builder
  buildYongShenDisplay() {
    if (this.yongShenMap) {
      Column({ space: 16 }) {
        Text('🎭 用神分析')
          .fontSize(20)
          .fontWeight(600)
          .fontColor('#FFD700')

        Column({ space: 12 }) {
          this.buildYongShenItem('父亲', this.yongShenMap.get('父亲'))
          this.buildYongShenItem('母亲', this.yongShenMap.get('母亲'))
          this.buildYongShenItem('子女', this.yongShenMap.get('子女'))
          this.buildYongShenItem('婚姻', this.yongShenMap.get('婚姻'))
        }
      }
      .width('100%')
      .padding(20)
      .backgroundColor('rgba(255, 255, 255, 0.05)')
      .borderRadius(12)
    }
  }

  @Builder
  buildYongShenItem(name: string, pos: YongShenPosition | undefined) {
    if (pos) {
      Row({ space: 12 }) {
        Text(name)
          .fontSize(14)
          .fontColor('rgba(255, 255, 255, 0.7)')
          .width(60)

        Text(`${pos.宫位}宫`)
          .fontSize(14)
          .fontColor('#FFD700')
          .width(60)

        Text(`→ ${pos.落宫}`)
          .fontSize(14)
          .fontColor('#FFFFFF')
          .layoutWeight(1)

        Text(pos.四象)
          .fontSize(14)
          .fontWeight(600)
          .fontColor(this.getSiXiangColor(pos.四象))
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor('rgba(255, 215, 0, 0.1)')
          .borderRadius(4)
      }
      .width('100%')
      .padding(12)
      .backgroundColor('rgba(255, 255, 255, 0.03)')
      .borderRadius(6)
    }
  }

  @Builder
  buildDetailedAnalysis() {
    Column({ space: 12 }) {
      Text('📖 详细分析')
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#FFD700')

      Text(this.detailedAnalysis)
        .fontSize(13)
        .fontColor('rgba(255, 255, 255, 0.8)')
        .lineHeight(20)
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.05)')
    .borderRadius(12)
    .alignItems(HorizontalAlign.Start)
  }

  // 获取四象颜色
  private getSiXiangColor(type: SiXiangType): string {
    if (type === SiXiangType.JI) {
      return '#00FF00';
    } else if (type === SiXiangType.XIONG) {
      return '#FF0000';
    } else if (type === SiXiangType.SHENG) {
      return '#00FFFF';
    } else if (type === SiXiangType.KE) {
      return '#FF00FF';
    }
    return '#FFFFFF';
  }

  // 执行专业起卦
  private performProfessionalQiGua(): void {
    // 1. 基础起卦
    const basicResult = XiaoChengTuUtil.timeBasedQiGua();
    this.currentResult = basicResult;

    // 2. 装卦
    const zhuangGua = this.professional.performZhuangGua(
      basicResult.上卦,
      basicResult.下卦
    );
    this.zhuangGuaResult = zhuangGua;

    // 3. 四象占法
    const siXiang = this.professional.analyzeSiXiang(zhuangGua);
    this.siXiangResult = siXiang;

    // 4. 用神分析
    const yongShen = this.professional.analyzeYongShen(zhuangGua);
    this.yongShenMap = yongShen;

    // 5. 详细分析
    const analysis = this.professional.generateDetailedAnalysis(
      zhuangGua,
      siXiang,
      yongShen
    );
    this.detailedAnalysis = analysis;

    this.showResult = true;
  }
}
