// 纳甲数据模型
export class NaJiaYao {
  position: string = '';
  najia: string = '';
  wuxing: string = '';

  constructor(position: string, najia: string, wuxing: string) {
    this.position = position;
    this.najia = najia;
    this.wuxing = wuxing;
  }
}

export class TianGan {
  inner: string = '';
  outer: string = '';

  constructor(inner: string, outer: string) {
    this.inner = inner;
    this.outer = outer;
  }
}

export class NaJiaItem {
  bagua: string = '';
  symbol: string = '';
  property: string = '';
  tianGan: TianGan = new TianGan('', '');
  yaoWei: NaJiaYao[] = [];
  koujue: string = '';

  constructor(bagua: string, symbol: string, property: string, tianGan: TianGan, yaoWei: NaJiaYao[], koujue: string) {
    this.bagua = bagua;
    this.symbol = symbol;
    this.property = property;
    this.tianGan = tianGan;
    this.yaoWei = yaoWei;
    this.koujue = koujue;
  }
}

// 纳甲完整数据
export const NAJIA_DATA: NaJiaItem[] = [
  new NaJiaItem(
    '乾', '☰', '阳金',
    new TianGan('甲', '壬'),
    [
      new NaJiaYao('上爻', '壬戌', '土'),
      new NaJiaYao('五爻', '壬申', '金'),
      new NaJiaYao('四爻', '壬午', '火'),
      new NaJiaYao('三爻', '甲辰', '土'),
      new NaJiaYao('二爻', '甲寅', '木'),
      new NaJiaYao('初爻', '甲子', '水')
    ],
    '乾金甲子外壬午'
  ),
  new NaJiaItem(
    '坤', '☷', '阴土',
    new TianGan('乙', '癸'),
    [
      new NaJiaYao('上爻', '癸酉', '金'),
      new NaJiaYao('五爻', '癸亥', '水'),
      new NaJiaYao('四爻', '癸丑', '土'),
      new NaJiaYao('三爻', '乙卯', '木'),
      new NaJiaYao('二爻', '乙巳', '火'),
      new NaJiaYao('初爻', '乙未', '土')
    ],
    '坤土乙未外癸丑'
  ),
  new NaJiaItem(
    '震', '☳', '阳木',
    new TianGan('庚', '庚'),
    [
      new NaJiaYao('上爻', '庚戌', '土'),
      new NaJiaYao('五爻', '庚申', '金'),
      new NaJiaYao('四爻', '庚午', '火'),
      new NaJiaYao('三爻', '庚辰', '土'),
      new NaJiaYao('二爻', '庚寅', '木'),
      new NaJiaYao('初爻', '庚子', '水')
    ],
    '震木庚子庚午临'
  ),
  new NaJiaItem(
    '坎', '☵', '阳水',
    new TianGan('戊', '戊'),
    [
      new NaJiaYao('上爻', '戊子', '水'),
      new NaJiaYao('五爻', '戊戌', '土'),
      new NaJiaYao('四爻', '戊申', '金'),
      new NaJiaYao('三爻', '戊午', '火'),
      new NaJiaYao('二爻', '戊辰', '土'),
      new NaJiaYao('初爻', '戊寅', '木')
    ],
    '坎水戊寅外戊申'
  ),
  new NaJiaItem(
    '艮', '☶', '阳土',
    new TianGan('丙', '丙'),
    [
      new NaJiaYao('上爻', '丙寅', '木'),
      new NaJiaYao('五爻', '丙子', '水'),
      new NaJiaYao('四爻', '丙戌', '土'),
      new NaJiaYao('三爻', '丙申', '金'),
      new NaJiaYao('二爻', '丙午', '火'),
      new NaJiaYao('初爻', '丙辰', '土')
    ],
    '艮土丙辰外丙戌'
  ),
  new NaJiaItem(
    '巽', '☴', '阴木',
    new TianGan('辛', '辛'),
    [
      new NaJiaYao('上爻', '辛卯', '木'),
      new NaJiaYao('五爻', '辛巳', '火'),
      new NaJiaYao('四爻', '辛未', '土'),
      new NaJiaYao('三爻', '辛酉', '金'),
      new NaJiaYao('二爻', '辛亥', '水'),
      new NaJiaYao('初爻', '辛丑', '土')
    ],
    '巽木辛丑并辛未'
  ),
  new NaJiaItem(
    '离', '☲', '阴火',
    new TianGan('己', '己'),
    [
      new NaJiaYao('上爻', '己巳', '火'),
      new NaJiaYao('五爻', '己未', '土'),
      new NaJiaYao('四爻', '己酉', '金'),
      new NaJiaYao('三爻', '己亥', '水'),
      new NaJiaYao('二爻', '己丑', '土'),
      new NaJiaYao('初爻', '己卯', '木')
    ],
    '离火卯酉终于寅'
  ),
  new NaJiaItem(
    '兑', '☱', '阴金',
    new TianGan('丁', '丁'),
    [
      new NaJiaYao('上爻', '丁未', '土'),
      new NaJiaYao('五爻', '丁酉', '金'),
      new NaJiaYao('四爻', '丁亥', '水'),
      new NaJiaYao('三爻', '丁丑', '土'),
      new NaJiaYao('二爻', '丁卯', '木'),
      new NaJiaYao('初爻', '丁巳', '火')
    ],
    '兑金丁巳丁亥陈'
  )
];

// 获取五行颜色
export function getWuXingColor(wuxing: string): string {
  switch (wuxing) {
    case '金': return '#d4af37';
    case '木': return '#4a7c59';
    case '水': return '#1e3a8a';
    case '火': return '#dc2626';
    case '土': return '#ca8a04';
    default: return '#666666';
  }
}

// 获取八卦属性颜色
export function getBaguaPropertyColor(property: string): string {
  if (property.includes('金')) return '#d4af37';
  if (property.includes('木')) return '#4a7c59';
  if (property.includes('水')) return '#1e3a8a';
  if (property.includes('火')) return '#dc2626';
  if (property.includes('土')) return '#ca8a04';
  return '#666666';
}