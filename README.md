# Azure Kubernetes Service Practical Guide

[English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md)

Comprehensive guide for running containerized applications on Azure Kubernetes Service (AKS) — from first deployment to production operations.

## What's Inside

| Section | Description |
|---------|-------------|
| [Start Here](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/start-here/) | Overview and learning paths |
| [Platform](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/platform/) | AKS architecture, networking, node pools |
| [Best Practices](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/best-practices/) | Production patterns and security |
| [Operations](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/operations/) | Scaling, upgrades, monitoring |
| [Troubleshooting](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/troubleshooting/) | Common issues and solutions |
| [Reference](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/reference/) | CLI cheatsheet, glossary, limits and quotas |

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yeongseon/azure-kubernetes-service-practical-guide.git

# Install MkDocs dependencies
pip install mkdocs-material mkdocs-minify-plugin

# Start local documentation server
mkdocs serve
```

Visit `http://127.0.0.1:8000` to browse the documentation locally.

## Contributing

Contributions welcome. Please ensure:
- All CLI examples use long flags (`--resource-group`, not `-g`)
- All documents include mermaid diagrams
- All content references Microsoft Learn with source URLs
- No PII in CLI output examples

## Related Projects

| Repository | Description |
|---|---|
| [azure-virtual-machine-practical-guide](https://github.com/yeongseon/azure-virtual-machine-practical-guide) | Azure Virtual Machines practical guide |
| [azure-networking-practical-guide](https://github.com/yeongseon/azure-networking-practical-guide) | Azure Networking practical guide |
| [azure-storage-practical-guide](https://github.com/yeongseon/azure-storage-practical-guide) | Azure Storage practical guide |
| [azure-app-service-practical-guide](https://github.com/yeongseon/azure-app-service-practical-guide) | Azure App Service practical guide |
| [azure-functions-practical-guide](https://github.com/yeongseon/azure-functions-practical-guide) | Azure Functions practical guide |
| [azure-container-apps-practical-guide](https://github.com/yeongseon/azure-container-apps-practical-guide) | Azure Container Apps practical guide |
| [azure-communication-services-practical-guide](https://github.com/yeongseon/azure-communication-services-practical-guide) | Azure Communication Services practical guide |
| [azure-architecture-practical-guide](https://github.com/yeongseon/azure-architecture-practical-guide) | Azure Architecture practical guide |
| [azure-monitoring-practical-guide](https://github.com/yeongseon/azure-monitoring-practical-guide) | Azure Monitoring practical guide |

## Disclaimer

This is an independent community project. Not affiliated with or endorsed by Microsoft. Azure and AKS are trademarks of Microsoft Corporation.

## License

[MIT](LICENSE)
