/**
 * 八卦指南针整合组件
 * 将指南针方位与先后天八卦系统深度整合
 */

import { CompassManager, DirectionInfo, BaguaDirection } from '../manager/CompassManager';

// 八卦详细信息接口
export interface BaguaDetailInfo {
  /** 卦名 */
  name: string;
  /** 卦符 */
  symbol: string;
  /** 卦象 */
  nature: string;
  /** 方位 */
  direction: string;
  /** 五行 */
  element: string;
  /** 家庭成员 */
  family: string;
  /** 洛书数 */
  number: number;
  /** 卦辞含义 */
  meaning: string;
  /** 颜色 */
  color: string;
  /** 是否先天八卦 */
  isXianTian: boolean;
  /** 当前朝向匹配度 */
  matchDegree: number;
}

// 八卦详细信息数据接口
export interface BaguaDetailData {
  nature: string;
  element: string;
  family: string;
  number: number;
  meaning: string;
  color: string;
}

// 方位分析结果接口
export interface DirectionAnalysis {
  /** 当前方位 */
  currentDirection: DirectionInfo;
  /** 匹配的先天八卦 */
  xianTianGua: BaguaDetailInfo | null;
  /** 匹配的后天八卦 */
  houTianGua: BaguaDetailInfo | null;
  /** 方位建议 */
  suggestions: string[];
  /** 最佳朝向 */
  bestDirections: string[];
}

@Component
export struct BaguaCompassIntegration {
  @State currentAnalysis: DirectionAnalysis | null = null;
  @State showDetailedAnalysis: boolean = false;
  @State selectedMode: 'both' | 'xiantian' | 'houtian' = 'both';
  @State compassRotation: number = 0;

  private compassManager: CompassManager = CompassManager.getInstance();

  aboutToAppear() {
    this.compassManager.addDirectionChangeCallback(this.onDirectionChange);
    this.initializeAnalysis();
  }

  aboutToDisappear() {
    this.compassManager.removeDirectionChangeCallback(this.onDirectionChange);
  }

  /**
   * 初始化分析
   */
  private async initializeAnalysis() {
    const currentDirection = this.compassManager.getCurrentDirection();
    if (currentDirection) {
      this.performDirectionAnalysis(currentDirection);
    }
  }

  /**
   * 方向变化处理
   */
  private onDirectionChange = (direction: DirectionInfo) => {
    this.compassRotation = direction.azimuth;
    this.performDirectionAnalysis(direction);
  }

  /**
   * 执行方位分析
   */
  private performDirectionAnalysis(direction: DirectionInfo) {
    // 获取先天八卦匹配
    const xianTianBagua = this.compassManager.getBaguaFromAngle(direction.azimuth, true);
    const xianTianDetail = xianTianBagua ? this.createBaguaDetailInfo(xianTianBagua, direction.azimuth, true) : null;

    // 获取后天八卦匹配
    const houTianBagua = this.compassManager.getBaguaFromAngle(direction.azimuth, false);
    const houTianDetail = houTianBagua ? this.createBaguaDetailInfo(houTianBagua, direction.azimuth, false) : null;

    // 生成建议
    const suggestions = this.generateSuggestions(xianTianDetail, houTianDetail);
    const bestDirections = this.getBestDirections(direction);

    this.currentAnalysis = {
      currentDirection: direction,
      xianTianGua: xianTianDetail,
      houTianGua: houTianDetail,
      suggestions: suggestions,
      bestDirections: bestDirections
    };
  }

  /**
   * 创建八卦详细信息
   */
  private createBaguaDetailInfo(bagua: BaguaDirection, azimuth: number, isXianTian: boolean): BaguaDetailInfo {
    // 计算匹配度
    const start = bagua.angleRange[0];
    const end = bagua.angleRange[1];
    let matchDegree = 0;
    
    if (start <= end) {
      const range = end - start;
      const offset = Math.abs(azimuth - start);
      matchDegree = Math.max(0, 1 - (offset / range));
    } else {
      // 跨0度的情况
      const range = (360 - start) + end;
      let offset = 0;
      if (azimuth >= start) {
        offset = azimuth - start;
      } else {
        offset = (360 - start) + azimuth;
      }
      matchDegree = Math.max(0, 1 - (offset / range));
    }

    // 获取详细信息
    const details = this.getBaguaDetails(bagua.name, isXianTian);

    return {
      name: bagua.name,
      symbol: bagua.symbol,
      nature: details.nature,
      direction: bagua.direction,
      element: details.element,
      family: details.family,
      number: details.number,
      meaning: details.meaning,
      color: details.color,
      isXianTian: isXianTian,
      matchDegree: matchDegree
    };
  }

