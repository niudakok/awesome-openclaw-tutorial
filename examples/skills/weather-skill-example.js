/**
 * OpenClaw 天气查询 Skill 示例
 * 
 * 功能：查询指定城市的天气信息
 */

const axios = require('axios');

module.exports = {
  name: 'weather-skill',
  version: '1.0.0',
  description: '查询天气信息',
  author: 'OpenClaw Community',
  
  config: {
    apiKey: {
      type: 'string',
      required: true,
      description: '天气API密钥'
    },
    apiUrl: {
      type: 'string',
      default: 'https://api.openweathermap.org/data/2.5/weather',
      description: 'API地址'
    },
    units: {
      type: 'string',
      default: 'metric',
      description: '温度单位 (metric/imperial)'
    },
    lang: {
      type: 'string',
      default: 'zh_cn',
      description: '语言'
    }
  },
  
  capabilities: [
    {
      name: 'getCurrentWeather',
      description: '获取当前天气',
      parameters: {
        city: {
          type: 'string',
          required: true,
          description: '城市名称'
        }
      }
    },
    {
      name: 'getForecast',
      description: '获取天气预报',
      parameters: {
        city: {
          type: 'string',
          required: true,
          description: '城市名称'
        },
        days: {
          type: 'number',
          default: 5,
          description: '预报天数'
        }
      }
    }
  ],
  
  async initialize(context) {
    this.config = context.config;
    this.apiKey = this.config.apiKey;
    this.apiUrl = this.config.apiUrl;
    console.log('天气Skill初始化完成');
  },
  
  async execute(capability, parameters, context) {
    switch (capability) {
      case 'getCurrentWeather':
        return await this.getCurrentWeather(parameters);
      case 'getForecast':
        return await this.getForecast(parameters);
      default:
        throw new Error(`未知的能力: ${capability}`);
    }
  },
  
  async getCurrentWeather(parameters) {
    const { city } = parameters;
    
    try {
      const response = await axios.get(this.apiUrl, {
        params: {
          q: city,
          appid: this.apiKey,
          units: this.config.units,
          lang: this.config.lang
        }
      });
      
      const data = response.data;
      
      return {
        success: true,
        data: {
          city: data.name,
          country: data.sys.country,
          temperature: data.main.temp,
          feelsLike: data.main.feels_like,
          humidity: data.main.humidity,
          description: data.weather[0].description,
          icon: data.weather[0].icon,
          windSpeed: data.wind.speed
        },
        message: `${city}当前天气：${data.weather[0].description}，温度${data.main.temp}°C`
      };
    } catch (error) {
      return {
        success: false,
        error: `获取天气失败: ${error.message}`
      };
    }
  },
  
  async getForecast(parameters) {
    const { city, days } = parameters;
    
    try {
      // 这里使用预报API
      const forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast';
      
      const response = await axios.get(forecastUrl, {
        params: {
          q: city,
          appid: this.apiKey,
          units: this.config.units,
          lang: this.config.lang,
          cnt: days * 8  // 每天8个时间点
        }
      });
      
      const data = response.data;
      
      // 按天分组
      const forecast = {};
      data.list.forEach(item => {
        const date = item.dt_txt.split(' ')[0];
        if (!forecast[date]) {
          forecast[date] = {
            date: date,
            temps: [],
            descriptions: [],
            humidity: []
          };
        }
        forecast[date].temps.push(item.main.temp);
        forecast[date].descriptions.push(item.weather[0].description);
        forecast[date].humidity.push(item.main.humidity);
      });
      
      // 计算每天的平均值
      const dailyForecast = Object.values(forecast).map(day => ({
        date: day.date,
        avgTemp: (day.temps.reduce((a, b) => a + b) / day.temps.length).toFixed(1),
        maxTemp: Math.max(...day.temps).toFixed(1),
        minTemp: Math.min(...day.temps).toFixed(1),
        description: day.descriptions[0],
        avgHumidity: (day.humidity.reduce((a, b) => a + b) / day.humidity.length).toFixed(0)
      }));
      
      return {
        success: true,
        data: {
          city: data.city.name,
          country: data.city.country,
          forecast: dailyForecast
        },
        message: `${city}未来${days}天天气预报已获取`
      };
    } catch (error) {
      return {
        success: false,
        error: `获取天气预报失败: ${error.message}`
      };
    }
  },
  
  async cleanup() {
    console.log('天气Skill清理完成');
  }
};
