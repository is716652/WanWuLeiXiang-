/**
 * 指南针方位管理器
 * 负责获取设备朝向、方位计算和与八卦方位的映射
 */

import sensor from '@ohos.sensor';
import geoLocationManager from '@ohos.geolocation';

// 方位信息接口
export interface DirectionInfo {
  /** 方位角度 (0-360度) */
  azimuth: number;
  /** 方位描述 */
  direction: string;
  /** 精确度 */
  accuracy: number;
  /** 时间戳 */
  timestamp: number;
}

// 八卦方位映射接口
export interface BaguaDirection {
  /** 卦名 */
  name: string;
  /** 卦符 */
  symbol: string;
  /** 方位范围 [起始角度, 结束角度] */
  angleRange: [number, number];
  /** 方位描述 */
  direction: string;
  /** 是否先天八卦 */
  isXianTian: boolean;
}

// 方位枚举
export enum CardinalDirection {
  NORTH = '北',
  NORTHEAST = '东北',
  EAST = '东',
  SOUTHEAST = '东南',
  SOUTH = '南',
  SOUTHWEST = '西南',
  WEST = '西',
  NORTHWEST = '西北'
}

/**
 * 指南针管理器
 */
export class CompassManager {
  private static instance: CompassManager | null = null;
  private currentDirection: DirectionInfo | null = null;
  private isListening: boolean = false;
  private directionChangeCallbacks: ((direction: DirectionInfo) => void)[] = [];

  // 私有构造函数，实现单例模式
  private constructor() {}

  /**
   * 获取单例实例
   */
  public static getInstance(): CompassManager {
    if (!CompassManager.instance) {
      CompassManager.instance = new CompassManager();
    }
    return CompassManager.instance;
  }

  /**
   * 根据角度获取方位描述
   */
  private getDirectionFromAngle(angle: number): string {
    const normalizedAngle = ((angle % 360) + 360) % 360;
    
    if (normalizedAngle >= 337.5 || normalizedAngle < 22.5) {
      return '北';
    } else if (normalizedAngle >= 22.5 && normalizedAngle < 67.5) {
      return '东北';
    } else if (normalizedAngle >= 67.5 && normalizedAngle < 112.5) {
      return '东';
    } else if (normalizedAngle >= 112.5 && normalizedAngle < 157.5) {
      return '东南';
    } else if (normalizedAngle >= 157.5 && normalizedAngle < 202.5) {
      return '南';
    } else if (normalizedAngle >= 202.5 && normalizedAngle < 247.5) {
      return '西南';
    } else if (normalizedAngle >= 247.5 && normalizedAngle < 292.5) {
      return '西';
    } else {
      return '西北';
    }
  }

  /**
   * 获取先天八卦方位映射
   */
  public getXianTianBaguaDirections(): BaguaDirection[] {
    return [
      { name: '乾', symbol: '☰', angleRange: [337.5, 22.5], direction: '南', isXianTian: true },
      { name: '兑', symbol: '☱', angleRange: [22.5, 67.5], direction: '东南', isXianTian: true },
      { name: '离', symbol: '☲', angleRange: [67.5, 112.5], direction: '东', isXianTian: true },
      { name: '震', symbol: '☳', angleRange: [112.5, 157.5], direction: '东北', isXianTian: true },
      { name: '巽', symbol: '☴', angleRange: [157.5, 202.5], direction: '西南', isXianTian: true },
      { name: '坎', symbol: '☵', angleRange: [202.5, 247.5], direction: '西', isXianTian: true },
      { name: '艮', symbol: '☶', angleRange: [247.5, 292.5], direction: '西北', isXianTian: true },
      { name: '坤', symbol: '☷', angleRange: [292.5, 337.5], direction: '北', isXianTian: true }
    ];
  }

