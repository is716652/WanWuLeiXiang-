/**
 * 焦氏易林起卦页面
 * 基于六爻同时生成法的现代化起卦工具
 */

import { QiGuaResult, GuaInfo, YaoInfo, performQiGua, getYaoColor, getGuaColor } from '../model/JiaoShiQiGuaData';
import { JieGuaResult, performJieGua, getGuaCombinationExplanation } from '../model/JiaoshiYilinService';
import router from '@ohos.router';

@Entry
@Component
struct QiGuaPage {
  @State qiGuaResult: QiGuaResult | null = null;
  @State isAnimating: boolean = false;
  @State showResult: boolean = false;
  @State question: string = '';
  @State showQuestionInput: boolean = false;
  @State jieGuaResult: JieGuaResult | null = null;
  @State showJieGua: boolean = false;
  @State isLoadingJieGua: boolean = false;

  /**
   * 爻位显示组件
   */
  @Builder
  YaoDisplay(yao: YaoInfo, showAnimation: boolean = false) {
    Row() {
      // 爻位标识
      Text(`${this.getYaoPositionName(yao.position)}`)
        .fontSize(12)
        .fontColor('#666666')
        .width(40)
      
      // 爻象符号
      Text(yao.symbol)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(getYaoColor(yao))
        .width(60)
        .textAlign(TextAlign.Center)
        .backgroundColor(yao.isChanging ? '#FFF3E0' : 'transparent')
        .borderRadius(8)
        .padding(4)
        .animation({
          duration: showAnimation ? 500 : 0,
          curve: Curve.EaseInOut,
          iterations: yao.isChanging ? 3 : 1
        })
      
      // 爻名和随机数
      Column({ space: 2 }) {
        Text(yao.name)
          .fontSize(14)
          .fontColor(getYaoColor(yao))
          .fontWeight(FontWeight.Medium)
        
        Text(`(${yao.randomValue})`)
          .fontSize(10)
          .fontColor('#999999')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      
      // 变爻标识
      if (yao.isChanging) {
        Text('变')
          .fontSize(12)
          .fontColor('#FF6B35')
          .backgroundColor('#FFF3E0')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(10)
      }
    }
    .width('100%')
    .height(50)
    .alignItems(VerticalAlign.Center)
    .padding({ left: 16, right: 16 })
  }

  /**
   * 卦象显示组件
   */
  @Builder
  GuaDisplay(gua: GuaInfo, title: string, titleColor: string) {
    Column({ space: 12 }) {
      // 标题
      Text(title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(titleColor)
      
      // 卦象和卦名
      Row({ space: 16 }) {
        Text(gua.symbol)
          .fontSize(48)
          .fontColor(getGuaColor(gua.name))
        
        Column({ space: 4 }) {
          Text(gua.name)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(getGuaColor(gua.name))
          
          Text(`第${gua.code}卦`)
            .fontSize(12)
            .fontColor('#666666')
          
          Text(`数字卦：${gua.code}`)
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor('#8E24AA')
          
          Text(`${gua.upperGua}上${gua.lowerGua}下`)
            .fontSize(12)
            .fontColor('#999999')
        }
        .alignItems(HorizontalAlign.Start)
      }
      .alignItems(VerticalAlign.Center)
      
      // 六爻详情
      Column({ space: 4 }) {
        ForEach(gua.yaoList.slice().reverse(), (yao: YaoInfo) => {
          this.YaoDisplay(yao, this.isAnimating)
        })
      }
      .backgroundColor('#FAFAFA')
      .borderRadius(8)
      .padding(8)
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
   * 获取爻位名称
   */
  getYaoPositionName(position: number): string {
    switch (position) {
      case 1: return '初爻';
      case 2: return '二爻';
      case 3: return '三爻';
      case 4: return '四爻';
      case 5: return '五爻';
      case 6: return '上爻';
      default: return '';
    }
  }

  /**
   * 执行起卦动画
   */
  performQiGuaAnimation() {
    this.isAnimating = true;
    this.showResult = false;
    
    // 执行起卦
    const result = performQiGua(this.question || undefined);
    
    // 延迟显示结果，创建动画效果
    setTimeout(() => {
      this.qiGuaResult = result;
      this.isAnimating = false;
      
      // 再延迟一点显示完整结果
      setTimeout(() => {
        this.showResult = true;
        // 自动执行解卦
        this.performJieGuaAction();
      }, 300);
    }, 1500);
  }

  /**
   * 执行解卦
   */
  async performJieGuaAction() {
    if (!this.qiGuaResult) return;
    
    this.isLoadingJieGua = true;
    
    try {
      const benGuaName = this.qiGuaResult.benGua.name;
      const zhiGuaName = this.qiGuaResult.changingYaoCount > 0 ? this.qiGuaResult.zhiGua.name : undefined;
      
      const result = await performJieGua(benGuaName, zhiGuaName);
      this.jieGuaResult = result;
      this.showJieGua = true;
    } catch (error) {
      console.error('解卦失败:', error);
    } finally {
      this.isLoadingJieGua = false;
    }
  }

  /**
   * 解卦结果显示
   */
  @Builder
  JieGuaResultDialog() {
    if (this.jieGuaResult) {
      Column({ space: 20 }) {
        // 标题
        Row() {
          Text(this.jieGuaResult.message)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
            .layoutWeight(1)

          Button('×')
            .fontSize(20)
            .fontColor('#666666')
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              this.showJieGua = false;
            })
        }
        .width('100%')

        if (this.jieGuaResult.isAvailable && this.jieGuaResult.benGuaInfo) {
          Scroll() {
            Column({ space: 16 }) {
              // 卦象组合说明
              if (this.qiGuaResult) {
                Column({ space: 8 }) {
                  Text('卦象组合')
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#8E24AA')

                  Text(getGuaCombinationExplanation(
                    this.qiGuaResult.benGua.name,
                    this.qiGuaResult.changingYaoCount > 0 ? this.qiGuaResult.zhiGua.name : undefined
                  ))
                    .fontSize(12)
                    .fontColor('#666666')
                    .lineHeight(18)
                }
                .width('100%')
                .padding(12)
                .backgroundColor('#F0F8FF')
                .borderRadius(8)
              }

              // 本卦解释
              Column({ space: 12 }) {
                Text(`${this.jieGuaResult.benGuaInfo.guaInfo.guaName}卦 - 本卦`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#8E24AA')

                Column({ space: 8 }) {
                  Text('原文：')
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#333333')
                    .width('100%')
                    .textAlign(TextAlign.Start)

                  Text(this.jieGuaResult.benGuaInfo.benGua.text)
                    .fontSize(14)
                    .fontColor('#333333')
                    .lineHeight(22)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                }

                Column({ space: 8 }) {
                  Text('义译：')
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#666666')
                    .width('100%')
                    .textAlign(TextAlign.Start)

                  Text(this.jieGuaResult.benGuaInfo.benGua.yiyi)
                    .fontSize(14)
                    .fontColor('#666666')
                    .lineHeight(22)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                }

                Column({ space: 8 }) {
                  Text('象证：')
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#999999')
                    .width('100%')
                    .textAlign(TextAlign.Start)

                  Text(this.jieGuaResult.benGuaInfo.benGua.xiangzheng)
                    .fontSize(12)
                    .fontColor('#999999')
                    .lineHeight(20)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                }
              }
              .width('100%')
              .padding(16)
              .backgroundColor('#F8F9FA')
              .borderRadius(8)

              // 之卦解释（如果有）
              if (this.jieGuaResult.zhiGuaInfo) {
                Column({ space: 12 }) {
                  Text(`${this.jieGuaResult.zhiGuaInfo.targetGua}卦 - 之卦`)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#FF6B35')

                  Column({ space: 8 }) {
                    Text('原文：')
                      .fontSize(14)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#333333')
                      .width('100%')
                      .textAlign(TextAlign.Start)

                    Text(this.jieGuaResult.zhiGuaInfo.text)
                      .fontSize(14)
                      .fontColor('#333333')
                      .lineHeight(22)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                  }

                  Column({ space: 8 }) {
                    Text('义译：')
                      .fontSize(14)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#666666')
                      .width('100%')
                      .textAlign(TextAlign.Start)

                    Text(this.jieGuaResult.zhiGuaInfo.yiyi)
                      .fontSize(14)
                      .fontColor('#666666')
                      .lineHeight(22)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                  }

                  Column({ space: 8 }) {
                    Text('象证：')
                      .fontSize(14)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#999999')
                      .width('100%')
                      .textAlign(TextAlign.Start)

                    Text(this.jieGuaResult.zhiGuaInfo.xiangzheng)
                      .fontSize(12)
                      .fontColor('#999999')
                      .lineHeight(20)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                  }
                }
                .width('100%')
                .padding(16)
                .backgroundColor('#FFF3E0')
                .borderRadius(8)
              }
            }
          }
          .height(400)
          .scrollBar(BarState.Auto)
        } else {
          // 卦象暂未收录的提示
          Column({ space: 16 }) {
            Text('📚')
              .fontSize(48)

            Text(this.jieGuaResult.message)
              .fontSize(14)
              .fontColor('#666666')
              .textAlign(TextAlign.Center)
              .lineHeight(22)

            Button('查看已收录卦象')
              .fontSize(14)
              .fontColor('#FFFFFF')
              .backgroundColor('#8E24AA')
              .onClick(() => {
                this.showJieGua = false;
                router.pushUrl({
                  url: 'pages/JiaoshiYilinPage'
                });
              })
          }
          .width('100%')
          .height(300)
          .justifyContent(FlexAlign.Center)
        }
      }
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .width('95%')
    }
  }

  /**
   * 问卦输入对话框
   */
  @Builder
  QuestionInputDialog() {
    Column({ space: 20 }) {
      Text('请输入您要问的问题')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
      
      TextInput({ placeholder: '例如：工作发展如何？感情运势怎样？' })
        .fontSize(14)
        .height(100)
        .maxLines(3)
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
          .backgroundColor('#8E24AA')
          .layoutWeight(1)
          .onClick(() => {
            this.showQuestionInput = false;
            this.performQiGuaAnimation();
          })
      }
      .width('100%')
    }
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .width('90%')
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

        Text('焦氏易林起卦')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button('重新起卦')
          .fontSize(14)
          .fontColor('#8E24AA')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.qiGuaResult = null;
            this.showResult = false;
            this.question = '';
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      if (!this.qiGuaResult && !this.isAnimating) {
        // 起卦界面
        Column({ space: 30 }) {
          // 说明文字
          Column({ space: 16 }) {
            Text('焦氏易林起卦法')
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .textAlign(TextAlign.Center)
            
            Text('基于"六爻同时生成法"的现代化起卦工具')
              .fontSize(14)
              .fontColor('#666666')
              .textAlign(TextAlign.Center)
            
            Column({ space: 8 }) {
              Text('• 老阳(O)、老阴(X)为变爻，概率各20%')
                .fontSize(12)
                .fontColor('#999999')
                .textAlign(TextAlign.Start)
                .width('100%')
              
              Text('• 少阳(—)、少阴(--)为稳定爻，概率共60%')
                .fontSize(12)
                .fontColor('#999999')
                .textAlign(TextAlign.Start)
                .width('100%')
              
              Text('• 生成本卦和之卦，用于查询焦氏易林')
                .fontSize(12)
                .fontColor('#999999')
                .textAlign(TextAlign.Start)
                .width('100%')
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#F8F9FA')
            .borderRadius(8)
          }
          
          // 太极图动画区域
          Column({ space: 20 }) {
            Text('☯')
              .fontSize(80)
              .fontColor('#8E24AA')
              .animation({
                duration: 3000,
                curve: Curve.Linear,
                iterations: -1
              })
              .rotate({ angle: 360 })
            
            Text('心念集中，诚心问卦')
              .fontSize(16)
              .fontColor('#666666')
              .fontStyle(FontStyle.Italic)
          }
          .width('100%')
          .height(200)
          .justifyContent(FlexAlign.Center)
          
          // 起卦按钮
          Column({ space: 12 }) {
            Button('设置问题并起卦')
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
            
            Button('直接起卦')
              .fontSize(16)
              .fontColor('#8E24AA')
              .backgroundColor('#F3E5F5')
              .width('60%')
              .height(44)
              .borderRadius(22)
              .onClick(() => {
                this.performQiGuaAnimation();
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
          
          Column({ space: 20 }) {
            Text('⚊ ⚋ ⚊ ⚋ ⚊ ⚋')
              .fontSize(32)
              .fontColor('#FF6B35')
              .animation({
                duration: 500,
                curve: Curve.EaseInOut,
                iterations: -1
              })
            
            Text('六爻生成中...')
              .fontSize(14)
              .fontColor('#666666')
          }
          
          if (this.question) {
            Text(`问：${this.question}`)
              .fontSize(14)
              .fontColor('#999999')
              .fontStyle(FontStyle.Italic)
              .textAlign(TextAlign.Center)
              .padding(16)
              .backgroundColor('#F8F9FA')
              .borderRadius(8)
              .width('90%')
          }
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        
      } else if (this.qiGuaResult) {
        // 起卦结果
        Scroll() {
          Column({ space: 20 }) {
            // 问题显示
            if (this.qiGuaResult.question) {
              Column({ space: 8 }) {
                Text('问卦内容')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333333')
                
                Text(this.qiGuaResult.question)
                  .fontSize(14)
                  .fontColor('#666666')
                  .textAlign(TextAlign.Center)
              }
              .width('100%')
              .padding(16)
              .backgroundColor('#F0F8FF')
              .borderRadius(8)
            }
            
            // 起卦信息
            Row({ space: 16 }) {
              Text(`变爻数量：${this.qiGuaResult.changingYaoCount}`)
                .fontSize(12)
                .fontColor('#666666')
              
              Text(`起卦时间：${new Date(this.qiGuaResult.timestamp).toLocaleString()}`)
                .fontSize(12)
                .fontColor('#666666')
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            
            // 本卦
            this.GuaDisplay(this.qiGuaResult.benGua, '本卦', '#8E24AA')
            
            // 箭头指示
            if (this.qiGuaResult.changingYaoCount > 0) {
              Text('↓ 变爻转换 ↓')
                .fontSize(14)
                .fontColor('#FF6B35')
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Center)
                .width('100%')
            }
            
            // 之卦
            if (this.qiGuaResult.changingYaoCount > 0) {
              this.GuaDisplay(this.qiGuaResult.zhiGua, '之卦', '#FF6B35')
            }
            
            // 卦象组合
            Column({ space: 12 }) {
              Text('卦象组合')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
              
              if (this.qiGuaResult.changingYaoCount > 0) {
                Column({ space: 8 }) {
                  Text(`${this.qiGuaResult.benGua.name}之${this.qiGuaResult.zhiGua.name}`)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#8E24AA')
                    .textAlign(TextAlign.Center)
                  
                  Text(`数字卦：${this.qiGuaResult.benGua.code} → ${this.qiGuaResult.zhiGua.code}`)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#FF6B35')
                    .textAlign(TextAlign.Center)
                }
              } else {
                Column({ space: 8 }) {
                  Text(`${this.qiGuaResult.benGua.name}卦`)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#8E24AA')
                    .textAlign(TextAlign.Center)
                  
                  Text(`数字卦：${this.qiGuaResult.benGua.code}`)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#8E24AA')
                    .textAlign(TextAlign.Center)
                }
              }
              
              if (this.isLoadingJieGua) {
                Text('正在自动查询《焦氏易林》...')
                  .fontSize(12)
                  .fontColor('#FF6B35')
                  .textAlign(TextAlign.Center)
              } else if (this.jieGuaResult) {
                Text('已自动查询《焦氏易林》获得详细解释')
                  .fontSize(12)
                  .fontColor('#4CAF50')
                  .textAlign(TextAlign.Center)
              } else {
                Text('点击"重新解卦"查询《焦氏易林》')
                  .fontSize(12)
                  .fontColor('#999999')
                  .textAlign(TextAlign.Center)
              }
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFF8E1')
            .borderRadius(8)
            
            // 操作按钮
            Row({ space: 12 }) {
              Button('重新起卦')
                .fontSize(16)
                .fontColor('#8E24AA')
                .backgroundColor('#F3E5F5')
                .layoutWeight(1)
                .onClick(() => {
                  this.qiGuaResult = null;
                  this.showResult = false;
                  this.question = '';
                  this.jieGuaResult = null;
                  this.showJieGua = false;
                })
              
              Button(this.jieGuaResult ? '查看解卦' : (this.isLoadingJieGua ? '解卦中...' : '重新解卦'))
                .fontSize(16)
                .fontColor('#FFFFFF')
                .backgroundColor(this.isLoadingJieGua ? '#CCCCCC' : '#FF6B35')
                .layoutWeight(1)
                .enabled(!this.isLoadingJieGua)
                .onClick(() => {
                  if (this.jieGuaResult) {
                    this.showJieGua = true;
                  } else {
                    this.performJieGuaAction();
                  }
                })
            }
            .width('100%')
            .margin({ top: 20, bottom: 20 })
          }
          .padding(20)
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Auto)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .bindSheet($$this.showQuestionInput, this.QuestionInputDialog(), {
      height: 300,
      dragBar: false,
      backgroundColor: Color.Transparent
    })
    .bindSheet($$this.showJieGua, this.JieGuaResultDialog(), {
      height: '80%',
      dragBar: false,
      backgroundColor: Color.Transparent
    })
  }
}