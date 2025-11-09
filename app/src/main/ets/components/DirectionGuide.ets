/**
 * 实时方位提示和卦象推荐组件
 * 根据当前方位提供实用的风水建议和卦象推荐
 */

import { CompassManager, DirectionInfo, BaguaDirection } from '../manager/CompassManager';

// 方位推荐接口
export interface DirectionRecommendation {
  /** 方位 */
  direction: string;
  /** 卦名 */
  guaName: string;
  /** 卦符 */
  symbol: string;
  /** 推荐理由 */
  reason: string;
  /** 适合活动 */
  suitableActivities: string[];
  /** 避免事项 */
  avoidances: string[];
  /** 吉凶等级 */
  fortuneLevel: '吉' | '中吉' | '平' | '凶';
  /** 颜色 */
  color: string;
}

// 实时提示接口
export interface RealTimeTip {
  /** 提示类型 */
  type: 'direction' | 'gua' | 'activity' | 'time';
  /** 提示内容 */
  content: string;
  /** 优先级 */
  priority: 'high' | 'medium' | 'low';
  /** 图标 */
  icon: string;
}

// 提示数据接口
export interface TipData {
  content: string;
  priority: 'high' | 'medium' | 'low';
  icon: string;
}

@Component
export struct DirectionGuide {
  @State currentRecommendations: DirectionRecommendation[] = [];
  @State realTimeTips: RealTimeTip[] = [];
  @State currentDirection: DirectionInfo | null = null;
  @State showAdvancedTips: boolean = false;

  private compassManager: CompassManager = CompassManager.getInstance();

  aboutToAppear() {
    this.compassManager.addDirectionChangeCallback(this.onDirectionChange);
    this.initializeRecommendations();
  }

  aboutToDisappear() {
    this.compassManager.removeDirectionChangeCallback(this.onDirectionChange);
  }

  /**
   * 初始化推荐
   */
  private async initializeRecommendations() {
    const currentDirection = this.compassManager.getCurrentDirection();
    if (currentDirection) {
      this.onDirectionChange(currentDirection);
    }
  }

  /**
   * 方向变化处理
   */
  private onDirectionChange = (direction: DirectionInfo) => {
    this.currentDirection = direction;
    this.updateRecommendations(direction);
    this.updateRealTimeTips(direction);
  }

  /**
   * 更新推荐
   */
  private updateRecommendations(direction: DirectionInfo) {
    const recommendations: DirectionRecommendation[] = [];
    
    // 获取八个基本方位的推荐
    const directions = this.getDirectionRecommendations(direction);
    recommendations.push(...directions);

    // 根据时间添加特殊推荐
    const timeRecommendation = this.getTimeBasedRecommendation(direction);
    if (timeRecommendation) {
      recommendations.push(timeRecommendation);
    }

    this.currentRecommendations = recommendations;
  }

