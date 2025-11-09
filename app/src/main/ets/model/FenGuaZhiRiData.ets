/**
 * 分卦值日数据模型
 * 基于"六日七分"规则，每卦6天分别由六爻统领
 */

// 爻位信息接口
export interface YaoInfo {
  yaoPosition: string;     // 爻位 (初爻、二爻、三爻、四爻、五爻、上爻)
  yaoSymbol: string;       // 爻象 (如：初九、六二等)
  yaoText: string;         // 爻辞
  yaoMeaning: string;      // 爻义解释
  dayIndex: number;        // 第几日 (1-6)
  date: string;           // 具体日期 (MM-DD)
  time: string;           // 时间段 (HH:mm-HH:mm)
}

// 分卦值日项目接口
export interface FenGuaZhiRiItem {
  guaName: string;         // 卦名
  guaIndex: number;        // 卦序号 (1-60)
  startDate: string;       // 卦值日开始日期
  endDate: string;         // 卦值日结束日期
  solarTerm: string;       // 当期节气段
  yaoList: YaoInfo[];      // 六爻值日列表
  guaQiFeature: string;    // 卦气特征
}

// 年份分卦值日表接口
export interface YearFenGuaZhiRi {
  year: number;
  dongzhiDate: string;
  fenGuaList: FenGuaZhiRiItem[];
}

// 六十四卦爻辞数据（简化版，重点展示分卦值日概念）

// 每日时长：24小时 = 1440分钟
const DAY_DURATION_MINUTES = 1440;

/**
 * 获取卦的爻辞数据（如果没有数据则生成通用版本）
 */
