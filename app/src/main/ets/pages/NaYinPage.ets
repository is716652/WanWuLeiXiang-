import { router } from '@kit.ArkUI';
import { loadNaYinData, NaYinItem } from '../model/NaYinData';

@Entry
@Component
struct NaYinPage {
  @State naYinList: NaYinItem[] = [];
  @State selectedNaYin: NaYinItem | null = null;
  @State showDetail: boolean = false;
  @State isLoading: boolean = true;
  private scroller: Scroller = new Scroller();

  async aboutToAppear() {
    try {
      this.naYinList = await loadNaYinData();
      this.isLoading = false;
    } catch (error) {
      console.error('加载纳音数据失败:', error);
      this.isLoading = false;
    }
  }

  // 拦截系统返回键
  onBackPress(): boolean | void {
    console.log('纳音页面系统返回键被按下，当前showDetail状态:', this.showDetail);
    if (this.showDetail) {
      // 如果在详情页，返回到列表页
      this.showDetail = false;
      this.selectedNaYin = null;
      console.log('拦截返回，回到纳音列表页');
      return true;
    }
    // 如果在列表页，返回false让系统处理
    console.log('在纳音列表页，交给系统处理返回');
    return false;
  }

  build() {
    Column() {
      // 顶部导航栏
      this.buildHeader();

      // 主内容区域
      if (!this.showDetail) {
        // 纳音列表
        this.buildNaYinList();
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
          console.log('纳音页面返回按钮点击，当前showDetail状态:', this.showDetail);
          if (this.showDetail) {
            // 从详情页返回到列表页
            this.showDetail = false;
            this.selectedNaYin = null;
            console.log('返回到纳音列表页');
          } else {
            // 从列表页返回到首页
            console.log('返回到首页');
            router.back();
          }
        })

      Text(this.showDetail && this.selectedNaYin ? this.selectedNaYin.纳音 : '六十甲子纳音')
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
    .backgroundColor('#9C27B0')
  }

