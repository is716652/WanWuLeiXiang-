import { router } from '@kit.ArkUI';
import { BA_GUA_DATA, XiaoChengTuUtil, QI_GUA_METHOD, XiaoChengTuResult, BaGua } from '../model/XiaoChengTuData';
import { GuaDetailManager, GuaDetail } from '../model/GuaDetailManager';

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
  @State guaDetail: GuaDetail | null = null;

  private guaDetailManager: GuaDetailManager = GuaDetailManager.getInstance();

  aboutToAppear(): void {
    // 页面加载时自动进行时间起卦
    this.performTimeBasedQiGua();
  }

  // 加载当前卦象的详细数据
  private loadCurrentGuaDetail(): void {
    if (!this.currentResult) {
      return;
    }

    const detail = this.guaDetailManager.getGuaDetailByIndex(this.currentResult!.重卦.序号);
    this.guaDetail = detail;
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

          // 专业版入口 - 独立卡片
          Column({ space: 16 }) {
            Text('🔮 专业预测系统')
              .fontSize(18)
              .fontWeight(600)
              .fontColor('#FFD700')

            Text('进阶功能：装卦四盘、四象占法、用神取用、专业断事')
              .fontSize(14)
              .fontColor('rgba(255, 255, 255, 0.7)')
              .textAlign(TextAlign.Center)
              .lineHeight(20)

            Button() {
              Row({ space: 8 }) {
                Text('🎯')
                  .fontSize(20)
                Text('进入专业预测')
                  .fontSize(16)
                  .fontWeight(600)
              }
            }
            .width('70%')
            .height(50)
            .backgroundColor('rgba(139, 69, 19, 0.8)')
            .fontColor('#FFD700')
            .borderRadius(25)
            .borderWidth(2)
            .borderColor('#FFD700')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/XiaoChengTuProfessionalPage'
              });
            })
          }
          .width('100%')
          .padding(20)
          .backgroundColor('rgba(139, 69, 19, 0.15)')
          .borderRadius(12)
          .borderWidth(2)
          .borderColor('rgba(255, 215, 0, 0.4)')
          
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

          // 详细分析指南
          Column({ space: 16 }) {
            Text('📖 卦象分析指南')
              .fontSize(16)
              .fontWeight(600)
              .fontColor('#FFD700')

        // 分析步骤
        Column({ space: 12 }) {
          Text('🔍 五步解卦法')
            .fontSize(14)
            .fontWeight(600)
            .fontColor('rgba(255, 215, 0, 0.9)')

          Text('1️⃣ 分析卦象结构')
            .fontSize(13)
            .fontColor('rgba(255, 255, 255, 0.8)')
            .margin({ left: 16 })

          Text('   • 上卦（外卦）：天时、外部环境、客观条件')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('   • 下卦（内卦）：地利、内在因素、主观能动性')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('   • 五行生克：分析上下卦五行关系（相生为吉，相克为凶）')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('2️⃣ 确定宫属性质')
            .fontSize(13)
            .fontColor('rgba(255, 255, 255, 0.8)')
            .margin({ left: 16 })

          Text('   • 八宫归属：乾宫(金)、坤宫(土)、震宫(木)、巽宫(木)')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('   • 坎宫(水)、离宫(火)、艮宫(土)、兑宫(金)')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('   • 本宫特性：了解该宫的基本性质和能量特征')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('3️⃣ 分析世次位置')
            .fontSize(13)
            .fontColor('rgba(255, 255, 255, 0.8)')
            .margin({ left: 16 })

          Text('   • 本宫卦：能量最强，性质最纯粹')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('   • 一至五世：变化程度逐步增强，三世为转折点')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('   • 游魂归魂：精神状态变化，游魂不定，归魂稳定')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('4️⃣ 分析世应关系')
            .fontSize(13)
            .fontColor('rgba(255, 255, 255, 0.8)')
            .margin({ left: 16 })

          Text('   • 世爻：代表问卦者本人或事情主体')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('   • 应爻：代表他人、对方或外部环境')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('   • 生克关系：世生应(付出)、应生世(得助)、世克应(主导)、应克世(被动)')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('5️⃣ 综合判断建议')
            .fontSize(13)
            .fontColor('rgba(255, 255, 255, 0.8)')
            .margin({ left: 16 })

          Text('   • 结合具体问题：事业、感情、健康、财运等')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('   • 把握时机特征：根据世次判断所处阶段')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })

          Text('   • 选择合适策略：顺势而为或逆势而动')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ left: 24 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        // 实例分析
        Column({ space: 8 }) {
          Text('💡 实时实例分析')
            .fontSize(14)
            .fontWeight(600)
            .fontColor('rgba(255, 215, 0, 0.9)')

          Text(`以当前【${this.currentResult!.重卦.名称}】为例：`)
            .fontSize(13)
            .fontColor('rgba(255, 255, 255, 0.8)')

          // 基础分析
          Text(`• 宫属分析：此卦属${this.currentResult!.重卦.宫属}，具备该宫的基本特质`)
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')

          Text(`• 世次定位：${this.currentResult!.重卦.世次}，世爻在${this.currentResult!.重卦.世爻}位置`)
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')

          Text(`• 世应关系：世爻${this.currentResult!.重卦.世爻}与应爻${this.currentResult!.重卦.应爻}的互动关系`)
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')

          Text(`• 五行配置：上卦${this.currentResult!.上卦.五行}，下卦${this.currentResult!.下卦.五行}，${this.currentResult!.上卦.五行 === this.currentResult!.下卦.五行 ? '五行相同，内外一致' : 
            (this.currentResult!.上卦.五行 === '金' && this.currentResult!.下卦.五行 === '木') || 
            (this.currentResult!.上卦.五行 === '木' && this.currentResult!.下卦.五行 === '土') ||
            (this.currentResult!.上卦.五行 === '土' && this.currentResult!.下卦.五行 === '水') ||
            (this.currentResult!.上卦.五行 === '水' && this.currentResult!.下卦.五行 === '火') ||
            (this.currentResult!.上卦.五行 === '火' && this.currentResult!.下卦.五行 === '金') ? '上克下，外制内' : '上生下，外助内'}`)
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')

          // 详细解读部分
          if (this.guaDetail) {
            Divider()
              .color('rgba(255, 215, 0, 0.2)')
              .margin({ top: 8, bottom: 8 })

            // 卦辞解读
            Column({ space: 4 }) {
              Text('📜 卦辞解读')
                .fontSize(12)
                .fontWeight(600)
                .fontColor('rgba(255, 215, 0, 0.8)')

              Text(`"${this.guaDetail.卦辞}"`)
                .fontSize(11)
                .fontColor('rgba(255, 255, 255, 0.8)')
                .fontStyle(FontStyle.Italic)

              Text(`象辞：${this.guaDetail.象辞}`)
                .fontSize(11)
                .fontColor('rgba(255, 255, 255, 0.7)')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ top: 8 })

            // 详细解释
            Column({ space: 4 }) {
              Text('🎯 卦象详解')
                .fontSize(12)
                .fontWeight(600)
                .fontColor('rgba(255, 215, 0, 0.8)')

              Text(`整体含义：${this.guaDetail.详细解释.整体含义}`)
                .fontSize(11)
                .fontColor('rgba(255, 255, 255, 0.7)')

              Text(`人生启示：${this.guaDetail.详细解释.人生启示}`)
                .fontSize(11)
                .fontColor('rgba(255, 255, 255, 0.7)')
                .margin({ top: 4 })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ top: 8 })

            // 实用指导
            Column({ space: 4 }) {
              Text('🌟 实用指导')
                .fontSize(12)
                .fontWeight(600)
                .fontColor('rgba(255, 215, 0, 0.8)')

              Text(`吉凶等级：${this.guaDetail.吉凶等级}`)
                .fontSize(11)
                .fontColor(this.guaDetail.吉凶等级.includes('上') ? 'rgba(100, 255, 100, 0.8)' : 
                          this.guaDetail.吉凶等级.includes('中') ? 'rgba(255, 255, 100, 0.8)' : 
                          'rgba(255, 100, 100, 0.8)')

              Text(`核心象征：${this.guaDetail.核心象征}`)
                .fontSize(11)
                .fontColor('rgba(255, 255, 255, 0.7)')

              Text(`自然象征：${this.guaDetail.自然象征} | 人伦象征：${this.guaDetail.人伦象征}`)
                .fontSize(11)
                .fontColor('rgba(255, 255, 255, 0.6)')
                .margin({ top: 4 })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ top: 8 })
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding({ top: 12 })
        .borderRadius(6)
        .backgroundColor('rgba(255, 215, 0, 0.05)')
        .padding(12)
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
    // 加载详细数据
    this.loadCurrentGuaDetail();
  }

  // 执行时间起卦
  performTimeBasedQiGua(): void {
    const result = XiaoChengTuUtil.timeBasedQiGua();
    this.currentResult = result;
    this.showResult = true;
    // 加载详细数据
    this.loadCurrentGuaDetail();
  }
}