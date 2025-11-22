import { router } from '@kit.ArkUI';
import { TianGanItem, DiZhiItem, LeiXiangCategory } from '../model/DataTypes';
import { loadTianGanData, loadDiZhiData } from '../model/GanZhiData';

@Entry
@Component
struct GanZhiPage {
  @State currentTab: number = 0; // 0: 天干, 1: 地支
  @State selectedTianGan: TianGanItem | null = null;
  @State selectedDiZhi: DiZhiItem | null = null;
  @State showDetail: boolean = false;
  @State tianGanList: TianGanItem[] = []; // 天干数据
  @State diZhiList: DiZhiItem[] = []; // 地支数据
  @State isLoading: boolean = true; // 加载状态
  private scroller: Scroller = new Scroller();

  async aboutToAppear() {
    // 异步加载数据
    try {
      this.tianGanList = await loadTianGanData();
      this.diZhiList = await loadDiZhiData();
      this.isLoading = false;
    } catch (error) {
      console.error('加载数据失败:', error);
      this.isLoading = false;
    }
  }

  // 拦截系统返回键
  onBackPress(): boolean | void {
    console.log('系统返回键被按下，当前showDetail状态:', this.showDetail);
    if (this.showDetail) {
      // 如果在详情页，返回到列表页
      this.showDetail = false;
      this.selectedTianGan = null;
      this.selectedDiZhi = null;
      console.log('拦截返回，回到列表页');
      return true; // 返回true表示消费了这个返回事件，不再继续向上传递
    }
    // 如果在列表页，返回false让系统处理（跳转到上一个页面）
    console.log('在列表页，交给系统处理返回');
    return false;
  }

