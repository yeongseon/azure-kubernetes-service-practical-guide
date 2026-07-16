# Azure Kubernetes Service 实操指南

[English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md)

📘 文档网站: <https://yeongseon.github.io/azure-kubernetes-service-practical-guide/>

[![Docs](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/actions/workflows/docs.yml/badge.svg)](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/actions/workflows/docs.yml)
[![CI](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/actions/workflows/validate-content-sources.yml/badge.svg)](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/actions/workflows/validate-content-sources.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

从首次部署到生产运营，在 Azure Kubernetes Service (AKS) 上运行容器化应用程序的全方位指南。

## 主要内容

| 章节 | 描述 | 状态 |
|---------|-------------|--------|
| [从这里开始](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/start-here/) | Azure 容器编排概述、前提条件和学习路径 | 全方位 |
| [平台](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/platform/) | AKS 架构深度解析：节点池、网络模型、身份和存储 | 全方位 |
| [最佳实践](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/best-practices/) | 针对安全、治理、可靠性和成本优化的生产级设计 | 全方位 |
| [运营](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/operations/) | 针对升级、扩展、监控和凭据轮换的 Day-2 指南 | 全方位 |
| [语言指南](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/language-guides/) | AKS 工作负载的 Python 容器化与部署入门 | 已发布 |
| [教程](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/tutorials/) | AGIC 入口、Key Vault CSI 和灾难恢复动手实验 | 已发布 |
| [故障排除](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/troubleshooting/) | 针对 Pod 失败、CNI IP 耗尽和入口问题的诊断手册 | 已发布 |
| [可视化图表](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/visualization/) | 架构、网络、身份和故障排除图谱 | 已发布 |
| [参考](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/reference/) | 快速查询 CLI 备忘单、限制、配额和仓库元模型 | 全方位 |

**状态图例**：**实验验证** = 全方位 + 提供可复现的实验证明指南 · **全方位** = 完整章节，经 MSLearn 验证，生产就绪 · **已发布** = 核心内容已就绪，仍在扩展中 · **进行中** = 部分内容已就绪，正在积极开发中 · **计划中** = 占位符，内容尚未开始

## 可运行构件

本仓库包含可部署资产，以加速您的 AKS 实施：

- [apps/python/](apps/python/): 以 Workload Identity 和 Key Vault CSI 集成为特色的 FastAPI 参考应用
- [infra/](infra/): 适用于公共和私有 AKS 集群拓扑的生产级 Bicep 基线
- [labs/](labs/): 用于动手故障排除练习的可复现故障注入实验模板

## 重点领域

本指南涵盖的 AKS 集群管理关键领域：
- **集群管理**：配置、节点池操作和维护窗口
- **网络**：CNI 选择、入口控制器 (AGIC) 和服务连接
- **安全**：Workload Identity、Key Vault 集成和适用于 Kubernetes 的 Azure Policy
- **弹性**：扩展操作 (HPA/CA) 和多区域灾难恢复
- **运营**：Kubernetes 版本升级和使用 Container Insights 的集群监控

## 快速入门

```bash
git clone https://github.com/yeongseon/azure-kubernetes-service-practical-guide.git
cd azure-kubernetes-service-practical-guide

python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements-docs.txt

mkdocs serve
```

访问 `http://127.0.0.1:8000` 在本地浏览文档。

## 贡献

欢迎贡献！请参阅我们的[贡献指南](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/contributing/)了解：

- 仓库结构和内容组织
- 文档模板和编写标准
- 本地开发设置和构建验证
- 拉取请求流程

## 相关项目

| 仓库 | 描述 |
|---|---|
| [azure-virtual-machine-practical-guide](https://github.com/yeongseon/azure-virtual-machine-practical-guide) | Azure Virtual Machines 实操指南 |
| [azure-networking-practical-guide](https://github.com/yeongseon/azure-networking-practical-guide) | Azure Networking 实操指南 |
| [azure-storage-practical-guide](https://github.com/yeongseon/azure-storage-practical-guide) | Azure Storage 实操指南 |
| [azure-app-service-practical-guide](https://github.com/yeongseon/azure-app-service-practical-guide) | Azure App Service 实操指南 |
| [azure-functions-practical-guide](https://github.com/yeongseon/azure-functions-practical-guide) | Azure Functions 实操指南 |
| [azure-communication-services-practical-guide](https://github.com/yeongseon/azure-communication-services-practical-guide) | Azure Communication Services 实操指南 |
| [azure-container-apps-practical-guide](https://github.com/yeongseon/azure-container-apps-practical-guide) | Azure Container Apps 实操指南 |
| [azure-kubernetes-service-practical-guide](https://github.com/yeongseon/azure-kubernetes-service-practical-guide) | Azure Kubernetes Service (AKS) 实操指南 |
| [azure-architecture-practical-guide](https://github.com/yeongseon/azure-architecture-practical-guide) | Azure Architecture 实操指南 |
| [azure-monitoring-practical-guide](https://github.com/yeongseon/azure-monitoring-practical-guide) | Azure Monitoring 实操指南 |

## 免责声明

这是一个独立的社区项目。与 Microsoft 无关，也不受其认可。Azure 和 AKS 是 Microsoft Corporation 的商标。

## 许可证

[MIT](LICENSE)