  /**
   * 获取八卦详细信息
   */
  private getBaguaDetails(name: string, isXianTian: boolean): BaguaDetailData {
    // 先天八卦详细信息
    const xianTianDetails: Map<string, BaguaDetailData> = new Map([
      ['乾', { nature: '天', element: '金', family: '父', number: 1, meaning: '天行健，君子以自强不息', color: '#FFD700' } as BaguaDetailData],
      ['兑', { nature: '泽', element: '金', family: '少女', number: 2, meaning: '丽泽，兑，君子以朋友讲习', color: '#FF69B4' } as BaguaDetailData],
      ['离', { nature: '火', element: '火', family: '中女', number: 3, meaning: '明两作，离，大人以继明照于四方', color: '#FF4500' } as BaguaDetailData],
      ['震', { nature: '雷', element: '木', family: '长男', number: 4, meaning: '洊雷，震，君子以恐惧修省', color: '#006400' } as BaguaDetailData],
      ['巽', { nature: '风', element: '木', family: '长女', number: 5, meaning: '随风，巽，君子以申命行事', color: '#228B22' } as BaguaDetailData],
      ['坎', { nature: '水', element: '水', family: '中男', number: 6, meaning: '水洊至，习坎，君子以常德行', color: '#0000CD' } as BaguaDetailData],
      ['艮', { nature: '山', element: '土', family: '少男', number: 7, meaning: '兼山，艮，君子以思不出其位', color: '#696969' } as BaguaDetailData],
      ['坤', { nature: '地', element: '土', family: '母', number: 8, meaning: '地势坤，君子以厚德载物', color: '#8B4513' } as BaguaDetailData]
    ]);

    // 后天八卦详细信息
    const houTianDetails: Map<string, BaguaDetailData> = new Map([
      ['离', { nature: '火', element: '火', family: '中女', number: 9, meaning: '明两作，离，大人以继明照于四方', color: '#FF4500' } as BaguaDetailData],
      ['巽', { nature: '风', element: '木', family: '长女', number: 4, meaning: '随风，巽，君子以申命行事', color: '#228B22' } as BaguaDetailData],
      ['震', { nature: '雷', element: '木', family: '长男', number: 3, meaning: '洊雷，震，君子以恐惧修省', color: '#006400' } as BaguaDetailData],
      ['坤', { nature: '地', element: '土', family: '母', number: 2, meaning: '地势坤，君子以厚德载物', color: '#8B4513' } as BaguaDetailData],
      ['坎', { nature: '水', element: '水', family: '中男', number: 1, meaning: '水洊至，习坎，君子以常德行', color: '#0000CD' } as BaguaDetailData],
      ['乾', { nature: '天', element: '金', family: '父', number: 6, meaning: '天行健，君子以自强不息', color: '#FFD700' } as BaguaDetailData],
      ['兑', { nature: '泽', element: '金', family: '少女', number: 7, meaning: '丽泽，兑，君子以朋友讲习', color: '#FF69B4' } as BaguaDetailData],
      ['艮', { nature: '山', element: '土', family: '少男', number: 8, meaning: '兼山，艮，君子以思不出其位', color: '#696969' } as BaguaDetailData]
    ]);

    const detailsMap = isXianTian ? xianTianDetails : houTianDetails;
    const result = detailsMap.get(name);
    return result || { nature: '', element: '', family: '', number: 0, meaning: '', color: '#000000' } as BaguaDetailData;
  }

  /**
   * 生成方位建议
   */
  private generateSuggestions(xianTian: BaguaDetailInfo | null, houTian: BaguaDetailInfo | null): string[] {
    const suggestions: string[] = [];

    if (xianTian && houTian) {
      suggestions.push(`当前朝向对应先天${xianTian.name}卦，后天${houTian.name}卦`);
      
      // 根据五行属性生成建议
      if (xianTian.element === houTian.element) {
        suggestions.push(`${xianTian.element}属性一致，能量和谐`);
      } else {
        suggestions.push(`先天${xianTian.element}与后天${houTian.element}相辅相成`);
      }

      // 根据家庭角色生成建议
      if (xianTian.family === houTian.family) {
        suggestions.push(`家庭角色统一，适合${xianTian.family}相关活动`);
      }

      // 根据卦辞生成建议
      suggestions.push(`宜：${xianTian.meaning.substring(0, 10)}...`);
    }

    return suggestions;
  }

  /**
   * 获取最佳朝向
   */
  private getBestDirections(direction: DirectionInfo): string[] {
    const bestDirections: string[] = [];
    const currentAzimuth = direction.azimuth;

    // 根据当前方位推荐最佳朝向
    if (currentAzimuth >= 315 || currentAzimuth < 45) {
      bestDirections.push('正北（坎卦）', '东北（艮卦）');
    } else if (currentAzimuth >= 45 && currentAzimuth < 135) {
      bestDirections.push('正东（震卦）', '东南（巽卦）');
    } else if (currentAzimuth >= 135 && currentAzimuth < 225) {
      bestDirections.push('正南（离卦）', '西南（坤卦）');
    } else {
      bestDirections.push('正西（兑卦）', '西北（乾卦）');
    }

    return bestDirections;
  }

