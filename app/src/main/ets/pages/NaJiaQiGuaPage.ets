/**
 * 纳甲起卦页面
 * 专业六爻纳甲起卦功能
 */

import router from '@ohos.router';
import {
  NaJiaQiGuaResult,
  NaJiaGuaInfo,
  NaJiaYaoInfo,
  NaJiaYaoType,
  LiuQin,
  LiuShen,
  performNaJiaQiGua,
  getLiuQinColor,
  getLiuShenColor,
  getYaoTypeColor,
  getWuXingColor
} from '../model/NaJiaQiGuaData';

@Entry
@Component
struct NaJiaQiGuaPage {
  @State result: NaJiaQiGuaResult | null = null;
  @State isAnimating: boolean = false;
  @State question: string = '';
  @State showQuestionInput: boolean = false;
  @State showBianGua: boolean = false;
  @State currentTab: number = 0;

  /**
   * 爻位显示组件
   */
  @Builder
  YaoRow(yao: NaJiaYaoInfo, showChanging: boolean) {
    Row() {
      // 六神
      Text(yao.liuShen)
        .fontSize(10)
        .fontColor(getLiuShenColor(yao.liuShen))
        .width(36)
        .textAlign(TextAlign.Center)
        .backgroundColor(yao.liuShen === LiuShen.BAI_HU ? '#333333' : 'transparent')
        .borderRadius(4)
        .padding(2)

      // 六亲
      Text(yao.liuQin)
        .fontSize(11)
        .fontColor(getLiuQinColor(yao.liuQin))
        .fontWeight(FontWeight.Medium)
        .width(36)
        .textAlign(TextAlign.Center)

      // 纳甲
      Text(yao.naJia)
        .fontSize(12)
        .fontColor(getWuXingColor(yao.wuXing))
        .fontWeight(FontWeight.Bold)
        .width(36)
        .textAlign(TextAlign.Center)

      // 五行
      Text(yao.wuXing)
        .fontSize(10)
        .fontColor(getWuXingColor(yao.wuXing))
        .width(24)
        .textAlign(TextAlign.Center)

      // 爻象符号
      Column() {
        if (yao.isYang) {
          // 阳爻
          Row()
            .width(40)
            .height(6)
            .backgroundColor(showChanging && yao.isChanging ? '#FF4444' : '#333333')
            .borderRadius(2)
        } else {
          // 阴爻
          Row({ space: 4 }) {
            Row()
              .width(16)
              .height(6)
              .backgroundColor(showChanging && yao.isChanging ? '#8844FF' : '#333333')
              .borderRadius(2)
            Row()
              .width(16)
              .height(6)
              .backgroundColor(showChanging && yao.isChanging ? '#8844FF' : '#333333')
              .borderRadius(2)
          }
        }
      }
      .width(48)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 变爻标识
      if (showChanging && yao.isChanging) {
        Text(yao.yaoType === NaJiaYaoType.OLD_YANG ? 'O' : 'X')
          .fontSize(12)
          .fontColor(getYaoTypeColor(yao.yaoType))
          .fontWeight(FontWeight.Bold)
          .width(20)
          .textAlign(TextAlign.Center)
      } else {
        Text('')
          .width(20)
      }

      // 世应标识
      if (yao.isShiYao) {
        Text('世')
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor('#E91E63')
          .borderRadius(10)
          .width(20)
          .height(20)
          .textAlign(TextAlign.Center)
      } else if (yao.isYingYao) {
        Text('应')
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor('#2196F3')
          .borderRadius(10)
          .width(20)
          .height(20)
          .textAlign(TextAlign.Center)
      } else {
        Text('')
          .width(20)
      }
    }
    .width('100%')
    .height(36)
    .padding({ left: 8, right: 8 })
    .backgroundColor(yao.isShiYao ? 'rgba(233, 30, 99, 0.08)' : (yao.isYingYao ? 'rgba(33, 150, 243, 0.08)' : 'transparent'))
    .borderRadius(4)
  }