function getGuaYaoData(guaName: string): YaoInfo[] {
  switch (guaName) {
    case '中孚':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '虞吉，有它不燕。', yaoMeaning: '爻气初现，需安守诚信，谨慎初始之变', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '鸣鹤在阴，其子和之。', yaoMeaning: '阴阳感应，同类相求，是沟通、呼应之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '得敌，或鼓或罢，或泣或歌。', yaoMeaning: '爻位不中不正，面临对立，情绪多变，是反复不定之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '月几望，马匹亡，无咎。', yaoMeaning: '阴爻居阴位，柔顺得正。接近圆满时需舍弃赘余，是权衡与抉择之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '有孚挛如，无咎。', yaoMeaning: '君位中正，以诚信维系天下，是团结、巩固、发布政令的吉日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '翰音登于天，贞凶。', yaoMeaning: '诚信过度而至于虚声，名不副实，是需警惕浮华、务实避凶之日', dayIndex: 6, date: '', time: '' }
      ];
    case '复':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '不远复，无祗悔，元吉。', yaoMeaning: '一阳来复，及时回归正道，是反省改过的吉日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '休复，吉。', yaoMeaning: '柔顺而复，安然回归，是休养生息的平和之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '频复，厉无咎。', yaoMeaning: '反复不定，虽有危险但无大咎，是需要坚持的考验之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '中行独复。', yaoMeaning: '独自行走正道，是坚持原则、不随波逐流之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '敦复，无悔。', yaoMeaning: '敦厚诚实地回归，是诚心改过、重新开始的好日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '迷复，凶，有灾眚。', yaoMeaning: '迷失方向，复归无路，是需要警惕迷失、避免灾祸之日', dayIndex: 6, date: '', time: '' }
      ];
    case '屯':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '磐桓，利居贞，利建侯。', yaoMeaning: '创始之初，宜守正道，是建立基础的重要之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '屯如邅如，乘马班如。', yaoMeaning: '进退两难，行进艰难，是需要耐心等待时机之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '即鹿无虞，惟入于林中。', yaoMeaning: '盲目追求，缺乏指导，是容易迷失方向的危险之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '乘马班如，求婚媾。', yaoMeaning: '寻求合作，建立联盟，是沟通协调、寻求帮助之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '屯其膏，小贞吉，大贞凶。', yaoMeaning: '积蓄实力，小事可成，大事宜缓，是积累准备之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '乘马班如，泣血涟如。', yaoMeaning: '困难重重，进退维谷，是最艰难困苦的考验之日', dayIndex: 6, date: '', time: '' }
      ];
    case '谦':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '谦谦君子，用涉大川，吉。', yaoMeaning: '谦德之始，如山藏地中，是修身养性、奠定谦德基础之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '鸣谦，贞吉。', yaoMeaning: '谦德彰显，声名远播而保持谦逊，是内外兼修、德行感召之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '劳谦，君子有终，吉。', yaoMeaning: '勤勉谦逊，劳而不伐，是实干兴业、功成不居的奋斗之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '无不利，撝谦。', yaoMeaning: '发挥谦德，无所不利，是施展才能、利益众人的奉献之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '不富，以其邻，利用侵伐，无不利。', yaoMeaning: '谦德感召，众望所归，是以德服人、团结协作的领导之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '鸣谦，利用行师，征邑国。', yaoMeaning: '谦德至极，声威远播，是以德行教化、安邦定国的成就之日', dayIndex: 6, date: '', time: '' }
      ];
    case '睽':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '悔亡，丧马勿逐，自复。', yaoMeaning: '睽违之初，失去不追，是顺其自然、静待转机之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '遇主于巷，无咎。', yaoMeaning: '睽而相遇，意外相逢，是在困境中遇见贵人的转折之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '见舆曳，其牛掣，其人天且劓。', yaoMeaning: '睽违加剧，进退两难，是矛盾激化、需要耐心化解的考验之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '睽孤，遇元夫，交孚。', yaoMeaning: '孤独之睽，遇贤明之士，是以诚相交、化解分歧的合作之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '悔亡，厥宗噬肤，往何咎。', yaoMeaning: '睽违消解，宗族相助，是关系修复、重归于好的和谐之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '睽孤，见豕负涂，载鬼一车。', yaoMeaning: '睽违至极，幻象丛生，是澄清误解、回归现实的觉悟之日', dayIndex: 6, date: '', time: '' }
      ];
    case '升':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '允升，大吉。', yaoMeaning: '升进之始，顺时而升，是把握时机、稳步上升的吉利之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '孚乃利用禴，无咎。', yaoMeaning: '诚信而升，祭祀以诚，是德行提升、精神升华的修养之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '升虚邑。', yaoMeaning: '升入虚境，境界提升，是突破瓶颈、进入新境界的飞跃之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '王用亨于岐山，吉，无咎。', yaoMeaning: '君王升阶，祭祀岐山，是地位提升、获得认可的荣耀之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '贞吉，升阶。', yaoMeaning: '守正而升，步步高升，是稳步发展、持续进步的成功之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '冥升，利于不息之贞。', yaoMeaning: '暗昧之升，持续进德，是默默积累、厚积薄发的坚持之日', dayIndex: 6, date: '', time: '' }
      ];
    case '临':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '咸临，贞吉。', yaoMeaning: '临之初始，感化而临，是以德感人、潜移默化的引导之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '咸临，吉无不利。', yaoMeaning: '感化临民，德政广施，是恩泽众生、国泰民安的治理之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '甘临，无攸利，既忧之，无咎。', yaoMeaning: '甘甜之临，柔顺感化，是温和施政、以柔克刚的智慧之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '至临，无咎。', yaoMeaning: '极致之临，亲临现场，是深入基层、体察民情的务实之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '知临，大君之宜，吉。', yaoMeaning: '智慧之临，明察秋毫，是英明决策、运筹帷幄的领导之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '敦临，吉，无咎。', yaoMeaning: '敦厚之临，仁德感化，是厚德载物、德化天下的成就之日', dayIndex: 6, date: '', time: '' }
      ];
    case '小过':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '飞鸟以凶。', yaoMeaning: '小过之初，如鸟高飞，是行事过急、需要谨慎的开始之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '过其祖，遇其妣，不及其君，遇其臣。', yaoMeaning: '小有过越，遇合得宜，是适度超越、把握分寸的权衡之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '弗过防之，从或戕之，凶。', yaoMeaning: '防备不及，可能被害，是警惕防范、避免过失的谨慎之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '无咎，弗过遇之，往厉必戒。', yaoMeaning: '无过错失，适可而止，是见好就收、适可而止的明智之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '密云不雨，自我西郊。', yaoMeaning: '云密不雨，时机未到，是蓄势待发、等待时机的耐心之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '弗遇过之，飞鸟离之，凶。', yaoMeaning: '过而不遇，如鸟离网，是过度冒进、招致危险的警示之日', dayIndex: 6, date: '', time: '' }
      ];
    case '蒙':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '发蒙，利用刑人，用说桎梏，以往吝。', yaoMeaning: '启蒙之始，需用严教，是建立规矩、奠定基础的训导之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '包蒙吉，纳妇吉，子克家。', yaoMeaning: '包容蒙昧，德行感化，是宽严并济、德教为先的引导之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '勿用娶女，见金夫，不有躬，无攸利。', yaoMeaning: '蒙昧之困，见利忘义，是抵御诱惑、坚守正道的考验之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '困蒙，吝。', yaoMeaning: '蒙昧受困，进步困难，是突破障碍、寻求光明的奋斗之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '童蒙，吉。', yaoMeaning: '童稚蒙昧，可塑可教，是虚心学习、接受启蒙的求知之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '击蒙，不利为寇，利御寇。', yaoMeaning: '击破蒙昧，防御外侵，是清除障碍、保护成果的防卫之日', dayIndex: 6, date: '', time: '' }
      ];
    case '益':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '利用为大作，元吉，无咎。', yaoMeaning: '益之初始，大有作为，是把握机遇、建功立业的进取之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '或益之，十朋之龟弗克违，永贞吉。', yaoMeaning: '增益有时，天命难违，是顺应时势、坚持正道的守恒之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '益之，用凶事，无咎。', yaoMeaning: '益以解困，救凶济危，是扶危济困、利益他人的奉献之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '中行，告公从，利用为依迁国。', yaoMeaning: '中道而行，依公而行，是公正无私、利益万民的治理之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '有孚惠心，勿问元吉，有孚惠我德。', yaoMeaning: '诚信益民，德惠天下，是以德服人、泽被苍生的仁政之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '莫益之，或击之，立心勿恒，凶。', yaoMeaning: '益之极也，反受其害，是功成身退、适可而止的明智之日', dayIndex: 6, date: '', time: '' }
      ];
    case '渐':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '鸿渐于干，小子厉，有言，无咎。', yaoMeaning: '渐进之始，如鸿雁泊岸，是稳扎稳打、循序渐进的开端之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '鸿渐于磐，饮食衍衍，吉。', yaoMeaning: '渐进安稳，如雁磐石，是根基稳固、安居乐业的平和之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '鸿渐于陆，夫征不复，妇孕不育，凶。', yaoMeaning: '渐进陆上，进退两难，是面临挑战、需要坚持的考验之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '鸿渐于木，或得其桷，无咎。', yaoMeaning: '渐进林木，有所依托，是找到支撑、获得帮助的转机之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '鸿渐于陵，妇三岁不孕，终莫之胜，吉。', yaoMeaning: '渐进高地，终得成功，是历经考验、终获成功的成就之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '鸿渐于陆，其羽可用为仪，吉。', yaoMeaning: '渐进之极，羽毛可仪，是功德圆满、成为典范的荣耀之日', dayIndex: 6, date: '', time: '' }
      ];
    case '泰':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '拔茅茹，以其汇，征吉。', yaoMeaning: '泰之初始，拔茅连茹，是团结协作、共同前进的和谐之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '包荒，用冯河，不遐遗，朋亡，得尚于中行。', yaoMeaning: '泰而包容，包容荒秽，是宽宏大度、德化四方的仁德之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '无平不陂，无往不复，艰贞无咎，勿恤其孚，于食有福。', yaoMeaning: '泰中有险，平陂往复，是居安思危、谨慎前行的警醒之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '翩翩，不富以其邻，不戒以孚。', yaoMeaning: '泰而翩翩，诚信待人，是和谐共处、互相信任的友善之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '帝乙归妹，以祉元吉。', yaoMeaning: '泰之极盛，帝王嫁妹，是门当户对、天作之合的喜庆之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '城复于隍，勿用师，自邑告命，贞吝。', yaoMeaning: '泰极而否，城复于隍，是盛极而衰、需要转变的警示之日', dayIndex: 6, date: '', time: '' }
      ];
    case '履':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '素履，往无咎。', yaoMeaning: '履之初始，朴素而行，是脚踏实地、稳步前行的务实之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '履道坦坦，幽人贞吉。', yaoMeaning: '履道平坦，幽人守正，是道路畅通、顺利前行的平坦之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '眇能视，跛能履，履虎尾，咥人，凶。', yaoMeaning: '履虎之危，能力不足，是面临危险、需要提升能力的挑战之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '履虎尾，愬愬，终吉。', yaoMeaning: '履虎尾终，谨慎行事，是化险为夷、转危为安的成功之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '夬履，贞厉。', yaoMeaning: '决然而履，刚健有力，是果断决策、勇往直前的进取之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '视履考祥，其旋元吉。', yaoMeaning: '回顾履程，考察祥瑞，是总结经验、圆满成功的收获之日', dayIndex: 6, date: '', time: '' }
      ];
    case '兑':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '和兑，吉。', yaoMeaning: '悦之初始，和谐喜悦，是心情愉悦、关系融洽的和乐之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '孚兑，吉，悔亡。', yaoMeaning: '诚信喜悦，真实无妄，是真心交往、诚信相待的真诚之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '来兑，凶。', yaoMeaning: '来求喜悦，可能有凶，是警惕诱惑、保持清醒的谨慎之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '商兑，未宁，介疾有喜。', yaoMeaning: '商议喜悦，未得安宁，是沟通协调、化解分歧的和谐之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '孚于剥，有厉。', yaoMeaning: '喜悦于剥，可能有危，是居安思危、防范风险的警醒之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '引兑。', yaoMeaning: '引导喜悦，感化他人，是以德化人、传播快乐的教化之日', dayIndex: 6, date: '', time: '' }
      ];
    case '随':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '官有渝，贞吉，出门交有功。', yaoMeaning: '随之时变，官职变动，是适应变化、出门有为的机遇之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '系小子，失丈夫。', yaoMeaning: '随而失正，贪小失大，是明辨是非、正确选择的明智之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '系丈夫，失小子，随有求得，利居贞。', yaoMeaning: '随得正道，得大失小，是坚持原则、获得成功的收获之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '随有获，贞凶，有孚在道，以明，何咎。', yaoMeaning: '随而有获，可能招凶，是明哲保身、坚持正道的自守之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '孚于嘉，吉。', yaoMeaning: '诚信随善，吉祥如意，是择善而从、德行圆满的善德之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '拘系之，乃从维之，王用亨于西山。', yaoMeaning: '拘系而随，君王祭祀，是忠诚追随、功成名就的荣耀之日', dayIndex: 6, date: '', time: '' }
      ];
    case '无妄':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '无妄，往吉。', yaoMeaning: '无妄之始，正道而行，是诚实守信、无妄而为的正直之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '不耕获，不菑畲，则利有攸往。', yaoMeaning: '无妄而耕，不期收获，是顺其自然、不强求结果的淡然之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '无妄之灾，或系之牛，行人之得，邑人之灾。', yaoMeaning: '无妄受灾，意外损失，是防范意外、保持警惕的谨慎之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '可贞，无咎。', yaoMeaning: '无妄守正，可以坚持，是坚守正道、不改初心的坚持之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '无妄之疾，勿药有喜。', yaoMeaning: '无妄之疾，不药而愈，是自然恢复、无需干预的自愈之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '无妄，行有眚，无攸利。', yaoMeaning: '无妄之极，行必有灾，是适可而止、避免过度的明智之日', dayIndex: 6, date: '', time: '' }
      ];
    case '明夷':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '明夷于飞，垂其翼，君子于行，三日不食。', yaoMeaning: '明夷之初，光明受伤，是韬光养晦、隐忍待时的蛰伏之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '明夷，夷于左股，用拯马壮，吉。', yaoMeaning: '光明受损，左股受伤，是虽有损失但能及时补救的转机之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '明夷于南狩，得其大首，不可疾贞。', yaoMeaning: '明夷南征，获得大胜，是把握时机、一举成功的进取之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '入于左腹，获明夷之心，于出门庭。', yaoMeaning: '深入核心，了解真相，是洞察本质、明辨是非的觉悟之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '箕子之明夷，利贞。', yaoMeaning: '箕子明夷，守正不阿，是坚守气节、保持品格的节操之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '不明晦，初登于天，后入于地。', yaoMeaning: '光明尽失，晦暗无光，是物极必反、重新开始的转折之日', dayIndex: 6, date: '', time: '' }
      ];
    case '贲':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '贲其趾，舍车而徒。', yaoMeaning: '贲饰之始，装饰其足，是注重内在、不慕虚荣的朴实之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '贲其须。', yaoMeaning: '贲饰其须，修饰表面，是适度装饰、注重仪表的文明之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '贲如濡如，永贞吉。', yaoMeaning: '贲饰润泽，光彩照人，是文质彬彬、德才兼备的修养之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '贲如皤如，白马翰如，匪寇婚媾。', yaoMeaning: '贲饰纯白，如白马飞驰，是纯洁高尚、志向远大的理想之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '贲于丘园，束帛戋戋，吝，终吉。', yaoMeaning: '贲饰园丘，简约质朴，是返璞归真、回归自然的本真之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '白贲，无咎。', yaoMeaning: '纯白贲饰，朴素无华，是返璞归真、大美若拙的境界之日', dayIndex: 6, date: '', time: '' }
      ];
    case '既济':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '曳其轮，濡其尾，无咎。', yaoMeaning: '既济之始，谨慎行事，是稳扎稳打、步步为营的谨慎之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '妇丧其茀，勿逐，七日得。', yaoMeaning: '既济之时，失去勿追，是顺其自然、失而复得的耐心之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '高宗伐鬼方，三年克之，小人勿用。', yaoMeaning: '既济征伐，历时三年，是坚持不懈、终获成功的坚毅之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '繻有衣袽，终日戒。', yaoMeaning: '既济防漏，终日警戒，是居安思危、防患未然的警醒之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '东邻杀牛，不如西邻之禴祭，实受其福。', yaoMeaning: '既济祭祀，心诚为贵，是诚信为本、德行感召的真诚之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '濡其首，厉。', yaoMeaning: '既济之极，浸湿头部，是功成身退、避免过度的明智之日', dayIndex: 6, date: '', time: '' }
      ];
    case '家人':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '闲有家，悔亡。', yaoMeaning: '家人之始，防患于未然，是家庭和睦、预防问题的和谐之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '无攸遂，在中馈，贞吉。', yaoMeaning: '主内持家，无求成就，是专心持家、家庭美满的幸福之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '家人嗃嗃，悔厉吉，妇子嘻嘻，终吝。', yaoMeaning: '家规严明，虽有严厉但吉祥，是严格教育、培养子女的责任之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '富家，大吉。', yaoMeaning: '家庭富裕，大吉大利，是家境殷实、生活富足的安康之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '王假有家，勿恤，吉。', yaoMeaning: '君王有家，无忧无虑，是治国齐家、天下太平的盛世之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '有孚威如，终吉。', yaoMeaning: '诚信威严，终得吉祥，是德行感化、家庭荣耀的成就之日', dayIndex: 6, date: '', time: '' }
      ];
    case '丰':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '遇其配主，虽旬无咎，往有尚。', yaoMeaning: '丰之初遇，遇配主相助，是遇见贵人、获得支持的幸运之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '丰其蔀，日中见斗，往得疑疾，有孚发若，吉。', yaoMeaning: '丰盛之时，日中见斗，是盛极而衰、需要警醒的反思之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '丰其沛，日中见沫，折其右肱，无咎。', yaoMeaning: '丰盛过度，日中见沫，是盛极必损、需要收敛的节制之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '丰其蔀，日中见斗，遇其夷主，吉。', yaoMeaning: '丰盛遮蔽，遇明主相助，是克服障碍、获得突破的转机之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '来章，有庆誉，吉。', yaoMeaning: '丰而得章，有庆有誉，是功成名就、声名远播的荣耀之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '丰其屋，蔀其家，窥其户，阒其无人，三岁不觌，凶。', yaoMeaning: '丰之极盛，房屋遮蔽，是孤立无援、需要谦逊的警示之日', dayIndex: 6, date: '', time: '' }
      ];
    case '革':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '巩用黄牛之革。', yaoMeaning: '变革之始，固守用黄牛，是稳扎稳打、不轻举妄动的谨慎之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '己日乃革之，征吉，无咎。', yaoMeaning: '变革时机成熟，可以行动，是把握时机、果断改革的进取之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '征凶，贞厉，革言三就，有孚。', yaoMeaning: '变革征伐，可能有凶，是三思而后行、诚信待人的审慎之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '悔亡，有孚改命，吉。', yaoMeaning: '变革成功，悔恨消亡，是改革创新、获得成功的突破之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '大人虎变，未占有孚。', yaoMeaning: '大人变革，如虎变化，是威严改革、令人信服的成功之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '君子豹变，小人革面，征凶，居贞吉。', yaoMeaning: '君子豹变，小人革面，是变革完成、安居守正的稳定之日', dayIndex: 6, date: '', time: '' }
      ];
    case '同人':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '同人于门，无咎。', yaoMeaning: '同人之始，出门同人，是开放包容、广结善缘的和谐之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '同人于宗，吝。', yaoMeaning: '同于宗族，格局有限，是突破局限、扩大格局的开放之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '伏戎于莽，升其高陵，三岁不兴。', yaoMeaning: '伏兵草莽，三岁不兴，是积蓄力量、等待时机的耐心之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '乘其墉，弗克攻，吉。', yaoMeaning: '登墙攻城，不能攻克，是知难而退、另寻他路的明智之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '同人，先号啕而后笑，大师克相遇。', yaoMeaning: '同人先哭后笑，大军相遇，是历经磨难、终获成功的喜悦之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '同人于郊，无悔。', yaoMeaning: '同于郊野，无所悔恨，是心胸开阔、志向远大的超然之日', dayIndex: 6, date: '', time: '' }
      ];
    case '观':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '童观，小人无咎，君子吝。', yaoMeaning: '观察之初，如童子观，是虚心学习、保持谦逊的求知之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '窥观，利女贞。', yaoMeaning: '暗中观察，女守正道，是审时度势、细心观察的谨慎之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '观我生，进退。', yaoMeaning: '观察自身，决定进退，是自我反省、调整方向的思考之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '观国之光，利用宾于王。', yaoMeaning: '观国之光，利于为王，是洞察时势、把握机遇的进取之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '观我生，君子无咎。', yaoMeaning: '君子自观，无有过错，是修身齐家、德行高尚的修养之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '观其生，君子无咎。', yaoMeaning: '观察众生，君子无咎，是以民为本、体察民情的仁德之日', dayIndex: 6, date: '', time: '' }
      ];
    case '比':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '有孚比之，无咎，有孚盈缶，终来有他，吉。', yaoMeaning: '比之初亲，诚信比附，是真诚交往、建立信任的友好之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '比之自内，贞吉。', yaoMeaning: '由内比附，守正则吉，是内外一致、真诚相待的和谐之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '比之匪人。', yaoMeaning: '比附匪人，可能不利，是明辨是非、择善而从的明智之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '外比之，贞吉。', yaoMeaning: '向外比附，守正则吉，是广结善缘、拓展关系的开放之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '显比，王用三驱，失前禽，邑人不诫，吉。', yaoMeaning: '光明比附，王用三驱，是宽宏大度、德化四方的仁德之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '比之无首，凶。', yaoMeaning: '比附无首，可能招凶，是避免盲从、保持独立的清醒之日', dayIndex: 6, date: '', time: '' }
      ];
    case '剥':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '剥床以足，蔑贞凶。', yaoMeaning: '剥落之始，床足剥落，是基础动摇、需要加固的警醒之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '剥床以辨，蔑贞凶。', yaoMeaning: '剥落加剧，床辨剥落，是危机加深、急需应对的紧急之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '剥之，无咎。', yaoMeaning: '剥落之时，顺其自然，是顺应时势、避免强求的明智之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '剥床以肤，凶。', yaoMeaning: '剥落及肤，直接受凶，是危机临身、必须采取行动的应对之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '贯鱼以宫人宠，无不利。', yaoMeaning: '贯鱼受宠，秩序井然，是化解危机、重建秩序的转机之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '硕果不食，君子得舆，小人剥庐。', yaoMeaning: '硕果不食，君子得车，是善恶有报、择善而得的结果之日', dayIndex: 6, date: '', time: '' }
      ];
    case '坤':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '履霜，坚冰至。', yaoMeaning: '坤之初始，履霜知冰，是防微杜渐、见微知著的警醒之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '直方大，不习无不利。', yaoMeaning: '坤德中正，直方大德，是品德高尚、无需学习的天赋之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '含章可贞，或从王事，无成有终。', yaoMeaning: '含章守正，可从事王事，是才华内敛、默默奉献的忠诚之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '括囊，无咎，无誉。', yaoMeaning: '束紧口袋，谨慎言行，是保守秘密、避免张扬的低调之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '黄裳，元吉。', yaoMeaning: '黄色衣裳，大吉大利，是德配其位、谦逊尊贵的荣耀之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '龙战于野，其血玄黄。', yaoMeaning: '坤之极盛，龙战于野，是阴阳相争、需要转化的冲突之日', dayIndex: 6, date: '', time: '' }
      ];
    case '师':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '师出以律，否臧凶。', yaoMeaning: '师出以律，纪律严明，是制定规则、建立秩序的规范之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '在师中，吉，无咎，王三锡命。', yaoMeaning: '在师中正，吉无不利，是掌握中道、获得认可的领导之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '师或舆尸，凶。', yaoMeaning: '师出舆尸，可能招凶，是指挥失误、需要反思的教训之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '师左次，无咎。', yaoMeaning: '师左次退，无有过错，是战略撤退、保存实力的明智之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '田有禽，利执言，无咎，长子帅师，弟子舆尸，贞凶。', yaoMeaning: '田有禽兽，利有执言，是把握时机、正确决策的进取之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '大君有命，开国承家，小人勿用。', yaoMeaning: '大君有命，开国承家，是论功行赏、任人唯贤的公正之日', dayIndex: 6, date: '', time: '' }
      ];
    case '坎':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '习坎，入于坎窞，凶。', yaoMeaning: '坎险之初，陷入深坑，是面临困难、需要谨慎的挑战之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '坎有险，求小得。', yaoMeaning: '坎中有险，小有获得，是克服困难、取得小胜的进步之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '来之坎坎，险且枕，入于坎窞，勿用。', yaoMeaning: '来则坎坎，险难枕藉，是困难重重、不宜行动的等待之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '樽酒簋贰，用缶，纳约自牖，终无咎。', yaoMeaning: '樽酒簋贰，简约自牖，是诚信待人、化解困难的智慧之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '坎不盈，祗既平，无咎。', yaoMeaning: '坎不满溢，平整无咎，是克服困难、趋于平稳的转机之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '系用徽纆，寘于丛棘，三岁不得，凶。', yaoMeaning: '被系束缚，困于丛棘，是陷入困境、难以脱身的危机之日', dayIndex: 6, date: '', time: '' }
      ];
    case '涣':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '用拯马壮，吉。', yaoMeaning: '涣之初始，用壮马拯救，是把握时机、及时行动的果断之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '涣奔其机，悔亡。', yaoMeaning: '涣散奔走，悔恨消亡，是迅速行动、避免损失的积极之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '涣其躬，无悔。', yaoMeaning: '涣散其身，无所悔恨，是放下自我、融入集体的奉献之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '涣其群，元吉，涣有丘，匪夷所思。', yaoMeaning: '涣散其群，大吉大利，是化解分歧、团结统一的和谐之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '涣汗其大号，涣王居，无咎。', yaoMeaning: '涣汗大号，王居无咎，是发布政令、推行改革的权威之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '涣其血，去逖出，无咎。', yaoMeaning: '涣散其血，远出无咎，是消除灾害、获得安全的平安之日', dayIndex: 6, date: '', time: '' }
      ];
    case '解':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '无咎。', yaoMeaning: '解之初始，无有过错，是顺利开始、无障碍的顺利之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '田获三狐，得黄矢，贞吉。', yaoMeaning: '田猎获狐，得黄矢吉，是获得战利品、收获成果的丰收之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '负且乘，致寇至，贞吝。', yaoMeaning: '背负乘车，招致寇至，是招摇过市、需要低调的警醒之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '解而拇，朋至斯孚。', yaoMeaning: '解其拇指，朋友来至，是解除束缚、获得帮助的解脱之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '君子维有解，吉，有孚于小人。', yaoMeaning: '君子有解，吉祥如意，是以德服人、感化小人的教化之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '公用射隼于高墉之上，获之，无不利。', yaoMeaning: '射隼高墉，获得无不利，是高瞻远瞩、一举成功的收获之日', dayIndex: 6, date: '', time: '' }
      ];
    case '恒':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '浚恒，贞凶，无攸利。', yaoMeaning: '恒之初始，深入求恒，可能招凶，是循序渐进、不宜冒进的耐心之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '悔亡。', yaoMeaning: '持之以恒，悔恨消亡，是坚持不懈、终获成功的坚持之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '不恒其德，或承之羞，贞吝。', yaoMeaning: '不能恒德，可能承羞，是保持品德、避免羞辱的修养之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '田无禽。', yaoMeaning: '田猎无禽，一无所获，是时机不对、需要等待的观察之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '恒其德，贞，妇人吉，夫子凶。', yaoMeaning: '恒其德行，妇人吉而夫子凶，是各守其位、各尽其责的本分之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '振恒，凶。', yaoMeaning: '振动恒久，可能招凶，是动摇不定、需要坚定的稳固之日', dayIndex: 6, date: '', time: '' }
      ];
    case '井':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '井泥不食，旧井无禽。', yaoMeaning: '井之初始，井泥不食，是基础不牢、需要整修的整顿之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '井谷射鲋，瓮敝漏。', yaoMeaning: '井谷射鲋，瓮敝漏水，是设备老化、需要更新的改进之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '井渫不食，为我心恻，可用汲，王明并受其福。', yaoMeaning: '井水清洁，无人饮用，是才华被埋没、需要发现的重用之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '井甃，无咎。', yaoMeaning: '井壁修整，无有过错，是完善设施、提高质量的改善之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '井冽，寒泉食。', yaoMeaning: '井水清澈，寒泉可食，是品质优良、受益众人的奉献之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '井收勿幕，有孚元吉。', yaoMeaning: '井成不盖，诚信大吉，是开放共享、利益众人的善德之日', dayIndex: 6, date: '', time: '' }
      ];
    case '大过':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '藉用白茅，无咎。', yaoMeaning: '大过之始，用白茅铺垫，是谨慎行事、注重细节的审慎之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '枯杨生稊，老夫得其女妻，无不利。', yaoMeaning: '枯杨生芽，老夫少妻，是老当益壮、焕发活力的新生之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '栋桡，凶。', yaoMeaning: '栋梁弯曲，可能招凶，是结构不稳、需要加固的危险之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '栋隆，吉，有它吝。', yaoMeaning: '栋梁隆起，吉祥如意，是基础牢固、发展顺利的成功之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '枯杨生华，老妇得其士夫，无咎无誉。', yaoMeaning: '枯杨开花，老妇少夫，是晚年幸福、生活美满的安享之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '过涉灭顶，凶，无咎。', yaoMeaning: '过涉灭顶，虽凶无咎，是冒险犯难、义无反顾的勇敢之日', dayIndex: 6, date: '', time: '' }
      ];
    case '姤':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '系于金柅，贞吉，有攸往，见凶，羸豕孚踯躅。', yaoMeaning: '姤之初始，系于金柅，是把握时机、谨慎前行的警醒之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '包有鱼，无咎，不利宾。', yaoMeaning: '包中有鱼，无过错，是有所收获、不宜张扬的低调之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '臀无肤，其行次且，厉，无大咎。', yaoMeaning: '臀无肌肤，行走困难，是虽有困难但无大碍的坚持之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '包无鱼，起凶。', yaoMeaning: '包中无鱼，可能招凶，是空虚无物、需要充实的反思之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '以杞包瓜，含章，有陨自天。', yaoMeaning: '以杞包瓜，含章之美，是内秀外朴、天降良机的幸运之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '姤其角，吝，无咎。', yaoMeaning: '遇其角，虽有吝但无咎，是遭遇阻碍、但能克服的挑战之日', dayIndex: 6, date: '', time: '' }
      ];
    case '鼎':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '鼎颠趾，利出否，得妾以其子，无咎。', yaoMeaning: '鼎之初始，颠倒其足，是革故鼎新、清除废物的变革之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '鼎有实，我仇有疾，不我能即，吉。', yaoMeaning: '鼎中有实，仇人有疾，是实力充实、无人能敌的强大之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '鼎耳革，其行塞，雉膏不食，方雨亏悔，终吉。', yaoMeaning: '鼎耳变革，行动受阻，是暂时困难、终将成功的转机之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '鼎折足，覆公餗，其形渥，凶。', yaoMeaning: '鼎足折断，倾覆公食，是重大失误、需要反思的教训之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '鼎黄耳金铉，利贞。', yaoMeaning: '鼎黄耳金铉，利于守正，是地位尊贵、德才兼备的荣耀之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '鼎玉铉，大吉，无不利。', yaoMeaning: '鼎玉铉饰，大吉大利，是功德圆满、万事如意的成功之日', dayIndex: 6, date: '', time: '' }
      ];
    case '巽':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '进退，利武人之贞。', yaoMeaning: '巽之初始，进退不定，是果断决策、勇往直前的进取之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '巽在床下，用史巫纷若，吉，无咎。', yaoMeaning: '巽在床下，用史巫纷，是谦逊顺从、获得帮助的和谐之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '频巽，吝。', yaoMeaning: '频繁巽顺，可能招吝，是过度谦让、需要坚持原则的反思之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '悔亡，田获三品。', yaoMeaning: '悔恨消亡，田获三品，是收获颇丰、成果显著的丰收之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '贞吉，悔亡，无不利，无初有终，先庚三日，后庚三日，吉。', yaoMeaning: '守正吉，悔亡无不利，是善始善终、前后兼顾的圆满之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '巽在床下，丧其资斧，贞凶。', yaoMeaning: '巽在床下，丧失资斧，是过度谦让、招致损失的警惕之日', dayIndex: 6, date: '', time: '' }
      ];
    case '豫':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '鸣豫，凶。', yaoMeaning: '豫之初鸣，可能招凶，是得意忘形、需要谨慎的警醒之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '介于石，不终日，贞吉。', yaoMeaning: '介如磐石，不终日变，是坚定不移、持之以恒的坚持之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '盱豫，悔，迟有悔。', yaoMeaning: '仰视豫乐，必有悔恨，是贪图享乐、需要反思的节制之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '由豫，大有得，勿疑，朋盍簪。', yaoMeaning: '由豫大有得，朋友聚会，是收获成果、朋友相助的喜庆之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '贞疾，恒不死。', yaoMeaning: '贞正有疾，恒久不死，是虽有疾病但终无碍的坚韧之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '冥豫，成有渝，无咎。', yaoMeaning: '冥豫有成，有所改变，是反省改过、重新开始的希望之日', dayIndex: 6, date: '', time: '' }
      ];
    case '蛊':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '干父之蛊，有子，考无咎，厉终吉。', yaoMeaning: '蛊之初始，纠正父过，是承前启后、继往开来的改革之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '干母之蛊，不可贞。', yaoMeaning: '纠正母过，不可固执，是因势利导、灵活处理的智慧之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '干父之蛊，小有悔，无大咎。', yaoMeaning: '纠正父过，小有悔恨，是虽有挫折但无大碍的坚持之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '裕父之蛊，往见吝。', yaoMeaning: '宽容父过，可能招吝，是姑息养奸、需要纠正的警示之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '干父之蛊，用誉。', yaoMeaning: '纠正父过，获得声誉，是拨乱反正、获得赞誉的成功之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '不事王侯，高尚其事。', yaoMeaning: '不事王侯，高尚其事，是超然物外、追求理想的境界之日', dayIndex: 6, date: '', time: '' }
      ];
    case '讼':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '不永所事，小有言，终吉。', yaoMeaning: '讼之初始，不永纠缠，是及时化解、避免升级的明智之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '不克讼，归而逋，其邑人三百户，无眚。', yaoMeaning: '诉讼不胜，逃归其邑，是知难而退、保全自身的明智之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '食旧德，贞厉，终吉，或从王事，无成。', yaoMeaning: '食旧德业，守正有危，是安分守己、终获平安的稳健之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '不克讼，复即命，渝，安贞吉。', yaoMeaning: '诉讼不胜，复命变通，是顺应时势、改变策略的灵活之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '讼元吉。', yaoMeaning: '诉讼大吉，正义得伸，是正义获胜、公道彰显的公正之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '或锡之鞶带，终朝三褫之。', yaoMeaning: '或赐鞶带，终朝三夺，是荣誉短暂、需要谦虚的警醒之日', dayIndex: 6, date: '', time: '' }
      ];
    case '旅':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '旅琐琐，斯其所取灾。', yaoMeaning: '旅之初始，琐琐而行，是准备充分、避免意外的谨慎之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '旅即次，怀其资，得童仆，贞。', yaoMeaning: '旅居其次，怀其资斧，是安身立命、有备无患的安稳之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '旅焚其次，丧其童仆，贞厉。', yaoMeaning: '旅焚其次，丧其童仆，是遭遇变故、需要冷静的应对之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '旅于处，得其资斧，我心不快。', yaoMeaning: '旅于其处，得资斧而不快，是有所得但不如意的复杂之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '射雉，一矢亡，终以誉命。', yaoMeaning: '射雉一矢，终以誉命，是付出代价、终获荣誉的收获之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '鸟焚其巢，旅人先笑后号啕。', yaoMeaning: '鸟焚其巢，先笑后号，是乐极生悲、需要警醒的反思之日', dayIndex: 6, date: '', time: '' }
      ];
    case '未济':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '濡其尾，吝。', yaoMeaning: '未济之始，浸湿尾巴，是准备不足、需要完善的准备之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '曳其轮，贞吉。', yaoMeaning: '拖曳其轮，守正则吉，是稳步推进、循序渐进的务实之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '未济，征凶，利涉大川。', yaoMeaning: '事未完成，征伐有凶，是时机未到、需要等待的耐心之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '贞吉，悔亡，震用伐鬼方，三年有赏于大国。', yaoMeaning: '守正吉，悔亡，是坚持正道、终获成功的收获之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '贞吉，无悔，君子之光，有孚，吉。', yaoMeaning: '守正吉，无悔，君子之光，是德行彰显、诚信为本的荣耀之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '有孚于饮酒，无咎，濡其首，有孚失是。', yaoMeaning: '诚信饮酒，无过错，是适度享乐、保持清醒的平衡之日', dayIndex: 6, date: '', time: '' }
      ];
    case '困':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '臀困于株木，入于幽谷，三岁不觌。', yaoMeaning: '困之初始，臀困株木，是陷入困境、需要坚持的考验之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '困于酒食，朱绂方来，利用享祀，征凶，无咎。', yaoMeaning: '困于酒食，朱绂方来，是物质丰富但精神困乏的反思之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '困于石，据于蒺藜，入于其宫，不见其妻，凶。', yaoMeaning: '困于石上，据于蒺藜，是内外交困、需要突破的挑战之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '来徐徐，困于金车，吝，有终。', yaoMeaning: '来徐徐困，困于金车，是进展缓慢但终有成的坚持之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '劓刖，困于赤绂，乃徐有说，利用祭祀。', yaoMeaning: '劓刖之困，困于赤绂，是权力受限、需要谦逊的警醒之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '困于葛藟，于臲卼，曰动悔有悔，征吉。', yaoMeaning: '困于葛藟，动摇不定，是突破束缚、勇往直前的进取之日', dayIndex: 6, date: '', time: '' }
      ];
    case '蹇':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '往蹇，来誉。', yaoMeaning: '蹇之初始，前往有难，是知难而退、获得赞誉的明智之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '王臣蹇蹇，匪躬之故。', yaoMeaning: '王臣蹇蹇，非为己故，是忠诚尽责、无私奉献的担当之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '往蹇，来反。', yaoMeaning: '往有蹇难，来则返回，是审时度势、适时调整的灵活之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '六四', yaoText: '往蹇，来连。', yaoMeaning: '往有蹇难，来则连接，是团结协作、共同应对的互助之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '大蹇朋来。', yaoMeaning: '大蹇之时，朋友来助，是患难见真情、获得帮助的温暖之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '往蹇，来硕，吉，利见大人。', yaoMeaning: '往有蹇难，来则硕大，是获得丰厚回报、成功的收获之日', dayIndex: 6, date: '', time: '' }
      ];
    case '否':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '拔茅茹，以其汇，贞吉，亨。', yaoMeaning: '否之初始，拔茅连茹，是团结一心、共渡难关的协作之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '包承，小人吉，大人否，亨。', yaoMeaning: '包容承受，小人吉而大人否，是明辨是非、坚持原则的坚守之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '包羞。', yaoMeaning: '包容羞辱，是忍辱负重、等待时机的坚韧之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '有命，无咎，畴离祉。', yaoMeaning: '有天之命，无有过错，是顺应天命、获得福佑的幸运之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '休否，大人吉。', yaoMeaning: '休止否塞，大人吉祥，是扭转局面、迎来转机的希望之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '倾否，先否后喜。', yaoMeaning: '倾覆否塞，先否后喜，是物极必反、否极泰来的转机之日', dayIndex: 6, date: '', time: '' }
      ];
    case '萃':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '有孚不终，乃乱乃萃，若号，一握为笑，勿恤，往无咎。', yaoMeaning: '萃之初始，诚信不终，是诚信缺失、需要重建的反思之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '引吉，无咎，孚乃利用禴。', yaoMeaning: '牵引而吉，无有过错，是以德感召、凝聚人心的团结之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '萃如，嗟如，无攸利，往无咎，小吝。', yaoMeaning: '萃聚嗟叹，无所利益，是虽有小吝但无大碍的坚持之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '大吉，无咎。', yaoMeaning: '大吉大利，无有过错，是团结一致、取得成功的收获之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '九五', yaoText: '萃有位，无咎，匪孚，元永贞，悔亡。', yaoMeaning: '萃居其位，无有过错，是德配其位、长久守正的稳固之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '赍咨涕洟，无咎。', yaoMeaning: '赍咨涕洟，无有过错，是真情流露、感化他人的真诚之日', dayIndex: 6, date: '', time: '' }
      ];
    case '晋':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初六', yaoText: '晋如，摧如，贞吉，罔孚，裕无咎。', yaoMeaning: '晋之初始，进退有度，是稳步前进、宽厚待人的进取之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '六二', yaoText: '晋如，愁如，贞吉，受兹介福，于其王母。', yaoMeaning: '晋而愁如，守正则吉，是获得大福、蒙受恩泽的幸运之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '六三', yaoText: '众允，悔亡。', yaoMeaning: '众人允从，悔恨消亡，是获得认可、众望所归的成功之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '晋如，鼫鼠，贞厉。', yaoMeaning: '晋如鼫鼠，守正有危，是能力不足、需要提升的反思之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '悔亡，失得勿恤，往吉，无不利。', yaoMeaning: '悔亡无悔，得失勿恤，是勇往直前、无所畏惧的进取之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上九', yaoText: '晋其角，维用伐邑，厉吉，无咎，贞吝。', yaoMeaning: '晋其角，维用伐邑，是进取有功、虽有危险的成就之日', dayIndex: 6, date: '', time: '' }
      ];
    case '大壮':
      return [
        { yaoPosition: '初爻', yaoSymbol: '初九', yaoText: '壮于趾，征凶，有孚。', yaoMeaning: '大壮之初，壮于足趾，是根基稳固、不宜冒进的谨慎之日', dayIndex: 1, date: '', time: '' },
        { yaoPosition: '二爻', yaoSymbol: '九二', yaoText: '贞吉。', yaoMeaning: '守正则吉，大壮守中，是坚持正道、稳步前行的稳健之日', dayIndex: 2, date: '', time: '' },
        { yaoPosition: '三爻', yaoSymbol: '九三', yaoText: '小人用壮，君子用罔，贞厉，羝羊触藩，羸其角。', yaoMeaning: '小人用壮，君子不用，是克己复礼、避免冲动的节制之日', dayIndex: 3, date: '', time: '' },
        { yaoPosition: '四爻', yaoSymbol: '九四', yaoText: '贞吉，悔亡，藩决不羸，壮于大舆之輹。', yaoMeaning: '守正吉，悔亡，藩决不羸，是突破障碍、势不可挡的奋进之日', dayIndex: 4, date: '', time: '' },
        { yaoPosition: '五爻', yaoSymbol: '六五', yaoText: '丧羊于易，无悔。', yaoMeaning: '丧羊于易，无所悔恨，是失去小利、获得大得的智慧之日', dayIndex: 5, date: '', time: '' },
        { yaoPosition: '上爻', yaoSymbol: '上六', yaoText: '羝羊触藩，不能退，不能遂，无攸利，艰则吉。', yaoMeaning: '羝羊触藩，进退两难，是艰难困苦、终将吉利的坚持之日', dayIndex: 6, date: '', time: '' }
      ];
    default:
      break;
  }
  
  // 如果没有具体爻辞数据，生成通用版本
  const yaoPositions = ['初爻', '二爻', '三爻', '四爻', '五爻', '上爻'];
  const yaoSymbols = ['初九', '六二', '六三', '六四', '九五', '上九']; // 简化处理
  
  const result: YaoInfo[] = [];
  for (let index = 0; index < yaoPositions.length; index++) {
    const position = yaoPositions[index];
    const yaoInfo: YaoInfo = {
      yaoPosition: position,
      yaoSymbol: yaoSymbols[index],
      yaoText: `${guaName}${position}爻辞`,
      yaoMeaning: `${guaName}卦${position}主导之日，宜观察${position}爻象变化`,
      dayIndex: index + 1,
      date: '',
      time: ''
    };
    result.push(yaoInfo);
  }
  
  return result;
}

