#!/usr/bin/env python3
"""Generate content validation status dashboard from frontmatter metadata."""

from __future__ import annotations

import argparse
import re
from collections import Counter
from pathlib import Path
from typing import Any

import yaml

VALID_STATUSES = {"verified", "pending_review", "unverified"}
LAB_PREFIX = "tutorials/lab-guides/lab-"


def extract_frontmatter(path: Path) -> dict[str, Any] | None:
    text = path.read_text(encoding="utf-8")
    match = re.match(r"^---\s*\n(.*?)\n---\s*\n", text, re.DOTALL)
    if not match:
        return None
    data = yaml.safe_load(match.group(1))
    return data if isinstance(data, dict) else None


def is_tutorial(path: Path, docs_dir: Path) -> bool:
    return path.relative_to(docs_dir).as_posix().startswith(LAB_PREFIX)


def get_status(frontmatter: dict[str, Any] | None) -> str:
    if not frontmatter:
        return "missing"
    content_validation = frontmatter.get("content_validation")
    if not isinstance(content_validation, dict):
        return "missing"
    status = content_validation.get("status")
    return status if status in VALID_STATUSES else "missing"


def count_core_claims(frontmatter: dict[str, Any] | None) -> tuple[int, int]:
    if not frontmatter:
        return 0, 0
    content_validation = frontmatter.get("content_validation")
    if not isinstance(content_validation, dict):
        return 0, 0
    claims = content_validation.get("core_claims", [])
    if not isinstance(claims, list):
        return 0, 0
    total = len(claims)
    verified = sum(
        1
        for claim in claims
        if isinstance(claim, dict) and claim.get("verified") is True
    )
    return total, verified


def count_diagram_sources(frontmatter: dict[str, Any] | None) -> Counter[str]:
    sources: Counter[str] = Counter()
    if not frontmatter:
        return sources
    content_sources = frontmatter.get("content_sources")
    if not isinstance(content_sources, dict):
        return sources
    diagrams = content_sources.get("diagrams", [])
    if not isinstance(diagrams, list):
        return sources
    for diagram in diagrams:
        if isinstance(diagram, dict):
            sources[str(diagram.get("source", "missing"))] += 1
    return sources


def collect_status(docs_dir: Path) -> dict[str, Any]:
    docs = []
    status_counts: Counter[str] = Counter()
    diagram_source_counts: Counter[str] = Counter()
    total_claims = 0
    verified_claims = 0

    for path in sorted(docs_dir.glob("**/*.md")):
        if is_tutorial(path, docs_dir):
            continue

        frontmatter = extract_frontmatter(path)
        status = get_status(frontmatter)
        claim_count, verified_count = count_core_claims(frontmatter)
        diagram_sources = count_diagram_sources(frontmatter)

        rel_path = path.relative_to(docs_dir).as_posix()
        docs.append(
            {
                "path": rel_path,
                "status": status,
                "claim_count": claim_count,
                "verified_claims": verified_count,
            }
        )

        status_counts[status] += 1
        total_claims += claim_count
        verified_claims += verified_count
        diagram_source_counts.update(diagram_sources)

    return {
        "docs": docs,
        "status_counts": status_counts,
        "diagram_source_counts": diagram_source_counts,
        "total_claims": total_claims,
        "verified_claims": verified_claims,
    }


