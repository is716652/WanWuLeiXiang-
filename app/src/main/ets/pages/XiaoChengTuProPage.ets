/**
 * 小成图专业版页面 - 完全重写
 * 
 * 功能特点：
 * 1. 专业装卦：九宫格展示天盘地盘
 * 2. 四象占法：图形化显示吉凶生克
 * 3. 用神分析：9大用神详细解读
 * 4. 图形化展示：直观易懂的卦象展示
 */

import { router } from '@kit.ArkUI';
import { XiaoChengTuUtil, XiaoChengTuResult } from '../model/XiaoChengTuData';
import { 
  XiaoChengTuPro, 
  WanZhengZhuangGua,
  XiaoChengTuJiuGong,
  YongShenInfo,
  SiXiangJiXiong
} from '../model/XiaoChengTuProfessionalNew';

@Entry
@Component
struct XiaoChengTuProPage {
  @State zhuangGuaResult: WanZhengZhuangGua | null = null;
  @State showResult: boolean = false;
  
  private xiaoChengTuPro: XiaoChengTuPro = new XiaoChengTuPro();
  private scroller: Scroller = new Scroller(); // 滚动控制器
  
  aboutToAppear(): void {
    // 页面加载时不自动起卦，等待用户点击
    console.log('小成图专业版页面加载完成');
  }
  
  /**
   * 执行起卦
   */
  private performQiGua(): void {
    try {
      console.log('[XiaoChengTuPro] 开始起卦...');
      
      // 1. 时间起卦
      const result: XiaoChengTuResult = XiaoChengTuUtil.timeBasedQiGua();
      console.log('[XiaoChengTuPro] 起卦结果:', result.重卦.名称);
      
      // 2. 装卦分析
      const dongYao = this.calculateDongYao();
      console.log('[XiaoChengTuPro] 动爻:', dongYao);
      
      const newResult = this.xiaoChengTuPro.performZhuangGua(
        result.重卦,
        dongYao,
        '时间起卦'
      );
      
      console.log('[XiaoChengTuPro] 装卦完成:', newResult.zhuGua.zhongGua);
      console.log('[XiaoChengTuPro] 主卦符号:', newResult.zhuGua.guaXiang);
      console.log('[XiaoChengTuPro] 变卦符号:', newResult.bianGua.guaXiang);
      
      // 输出九宫格数据
      console.log('[XiaoChengTuPro] === 天盘数据 ===');
      console.log('[XiaoChengTuPro] 乾宫(西北):', newResult.tianPan.qianGong);
      console.log('[XiaoChengTuPro] 坤宫(西南):', newResult.tianPan.kunGong);
      console.log('[XiaoChengTuPro] 震宫(正东):', newResult.tianPan.zhenGong);
      console.log('[XiaoChengTuPro] 巽宫(东南):', newResult.tianPan.xunGong);
      console.log('[XiaoChengTuPro] 坎宫(正北):', newResult.tianPan.kanGong);
      console.log('[XiaoChengTuPro] 离宫(正南):', newResult.tianPan.liGong);
      console.log('[XiaoChengTuPro] 艮宫(东北):', newResult.tianPan.genGong);
      console.log('[XiaoChengTuPro] 兑宫(正西):', newResult.tianPan.duiGong);
      console.log('[XiaoChengTuPro] 中宫:', newResult.tianPan.zhongGong);
      
      // 保存当前滚动位置
      const currentOffset = this.scroller.currentOffset();
      console.log('[XiaoChengTuPro] 当前滚动位置:', currentOffset.yOffset);
      
      // 关键：先设置为null，再设置为新值，确保触发界面更新
      this.showResult = false;
      this.zhuangGuaResult = null;
      
      // 使用 nextTick 确保 UI 完全重置
      setTimeout(() => {
        this.zhuangGuaResult = newResult;
        this.showResult = true;
        console.log('[XiaoChengTuPro] 显示结果:', this.showResult);
        
        // 恢复滚动位置
        setTimeout(() => {
          if (currentOffset.yOffset > 0) {
            this.scroller.scrollTo({ xOffset: 0, yOffset: currentOffset.yOffset });
            console.log('[XiaoChengTuPro] 恢复滚动位置:', currentOffset.yOffset);
          }
        }, 50);
      }, 10);
      
    } catch (error) {
      console.error('[XiaoChengTuPro] 起卦错误:', JSON.stringify(error));
      console.error('[XiaoChengTuPro] 错误堆栈:', error.stack);
    }
  }
  
