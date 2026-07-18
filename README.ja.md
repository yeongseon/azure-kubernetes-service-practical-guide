# Azure Kubernetes Service 実務ガイド

[English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md)

📘 ドキュメントサイト: <https://yeongseon.github.io/azure-kubernetes-service-practical-guide/>

[![Docs](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/actions/workflows/docs.yml/badge.svg)](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/actions/workflows/docs.yml)
[![CI](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/actions/workflows/validate-content-sources.yml/badge.svg)](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/actions/workflows/validate-content-sources.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

最初のデプロイから本番運用まで、Azure Kubernetes Service (AKS) でコンテナ化されたアプリケーションを実行するための包括的なガイドです。

## 主な内容

| セクション | 説明 | ステータス |
|---------|-------------|--------|
| [ここから開始](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/start-here/) | Azure でのコンテナオーケストレーションの概要、前提条件、学習パス | 包括的 |
| [プラットフォーム](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/platform/) | AKS アーキテクチャの詳細: ノードプール、ネットワークモデル、ID、ストレージ | 包括적 |
| [ベストプラクティス](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/best-practices/) | セキュリティ、ガバナンス、信頼性、コスト最適化のための本番向け設計 | 包括的 |
| [運用](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/operations/) | アップグレード、スケーリング、監視、資格情報のローテーションのための Day-2 ガイド | 包括적 |
| [言語ガイド](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/language-guides/) | AKS ワークロードのための Python コンテナ化とデプロイの入門 | 公開済み |
| [チュートリアル](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/tutorials/) | AGIC イングレス、Key Vault CSI、災害復旧の実習 | 公開済み |
| [トラブルシューティング](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/troubleshooting/) | Pod 失敗、CNI IP 枯渇、イングレス問題の診断プレイブック | 公開済み |
| [視覚化マップ](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/visualization/) | アーキテクチャ、ネットワーク、ID、トラブルシューティングのマップ | 公開済み |
| [リファレンス](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/reference/) | CLI チートシート、制限事項、クォータ、リポジトリのメタモデル | 包括的 |

**ステータス凡例**: **実習検証済み** = 包括的 + ガイドを実証する再現可能な実習を含む · **包括的** = セクション全体完了、MSLearn 検証済み、本番対応 · **公開済み** = コアコンテンツは完成、継続的に拡張中 · **進行中** = 一部のコンテンツあり、活発に開発中 · **計画中** = プレースホルダー、コンテンツ未着手

## 実行可能なアーティファクト

このリポジトリには、AKS 実装を加速するためのデプロイ可能な資産が含まれています：

- [apps/python/](apps/python/): Workload Identity と Key Vault CSI の統合を特徴とする FastAPI リファレンスアプリ
- [infra/](infra/): パブリックおよびプライベート両方の AKS クラスタトポロジに対応した本番向け Bicep ベースライン
- [labs/](labs/): 直接トラブルシューティングを練習できる再現可能な障害注入ラボテンプレート

## 重点分野

このガイドでカバーする AKS クラスタ管理の主な分野：
- **クラスタ管理**: プロビジョニング、ノードプール操作、メンテナンスウィンドウ
- **ネットワーク**: CNI の選択、イングレスコントローラ (AGIC)、サービス接続
- **セキュリティ**: Workload Identity、Key Vault 統合、Kubernetes 用 Azure Policy
- **レジリエンス**: スケーリング操作 (HPA/CA) とマルチリージョン災害復旧
- **運用**: Kubernetes バージョンアップグレードと Container Insights によるクラスタ監視

## クイックスタート

```bash
git clone https://github.com/yeongseon/azure-kubernetes-service-practical-guide.git
cd azure-kubernetes-service-practical-guide

python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements-docs.txt

mkdocs serve
```

ローカルで `http://127.0.0.1:8000` にアクセスしてドキュメントを閲覧してください。

## 貢献

貢献を歓迎します！詳細は [貢献ガイド](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/contributing/) をご覧ください：

- リポジトリ構造とコンテンツ構成
- ドキュメントテンプレートと記述標準
- ローカル開発環境のセットアップとビルド検証
- プルリクエストプロセス

AI エージェントおよび自動化された貢献者は、リポジトリの規約、コンテンツ検証ルール、ナビゲーション予算、ドキュメント標準について [`AGENTS.md`](AGENTS.md) も参照してください。

## 関連プロジェクト

| リポジトリ | 説明 |
|---|---|
| [azure-virtual-machine-practical-guide](https://github.com/yeongseon/azure-virtual-machine-practical-guide) | Azure Virtual Machines 実務ガイド |
| [azure-networking-practical-guide](https://github.com/yeongseon/azure-networking-practical-guide) | Azure Networking 実務ガイド |
| [azure-storage-practical-guide](https://github.com/yeongseon/azure-storage-practical-guide) | Azure Storage 実務ガイド |
| [azure-app-service-practical-guide](https://github.com/yeongseon/azure-app-service-practical-guide) | Azure App Service 実務ガイド |
| [azure-functions-practical-guide](https://github.com/yeongseon/azure-functions-practical-guide) | Azure Functions 実務ガイド |
| [azure-communication-services-practical-guide](https://github.com/yeongseon/azure-communication-services-practical-guide) | Azure Communication Services 実務ガイド |
| [azure-container-apps-practical-guide](https://github.com/yeongseon/azure-container-apps-practical-guide) | Azure Container Apps 実務ガイド |
| [azure-kubernetes-service-practical-guide](https://github.com/yeongseon/azure-kubernetes-service-practical-guide) | Azure Kubernetes Service (AKS) 実務ガイド |
| [azure-architecture-practical-guide](https://github.com/yeongseon/azure-architecture-practical-guide) | Azure Architecture 実務ガイド |
| [azure-monitoring-practical-guide](https://github.com/yeongseon/azure-monitoring-practical-guide) | Azure Monitoring 実務ガイド |

## 免責事項

これは独立したコミュニティプロジェクトです。Microsoft との提携や承認を受けているものではありません。Azure および AKS は Microsoft Corporation の商標です。

## ライセンス

[MIT](LICENSE)
