**DNS 조회 명령어:**
```bash
# 정방향 조회
nslookup naver.com

# 역방향 조회
dig -x @DNS서버 IP주소
dig -x @168.126.63.1 74.6.136.150

# 재귀 질의
dig google.com @8.8.8.8

# trace 옵션으로 순환 과정 확인
dig @DNS서버 도메인 +trace
dig @168.126.63.1 yahoo.co.kr +trace 
```