  /**
   * 获取方位推荐
   */
  private getDirectionRecommendations(direction: DirectionInfo): DirectionRecommendation[] {
    const azimuth = direction.azimuth;
    const recommendations: DirectionRecommendation[] = [];

    // 北方推荐
    if (azimuth >= 315 || azimuth < 45) {
      recommendations.push({
        direction: '北',
        guaName: '坎',
        symbol: '☵',
        reason: '坎卦属水，主智慧与事业',
        suitableActivities: ['学习研究', '策划谋略', '静心思考', '养精蓄锐'],
        avoidances: ['重大决策', '冒险投资', '激烈运动'],
        fortuneLevel: '中吉',
        color: '#0000CD'
      });
    }

    // 东北推荐
    if (azimuth >= 45 && azimuth < 135) {
      if (azimuth < 90) {
        recommendations.push({
          direction: '东北',
          guaName: '艮',
          symbol: '☶',
          reason: '艮卦属土，主停止与新生',
          suitableActivities: ['开始新项目', '休息调整', '学习新知', '积累基础'],
          avoidances: ['急于求成', '冲动行事', '过度消耗'],
          fortuneLevel: '平',
          color: '#696969'
        });
      } else {
        recommendations.push({
          direction: '东',
          guaName: '震',
          symbol: '☳',
          reason: '震卦属木，主动生与奋发',
          suitableActivities: ['开拓创新', '积极行动', '领导工作', '体育锻炼'],
          avoidances: ['犹豫不决', '消极等待', '保守守旧'],
          fortuneLevel: '吉',
          color: '#006400'
        });
      }
    }

    // 东南推荐
    if (azimuth >= 135 && azimuth < 225) {
      if (azimuth < 180) {
        recommendations.push({
          direction: '东南',
          guaName: '巽',
          symbol: '☴',
          reason: '巽卦属木，主柔顺与渐进',
          suitableActivities: ['沟通交流', '循序渐进', '灵活应变', '文化传播'],
          avoidances: ['强硬对抗', '急躁冒进', '固执己见'],
          fortuneLevel: '中吉',
          color: '#228B22'
        });
      } else {
        recommendations.push({
          direction: '南',
          guaName: '离',
          symbol: '☲',
          reason: '离卦属火，主光明与文明',
          suitableActivities: ['公开演讲', '展示才华', '社交活动', '艺术创作'],
          avoidances: ['隐匿保守', '阴暗行事', '独断专行'],
          fortuneLevel: '吉',
          color: '#FF4500'
        });
      }
    }

    // 西南推荐
    if (azimuth >= 225 && azimuth < 315) {
      if (azimuth < 270) {
        recommendations.push({
          direction: '西南',
          guaName: '坤',
          symbol: '☷',
          reason: '坤卦属土，主包容与承载',
          suitableActivities: ['团队协作', '包容他人', '积累财富', '家庭活动'],
          avoidances: ['争强好胜', '单打独斗', '急功近利'],
          fortuneLevel: '中吉',
          color: '#8B4513'
        });
      } else {
        recommendations.push({
          direction: '西',
          guaName: '兑',
          symbol: '☱',
          reason: '兑卦属金，主喜悦与交流',
          suitableActivities: ['娱乐休闲', '朋友聚会', '谈判协商', '表达情感'],
          avoidances: ['严肃刻板', '封闭自我', '压抑情感'],
          fortuneLevel: '吉',
          color: '#FF69B4'
        });
      }
    }

    // 西北推荐
    if (azimuth >= 270 || azimuth < 315) {
      recommendations.push({
        direction: '西北',
        guaName: '乾',
        symbol: '☰',
        reason: '乾卦属金，主刚健与权威',
        suitableActivities: ['领导决策', '制定规则', '发挥权威', '战略规划'],
        avoidances: ['优柔寡断', '依赖他人', '缺乏主见'],
        fortuneLevel: '吉',
        color: '#FFD700'
      });
    }

    return recommendations;
  }

  /**
   * 获取基于时间的推荐
   */
  private getTimeBasedRecommendation(direction: DirectionInfo): DirectionRecommendation | null {
    const hour = new Date().getHours();
    
    // 早晨推荐东方
    if (hour >= 5 && hour <= 9) {
      return {
        direction: '东',
        guaName: '震',
        symbol: '☳',
        reason: '早晨阳气上升，宜面向东方开启新的一天',
        suitableActivities: ['晨练', '规划一天', '开始重要工作'],
        avoidances: ['赖床', '拖延'],
        fortuneLevel: '吉',
        color: '#006400'
      };
    }

    // 中午推荐南方
    if (hour >= 11 && hour <= 13) {
      return {
        direction: '南',
        guaName: '离',
        symbol: '☲',
        reason: '正午阳气最盛，宜面向南方承接正能量',
        suitableActivities: ['重要会议', '展示成果', '社交活动'],
        avoidances: ['剧烈运动', '情绪激动'],
        fortuneLevel: '吉',
        color: '#FF4500'
      };
    }

    // 晚上推荐北方
    if (hour >= 21 || hour <= 5) {
      return {
        direction: '北',
        guaName: '坎',
        symbol: '☵',
        reason: '夜晚阴气上升，宜面向北方静心养神',
        suitableActivities: ['冥想', '学习', '休息'],
        avoidances: ['刺激性活动', '过度用脑'],
        fortuneLevel: '中吉',
        color: '#0000CD'
      };
    }

    return null;
  }

