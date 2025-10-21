/**
 * 六十四卦数据加载器
 */
import { resourceManager } from '@kit.LocalizationKit';
import util from '@ohos.util';
import { LiuShiSiGuaItem } from './DataTypes';

// 六十四卦文件列表（按卦序）
const LIUSHISIGUA_FILES = [
  'gua_01_qian.json',      // 1.乾
  'gua_02_kun.json',       // 2.坤
  'gua_03_zhun.json',      // 3.屯
  'gua_04_meng.json',      // 4.蒙
  'gua_05_xu.json',        // 5.需
  'gua_06_song.json',      // 6.讼
  'gua_07_shi.json',       // 7.师
  'gua_08_bi.json',        // 8.比
  'gua_09_xiaoxu.json',    // 9.小畜
  'gua_10_lv.json',        // 10.履
  'gua_11_tai.json',       // 11.泰
  'gua_12_pi.json',        // 12.否
  'gua_13_tongren.json',   // 13.同人
  'gua_14_dayou.json',     // 14.大有
  'gua_15_qian.json',      // 15.谦
  'gua_16_yu.json',        // 16.豫
  'gua_17_sui.json',       // 17.随
  'gua_18_gu.json',        // 18.蛊
  'gua_19_lin.json',       // 19.临
  'gua_20_guan.json',      // 20.观
  'gua_21_shihe.json',     // 21.噬嗑
  'gua_22_bi.json',        // 22.贲
  'gua_23_bo.json',        // 23.剥
  'gua_24_fu.json',        // 24.复
  'gua_25_wuwang.json',    // 25.无妄
  'gua_26_daxu.json',      // 26.大畜
  'gua_27_yi.json',        // 27.颐
  'gua_28_daguo.json',     // 28.大过
  'gua_29_kan.json',       // 29.坎
  'gua_30_li.json',        // 30.离
  'gua_31_xian.json',      // 31.咸
  'gua_32_heng.json',      // 32.恒
  'gua_33_dun.json',       // 33.遁
  'gua_34_dazhuang.json',  // 34.大壮
  'gua_35_jin.json',       // 35.晋
  'gua_36_mingyi.json',    // 36.明夷
  'gua_37_jiaren.json',    // 37.家人
  'gua_38_kui.json',       // 38.睽
  'gua_39_jian.json',      // 39.蹇
  'gua_40_jie.json',       // 40.解
  'gua_41_sun.json',       // 41.损
  'gua_42_yi.json',        // 42.益
  'gua_43_guai.json',      // 43.夬
  'gua_44_gou.json',       // 44.姤
  'gua_45_cui.json',       // 45.萃
  'gua_46_sheng.json',     // 46.升
  'gua_47_kun.json',       // 47.困
  'gua_48_jing.json',      // 48.井
  'gua_49_ge.json',        // 49.革
  'gua_50_ding.json',      // 50.鼎
  'gua_51_zhen.json',      // 51.震
  'gua_52_gen.json',       // 52.艮
  'gua_53_jian.json',      // 53.渐
  'gua_54_guimei.json',    // 54.归妹
  'gua_55_feng.json',      // 55.丰
  'gua_56_lv.json',        // 56.旅
  'gua_57_xun.json',       // 57.巽
  'gua_58_dui.json',       // 58.兑
  'gua_59_huan.json',      // 59.涣
  'gua_60_jie.json',       // 60.节
  'gua_61_zhongfu.json',   // 61.中孚
  'gua_62_xiaoguo.json',   // 62.小过
  'gua_63_jiji.json',      // 63.既济
  'gua_64_weiji.json'      // 64.未济
];

// 从rawfile加载JSON文件内容
async function loadJsonFromRawfile(fileName: string): Promise<string> {
  const context = getContext();
  const mgr: resourceManager.ResourceManager = context.resourceManager;
  
  try {
    const fileData: Uint8Array = await mgr.getRawFileContent(fileName);
    const textDecoder = util.TextDecoder.create('utf-8');
    const jsonStr: string = textDecoder.decodeWithStream(fileData);
    return jsonStr;
  } catch (error) {
    console.error(`加载文件失败: ${fileName}`, error);
    return '';
  }
}

/**
 * 加载所有六十四卦数据（简要信息用于列表展示）
 */
export async function loadLiuShiSiGuaSummary(): Promise<LiuShiSiGuaItem[]> {
  const list: LiuShiSiGuaItem[] = [];
  
  for (const fileName of LIUSHISIGUA_FILES) {
    try {
      const jsonStr = await loadJsonFromRawfile(fileName);
      if (jsonStr) {
        const data: LiuShiSiGuaItem = JSON.parse(jsonStr) as LiuShiSiGuaItem;
        list.push(data);
      }
    } catch (error) {
      console.error(`解析文件失败: ${fileName}`, error);
    }
  }
  
  return list;
}

/**
 * 按需加载单个卦的详细数据
 */
export async function loadSingleGua(guaXu: number): Promise<LiuShiSiGuaItem | null> {
  if (guaXu < 1 || guaXu > 64) {
    console.error('卦序超出范围');
    return null;
  }
  
  const fileName = LIUSHISIGUA_FILES[guaXu - 1];
  
  try {
    const jsonStr = await loadJsonFromRawfile(fileName);
    if (jsonStr) {
      return JSON.parse(jsonStr) as LiuShiSiGuaItem;
    }
  } catch (error) {
    console.error(`加载卦失败: ${fileName}`, error);
  }
  
  return null;
}