  /**
   * 计算动爻（加入随机性）
   */
  private calculateDongYao(): number {
    const now = new Date();
    // 加入秒数和随机数，确保每次不同
    const random = Math.floor(Math.random() * 1000);
    const total = now.getFullYear() + now.getMonth() + 1 + 
                  now.getDate() + now.getHours() + now.getMinutes() + 
                  now.getSeconds() + random;
    const yao = total % 6;
    return yao === 0 ? 6 : yao;
  }
  
  build() {
    Column() {
      // 顶部导航
      this.buildHeader()
      
      Scroll(this.scroller) {
        Column({ space: 20 }) {
          // 功能说明
          this.buildIntro()
          
          // 起卦按钮
          this.buildQiGuaButton()
          
          // 结果展示
          if (this.showResult && this.zhuangGuaResult !=  null) {
            Column({ space: 20 }) {
              this.buildBasicGua()
              this.buildJiuGongGe()
              this.buildYongShenAnalysis()
            }
          }
        }
        .width('100%')
        .padding(20)
      }
      .layoutWeight(1)
      .width('100%')
    }
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
  }
  
  /**
   * 顶部导航
   */
  @Builder
  buildHeader() {
    Row() {
      Button() {
        Text('← 返回')
          .fontSize(18)
          .fontColor('#FFFFFF')
      }
      .type(ButtonType.Normal)
      .backgroundColor('rgba(255, 255, 255, 0.1)')
      .onClick(() => {
        router.back();
      })
      
      Text('小成图专业版')
        .fontSize(24)
        .fontWeight(600)
        .fontColor('#FFD700')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .textShadow({
          radius: 10,
          color: 'rgba(255, 215, 0, 0.5)',
          offsetX: 0,
          offsetY: 0
        })
      
      Blank().width(80)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor('rgba(0, 0, 0, 0.3)')
  }
  
  /**
   * 功能介绍
   */
  @Builder
  buildIntro() {
    Column({ space: 12 }) {
      Text('☯ 小成图专业预测系统')
        .fontSize(20)
        .fontWeight(600)
        .fontColor('#FFD700')
      
      Text('基于苏国圣-卢德君《小成图解读》专业理论\n' +
           '天盘地盘九宫装卦 | 四象占法吉凶分析 | 用神取用精准断事')
        .fontSize(14)
        .fontColor('rgba(255, 255, 255, 0.85)')
        .lineHeight(22)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(0, 0, 0, 0.6)')
    .borderRadius(12)
    .borderWidth(1)
    .borderColor('rgba(255, 215, 0, 0.3)')
  }
  
  /**
   * 起卦按钮
   */
  @Builder
  buildQiGuaButton() {
    Button() {
      Row({ space: 8 }) {
        Text('🔮')
          .fontSize(20)
        Text(this.showResult ? '重新起卦' : '开始专业起卦')
          .fontSize(18)
          .fontWeight(600)
      }
    }
    .width('80%')
    .height(50)
    .backgroundColor('#FFD700')
    .fontColor('#000000')
    .borderRadius(25)
    .onClick(() => {
      this.performQiGua();
    })
  }
  
  /**
   * 基础卦象展示
   */
  @Builder
  buildBasicGua() {
    Column({ space: 16 }) {
      Text('📊 基础卦象')
        .fontSize(18)
        .fontWeight(600)
        .fontColor('#FFD700')
      
      // 主卦
      Row({ space: 20 }) {
        Column({ space: 8 }) {
          Text('主卦')
            .fontSize(14)
            .fontColor('rgba(255, 255, 255, 0.7)')
          Text(this.zhuangGuaResult!.zhuGua.guaXiang)
            .fontSize(40)
            .fontColor('#FFD700')
          Text(this.zhuangGuaResult!.zhuGua.zhongGua)
            .fontSize(16)
            .fontWeight(600)
            .fontColor('#FFD700')
          Text(`${this.zhuangGuaResult!.zhuGua.shangGua} ䷾ ${this.zhuangGuaResult!.zhuGua.xiaGua}`)
            .fontSize(13)
            .fontColor('rgba(255, 255, 255, 0.7)')
        }
        
        Text('→')
          .fontSize(24)
          .fontColor('#FFD700')
        
        // 变卦
        Column({ space: 8 }) {
          Text(`变卦（${this.zhuangGuaResult!.dongYao}爻动）`)
            .fontSize(14)
            .fontColor('rgba(255, 255, 255, 0.7)')
          Text(this.zhuangGuaResult!.bianGua.guaXiang)
            .fontSize(40)
            .fontColor('#00FFFF')
          Text(this.zhuangGuaResult!.bianGua.zhongGua)
            .fontSize(16)
            .fontWeight(600)
            .fontColor('#00FFFF')
          Text(`${this.zhuangGuaResult!.bianGua.shangGua} ䷾ ${this.zhuangGuaResult!.bianGua.xiaGua}`)
            .fontSize(13)
            .fontColor('rgba(255, 255, 255, 0.7)')
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      
      // 起卦时间和方式
      Text(`起卦时间：${this.formatTime(this.zhuangGuaResult!.qiGuaShiJian)}`)
        .fontSize(12)
        .fontColor('rgba(255, 255, 255, 0.6)')
      Text(`起卦方式：${this.zhuangGuaResult!.qiGuaFangShi}`)
        .fontSize(12)
        .fontColor('rgba(255, 255, 255, 0.6)')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(0, 0, 0, 0.5)')
    .borderRadius(12)
  }
  
  /**
   * 九宫格展示 - 核心
   */
  @Builder
  buildJiuGongGe() {
    Column({ space: 16 }) {
      Text('🎯 九宫装卦')
        .fontSize(18)
        .fontWeight(600)
        .fontColor('#FFD700')
      
      Text('天盘（上卦所落）与地盘（后天八卦）对照')
        .fontSize(13)
        .fontColor('rgba(255, 255, 255, 0.7)')
      
      // 九宫格
      Column({ space: 2 }) {
        // 第一行：巽 离 坤
        Row({ space: 2 }) {
          this.buildGongCell('巽', '东南', 
            this.zhuangGuaResult!.tianPan.xunGong,
            this.zhuangGuaResult!.diPan.xunGong)
          this.buildGongCell('离', '正南',
            this.zhuangGuaResult!.tianPan.liGong,
            this.zhuangGuaResult!.diPan.liGong)
          this.buildGongCell('坤', '西南',
            this.zhuangGuaResult!.tianPan.kunGong,
            this.zhuangGuaResult!.diPan.kunGong)
        }
        
        // 第二行：震 中 兑
        Row({ space: 2 }) {
          this.buildGongCell('震', '正东',
            this.zhuangGuaResult!.tianPan.zhenGong,
            this.zhuangGuaResult!.diPan.zhenGong)
          this.buildZhongGongCell(this.zhuangGuaResult!.tianPan.zhongGong)
          this.buildGongCell('兑', '正西',
            this.zhuangGuaResult!.tianPan.duiGong,
            this.zhuangGuaResult!.diPan.duiGong)
        }
        
        // 第三行：艮 坎 乾
        Row({ space: 2 }) {
          this.buildGongCell('艮', '东北',
            this.zhuangGuaResult!.tianPan.genGong,
            this.zhuangGuaResult!.diPan.genGong)
          this.buildGongCell('坎', '正北',
            this.zhuangGuaResult!.tianPan.kanGong,
            this.zhuangGuaResult!.diPan.kanGong)
          this.buildGongCell('乾', '西北',
            this.zhuangGuaResult!.tianPan.qianGong,
            this.zhuangGuaResult!.diPan.qianGong)
        }
      }
      .width('100%')
      
      // 说明
      Row({ space: 20 }) {
        Row({ space: 4 }) {
          Text('●')
            .fontSize(12)
            .fontColor('#FF6B6B')
          Text('天盘（上卦）')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
        }
        
        Row({ space: 4 }) {
          Text('●')
            .fontSize(12)
            .fontColor('#4ECDC4')
          Text('地盘（固定）')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(0, 0, 0, 0.5)')
    .borderRadius(12)
  }
  
  /**
   * 宫位单元格
   */
  @Builder
  buildGongCell(
    gongMing: string,
    fangWei: string,
    tianGua: string,
    diGua: string
  ) {
    Column({ space: 6 }) {
      Text(gongMing)
        .fontSize(13)
        .fontWeight(600)
        .fontColor('#FFD700')
      
      Text(fangWei)
        .fontSize(10)
        .fontColor('rgba(255, 255, 255, 0.5)')
      
      Divider()
        .color('rgba(255, 255, 255, 0.2)')
        .strokeWidth(0.5)
      
      Text(tianGua)
        .fontSize(16)
        .fontWeight(600)
        .fontColor('#FF6B6B')
      
      Text(diGua)
        .fontSize(14)
        .fontColor('#4ECDC4')
    }
    .width('30%')
    .aspectRatio(1)
    .padding(8)
    .backgroundColor('rgba(0, 0, 0, 0.5)')
    .borderRadius(8)
    .borderWidth(1)
    .borderColor('rgba(255, 215, 0, 0.3)')
  }
  
  /**
   * 中宫单元格
   */
  @Builder
  buildZhongGongCell(zhongGua: string) {
    Column({ space: 6 }) {
      Text('中宫')
        .fontSize(13)
        .fontWeight(600)
        .fontColor('#FFD700')
      
      Text(zhongGua)
        .fontSize(20)
        .fontWeight(700)
        .fontColor('#FFD700')
    }
    .width('30%')
    .aspectRatio(1)
    .padding(8)
    .backgroundColor('rgba(255, 215, 0, 0.15)')
    .borderRadius(8)
    .borderWidth(2)
    .borderColor('#FFD700')
  }
  
  /**
   * 用神分析
   */
  @Builder
  buildYongShenAnalysis() {
    Column({ space: 16 }) {
      Text('🔍 用神分析')
        .fontSize(18)
        .fontWeight(600)
        .fontColor('#FFD700')
      
      Text('九大用神吉凶详解')
        .fontSize(13)
        .fontColor('rgba(255, 255, 255, 0.7)')
      
      // 用神列表
      Column({ space: 12 }) {
        ForEach(this.zhuangGuaResult!.yongShen, (yongShen: YongShenInfo) => {
          this.buildYongShenItem(yongShen)
        })
      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(0, 0, 0, 0.5)')
    .borderRadius(12)
  }
  
  /**
   * 用神项
   */
  @Builder
  buildYongShenItem(yongShen: YongShenInfo) {
    Column({ space: 10 }) {
      // 标题行
      Row() {
        Text(yongShen.mingCheng)
          .fontSize(16)
          .fontWeight(600)
          .fontColor('#FFD700')
        
        Blank()
        
        Text(this.getJiXiongIcon(yongShen.siXiang.jiXiong))
          .fontSize(14)
          .fontColor(this.getJiXiongColor(yongShen.siXiang.jiXiong))
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor(this.getJiXiongBgColor(yongShen.siXiang.jiXiong))
          .borderRadius(4)
      }
      .width('100%')
      
      // 详情
      Column({ space: 6 }) {
        Row() {
          Text(`宫位：${yongShen.gongWei}`)
            .fontSize(13)
            .fontColor('rgba(255, 255, 255, 0.7)')
          
          Blank()
          
          Text(`天盘：${yongShen.tianPanGua}`)
            .fontSize(13)
            .fontColor('#FF6B6B')
          
          Blank()
          
          Text(`地盘：${yongShen.diPanGua}`)
            .fontSize(13)
            .fontColor('#4ECDC4')
        }
        .width('100%')
        
        Text(yongShen.siXiang.shuoming)
          .fontSize(12)
          .fontColor('rgba(255, 255, 255, 0.6)')
          .lineHeight(18)
        
        Text(yongShen.fenXi)
          .fontSize(13)
          .fontColor('rgba(255, 255, 255, 0.8)')
          .lineHeight(20)
      }
      .width('100%')
      .padding(12)
      .backgroundColor('rgba(0, 0, 0, 0.2)')
      .borderRadius(8)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('rgba(255, 255, 255, 0.03)')
    .borderRadius(10)
    .borderWidth(1)
    .borderColor('rgba(255, 215, 0, 0.15)')
  }
  
  /**
   * 获取吉凶图标
   */
  private getJiXiongIcon(jiXiong: SiXiangJiXiong): string {
    if (jiXiong === SiXiangJiXiong.JI) {
      return '✅ 吉';
    } else if (jiXiong === SiXiangJiXiong.XIONG) {
      return '❌ 凶';
    } else if (jiXiong === SiXiangJiXiong.SHENG) {
      return '🔄 生';
    } else if (jiXiong === SiXiangJiXiong.KE) {
      return '⚔️ 克';
    } else if (jiXiong === SiXiangJiXiong.XIAN_XIONG_HOU_JI) {
      return '📈 先凶后吉';
    } else {
      return '📉 先吉后凶';
    }
  }
  
  /**
   * 获取吉凶颜色
   */
  private getJiXiongColor(jiXiong: SiXiangJiXiong): string {
    if (jiXiong === SiXiangJiXiong.JI) {
      return '#00FF00';
    } else if (jiXiong === SiXiangJiXiong.XIONG) {
      return '#FF0000';
    } else if (jiXiong === SiXiangJiXiong.SHENG) {
      return '#00FFFF';
    } else if (jiXiong === SiXiangJiXiong.KE) {
      return '#FF00FF';
    } else if (jiXiong === SiXiangJiXiong.XIAN_XIONG_HOU_JI) {
      return '#FFD700';
    } else {
      return '#FFA500';
    }
  }
  
  /**
   * 获取吉凶背景色
   */
  private getJiXiongBgColor(jiXiong: SiXiangJiXiong): string {
    if (jiXiong === SiXiangJiXiong.JI) {
      return 'rgba(0, 255, 0, 0.2)';
    } else if (jiXiong === SiXiangJiXiong.XIONG) {
      return 'rgba(255, 0, 0, 0.2)';
    } else if (jiXiong === SiXiangJiXiong.SHENG) {
      return 'rgba(0, 255, 255, 0.2)';
    } else if (jiXiong === SiXiangJiXiong.KE) {
      return 'rgba(255, 0, 255, 0.2)';
    } else if (jiXiong === SiXiangJiXiong.XIAN_XIONG_HOU_JI) {
      return 'rgba(255, 215, 0, 0.2)';
    } else {
      return 'rgba(255, 165, 0, 0.2)';
    }
  }
  
  /**
   * 格式化时间
   */
  private formatTime(date: Date): string {
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    const hour = date.getHours().toString().padStart(2, '0');
    const minute = date.getMinutes().toString().padStart(2, '0');
    return `${year}-${month}-${day} ${hour}:${minute}`;
  }
}
