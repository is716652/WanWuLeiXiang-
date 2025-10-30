/**
 * 卦气值日页面
 * 基于冬至节气的60卦轮值系统
 */

import { YearGuaQi, GuaQiItem, generateGuaQiTable, getGuaQiColor } from '../model/GuaQiData';
import { YearFenGuaZhiRi, FenGuaZhiRiItem, YaoInfo, generateFenGuaZhiRiTable, getYaoColor } from '../model/FenGuaZhiRiData';
import router from '@ohos.router';

@Entry
@Component
struct GuaQiPage {
  @State currentYear: number = new Date().getFullYear(); // 当前年份
  @State selectedYear: number = new Date().getFullYear(); // 选择的年份
  @State yearGuaQi: YearGuaQi | null = null;
  @State yearFenGuaZhiRi: YearFenGuaZhiRi | null = null; // 分卦值日数据
  @State showYearPicker: boolean = false;
  @State expandedGuaIndex: number = -1; // 展开的卦索引，-1表示都不展开

  // 年份选择范围 (2010-2040)
  private yearRange: number[] = [];

  aboutToAppear() {
    // 初始化年份范围 (2010-2040)
    for (let year = 2010; year <= 2040; year++) {
      this.yearRange.push(year);
    }
    // 加载当前年份的卦气值日表
    this.loadGuaQiTable(this.currentYear);
  }

  /**
   * 加载指定年份的卦气值日表
   */
  loadGuaQiTable(year: number) {
    try {
      const result = generateGuaQiTable(year);
      this.yearGuaQi = result;
      
      // 同时加载分卦值日数据
      const fenGuaResult = generateFenGuaZhiRiTable(year);
      this.yearFenGuaZhiRi = fenGuaResult;
      
      this.selectedYear = year;
      this.expandedGuaIndex = -1; // 重置展开状态
    } catch (error) {
      console.error(`加载${year}年卦气值日表失败:`, error);
    }
  }

  /**
   * 年份选择器
   */
  @Builder
  YearPickerDialog() {
    Column() {
      Text('选择年份')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      // 年份网格 - 使用滚动列表
      List({ space: 8 }) {
        ForEach(this.yearRange, (year: number) => {
          ListItem() {
            Text(year.toString())
              .fontSize(16)
              .fontColor(year === this.selectedYear ? '#FFFFFF' : '#333333')
              .textAlign(TextAlign.Center)
              .width('100%')
              .height(44)
              .backgroundColor(year === this.selectedYear ? '#8E24AA' : '#F5F5F5')
              .borderRadius(8)
              .onClick(() => {
                this.loadGuaQiTable(year);
                this.showYearPicker = false;
              })
          }
        })
      }
      .width('100%')
      .height(300)
      .scrollBar(BarState.Auto)

      Button('取消')
        .fontSize(16)
        .fontColor('#8E24AA')
        .backgroundColor('#F5F5F5')
        .width('100%')
        .height(44)
        .margin({ top: 20 })
        .onClick(() => {
          this.showYearPicker = false;
        })
    }
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .width('90%')
  }

