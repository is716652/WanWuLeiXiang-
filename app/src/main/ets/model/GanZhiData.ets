/**
 * 天干地支数据加载器
 */

import { TianGanItem, DiZhiItem, LeiXiangCategory } from './DataTypes';
import { util } from '@kit.ArkTS';

// 导出类型
export { TianGanItem, DiZhiItem, LeiXiangCategory } from './DataTypes';

const TIANGAN_FILES = ['tiangan_jia.json','tiangan_yi.json','tiangan_bing.json','tiangan_ding.json','tiangan_wu.json','tiangan_ji.json','tiangan_geng.json','tiangan_xin.json','tiangan_ren.json','tiangan_gui.json'];
const DIZHI_FILES = ['dizhi_zi.json','dizhi_chou.json','dizhi_yin.json','dizhi_mao.json','dizhi_chen.json','dizhi_si.json','dizhi_wu.json','dizhi_wei.json','dizhi_shen.json','dizhi_you.json','dizhi_xu.json','dizhi_hai.json'];

async function loadJsonFromRawfile(fileName: string): Promise<string> {
  try {
    const context = getContext();
    const mgr = context.resourceManager;
    const data = await mgr.getRawFileContent(fileName);
    const textDecoder = util.TextDecoder.create('utf-8');
    return textDecoder.decodeWithStream(data);
  } catch (error) {
    console.error(`加载文件失败: ${fileName}`, error);
    return '';
  }
}

export async function loadTianGanData(): Promise<TianGanItem[]> {
  const list: TianGanItem[] = [];
  for (const fileName of TIANGAN_FILES) {
    try {
      const jsonStr = await loadJsonFromRawfile(fileName);
      if (jsonStr) list.push(JSON.parse(jsonStr));
    } catch (error) {
      console.error(`解析失败: ${fileName}`, error);
    }
  }
  return list;
}

export async function loadDiZhiData(): Promise<DiZhiItem[]> {
  const list: DiZhiItem[] = [];
  for (const fileName of DIZHI_FILES) {
    try {
      const jsonStr = await loadJsonFromRawfile(fileName);
      if (jsonStr) list.push(JSON.parse(jsonStr));
    } catch (error) {
      console.error(`解析失败: ${fileName}`, error);
    }
  }
  return list;
}
