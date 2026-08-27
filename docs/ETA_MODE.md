# ETA（事件树分析）模式文档

**版本**：1.5.0 | **更新日期**：2025 年 12 月 16 日

## 概述

FTA 编辑器同时支持 **FTA（故障树分析，Fault Tree Analysis）** 和 **ETA（事件树分析，Event Tree Analysis）** 两种模式，并且这两种模式均提供 AI 辅助分析功能。

## 模式差异

### FTA（故障树分析）——自下而上（Bottom-Up）
- **方向**：子节点 → 父节点
- **目的**：分析部件故障如何导致系统故障
- **计算方式**：父节点概率由子节点概率计算得出
- **适用范围**：可靠性分析、失效模式分析

**示例：**
```
系统故障（由子节点计算得出）
  ├─ 部件 A 故障（0.1）
  ├─ 部件 B 故障（0.2）
  └─ 部件 C 故障（0.15）
```

### ETA（事件树分析）——自上而下（Top-Down）
- **方向**：父节点 → 子节点
- **目的**：分析由某个初始事件（initiating event）引发的一系列可能后果
- **计算方式**：子节点概率为自根节点往下逐级累积的乘积
- **适用范围**：事故序列分析、后果建模

**示例：**
```
初始事件（0.5）
  ├─ 分支 1 成功（0.8） → 计算：0.5 × 0.8 = 0.4
  │   ├─ 后果 A（0.9） → 计算：0.4 × 0.9 = 0.36
  │   └─ 后果 B（0.7） → 计算：0.4 × 0.7 = 0.28
  └─ 分支 2 失败（0.6） → 计算：0.5 × 0.6 = 0.3
```

## 界面功能

### 顶栏控件

该应用现在包含一个顶栏，共三个字段：

1. **模式选择器（Mode Selector）** —— 在 FTA 和 ETA 模式之间切换
2. **标题字段（Title Field）** —— 为你的分析命名
3. **日期字段（Date Field）** —— 记录分析执行的日期

### 模式选择器
- 下拉菜单，选项包括：FTA、ETA
- 切换模式会立即重新计算所有概率
- 树名称标签会根据当前模式更新（"故障树"或"事件树"）

### 标题与日期字段
- 自由文本输入字段
- 随 JSON 文件自动保存
- 加载文件时予以保留

## JSON 文件格式

### 新格式（带元数据）
```json
{
  "title": "Nuclear Plant Safety Analysis",
  "date": "2025-10-31",
  "mode": "ETA",
  "tree": {
    "id": "root",
    "name": "Initiating Event",
    "type": "Root",
    "probability": 0.5,
    "logicGate": "OR",
    "children": [...]
  }
}
```

### 旧格式兼容支持
该应用仍支持加载旧格式的 JSON 文件（不带元数据）：
```json
{
  "id": "root",
  "name": "RootEvent",
  ...
}
```

加载旧文件时：
- 标题默认为 "Untitled Analysis"
- 日期默认为空字符串
- 模式默认为 "FTA"

## ETA 概率计算算法

在 ETA 模式下，计算得到的概率以自上而下的方式流转：

```python
def calculate_eta(node, parent_calc_prob=1.0):
    # 子节点计算概率 = 父节点计算概率 × 子节点基准概率
    child.calculatedProbability = parent_calc_prob × child.probability
    
    # 递归应用到所有子节点
    for each child:
        calculate_eta(child, child.calculatedProbability)
```

### 计算示例

```
初始事件（基准：0.5）
  calc = 0.5

  ├─ 成功分支（基准：0.8）
  │   calc = 0.5 × 0.8 = 0.4
  │
  │   ├─ 良好后果（基准：0.9）
  │   │   calc = 0.4 × 0.9 = 0.36
  │   │
  │   └─ 降级后果（基准：0.7）
  │       calc = 0.4 × 0.7 = 0.28
  │
  └─ 失败分支（基准：0.6）
      calc = 0.5 × 0.6 = 0.3
```

## 使用示例

### 创建 ETA 分析

1. 打开 FTA 编辑器界面：`python FTA_Editor_UI.py`
2. 在顶栏将模式设置为 "ETA"
3. 输入标题："Reactor Scram Analysis"
4. 输入日期："2025-10-31"
5. 构建你的事件树：
   - 根节点 = 初始事件（例如 "Loss of Coolant"）
   - 子节点 = 可能的分支（例如 "ECCS Success"、"ECCS Failure"）
   - 孙节点 = 最终后果

### 将 FTA 转换为 ETA

1. 加载现有的 FTA 文件
2. 将模式从 "FTA" 改为 "ETA"
3. 概率会在 ETA 模式下自动重新计算
4. 另存为新文件以保留原文件

## 编程（代码）接口使用

```python
from FTA_Editor_core import FTACore

# 创建 ETA 分析
core = FTACore()
core.set_metadata(
    title="Safety Analysis",
    date="2025-10-31",
    mode="ETA"
)

# 构建树结构
core.set_data({
    "id": "root",
    "name": "Initiating Event",
    "probability": 0.5,
    "children": [...]
})

# 在 ETA 模式下计算概率
core.recalculate_probabilities()

# 带元数据保存
core.save_to_json("safety_analysis.json")
```

## 对比表

| 特性 | FTA 模式 | ETA 模式 |
|---------|----------|----------|
| 计算方向 | 自下而上 | 自上而下 |
| 父节点计算 | 由子节点 | 由基准概率 |
| 子节点计算 | 由基准概率 | 由父节点计算值 |
| 逻辑门 | 应用与门（AND）、或门（OR） | 仅累积相乘 |
| 适用场景 | 系统可靠性 | 事故序列 |
| 根节点含义 | 系统故障（顶事件） | 初始事件 |
| 叶节点含义 | 部件故障（底事件） | 最终后果 |

## 测试

运行 ETA 测试套件：
```bash
python test_eta_mode.py
```

预期输出：
```
✅ All ETA calculations correct!
✅ All tests passed!
```

## 备注

- 模式可随时切换
- 切换模式会重新计算所有概率
- 两种模式都能随元数据正常保存/加载
- 旧格式文件默认使用 FTA 模式
- 两种模式下均支持 Excel 导出
- 两种模式下均支持零概率标记功能

## 后续增强计划

ETA 模式的潜在改进方向：
- 成功/失败分支标注
- 条件概率支持
- 后果自动分类
- 针对 ETA 的专属可视化