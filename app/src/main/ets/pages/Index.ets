import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State titleOpacity: number = 0;
  @State subtitleOpacity: number = 0;
  @State buttonsOpacity: number = 0;

  aboutToAppear(): void {
    // 标题动画
    animateTo({
      duration: 800,
      delay: 200,
      curve: Curve.EaseOut
    }, () => {
      this.titleOpacity = 1;
    });

    // 副标题动画
    animateTo({
      duration: 800,
      delay: 600,
      curve: Curve.EaseOut
    }, () => {
      this.subtitleOpacity = 1;
    });

    // 按钮动画
    animateTo({
      duration: 800,
      delay: 1000,
      curve: Curve.EaseOut
    }, () => {
      this.buttonsOpacity = 1;
    });
  }

  build() {
    Stack() {
      // 背景渐变
      Column()
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

      // 背景装饰图案
      Column() {
        Text('☰☷☳☴')
          .fontSize(120)
          .fontColor('rgba(255, 255, 255, 0.03)')
          .margin({ top: 80 })
        Text('☵☲☶☱')
          .fontSize(120)
          .fontColor('rgba(255, 255, 255, 0.03)')
          .margin({ top: 20 })
      }
      .width('100%')

      // 主内容（添加滚动容器）
      Scroll() {
        Column({ space: 40 }) {
          // 主标题
          Column({ space: 15 }) {
            Text('类象万物')
              .fontSize(56)
              .fontWeight(700)
              .fontColor('#FFD700')
              .letterSpacing(8)
              .opacity(this.titleOpacity)
              .textShadow({
                radius: 20,
                color: 'rgba(255, 215, 0, 0.5)',
                offsetX: 0,
                offsetY: 0
              })

            Text('Analogical Categorization')
              .fontSize(18)
              .fontColor('rgba(255, 215, 0, 0.7)')
              .letterSpacing(2)
              .opacity(this.titleOpacity)
          }
          .margin({ top: 80 })

          // 副标题
          Column({ space: 12 }) {
            this.createSubtitleItem('八卦 · 天干地支 · 纳音 · 六十四卦', '☯')
            this.createSubtitleItem('易学类象知识库', '📖')
          }
          .opacity(this.subtitleOpacity)
          .margin({ top: 20 })

          // 导航按钮
          Column({ space: 20 }) {
            this.createNavButton(
              '八卦类象',
              '☰☷☳☴☵☲☶☱',
              '#E74C3C',
              'pages/BaguaPage'
            )

            this.createNavButton(
              '天干地支类象',
              '甲乙丙丁  子丑寅卯',
              '#3498DB',
              'pages/GanZhiPage'
            )

            this.createNavButton(
              '六十甲子纳音',
              '海中金  炉中火  大林木',
              '#9C27B0',
              'pages/NaYinPage'
            )

            this.createNavButton(
              '六十四卦详解',
              '乾坤屯蒙  需讼师比',
              '#F39C12',
              'pages/LiuShiSiGuaPage'
            )

            this.createNavButton(
              '六十四卦卦数图',
              '象数合一  先天卦数',
              '#00BCD4',
              'pages/GuaShuPage'
            )

            this.createNavButton(
              '京房八宫卦',
              '世应易学  六爻占卜',
              '#7B1FA2',
              'pages/JingFangPage'
            )

            this.createNavButton(
              '京房重卦法表格',
              '卦变规律  阴阳消长',
              '#4A148C',
              'pages/JingFangTablePage'
            )
          }
          .opacity(this.buttonsOpacity)
          .margin({ top: 40 })

          // 底部提示
          Text('点击卡片进入查询')
            .fontSize(14)
            .fontColor('rgba(255, 255, 255, 0.5)')
            .margin({ top: 30, bottom: 60 })
            .opacity(this.buttonsOpacity)
        }
        .width('100%')
        .padding({ left: 20, right: 20 })
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  createSubtitleItem(text: string, icon: string) {
    Row({ space: 8 }) {
      Text(icon)
        .fontSize(20)
      Text(text)
        .fontSize(16)
        .fontColor('rgba(255, 255, 255, 0.8)')
        .letterSpacing(2)
    }
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  createNavButton(title: string, subtitle: string, bgColor: string, route: string) {
    Column({ space: 12 }) {
      Text(title)
        .fontSize(24)
        .fontWeight(600)
        .fontColor('#FFFFFF')
        .letterSpacing(3)

      Text(subtitle)
        .fontSize(16)
        .fontColor('rgba(255, 255, 255, 0.9)')
        .letterSpacing(4)
    }
    .width('85%')
    .padding({ top: 25, bottom: 25 })
    .backgroundColor(bgColor)
    .borderRadius(16)
    .shadow({
      radius: 20,
      color: bgColor + '40',
      offsetX: 0,
      offsetY: 8
    })
    .onClick(() => {
      router.pushUrl({
        url: route
      });
    })
    .animation({
      duration: 200,
      curve: Curve.Sharp
    })
  }
}