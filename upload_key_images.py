#!/usr/bin/env python3
import os
import requests
import json
import time

# 图床配置
API_URL = "https://upload.maynor1024.live/upload"
URL_PREFIX = "https://upload.maynor1024.live"

# 需要上传的关键图片（根据原文档中的图片引用）
KEY_IMAGES = {
    # Moltbook相关
    "ZdJubVfPioWuqXxyN6OcdhTmntc.png": "moltbook-overview",
    "OpNQb8LpgoluFgxrtWXcqRlVn5g.png": "agent-religion",
    "YBhvbMN9hoPXYMxpJGic831ynGH.png": "agent-sell-human",
    "UsFCb4nSloqGMtxbWLxc28stnBb.png": "moltbook-command",
    "H3oVb0VvmonQxwxirZxcvALfnOo.png": "moltbook-auth",
    "GXhCbSEvboOL8UxcIRdcC1mjnNz.png": "twitter-post",
    "UOwsb1yzyoGkYjxGHJuca8Jhn2b.png": "submit-auth",
    "Y1DAbC0IHop34DxtzSNcIqignYi.png": "join-success",
    "PRmWbRXLgoxsv6xbmImcy2e7nib.png": "agent-profile",
    
    # 定时任务相关
    "1422412504849629deb3b1a648d4365b.png": "weather-reminder",
    "c2a2e0e0e1e33dac91c1c91698c9ac90.png": "bedtime-story",
    
    # Skill相关
    "Kct4bNieGoZdaDxVuqCcli8Dnmd.png": "install-skill",
    "QZyAbbVyDo7keCx5By9cBu6LnZc.png": "config-api",
    "EnQvbD7KkouzTcx75dMc10TDnkg.jpg": "xiaohongshu-cover",
    
    # 网页生成相关
    "UpcWbWNZ2ox7R6xsszbckTqynHc.png": "send-article",
    "6bd871e1448b46b192ff38f51c3bc441.png": "generated-webpage",
    
    # 信息收集相关
    "Vgx7bZxQOo6eLwx0JEOcpwnenmh.png": "research-report",
    
    # Agent Coding相关
    "TqD8bqjB1oMp1qxIJy0cQYZhnef.png": "install-opencode",
    "Jv0GbCeYTolL34x8LdVcQohUnnc.png": "create-dir",
    "EREhbdurjon7D4xolBncCwmZnhg.png": "start-opencode",
    "QwzJb3m24od87zxvP3Sc3yB7ny2.png": "develop-game",
    "Rms1b9zPioOZNNxFx1AcnLhxng2.png": "connect-github",
    "MAEDbAn20oPsIex4rrzcPnTtntd.png": "push-github",
    "PXR5bxURCo2CkaxzIr9cnaFfnGg.png": "deploy-vercel",
    "CCvbbxY3Qojg6XxGhHfcCIV1njc.png": "game-live",
    "Wv4Nbsc7moQFYOxFijpc7GIBnpe.png": "generate-doc",
}

def upload_image(file_path, new_name):
    """上传单张图片到图床"""
    try:
        with open(file_path, 'rb') as f:
            files = {'file': (os.path.basename(file_path), f)}
            response = requests.post(API_URL, files=files, timeout=30)
            
            if response.status_code == 200:
                data = response.json()
                if isinstance(data, list) and len(data) > 0:
                    url = data[0].get('src', '')
                    if url and not url.startswith('http'):
                        url = URL_PREFIX + url
                    return url
                elif isinstance(data, dict):
                    url = data.get('src', '')
                    if url and not url.startswith('http'):
                        url = URL_PREFIX + url
                    return url
        return None
    except Exception as e:
        print(f"  ✗ 错误: {e}")
        return None

def main():
    image_dir = "images/openclaw-guide"
    output_file = "key_image_urls.json"
    
    results = {}
    success = 0
    failed = 0
    
    print("开始上传关键图片...")
    print(f"总计: {len(KEY_IMAGES)} 张\n")
    
    for i, (filename, new_name) in enumerate(KEY_IMAGES.items(), 1):
        file_path = os.path.join(image_dir, f"OpenClaw 从入门到精通指南-{filename}")
        
        if not os.path.exists(file_path):
            print(f"[{i}/{len(KEY_IMAGES)}] ⚠️  文件不存在: {filename}")
            failed += 1
            continue
        
        print(f"[{i}/{len(KEY_IMAGES)}] 上传: {filename}")
        url = upload_image(file_path, new_name)
        
        if url:
            print(f"  ✓ 成功: {url}")
            results[new_name] = url
            success += 1
        else:
            print(f"  ✗ 失败")
            failed += 1
        
        # 避免请求过快
        time.sleep(0.5)
    
    # 保存结果
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    
    print(f"\n上传完成！")
    print(f"成功: {success} 张")
    print(f"失败: {failed} 张")
    print(f"结果保存在: {output_file}")

if __name__ == "__main__":
    main()
