/*
 * AI 服务管理器：模型选择、API Key 存储、域限制
 */

export type ModelName = 'DeepSeek' | 'Qwen' | 'Doubao' | 'MiniMax';

export interface AIConfig {
  selectedModel: ModelName;
  deepseekKey: string;
  qwenKey: string;
  doubaoKey: string;
  minimaxKey: string;
  allowInternet: boolean; // 是否允许联网（默认走本地库优先）
}

export class AIServiceManager {
  private static instance: AIServiceManager;
  private config: AIConfig = {
    selectedModel: 'DeepSeek',
    deepseekKey: '',
    qwenKey: '',
    doubaoKey: '',
    minimaxKey: '',
    allowInternet: true
  };

  private constructor() {}

  static getInstance(): AIServiceManager {
    if (!AIServiceManager.instance) {
      AIServiceManager.instance = new AIServiceManager();
    }
    return AIServiceManager.instance;
  }

  getConfig(): AIConfig {
    return this.config;
  }

  updateConfig(newCfg: Partial<AIConfig>): void {
    const cfg = this.config;
    if (newCfg.selectedModel) { cfg.selectedModel = newCfg.selectedModel; }
    if (newCfg.deepseekKey !== undefined) { cfg.deepseekKey = newCfg.deepseekKey; }
    if (newCfg.qwenKey !== undefined) { cfg.qwenKey = newCfg.qwenKey; }
    if (newCfg.doubaoKey !== undefined) { cfg.doubaoKey = newCfg.doubaoKey; }
    if (newCfg.minimaxKey !== undefined) { cfg.minimaxKey = newCfg.minimaxKey; }
    if (newCfg.allowInternet !== undefined) { cfg.allowInternet = newCfg.allowInternet; }
  }

  // 领域限制：仅允许项目领域（易学类象、六十四卦、京房、纳音、天干地支、河图洛书、指南针等）
  isQueryAllowed(query: string): boolean {
    const key = query.trim();
    if (key === '') { return false; }
    const domain: string[] = ['易学', '类象', '六十四卦', '京房', '纳音', '天干', '地支', '八卦', '河图', '洛书', '焦氏易林', '小成图', '指南针', '卦气'];
    for (let i = 0; i < domain.length; i++) {
      if (key.indexOf(domain[i]) >= 0) {
        return true;
      }
    }
    return false;
  }

  // 占位：实际联网调用由不同模型实现，这里仅保留接口
  async askLLM(prompt: string, context: string): Promise<string> {
    // 受限环境：不做真实联网调用，返回占位提示
    const model = this.config.selectedModel;
    const reply = '【' + model + '】占位回复：当前为演示环境，未进行真实联网调用。';
    return Promise.resolve(reply);
  }
}