/**
 * 格式化日期为 MM-DD 格式
 */
function formatDate(date: Date): string {
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const day = date.getDate().toString().padStart(2, '0');
  return `${month}-${day}`;
}

/**
 * 格式化时间为 HH:mm 格式
 */
function formatTime(date: Date): string {
  const hour = date.getHours().toString().padStart(2, '0');
  const minute = date.getMinutes().toString().padStart(2, '0');
  return `${hour}:${minute}`;
}

/**
 * 获取冬至日期（复用GuaQiData中的逻辑）
 */
function getDongzhiDate(year: number): string {
  switch (year) {
    // 2010-2019年
    case 2010: return '12-22';
    case 2011: return '12-22';
    case 2012: return '12-21';
    case 2013: return '12-21';
    case 2014: return '12-22';
    case 2015: return '12-22';
    case 2016: return '12-21';
    case 2017: return '12-22';
    case 2018: return '12-22';
    case 2019: return '12-22';
    
    // 2020-2030年
    case 2020: return '12-21';
    case 2021: return '12-21';
    case 2022: return '12-22';
    case 2023: return '12-22';
    case 2024: return '12-21';
    case 2025: return '12-21';
    case 2026: return '12-21';
    case 2027: return '12-22';
    case 2028: return '12-21';
    case 2029: return '12-21';
    case 2030: return '12-21';
    
    // 2031-2040年
    case 2031: return '12-22';
    case 2032: return '12-21';
    case 2033: return '12-21';
    case 2034: return '12-22';
    case 2035: return '12-22';
    case 2036: return '12-21';
    case 2037: return '12-21';
    case 2038: return '12-22';
    case 2039: return '12-22';
    case 2040: return '12-21';
    
    default: return '12-21';
  }
}

