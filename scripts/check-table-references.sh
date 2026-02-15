#!/bin/bash

# 检查所有文档中的表格是否有引用和说明

echo "🔍 检查文档中的表格引用..."
echo ""

find docs -name "*.md" -type f | while read file; do
    # 统计表格数量
    table_count=$(grep -c "^| " "$file" | head -1)
    
    if [ "$table_count" -gt 0 ]; then
        echo "📄 $file"
        echo "   表格数量: $table_count"
        
        # 检查是否有表格编号
        table_ref_count=$(grep -c "表 [0-9]" "$file")
        echo "   表格引用: $table_ref_count"
        
        # 检查是否有"如表"引用
        table_mention_count=$(grep -c "如表" "$file")
        echo "   如表引用: $table_mention_count"
        
        if [ "$table_ref_count" -eq 0 ] && [ "$table_count" -gt 0 ]; then
            echo "   ⚠️  缺少表格编号"
        fi
        
        echo ""
    fi
done

echo "✅ 检查完成"
