## Awk
파일의 레코드를 검색하고, 선택된 레코드에 포함된 값을 조작하거나 데이터화하는 것이 목적이다. 패턴, 분류, 텍스트, 조작 연산, 액션등 복잡한 작업에 수행된다

```bash
# 모든 레코드 출력
awk '{ print }' ./file.txt

# p를 포함하는 레코드 출력
awk '/p/' ./file.txt   
```

https://recipes4dev.tistory.com/171
https://docs.rockylinux.org/10/books/sed_awk_grep/4_awk_command/
https://stackoverflow.com/questions/17908555/printing-with-sed-or-awk-a-line-following-a-matching-pattern