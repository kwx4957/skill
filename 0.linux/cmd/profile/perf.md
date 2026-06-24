## Perf
리눅스에서 성능 분석을 위한 도구로서, CPU 성능 카운터를 사용하여 시스템의 성능을 분석하고, CPU 사용량, 메모리 사용량, I/O 대기 시간 등을 측정할 수 있습니다. Perf는 다양한 기능을 제공하며, 이를 통해 시스템의 성능을 최적화할 수 있습니다.

```bash
dnf install -y perf

perf [ list | stat | record | report | top | test ]

# 성능 부선 가능한 옵션 출력
perf list

# perf 동작 테스트
perf test

# 샘플링된 함수를 실시간으로 출력한다.
perf top

perf stat
```

[Ref]

https://perfwiki.github.io/main/tutorial/

https://man7.org/linux/man-pages/man1/perf.1.html