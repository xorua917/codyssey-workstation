# CODYSSEY MISSION 01 — 개발 워크스테이션 구축

> **입학연수 · 개발 입문 · 필수 40시간**  
> 터미널, Docker, Git/GitHub를 이용해 재현 가능한 개발환경을 만들고 실행 결과로 검증하는 미션

## 1. 프로젝트 개요

Windows의 WSL 2에서 Ubuntu와 VS Code를 연동하고, Linux CLI로 파일·권한을 관리했습니다. Docker Desktop 환경에서 `hello-world` 및 Ubuntu 컨테이너를 실행·관리했고, NGINX 기반의 자체 `Dockerfile`로 정적 웹 서버 이미지를 빌드했습니다. 로컬 포트로 웹 서버에 접속하고, 바인드 마운트의 변경 반영과 Docker 볼륨의 데이터 영속성을 확인했습니다.

- **제출 형식:** 이 GitHub 저장소의 소스코드, README, 실제 실행 로그 및 스크린샷
- **실습 위치:** Ubuntu 홈 디렉터리의 `codyssey-workstation` (개인 컴퓨터 경로에 따라 달라짐)
- **웹 서버 이미지:** `codyssey-web:1.0`
- **기본 접속 포트:** 호스트 `8080` → 컨테이너 `80`
- **바인드 마운트 검증 포트:** 호스트 `8081` → 컨테이너 `80`

## 2. 실행 환경

| 구성요소 | 실습에서 확인한 값 | 확인 근거 |
| --- | --- | --- |
| 호스트 환경 | Windows + WSL 2 | [Docker 상태 로그](evidence/logs/02_docker_basics.log) |
| Ubuntu (WSL) | Ubuntu **26.04.1 LTS** | `cat /etc/os-release` 실습 출력 (README 작성 전 별도 확인) |
| 셸 / 터미널 | Bash / VS Code 통합 터미널 (WSL: Ubuntu) | [Linux CLI 로그](evidence/logs/01_terminal.log) |
| Docker Desktop | **4.97.0** | [Docker 상태 로그](evidence/logs/02_docker_basics.log) |
| Docker Client / Server | **29.9.2** | [Docker 상태 로그](evidence/logs/02_docker_basics.log) |
| Docker Compose | **v5.6.1** (설치 확인, 보너스 수행은 별도) | [Docker 상태 로그](evidence/logs/02_docker_basics.log) |
| Git | **2.53.0** | 사용자 터미널에서 `git --version`으로 확인 |
| 실습용 Ubuntu 컨테이너 | Ubuntu **24.04.5 LTS** (`ubuntu:24.04`) | [Docker 기본 실습 로그](evidence/logs/02_docker_basics.log) |

> **주의:** WSL의 Ubuntu 버전(26.04.1)과 컨테이너 안의 Ubuntu 버전(24.04.5)은 서로 다릅니다. 이는 정상이며, 서로 다른 실행 환경임을 보여줍니다. Windows의 정확한 에디션·빌드 정보는 아직 확인하지 않았으므로 기재하지 않았습니다.

## 3. 필수 수행 체크리스트

- [x] 현재 경로·숨김 파일 목록·디렉터리 이동·파일 생성/복사/이름 변경/삭제/내용 확인
- [x] 파일 권한 변경 `644 → 600`, 디렉터리 권한 변경 `755 → 700`
- [x] `docker --version`, `docker info`로 설치 및 엔진 점검
- [x] `hello-world` 및 Ubuntu 컨테이너 실행
- [x] `docker images`, `docker ps`, `docker ps -a`, `docker logs`, `docker stats` 실행
- [x] 컨테이너 중지/재시작 및 `attach` 방식(`start -ai`)과 `exec` 방식 확인
- [x] 직접 작성한 NGINX 기반 Dockerfile로 커스텀 이미지 빌드
- [x] 포트 매핑 및 HTTP 접속 확인 (8080)
- [x] 바인드 마운트 수정 전후 확인 (8081)
- [x] Docker 볼륨을 컨테이너에 연결하고 삭제 후 데이터 유지 검증
- [x] Git 사용자 이름·이메일·기본 브랜치 설정 (로컬에서 확인; 공개 증거 로그는 추가 예정)
- [x] Git 저장소 초기화 (`git init -b main`) 및 `main` 브랜치 확인
- [ ] GitHub 원격 저장소 연결 및 Push 확인
- [ ] VS Code의 GitHub 로그인 및 저장소 연동 스크린샷 첨부
- [ ] 전체 README·증거 링크 최종 검토 및 제출

