## ulimit

### 핵심 개념

* `ulimit`은 현재 shell과 그 shell이 실행하는 자식 프로세스의 resource limit을 조회하거나 설정하는 shell builtin 명령어입니다.
* Linux resource limit은 프로세스 단위 속성이며, child process는 parent process의 limit을 상속합니다. 따라서 `ulimit`으로 바꾼 값은 현재 shell 세션과 이후 실행하는 명령에 영향을 주고, 이미 실행 중인 다른 프로세스에는 직접 적용되지 않습니다.
* soft limit은 현재 적용되는 제한이고, hard limit은 일반 사용자가 올릴 수 있는 상한입니다. 일반 사용자는 soft limit을 hard limit 이하로만 올릴 수 있으며, hard limit을 올리려면 보통 root 권한 또는 로그인/session manager 설정이 필요합니다.
* 주요 사용 사례는 open file descriptor 부족(`Too many open files`) 분석, core dump 생성 허용, stack size 확인, 사용자별 process 수 제한 확인, DB/웹서버/프록시 실행 전 limit 검증입니다.
* RHEL / Debian 계열 모두 Bash에서는 `ulimit`을 shell builtin으로 제공합니다. 로그인 세션의 기본 limit은 공통적으로 PAM `pam_limits`와 `/etc/security/limits.conf`, `/etc/security/limits.d/*.conf` 영향을 받을 수 있습니다. systemd service는 PAM 로그인 shell과 경로가 다르므로 unit의 `LimitNOFILE=`, `LimitNPROC=`, `LimitCORE=` 같은 설정을 별도로 확인해야 합니다.

### 작성 위치

* 바이너리 경로: 해당 없음. Bash 기준 `ulimit`은 외부 binary가 아니라 shell builtin입니다. `type ulimit` 또는 `help ulimit`로 확인합니다.
* 설정 파일 위치: `/etc/security/limits.conf`, `/etc/security/limits.d/*.conf`, systemd unit/drop-in의 `[Service] Limit*=` 설정.
* 로그 파일 위치: 별도 전용 로그는 없습니다. 적용 여부는 shell 출력, `/proc/<PID>/limits`, systemd unit 상태, 서비스 로그로 확인합니다.
* 관련 서비스(systemd) 위치: systemd service별 unit 파일(`/usr/lib/systemd/system/*.service`, `/lib/systemd/system/*.service`, `/etc/systemd/system/*.service`)과 drop-in(`/etc/systemd/system/<SERVICE>.service.d/*.conf`).

### 사용 방법

```sh
# 기본 사용법
ulimit [옵션]
```

### 간단한 예제

```sh
# 예제 1: 현재 shell의 모든 resource limit 확인
ulimit -a

# 예제 2: 현재 shell의 open file descriptor soft limit 확인
ulimit -Sn
```

### 주요 옵션

| 옵션 | 설명 |
| -- | -- |
| -a | 현재 resource limit 전체를 출력합니다. 값을 변경하지 않습니다. |
| -S | soft limit을 조회하거나 설정합니다. |
| -H | hard limit을 조회하거나 설정합니다. |
| -n | open file descriptor 최대 개수를 조회하거나 설정합니다. |
| -u | 단일 사용자에게 허용되는 process 수를 조회하거나 설정합니다. |
| -c | core file 최대 크기를 조회하거나 설정합니다. `0`이면 core dump가 생성되지 않습니다. |
| -s | stack size limit을 조회하거나 설정합니다. |
| -l | memory lock limit을 조회하거나 설정합니다. |
| -v | virtual memory limit을 조회하거나 설정합니다. |
| unlimited | 지정한 resource limit을 무제한으로 설정할 때 사용하는 값입니다. 실제 적용 가능 여부는 hard limit과 권한에 따라 달라집니다. |

### 실무 예제

```sh
# 현재 shell에서 실행할 프로세스의 open file descriptor limit을 임시로 올린 뒤 서비스 프로세스 실행
ulimit -n 65535
exec /opt/<APP>/bin/<APP>
```

```sh
# 실행 중인 프로세스의 실제 limit 확인
cat /proc/<PID>/limits
```

```sh
# systemd 서비스의 open file descriptor limit 확인
systemctl show <SERVICE> -p LimitNOFILE -p LimitNPROC -p LimitCORE
```

### 확인 방법

```sh
# ulimit이 shell builtin인지 확인
type ulimit

# 현재 shell의 soft/hard open file descriptor limit 확인
ulimit -Sn
ulimit -Hn

# 특정 프로세스에 적용된 limit 확인
cat /proc/<PID>/limits
```

### 주의사항

* `ulimit`으로 설정한 값은 현재 shell과 이후 생성되는 자식 프로세스에만 적용됩니다. 이미 떠 있는 daemon이나 다른 terminal session에는 적용되지 않습니다.
* `ulimit -n 65535`처럼 현재 shell에서 임시로 올린 값은 logout, shell 종료, process 재시작 후 유지되지 않습니다. 영구 적용은 PAM limits 또는 systemd unit 설정을 사용해야 합니다.
* systemd service의 limit 문제를 `/etc/security/limits.conf`만 수정해서 해결하려고 하면 적용되지 않을 수 있습니다. systemd 서비스는 unit의 `LimitNOFILE=`, `LimitNPROC=` 등으로 확인하고 조정합니다.
* `nofile` 값을 과도하게 올리면 프로세스가 많은 file descriptor를 열 수 있어 장애 시 영향 범위가 커질 수 있습니다. 애플리케이션 요구량, kernel 전역 제한, monitoring 기준을 함께 검토합니다.
* `ulimit -c unlimited`는 core dump 생성을 허용할 수 있어 디스크 사용량과 민감정보 노출 위험이 있습니다. core dump 저장 위치, 권한, 보존 정책을 같이 확인합니다.
* container 환경에서는 host, container runtime, systemd, OCI runtime, orchestrator 설정이 함께 영향을 줄 수 있으므로 container 내부 `ulimit` 출력만으로 전체 원인을 단정하지 않습니다.

### 공식 문서

* RHEL: Red Hat Customer Portal - All about resource limits: ulimit, pam_limits.so, `/etc/limits.conf`, and `/etc/security/limits.d`
* Debian: Debian/Ubuntu 계열은 Linux-PAM `limits.conf(5)` / `pam_limits(8)` man page와 배포판 패키지 문서를 우선 확인
* Upstream: GNU Bash Reference Manual - Bash Builtin Commands, `ulimit`; systemd `systemd.exec(5)` resource limit directives
* man page: `ulimit(1p)`, `limits.conf(5)`, `pam_limits(8)`, `proc_pid_limits(5)`, `getrlimit(2)`