  /**
   * 更新实时提示
   */
  private updateRealTimeTips(direction: DirectionInfo) {
    const tips: RealTimeTip[] = [];
    
    // 方位提示
    tips.push({
      type: 'direction',
      content: `当前方位：${direction.direction}（${Math.round(direction.azimuth)}°）`,
      priority: 'high',
      icon: '🧭'
    } as RealTimeTip);

    // 根据方位添加卦象提示
    const xianTianGua = this.compassManager.getBaguaFromAngle(direction.azimuth, true);
    if (xianTianGua) {
      tips.push({
        type: 'gua',
        content: `先天${xianTianGua.name}卦：${this.getGuaTip(xianTianGua.name)}`,
        priority: 'medium',
        icon: xianTianGua.symbol
      } as RealTimeTip);
    }

    // 活动建议
    const activityTip = this.getActivityTip(direction);
    if (activityTip) {
      tips.push({
        type: 'activity',
        content: activityTip,
        priority: 'medium',
        icon: '💡'
      } as RealTimeTip);
    }

    // 时间提示
    const timeTip = this.getTimeTip();
    if (timeTip) {
      tips.push({
        type: 'time',
        content: timeTip,
        priority: 'low',
        icon: '⏰'
      } as RealTimeTip);
    }

    this.realTimeTips = tips;
  }

  /**
   * 获取卦象提示
   */
  private getGuaTip(guaName: string): string {
    const tips: Map<string, string> = new Map([
      ['乾', '天行健，君子以自强不息'],
      ['坤', '地势坤，君子以厚德载物'],
      ['震', '洊雷，震，君子以恐惧修省'],
      ['巽', '随风，巽，君子以申命行事'],
      ['坎', '水洊至，习坎，君子以常德行'],
      ['离', '明两作，离，大人以继明照于四方'],
      ['艮', '兼山，艮，君子以思不出其位'],
      ['兑', '丽泽，兑，君子以朋友讲习']
    ]);

    return tips.get(guaName) || '';
  }

  /**
   * 获取活动提示
   */
  private getActivityTip(direction: DirectionInfo): string {
    const azimuth = direction.azimuth;
    
    if (azimuth >= 315 || azimuth < 45) {
      return '适合静心学习和思考问题';
    } else if (azimuth >= 45 && azimuth < 135) {
      return '适合积极行动和开拓创新';
    } else if (azimuth >= 135 && azimuth < 225) {
      return '适合社交活动和展示才华';
    } else {
      return '适合沟通交流和表达情感';
    }
  }

  /**
   * 获取时间提示
   */
  private getTimeTip(): string {
    const hour = new Date().getHours();
    
    if (hour >= 5 && hour <= 9) {
      return '早晨阳气上升，宜积极进取';
    } else if (hour >= 11 && hour <= 13) {
      return '正午阳气最盛，宜把握时机';
    } else if (hour >= 17 && hour <= 19) {
      return '傍晚阴阳转换，宜调整身心';
    } else if (hour >= 21 || hour <= 5) {
      return '夜晚阴气上升，宜静养休息';
    } else {
      return '当前时辰平和，宜稳步前行';
    }
  }

