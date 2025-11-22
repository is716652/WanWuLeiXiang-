/**
 * 汉代象数易学页面
 * 包含京房八宫卦、京房重卦法、纳甲配置、卦气值日等功能
 */

import router from '@ohos.router';

@Entry
@Component
struct HanDaiPage {
  @State buttonsOpacity: number = 0;

  aboutToAppear() {
    // 延迟显示按钮，创建动画效果
    setTimeout(() => {
      animateTo({
        duration: 800,
        curve: Curve.EaseOut
      }, () => {
        this.buttonsOpacity = 1;
      });
    }, 200);
  }

  /**
   * 创建导航按钮
   */
  @Builder
  createNavButton(title: string, subtitle: string, color: string, route: string) {
    Column({ space: 8 }) {
      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .textAlign(TextAlign.Center)
        .width('100%')

      Text(subtitle)
        .fontSize(12)
        .fontColor('#E0E0E0')
        .textAlign(TextAlign.Center)
        .width('100%')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(100)
    .padding(16)
    .backgroundColor(color)
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
    .shadow({
      radius: 8,
      color: '#1A000000',
      offsetX: 0,
      offsetY: 4
    })
    .onClick(() => {
      router.pushUrl({
        url: route
      });
    })
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

        Text('汉代象数易学')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button() {
          Text('🤖').fontSize(18).fontColor('#8E24AA')
        }
          .width(36).height(36)
          .backgroundColor('rgba(142,36,170,0.08)')
          .borderRadius(18)
          .onClick(() => { router.pushUrl({ url: 'pages/BaiXiaoShengPanel' }); })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // 可滚动的内容区域
      Scroll() {
        Column({ space: 20 }) {
          // 页面说明
          Column({ space: 8 }) {
            Text('汉代象数易学体系')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .textAlign(TextAlign.Center)

            Text('京房易学传承，象数理论精华')
              .fontSize(14)
              .fontColor('#666666')
              .textAlign(TextAlign.Center)

            Text('包含焦氏易林起卦、八宫卦序、纳甲配置、卦气值日等核心内容')
              .fontSize(12)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)
              .margin({ top: 8 })
          }
          .width('100%')
          .padding(20)

          // 功能按钮区域
          Column({ space: 16 }) {
            // 第一行：河图洛书
            this.createNavButton(
              '河图洛书',
              '天地生成之数  九宫数理结构',
              '#0D47A1',
              'pages/HeTuLuoShuPage'
            )

            // 第二行：先后天八卦图
            this.createNavButton(
              '先后天八卦图',
              '伏羲先天八卦  文王后天八卦',
              '#1A237E',
              'pages/XianTianBaGuaPage'
            )

            // 第三行：焦氏易林起卦
            this.createNavButton(
              '焦氏易林起卦',
              '六爻同时生成法  本卦之卦占验',
              '#3F51B5',
              'pages/QiGuaPage'
            )

            // 第四行：京房八宫卦
            this.createNavButton(
              '京房八宫卦',
              '世应易学  六爻占卜基础',
              '#4A148C',
              'pages/JingFangPage'
            )

            // 第五行：京房重卦法表格
            this.createNavButton(
              '京房重卦法表格',
              '卦变规律  阴阳消长',
              '#6A1B9A',
              'pages/JingFangTablePage'
            )

            // 第六行：纳甲配置表
            this.createNavButton(
              '纳甲配置表',
              '六爻基础  天干地支配卦',
              '#7B1FA2',
              'pages/NaJiaPage'
            )

            // 第七行：卦气值日
            this.createNavButton(
              '卦气值日',
              '六日七分  冬至起始六十卦轮值',
              '#8E24AA',
              'pages/GuaQiPage'
            )

            // 第八行：焦氏易林查询
            this.createNavButton(
              '焦氏易林查询',
              '浏览查询  已收录45卦易林内容',
              '#9C27B0',
              'pages/JiaoshiYilinPage'
            )
          }
          .width('100%')
          .padding({ left: 20, right: 20 })
          .opacity(this.buttonsOpacity)

          // 底部说明
          Column({ space: 8 }) {
            Text('汉代象数易学特色')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')

            Text('• 河图洛书：天地生成之数与九宫数理的象数基础')
              .fontSize(12)
              .fontColor('#666666')
              .textAlign(TextAlign.Start)
              .width('100%')

            Text('• 先后天八卦图：伏羲先天八卦与文王后天八卦的完整展示')
              .fontSize(12)
              .fontColor('#666666')
              .textAlign(TextAlign.Start)
              .width('100%')

            Text('• 焦氏易林起卦：六爻同时生成法，本卦之卦占验')
              .fontSize(12)
              .fontColor('#666666')
              .textAlign(TextAlign.Start)
              .width('100%')

            Text('• 京房八宫卦序：世应理论，六爻占卜核心')
              .fontSize(12)
              .fontColor('#666666')
              .textAlign(TextAlign.Start)
              .width('100%')

            Text('• 纳甲配置：天干地支与八卦的对应关系')
              .fontSize(12)
              .fontColor('#666666')
              .textAlign(TextAlign.Start)
              .width('100%')

            Text('• 卦气值日：基于"六日七分"的时间易学')
              .fontSize(12)
              .fontColor('#666666')
              .textAlign(TextAlign.Start)
              .width('100%')

            Text('• 重卦法表：卦变规律的系统化展示')
              .fontSize(12)
              .fontColor('#666666')
              .textAlign(TextAlign.Start)
              .width('100%')

            Text('• 焦氏易林查询：已收录45卦完整易林内容（新增夬、姤、萃）')
              .fontSize(12)
              .fontColor('#666666')
              .textAlign(TextAlign.Start)
              .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#F8F9FA')
          .borderRadius(12)
          .margin({ top: 20 })
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