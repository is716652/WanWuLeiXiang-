/**
 * 指南针视图组件
 * 显示设备朝向、指南针动画和八卦方位信息
 */

import { CompassManager, DirectionInfo, BaguaDirection } from '../manager/CompassManager';

// 位置接口
interface Position {
  x: number;
  y: number;
}

@Component
export struct CompassView {
  @State currentAzimuth: number = 0;
  @State currentDirection: string = '北';
  @State baguaDirection: BaguaDirection | null = null;
  @State isListening: boolean = false;
  @State showBaguaOverlay: boolean = true;
  @State compassMode: 'normal' | 'xiantian' | 'houtian' = 'normal';

  private compassManager: CompassManager = CompassManager.getInstance();

  aboutToAppear() {
    this.initializeCompass();
  }

  aboutToDisappear() {
    this.compassManager.removeDirectionChangeCallback(this.onDirectionChange);
    this.compassManager.stopListening();
  }

  /**
   * 初始化指南针
   */
  private async initializeCompass() {
    this.compassManager.addDirectionChangeCallback(this.onDirectionChange);
    
    const success = await this.compassManager.startListening();
    this.isListening = success;
    
    if (success) {
      const currentDirection = this.compassManager.getCurrentDirection();
      if (currentDirection) {
        this.onDirectionChange(currentDirection);
      }
    }
  }

  /**
   * 方向变化处理
   */
  private onDirectionChange = (direction: DirectionInfo) => {
    this.currentAzimuth = direction.azimuth;
    this.currentDirection = direction.direction;
    
    if (this.compassMode === 'xiantian') {
      this.baguaDirection = this.compassManager.getBaguaFromAngle(direction.azimuth, true);
    } else if (this.compassMode === 'houtian') {
      this.baguaDirection = this.compassManager.getBaguaFromAngle(direction.azimuth, false);
    } else {
      this.baguaDirection = null;
    }
  }

  /**
   * 切换指南针模式
   */
  private switchCompassMode(mode: 'normal' | 'xiantian' | 'houtian') {
    this.compassMode = mode;
    if (this.compassMode === 'normal') {
      this.baguaDirection = null;
    } else {
      const currentDirection = this.compassManager.getCurrentDirection();
      if (currentDirection) {
        this.onDirectionChange(currentDirection);
      }
    }
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        // 标题
        Text('指南针')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .textAlign(TextAlign.Center)
          .width('100%')

        // 指南针圆盘
        Stack() {
          // 外圈背景
          Circle({ width: 280, height: 280 })
            .fill('#FFFFFF')
            .stroke('#E0E0E0')
            .strokeWidth(2)

          // 方位标记
          ForEach(['北', '东', '南', '西'], (direction: string, index: number) => {
            Text(direction)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .position(this.getCardinalPosition(index))
              .markAnchor({ x: '50%', y: '50%' })
          })

          // 指南针指针
          Column({ space: 0 }) {
            // 北针（红色）
            Path()
              .width(20)
              .height(60)
              .commands('M 10 60 L 0 20 L 10 0 L 20 20 Z')
              .fill('#FF0000')
              .stroke('#CC0000')
              .strokeWidth(1)

            // 南针（白色）
            Path()
              .width(20)
              .height(60)
              .commands('M 10 0 L 0 20 L 10 60 L 20 20 Z')
              .fill('#FFFFFF')
              .stroke('#CCCCCC')
              .strokeWidth(1)
          }
          .rotate({ angle: -this.currentAzimuth })
          .markAnchor({ x: '50%', y: '50%' })

          // 中心点
          Circle({ width: 20, height: 20 })
            .fill('#333333')
        }
        .width(280)
        .height(280)
        .margin(20)

        // 信息面板
        Column({ space: 12 }) {
          // 当前方向信息
          Row({ space: 16 }) {
            Column({ space: 4 }) {
              Text('当前方位')
                .fontSize(12)
                .fontColor('#999999')
              Text(this.currentDirection)
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
            }

            Column({ space: 4 }) {
              Text('方位角度')
                .fontSize(12)
                .fontColor('#999999')
              Text(`${Math.round(this.currentAzimuth)}°`)
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)

          // 模式切换按钮
          Row({ space: 8 }) {
            Button('普通')
              .fontSize(12)
              .fontColor(this.compassMode === 'normal' ? '#FFFFFF' : '#8E24AA')
              .backgroundColor(this.compassMode === 'normal' ? '#8E24AA' : '#F3E5F5')
              .borderRadius(16)
              .height(32)
              .onClick(() => this.switchCompassMode('normal'))

            Button('先天八卦')
              .fontSize(12)
              .fontColor(this.compassMode === 'xiantian' ? '#FFFFFF' : '#8E24AA')
              .backgroundColor(this.compassMode === 'xiantian' ? '#8E24AA' : '#F3E5F5')
              .borderRadius(16)
              .height(32)
              .onClick(() => this.switchCompassMode('xiantian'))

            Button('后天八卦')
              .fontSize(12)
              .fontColor(this.compassMode === 'houtian' ? '#FFFFFF' : '#8E24AA')
              .backgroundColor(this.compassMode === 'houtian' ? '#8E24AA' : '#F3E5F5')
              .borderRadius(16)
              .height(32)
              .onClick(() => this.switchCompassMode('houtian'))
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)

          // 状态指示
          Row({ space: 8 }) {
            Circle({ width: 8, height: 8 })
              .fill(this.isListening ? '#00FF00' : '#FF0000')
            Text(this.isListening ? '指南针运行中' : '指南针未启动')
              .fontSize(12)
              .fontColor('#666666')
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({
          radius: 8,
          color: '#1A000000',
          offsetX: 0,
          offsetY: 4
        })
      }
      .width('100%')
      .padding(20)
    }
    .width('100%')
    .backgroundColor('#F5F5F5')
    .borderRadius(12)
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
  }

  /**
   * 获取基本方位位置
   */
  private getCardinalPosition(index: number): Position {
    const centerX = 140;
    const centerY = 140;
    const radius = 110;
    const angles = [0, 90, 180, 270];
    const angle = (angles[index] * Math.PI) / 180;

    const result: Position = {
      x: centerX + radius * Math.sin(angle),
      y: centerY - radius * Math.cos(angle)
    };
    return result;
  }
}