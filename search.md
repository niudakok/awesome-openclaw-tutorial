---
layout: default
title: 搜索
---

<div class="search-container">
  <div class="search-box">
    <input type="text" id="search-input" placeholder="搜索标题..." autocomplete="off">
    <button id="search-button">🔍 搜索</button>
  </div>
  
  <div id="search-results">
    <p class="search-hint">输入关键词搜索标题</p>
  </div>
</div>

<style>
.search-container {
  max-width: 900px;
  margin: 2rem auto;
  padding: 0 1rem;
}

.search-box {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 2rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  border-radius: 8px;
  overflow: hidden;
}

#search-input {
  flex: 1;
  padding: 1rem 1.5rem;
  font-size: 1.1rem;
  border: 2px solid #159957;
  border-right: none;
  outline: none;
  transition: all 0.3s;
}

#search-input:focus {
  border-color: #155799;
  box-shadow: 0 0 0 3px rgba(21, 153, 87, 0.1);
}

#search-button {
  padding: 1rem 2rem;
  font-size: 1.1rem;
  background: linear-gradient(120deg, #155799, #159957);
  color: white;
  border: none;
  cursor: pointer;
  transition: all 0.3s;
  font-weight: bold;
}

#search-button:hover {
  background: linear-gradient(120deg, #0d3f6f, #0f7a3f);
  transform: scale(1.05);
}

#search-button:active {
  transform: scale(0.98);
}

#search-results {
  min-height: 200px;
}

.search-hint {
  text-align: center;
  color: #666;
  font-size: 1.2rem;
  padding: 4rem 0;
  background: #f8f9fa;
  border-radius: 8px;
  border: 2px dashed #ddd;
}

