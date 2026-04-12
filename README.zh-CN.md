# Azure Kubernetes Service 实操指南

[English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md)

从首次部署到生产运营，在 Azure Kubernetes Service (AKS) 上运行容器化应用程序的全方位指南。

## 主要内容

| 章节 | 描述 |
|---------|-------------|
| [从这里开始 (Start Here)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/start-here/) | 概述和学习路径 |
| [平台 (Platform)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/platform/) | AKS 架构、网络、节点池 |
| [最佳实践 (Best Practices)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/best-practices/) | 生产模式和安全 |
| [运营 (Operations)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/operations/) | 扩展、升级、监控 |
| [故障排除 (Troubleshooting)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/troubleshooting/) | 常见问题和解决方案 |

## 快速入门

```bash
# 克隆仓库
git clone https://github.com/yeongseon/azure-kubernetes-service-practical-guide.git

# 安装 MkDocs 依赖
pip install mkdocs-material mkdocs-minify-plugin

# 启动本地文档服务器
mkdocs serve
```

访问 `http://127.0.0.1:8000` 在本地浏览文档。

## 贡献

欢迎贡献。请确保：
- 所有 CLI 示例使用长标记 (使用 `--resource-group` 而不是 `-g`)
- 所有文档包含 Mermaid 图表
- 所有内容参考 Microsoft Learn 并附带源 URL
- CLI 输出示例中不含个人身份信息 (PII)

## 相关项目

| 仓库 | 描述 |
|---|---|
| [azure-virtual-machine-practical-guide](https://github.com/yeongseon/azure-virtual-machine-practical-guide) | Azure Virtual Machines 实操指南 |
| [azure-networking-practical-guide](https://github.com/yeongseon/azure-networking-practical-guide) | Azure Networking 实操指南 |
| [azure-storage-practical-guide](https://github.com/yeongseon/azure-storage-practical-guide) | Azure Storage 实操指南 |
| [azure-app-service-practical-guide](https://github.com/yeongseon/azure-app-service-practical-guide) | Azure App Service 实操指南 |
| [azure-functions-practical-guide](https://github.com/yeongseon/azure-functions-practical-guide) | Azure Functions 实操指南 |
| [azure-container-apps-practical-guide](https://github.com/yeongseon/azure-container-apps-practical-guide) | Azure Container Apps 实操指南 |
| [azure-monitoring-practical-guide](https://github.com/yeongseon/azure-monitoring-practical-guide) | Azure Monitoring 实操指南 |

## 免责声明

这是一个独立的社区项目。与 Microsoft 无关，也不受其认可。Azure 和 AKS 是 Microsoft Corporation 的商标。

## 许可证

[MIT](LICENSE)
