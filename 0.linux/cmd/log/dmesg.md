## dmesg

### 핵심 개념

* `dmesg`는 Linux kernel ring buffer에 저장된 kernel message를 조회하거나 제어하는 명령어입니다.
* kernel ring buffer는 kernel이 boot, hardware detection, driver load, device error, filesystem error, OOM, kernel warning 같은 메시지를 기록하는 순환 버퍼입니다. 버퍼 크기는 제한되어 있어 새 메시지가 오래된 메시지를 덮어쓸 수 있습니다.
* `dmesg`는 장애 직후 kernel 수준 이벤트를 빠르게 확인할 때 유용합니다. 특히 disk I/O error, NIC link up/down, USB/device 인식, module load 실패, OOM kill, segfault, kernel warning 분석에 자주 사용합니다.
* 최신 systemd 기반 배포판에서는 kernel message가 `systemd-journald`에도 수집되므로 `journalctl -k`와 함께 확인하는 것이 좋습니다. `dmesg`는 현재 kernel ring buffer를 직접 보는 성격이고, `journalctl -k`는 journal에 저장된 kernel log를 시간/boot 기준으로 조회하는 데 유리합니다.
* RHEL / Debian 계열 모두 `dmesg`는 일반적으로 `util-linux` 패키지에 포함됩니다. 배포판과 보안 설정에 따라 일반 사용자의 `dmesg` 접근이 `kernel.dmesg_restrict` 또는 capability 정책으로 제한될 수 있습니다.

### 작성 위치

* 바이너리 경로: 일반적으로 `/usr/bin/dmesg` 또는 `/bin/dmesg`입니다. 실제 위치는 `command -v dmesg`로 확인합니다.
* 설정 파일 위치: `/proc/sys/kernel/dmesg_restrict`, `/proc/sys/kernel/printk`, 영구 sysctl 설정은 `/etc/sysctl.conf` 또는 `/etc/sysctl.d/*.conf`입니다.
* 로그 파일 위치: kernel ring buffer는 메모리 기반이며 파일이 아닙니다. systemd 환경에서는 `journalctl -k`로 journal에 저장된 kernel log를 확인합니다. 배포판/설정에 따라 `/var/log/dmesg`, `/var/log/kern.log`, `/var/log/messages`, `/var/log/boot.log`가 관련될 수 있습니다.
* 관련 서비스(systemd) 위치: `systemd-journald.service`, 선택적으로 `rsyslog.service`가 kernel log 저장과 전달에 관여할 수 있습니다.

### 사용 방법

```sh
# 기본 사용법
dmesg [옵션]
```

### 간단한 예제

```sh
# 예제 1: kernel ring buffer 전체 조회
dmesg

# 예제 2: 사람이 읽기 쉬운 시간 형식으로 error 이상의 메시지 확인
dmesg -T -l err,crit,alert,emerg
```

### 주요 옵션

| 옵션 | 설명 |
| -- | -- |
| -H, --human | pager와 color를 사용하는 사람이 읽기 쉬운 출력 형식으로 표시합니다. |
| -T, --ctime | timestamp를 사람이 읽기 쉬운 wall-clock 시간으로 표시합니다. suspend/resume 이후 시간 정확도에 주의합니다. |
| -w, --follow | 새 kernel message를 계속 출력합니다. 장애 재현 중 실시간 확인에 사용합니다. |
| -l, --level | `err`, `warn`, `info` 같은 log level로 필터링합니다. |
| -f, --facility | `kern`, `daemon` 같은 facility로 필터링합니다. |
| -k, --kernel | kernel message만 출력합니다. |
| -x, --decode | facility와 level을 사람이 읽기 쉽게 decode해서 표시합니다. |
| -t, --notime | timestamp를 출력하지 않습니다. |
| -C, --clear | kernel ring buffer를 비웁니다. 운영 환경에서는 증거 보존 관점에서 주의가 필요합니다. |
| -c, --read-clear | 메시지를 출력한 뒤 kernel ring buffer를 비웁니다. 운영 환경에서는 사용 전 로그 보존 여부를 확인합니다. |

### 실무 예제

```sh
# disk, filesystem, I/O 관련 kernel error 확인
dmesg -T -l err,crit,alert,emerg | grep -Ei 'blk|scsi|nvme|ata|ext4|xfs|io error|I/O error'
```

```sh
# 장애 재현 중 kernel message 실시간 관찰
dmesg -wH
```

```sh
# 이번 boot의 kernel log를 journal 기준으로 함께 확인
journalctl -k -b --no-pager
```

### 확인 방법

```sh
# dmesg 실행 파일 위치와 패키지 확인
command -v dmesg

# RHEL 계열
rpm -qf "$(command -v dmesg)"

# Debian 계열
dpkg -S "$(command -v dmesg)"

# 일반 사용자 dmesg 접근 제한 여부 확인
cat /proc/sys/kernel/dmesg_restrict
```

### 주의사항

* kernel ring buffer는 크기가 제한된 순환 버퍼입니다. 장애 이후 시간이 지나거나 메시지가 많이 발생하면 중요한 초기 로그가 덮어써질 수 있습니다.
* `dmesg -C`와 `dmesg -c`는 kernel ring buffer를 지우므로 운영 장애 분석이나 보안 사고 조사 중에는 사용하지 않는 것이 안전합니다.
* `dmesg -T`의 사람이 읽기 쉬운 시간은 시스템 suspend/resume, clock 변경, 부팅 이후 시간 계산 방식에 따라 정확하지 않을 수 있습니다. 정밀한 시간 분석은 `journalctl -k`와 함께 비교합니다.
* `kernel.dmesg_restrict=1`이면 일반 사용자가 `dmesg`를 읽지 못할 수 있습니다. 이는 kernel address, device 정보 등 민감한 정보 노출을 줄이기 위한 보안 설정입니다.
* `dmesg` 출력에는 hardware serial, device topology, kernel pointer, crash 정보처럼 민감할 수 있는 내용이 포함될 수 있습니다. 외부 공유 전 필요한 부분만 발췌하고 민감정보를 마스킹합니다.
* `dmesg -w`는 실시간 출력이므로 메시지가 많은 장애 상황에서는 terminal과 로그 수집 파이프라인에 부하를 줄 수 있습니다. 필요한 필터와 함께 사용합니다.

### 공식 문서

* RHEL: https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/10/html/managing_monitoring_and_updating_the_kernel/getting-started-with-kernel-logging
* Debian: https://manpages.debian.org/testing/util-linux/dmesg.1.en.html
* Upstream: https://www.kernel.org/pub/linux/utils/util-linux/ , https://www.freedesktop.org/software/systemd/man/latest/journalctl.html
* man page: https://man7.org/linux/man-pages/man1/dmesg.1.html , `man dmesg`, `man syslog`, `man proc_sys_kernel`