/**
 * 获取卦气特征描述（复用GuaQiData中的逻辑）
 */
function getGuaQiFeature(guaName: string): string {
  switch (guaName) {
    case '中孚': return '阳气初生，微温';
    case '复': return '一阳来复，草木萌动';
    case '屯': return '创始艰难，郁结未通';
    case '谦': return '谦和卑下，地中有山';
    case '睽': return '二女相违，乖异求同';
    case '升': return '地中生木，柔顺上进';
    case '临': return '二阳渐长，临近春意';
    case '小过': return '小有过越，雷在山上';
    case '蒙': return '山下出泉，启蒙教育';
    case '益': return '风雷相益，损上益下';
    case '渐': return '山上有木，渐进发展';
    case '泰': return '天地交泰，万物通达';
    case '履': return '天泽履，礼仪之道';
    case '兑': return '泽泽相连，和悦欢乐';
    case '随': return '泽中有雷，随时而动';
    case '无妄': return '天下雷行，无妄而动';
    case '明夷': return '地火明夷，光明受伤';
    case '贲': return '山火贲，文明装饰';
    case '既济': return '水火既济，功德圆满';
    case '家人': return '风火家人，齐家治国';
    case '丰': return '雷火丰，盛大丰满';
    case '革': return '泽火革，变革更新';
    case '同人': return '天火同人，同心协力';
    case '观': return '风地观，观察省思';
    case '比': return '水地比，亲密比附';
    case '剥': return '山地剥，剥落衰败';
    case '坤': return '地地坤，厚德载物';
    case '师': return '地水师，众人之师';
    case '坎': return '水水坎，险阻重重';
    case '涣': return '风水涣，涣散离析';
    case '解': return '雷水解，解除困难';
    case '恒': return '雷风恒，恒久不变';
    case '井': return '水风井，井养不穷';
    case '大过': return '泽风大过，大有过越';
    case '姤': return '天风姤，天下有风';
    case '鼎': return '火风鼎，革故鼎新';
    case '巽': return '风风巽，谦逊顺从';
    case '大壮': return '雷天大壮，刚健有力';
    case '豫': return '雷地豫，和乐安逸';
    case '蛊': return '山风蛊，整治腐败';
    case '讼': return '天水讼，争讼不休';
    case '旅': return '火山旅，行旅在外';
    case '未济': return '火水未济，事未完成';
    case '困': return '泽水困，困顿艰难';
    case '蹇': return '水山蹇，艰难险阻';
    case '否': return '天地否，闭塞不通';
    case '萃': return '泽地萃，聚集荟萃';
    case '晋': return '火地晋，光明上进';
    default: return '卦气特征';
  }
}

