# Microsoft Copilot（Azure OpenAI）配置指南

**版本**：1.5.0 | **更新日期**：2025 年 12 月 17 日

关于如何在 FTA Editor 中配置 Microsoft Copilot / Azure OpenAI 的完整指南。

> **适用定位说明**：本指南针对使用 Azure OpenAI / Microsoft Copilot 的企业用户；个人用户更推荐使用 README 中的 DeepSeek / 通义千问 / 智谱清言 / Kimi / Ollama 本地等国内/本地服务商。

## 概述

面向企业的 Microsoft Copilot 使用 **Azure OpenAI 服务**，它提供以下能力：
- GPT-4、GPT-4o、GPT-4-turbo、GPT-3.5-turbo 等模型
- 企业级安全性与合规性
- 数据隐私（你的数据保留在你的 Azure 订阅内）
- 兼容 OpenAI 的 API，可与 FTA Editor 配合使用

## 前提条件

1. **Microsoft 账户（账号）** - Microsoft 365 或 Azure 订阅
2. **Azure OpenAI 访问权限** - 二选一：
   - **Azure OpenAI 服务** - 面向企业（费用较高）
   - **Microsoft Copilot for Microsoft 365** - 面向个人/企业用户（约 30 美元/用户/月）
3. **Azure 门户访问权限** - 用于创建资源、获取 API 密钥（key）
4. **互联网连接** - 访问 Azure API 所需

## 方案一：Azure OpenAI 服务（推荐企业使用）

### 第 1 步：创建 Azure OpenAI 资源

