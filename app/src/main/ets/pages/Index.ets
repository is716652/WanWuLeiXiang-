import { router } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';

@Entry
@Component
struct Index {
  @State titleOpacity: number = 0;
  @State subtitleOpacity: number = 0;
  @State buttonsOpacity: number = 0;
  @State showAgreementDialog: boolean = false;

  async aboutToAppear(): Promise<void> {
    // 检查是否首次访问
    await this.checkFirstVisit();

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

  // 检查是否首次访问
  async checkFirstVisit(): Promise<void> {
    try {
      const dataPreferences = await preferences.getPreferences(getContext(this), 'appSettings');
      const hasAgreed = await dataPreferences.get('hasAgreedToTerms', false);
      
      if (!hasAgreed) {
        // 首次访问，显示协议弹窗
        this.showAgreementDialog = true;
      }
    } catch (err) {
      console.error('检查首次访问失败:', err);
    }
  }

  // 同意协议
  async agreeToTerms(): Promise<void> {
    try {
      const dataPreferences = await preferences.getPreferences(getContext(this), 'appSettings');
      await dataPreferences.put('hasAgreedToTerms', true);
      await dataPreferences.flush();
      this.showAgreementDialog = false;
    } catch (err) {
      console.error('保存协议状态失败:', err);
    }
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
              '汉代象数易学',
              '京房易学  纳甲卦气  世应占卜',
              '#7B1FA2',
              'pages/HanDaiPage'
            )

            this.createNavButton(
              '小成图专业版',
              '九宫装卦  四象占法  用神取用',
              '#FF6B35',
              'pages/XiaoChengTuProPage'
            )
          }
          .opacity(this.buttonsOpacity)
          .margin({ top: 40 })

          // 底部提示和协议入口
          Column({ space: 16 }) {
            Text('点击卡片进入查询')
              .fontSize(14)
              .fontColor('rgba(255, 255, 255, 0.5)')

            // 用户协议和隐私政策入口
            Row({ space: 20 }) {
              Text('用户协议')
                .fontSize(12)
                .fontColor('rgba(255, 255, 255, 0.6)')
                .onClick(() => {
                  router.pushUrl({ url: 'pages/Legal/UserAgreement' });
                })

              Text('|')
                .fontSize(12)
                .fontColor('rgba(255, 255, 255, 0.3)')

              Text('隐私政策')
                .fontSize(12)
                .fontColor('rgba(255, 255, 255, 0.6)')
                .onClick(() => {
                  router.pushUrl({ url: 'pages/Legal/PrivacyPolicy' });
                })
            }
            .justifyContent(FlexAlign.Center)
          }
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

      // 用户协议弹窗
      if (this.showAgreementDialog) {
        Column() {
          Column({ space: 20 }) {
            // 标题
            Text('用户协议与隐私政策')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')

            // 内容
            Column({ space: 12 }) {
              Text('欢迎使用万物类象APP！')
                .fontSize(16)
                .fontColor('#333333')
                .width('100%')

              Text('在使用我们的服务前，请您仔细阅读并同意：')
                .fontSize(14)
                .fontColor('#666666')
                .width('100%')

              Row({ space: 4 }) {
                Text('《')
                  .fontSize(14)
                  .fontColor('#666666')
                Text('用户协议')
                  .fontSize(14)
                  .fontColor('#1E88E5')
                  .decoration({ type: TextDecorationType.Underline })
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/Legal/UserAgreement' });
                  })
                Text('》和《')
                  .fontSize(14)
                  .fontColor('#666666')
                Text('隐私政策')
                  .fontSize(14)
                  .fontColor('#1E88E5')
                  .decoration({ type: TextDecorationType.Underline })
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/Legal/PrivacyPolicy' });
                  })
                Text('》')
                  .fontSize(14)
                  .fontColor('#666666')
              }
              .width('100%')

              Text('当前版本不收集您的个人信息，无需账号即可浏览所有内容。')
                .fontSize(13)
                .fontColor('#999999')
                .width('100%')
                .margin({ top: 8 })
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#F5F5F5')
            .borderRadius(8)

            // 按钮
            Row({ space: 12 }) {
              Button('不同意并退出')
                .fontSize(14)
                .fontColor('#666666')
                .backgroundColor('#E0E0E0')
                .layoutWeight(1)
                .onClick(() => {
                  // 退出应用 - 返回并关闭
                  router.back();
                })

              Button('同意并继续')
                .fontSize(14)
                .fontColor('#FFFFFF')
                .backgroundColor('#1E88E5')
                .layoutWeight(1)
                .onClick(() => {
                  this.agreeToTerms();
                })
            }
            .width('100%')
          }
          .width('85%')
          .padding(24)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .shadow({
            radius: 30,
            color: 'rgba(0, 0, 0, 0.3)',
            offsetX: 0,
            offsetY: 10
          })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .justifyContent(FlexAlign.Center)
      }
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