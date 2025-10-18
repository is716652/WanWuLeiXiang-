/**
 * 六十甲子纳音数据加载器
 */

import { NaYinItem, NaYinXiangYi } from './DataTypes';
import { util } from '@kit.ArkTS';

// 导出类型
export { NaYinItem, NaYinXiangYi } from './DataTypes';

const NAYIN_FILES = [
  'nayin_haizhoujin.json',     // 甲子乙丑 海中金
  'nayin_luzhonghuo.json',     // 丙寅丁卯 炉中火
  'nayin_dalinmu.json',        // 戊辰己巳 大林木
  'nayin_lupangtu.json',       // 庚午辛未 路旁土
  'nayin_jianfengjin.json',    // 壬申癸酉 剑锋金
  'nayin_shantouhuo.json',     // 甲戌乙亥 山头火
  'nayin_jianxiashui.json',    // 丙子丁丑 涧下水
  'nayin_chengtoutu.json',     // 戊寅己卯 城头土
  'nayin_bailajin.json',       // 庚辰辛巳 白蜡金
  'nayin_yangliumu.json',      // 壬午癸未 杨柳木
  'nayin_quanzhongshui.json',  // 甲申乙酉 泉中水
  'nayin_wushangtu.json',      // 丙戌丁亥 屋上土
  'nayin_pilihuo.json',        // 戊子己丑 霹雳火
  'nayin_songbaimu.json',      // 庚寅辛卯 松柏木
  'nayin_changliushui.json',   // 壬辰癸巳 长流水
  'nayin_shazhongjin.json',    // 甲午乙未 沙中金
  'nayin_shanxiahuo.json',     // 丙申丁酉 山下火
  'nayin_pingdimu.json',       // 戊戌己亥 平地木
  'nayin_bishangtu.json',      // 庚子辛丑 壁上土
  'nayin_jinbojin.json',       // 壬寅癸卯 金箔金
  'nayin_fudenghuo.json',      // 甲辰乙巳 覆灯火
  'nayin_tianheshui.json',     // 丙午丁未 天河水
  'nayin_dayitu.json',         // 戊申己酉 大驿土
  'nayin_chaichuanjin.json',   // 庚戌辛亥 钗钏金
  'nayin_sangtuomu.json',      // 壬子癸丑 桑柘木
  'nayin_daxishui.json',       // 甲寅乙卯 大溪水
  'nayin_shazhongtu.json',     // 丙辰丁巳 沙中土
  'nayin_tianshanghuo.json',   // 戊午己未 天上火
  'nayin_shiliumu.json',       // 庚申辛酉 石榴木
  'nayin_dahaishui.json'       // 壬戌癸亥 大海水
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

export async function loadNaYinData(): Promise<NaYinItem[]> {
  const list: NaYinItem[] = [];
  for (const fileName of NAYIN_FILES) {
    try {
      const jsonStr = await loadJsonFromRawfile(fileName);
      if (jsonStr) list.push(JSON.parse(jsonStr));
    } catch (error) {
      console.error(`解析失败: ${fileName}`, error);
    }
  }
  return list;
}