  /**
   * 卦象卡片
   */
  @Builder
  GuaCard(gua: NaJiaGuaInfo, title: string, titleColor: string, showChanging: boolean) {
    Column({ space: 12 }) {
      // 卡片头部
      Row() {
        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(titleColor)

        Blank()

        Column({ space: 2 }) {
          Text(gua.gongShu)
            .fontSize(10)
            .fontColor('#666666')
          Text(gua.shiCi)
            .fontSize(10)
            .fontColor('#999999')
        }
        .alignItems(HorizontalAlign.End)
      }
      .width('100%')

      // 卦象信息
      Row({ space: 16 }) {
        // 卦象符号
        Text(gua.symbol)
          .fontSize(56)
          .fontColor(titleColor)

        // 卦名和组成
        Column({ space: 4 }) {
          Text(gua.name)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')

          Text(`${gua.upperGua}上${gua.lowerGua}下`)
            .fontSize(12)
            .fontColor('#666666')

          Text(`第${gua.code}卦`)
            .fontSize(11)
            .fontColor('#999999')
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')

      // 列标题
      Row() {
        Text('六神')
          .fontSize(9)
          .fontColor('#999999')
          .width(36)
          .textAlign(TextAlign.Center)
        Text('六亲')
          .fontSize(9)
          .fontColor('#999999')
          .width(36)
          .textAlign(TextAlign.Center)
        Text('纳甲')
          .fontSize(9)
          .fontColor('#999999')
          .width(36)
          .textAlign(TextAlign.Center)
        Text('五行')
          .fontSize(9)
          .fontColor('#999999')
          .width(24)
          .textAlign(TextAlign.Center)
        Text('爻象')
          .fontSize(9)
          .fontColor('#999999')
          .width(48)
          .textAlign(TextAlign.Center)
        Text('变')
          .fontSize(9)
          .fontColor('#999999')
          .width(20)
          .textAlign(TextAlign.Center)
        Text('世应')
          .fontSize(9)
          .fontColor('#999999')
          .width(20)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding({ left: 8, right: 8 })

      Divider().color('#E0E0E0')

      // 六爻列表 (从上爻到初爻)
      Column({ space: 4 }) {
        ForEach(gua.yaoList.slice().reverse(), (yao: NaJiaYaoInfo) => {
          this.YaoRow(yao, showChanging)
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({
      radius: 8,
      color: '#1A000000',
      offsetX: 0,
      offsetY: 4
    })
  }

  /**
   * 问题输入对话框
   */
  @Builder
  QuestionDialog() {
    Column({ space: 16 }) {
      Text('请输入问卦内容')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')

      // 示例问题
      Column({ space: 8 }) {
        Text('常用问题：')
          .fontSize(12)
          .fontColor('#666666')
          .width('100%')

        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(['事业发展', '财运如何', '感情姻缘', '健康状况', '出行吉凶', '考试升学'], (item: string) => {
            Button(item)
              .fontSize(11)
              .fontColor('#8E24AA')
              .backgroundColor('#F3E5F5')
              .height(28)
              .margin(4)
              .onClick(() => {
                this.question = item + '如何？';
              })
          })
        }
        .width('100%')
      }

      TextInput({
        placeholder: '请输入您要占问的事情...',
        text: this.question
      })
        .fontSize(14)
        .height(80)
        .onChange((value: string) => {
          this.question = value;
        })

      Row({ space: 12 }) {
        Button('取消')
          .fontSize(16)
          .fontColor('#666666')
          .backgroundColor('#F5F5F5')
          .layoutWeight(1)
          .onClick(() => {
            this.showQuestionInput = false;
          })

        Button('开始起卦')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor(this.question.trim() ? '#8E24AA' : '#CCCCCC')
          .layoutWeight(1)
          .enabled(this.question.trim().length > 0)
          .onClick(() => {
            if (this.question.trim()) {
              this.showQuestionInput = false;
              this.startQiGua();
            }
          })
      }
      .width('100%')
    }
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .width('90%')
  }

  /**
   * 六亲图例
   */
  @Builder
  LiuQinLegend() {
    Column({ space: 8 }) {
      Text('六亲释义')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')

      Row({ space: 8 }) {
        ForEach([
          { name: '父母', desc: '生我者', color: getLiuQinColor(LiuQin.FU_MU) },
          { name: '兄弟', desc: '同我者', color: getLiuQinColor(LiuQin.XIONG_DI) },
          { name: '子孙', desc: '我生者', color: getLiuQinColor(LiuQin.ZI_SUN) },
          { name: '妻财', desc: '我克者', color: getLiuQinColor(LiuQin.QI_CAI) },
          { name: '官鬼', desc: '克我者', color: getLiuQinColor(LiuQin.GUAN_GUI) }
        ], (item: LegendItem) => {
          Column({ space: 2 }) {
            Text(item.name)
              .fontSize(11)
              .fontColor(item.color)
              .fontWeight(FontWeight.Medium)
            Text(item.desc)
              .fontSize(9)
              .fontColor('#999999')
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FAFAFA')
    .borderRadius(8)
  }

  /**
   * 六神图例
   */
  @Builder
  LiuShenLegend() {
    Column({ space: 8 }) {
      Text('六神释义')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')

      Row({ space: 4 }) {
        ForEach([
          { name: '青龙', desc: '吉庆', color: getLiuShenColor(LiuShen.QING_LONG), bgColor: 'transparent' },
          { name: '朱雀', desc: '口舌', color: getLiuShenColor(LiuShen.ZHU_QUE), bgColor: 'transparent' },
          { name: '勾陈', desc: '田土', color: getLiuShenColor(LiuShen.GOU_CHEN), bgColor: 'transparent' },
          { name: '螣蛇', desc: '怪异', color: getLiuShenColor(LiuShen.TENG_SHE), bgColor: 'transparent' },
          { name: '白虎', desc: '凶丧', color: getLiuShenColor(LiuShen.BAI_HU), bgColor: '#333333' },
          { name: '玄武', desc: '盗贼', color: getLiuShenColor(LiuShen.XUAN_WU), bgColor: 'transparent' }
        ], (item: LegendItemWithBg) => {
          Column({ space: 2 }) {
            Text(item.name)
              .fontSize(10)
              .fontColor(item.color)
              .fontWeight(FontWeight.Medium)
              .backgroundColor(item.bgColor)
              .padding(2)
              .borderRadius(2)
            Text(item.desc)
              .fontSize(9)
              .fontColor('#999999')
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FAFAFA')
    .borderRadius(8)
  }

  /**
   * 执行起卦
   */
  startQiGua(): void {
    this.isAnimating = true;
    this.result = null;

    // 模拟起卦动画
    setTimeout(() => {
      this.result = performNaJiaQiGua(this.question);
      this.isAnimating = false;
    }, 1500);
  }

  build() {
    Stack() {
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

          Text('纳甲起卦')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Button('重置')
            .fontSize(14)
            .fontColor('#8E24AA')
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              this.result = null;
              this.question = '';
              this.showBianGua = false;
            })
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .backgroundColor('#FFFFFF')

        if (!this.result && !this.isAnimating) {
          // 起卦前界面
          Column({ space: 24 }) {
            // 标题说明
            Column({ space: 12 }) {
              Text('六爻纳甲起卦')
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')

              Text('专业六爻占卜工具')
                .fontSize(14)
                .fontColor('#666666')
            }

            // 功能说明卡片
            Column({ space: 12 }) {
              Row({ space: 8 }) {
                Text('☯')
                  .fontSize(24)
                Text('纳甲装卦')
                  .fontSize(14)
                  .fontColor('#333333')
                Text('天干地支配爻')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')

              Row({ space: 8 }) {
                Text('👥')
                  .fontSize(24)
                Text('六亲关系')
                  .fontSize(14)
                  .fontColor('#333333')
                Text('父母兄弟子孙妻财官鬼')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')

              Row({ space: 8 }) {
                Text('🐉')
                  .fontSize(24)
                Text('六神配置')
                  .fontSize(14)
                  .fontColor('#333333')
                Text('青龙朱雀勾陈螣蛇白虎玄武')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')

              Row({ space: 8 }) {
                Text('🌍')
                  .fontSize(24)
                Text('世应定位')
                  .fontSize(14)
                  .fontColor('#333333')
                Text('京房八宫世应体系')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)

            // 太极图
            Text('☯')
              .fontSize(100)
              .fontColor('#8E24AA')

            // 起卦按钮
            Column({ space: 12 }) {
              Button('诚心起卦')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .backgroundColor('#8E24AA')
                .width('80%')
                .height(56)
                .borderRadius(28)
                .shadow({
                  radius: 8,
                  color: '#4A8E24AA',
                  offsetX: 0,
                  offsetY: 4
                })
                .onClick(() => {
                  this.showQuestionInput = true;
                })

              Button('随机起卦')
                .fontSize(14)
                .fontColor('#8E24AA')
                .backgroundColor('#F3E5F5')
                .width('60%')
                .height(40)
                .borderRadius(20)
                .onClick(() => {
                  this.question = '随机占卜';
                  this.startQiGua();
                })
            }
          }
          .width('100%')
          .layoutWeight(1)
          .padding(20)
          .justifyContent(FlexAlign.Center)

        } else if (this.isAnimating) {
          // 起卦动画
          Column({ space: 30 }) {
            Text('正在起卦...')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#8E24AA')

            Column({ space: 16 }) {
              Text('⚊ ⚋ ⚊ ⚋ ⚊ ⚋')
                .fontSize(32)
                .fontColor('#FF6B35')

              Text('六爻生成中...')
                .fontSize(14)
                .fontColor('#666666')
            }

            Text(`问：${this.question}`)
              .fontSize(14)
              .fontColor('#666666')
              .fontStyle(FontStyle.Italic)
              .textAlign(TextAlign.Center)
              .padding(16)
              .backgroundColor('#F8F9FA')
              .borderRadius(8)
              .width('90%')
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)

        } else if (this.result) {
          // 起卦结果
          Scroll() {
            Column({ space: 16 }) {
              // 问题和时间信息
              Column({ space: 8 }) {
                Row() {
                  Text('问卦：')
                    .fontSize(14)
                    .fontColor('#666666')
                  Text(this.result.question)
                    .fontSize(14)
                    .fontColor('#333333')
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(1)
                }
                .width('100%')

                Row({ space: 16 }) {
                  Text(`日干支：${this.result.riGan}${this.result.riZhi}`)
                    .fontSize(12)
                    .fontColor('#8E24AA')

                  Text(`变爻：${this.result.changingCount}个`)
                    .fontSize(12)
                    .fontColor('#FF6B35')

                  Blank()

                  Text(new Date(this.result.timestamp).toLocaleString())
                    .fontSize(10)
                    .fontColor('#999999')
                }
                .width('100%')
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#F0F8FF')
              .borderRadius(8)

              // 卦象切换
              Row({ space: 0 }) {
                Button('本卦')
                  .fontSize(14)
                  .fontColor(this.currentTab === 0 ? '#FFFFFF' : '#8E24AA')
                  .backgroundColor(this.currentTab === 0 ? '#8E24AA' : '#F3E5F5')
                  .layoutWeight(1)
                  .height(40)
                  .borderRadius({ topLeft: 20, bottomLeft: 20, topRight: 0, bottomRight: 0 })
                  .onClick(() => {
                    this.currentTab = 0;
                  })

                Button('变卦')
                  .fontSize(14)
                  .fontColor(this.currentTab === 1 ? '#FFFFFF' : '#FF6B35')
                  .backgroundColor(this.currentTab === 1 ? '#FF6B35' : '#FFF3E0')
                  .layoutWeight(1)
                  .height(40)
                  .borderRadius({ topLeft: 0, bottomLeft: 0, topRight: 20, bottomRight: 20 })
                  .enabled(this.result.changingCount > 0)
                  .opacity(this.result.changingCount > 0 ? 1 : 0.5)
                  .onClick(() => {
                    if (this.result && this.result.changingCount > 0) {
                      this.currentTab = 1;
                    }
                  })
              }
              .width('100%')

              // 卦象显示
              if (this.currentTab === 0) {
                this.GuaCard(this.result.benGua, '本卦', '#8E24AA', true)
              } else {
                this.GuaCard(this.result.bianGua, '变卦', '#FF6B35', false)
              }

              // 变卦提示
              if (this.result.changingCount > 0 && this.currentTab === 0) {
                Row() {
                  Text('↓ 变爻转换后得变卦 ↓')
                    .fontSize(12)
                    .fontColor('#FF6B35')
                }
                .width('100%')
                .justifyContent(FlexAlign.Center)
              }

              // 图例说明
              this.LiuQinLegend()
              this.LiuShenLegend()

              // 操作按钮
              Row({ space: 12 }) {
                Button('重新起卦')
                  .fontSize(16)
                  .fontColor('#8E24AA')
                  .backgroundColor('#F3E5F5')
                  .layoutWeight(1)
                  .onClick(() => {
                    this.result = null;
                    this.question = '';
                    this.currentTab = 0;
                  })

                Button('再占一卦')
                  .fontSize(16)
                  .fontColor('#FFFFFF')
                  .backgroundColor('#8E24AA')
                  .layoutWeight(1)
                  .onClick(() => {
                    this.showQuestionInput = true;
                  })
              }
              .width('100%')
              .margin({ top: 16, bottom: 20 })
            }
            .padding(16)
          }
          .width('100%')
          .layoutWeight(1)
          .scrollBar(BarState.Auto)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')

      // 问题输入弹窗
      if (this.showQuestionInput) {
        Column() {
          this.QuestionDialog()
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.showQuestionInput = false;
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}

// 图例项接口
interface LegendItem {
  name: string;
  desc: string;
  color: string;
}

// 带背景色的图例项接口
interface LegendItemWithBg {
  name: string;
  desc: string;
  color: string;
  bgColor: string;
}