  build() {
    Column() {
      // 顶部导航栏
      this.buildHeader();

      // Tab切换栏
      if (!this.showDetail) {
        this.buildTabBar();
      }

      // 主内容区域
      if (!this.showDetail) {
        // 列表视图
        if (this.currentTab === 0) {
          this.buildTianGanList();
        } else {
          this.buildDiZhiList();
        }
      } else {
        // 详情页
        this.buildDetailView();
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7FA')
  }

  @Builder
  buildHeader() {
    Row() {
      Image($r('sys.symbol.chevron_left'))
        .width(24)
        .height(24)
        .fillColor('#FFFFFF')
        .onClick(() => {
          console.log('返回按钮点击，当前showDetail状态:', this.showDetail);
          if (this.showDetail) {
            // 从详情页返回到列表页
            this.showDetail = false;
            this.selectedTianGan = null;
            this.selectedDiZhi = null;
            console.log('返回到列表页');
          } else {
            // 从列表页返回到首页
            console.log('返回到首页');
            router.back();
          }
        })

      Text(this.showDetail ?
        (this.currentTab === 0 && this.selectedTianGan ? this.selectedTianGan.name :
          this.selectedDiZhi ? this.selectedDiZhi.name : '类象详情') :
        '天干地支类象')
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#FFFFFF')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Button() {
        Text('🤖').fontSize(18).fontColor('#FFFFFF')
      }
        .width(36).height(36)
        .backgroundColor('rgba(255,255,255,0.15)')
        .borderRadius(18)
        .onClick(() => { router.pushUrl({ url: 'pages/BaiXiaoShengPanel' }); })
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#3498DB')
  }

  @Builder
  buildTabBar() {
    Row() {
      this.buildTabItem('天干', 0);
      this.buildTabItem('地支', 1);
    }
    .width('90%')
    .height(48)
    .backgroundColor('#FFFFFF')
    .borderRadius(24)
    .padding(4)
    .margin({ left: 16, right: 16, top: 16, bottom: 12 })
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.08)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  buildTabItem(title: string, index: number) {
    Text(title)
      .fontSize(16)
      .fontWeight(this.currentTab === index ? 600 : 400)
      .fontColor(this.currentTab === index ? '#FFFFFF' : '#7F8C8D')
      .layoutWeight(1)
      .textAlign(TextAlign.Center)
      .height(40)
      .borderRadius(20)
      .backgroundColor(this.currentTab === index ? '#3498DB' : Color.Transparent)
      .onClick(() => {
        this.currentTab = index;
      })
      .animation({
        duration: 300,
        curve: Curve.EaseInOut
      })
  }



  @Builder
  buildTianGanList() {
    Column() {
      if (this.isLoading) {
        Text('加载中...')
          .fontSize(16)
          .fontColor('#999')
          .margin({ top: 100 })
      } else {
        Scroll(this.scroller) {
          Column({ space: 12 }) {
            // 标题提示
            Text('请选择天干')
              .fontSize(16)
              .fontColor('#7F8C8D')
              .margin({ top: 16, bottom: 4 })

            ForEach(this.tianGanList, (item: TianGanItem) => {
              this.buildTianGanCard(item);
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 20 })
        }
        .scrollBar(BarState.Auto)
        .edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1)
      }
    }
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  buildTianGanCard(item: TianGanItem) {
    Row() {
      // 左侧天干标识
      Column({ space: 4 }) {
        Text(item.name.substring(0, 1))
          .fontSize(32)
          .fontWeight(700)
          .fontColor('#3498DB')

        Text(item.type)
          .fontSize(12)
          .fontColor('#7F8C8D')
      }
      .width(80)
      .justifyContent(FlexAlign.Center)

      // 中间内容
      Column({ space: 8 }) {
        Text(item.name)
          .fontSize(18)
          .fontWeight(600)
          .fontColor('#2C3E50')

        // 基本信息标签
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(item.basicInfo.slice(0, 3), (info: string) => {
            Text(info)
              .fontSize(12)
              .fontColor('#3498DB')
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .backgroundColor('rgba(52, 152, 219, 0.1)')
              .borderRadius(8)
              .margin({ right: 6, bottom: 6 })
          })
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 右侧箭头
      Image($r('sys.symbol.chevron_right'))
        .width(20)
        .height(20)
        .fillColor('#CCCCCC')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(() => {
      this.selectedTianGan = item;
      this.showDetail = true;
    })
    .animation({
      duration: 200,
      curve: Curve.Sharp
    })
  }

  @Builder
  buildDiZhiList() {
    Column() {
      if (this.isLoading) {
        Text('加载中...')
          .fontSize(16)
          .fontColor('#999')
          .margin({ top: 100 })
      } else {
        Scroll(this.scroller) {
          Column({ space: 12 }) {
            // 标题提示
            Text('请选择地支')
              .fontSize(16)
              .fontColor('#7F8C8D')
              .margin({ top: 16, bottom: 4 })

            ForEach(this.diZhiList, (item: DiZhiItem) => {
              this.buildDiZhiCard(item);
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 20 })
        }
        .scrollBar(BarState.Auto)
        .edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1)
      }
    }
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  buildDiZhiCard(item: DiZhiItem) {
    Row() {
      // 左侧地支标识
      Column({ space: 4 }) {
        Text(item.name.substring(0, 1))
          .fontSize(32)
          .fontWeight(700)
          .fontColor('#9B59B6')

        Text(item.direction)
          .fontSize(11)
          .fontColor('#7F8C8D')
          .textAlign(TextAlign.Center)
          .width(70)
          .maxLines(1)
      }
      .width(80)
      .justifyContent(FlexAlign.Center)

      // 中间内容
      Column({ space: 8 }) {
        Row({ space: 8 }) {
          Text(item.name)
            .fontSize(18)
            .fontWeight(600)
            .fontColor('#2C3E50')

          Text(item.nature)
            .fontSize(12)
            .fontColor('#9B59B6')
            .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            .backgroundColor('rgba(155, 89, 182, 0.1)')
            .borderRadius(8)
        }

        // 特征标签
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(item.features.slice(0, 3), (feature: string) => {
            Text(feature)
              .fontSize(12)
              .fontColor('#7F8C8D')
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .backgroundColor('#F8F9FA')
              .borderRadius(8)
              .margin({ right: 6, bottom: 6 })
          })
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 右侧箭头
      Image($r('sys.symbol.chevron_right'))
        .width(20)
        .height(20)
        .fillColor('#CCCCCC')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(() => {
      this.selectedDiZhi = item;
      this.showDetail = true;
    })
    .animation({
      duration: 200,
      curve: Curve.Sharp
    })
  }

  @Builder
  buildDetailView() {
    Scroll() {
      Column({ space: 20 }) {
        if (this.currentTab === 0 && this.selectedTianGan) {
          // 天干详情
          this.buildTianGanDetail(this.selectedTianGan);
        } else if (this.currentTab === 1 && this.selectedDiZhi) {
          // 地支详情
          this.buildDiZhiDetail(this.selectedDiZhi);
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 24 })
    }
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1)
  }

  @Builder
  buildTianGanDetail(item: TianGanItem) {
    Column({ space: 20 }) {
      // 顶部卡片
      Column({ space: 16 }) {
        Text(item.name.substring(0, 1))
          .fontSize(80)
          .fontWeight(700)
          .fontColor('#3498DB')

        Text(item.name)
          .fontSize(28)
          .fontWeight(700)
          .fontColor('#2C3E50')

        Text(item.type)
          .fontSize(16)
          .fontColor('#7F8C8D')

        // 基本信息
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
          ForEach(item.basicInfo, (info: string) => {
            Text(info)
              .fontSize(14)
              .fontColor('#3498DB')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor('rgba(52, 152, 219, 0.1)')
              .borderRadius(12)
              .margin(4)
          })
        }
        .width('90%')
      }
      .width('100%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(20)
      .shadow({
        radius: 16,
        color: 'rgba(52, 152, 219, 0.15)',
        offsetX: 0,
        offsetY: 4
      })

      // 分类详情
      ForEach(item.categories, (category: LeiXiangCategory) => {
        this.buildCategorySection(category, '#3498DB');
      })
    }
  }

  @Builder
  buildDiZhiDetail(item: DiZhiItem) {
    Column({ space: 20 }) {
      // 顶部卡片
      Column({ space: 16 }) {
        Text(item.name.substring(0, 1))
          .fontSize(80)
          .fontWeight(700)
          .fontColor('#9B59B6')

        Text(item.name)
          .fontSize(28)
          .fontWeight(700)
          .fontColor('#2C3E50')

        Column({ space: 8 }) {
          Text(item.direction)
            .fontSize(16)
            .fontColor('#7F8C8D')

          Text(item.nature)
            .fontSize(15)
            .fontColor('#9B59B6')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('rgba(155, 89, 182, 0.1)')
            .borderRadius(12)
        }

        // 特征标签
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
          ForEach(item.features, (feature: string) => {
            Text(feature)
              .fontSize(14)
              .fontColor('#9B59B6')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor('rgba(155, 89, 182, 0.1)')
              .borderRadius(12)
              .margin(4)
          })
        }
        .width('90%')
      }
      .width('100%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(20)
      .shadow({
        radius: 16,
        color: 'rgba(155, 89, 182, 0.15)',
        offsetX: 0,
        offsetY: 4
      })

      // 分类详情
      ForEach(item.categories, (category: LeiXiangCategory) => {
        this.buildCategorySection(category, '#9B59B6');
      })
    }
  }

  @Builder
  buildCategorySection(category: LeiXiangCategory, themeColor: string) {
    Column({ space: 12 }) {
      // 分类标题
      Row() {
        Text('●')
          .fontSize(16)
          .fontColor(themeColor)
          .margin({ right: 8 })

        Text(category.name)
          .fontSize(18)
          .fontWeight(600)
          .fontColor('#2C3E50')
      }

      // 分类内容
      Column({ space: 10 }) {
        ForEach(category.items, (item: string, index: number) => {
          Row({ space: 8 }) {
            Text(`${index + 1}.`)
              .fontSize(13)
              .fontColor('#95A5A6')
              .width(24)

            Text(item)
              .fontSize(14)
              .fontColor('#34495E')
              .layoutWeight(1)
              .lineHeight(22)
          }
          .width('100%')
          .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          .backgroundColor('#F8F9FA')
          .borderRadius(8)
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }
}
