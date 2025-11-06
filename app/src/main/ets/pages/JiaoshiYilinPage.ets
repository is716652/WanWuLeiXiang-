/**
 * 焦氏易林查询页面
 * 浏览和查询焦氏易林64卦内容
 */

import router from '@ohos.router';
import { resourceManager } from '@kit.LocalizationKit';
import util from '@ohos.util';

interface GuaInfo {
  guaName: string;
  guaNumber: number;
  guaSymbol: string;
  upperTrigram: string;
  lowerTrigram: string;
  upperTrigramMeaning: string;
  lowerTrigramMeaning: string;
  upperTrigramAttribute: string;
  lowerTrigramAttribute: string;
  description: string;
}

interface BenGuaInfo {
  text: string;
  yiyi: string;
  xiangzheng: string;
}

interface ZhiGuaInfo {
  targetGua: string;
  guaNumber: number;
  text: string;
  yiyi: string;
  xiangzheng: string;
}

interface JiaoshiYilinData {
  guaInfo: GuaInfo;
  benGua: BenGuaInfo;
  zhiGua: ZhiGuaInfo[];
}

@Entry
@Component
struct JiaoshiYilinPage {
  @State guaList: string[] = ['qian', 'kun', 'zhun', 'meng', 'xu', 'song', 'shi', 'bi', 'xiaoxu', 'lv', 'tai', 'pi', 'tongren', 'dayou', 'qian_modesty', 'yu', 'sui', 'gu', 'lin', 'guan', 'shihe'];
  @State guaNames: string[] = ['乾', '坤', '屯', '蒙', '需', '讼', '师', '比', '小畜', '履', '泰', '否', '同人', '大有', '谦', '豫', '随', '蛊', '临', '观', '噬嗑'];
  @State selectedGuaIndex: number = 0;
  @State currentGuaData: JiaoshiYilinData | null = null;
  @State selectedZhiGuaIndex: number = -1;
  @State showZhiGuaDetail: boolean = false;
  @State searchText: string = '';
  @State showSearch: boolean = false;

  aboutToAppear() {
    this.loadGuaData(0);
  }

  /**
   * 加载卦数据
   */
  async loadGuaData(index: number) {
    try {
      const fileName = this.guaList[index];
      const context = getContext(this);
      const mgr = context.resourceManager;
      const fileData = await mgr.getRawFileContent(`JiaoshiYilin/${fileName}.json`);
      const textDecoder = util.TextDecoder.create('utf-8');
      const jsonString = textDecoder.decodeWithStream(fileData);
      this.currentGuaData = JSON.parse(jsonString) as JiaoshiYilinData;
    } catch (error) {
      console.error('加载卦数据失败:', error);
    }
  }

