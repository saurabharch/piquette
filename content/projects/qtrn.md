---
title: "qtrn"
description: "Command-line tool for displaying quotes, charts, and writing csv files"
repo: "#" # delete this line if you want blog-like posts for projects
tags: ["golang", "cli"]
weight: 2
draft: false
code_lang: "go"
---
<br>
[![Go Report Card](https://goreportcard.com/badge/github.com/piquette/qtrn)](https://goreportcard.com/badge/github.com/piquette/qtrn)
[![Build Status](https://travis-ci.org/piquette/qtrn.svg?branch=master)](https://travis-ci.org/piquette/qtrn)
[![GoDoc](https://godoc.org/github.com/piquette/qtrn?status.svg)](https://godoc.org/github.com/piquette/qtrn)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The official cli tool for making financial markets analysis as fast as you are.

Pronounced "quote-tron" as a throwback to those awesome financial terminals of the 80's. This project is intended as a living example of the capabilities of the [finance-go] library.

<br>
### Commands
The current available commands are:

* `quote` - prints tables of quotes to the current shell
* `chart` - prints sparkline chart to the current shell
* `options` - prints tables of options contract quotes to the current shell
* `write` - writes tables of quotes/history to csv files

<br>
### Installation
In order to use this awesome tool, you'll need to get it on your machine!

#### From Homebrew
If you're on macOS, the easiest way to get qtrn is through the homebrew tap.

```sh
brew tap piquette/qtrn
brew install qtrn
```

#### From Release
1. Head over to the official [releases page](https://github.com/piquette/qtrn/releases)
2. Determine the appropriate distribution for your operating system (mac | windows | linux)
3. Download and untar the distribution. Shortcut for macs:

```sh
curl -sL https://github.com/piquette/qtrn/releases/download/v0.0.8/qtrn_0.0.8_darwin_amd64.tar.gz | tar zx
```

4. Move the binary into your local `$PATH`.
5. Run `qtrn help`.

#### From Source
`qtrn` is built in Go, with v1.13+ preferred. Clone the source repo, like this:

```
git clone https://github.com/piquette/qtrn.git
```

Then run:

```
go mod download 
make build
```

<br>
### Usage
Run the command `qtrn` in your shell for the list of possible commands.

[releases]: https://github.com/piquette/qtrn/releases
[finance-go]: https://github.com/piquette/finance-go
