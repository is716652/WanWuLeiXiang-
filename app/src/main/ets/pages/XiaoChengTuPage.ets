import { router } from '@kit.ArkUI';
import { BA_GUA_DATA, XiaoChengTuUtil, QI_GUA_METHOD, XiaoChengTuResult, BaGua } from '../model/XiaoChengTuData';

@Entry
@Component
struct XiaoChengTuPage {
  @State currentResult: XiaoChengTuResult | null = null;
  @State selectedMethod: QI_GUA_METHOD = QI_GUA_METHOD.TIME_BASED;
  @State upperNumber: number = 1;
  @State lowerNumber: number = 1;
  @State selectedUpperGua: string = '乾';
  @State selectedLowerGua: string = '坤';
  @State showResult: boolean = false;

  aboutToAppear(): void {
    // 页面加载时自动进行时间起卦
    this.performTimeBasedQiGua();
  }

  build() {
    Column() {
      // 顶部导航栏
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

        Text('小成图起卦')
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
          // 小成图说明
          Column({ space: 16 }) {
            Text('☯ 小成图原理')
              .fontSize(20)
              .fontWeight(600)
              .fontColor('#FFD700')

            Text(`小成图是易经象数易学中的重要概念，通过八卦重合形成六十四卦。
上卦代表天时、外部环境，下卦代表地利、内在条件。
天地交感，阴阳和合，化生万物，体现"天人合一"的哲学思想。`)
              .fontSize(16)
              .fontColor('rgba(255, 255, 255, 0.9)')
              .lineHeight(24)
              .letterSpacing(1)
          }
          .width('100%')
          .padding(20)
          .backgroundColor('rgba(255, 215, 0, 0.1)')
          .borderRadius(12)
          .borderWidth(1)
          .borderColor('rgba(255, 215, 0, 0.3)')
          
          // 起卦方式选择
          Column({ space: 16 }) {
            Text('📊 起卦方式')
              .fontSize(20)
              .fontWeight(600)
              .fontColor('#FFD700')

            Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
              ForEach(Object.values(QI_GUA_METHOD), (method: QI_GUA_METHOD) => {
                Button(method)
                  .fontSize(14)
                  .fontColor(this.selectedMethod === method ? '#000000' : '#FFFFFF')
                  .backgroundColor(this.selectedMethod === method ? '#FFD700' : 'rgba(255, 255, 255, 0.1)')
                  .borderColor(this.selectedMethod === method ? '#FFD700' : 'rgba(255, 255, 255, 0.3)')
                  .borderWidth(1)
                  .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                  .margin({ bottom: 8 })
                  .onClick(() => {
                    this.selectedMethod = method;
                  })
              })
            }
          }
          .width('100%')
          .padding(20)
          .backgroundColor('rgba(255, 255, 255, 0.05)')
          .borderRadius(12)
          
          // 起卦操作区域
          Column({ space: 20 }) {
            Text('🎯 起卦操作')
              .fontSize(20)
              .fontWeight(600)
              .fontColor('#FFD700')

            if (this.selectedMethod === QI_GUA_METHOD.TIME_BASED) {
              this.buildTimeBasedArea()
            } else if (this.selectedMethod === QI_GUA_METHOD.NUMBER_BASED) {
              this.buildNumberBasedArea()
            } else if (this.selectedMethod === QI_GUA_METHOD.MANUAL) {
              this.buildManualArea()
            }

            // 起卦按钮
            Button() {
              Text('开始起卦')
                .fontSize(18)
                .fontWeight(600)
                .fontColor('#000000')
            }
            .width('60%')
            .height(50)
            .backgroundColor('#FFD700')
            .borderRadius(25)
            .onClick(() => {
              this.performQiGua();
            })
          }
          .width('100%')
          .padding(20)
          .backgroundColor('rgba(255, 255, 255, 0.05)')
          .borderRadius(12)
          
          // 结果展示
          if (this.showResult && this.currentResult) {
            this.buildResultDisplay()
          }
        }
        .width('100%')
        .padding({ left: 20, right: 20 })
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
  buildTimeBasedArea() {
    Column({ space: 12 }) {
      Text('时间起卦法')
        .fontSize(16)
        .fontColor('#FFFFFF')
        .textAlign(TextAlign.Center)

      Text(`根据当前时间自动起卦
年月日时相配，天地人神合一`)
        .fontSize(14)
        .fontColor('rgba(255, 255, 255, 0.7)')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('rgba(255, 215, 0, 0.1)')
    .borderRadius(8)
  }

  @Builder
  buildNumberBasedArea() {
    Column({ space: 16 }) {
      Text('数字起卦法')
        .fontSize(16)
        .fontColor('#FFFFFF')
        .textAlign(TextAlign.Center)

      Row({ space: 20 }) {
        Column({ space: 8 }) {
          Text('上卦数字')
            .fontSize(14)
            .fontColor('rgba(255, 255, 255, 0.8)')

          Row({ space: 12 }) {
            Button('-')
              .width(40)
              .height(40)
              .fontSize(16)
              .fontColor('#000000')
              .backgroundColor('rgba(255, 255, 255, 0.8)')
              .onClick(() => {
                if (this.upperNumber > 1) this.upperNumber--;
              })

            Text(this.upperNumber.toString())
              .fontSize(18)
              .fontWeight(600)
              .fontColor('#FFD700')
              .width(40)
              .textAlign(TextAlign.Center)

            Button('+')
              .width(40)
              .height(40)
              .fontSize(16)
              .fontColor('#000000')
              .backgroundColor('rgba(255, 255, 255, 0.8)')
              .onClick(() => {
                if (this.upperNumber < 999) this.upperNumber++;
              })
          }
        }

        Column({ space: 8 }) {
          Text('下卦数字')
            .fontSize(14)
            .fontColor('rgba(255, 255, 255, 0.8)')

          Row({ space: 12 }) {
            Button('-')
              .width(40)
              .height(40)
              .fontSize(16)
              .fontColor('#000000')
              .backgroundColor('rgba(255, 255, 255, 0.8)')
              .onClick(() => {
                if (this.lowerNumber > 1) this.lowerNumber--;
              })

            Text(this.lowerNumber.toString())
              .fontSize(18)
              .fontWeight(600)
              .fontColor('#FFD700')
              .width(40)
              .textAlign(TextAlign.Center)

            Button('+')
              .width(40)
              .height(40)
              .fontSize(16)
              .fontColor('#000000')
              .backgroundColor('rgba(255, 255, 255, 0.8)')
              .onClick(() => {
                if (this.lowerNumber < 999) this.lowerNumber++;
              })
          }
        }
      }
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('rgba(255, 215, 0, 0.1)')
    .borderRadius(8)
  }

  @Builder
  buildManualArea() {
    Column({ space: 16 }) {
      Text('手动选择起卦法')
        .fontSize(16)
        .fontColor('#FFFFFF')
        .textAlign(TextAlign.Center)

      Column({ space: 12 }) {
        Text('选择上卦')
          .fontSize(14)
          .fontColor('rgba(255, 255, 255, 0.8)')

        Grid() {
          ForEach(BA_GUA_DATA, (gua: BaGua) => {
            GridItem() {
              Button() {
                Column({ space: 4 }) {
                  Text(gua.符号)
                    .fontSize(20)
                  Text(gua.名称)
                    .fontSize(12)
                }
              }
              .backgroundColor(this.selectedUpperGua === gua.名称 ? '#FFD700' : 'rgba(255, 255, 255, 0.1)')
              .fontColor(this.selectedUpperGua === gua.名称 ? '#000000' : '#FFFFFF')
              .borderRadius(8)
              .onClick(() => {
                this.selectedUpperGua = gua.名称;
              })
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsGap(8)
        .columnsGap(8)
        .height(120)
      }

      Column({ space: 12 }) {
        Text('选择下卦')
          .fontSize(14)
          .fontColor('rgba(255, 255, 255, 0.8)')

        Grid() {
          ForEach(BA_GUA_DATA, (gua: BaGua) => {
            GridItem() {
              Button() {
                Column({ space: 4 }) {
                  Text(gua.符号)
                    .fontSize(20)
                  Text(gua.名称)
                    .fontSize(12)
                }
              }
              .backgroundColor(this.selectedLowerGua === gua.名称 ? '#FFD700' : 'rgba(255, 255, 255, 0.1)')
              .fontColor(this.selectedLowerGua === gua.名称 ? '#000000' : '#FFFFFF')
              .borderRadius(8)
              .onClick(() => {
                this.selectedLowerGua = gua.名称;
              })
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsGap(8)
        .columnsGap(8)
        .height(120)
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('rgba(255, 215, 0, 0.1)')
    .borderRadius(8)
  }

  @Builder
  buildResultDisplay() {
    Column({ space: 20 }) {
      Text('📿 起卦结果')
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#FFD700')

      // 卦象展示
      Column({ space: 16 }) {
        Row({ space: 20 }) {
          // 上卦
          Column({ space: 8 }) {
            Text('上卦')
              .fontSize(14)
              .fontColor('rgba(255, 255, 255, 0.7)')
            Text(this.currentResult!.上卦.符号)
              .fontSize(48)
              .fontColor('#FFD700')
            Text(this.currentResult!.上卦.名称)
              .fontSize(18)
              .fontWeight(600)
              .fontColor('#FFFFFF')
            Text(`${this.currentResult!.上卦.五行} · ${this.currentResult!.上卦.方位}`)
              .fontSize(14)
              .fontColor('rgba(255, 255, 255, 0.7)')
          }

          // 重卦符号
          Column({ space: 8 }) {
            Text('重卦')
              .fontSize(14)
              .fontColor('rgba(255, 255, 255, 0.7)')
            Text(this.currentResult!.重卦.符号)
              .fontSize(56)
              .fontColor('#FFD700')
            Text(this.currentResult!.重卦.名称)
              .fontSize(20)
              .fontWeight(600)
              .fontColor('#FFFFFF')
            Text(`第${this.currentResult!.重卦.序号}卦`)
              .fontSize(14)
              .fontColor('rgba(255, 255, 255, 0.7)')
          }

          // 下卦
          Column({ space: 8 }) {
            Text('下卦')
              .fontSize(14)
              .fontColor('rgba(255, 255, 255, 0.7)')
            Text(this.currentResult!.下卦.符号)
              .fontSize(48)
              .fontColor('#FFD700')
            Text(this.currentResult!.下卦.名称)
              .fontSize(18)
              .fontWeight(600)
              .fontColor('#FFFFFF')
            Text(`${this.currentResult!.下卦.五行} · ${this.currentResult!.下卦.方位}`)
              .fontSize(14)
              .fontColor('rgba(255, 255, 255, 0.7)')
          }
        }
        .justifyContent(FlexAlign.SpaceAround)
        .width('100%')
        .padding(20)
        .backgroundColor('rgba(255, 215, 0, 0.1)')
        .borderRadius(12)
      }

      // 详细信息
      Column({ space: 12 }) {
        Row({ space: 20 }) {
          Column({ space: 4 }) {
            Text('宫属')
              .fontSize(12)
              .fontColor('rgba(255, 255, 255, 0.7)')
            Text(this.currentResult!.重卦.宫属)
              .fontSize(16)
              .fontWeight(600)
              .fontColor('#FFFFFF')
          }

          Column({ space: 4 }) {
            Text('世次')
              .fontSize(12)
              .fontColor('rgba(255, 255, 255, 0.7)')
            Text(this.currentResult!.重卦.世次)
              .fontSize(16)
              .fontWeight(600)
              .fontColor('#FFFFFF')
          }

          Column({ space: 4 }) {
            Text('世爻')
              .fontSize(12)
              .fontColor('rgba(255, 255, 255, 0.7)')
            Text(this.currentResult!.重卦.世爻)
              .fontSize(16)
              .fontWeight(600)
              .fontColor('#FFFFFF')
          }

          Column({ space: 4 }) {
            Text('应爻')
              .fontSize(12)
              .fontColor('rgba(255, 255, 255, 0.7)')
            Text(this.currentResult!.重卦.应爻)
              .fontSize(16)
              .fontWeight(600)
              .fontColor('#FFFFFF')
          }
        }
        .justifyContent(FlexAlign.SpaceAround)
        .width('100%')
        .padding(16)
        .backgroundColor('rgba(255, 255, 255, 0.05)')
        .borderRadius(8)
      }

      // 解说
      Column({ space: 12 }) {
        Text('小成图解说')
          .fontSize(16)
          .fontWeight(600)
          .fontColor('#FFD700')

        Text(this.currentResult!.解说)
          .fontSize(14)
          .fontColor('rgba(255, 255, 255, 0.9)')
          .lineHeight(22)
          .letterSpacing(0.5)
      }
      .width('100%')
      .padding(20)
      .backgroundColor('rgba(255, 255, 255, 0.05)')
      .borderRadius(8)

      // 起卦信息
      Row({ space: 20 }) {
        Text(`起卦方式：${this.currentResult!.起卦方式}`)
          .fontSize(14)
          .fontColor('rgba(255, 255, 255, 0.7)')

        Text(`时间：${this.currentResult!.时间.getFullYear()}-${(this.currentResult!.时间.getMonth() + 1).toString().padStart(2, '0')}-${this.currentResult!.时间.getDate().toString().padStart(2, '0')} ${this.currentResult!.时间.getHours().toString().padStart(2, '0')}:${this.currentResult!.时间.getMinutes().toString().padStart(2, '0')}`)
          .fontSize(14)
          .fontColor('rgba(255, 255, 255, 0.7)')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.05)')
    .borderRadius(12)
    .borderWidth(1)
    .borderColor('rgba(255, 215, 0, 0.3)')
  }

  // 执行起卦
  performQiGua(): void {
    let result: XiaoChengTuResult;

    switch (this.selectedMethod) {
      case QI_GUA_METHOD.TIME_BASED:
        result = XiaoChengTuUtil.timeBasedQiGua();
        break;
      case QI_GUA_METHOD.NUMBER_BASED:
        result = XiaoChengTuUtil.numberBasedQiGua(this.upperNumber, this.lowerNumber);
        break;
      case QI_GUA_METHOD.MANUAL:
        result = XiaoChengTuUtil.manualQiGua(this.selectedUpperGua, this.selectedLowerGua);
        break;
      case QI_GUA_METHOD.RANDOM:
      default:
        result = XiaoChengTuUtil.randomQiGua();
        break;
    }

    this.currentResult = result;
    this.showResult = true;
  }

  // 执行时间起卦
  performTimeBasedQiGua(): void {
    const result = XiaoChengTuUtil.timeBasedQiGua();
    this.currentResult = result;
    this.showResult = true;
  }
}