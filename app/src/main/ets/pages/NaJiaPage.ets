import { router } from '@kit.ArkUI';
import { NAJIA_DATA, NaJiaItem, NaJiaYao, getWuXingColor, getBaguaPropertyColor } from '../model/NaJiaData';

@Entry
@Component
struct NaJiaPage {
  @State selectedBagua: number = -1; // 选中的八卦索引，-1表示显示全部

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Button('← 返回')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor('transparent')
          .onClick(() => {
            router.back();
          })

        Text('纳甲配置表')
          .fontSize(20)
          .fontWeight(600)
          .fontColor('#FFFFFF')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('六爻基础')
          .fontSize(14)
          .fontColor('rgba(255, 255, 255, 0.7)')
      }
      .width('100%')
      .height(60)
      .padding({ left: 20, right: 20 })
      .backgroundColor('#2C3E50')

      // 说明文字
      Column({ space: 8 }) {
        Text('纳甲规则：阳卦纳阳干阳支，阴卦纳阴干阴支')
          .fontSize(14)
          .fontColor('#666666')
          .textAlign(TextAlign.Center)

        Text('点击八卦查看详细配置，再次点击收起')
          .fontSize(12)
          .fontColor('#999999')
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding({ top: 16, bottom: 8, left: 20, right: 20 })
      .backgroundColor('#F8F9FA')

      // 滚动内容
      Scroll() {
        Column({ space: 12 }) {
          ForEach(NAJIA_DATA, (item: NaJiaItem, index: number) => {
            this.createBaguaCard(item, index);
          })
        }
        .width('100%')
        .padding({ top: 16, bottom: 20, left: 16, right: 16 })
      }
      .layoutWeight(1)
      .backgroundColor('#F0F2F5')
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  createBaguaCard(item: NaJiaItem, index: number) {
    Column({ space: 0 }) {
      // 八卦头部信息
      Row({ space: 16 }) {
        // 八卦符号
        Text(item.symbol)
          .fontSize(32)
          .fontColor(getBaguaPropertyColor(item.property))

        // 八卦信息
        Column({ space: 4 }) {
          Text(item.bagua)
            .fontSize(20)
            .fontWeight(600)
            .fontColor('#2C3E50')

          Text(item.property)
            .fontSize(14)
            .fontColor(getBaguaPropertyColor(item.property))
            .fontWeight(500)

          Text(`内${item.tianGan.inner} 外${item.tianGan.outer}`)
            .fontSize(12)
            .fontColor('#666666')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // 展开/收起图标
        Text(this.selectedBagua === index ? '▲' : '▼')
          .fontSize(16)
          .fontColor('#999999')
      }
      .width('100%')
      .padding({ top: 16, bottom: 16, left: 20, right: 20 })
      .onClick(() => {
        this.selectedBagua = this.selectedBagua === index ? -1 : index;
      })

      // 详细纳甲表格（展开时显示）
      if (this.selectedBagua === index) {
        Column({ space: 0 }) {
          // 表头
          Row() {
            Text('爻位')
              .fontSize(14)
              .fontWeight(600)
              .fontColor('#FFFFFF')
              .width('25%')
              .textAlign(TextAlign.Center)

            Text('纳甲')
              .fontSize(14)
              .fontWeight(600)
              .fontColor('#FFFFFF')
              .width('35%')
              .textAlign(TextAlign.Center)

            Text('五行')
              .fontSize(14)
              .fontWeight(600)
              .fontColor('#FFFFFF')
              .width('20%')
              .textAlign(TextAlign.Center)

            Text('天干')
              .fontSize(14)
              .fontWeight(600)
              .fontColor('#FFFFFF')
              .width('20%')
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .height(40)
          .backgroundColor('#34495E')

          // 表格内容
          ForEach(item.yaoWei, (yao: NaJiaYao, yaoIndex: number) => {
            Row() {
              Text(yao.position)
                .fontSize(13)
                .fontColor('#2C3E50')
                .width('25%')
                .textAlign(TextAlign.Center)

              Text(yao.najia)
                .fontSize(13)
                .fontColor('#2C3E50')
                .fontWeight(500)
                .width('35%')
                .textAlign(TextAlign.Center)

              Text(yao.wuxing)
                .fontSize(13)
                .fontColor(getWuXingColor(yao.wuxing))
                .fontWeight(600)
                .width('20%')
                .textAlign(TextAlign.Center)

              Text(yao.najia.charAt(0))
                .fontSize(13)
                .fontColor('#666666')
                .width('20%')
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            .height(36)
            .backgroundColor(yaoIndex % 2 === 0 ? '#FFFFFF' : '#F8F9FA')
          })

          // 记忆口诀
          Row() {
            Text('口诀：')
              .fontSize(12)
              .fontColor('#666666')

            Text(item.koujue)
              .fontSize(12)
              .fontColor(getBaguaPropertyColor(item.property))
              .fontWeight(500)
          }
          .width('100%')
          .padding({ top: 12, bottom: 12, left: 20, right: 20 })
          .backgroundColor('#E8F4FD')
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .animation({
          duration: 300,
          curve: Curve.EaseInOut
        })
      }
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetX: 0,
      offsetY: 2
    })
  }
}