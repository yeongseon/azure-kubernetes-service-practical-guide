# Azure Kubernetes Service 실무 가이드

[English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md)

첫 배포부터 운영 환경까지, Azure Kubernetes Service (AKS)에서 컨테이너화된 애플리케이션을 실행하기 위한 포괄적인 가이드입니다.

## 주요 내용

| 섹션 | 설명 |
|---------|-------------|
| [시작하기 (Start Here)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/start-here/) | 개요 및 학습 경로 |
| [플랫폼 (Platform)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/platform/) | AKS 아키텍처, 네트워킹, 노드 풀 |
| [베스트 프랙티스 (Best Practices)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/best-practices/) | 운영 패턴 및 보안 |
| [운영 (Operations)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/operations/) | 스케일링, 업그레이드, 모니터링 |
| [트러블슈팅 (Troubleshooting)](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/troubleshooting/) | 주요 이슈 및 해결 방법 |

## 빠른 시작

```bash
# 저장소 복제
git clone https://github.com/yeongseon/azure-kubernetes-service-practical-guide.git

# MkDocs 의존성 설치
pip install mkdocs-material mkdocs-minify-plugin

# 로컬 문서 서버 시작
mkdocs serve
```

로컬에서 `http://127.0.0.1:8000`에 접속하여 문서를 확인하세요.

## 기여하기

기여는 언제나 환영합니다. 다음 사항을 준수해 주세요:
- 모든 CLI 예제에는 긴 플래그를 사용하세요 (`-g` 대신 `--resource-group`)
- 모든 문서에는 Mermaid 다이어그램을 포함하세요
- 모든 콘텐츠는 출처 URL과 함께 Microsoft Learn을 참조해야 합니다
- CLI 출력 예제에 개인 식별 정보(PII)를 포함하지 마세요

## 관련 프로젝트

| 저장소 | 설명 |
|---|---|
| [azure-virtual-machine-practical-guide](https://github.com/yeongseon/azure-virtual-machine-practical-guide) | Azure Virtual Machines 실무 가이드 |
| [azure-networking-practical-guide](https://github.com/yeongseon/azure-networking-practical-guide) | Azure Networking 실무 가이드 |
| [azure-storage-practical-guide](https://github.com/yeongseon/azure-storage-practical-guide) | Azure Storage 실무 가이드 |
| [azure-app-service-practical-guide](https://github.com/yeongseon/azure-app-service-practical-guide) | Azure App Service 실무 가이드 |
| [azure-functions-practical-guide](https://github.com/yeongseon/azure-functions-practical-guide) | Azure Functions 실무 가이드 |
| [azure-container-apps-practical-guide](https://github.com/yeongseon/azure-container-apps-practical-guide) | Azure Container Apps 실무 가이드 |
| [azure-monitoring-practical-guide](https://github.com/yeongseon/azure-monitoring-practical-guide) | Azure Monitoring 실무 가이드 |

## 면책 조항

이 프로젝트는 독립적인 커뮤니티 프로젝트입니다. Microsoft와 제휴하거나 보증을 받지 않았습니다. Azure 및 AKS는 Microsoft Corporation의 상표입니다.

## 라이선스

[MIT](LICENSE)