  /**
   * 创建八卦匹配卡片
   */
  @Builder
  createBaguaMatchCard(detail: BaguaDetailInfo | null, title: string) {
    if (detail) {
      Column({ space: 12 }) {
        Text(title)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Row({ space: 12 }) {
          Text(detail.symbol)
            .fontSize(28)
            .fontColor(detail.color)
            .fontWeight(FontWeight.Bold)

          Column({ space: 4 }) {
            Text(`${detail.name}卦`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')

            Text(`${detail.nature} · ${detail.direction}`)
              .fontSize(12)
              .fontColor('#666666')

            Text(`${detail.element} · ${detail.family}`)
              .fontSize(12)
              .fontColor('#666666')
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          // 匹配度指示器
          Column({ space: 4 }) {
            Text('匹配度')
              .fontSize(10)
              .fontColor('#999999')
            Text(`${Math.round(detail.matchDegree * 100)}%`)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(detail.matchDegree > 0.7 ? '#00AA00' : '#FF6600')
          }
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        if (this.showDetailedAnalysis) {
          Divider().color('#E0E0E0')

          Text(detail.meaning)
            .fontSize(12)
            .fontColor('#666666')
            .lineHeight(16)
            .textAlign(TextAlign.Start)
            .width('100%')
        }
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(8)
      .border({ width: 1, color: detail.matchDegree > 0.7 ? '#8E24AA' : '#E0E0E0' })
    }
  }

  /**
   * 创建分析结果面板
   */
  @Builder
  createAnalysisPanel() {
    if (this.currentAnalysis) {
      Column({ space: 16 }) {
        // 当前方位信息
        Row({ space: 16 }) {
          Column({ space: 4 }) {
            Text('当前方位')
              .fontSize(12)
              .fontColor('#999999')
            Text(this.currentAnalysis.currentDirection.direction)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
          }

          Column({ space: 4 }) {
            Text('方位角度')
              .fontSize(12)
              .fontColor('#999999')
            Text(`${Math.round(this.currentAnalysis.currentDirection.azimuth)}°`)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        // 八卦匹配信息
        if (this.selectedMode === 'both' || this.selectedMode === 'xiantian') {
          this.createBaguaMatchCard(this.currentAnalysis.xianTianGua, '先天八卦')
        }

        if (this.selectedMode === 'both' || this.selectedMode === 'houtian') {
          this.createBaguaMatchCard(this.currentAnalysis.houTianGua, '后天八卦')
        }

        // 方位建议
        if (this.currentAnalysis.suggestions.length > 0) {
          Column({ space: 8 }) {
            Text('方位建议')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%')
              .textAlign(TextAlign.Start)

            ForEach(this.currentAnalysis.suggestions, (suggestion: string) => {
              Row({ space: 8 }) {
                Text('•')
                  .fontSize(14)
                  .fontColor('#8E24AA')
                  .fontWeight(FontWeight.Bold)

                Text(suggestion)
                  .fontSize(12)
                  .fontColor('#666666')
                  .lineHeight(16)
                  .layoutWeight(1)
              }
              .width('100%')
              .alignItems(VerticalAlign.Top)
            })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#F8F9FA')
          .borderRadius(8)
        }

        // 最佳朝向推荐
        if (this.currentAnalysis.bestDirections.length > 0) {
          Column({ space: 8 }) {
            Text('推荐朝向')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%')
              .textAlign(TextAlign.Start)

            Row({ space: 8 }) {
              ForEach(this.currentAnalysis.bestDirections, (direction: string) => {
                Text(direction)
                  .fontSize(12)
                  .fontColor('#FFFFFF')
                  .backgroundColor('#8E24AA')
                  .borderRadius(12)
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFF3E0')
          .borderRadius(8)
        }
      }
      .width('100%')
      .padding(20)
    }
  }

  build() {
    Column({ space: 16 }) {
      // 标题和控制
      Row({ space: 12 }) {
        Text('八卦方位分析')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)

        Button(this.showDetailedAnalysis ? '简化' : '详细')
          .fontSize(12)
          .fontColor('#8E24AA')
          .backgroundColor('#F3E5F5')
          .borderRadius(16)
          .height(32)
          .onClick(() => {
            this.showDetailedAnalysis = !this.showDetailedAnalysis;
          })
      }
      .width('100%')

      // 分析结果面板
      this.createAnalysisPanel()
    }
    .width('100%')
    .backgroundColor('#F5F5F5')
    .borderRadius(12)
    .padding(16)
  }
}