.search-result-item {
  padding: 1.5rem;
  margin-bottom: 1rem;
  background: #ffffff;
  border: 1px solid #e1e4e8;
  border-left: 4px solid #159957;
  border-radius: 8px;
  transition: all 0.3s;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.search-result-item:hover {
  background: #f6f8fa;
  border-left-color: #155799;
  transform: translateX(4px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.search-result-title {
  font-size: 1.3rem;
  font-weight: bold;
  margin-bottom: 0.75rem;
  line-height: 1.4;
}

.search-result-title a {
  color: #155799;
  text-decoration: none;
  transition: color 0.3s;
}

.search-result-title a:hover {
  color: #159957;
}

.search-result-excerpt {
  color: #586069;
  line-height: 1.6;
  margin-bottom: 0.75rem;
  font-size: 0.95rem;
}

.search-result-url {
  font-size: 0.85rem;
  color: #159957;
  font-family: 'Courier New', monospace;
  opacity: 0.8;
}

.no-results {
  text-align: center;
  padding: 4rem 2rem;
  color: #666;
  background: #f8f9fa;
  border-radius: 8px;
  line-height: 1.8;
}

.no-results strong {
  color: #159957;
}

.loading {
  text-align: center;
  padding: 3rem;
  color: #159957;
  font-size: 1.2rem;
  font-weight: bold;
  animation: pulse 1.5s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

mark {
  background-color: #fff3cd;
  padding: 0.1em 0.3em;
  border-radius: 3px;
  font-weight: bold;
  color: #856404;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .search-box {
    flex-direction: column;
  }
  
  #search-input {
    border: 2px solid #159957;
    border-radius: 8px 8px 0 0;
  }
  
  #search-button {
    border-radius: 0 0 8px 8px;
  }
  
  .search-result-item {
    padding: 1rem;
  }
  
  .search-result-title {
    font-size: 1.1rem;
  }
}
</style>

<script src="https://unpkg.com/lunr/lunr.js"></script>
<script>
(function() {
  let searchIndex;
  let searchData;
  
  // 加载搜索数据
  fetch('{{ "/search.json" | relative_url }}')
    .then(response => response.json())
    .then(data => {
      searchData = data;
      
      // 构建搜索索引（只搜索标题）
      searchIndex = lunr(function() {
        this.ref('url');
        this.field('title', { boost: 10 }); // 只索引标题字段，提高权重
        
        // 添加中文分词支持
        this.pipeline.remove(lunr.stemmer);
        this.searchPipeline.remove(lunr.stemmer);
        
        data.forEach(doc => {
          this.add(doc);
        });
      });
      
      console.log('✅ 搜索索引已加载，共 ' + data.length + ' 个页面（仅搜索标题）');
    })
    .catch(error => {
      console.error('❌ 加载搜索索引失败:', error);
      document.getElementById('search-results').innerHTML = 
        '<p class="no-results">搜索功能加载失败，请刷新页面重试</p>';
    });
  
  // 简单的中文分词（按字符分割）
  function tokenizeChinese(text) {
    return text.split('');
  }
  
  // 执行搜索
  function performSearch(query) {
    if (!searchIndex || !searchData) {
      document.getElementById('search-results').innerHTML = 
        '<p class="loading">⏳ 搜索索引加载中...</p>';
      return;
    }
    
    if (!query || query.trim() === '') {
      document.getElementById('search-results').innerHTML = 
        '<p class="search-hint">💡 请输入搜索关键词</p>';
      return;
    }
    
    document.getElementById('search-results').innerHTML = 
      '<p class="loading">🔍 搜索中...</p>';
    
    try {
      // 执行搜索（支持模糊匹配）
      let results = searchIndex.search(query + '*'); // 添加通配符支持前缀匹配
      
      // 如果没有结果，尝试不使用通配符
      if (results.length === 0) {
        results = searchIndex.search(query);
      }
      
      // 如果还是没有结果，尝试按字符搜索（中文支持）
      if (results.length === 0 && /[\u4e00-\u9fa5]/.test(query)) {
        const chars = query.split('');
        const charQuery = chars.map(c => c + '~1').join(' '); // 模糊匹配
        results = searchIndex.search(charQuery);
      }
      
      // 额外的标题匹配过滤（提高准确度）
      const queryLower = query.toLowerCase();
      const filteredResults = results.filter(result => {
        const doc = searchData.find(d => d.url === result.ref);
        if (!doc) return false;
        const titleLower = (doc.title || '').toLowerCase();
        return titleLower.includes(queryLower) || 
               query.split('').every(char => titleLower.includes(char.toLowerCase()));
      });
      
      const finalResults = filteredResults.length > 0 ? filteredResults : results;
      
      if (finalResults.length === 0) {
        document.getElementById('search-results').innerHTML = 
          '<p class="no-results">😕 没有找到包含 "<strong>' + query + '</strong>" 的标题<br><br>💡 搜索提示：<br>• 尝试使用更简短的关键词<br>• 检查关键词拼写<br>• 尝试使用同义词</p>';
        return;
      }
      
      // 显示结果
      let html = '<p style="margin-bottom: 1.5rem; color: #159957; font-weight: bold; font-size: 1.1rem;">✨ 找到 ' + finalResults.length + ' 个相关标题</p>';
      
      finalResults.slice(0, 30).forEach((result, index) => {
        const doc = searchData.find(d => d.url === result.ref);
        if (doc) {
          // 高亮标题中的关键词
          let title = doc.title || '无标题';
          const queryWords = query.split(/\s+/).filter(w => w.length > 0);
          
          // 高亮每个关键词
          queryWords.forEach(word => {
            const regex = new RegExp('(' + word.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi');
            title = title.replace(regex, '<mark>$1</mark>');
          });
          
          // 显示摘要
          let excerpt = doc.excerpt || '';
          if (excerpt.length > 150) {
            excerpt = excerpt.substring(0, 150) + '...';
          }
          
          // 分类标签
          let categoryBadge = '';
          if (doc.category) {
            const categoryMap = {
              'docs': '📚 文档',
              'appendix': '📖 附录',
              'examples': '💡 示例'
            };
            const categoryName = categoryMap[doc.category] || doc.category;
            categoryBadge = `<span style="display: inline-block; padding: 0.2rem 0.5rem; background: #e1f5fe; color: #0277bd; border-radius: 3px; font-size: 0.85rem; margin-right: 0.5rem;">${categoryName}</span>`;
          }
          
          html += `
            <div class="search-result-item">
              <div class="search-result-title">
                <span style="color: #999; margin-right: 0.5rem;">${index + 1}.</span>
                ${categoryBadge}
                <a href="${doc.url}">${title}</a>
              </div>
              ${excerpt ? '<div class="search-result-excerpt">' + excerpt + '</div>' : ''}
              <div class="search-result-url">📄 ${doc.url}</div>
            </div>
          `;
        }
      });
      
      if (finalResults.length > 30) {
        html += '<p style="text-align: center; color: #666; margin-top: 2rem;">显示前 30 个结果，共 ' + finalResults.length + ' 个</p>';
      }
      
      document.getElementById('search-results').innerHTML = html;
    } catch (error) {
      console.error('❌ 搜索出错:', error);
      document.getElementById('search-results').innerHTML = 
        '<p class="no-results">搜索出错，请重试</p>';
    }
  }
  
  // 绑定搜索事件
  document.getElementById('search-button').addEventListener('click', function() {
    const query = document.getElementById('search-input').value;
    performSearch(query);
  });
  
  document.getElementById('search-input').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
      const query = this.value;
      performSearch(query);
    }
  });
  
  // 实时搜索（可选，输入时自动搜索）
  let searchTimeout;
  document.getElementById('search-input').addEventListener('input', function() {
    clearTimeout(searchTimeout);
    const query = this.value;
    if (query.length >= 2) { // 至少2个字符才开始搜索
      searchTimeout = setTimeout(() => performSearch(query), 300);
    }
  });
  
  // 从 URL 参数获取搜索词
  const urlParams = new URLSearchParams(window.location.search);
  const queryParam = urlParams.get('q');
  if (queryParam) {
    document.getElementById('search-input').value = queryParam;
    // 等待索引加载后执行搜索
    setTimeout(() => performSearch(queryParam), 500);
  }
})();
</script>