/**
 * 生成指定年份的分卦值日表
 */
export function generateFenGuaZhiRiTable(year: number): YearFenGuaZhiRi {
  // 六十值日卦固定顺序表（复用GuaQiData中的数据）
  const LIUSHI_ZHIRI_GUA_ORDER: string[] = [
    '中孚', '复', '屯', '谦', '睽', '升', '临', '小过', '蒙', '益',
    '渐', '泰', '履', '兑', '随', '无妄', '明夷', '贲', '既济', '家人',
    '丰', '革', '同人', '临', '观', '比', '剥', '坤', '师', '蒙',
    '坎', '涣', '解', '恒', '升', '井', '大过', '姤', '鼎', '巽',
    '恒', '鼎', '大壮', '豫', '解', '随', '蛊', '升', '讼', '旅',
    '未济', '困', '革', '蹇', '谦', '否', '萃', '晋', '豫', '观'
  ];

  // 获取冬至日期
  const dongzhiDate = getDongzhiDate(year);
  
  // 解析冬至日期
  const dateParts = dongzhiDate.split('-');
  const month = parseInt(dateParts[0]);
  const day = parseInt(dateParts[1]);
  const dongzhiDateTime = new Date(year, month - 1, day, 0, 0, 0);
  
  const fenGuaList: FenGuaZhiRiItem[] = [];
  
  // 每卦值日时长：6日7分 = 8766分钟
  const GUA_DURATION_MINUTES = 8766;
  
  // 生成60卦的分卦值日表
  for (let i = 0; i < 60; i++) {
    const guaName = LIUSHI_ZHIRI_GUA_ORDER[i];
    const guaStartTime = new Date(dongzhiDateTime.getTime() + i * GUA_DURATION_MINUTES * 60 * 1000);
    const guaEndTime = new Date(guaStartTime.getTime() + GUA_DURATION_MINUTES * 60 * 1000);
    
    // 获取该卦的爻辞数据
    const yaoData = getGuaYaoData(guaName);
    
    // 为每一爻计算具体的日期和时间
    const yaoList: YaoInfo[] = [];
    for (let yaoIndex = 0; yaoIndex < yaoData.length; yaoIndex++) {
      const yao = yaoData[yaoIndex];
      // 每日开始时间 = 卦开始时间 + yaoIndex * 24小时
      const dayStartTime = new Date(guaStartTime.getTime() + yaoIndex * DAY_DURATION_MINUTES * 60 * 1000);
      const dayEndTime = new Date(dayStartTime.getTime() + DAY_DURATION_MINUTES * 60 * 1000);
      
      const yaoInfo: YaoInfo = {
        yaoPosition: yao.yaoPosition,
        yaoSymbol: yao.yaoSymbol,
        yaoText: yao.yaoText,
        yaoMeaning: yao.yaoMeaning,
        dayIndex: yao.dayIndex,
        date: formatDate(dayStartTime),
        time: `${formatTime(dayStartTime)}-${formatTime(dayEndTime)}`
      };
      
      yaoList.push(yaoInfo);
    }
    
    // 确定当期节气段（简化处理）
    const startMonth = guaStartTime.getMonth() + 1;
    let solarTerm = '';
    if (startMonth === 12 || startMonth === 1) {
      solarTerm = '冬至-小寒';
    } else if (startMonth === 1 || startMonth === 2) {
      solarTerm = '小寒-大寒';
    } else if (startMonth === 2 || startMonth === 3) {
      solarTerm = '大寒-立春';
    } else if (startMonth === 3 || startMonth === 4) {
      solarTerm = '立春-雨水';
    } else if (startMonth === 4 || startMonth === 5) {
      solarTerm = '雨水-惊蛰';
    } else if (startMonth === 5 || startMonth === 6) {
      solarTerm = '惊蛰-春分';
    } else if (startMonth === 6 || startMonth === 7) {
      solarTerm = '春分-清明';
    } else if (startMonth === 7 || startMonth === 8) {
      solarTerm = '清明-谷雨';
    } else if (startMonth === 8 || startMonth === 9) {
      solarTerm = '谷雨-立夏';
    } else if (startMonth === 9 || startMonth === 10) {
      solarTerm = '立夏-小满';
    } else if (startMonth === 10 || startMonth === 11) {
      solarTerm = '小满-芒种';
    } else {
      solarTerm = '芒种-夏至';
    }
    
    const fenGuaItem: FenGuaZhiRiItem = {
      guaName: guaName,
      guaIndex: i + 1,
      startDate: formatDate(guaStartTime),
      endDate: formatDate(guaEndTime),
      solarTerm: solarTerm,
      yaoList: yaoList,
      guaQiFeature: getGuaQiFeature(guaName)
    };
    
    fenGuaList.push(fenGuaItem);
  }
  
  return {
    year: year,
    dongzhiDate: `${year}-${dongzhiDate}`,
    fenGuaList: fenGuaList
  };
}

/**
 * 获取爻位颜色（基于爻的阴阳属性）
 */
export function getYaoColor(yaoSymbol: string): string {
  if (yaoSymbol.includes('九')) {
    return '#FF6B35'; // 阳爻 - 橙红色
  } else if (yaoSymbol.includes('六')) {
    return '#4A90E2'; // 阴爻 - 蓝色
  } else {
    return '#8E24AA'; // 默认紫色
  }
}