  /**
   * 获取后天八卦方位映射
   */
  public getHouTianBaguaDirections(): BaguaDirection[] {
    return [
      { name: '离', symbol: '☲', angleRange: [157.5, 202.5], direction: '南', isXianTian: false },
      { name: '巽', symbol: '☴', angleRange: [112.5, 157.5], direction: '东南', isXianTian: false },
      { name: '震', symbol: '☳', angleRange: [67.5, 112.5], direction: '东', isXianTian: false },
      { name: '坤', symbol: '☷', angleRange: [292.5, 337.5], direction: '西南', isXianTian: false },
      { name: '坎', symbol: '☵', angleRange: [337.5, 22.5], direction: '北', isXianTian: false },
      { name: '乾', symbol: '☰', angleRange: [247.5, 292.5], direction: '西北', isXianTian: false },
      { name: '兑', symbol: '☱', angleRange: [202.5, 247.5], direction: '西', isXianTian: false },
      { name: '艮', symbol: '☶', angleRange: [22.5, 67.5], direction: '东北', isXianTian: false }
    ];
  }

  /**
   * 根据角度获取对应的八卦方位
   */
  public getBaguaFromAngle(angle: number, isXianTian: boolean): BaguaDirection | null {
    const normalizedAngle = ((angle % 360) + 360) % 360;
    const directions = isXianTian ? 
      this.getXianTianBaguaDirections() : 
      this.getHouTianBaguaDirections();

    for (const bagua of directions) {
      const start = bagua.angleRange[0];
      const end = bagua.angleRange[1];
      if (start <= end) {
        if (normalizedAngle >= start && normalizedAngle < end) {
          return bagua;
        }
      } else {
        // 处理跨0度的情况
        if (normalizedAngle >= start || normalizedAngle < end) {
          return bagua;
        }
      }
    }
    return null;
  }

  /**
   * 开始监听设备方向
   */
  public async startListening(): Promise<boolean> {
    try {
      if (this.isListening) {
        return true;
      }

      // 直接订阅方向传感器数据（HarmonyOS会自动检查传感器可用性）
      sensor.on(sensor.SensorId.ORIENTATION, (data) => {
        if (data) {
          const directionInfo: DirectionInfo = {
            azimuth: data.alpha || 0,
            direction: this.getDirectionFromAngle(data.alpha || 0),
            accuracy: data.accuracy || 0,
            timestamp: Date.now()
          };

          this.currentDirection = directionInfo;
          this.notifyDirectionChange(directionInfo);
        }
      });

      this.isListening = true;
      return true;
    } catch (error) {
      console.error('启动方向监听失败:', error);
      return false;
    }
  }

  /**
   * 停止监听设备方向
   */
  public stopListening(): void {
    if (this.isListening) {
      try {
        sensor.off(sensor.SensorId.ORIENTATION);
        this.isListening = false;
      } catch (error) {
        console.error('停止方向监听失败:', error);
      }
    }
  }

  /**
   * 获取当前方向信息
   */
  public getCurrentDirection(): DirectionInfo | null {
    return this.currentDirection;
  }

  /**
   * 添加方向变化回调
   */
  public addDirectionChangeCallback(callback: (direction: DirectionInfo) => void): void {
    this.directionChangeCallbacks.push(callback);
  }

  /**
   * 移除方向变化回调
   */
  public removeDirectionChangeCallback(callback: (direction: DirectionInfo) => void): void {
    const index = this.directionChangeCallbacks.indexOf(callback);
    if (index > -1) {
      this.directionChangeCallbacks.splice(index, 1);
    }
  }

  /**
   * 通知方向变化
   */
  private notifyDirectionChange(direction: DirectionInfo): void {
    this.directionChangeCallbacks.forEach(callback => {
      try {
        callback(direction);
      } catch (error) {
        console.error('方向变化回调执行失败:', error);
      }
    });
  }

  /**
   * 获取方位角的精确描述
   */
  public getDetailedDirectionDescription(angle: number): string {
    const normalizedAngle = ((angle % 360) + 360) % 360;
    const baseDirection = this.getDirectionFromAngle(normalizedAngle);
    const deviation = Math.round(normalizedAngle);
    
    return `${baseDirection} ${deviation}°`;
  }

  /**
   * 检查权限状态
   */
  public async checkPermissions(): Promise<boolean> {
    try {
      // 这里可以添加权限检查逻辑
      // 比如检查位置权限等
      return true;
    } catch (error) {
      console.error('权限检查失败:', error);
      return false;
    }
  }

  /**
   * 释放资源
   */
  public dispose(): void {
    this.stopListening();
    this.directionChangeCallbacks = [];
    this.currentDirection = null;
  }
}