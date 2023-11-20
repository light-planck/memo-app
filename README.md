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

postgres=# create user postgres with SUPERUSER; // postgresユーザーの作成
```

DBとテーブルの作成

```bash
./bin/setup_db.sh
```

参考: <https://qiita.com/ksh-fthr/items/b86ba53f8f0bccfd7753>

### 起動

```bash
bundle exec ruby app.rb
```

http://localhost:4567 にアクセス

## ERB Lint

```bash
bundle exec erblint --lint-all
```
