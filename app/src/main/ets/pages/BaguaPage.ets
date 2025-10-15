import { router } from '@kit.ArkUI';
import { loadBaguaData, BaguaItem, LeiXiangCategory } from '../model/BaguaData';

@Entry
@Component
struct BaguaPage {
  @State baguaList: BaguaItem[] = [];
  @State selectedBagua: BaguaItem | null = null;
  @State showDetail: boolean = false;
  @State isLoading: boolean = true;
  private scroller: Scroller = new Scroller();

  async aboutToAppear() {
    try {
      this.baguaList = await loadBaguaData();
      this.isLoading = false;
    } catch (error) {
      console.error('加载八卦数据失败:', error);
      this.isLoading = false;
    }
  }

  // 拦截系统返回键
  onBackPress(): boolean | void {
    console.log('八卦页面系统返回键被按下，当前showDetail状态:', this.showDetail);
    if (this.showDetail) {
      // 如果在详情页，返回到列表页
      this.showDetail = false;
      this.selectedBagua = null;
      console.log('拦截返回，回到八卦列表页');
      return true; // 返回true表示消费了这个返回事件
    }
    // 如果在列表页，返回false让系统处理
    console.log('在八卦列表页，交给系统处理返回');
    return false;
  }

  build() {
    Column() {
      // 顶部导航栏
      this.buildHeader();

      // 主内容区域
      if (!this.showDetail) {
        // 八卦网格列表
        this.buildBaguaGrid();
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
          console.log('八卦页面返回按钮点击，当前showDetail状态:', this.showDetail);
          if (this.showDetail) {
            // 从详情页返回到列表页
            this.showDetail = false;
            this.selectedBagua = null;
            console.log('返回到八卦列表页');
          } else {
            // 从列表页返回到首页
            console.log('返回到首页');
            router.back();
          }
        })

      Text(this.showDetail && this.selectedBagua ? this.selectedBagua.name : '八卦类象')
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#FFFFFF')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Row()
        .width(24)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#E74C3C')
  }



  @Builder
  buildBaguaGrid() {
    Column() {
      if (this.isLoading) {
        Text('加载中...')
          .fontSize(16)
          .fontColor('#999')
          .margin({ top: 100 })
      } else {
        Scroll(this.scroller) {
          Column({ space: 16 }) {
            // 标题提示
            Text('请选择八卦')
              .fontSize(16)
              .fontColor('#7F8C8D')
              .margin({ top: 20, bottom: 4 })

            GridRow({
              columns: 2,
              gutter: { x: 12, y: 12 }
            }) {
              ForEach(this.baguaList, (item: BaguaItem) => {
                GridCol() {
                  this.buildBaguaCard(item);
                }
              })
            }
            .width('100%')
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
  buildBaguaCard(item: BaguaItem) {
    Column({ space: 12 }) {
      // 八卦符号
      Text(item.symbol)
        .fontSize(48)
        .fontColor('#E74C3C')

      // 八卦名称
      Text(item.name)
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#2C3E50')

      // 基本象义（显示前3个）
      Column({ space: 6 }) {
        ForEach(item.basicInfo.slice(0, 3), (meaning: string, index: number) => {
          Text(meaning)
            .fontSize(13)
            .fontColor('#7F8C8D')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        })
      }
      .width('100%')

      // 查看详情按钮
      Text('查看详情 →')
        .fontSize(13)
        .fontColor('#E74C3C')
        .margin({ top: 8 })
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: 'rgba(231, 76, 60, 0.12)',
      offsetX: 0,
      offsetY: 4
    })
    .onClick(() => {
      this.selectedBagua = item;
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
        // 顶部卡片
        Column({ space: 16 }) {
          Text(this.selectedBagua ? this.selectedBagua.symbol : '')
            .fontSize(80)
            .fontColor('#E74C3C')

          Text(this.selectedBagua ? this.selectedBagua.name : '')
            .fontSize(28)
            .fontWeight(700)
            .fontColor('#2C3E50')

          // 基本象义
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
            ForEach(this.selectedBagua ? this.selectedBagua.basicInfo : [], (meaning: string) => {
              Text(meaning)
                .fontSize(14)
                .fontColor('#E74C3C')
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .backgroundColor('rgba(231, 76, 60, 0.1)')
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
          color: 'rgba(231, 76, 60, 0.15)',
          offsetX: 0,
          offsetY: 4
        })

        // 分类详情
        ForEach(this.selectedBagua ? this.selectedBagua.categories : [], (category: LeiXiangCategory) => {
          this.buildCategorySection(category);
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 24 })
    }
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1)
  }

  @Builder
  buildCategorySection(category: LeiXiangCategory) {
    Column({ space: 12 }) {
      // 分类标题
      Row() {
        Text('●')
          .fontSize(16)
          .fontColor('#E74C3C')
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
