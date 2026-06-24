## Strace
trace system calls and signals

```bash
# 전체 명령어 정리
strace -s 65535 -tt -f -o uptime_dump uptime

# 바이너리 추적, 실행 가능한 바이너리를 추적
strace uptime

# 트레이스 대상의 시스템 콜을 한정하여 출력
strace -e nmap uptime
# 여러 시스템 콜을 한정하여 추력
strace -e trace=network,process uptime

# 결과를 파일에 저장
strace -o uptime_dump uptime

# 라인 별 시간 출력
strace -tt uptime

# 조회 대상의 시스템 콜 통계 출력
strace -c uptime

# 시스템 콜의 인자와 리턴값에 대한 문자열 최대값 정의.
strace -s 65535 uptime

# 자식 프로세스 및 스레드를 포함하여 추적
strace -f uptime

# pid를 이용하여 프로세스 추적
strace -p <PID>
```

[Ref]

https://brunch.co.kr/@alden/12

https://man7.org/linux/man-pages/man1/strace.1.html