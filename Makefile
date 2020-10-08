.PHONY: build
build:
	GOOS=linux GOARCH=amd64 go build -o game/tictactoe ./game

.PHONY :install
install:
	go get ./...
