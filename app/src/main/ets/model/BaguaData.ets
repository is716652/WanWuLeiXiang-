/**
 * 八卦数据加载器
 */

import { BaguaItem, LeiXiangCategory } from './DataTypes';
import { util } from '@kit.ArkTS';

// 导出类型
export { BaguaItem, LeiXiangCategory } from './DataTypes';

const BAGUA_FILES = [
  'bagua_qian.json',
  'bagua_kun.json',
  'bagua_zhen.json',
  'bagua_xun.json',
  'bagua_kan.json',
  'bagua_li.json',
  'bagua_gen.json',
  'bagua_dui.json'
];

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

export async function loadBaguaData(): Promise<BaguaItem[]> {
  const list: BaguaItem[] = [];
  for (const fileName of BAGUA_FILES) {
    try {
      const jsonStr = await loadJsonFromRawfile(fileName);
      if (jsonStr) list.push(JSON.parse(jsonStr));
    } catch (error) {
      console.error(`解析失败: ${fileName}`, error);
    }
  }
  return list;
}