## 4. 프로젝트 파일 구조

```text
codyssey-workstation/
├── README.md
├── Dockerfile
├── site/
│   └── index.html
├── practice/
│   ├── cli/
│   │   └── hello.txt
│   ├── secure-dir/
│   └── bind-site/
│       └── change.txt
└── evidence/
    ├── logs/
    │   ├── 01_terminal.log
    │   ├── 02_docker_basics.log
    │   ├── 03_web_server.log
    │   ├── 04_bind_mount.log
    │   └── 05_volume.log
    └── screenshots/
        ├── port-8080.png
        └── port-8081.png
```

> 파일 목록은 실제 로컬 실습 결과를 기준으로 작성했습니다. 빈 디렉터리(`practice/secure-dir`)는 Git에 자동으로 업로드되지 않을 수 있습니다. 평가에 필요한 권한 변경 전후 기록은 로그에 있습니다.

## 5. 검증 명령어 및 실제 결과

### 5-1. Linux CLI와 권한

[실제 터미널 로그 보기](evidence/logs/01_terminal.log)

```bash
pwd
ls -la
mkdir -p practice/cli
cd practice/cli
touch hello.txt
echo "Hello Codyssey" > hello.txt
cat hello.txt
# Hello Codyssey
```

파일 복사·이름 변경·삭제를 수행했습니다.

```bash
cp practice/cli/hello.txt practice/cli/hello-copy.txt
mv practice/cli/hello-copy.txt practice/cli/renamed.txt
rm practice/cli/renamed.txt
```

파일과 디렉터리의 권한을 설정하고 변경 전후를 비교했습니다.

```bash
chmod 644 practice/cli/hello.txt
chmod 755 practice/secure-dir
stat -c '%a %A %n' practice/cli/hello.txt practice/secure-dir
# 644 -rw-r--r-- practice/cli/hello.txt
# 755 drwxr-xr-x practice/secure-dir

chmod 600 practice/cli/hello.txt
chmod 700 practice/secure-dir
stat -c '%a %A %n' practice/cli/hello.txt practice/secure-dir
# 600 -rw------- practice/cli/hello.txt
# 700 drwx------ practice/secure-dir
```

- 절대 경로: `/home/rua02/codyssey-workstation/practice/cli/hello.txt` (파일 시스템 루트부터 시작)
- 상대 경로: `practice/cli/hello.txt` (`codyssey-workstation` 디렉터리에 있을 때의 경로)
- 권한 숫자: 읽기 `r=4`, 쓰기 `w=2`, 실행 `x=1`. 세 자리 숫자는 차례대로 소유자/그룹/기타 사용자의 권한 합계입니다.

### 5-2. Docker 설치 확인 및 컨테이너 운영

[실제 Docker 운영 로그 보기](evidence/logs/02_docker_basics.log)

```bash
docker --version
# Docker version 29.9.2, build a82e528

docker info
# Server Version: 29.9.2 (발췌)

docker run --name codyssey-hello hello-world
# Hello from Docker!

docker images
docker ps
docker ps -a
docker logs codyssey-hello
```

Ubuntu 컨테이너를 실행하고 내부에 진입했습니다.

```bash
docker run -it --name codyssey-ubuntu ubuntu:24.04 bash
pwd
ls /
echo "Hello from Ubuntu Container"
cat /etc/os-release
exit

docker start -ai codyssey-ubuntu
# 재시작한 컨테이너에 연결
```

실행 중인 컨테이너에는 `docker exec`로 명령을 전달했습니다.

```bash
docker run -d --name codyssey-worker ubuntu:24.04 sleep infinity
docker exec codyssey-worker echo "Docker Exec Success"
# Docker Exec Success

docker stats --no-stream codyssey-worker
# CPU 0.00%, 메모리 1.559MiB / 7.445GiB (실습 당시)

docker stop codyssey-worker
docker ps -a
docker start codyssey-worker
docker ps
# 컨테이너가 다시 Up 상태임을 확인
```

**동작 차이:** 컨테이너에서 `exit`하면 실행 중인 주 프로세스가 종료될 수 있습니다. `docker start -ai`는 기존 컨테이너의 입출력에 연결하고, `docker exec`는 이미 실행 중인 컨테이너에서 별도 명령을 수행합니다.

### 5-3. Dockerfile 기반 커스텀 이미지와 포트 매핑