  @Builder
  buildNaYinList() {
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
            Text('请选择纳音')
              .fontSize(16)
              .fontColor('#7F8C8D')
              .margin({ top: 16, bottom: 4 })

            ForEach(this.naYinList, (item: NaYinItem) => {
              this.buildNaYinCard(item);
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
  buildNaYinCard(item: NaYinItem) {
    Row() {
      // 左侧标识
      Column({ space: 4 }) {
        Text(item.纳音)
          .fontSize(18)
          .fontWeight(700)
          .fontColor('#9C27B0')
          .textAlign(TextAlign.Center)

        Text(item.name)
          .fontSize(12)
          .fontColor('#7F8C8D')
          .textAlign(TextAlign.Center)
      }
      .width(100)
      .justifyContent(FlexAlign.Center)

      // 中间内容
      Column({ space: 8 }) {
        // 天干地支
        Row({ space: 8 }) {
          Text('天干:')
            .fontSize(13)
            .fontColor('#7F8C8D')
          Text(item.天干.join(' '))
            .fontSize(14)
            .fontColor('#2C3E50')
            .fontWeight(500)
        }

        Row({ space: 8 }) {
          Text('地支:')
            .fontSize(13)
            .fontColor('#7F8C8D')
          Text(item.地支.join(' '))
            .fontSize(14)
            .fontColor('#2C3E50')
            .fontWeight(500)
        }

        // 本义简述
        Text(item.象义.本义)
          .fontSize(13)
          .fontColor('#7F8C8D')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
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
      this.selectedNaYin = item;
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
          Text(this.selectedNaYin ? this.selectedNaYin.纳音 : '')
            .fontSize(32)
            .fontWeight(700)
            .fontColor('#9C27B0')

          Text(this.selectedNaYin ? this.selectedNaYin.name : '')
            .fontSize(20)
            .fontColor('#2C3E50')

          // 天干地支
          Row({ space: 20 }) {
            Row({ space: 8 }) {
              Text('天干:')
                .fontSize(14)
                .fontColor('#7F8C8D')
              Text(this.selectedNaYin ? this.selectedNaYin.天干.join(' ') : '')
                .fontSize(16)
                .fontColor('#9C27B0')
                .fontWeight(500)
            }

            Row({ space: 8 }) {
              Text('地支:')
                .fontSize(14)
                .fontColor('#7F8C8D')
              Text(this.selectedNaYin ? this.selectedNaYin.地支.join(' ') : '')
                .fontSize(16)
                .fontColor('#9C27B0')
                .fontWeight(500)
            }
          }
        }
        .width('100%')
        .padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(20)
        .shadow({
          radius: 16,
          color: 'rgba(156, 39, 176, 0.15)',
          offsetX: 0,
          offsetY: 4
        })

        // 象义详情
        if (this.selectedNaYin) {
          this.buildXiangYiSection('本义', this.selectedNaYin.象义.本义);
          this.buildXiangYiSection('性格', this.selectedNaYin.象义.性格);
          this.buildXiangYiSection('事业', this.selectedNaYin.象义.事业);
          this.buildXiangYiSection('感情', this.selectedNaYin.象义.感情);
          this.buildXiangYiSection('健康', this.selectedNaYin.象义.健康);
          this.buildXiangYiSection('风水', this.selectedNaYin.象义.风水);

          // 吉色吉数吉方
          this.buildMetaInfo();
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
  buildXiangYiSection(title: string, content: string) {
    Column({ space: 12 }) {
      // 标题
      Row() {
        Text('●')
          .fontSize(16)
          .fontColor('#9C27B0')
          .margin({ right: 8 })

        Text(title)
          .fontSize(18)
          .fontWeight(600)
          .fontColor('#2C3E50')
      }

      // 内容
      Text(content)
        .fontSize(14)
        .fontColor('#34495E')
        .lineHeight(24)
        .width('100%')
        .padding({ left: 12, right: 12, top: 12, bottom: 12 })
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
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

  @Builder
  buildMetaInfo() {
    Column({ space: 12 }) {
      Row() {
        Text('●')
          .fontSize(16)
          .fontColor('#9C27B0')
          .margin({ right: 8 })

        Text('吉祥参考')
          .fontSize(18)
          .fontWeight(600)
          .fontColor('#2C3E50')
      }

      Column({ space: 10 }) {
        // 吉色
        Row({ space: 12 }) {
          Text('吉色:')
            .fontSize(14)
            .fontColor('#7F8C8D')
            .width(60)
          Text(this.formatArrayOrString(this.selectedNaYin?.象义.吉色))
            .fontSize(14)
            .fontColor('#9C27B0')
            .fontWeight(500)
            .layoutWeight(1)
        }
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor('#F8F9FA')
        .borderRadius(8)

        // 吉数
        Row({ space: 12 }) {
          Text('吉数:')
            .fontSize(14)
            .fontColor('#7F8C8D')
            .width(60)
          Text(this.formatArrayOrString(this.selectedNaYin?.象义.吉数))
            .fontSize(14)
            .fontColor('#9C27B0')
            .fontWeight(500)
            .layoutWeight(1)
        }
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor('#F8F9FA')
        .borderRadius(8)

        // 吉方
        Row({ space: 12 }) {
          Text('吉方:')
            .fontSize(14)
            .fontColor('#7F8C8D')
            .width(60)
          Text(this.formatArrayOrString(this.selectedNaYin?.象义.吉方))
            .fontSize(14)
            .fontColor('#9C27B0')
            .fontWeight(500)
            .layoutWeight(1)
        }
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
      }
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

  private formatArrayOrString(value: string | string[] | number[] | undefined): string {
    if (!value) return '';
    if (Array.isArray(value)) {
      return value.join('、');
    }
    return value.toString();
  }
}
