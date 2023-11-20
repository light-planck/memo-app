# memo-app

## 起動方法

### git clone

```bash
git clone https://github.com/light-planck/memo-app.git

cd memo-app

git checkout development
```

### セットアップ

```bash
./bin/setup.sh
```

### DBのセットアップ

DBのユーザーとしてpostgresを作成する。
なお、環境はMac OSを想定している。

```bash
brew services start postgresql  // DBの自動起動
psql -U${USER} postgres
create user postgres with SUPERUSER; // postgresユーザーの作成
```

### 起動

```bash
bundle exec ruby app.rb
```

http://localhost:4567 にアクセス

## ERB Lint

```bash
bundle exec erblint --lint-all
```