- 베이스 이미지: `nginx:alpine`
- 커스텀 포인트: 이미지 제목을 나타내는 `LABEL`, 직접 작성한 정적 웹페이지를 복사하는 `COPY`, 서비스 포트를 문서화하는 `EXPOSE 80`
- 작성 파일: [Dockerfile](Dockerfile), [site/index.html](site/index.html)
- [실제 웹 서버 빌드 및 실행 로그](evidence/logs/03_web_server.log)

```dockerfile
FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey-workstation"
COPY site/ /usr/share/nginx/html/
EXPOSE 80
```

```bash
docker build -t codyssey-web:1.0 .
# Building ... FINISHED

docker run -d --name codyssey-web-8080 -p 127.0.0.1:8080:80 codyssey-web:1.0
docker ps
# 127.0.0.1:8080->80/tcp  codyssey-web-8080

curl http://127.0.0.1:8080/
# <title>CODYSSEY Workstation</title> 등의 HTML 응답
```

![8080 포트 매핑 웹페이지 접속 성공](evidence/screenshots/port-8080.png)

**포트 매핑을 쓰는 이유:** 컨테이너 내부에서만 열려 있는 80번 포트의 서비스를 호스트의 8080번 포트로 전달해 브라우저에서 접근하기 위해서입니다. 여기서는 보안을 고려해 `127.0.0.1`에만 연결했습니다.

### 5-4. 바인드 마운트 변경 반영

[실제 바인드 마운트 로그](evidence/logs/04_bind_mount.log)

```bash
mkdir -p practice/bind-site
echo "BIND_MOUNT_BEFORE" > practice/bind-site/change.txt

docker run -d \
  --name codyssey-bind-8081 \
  -p 127.0.0.1:8081:80 \
  --mount "type=bind,source=$(pwd)/practice/bind-site,target=/usr/share/nginx/html,readonly" \
  codyssey-web:1.0

curl http://127.0.0.1:8081/change.txt
# BIND_MOUNT_BEFORE

echo "BIND_MOUNT_AFTER" > practice/bind-site/change.txt
curl http://127.0.0.1:8081/change.txt
# BIND_MOUNT_AFTER
```

컨테이너를 다시 빌드하거나 재시작하지 않고도 웹 서버가 수정된 호스트 파일의 내용을 제공했습니다.

![8081 포트 바인드 마운트 변경 후 접속 화면](evidence/screenshots/port-8081.png)

### 5-5. Docker 볼륨 영속성

[실제 Docker 볼륨 로그](evidence/logs/05_volume.log)

```bash
docker volume create codyssey-volume-data
docker volume ls
# local     codyssey-volume-data

docker run -d --name codyssey-volume-before --mount source=codyssey-volume-data,target=/data ubuntu:24.04 sleep infinity
docker exec codyssey-volume-before sh -c 'echo "DATA_SURVIVED" > /data/result.txt'
docker exec codyssey-volume-before cat /data/result.txt
# DATA_SURVIVED

docker rm -f codyssey-volume-before

docker run -d --name codyssey-volume-after --mount source=codyssey-volume-data,target=/data ubuntu:24.04 sleep infinity
docker exec codyssey-volume-after cat /data/result.txt
# DATA_SURVIVED

docker volume ls
# local     codyssey-volume-data
```

컨테이너 `codyssey-volume-before`를 삭제한 뒤 새 컨테이너 `codyssey-volume-after`를 같은 볼륨에 연결해 파일이 보존됨을 확인했습니다. **컨테이너의 수명과 볼륨 데이터의 수명은 별개**라는 것을 검증했습니다.

## 6. 트러블슈팅 (실제 수행 기록 기반)

### 사례 A — 터미널 출력 문구를 명령어로 잘못 입력

- **문제:** `BIND_MOUNT_BEFORE: command not found` 오류 발생
- **원인 가설:** `curl` 출력 결과인 `BIND_MOUNT_BEFORE`를 명령 프롬프트에 다시 입력했기 때문
- **확인:** [바인드 마운트 로그](evidence/logs/04_bind_mount.log)에 오류와 이후 실행 과정이 연속해서 기록됨
- **해결:** 출력 문구는 명령이 아니므로 별도로 실행하지 않고, 실제 명령인 `echo "BIND_MOUNT_AFTER" > practice/bind-site/change.txt` 및 `curl http://127.0.0.1:8081/change.txt`를 실행
- **결과:** `BIND_MOUNT_AFTER` 정상 출력