  /**
   * 分卦值日详情组件
   */
  @Builder
  FenGuaZhiRiDetail(fenGuaItem: FenGuaZhiRiItem) {
    Column({ space: 8 }) {
      // 分卦值日标题
      Row() {
        Text('📅')
          .fontSize(16)
          .margin({ right: 8 })
        
        Text('分卦值日 - 六爻分日')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#8E24AA')
          .layoutWeight(1)
        
        Text('自下而上')
          .fontSize(11)
          .fontColor('#999999')
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .padding({ top: 8, bottom: 4 })

      // 六爻值日列表
      Column({ space: 6 }) {
        ForEach(fenGuaItem.yaoList, (yao: YaoInfo) => {
          this.YaoInfoCard(yao)
        })
      }
      .width('100%')

      // 分卦值日说明
      Text('根据"分卦值日法"，每卦6天分别由六爻统领，从初爻到上爻，自下而上依次主导每日气候变化。')
        .fontSize(10)
        .fontColor('#999999')
        .textAlign(TextAlign.Start)
        .width('100%')
        .lineHeight(14)
        .margin({ top: 8 })
    }
    .padding({ top: 12 })
    .borderColor('#E0E0E0')
    .borderWidth({ top: 1 })
  }

  /**
   * 爻位信息卡片
   */
  @Builder
  YaoInfoCard(yao: YaoInfo) {
    Column({ space: 6 }) {
      // 爻位和爻象
      Row() {
        Text(`第${yao.dayIndex}日`)
          .fontSize(12)
          .fontColor('#666666')
          .width(50)
        
        Text(yao.yaoPosition)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .width(50)
        
        Text(yao.yaoSymbol)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(getYaoColor(yao.yaoSymbol))
          .layoutWeight(1)
        
        Text(yao.date)
          .fontSize(12)
          .fontColor('#8E24AA')
          .backgroundColor('#F3E5F5')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(8)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      // 爻辞
      Text(yao.yaoText)
        .fontSize(12)
        .fontColor('#555555')
        .fontStyle(FontStyle.Italic)
        .width('100%')
        .textAlign(TextAlign.Start)

      // 爻义解释
      Text(yao.yaoMeaning)
        .fontSize(11)
        .fontColor('#777777')
        .width('100%')
        .textAlign(TextAlign.Start)
        .lineHeight(16)
    }
    .padding(12)
    .backgroundColor('#F8F9FA')
    .borderRadius(8)
    .width('100%')
  }

  /**
   * 卦气项目卡片（支持展开分卦值日）
   */
  @Builder
  GuaQiItemCard(item: GuaQiItem, index: number) {
    Column({ space: 8 }) {
      // 主卦信息（可点击展开）
      Column({ space: 8 }) {
        // 卦名和序号
        Row() {
          Text(`${item.index}`)
            .fontSize(12)
            .fontColor('#666666')
            .width(30)
          
          Text(item.guaName)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(getGuaQiColor(item.guaName))
            .layoutWeight(1)
          
          Text(item.solarTerm)
            .fontSize(12)
            .fontColor('#8E24AA')
            .backgroundColor('#F3E5F5')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(12)
          
          // 展开/收起图标
          Text(this.expandedGuaIndex === index ? '▼' : '▶')
            .fontSize(12)
            .fontColor('#8E24AA')
            .margin({ left: 8 })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        // 时间段
        Column({ space: 4 }) {
          Row() {
            Text('开始：')
              .fontSize(12)
              .fontColor('#666666')
              .width(40)
            Text(item.startTime)
              .fontSize(12)
              .fontColor('#333333')
          }
          .width('100%')

          Row() {
            Text('结束：')
              .fontSize(12)
              .fontColor('#666666')
              .width(40)
            Text(item.endTime)
              .fontSize(12)
              .fontColor('#333333')
          }
          .width('100%')

          Row() {
            Text('时长：')
              .fontSize(12)
              .fontColor('#666666')
              .width(40)
            Text(item.duration)
              .fontSize(12)
              .fontColor('#333333')
          }
          .width('100%')
        }

        // 卦气特征
        Text(item.guaQiFeature)
          .fontSize(13)
          .fontColor('#555555')
          .fontStyle(FontStyle.Italic)
          .textAlign(TextAlign.Start)
          .width('100%')
          .margin({ top: 4 })
        
        // 分卦值日提示
        Text('点击展开分卦值日详情 (六爻分日)')
          .fontSize(11)
          .fontColor('#8E24AA')
          .textAlign(TextAlign.Center)
          .width('100%')
          .margin({ top: 4 })
      }
      .onClick(() => {
        // 切换展开状态
        if (this.expandedGuaIndex === index) {
          this.expandedGuaIndex = -1; // 收起
        } else {
          this.expandedGuaIndex = index; // 展开
        }
      })

      // 分卦值日详情（展开时显示）
      if (this.expandedGuaIndex === index && this.yearFenGuaZhiRi && this.yearFenGuaZhiRi.fenGuaList[index]) {
        this.FenGuaZhiRiDetail(this.yearFenGuaZhiRi.fenGuaList[index])
      }
    }
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({
      radius: 4,
      color: '#1A000000',
      offsetX: 0,
      offsetY: 2
    })
    .width('100%')
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

        Text('卦气值日')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button('选择年份')
          .fontSize(14)
          .fontColor('#8E24AA')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.showYearPicker = true;
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      if (this.yearGuaQi) {
        // 正常显示卦气值日表
        Column() {
          // 年份和冬至信息
          Column({ space: 8 }) {
            Text(`${this.yearGuaQi.year}年卦气值日表`)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
            
            Text(`冬至起始：${this.yearGuaQi.dongzhiDate}`)
              .fontSize(14)
              .fontColor('#666666')
            
            Text('基于"六日七分"规则，每卦值日6天2.1小时')
              .fontSize(12)
              .fontColor('#999999')
            
            Text('六十卦轮值，四正卦（坎离震兑）主管节气')
              .fontSize(12)
              .fontColor('#999999')
            
            Text('点击卦气卡片可展开\"分卦值日\"，查看六爻分日详情')
              .fontSize(12)
              .fontColor('#FF6B35')
              .fontWeight(FontWeight.Medium)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#F8F9FA')

          // 卦气值日列表
          List({ space: 12 }) {
            ForEach(this.yearGuaQi.guaQiList, (item: GuaQiItem, index: number) => {
              ListItem() {
                this.GuaQiItemCard(item, index)
              }
            })
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
          .scrollBar(BarState.Auto)
        }
        .width('100%')
        .height('100%')
      } else {
        // 加载状态
        Column({ space: 16 }) {
          Text('📅')
            .fontSize(40)
          
          Text('正在生成卦气值日表...')
            .fontSize(14)
            .fontColor('#666666')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .bindSheet($$this.showYearPicker, this.YearPickerDialog(), {
      height: 500,
      dragBar: false,
      backgroundColor: Color.Transparent
    })
  }
}