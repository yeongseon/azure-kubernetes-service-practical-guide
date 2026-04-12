# Azure Kubernetes Service 実務ガイド

[English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md)

最初のデプロイから本番運用まで、Azure Kubernetes Service (AKS) でコンテナ化されたアプリケーションを実行するための包括的なガイドです。

## 主な内容

| セクション | 説明 |
|---------|-------------|
| [ここから開始 (Start Here)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/start-here/) | 概要と学習パス |
| [プラットフォーム (Platform)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/platform/) | AKS アーキテクチャ、ネットワーク、ノードプール |
| [ベストプラクティス (Best Practices)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/best-practices/) | 本番パターンとセキュリティ |
| [運用 (Operations)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/operations/) | スケーリング、アップグレード、モニタリング |
| [トラブルシューティング (Troubleshooting)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/troubleshooting/) | よくある問題と解決策 |

## クイックスタート

```bash
# リポジトリをクローン
git clone https://github.com/yeongseon/azure-kubernetes-service-practical-guide.git

# MkDocs の依存関係をインストール
pip install mkdocs-material mkdocs-minify-plugin

# ローカルドキュメントサーバーを起動
mkdocs serve
```

ローカルで `http://127.0.0.1:8000` にアクセスしてドキュメントを閲覧してください。

## 貢献

貢献を歓迎します。以下の点を確認してください：
- すべての CLI の例で長いフラグを使用してください (`-g` ではなく `--resource-group`)
- すべてのドキュメントに Mermaid ダイアグラムを含めてください
- すべてのコンテンツは、ソース URL とともに Microsoft Learn を参照してください
- CLI 出力の例に個人情報 (PII) を含めないでください

## 関連プロジェクト

| リポジトリ | 説明 |
|---|---|
| [azure-virtual-machine-practical-guide](https://github.com/yeongseon/azure-virtual-machine-practical-guide) | Azure Virtual Machines 実務ガイド |
| [azure-networking-practical-guide](https://github.com/yeongseon/azure-networking-practical-guide) | Azure Networking 実務ガイド |
| [azure-storage-practical-guide](https://github.com/yeongseon/azure-storage-practical-guide) | Azure Storage 実務ガイド |
| [azure-app-service-practical-guide](https://github.com/yeongseon/azure-app-service-practical-guide) | Azure App Service 実務ガイド |
| [azure-functions-practical-guide](https://github.com/yeongseon/azure-functions-practical-guide) | Azure Functions 実務ガイド |
| [azure-container-apps-practical-guide](https://github.com/yeongseon/azure-container-apps-practical-guide) | Azure Container Apps 実務ガイド |
| [azure-monitoring-practical-guide](https://github.com/yeongseon/azure-monitoring-practical-guide) | Azure Monitoring 実務ガイド |

## 免責事項

これは独立したコミュニティプロジェクトです。Microsoft との提携や承認を受けているものではありません。Azure および AKS は Microsoft Corporation の商標です。

## ライセンス

[MIT](LICENSE)
