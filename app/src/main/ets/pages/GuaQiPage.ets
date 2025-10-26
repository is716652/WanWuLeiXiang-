/**
 * 卦气值日页面
 * 基于冬至节气的60卦轮值系统
 */

import { YearGuaQi, GuaQiItem, generateGuaQiTable, getGuaQiColor } from '../model/GuaQiData';
import router from '@ohos.router';

@Entry
@Component
struct GuaQiPage {
  @State currentYear: number = new Date().getFullYear(); // 当前年份
  @State selectedYear: number = new Date().getFullYear(); // 选择的年份
  @State yearGuaQi: YearGuaQi | null = null;
  @State showYearPicker: boolean = false;

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
      this.selectedYear = year;
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
   * 卦气项目卡片
   */
  @Builder
  GuaQiItemCard(item: GuaQiItem) {
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
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#F8F9FA')

          // 卦气值日列表
          List({ space: 12 }) {
            ForEach(this.yearGuaQi.guaQiList, (item: GuaQiItem) => {
              ListItem() {
                this.GuaQiItemCard(item)
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