  /**
   * 创建推荐卡片
   */
  @Builder
  createRecommendationCard(recommendation: DirectionRecommendation) {
    Column({ space: 12 }) {
      // 标题栏
      Row({ space: 12 }) {
        Text(recommendation.symbol)
          .fontSize(24)
          .fontColor(recommendation.color)
          .fontWeight(FontWeight.Bold)

        Column({ space: 4 }) {
          Text(`${recommendation.direction}方·${recommendation.guaName}卦`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')

          Text(recommendation.reason)
            .fontSize(12)
            .fontColor('#666666')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // 吉凶标识
        Text(recommendation.fortuneLevel)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getFortuneColor(recommendation.fortuneLevel))
          .backgroundColor(this.getFortuneBgColor(recommendation.fortuneLevel))
          .borderRadius(8)
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      // 适合活动
      Column({ space: 6 }) {
        Text('适合活动')
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .width('100%')
          .textAlign(TextAlign.Start)

        Flex({ wrap: FlexWrap.Wrap, spacing: 6 }) {
          ForEach(recommendation.suitableActivities, (activity: string) => {
            Text(activity)
              .fontSize(11)
              .fontColor('#FFFFFF')
              .backgroundColor(recommendation.color)
              .borderRadius(10)
              .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          })
        }
        .width('100%')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      // 避免事项
      if (this.showAdvancedTips && recommendation.avoidances.length > 0) {
        Column({ space: 6 }) {
          Text('避免事项')
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
            .width('100%')
            .textAlign(TextAlign.Start)

          Flex({ wrap: FlexWrap.Wrap, spacing: 6 }) {
            ForEach(recommendation.avoidances, (avoidance: string) => {
              Text(avoidance)
                .fontSize(11)
                .fontColor('#666666')
                .backgroundColor('#F0F0F0')
                .borderRadius(10)
                .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            })
          }
          .width('100%')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({
      radius: 6,
      color: '#1A000000',
      offsetX: 0,
      offsetY: 2
    })
    .border({ width: 1, color: recommendation.color + '30' })
  }

  /**
   * 创建实时提示面板
   */
  @Builder
  createRealTimeTipsPanel() {
    Column({ space: 10 }) {
      Text('实时提示')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start)

      ForEach(this.realTimeTips, (tip: RealTimeTip) => {
        Row({ space: 8 }) {
          Text(tip.icon)
            .fontSize(16)

          Text(tip.content)
            .fontSize(12)
            .fontColor('#666666')
            .lineHeight(16)
            .layoutWeight(1)

          if (tip.priority === 'high') {
            Circle({ width: 6, height: 6 })
              .fill('#FF0000')
          } else if (tip.priority === 'medium') {
            Circle({ width: 6, height: 6 })
              .fill('#FFA500')
          } else {
            Circle({ width: 6, height: 6 })
              .fill('#00AA00')
          }
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .alignItems(VerticalAlign.Center)
      })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({
      radius: 6,
      color: '#1A000000',
      offsetX: 0,
      offsetY: 2
    })
  }

  /**
   * 获取吉凶颜色
   */
  private getFortuneColor(level: string): string {
    const colors: Map<string, string> = new Map([
      ['吉', '#FFFFFF'],
      ['中吉', '#FFFFFF'],
      ['平', '#666666'],
      ['凶', '#FFFFFF']
    ]);
    return colors.get(level) || '#666666';
  }

  /**
   * 获取吉凶背景色
   */
  private getFortuneBgColor(level: string): string {
    const colors: Map<string, string> = new Map([
      ['吉', '#00AA00'],
      ['中吉', '#FFA500'],
      ['平', '#CCCCCC'],
      ['凶', '#FF0000']
    ]);
    return colors.get(level) || '#CCCCCC';
  }

  build() {
    Column({ space: 16 }) {
      // 标题栏
      Row({ space: 12 }) {
        Text('方位指导')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)

        Button(this.showAdvancedTips ? '简化' : '详细')
          .fontSize(12)
          .fontColor('#8E24AA')
          .backgroundColor('#F3E5F5')
          .borderRadius(16)
          .height(32)
          .onClick(() => {
            this.showAdvancedTips = !this.showAdvancedTips;
          })
      }
      .width('100%')

      // 实时提示面板
      this.createRealTimeTipsPanel()

      // 方位推荐列表
      Column({ space: 12 }) {
        Text('方位推荐')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .width('100%')
          .textAlign(TextAlign.Start)

        ForEach(this.currentRecommendations, (recommendation: DirectionRecommendation) => {
          this.createRecommendationCard(recommendation)
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#F5F5F5')
    .borderRadius(12)
  }
}