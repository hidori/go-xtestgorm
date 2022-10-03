.PHONY: tool/install

# ツールをインストールします。
tool/install:
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	go install github.com/masakurapa/gover-html@latest

.PHONY: mod/download mod/tidy

# 依存関係パッケージをダウンロードします。
mod/download:
	go mod download

# 依存関係パッケージの参照を整理します。
mod/tidy:
	go mod tidy

.PHONY: lint test cover

# ソースコードの書式を検査します。
lint:
	golangci-lint -v run `find . -type f -and -name '*.go' | xargs dirname | grep '^\.$$' | sort | uniq | grep -v '^\.$$'`

# 単体テストを実行します。
test:
	-rm -r ./reports
	mkdir -p ./reports
	go test -v -shuffle=on -coverprofile=./reports/coverage.out -cover ./...

# カバレッジレポートを作成します。
cover: test
	gover-html -i ./reports/coverage.out -o ./reports/coverage.html