1. **访问 Azure 门户（Portal）**：
   - 打开 [portal.azure.com](https://portal.azure.com/)
   - 使用你的 Microsoft 账户登录

2. **创建 Azure OpenAI 资源**：
   - 点击 **"Create a resource（创建资源）"**
   - 搜索 **"Azure OpenAI"**
   - 点击 **"Create（创建）"**

3. **配置资源**：
   - **Subscription（订阅）**：选择你的 Azure 订阅
   - **Resource Group（资源组）**：新建或选择现有资源组
   - **Region（区域）**：选择离你最近的区域（如 East US（美国东部）、West Europe（西欧））
   - **Name（名称）**：起一个唯一名称（例如 `my-fta-openai`）
   - **Pricing Tier（定价层）**：选择 Standard S0
   - 点击 **"Review + Create（查看 + 创建）"** → **"Create（创建）"**

4. **等待部署完成**：
   - 大约需要 2-5 分钟
   - 就绪后点击 **"Go to resource（转到资源）"**

### 第 2 步：部署模型

1. **进入 Azure OpenAI Studio（工作室）**：
   - 在你的资源页面中，点击 **"Go to Azure OpenAI Studio（转到 Azure OpenAI Studio）"**
   - 或直接访问：https://oai.azure.com/

2. **创建部署（Deployment）**：
   - 点击左侧边栏的 **"Deployments（部署）"**
   - 点击 **"Create new deployment（创建新部署）"**
   - 进行配置：
     - **Model（模型）**：选择 `gpt-4o`（推荐）或 `gpt-4-turbo`
     - **Deployment name（部署名称）**：`gpt-4o-deployment`（请牢记这个名称！）
     - **Deployment type（部署类型）**：Standard（标准）
   - 点击 **"Create（创建）"**

3. **记下你的部署名称**：
   - 稍后 FTA Editor 配置时需要用到它
   - 示例：`gpt-4o-deployment`

### 第 3 步：获取 API 密钥（Key）和端点（Endpoint）

1. **返回 Azure 门户**：
   - 打开你的 Azure OpenAI 资源

2. **查找密钥和端点**：
   - 点击左侧边栏的 **"Keys and Endpoint（密钥和端点）"**
   - 你会看到：
     - **KEY 1**：你的 API 密钥（点击 "Show（显示）" 即可查看）
     - **Endpoint（端点）**：你的基础 URL（例如 `https://my-fta-openai.openai.azure.com/`）

3. **复制凭证**：
   - **API 密钥**：复制 KEY 1（或 KEY 2）
   - **端点**：复制完整的端点 URL
   - **部署名称**：第 2 步中设置的部署名称

### 第 4 步：配置 FTA Editor

1. **拼出完整的端点 URL**：
   ```
   格式：https://{资源名称}.openai.azure.com/openai/deployments/{部署名称}

   示例：https://my-fta-openai.openai.azure.com/openai/deployments/gpt-4o-deployment
   ```

2. **启动 FTA Editor**：
   ```bash
   python src/FTA_Editor_UI.py
   ```

3. **打开 AI 设置**：
   - 点击 AI 助手面板中的 **⚙️ AI Settings（AI 设置）** 按钮

4. **配置服务商（Provider）**：
   - **Provider（服务商）**：在下拉菜单中选择 **"Microsoft Copilot"**
   - **API Key（API 密钥）**：粘贴你的 Azure OpenAI API 密钥
   - **API Endpoint（API 端点）**：输入完整端点 URL（含部署名称）
     - 示例：`https://my-fta-openai.openai.azure.com/openai/deployments/gpt-4o-deployment`
   - **Model（模型）**：输入你的部署名称（例如 `gpt-4o-deployment`）

5. **测试连接**：
   - 点击 **"Test Connection（测试连接）"** 按钮
   - 应当看到：✅ "Microsoft Copilot（Azure OpenAI）连接成功！"

6. **保存设置**：
   - 点击 **"Save（保存）"** 按钮
   - 凭证将保存在本地 `~/.fta_editor/ai_credentials.json`

---

## 方案二：Microsoft Copilot for Microsoft 365

如果你拥有 **Microsoft Copilot for Microsoft 365**，可以通过组织（企业）的 Azure OpenAI 端点访问 API。

### 操作步骤：

1. **联系你的 IT 管理员**：
   - 申请访问你们组织的 Azure OpenAI 端点
   - 索要如下信息：
     - API 密钥
     - 端点 URL
     - 部署名称

2. **使用提供的凭证**：
   - 使用 IT 管理员提供的凭证，按照上文方案一的第 4 步操作

---

## 配置示例

### 示例 1：美国东部（East US）区域

```
Provider（服务商）: Microsoft Copilot
API Key（API 密钥）：1234567890abcdef1234567890abcdef
API Endpoint（API 端点）：https://my-company-ai.openai.azure.com/openai/deployments/gpt-4o
Model（模型）：gpt-4o
```

### 示例 2：欧洲西部（Europe West）区域

```
Provider（服务商）: Microsoft Copilot
API Key（API 密钥）：abcdef1234567890abcdef1234567890
API Endpoint（API 端点）：https://fta-editor-ai-eu.openai.azure.com/openai/deployments/gpt-4-turbo
Model（模型）：gpt-4-turbo
```

---

## 定价

Azure OpenAI 按令牌（token，即模型计量的基本单位）用量计费：

| 模型 | 每千输入令牌费用 | 每千输出令牌费用 |
|-------|--------------------------|---------------------------|
| **GPT-4o** | $0.0025 | $0.010 |
| **GPT-4-turbo** | $0.010 | $0.030 |
| **GPT-4** | $0.030 | $0.060 |
| **GPT-3.5-turbo** | $0.0005 | $0.0015 |

**FTA Editor 用量估算**：
- 快速 FTA 分析：约 1,000-2,000 令牌 ≈ $0.01-0.03
- 根因建议：约 800-1,500 令牌 ≈ $0.005-0.02
- 每月用量（较高频，100 次请求）：约 $2-6

**企业优势**：
- 数据保留在你的 Azure 订阅内
- SOC 2、ISO 27001、HIPAA 合规
- 不会用你的数据训练模型
- 高级安全功能

---

## 故障排查

### 报错"Deployment error: Check your deployment name（部署错误：请检查你的部署名称）"

**问题**：端点 URL 中的部署名称不正确

**解决方法**：
1. 进入 Azure OpenAI Studio → Deployments（部署）
2. 核对你的部署名称（注意区分大小写！）
3. 更新端点 URL：`https://{resource}.openai.azure.com/openai/deployments/{exact-deployment-name}`

### 报错"Authentication failed: Check your API key（身份验证失败：请检查你的 API 密钥）"

**问题**：API 密钥无效或已过期

**解决方法**：
1. 进入 Azure 门户 → 你的资源 → Keys and Endpoint（密钥和端点）
2. 复制 KEY 1 或 KEY 2（点击 "Show（显示）"）
3. 如果密钥已重新生成，请更新 FTA Editor 中的设置

### 报错"Endpoint not found: Verify your Azure resource URL（未找到端点：请核对你的 Azure 资源 URL）"

**问题**：端点中的资源名称不正确

**解决方法**：
1. 进入 Azure 门户 → 你的 OpenAI 资源
2. 在 "Keys and Endpoint（密钥和端点）" 中查看端点 URL
3. 格式应为：`https://{你的资源名称}.openai.azure.com/`
4. 确保资源名称没有拼写错误

### 报错"Rate limit exceeded（超出速率限制）"

**问题**：短时间内请求过多

**解决方法**：
1. Azure OpenAI 对每个部署都有速率限制
2. 稍等几分钟后重试
3. 升级到更高定价层（Standard S0 → 更高配额）
4. 联系 Azure 支持以提升配额

### 报错"Model not found（未找到模型）"或"Invalid model（模型无效）"

**问题**：模型名称与部署名称不匹配

**解决方法**：
- 在 FTA Editor 中，**Model（模型）**字段应填写你的**部署名称**，而不是底层模型名称
- 示例：如果你的部署命名为 `my-gpt4`，请填写 `my-gpt4`（而不是 `gpt-4`）

---

## 安全最佳实践

1. **保护 API 密钥**：
   - 绝不将密钥提交到 git 仓库
   - 不要在邮件或即时消息中分享密钥
   - 定期轮换密钥（在 Azure 门户中重新生成）

2. **使用 Azure RBAC（基于角色的访问控制）**：
   - 授予最小权限（Cognitive Services OpenAI User（认知服务 OpenAI 用户））
   - 生产环境使用服务主体（service principal）

3. **监控用量**：
   - 查看 Azure 门户 → Cost Management（成本管理）
   - 设置预算预警
   - 查看审计日志

4. **网络安全**：
   - 生产环境使用 Azure Private Link（专用链接）
   - 配置防火墙规则
   - 启用托管标识（managed identity）

---

## 对比：Microsoft Copilot 与其他方案

| 特性 | Microsoft Copilot（Azure） | OpenAI 直连 | Google Gemini |
|---------|---------------------------|---------------|---------------|
| **数据隐私** | ✅ 保留在你的 Azure 内 | ❌ 发送给 OpenAI | ❌ 发送给 Google |
| **合规性** | ✅ SOC 2、HIPAA、ISO | ⚠️ 有限 | ⚠️ 有限 |
| **成本** | $$$ 较高 | $$ 中等 | $ 较低（有免费层） |
| **配置复杂度** | ⚠️ 中等 | ✅ 简单 | ✅ 简单 |
| **企业功能** | ✅ 完整 | ❌ 有限 | ❌ 有限 |
| **适用场景** | 企业、受监管行业 | 个人、初创公司 | 测试、轻度使用 |

---

## 获取帮助

**Azure OpenAI 相关问题**：
- [Azure OpenAI 文档](https://learn.microsoft.com/azure/ai-services/openai/)
- [Azure 支持门户](https://portal.azure.com/#blade/Microsoft_Azure_Support/HelpAndSupportBlade)
- [Azure OpenAI 论坛](https://learn.microsoft.com/answers/tags/387/azure-openai)

**FTA Editor 相关问题**：
- [GitHub Issues（问题反馈）](https://github.com/Gertrud-Violett/FTA_editor/issues)
- 参见 README.md 的故障排查部分

---

## 汇总清单

- [ ] 在 Azure 门户中创建 Azure OpenAI 资源
- [ ] 部署 GPT-4o 或 GPT-4-turbo 模型
- [ ] 从 Azure 门户获取 API 密钥和端点
- [ ] 用部署名称拼出完整的端点 URL
- [ ] 在 FTA Editor 中配置 Microsoft Copilot 服务商
- [ ] 成功测试连接
- [ ] 开始使用 AI 助手进行 FTA 分析！

**预计配置时间**：15-20 分钟

配置完成后，Microsoft Copilot 即可为你的事故树提供企业级 AI 分析，同时保障完整的数据隐私与合规性！