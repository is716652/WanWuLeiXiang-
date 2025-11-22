import { router } from '@kit.ArkUI';
import { loadBaguaData, BaguaItem, LeiXiangCategory } from '../model/BaguaData';
import { ExtendedLeiXiang, SubcategoryItem, ExtendedDataFile } from '../model/DataTypes';
import { resourceManager } from '@kit.LocalizationKit';
import util from '@ohos.util';

@Entry
@Component
struct BaguaPage {
  @State baguaList: BaguaItem[] = [];
  @State selectedBagua: BaguaItem | null = null;
  @State showDetail: boolean = false;
  @State isLoading: boolean = true;
  @State extendedData: ExtendedLeiXiang[] = [];  // 扩展象义数据
  @State showExtended: boolean = false;  // 是否显示扩展象义
  @State expandedCategories: Set<number> = new Set();  // 展开的分类索引
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
      this.showExtended = false;  // 重置扩展显示状态
      this.extendedData = [];  // 清空扩展数据
      this.expandedCategories.clear();  // 清空展开状态
      console.log('拦截返回，回到八卦列表页');
      return true; // 返回true表示消费了这个返回事件
    }
    // 如果在列表页，返回false让系统处理
    console.log('在八卦列表页，交给系统处理返回');
    return false;
  }

  // 加载扩展象义数据（按需加载）
  async loadExtendedData(baguaName: string) {
    try {
      const fileName = this.getExtendedFileName(baguaName);
      const context = getContext(this);
      const mgr = context.resourceManager;
      const fileData = await mgr.getRawFileContent(fileName);
      const textDecoder = util.TextDecoder.create('utf-8');
      const jsonStr = textDecoder.decodeWithStream(fileData);
      const data: ExtendedDataFile = JSON.parse(jsonStr) as ExtendedDataFile;
      this.extendedData = data.extendedCategories || [];
      this.showExtended = true;
      console.log(`加载扩展象义成功: ${fileName}`);
    } catch (error) {
      console.error(`加载扩展象义失败: ${baguaName}`, error);
      this.showExtended = false;
    }
  }

  // 获取扩展文件名
  getExtendedFileName(baguaName: string): string {
    const nameMap = new Map<string, string>([
      ['乾卦', 'bagua_qian_extended.json'],
      ['坤卦', 'bagua_kun_extended.json'],
      ['震卦', 'bagua_zhen_extended.json'],
      ['巽卦', 'bagua_xun_extended.json'],
      ['坎卦', 'bagua_kan_extended.json'],
      ['离卦', 'bagua_li_extended.json'],
      ['艮卦', 'bagua_gen_extended.json'],
      ['兑卦', 'bagua_dui_extended.json']
    ]);
    return nameMap.get(baguaName) || 'bagua_qian_extended.json';
  }

  // 切换分类展开状态
  toggleCategory(index: number) {
    if (this.expandedCategories.has(index)) {
      this.expandedCategories.delete(index);
    } else {
      this.expandedCategories.add(index);
    }
    // 触发界面更新
    this.expandedCategories = new Set(this.expandedCategories);
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

        // 查看更多象义按钮
        if (!this.showExtended) {
          Button('查看更多象义 ⬇')
            .width('90%')
            .height(48)
            .fontSize(16)
            .fontColor('#FFFFFF')
            .backgroundColor('#E74C3C')
            .borderRadius(24)
            .onClick(() => {
              if (this.selectedBagua) {
                this.loadExtendedData(this.selectedBagua.name);
              }
            })
            .margin({ top: 10 })
        }

        // 扩展象义分类(折叠展示)
        if (this.showExtended && this.extendedData.length > 0) {
          // 标题分割线
          Row() {
            Divider()
              .strokeWidth(1)
              .color('#E0E0E0')
              .layoutWeight(1)

            Text('象义分类深入')
              .fontSize(14)
              .fontColor('#999')
              .margin({ left: 12, right: 12 })

            Divider()
              .strokeWidth(1)
              .color('#E0E0E0')
              .layoutWeight(1)
          }
          .width('100%')
          .margin({ top: 16, bottom: 8 })

          // 折叠展示扩展象义
          ForEach(this.extendedData, (extCategory: ExtendedLeiXiang, catIndex: number) => {
            this.buildExtendedCategory(extCategory, catIndex);
          })

          // 收起按钮
          Button('收起详细象义 ⬆')
            .width('90%')
            .height(48)
            .fontSize(16)
            .fontColor('#E74C3C')
            .backgroundColor('#FFF')
            .border({ width: 2, color: '#E74C3C' })
            .borderRadius(24)
            .onClick(() => {
              this.showExtended = false;
              this.extendedData = [];
              this.expandedCategories.clear();
            })
            .margin({ top: 16 })
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

  // 扩展分类Builder(支持折叠)
  @Builder
  buildExtendedCategory(extCategory: ExtendedLeiXiang, catIndex: number) {
    Column({ space: 12 }) {
      // 大分类标题(可点击折叠)
      Row({ space: 12 }) {
        Text(this.expandedCategories.has(catIndex) ? '▼' : '▶')
          .fontSize(14)
          .fontColor('#E74C3C')

        Text(extCategory.category)
          .fontSize(18)
          .fontWeight(700)
          .fontColor('#E74C3C')
          .layoutWeight(1)

        Text(this.expandedCategories.has(catIndex) ? '点击收起' : '点击展开')
          .fontSize(12)
          .fontColor('#999')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFF5F5')
      .borderRadius(12)
      .onClick(() => {
        this.toggleCategory(catIndex);
      })

      // 子分类内容(折叠显示)
      if (this.expandedCategories.has(catIndex)) {
        ForEach(extCategory.subcategories, (subcat: SubcategoryItem, subIndex: number) => {
          Column({ space: 8 }) {
            // 子分类标题
            Row({ space: 8 }) {
              Text('◆')
                .fontSize(14)
                .fontColor('#E74C3C')

              Text(subcat.name)
                .fontSize(16)
                .fontWeight(600)
                .fontColor('#2C3E50')
            }
            .padding({ top: 8, bottom: 8 })

            // 子分类条目
            ForEach(subcat.items, (item: string, itemIndex: number) => {
              Row({ space: 8 }) {
                Text(`•`)
                  .fontSize(12)
                  .fontColor('#95A5A6')
                  .width(16)

                Text(item)
                  .fontSize(14)
                  .fontColor('#34495E')
                  .layoutWeight(1)
                  .lineHeight(22)
              }
              .width('100%')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor('#F8F9FA')
              .borderRadius(8)
            })
          }
          .width('100%')
          .padding(12)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .margin({ top: subIndex === 0 ? 8 : 4 })
        })
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
}
