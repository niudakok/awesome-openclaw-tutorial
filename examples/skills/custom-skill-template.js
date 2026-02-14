/**
 * OpenClaw 自定义 Skill 模板
 * 
 * 这是一个基础的Skill模板，展示如何创建自定义Skill
 */

module.exports = {
  // Skill 元数据
  name: 'my-custom-skill',
  version: '1.0.0',
  description: '这是一个自定义Skill示例',
  author: 'Your Name',
  
  // Skill 配置
  config: {
    // 可配置的参数
    apiKey: {
      type: 'string',
      required: false,
      description: 'API密钥（如果需要）'
    },
    maxResults: {
      type: 'number',
      default: 10,
      description: '最大结果数量'
    }
  },
  
  // Skill 能力定义
  capabilities: [
    {
      name: 'search',
      description: '搜索功能',
      parameters: {
        query: {
          type: 'string',
          required: true,
          description: '搜索关键词'
        },
        limit: {
          type: 'number',
          default: 10,
          description: '结果数量限制'
        }
      }
    }
  ],
  
  // 初始化函数
  async initialize(context) {
    console.log('Skill 初始化...');
    // 在这里进行初始化操作
    // 例如：连接数据库、加载配置等
  },
  
  // 执行函数
  async execute(capability, parameters, context) {
    switch (capability) {
      case 'search':
        return await this.search(parameters, context);
      default:
        throw new Error(`未知的能力: ${capability}`);
    }
  },
  
  // 搜索功能实现
  async search(parameters, context) {
    const { query, limit } = parameters;
    
    try {
      // 实现你的搜索逻辑
      const results = [
        {
          title: `搜索结果 1 for ${query}`,
          description: '这是第一个搜索结果',
          url: 'https://example.com/1'
        },
        {
          title: `搜索结果 2 for ${query}`,
          description: '这是第二个搜索结果',
          url: 'https://example.com/2'
        }
      ];
      
      return {
        success: true,
        data: results.slice(0, limit),
        message: `找到 ${results.length} 个结果`
      };
    } catch (error) {
      return {
        success: false,
        error: error.message
      };
    }
  },
  
  // 清理函数
  async cleanup() {
    console.log('Skill 清理...');
    // 在这里进行清理操作
    // 例如：关闭数据库连接、释放资源等
  }
};
