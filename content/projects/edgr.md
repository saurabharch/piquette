---
title: "edgr"
description: "SEC EDGAR data cli tool"
tags: ["text-analysis", "cli", "postgres", "golang"]
weight: 1
draft: false
code_lang: "go"
---

<br>
[![Go Report Card](https://goreportcard.com/badge/github.com/piquette/edgr)](https://goreportcard.com/badge/github.com/piquette/edgr)
[![Build Status](https://travis-ci.org/piquette/edgr.svg?branch=master)](https://travis-ci.org/piquette/edgr)
[![GoDoc](https://godoc.org/github.com/piquette/edgr?status.svg)](https://godoc.org/github.com/piquette/edgr)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

<br>
A cli tool that can populate a postgres db with SEC filings for use in data analysis projects, `edgr` is a cli tool that aims to make working with SEC filings not terrible

<br>
### Commands
These commands in a normal workflow should be run in the order found in this list. Please note an a running postgres database must be available for any of these commands to execute properly. The current available commands are:

* `init` - initializes the db tables needed for the edgr tool
* `filers` - downloads and persists entities that file with the SEC
* `get` - downloads and persists SEC filings

<br>
### Installation
In order to use this awesome tool, you'll need to get it on your machine!

#### From Homebrew
If you're on macOS, the easiest way to get edgr is through the homebrew tap.

```sh
brew tap piquette/edgr
brew install edgr
```

#### From Release
1. Head over to the official [releases page](https://github.com/piquette/edgr/releases)
2. Determine the appropriate distribution for your operating system (mac | windows | linux)
3. Download and untar the distribution. Shortcut for macs:

```sh
curl -sL https://github.com/piquette/edgr/releases/download/v0.0.1/edgr_0.0.1_darwin_amd64.tar.gz | tar zx
```

4. Move the binary into your local `$PATH`.
5. Run `edgr help`.

#### From Source
`edgr` is built in Go, with v1.13+ preferred. Clone the source repo, like this:

```
git clone https://github.com/piquette/edgr.git
```

Then run:

```
go mod download 
make build
```

<br>
### Usage
Run the command `edgr help` in your shell for the list of possible commands and flags.

Running the root `edgr` will print the following:

```
NAME:
   edgr - Retrieve and store SEC filings for corporations

USAGE:
   edgr [global flags] COMMAND [command flags]

VERSION:
   0.0.1

COMMANDS:
   filers   Manage the universe of entities that file with the SEC
   get      Retrieves and stores SEC filings
   init     Initializes a postgres database that can store SEC data
   help, h  Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --pg-addr value  PostgreSQL ~address~ (default: "localhost:5432") [$PG_ADDR] [EDGRFILE]
   --pg-db value    PostgreSQL ~database~ (default: "postgres") [$PG_DB] [EDGRFILE]
   --pg-pass value  PostgreSQL ~password~ (default: "postgres") [$PG_PASS] [EDGRFILE]
   --pg-user value  PostgreSQL ~username~ (default: "postgres") [$PG_USER] [EDGRFILE]
   --help, -h       show help
   --version, -v    print the version
```


[releases]: https://github.com/piquette/edgr/releases