### 사례 B — 컨테이너 중지 후 `Exited (137)` 표시

- **문제:** `docker stop codyssey-worker` 후 상태를 확인했을 때 `Exited (137)` 관찰
- **원인 가설:** 종료 과정에서 주 프로세스가 SIGKILL로 종료된 상황. 중지 제한시간 초과 가능성 등이 있으나 **정확한 원인은 이 로그만으로 확정할 수 없음**
- **확인:** [Docker 운영 로그](evidence/logs/02_docker_basics.log)의 `docker ps -a` 상태 출력
- **해결·대안:** `docker start codyssey-worker`로 재시작한 뒤 `docker ps`에서 `Up` 확인. 원인 분석이 필요한 환경에서는 `docker inspect`, 종료 시그널 및 시간 제한도 추가 점검
- **결과:** 재시작 후 정상 실행 상태 확인. 종료 코드 발생 원인 규명 자체는 미완료

## 7. Git/GitHub 연동 및 제출 상태

로컬에서 확인된 Git 설정:

```bash
git --version
# git version 2.53.0

git config --global init.defaultBranch main
git config --global --list
# user.name=RUA
# user.email=[REDACTED]
# init.defaultbranch=main
```

**현재 상태:** Git 사용자 정보와 기본 브랜치 설정을 완료했고, 프로젝트 폴더에서 `git init -b main`을 실행하여 로컬 Git 저장소를 초기화했습니다. `git status`에서 `On branch main`, `No commits yet` 및 미추적 파일을 확인했습니다. **아직 첫 커밋, GitHub 원격 저장소 연결 및 Push, VS Code GitHub 연동 스크린샷은 완료하지 않았습니다.** 해당 작업을 수행한 뒤 증거를 추가할 예정입니다.

## 8. 평가자를 위한 재현 방법

프로젝트를 내려받은 뒤 Linux/macOS의 Bash 또는 WSL의 Ubuntu 터미널에서 다음을 실행합니다. Docker 엔진이 먼저 실행되어 있어야 하며, 호스트 포트가 이미 사용 중이라면 다른 포트를 선택합니다.

```bash
# 저장소를 내려받은 경우, 프로젝트 루트에서 실행
# 기본 웹페이지: 충돌을 피하기 위해 실습과 다른 8090 포트 사용
docker build -t codyssey-web:1.0 .
docker run --rm -d --name codyssey-review-web -p 127.0.0.1:8090:80 codyssey-web:1.0
curl http://127.0.0.1:8090/
docker stop codyssey-review-web
```

바인드 마운트 재현:

```bash
docker run --rm -d --name codyssey-review-bind \
  -p 127.0.0.1:8091:80 \
  --mount "type=bind,source=$(pwd)/practice/bind-site,target=/usr/share/nginx/html,readonly" \
  codyssey-web:1.0
curl http://127.0.0.1:8091/change.txt
echo "REVIEW_CHANGED" > practice/bind-site/change.txt
curl http://127.0.0.1:8091/change.txt
docker stop codyssey-review-bind
```

볼륨 영속성 재현 (별도 이름 사용):

```bash
docker volume create codyssey-review-data
docker run --name codyssey-review-before \
  --mount source=codyssey-review-data,target=/data ubuntu:24.04 \
  sh -c 'echo REVIEW_PERSISTED > /data/check.txt'
docker rm codyssey-review-before
docker run --rm --mount source=codyssey-review-data,target=/data \
  ubuntu:24.04 cat /data/check.txt
# REVIEW_PERSISTED
```

> 위 재현 과정은 평가자의 PC에 맞춰 포트와 볼륨 이름을 별도로 지정합니다. 바인드 마운트 재현 명령은 `practice/bind-site/change.txt`를 수정하므로 필요하면 실습 후 해당 파일을 원래 내용(`BIND_MOUNT_AFTER`)으로 복원하세요.

## 9. 보안 및 제출 전 점검

- [ ] 실제 로그에 비밀번호, 접근 토큰, SSH 개인키, 인증 코드가 포함되어 있지 않은지 확인
- [ ] Git 설정의 이메일 주소 등 공개를 원치 않는 정보 마스킹
- [ ] GitHub 원격 저장소 주소와 브랜치(`main`) 확인
- [ ] README의 모든 상대 경로 링크 및 스크린샷 렌더링 확인
- [ ] VS Code GitHub 로그인·연동 증거 추가

**GitHub 저장소 URL:** GitHub 저장소 생성 및 원격 연결 후 기재