def generate_dashboard(data: dict[str, Any]) -> str:
    status_counts: Counter[str] = data["status_counts"]
    diagram_source_counts: Counter[str] = data["diagram_source_counts"]
    docs = data["docs"]
    total_docs = len(docs)
    total_diagrams = sum(diagram_source_counts.values())

    lines = [
        "---",
        "content_sources:",
        "  diagrams:",
        "    - id: reference-content-validation-status",
        "      type: pie",
        "      source: self-generated",
        "      justification: Text and diagram validation status chart generated from repository frontmatter metadata.",
        "      based_on:",
        "        - docs/",
        "content_validation:",
        "  status: pending_review",
        "  last_reviewed: null",
        "  reviewer: agent",
        "  core_claims: []",
        "---",
        "",
        "# Content Source Validation Status",
        "",
        "This page tracks non-tutorial text validation metadata and Mermaid diagram source metadata declared in document frontmatter.",
        "",
        "## Summary",
        "",
        "*Generated from repository frontmatter metadata.*",
        "",
        "| Text Validation Status | Count |",
        "|---|---:|",
        f"| Total non-tutorial documents | {total_docs} |",
        f"| Verified | {status_counts['verified']} |",
        f"| Pending review | {status_counts['pending_review']} |",
        f"| Unverified | {status_counts['unverified']} |",
        f"| Missing metadata | {status_counts['missing']} |",
        f"| Core claims listed | {data['total_claims']} |",
        f"| Core claims verified | {data['verified_claims']} |",
        "",
        "| Diagram Source Type | Count |",
        "|---|---:|",
        f"| Mermaid diagrams | {total_diagrams} |",
        f"| MSLearn sourced | {diagram_source_counts['mslearn'] + diagram_source_counts['mslearn-adapted']} |",
        f"| Self-generated | {diagram_source_counts['self-generated']} |",
        f"| Missing source metadata | {diagram_source_counts['missing']} |",
        "",
        "!!! warning \"Validation state\"",
        "    `pending_review` means the document participates in the tracking workflow, but its individual factual claims still need claim-level source review. Do not treat pending documents as verified.",
        "",
        "<!-- diagram-id: reference-content-validation-status -->",
        "```mermaid",
        "pie title Text Validation Status",
    ]

    if status_counts["verified"]:
        lines.append(f'    "Verified" : {status_counts["verified"]}')
    if status_counts["pending_review"]:
        lines.append(f'    "Pending Review" : {status_counts["pending_review"]}')
    if status_counts["unverified"]:
        lines.append(f'    "Unverified" : {status_counts["unverified"]}')
    if status_counts["missing"]:
        lines.append(f'    "Missing Metadata" : {status_counts["missing"]}')
    lines.extend(
        [
            "```",
            "",
            "## Document Matrix",
            "",
            "| Document | Status | Core Claims | Verified Claims |",
            "|---|---|---:|---:|",
        ]
    )

    for item in docs:
        title = item["path"]
        link = f"[{title}](../{item['path']})"
        lines.append(
            f"| {link} | `{item['status']}` | {item['claim_count']} | {item['verified_claims']} |"
        )

    lines.extend(
        [
            "",
            "## How to Update",
            "",
            "Add a `content_validation` block to every non-tutorial Markdown file:",
            "",
            "```yaml",
            "content_validation:",
            "  status: pending_review",
            "  last_reviewed: null",
            "  reviewer: agent",
            "  core_claims: []",
            "```",
            "",
            "When claims have been reviewed against Microsoft Learn, replace the empty claim list with 2-5 sourced claims and set `status: verified` only if every listed claim is verified.",
            "",
            "Then regenerate this page:",
            "",
            "```bash",
            "python3 scripts/generate_content_validation_status.py",
            "```",
            "",
            "## See Also",
            "",
            "- [Tutorial Validation Status](validation-status.md)",
            "- [CLI Cheatsheet](cli-cheatsheet.md)",
            "- [Limits and Quotas](limits-and-quotas.md)",
            "",
            "## Sources",
            "",
            "- [Azure Kubernetes Service documentation](https://learn.microsoft.com/en-us/azure/aks/)",
            "- [AKS cluster architecture](https://learn.microsoft.com/en-us/azure/aks/concepts-clusters-workloads)",
        ]
    )

    return "\n".join(lines).rstrip() + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate content validation status dashboard"
    )
    parser.add_argument(
        "--docs-dir",
        type=Path,
        default=Path("docs"),
        help="Path to docs directory",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("docs/reference/content-validation-status.md"),
        help="Dashboard output path",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="Fail if the generated dashboard differs from the output file",
    )
    args = parser.parse_args()

    data = collect_status(args.docs_dir)
    content = generate_dashboard(data)

    if args.check:
        existing = args.output.read_text(encoding="utf-8")
        if existing != content:
            raise SystemExit(
                f"{args.output} is stale. Run scripts/generate_content_validation_status.py."
            )
        return

    args.output.write_text(content, encoding="utf-8")
    print(f"Scanned {len(data['docs'])} non-tutorial documents, generated {args.output}")


if __name__ == "__main__":
    main()