  /**
   * 卦选择器
   */
  @Builder
  GuaSelector() {
    Column({ space: 12 }) {
      Text('选择卦象')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')

      Grid() {
        ForEach(this.guaNames, (guaName: string, index: number) => {
          GridItem() {
            Column({ space: 4 }) {
              Text(`${index + 1}`)
                .fontSize(12)
                .fontColor(this.selectedGuaIndex === index ? '#FFFFFF' : '#666666')

              Text(guaName)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.selectedGuaIndex === index ? '#FFFFFF' : '#333333')
            }
            .width('100%')
            .height(50)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(this.selectedGuaIndex === index ? '#8E24AA' : '#F5F5F5')
            .borderRadius(8)
            .onClick(() => {
              this.selectedGuaIndex = index;
              this.loadGuaData(index);
              this.selectedZhiGuaIndex = -1;
              this.showZhiGuaDetail = false;
            })
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .columnsGap(8)
      .rowsGap(8)
      .width('100%')
      .height(240)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
  }

  /**
   * 本卦信息显示
   */
  @Builder
  BenGuaDisplay() {
    if (this.currentGuaData) {
      Column({ space: 16 }) {
        // 卦象基本信息
        Row({ space: 16 }) {
          Text(this.currentGuaData.guaInfo.guaSymbol)
            .fontSize(48)
            .fontColor('#8E24AA')

          Column({ space: 4 }) {
            Text(`第${this.currentGuaData.guaInfo.guaNumber}卦 ${this.currentGuaData.guaInfo.guaName}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')

            Text(`${this.currentGuaData.guaInfo.upperTrigramMeaning}上${this.currentGuaData.guaInfo.lowerTrigramMeaning}下`)
              .fontSize(14)
              .fontColor('#666666')

            Text(this.currentGuaData.guaInfo.description)
              .fontSize(12)
              .fontColor('#999999')
              .maxLines(2)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .alignItems(VerticalAlign.Center)

        // 本卦内容
        Column({ space: 12 }) {
          Text('本卦')
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

            Text(this.currentGuaData.benGua.text)
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

            Text(this.currentGuaData.benGua.yiyi)
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

            Text(this.currentGuaData.benGua.xiangzheng)
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
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
    }
  }

  /**
   * 之卦列表
   */
  @Builder
  ZhiGuaList() {
    if (this.currentGuaData) {
      Column({ space: 12 }) {
        Row() {
          Text(`之卦 (${this.currentGuaData?.zhiGua.length ?? 0}个)`) 
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
            .layoutWeight(1)

          Button('搜索')
            .fontSize(12)
            .fontColor('#8E24AA')
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              this.showSearch = !this.showSearch;
            })
        }
        .width('100%')

        if (this.showSearch) {
          TextInput({ placeholder: '搜索卦名或内容...' })
            .fontSize(14)
            .onChange((value: string) => {
              this.searchText = value;
            })
        }

        List({ space: 8 }) {
          ForEach(this.currentGuaData.zhiGua.filter((zhiGua: ZhiGuaInfo) => {
            if (!this.searchText) return true;
            return zhiGua.targetGua.includes(this.searchText) ||
                   zhiGua.text.includes(this.searchText) ||
                   zhiGua.yiyi.includes(this.searchText);
          }), (zhiGua: ZhiGuaInfo, index: number) => {
            ListItem() {
              Row({ space: 12 }) {
                Text(`${zhiGua.guaNumber}`)
                  .fontSize(12)
                  .fontColor('#FFFFFF')
                  .backgroundColor('#8E24AA')
                  .width(24)
                  .height(24)
                  .textAlign(TextAlign.Center)
                  .borderRadius(12)

                Column({ space: 4 }) {
                  Text(`${this.currentGuaData!.guaInfo.guaName}之${zhiGua.targetGua}`)
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#333333')
                    .width('100%')
                    .textAlign(TextAlign.Start)

                  Text(zhiGua.text.substring(0, 30) + (zhiGua.text.length > 30 ? '...' : ''))
                    .fontSize(12)
                    .fontColor('#666666')
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .maxLines(1)
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                Text('>')
                  .fontSize(16)
                  .fontColor('#CCCCCC')
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#FFFFFF')
              .borderRadius(8)
              .onClick(() => {
                this.selectedZhiGuaIndex = this.currentGuaData!.zhiGua.indexOf(zhiGua);
                this.showZhiGuaDetail = true;
              })
            }
          })
        }
        .width('100%')
        .height(400)
        .scrollBar(BarState.Auto)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
    }
  }

  /**
   * 之卦详情弹窗
   */
  @Builder
  ZhiGuaDetailDialog() {
    if (this.currentGuaData && this.selectedZhiGuaIndex >= 0) {
      Column({ space: 20 }) {
        Row() {
          Text(`${this.currentGuaData.guaInfo.guaName}之${this.currentGuaData.zhiGua[this.selectedZhiGuaIndex].targetGua}`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
            .layoutWeight(1)

          Button('×')
            .fontSize(20)
            .fontColor('#666666')
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              this.showZhiGuaDetail = false;
            })
        }
        .width('100%')

        Scroll() {
          Column({ space: 16 }) {
            Column({ space: 8 }) {
              Text('原文：')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .width('100%')
                .textAlign(TextAlign.Start)

              Text(this.currentGuaData.zhiGua[this.selectedZhiGuaIndex].text)
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

              Text(this.currentGuaData.zhiGua[this.selectedZhiGuaIndex].yiyi)
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

              Text(this.currentGuaData.zhiGua[this.selectedZhiGuaIndex].xiangzheng)
                .fontSize(12)
                .fontColor('#999999')
                .lineHeight(20)
                .width('100%')
                .textAlign(TextAlign.Start)
            }
          }
        }
        .height(300)
        .scrollBar(BarState.Auto)
      }
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .width('90%')
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

        Text('焦氏易林')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('')
          .width(60) // 占位，保持标题居中
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // 内容区域
      Scroll() {
        Column({ space: 16 }) {
          // 卦选择器
          this.GuaSelector()

          // 本卦显示
          this.BenGuaDisplay()

          // 之卦列表
          this.ZhiGuaList()
        }
        .padding(16)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Auto)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .bindSheet($$this.showZhiGuaDetail, this.ZhiGuaDetailDialog(), {
      height: 500,
      dragBar: false,
      backgroundColor: Color.Transparent
    })
  }
}