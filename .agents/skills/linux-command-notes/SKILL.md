---
name: linux-command-notes
description: Create or update categorized Linux command reference Markdown under 0.linux/cmd for RHEL-family and Debian-family systems. Use when writing, organizing, verifying, or expanding command docs with sections for core concepts, paths, examples, options, operations examples, validation, cautions, and official documentation sources.
---

# Linux Command Notes

Use this skill to write Linux command documentation for a platform/DevOps engineer who works with RHEL-family and Debian-family systems.

## Target Location

- Store command documents under `0.linux/cmd/<category>/<command>.md`.
- Use the existing category directories when possible:
  - `log`: log and journal commands such as `journalctl`, `dmesg`, `logger`.
  - `monitor`: resource and status commands such as `top`, `free`, `df`, `iostat`, `vmstat`.
  - `network`: network commands such as `ip`, `ss`, `nmcli`, `dig`, `tcpdump`.
  - `os`: OS, kernel, process, module, limit, and system behavior commands such as `uname`, `sysctl`, `lsmod`, `ulimit`.
  - `profile`: shell profile, environment, and user session commands such as `env`, `printenv`, `export`.
  - `search`: file and text search commands such as `find`, `grep`, `rg`, `locate`.
  - `trace`: tracing and debugging commands such as `strace`, `ltrace`, `perf`, `bpftrace`.
- If no existing category fits, create a concise new category under `0.linux/cmd` only when it is clearly justified.
- Use lowercase command file names, for example `0.linux/cmd/os/ulimit.md`.
- If the target file already exists, preserve useful existing content and revise it into the required structure instead of appending duplicate sections.

## Required Document Structure

Use this structure for every command document:

````markdown
## 명령어

### 핵심 개념

* 명령어의 목적
* 동작 원리
* 주요 사용 사례
* RHEL / Debian 계열 차이점 (존재하는 경우)

### 작성 위치

* 바이너리 경로
* 설정 파일 위치
* 로그 파일 위치
* 관련 서비스(systemd) 위치

### 사용 방법

```sh
# 기본 사용법
명령어 [옵션]
```

### 간단한 예제

```sh
# 예제 1
명령어 옵션

# 예제 2
명령어 옵션
```

### 주요 옵션

| 옵션 | 설명 |
| -- | -- |
| -a | 설명 |
| -b | 설명 |

### 실무 예제

```sh
# 실제 운영 환경에서 사용하는 예제
```

### 확인 방법

```sh
# 결과 검증
```

### 주의사항

* 운영 환경에서 주의할 점
* 성능 영향
* 보안 영향

### 공식 문서

* RHEL:
* Debian:
* Upstream:
* man page:
````

Replace `명령어` with the actual command name, for example `ulimit`, `sysctl`, `journalctl`, or `ss`.

## Writing Rules

- Write in Korean. Keep commands, flags, paths, service names, package names, errors, and upstream terms in their original form.
- Explain from an operator perspective: what to check, when to use it, how it behaves, and what can go wrong in production.
- Keep each bullet specific. Do not leave placeholder text such as `설명`, `명령어 옵션`, or empty source fields in the final file.
- Use practical examples that can run after replacing placeholders like `<SERVICE>`, `<USER>`, `<DEVICE>`, `<PATH>`, `<PID>`, `<HOST>`, or `<INTERFACE>`.
- Mention RHEL/Debian differences only when they affect package names, binary paths, config paths, log paths, service names, defaults, or operational behavior.
- For unavailable items in `작성 위치`, write `해당 없음` with a short reason. For example, a shell builtin may not have a standalone binary path.
- Include safety notes for destructive or high-impact commands such as `rm`, `mkfs`, `dd`, `parted`, `lvremove`, `systemctl restart`, firewall changes, package removal, kernel parameter changes, and tracing commands with performance impact.
- Do not include secrets, real internal hostnames, private IPs, tokens, private keys, kubeconfig contents, or customer data.
- Do not invent flags, default paths, package names, or behavior. Verify first when uncertain.

## Source Policy

- 기본 출처는 반드시 공식 문서여야 한다. 정말 안 될 경우에만 개인 링크 또는 커뮤니티 링크를 보조 참고자료로 사용한다.
- Prefer official sources in this order:
  - Local `man`/`help` output or authoritative man page mirrors.
  - Upstream documentation such as GNU, util-linux, systemd, iproute2, procps-ng, OpenSSH, curl, Git, kernel, or the command's project docs.
  - Red Hat official documentation for RHEL-family behavior.
  - Debian, Ubuntu, or package maintainer documentation for Debian-family behavior.
- Fill `공식 문서` with source names or URLs when available.
- If official documentation is incomplete or unavailable, use reputable community or personal links only as secondary references and label them as non-official.
- For version-sensitive commands, state the assumed distribution/version or write a version caveat.

## Workflow

1. Determine the command and target category under `0.linux/cmd`.
2. Inspect the existing target file and nearby files in the same category.
3. Verify command behavior from official sources for important flags, paths, and distro differences.
4. Write or rewrite the file using the required document structure.
5. Ensure all sections are populated and all shell examples use fenced `sh` blocks.
6. Review that the final file is useful for incident response, maintenance windows, and daily platform operations.
7. Summarize the file path, major changes, source assumptions, and any sections where official docs were unavailable.

## Quality Bar

- Make the document dense and operational, not a beginner tutorial.
- Prefer two good examples over a long list of shallow examples.
- Include validation commands that prove the example worked or show where to inspect the result.
- Keep source references honest: official first, community only when official documentation is not enough.
