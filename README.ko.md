# Azure Kubernetes Service 실무 가이드

[English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md)

📘 문서 사이트: <https://yeongseon.github.io/azure-kubernetes-service-practical-guide/>

[![Docs](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/actions/workflows/docs.yml/badge.svg)](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/actions/workflows/docs.yml)
[![CI](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/actions/workflows/validate-content-sources.yml/badge.svg)](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/actions/workflows/validate-content-sources.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

첫 배포부터 운영 환경까지, Azure Kubernetes Service (AKS)에서 컨테이너화된 애플리케이션을 실행하기 위한 포괄적인 가이드입니다.

## 주요 내용

| 섹션 | 설명 | 상태 |
|---------|-------------|--------|
| [시작하기](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/start-here/) | Azure 컨테이너 오케스트레이션 개요, 필수 조건 및 학습 경로 | 포괄적 |
| [플랫폼](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/platform/) | AKS 아키텍처 심층 분석: 노드 풀, 네트워킹 모델, ID 및 스토리지 | 포괄적 |
| [베스트 프랙티스](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/best-practices/) | 보안, 거버넌스, 안정성 및 비용 최적화를 위한 운영 환경 설계 | 포괄적 |
| [운영](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/operations/) | 업그레이드, 스케일링, 모니터링 및 자격 증명 순환을 위한 Day-2 가이드 | 포괄적 |
| [언어 가이드](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/language-guides/) | AKS 워크로드를 위한 Python 컨테이너화 및 배포 입문 | 게시됨 |
| [튜토리얼](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/tutorials/) | AGIC 인그레스, Key Vault CSI 및 재해 복구 실습 | 게시됨 |
| [트러블슈팅](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/troubleshooting/) | 포드 실패, CNI IP 고갈 및 인그레스 문제 진단 플레이북 | 게시됨 |
| [시각화 자료](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/visualization/) | 아키텍처, 네트워킹, ID 및 트러블슈팅 맵 | 게시됨 |
| [참고 자료](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/reference/) | CLI 치트시트, 제한 사항, 쿼터 및 저장소 메타 모델 | 포괄적 |

**상태 범례**: **실습 검증됨** = 포괄적 + 가이드를 증명하는 재현 가능한 실습 포함 · **포괄적** = 전체 섹션 완료, MSLearn 검증, 운영 환경 준비 완료 · **게시됨** = 핵심 콘텐츠 포함, 지속적 확장 중 · **진행 중** = 일부 콘텐츠 포함, 활발히 개발 중 · **계획됨** = 자리 표시자, 콘텐츠 시작 전

## 실행 가능한 아티팩트

이 저장소에는 AKS 구현을 가속화하기 위한 배포 가능한 자산이 포함되어 있습니다:

- [apps/python/](apps/python/): Workload Identity 및 Key Vault CSI 통합이 특징인 FastAPI 참조 앱
- [infra/](infra/): 퍼블릭 및 프라이빗 AKS 클러스터 토폴로지 모두를 위한 운영 환경용 Bicep 베이스라인
- [labs/](labs/): 직접 문제 해결을 연습할 수 있는 재현 가능한 결함 주입 실습 템플릿

## 중점 분야

이 가이드에서 다루는 AKS 클러스터 관리의 핵심 분야:
- **클러스터 관리**: 프로비저닝, 노드 풀 작업 및 유지 관리 기간
- **네트워킹**: CNI 선택, 인그레스 컨트롤러 (AGIC) 및 서비스 연결성
- **보안**: Workload Identity, Key Vault 통합 및 Kubernetes용 Azure Policy
- **복원력**: 스케일링 작업 (HPA/CA) 및 멀티 리전 재해 복구
- **운영**: Kubernetes 버전 업그레이드 및 Container Insights를 통한 클러스터 모니터링

## 빠른 시작

```bash
git clone https://github.com/yeongseon/azure-kubernetes-service-practical-guide.git
cd azure-kubernetes-service-practical-guide

python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements-docs.txt

mkdocs serve
```

로컬에서 `http://127.0.0.1:8000`에 접속하여 문서를 확인하세요.

## 기여하기

기여는 언제나 환영합니다! 다음 사항은 [기여 가이드](https://yeongseon.github.io/azure-kubernetes-service-practical-guide/contributing/)를 참조하세요:

- 저장소 구조 및 콘텐츠 구성
- 문서 템플릿 및 작성 표준
- 로컬 개발 설정 및 빌드 검증
- 풀 요청 프로세스

## 관련 프로젝트

| 저장소 | 설명 |
|---|---|
| [azure-virtual-machine-practical-guide](https://github.com/yeongseon/azure-virtual-machine-practical-guide) | Azure Virtual Machines 실무 가이드 |
| [azure-networking-practical-guide](https://github.com/yeongseon/azure-networking-practical-guide) | Azure Networking 실무 가이드 |
| [azure-storage-practical-guide](https://github.com/yeongseon/azure-storage-practical-guide) | Azure Storage 실무 가이드 |
| [azure-app-service-practical-guide](https://github.com/yeongseon/azure-app-service-practical-guide) | Azure App Service 실무 가이드 |
| [azure-functions-practical-guide](https://github.com/yeongseon/azure-functions-practical-guide) | Azure Functions 실무 가이드 |
| [azure-communication-services-practical-guide](https://github.com/yeongseon/azure-communication-services-practical-guide) | Azure Communication Services 실무 가이드 |
| [azure-container-apps-practical-guide](https://github.com/yeongseon/azure-container-apps-practical-guide) | Azure Container Apps 실무 가이드 |
| [azure-kubernetes-service-practical-guide](https://github.com/yeongseon/azure-kubernetes-service-practical-guide) | Azure Kubernetes Service (AKS) 실무 가이드 |
| [azure-architecture-practical-guide](https://github.com/yeongseon/azure-architecture-practical-guide) | Azure Architecture 실무 가이드 |
| [azure-monitoring-practical-guide](https://github.com/yeongseon/azure-monitoring-practical-guide) | Azure Monitoring 실무 가이드 |

## 면책 조항

이 프로젝트는 독립적인 커뮤니티 프로젝트입니다. Microsoft와 제휴하거나 보증을 받지 않았습니다. Azure 및 AKS는 Microsoft Corporation의 상표입니다.

## 라이선스

[MIT](LICENSE)
