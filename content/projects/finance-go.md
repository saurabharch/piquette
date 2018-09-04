---
title: "finance-go"
description: "Financial markets data packages"
tags: ["golang", "finance", "market-data", "library"]
weight: 1
draft: false
code_lang: "go"
---
<br>
[![GitHub forks](https://img.shields.io/github/forks/piquette/finance-go.svg?style=social&label=Fork)](https://github.com/piquette/finance-go)
[![GitHub stars](https://img.shields.io/github/stars/piquette/finance-go.svg?style=social&label=Stars)](https://github.com/piquette/finance-go)


[![GoDoc](http://img.shields.io/badge/godoc-reference-blue.svg)](http://godoc.org/github.com/piquette/finance-go) [![Build Status](https://travis-ci.org/piquette/finance-go.svg?branch=master)](https://travis-ci.org/piquette/finance-go) [![Coverage Status](https://coveralls.io/repos/github/piquette/finance-go/badge.svg?branch=master)](https://coveralls.io/github/piquette/finance-go?branch=master)


[![GitHub release](https://img.shields.io/github/release/piquette/finance-go.svg)](https://github.com/piquette/finance-go/releases) [![GitHub issues](https://img.shields.io/github/issues-raw/piquette/finance-go.svg)](https://github.com/piquette/finance-go/issues)



<h3 class="s-title" id="purpose">1. Purpose<a class="anchor" href="#purpose" aria-hidden="true">#</a></h3>

This go library aims to provide a go application with access to current and historical financial markets data in streamlined, well-formatted structures. Currently, the core features of this library are

* [Detailed realtime quotes across most instruments (minus fixed-income)](#quote)
* [Lists of OHLCV quotes for various time frames and aggregations](#chart)
* [Equity options series for most expirations](#options)

<br>

<h3 class="s-title"id="basics">2. Basics<a class="anchor" href="#basics" aria-hidden="true">#</a></h3>

This package is actually a composed of a collection of packages, each with a specific use case. The good news is that they all follow a similar convention and share embedded structs - with some exceptions.

For starters, the result of a request to `quote.Get(symbol string)` is a `finance.Quote` struct, which looks like this -
```go
// Quote is the basic quote structure shared across
// asset classes.
//
// Contains most fields that are common across all
// possible assets.
type Quote struct {
  // Quote classifying fields.
  Symbol      string
  MarketState MarketState
  QuoteType   QuoteType
  ShortName   string

  // Regular session quote data.
  RegularMarketChangePercent float64
  RegularMarketPreviousClose float64
  RegularMarketPrice         float64
  RegularMarketTime          int
  RegularMarketChange        float64
  RegularMarketOpen          float64
  RegularMarketDayHigh       float64
  RegularMarketDayLow        float64
  RegularMarketVolume        int

  // Quote depth.
  Bid     float64
  Ask     float64
  BidSize int
  AskSize int

  // Pre-market quote data.
  PreMarketPrice         float64
  PreMarketChange        float64
  PreMarketChangePercent float64
  PreMarketTime          int

  // Post-market quote data.
  PostMarketPrice         float64
  PostMarketChange        float64
  PostMarketChangePercent float64
  PostMarketTime          int

  // 52wk ranges.
  FiftyTwoWeekLowChange         float64
  FiftyTwoWeekLowChangePercent  float64
  FiftyTwoWeekHighChange        float64
  FiftyTwoWeekHighChangePercent float64
  FiftyTwoWeekLow               float64
  FiftyTwoWeekHigh              float64

  // Averages.
  FiftyDayAverage                   float64
  FiftyDayAverageChange             float64
  FiftyDayAverageChangePercent      float64
  TwoHundredDayAverage              float64
  TwoHundredDayAverageChange        float64
  TwoHundredDayAverageChangePercent float64

  // Volume metrics.
  AverageDailyVolume3Month int
  AverageDailyVolume10Day  int

  // Quote meta-data.
  QuoteSource               string
  CurrencyID                string
  IsTradeable               bool
  QuoteDelay                int
  FullExchangeName          string
  SourceInterval            int
  ExchangeTimezoneName      string
  ExchangeTimezoneShortName string
  GMTOffSetMilliseconds     int
  MarketID                  string
  ExchangeID                string
}
```

The function `quote.Get(symbol string)` does not care what asset class the symbol requested belongs to - it will always return a `finance.Quote` struct with as many of the member fields populated as it could find.

To get more specific, if you know your symbol is an equity, you can request a result with more information specific to an equity. For example, `equity.Get(symbol string)` will return the `finance.Equity` struct -

```go
// Equity represents a single equity quote.
type Equity struct {
  Quote
  // Equity-only fields.
  LongName                    string  
  EpsTrailingTwelveMonths     float64
  EpsForward                  float64
  EarningsTimestamp           int     
  EarningsTimestampStart      int     
  EarningsTimestampEnd        int     
  TrailingAnnualDividendRate  float64
  DividendDate                int     
  TrailingAnnualDividendYield float64
  TrailingPE                  float64
  ForwardPE                   float64
  BookValue                   float64
  PriceToBook                 float64
  SharesOutstanding           int     
  MarketCap                   int64   
}
```
This struct has all the access to the fields in the embedded `finance.Quote` struct, and additional fields pertaining to equities.

The same convention is used across all the following packages. For a more detailed quote, use the package that corresponds to the asset class of which your requested symbol belongs.

* [quote](#quote)
* [equity](#equity)
* [etf](#etf)
* [mutualfund](#mutualfund)
* [option](#option)
* [forex](#forex)
* [future](#future)
* [crypto](#crypto)
* [index](#index)

<br>

<h3 class="s-title"id="implementation">3. Implementation<a class="anchor" href="#implementation" aria-hidden="true">#</a></h3>

The following are explanations and examples of all the production-ready finance-go packages. You can selectively implement one - or all - to meet your application's needs.


<h4 class="s-title" id="quote"><i class="fas fa-folder"></i> quote<a class="anchor" href="#quote" aria-hidden="true">#</a></h4>

Provides access to a realtime quote for any financial asset.

##### Result

```go
// Quote is the basic quote structure shared across
// asset classes.
//
// Contains most fields that are common across all
// possible assets.
type Quote struct {
  // Quote classifying fields.
  Symbol      string
  MarketState MarketState
  QuoteType   QuoteType
  ShortName   string

  // Regular session quote data.
  RegularMarketChangePercent float64
  RegularMarketPreviousClose float64
  RegularMarketPrice         float64
  RegularMarketTime          int
  RegularMarketChange        float64
  RegularMarketOpen          float64
  RegularMarketDayHigh       float64
  RegularMarketDayLow        float64
  RegularMarketVolume        int

  // Quote depth.
  Bid     float64
  Ask     float64
  BidSize int
  AskSize int

  // Pre-market quote data.
  PreMarketPrice         float64
  PreMarketChange        float64
  PreMarketChangePercent float64
  PreMarketTime          int

  // Post-market quote data.
  PostMarketPrice         float64
  PostMarketChange        float64
  PostMarketChangePercent float64
  PostMarketTime          int

  // 52wk ranges.
  FiftyTwoWeekLowChange         float64
  FiftyTwoWeekLowChangePercent  float64
  FiftyTwoWeekHighChange        float64
  FiftyTwoWeekHighChangePercent float64
  FiftyTwoWeekLow               float64
  FiftyTwoWeekHigh              float64

  // Averages.
  FiftyDayAverage                   float64
  FiftyDayAverageChange             float64
  FiftyDayAverageChangePercent      float64
  TwoHundredDayAverage              float64
  TwoHundredDayAverageChange        float64
  TwoHundredDayAverageChangePercent float64

  // Volume metrics.
  AverageDailyVolume3Month int
  AverageDailyVolume10Day  int

  // Quote meta-data.
  QuoteSource               string
  CurrencyID                string
  IsTradeable               bool
  QuoteDelay                int
  FullExchangeName          string
  SourceInterval            int
  ExchangeTimezoneName      string
  ExchangeTimezoneShortName string
  GMTOffSetMilliseconds     int
  MarketID                  string
  ExchangeID                string
}
```

##### Methods

* `func Get(symbol string) (*finance.Quote, error)` - single quote
* `func List(symbols []string) *Iter` - multiple quotes
* `func ListP(params *Params) *Iter` - granular control over request execution

##### Example

```go
// A single quote.
// ---------------
q, err := quote.Get("AAPL")
if err != nil {
  // Uh-oh!
  panic(err)
}
// All good.
fmt.Println(q)


// Multiple quotes.
// ----------------
symbols := []string{"AAPL", "GOOG", "MSFT"}
iter := quote.List(symbols)

// Iterate over results. Will exit upon any error.
for iter.Next() {
  q := iter.Quote()
  fmt.Println(q)
}

// Catch an error, if there was one.
if iter.Err() != nil {
  // Uh-oh!
  panic(err)
}
```

<h4 class="s-title" id="equity"><i class="fas fa-folder"></i> equity<a class="anchor" href="#equity" aria-hidden="true">#</a></h4>

Provides access to a realtime quote for an equity.

##### Result

```go
// Equity represents a single equity quote.
type Equity struct {
  Quote
  // Equity-only fields.
  LongName                    string  
  EpsTrailingTwelveMonths     float64
  EpsForward                  float64
  EarningsTimestamp           int     
  EarningsTimestampStart      int     
  EarningsTimestampEnd        int     
  TrailingAnnualDividendRate  float64
  DividendDate                int     
  TrailingAnnualDividendYield float64
  TrailingPE                  float64
  ForwardPE                   float64
  BookValue                   float64
  PriceToBook                 float64
  SharesOutstanding           int     
  MarketCap                   int64   
}
```

##### Methods

* `func Get(symbol string) (*finance.Equity, error)` - single equity
* `func List(symbols []string) *Iter` - multiple equities
* `func ListP(params *Params) *Iter` - granular control over request execution

##### Example

```go
// A single quote.
// ---------------
q, err := equity.Get("AAPL")
if err != nil {
  // Uh-oh!
  panic(err)
}
// All good.
fmt.Println(q)


// Multiple quotes.
// ----------------
symbols := []string{"AAPL", "GOOG", "MSFT"}
iter := equity.List(symbols)

// Iterate over results. Will exit upon any error.
for iter.Next() {
  q := iter.Equity()
  fmt.Println(q)
}

// Catch an error, if there was one.
if iter.Err() != nil {
  // Uh-oh!
  panic(err)
}
```

<h4 class="s-title" id="etf"><i class="fas fa-folder"></i> etf<a class="anchor" href="#etf" aria-hidden="true">#</a></h4>

Provides access to a realtime quote for an etf.

##### Result

```go
// ETF represents a single etf quote.
type ETF struct {
  Quote
  // MutualFund/ETF-only fields.
  YTDReturn                    float64
  TrailingThreeMonthReturns    float64
  TrailingThreeMonthNavReturns float64
}
```

##### Methods

* `func Get(symbol string) (*finance.ETF, error)` - single etf
* `func List(symbols []string) *Iter` - multiple etfs
* `func ListP(params *Params) *Iter` - granular control over request execution

##### Example

```go
// A single quote.
// ---------------
q, err := etf.Get("SPY")
if err != nil {
  // Uh-oh!
  panic(err)
}
// All good.
fmt.Println(q)


// Multiple quotes.
// ----------------
symbols := []string{"SPY", "QQQ", "DIA"}
iter := etf.List(symbols)

// Iterate over results. Will exit upon any error.
for iter.Next() {
  q := iter.ETF()
  fmt.Println(q)
}

// Catch an error, if there was one.
if iter.Err() != nil {
  // Uh-oh!
  panic(err)
}
```

<h4 class="s-title" id="mutualfund"><i class="fas fa-folder"></i> mutualfund<a class="anchor" href="#mutualfund" aria-hidden="true">#</a></h4>

Provides access to a quote for a mutual fund.

##### Result

```go
// MutualFund represents a single mutual fund share quote.
type MutualFund struct {
  Quote
  // MutualFund/ETF-only fields.
  YTDReturn                    float64
  TrailingThreeMonthReturns    float64
  TrailingThreeMonthNavReturns float64
}
```

##### Methods

* `func Get(symbol string) (*finance.MutualFund, error)` - single mutual fund
* `func List(symbols []string) *Iter` - multiple mutual funds
* `func ListP(params *Params) *Iter` - granular control over request execution

##### Example

```go
// A single quote.
// ---------------
q, err := mutualfund.Get("FMAGX")
if err != nil {
  // Uh-oh!
  panic(err)
}
// All good.
fmt.Println(q)


// Multiple quotes.
// ----------------
symbols := []string{"FMAGX", "FSPTX"}
iter := mutualfund.List(symbols)

// Iterate over results. Will exit upon any error.
for iter.Next() {
  q := iter.MutualFund()
  fmt.Println(q)
}

// Catch an error, if there was one.
if iter.Err() != nil {
  // Uh-oh!
  panic(err)
}
```

<h4 class="s-title" id="option"><i class="fas fa-folder"></i> option<a class="anchor" href="#option" aria-hidden="true">#</a></h4>

Provides access to a quote for a single option contract.

##### Result

```go
// Option represents a single option contract quote
// for a specified strike and expiration.
type Option struct {
  Quote
  // Options/Futures-only fields.
  UnderlyingSymbol         string
  OpenInterest             int
  ExpireDate               int
  Strike                   float64
  UnderlyingExchangeSymbol string
}
```

##### Methods

* `func Get(symbol string) (*finance.Option, error)` - single contract
* `func List(symbols []string) *Iter` - multiple contracts
* `func ListP(params *Params) *Iter` - granular control over request execution

##### Example

```go
// A single quote.
// ---------------
q, err := option.Get("AMD180907C00011000")
if err != nil {
  // Uh-oh!
  panic(err)
}
// All good.
fmt.Println(q)


// Multiple quotes.
// ----------------
symbols := []string{"AMD180907C00011000", "AMD180907C00011500"}
iter := option.List(symbols)

// Iterate over results. Will exit upon any error.
for iter.Next() {
  q := iter.Option()
  fmt.Println(q)
}

// Catch an error, if there was one.
if iter.Err() != nil {
  // Uh-oh!
  panic(err)
}
```

<h4 class="s-title" id="forex"><i class="fas fa-folder"></i> forex<a class="anchor" href="#forex" aria-hidden="true">#</a></h4>

Provides access to a quote for a forex pair.

##### Result

```go
// ForexPair represents a single forex currency pair quote.
type ForexPair struct {
  // Not much here...
  Quote
}
```

##### Methods

* `func Get(symbol string) (*finance.ForexPair, error)` - single quote
* `func List(symbols []string) *Iter` - multiple quotes
* `func ListP(params *Params) *Iter` - granular control over request execution

##### Example

```go
// A single quote.
// ---------------
q, err := forex.Get("EURUSD=X")
if err != nil {
  // Uh-oh!
  panic(err)
}
// All good.
fmt.Println(q)


// Multiple quotes.
// ----------------
symbols := []string{"EURUSD=X", "NZDUSD=X"}
iter := forex.List(symbols)

// Iterate over results. Will exit upon any error.
for iter.Next() {
  q := iter.ForexPair()
  fmt.Println(q)
}

// Catch an error, if there was one.
if iter.Err() != nil {
  // Uh-oh!
  panic(err)
}
```

<h4 class="s-title" id="future"><i class="fas fa-folder"></i> future<a class="anchor" href="#future" aria-hidden="true">#</a></h4>

Provides access to a quote for a future contract.

##### Result

```go
// Future represents a single futures contract quote
// for a specified strike and expiration.
type Future struct {
  Quote
  // Options/Futures-only fields.
  UnderlyingSymbol         string
  OpenInterest             int
  ExpireDate               int
  Strike                   float64
  UnderlyingExchangeSymbol string
  HeadSymbolAsString       string
  IsContractSymbol         bool
}
```

##### Methods

* `func Get(symbol string) (*finance.Future, error)` - single future contract
* `func List(symbols []string) *Iter` - multiple contracts
* `func ListP(params *Params) *Iter` - granular control over request execution

##### Example

```go
// A single quote.
// ---------------
q, err := future.Get("CL=F")
if err != nil {
  // Uh-oh!
  panic(err)
}
// All good.
fmt.Println(q)


// Multiple quotes.
// ----------------
symbols := []string{"CL=F", "GC=F"}
iter := future.List(symbols)

// Iterate over results. Will exit upon any error.
for iter.Next() {
  q := iter.Future()
  fmt.Println(q)
}

// Catch an error, if there was one.
if iter.Err() != nil {
  // Uh-oh!
  panic(err)
}
```

<h4 class="s-title" id="crypto"><i class="fas fa-folder"></i> crypto<a class="anchor" href="#crypto" aria-hidden="true">#</a></h4>

Provides access to a quote for a cryptocurrency pair.

##### Result

```go
// CryptoPair represents a single crypto currency pair quote.
type CryptoPair struct {
  Quote
  // Cryptocurrency-only fields.
  Algorithm           string
  StartDate           int
  MaxSupply           int
  CirculatingSupply   int
  VolumeLastDay       int
  VolumeAllCurrencies int
}
```

##### Methods

* `func Get(symbol string) (*finance.CryptoPair, error)` - single crypto pair
* `func List(symbols []string) *Iter` - multiple pairs
* `func ListP(params *Params) *Iter` - granular control over request execution

##### Example

```go
// A single quote.
// ---------------
q, err := crypto.Get("BTC-USD")
if err != nil {
  // Uh-oh!
  panic(err)
}
// All good.
fmt.Println(q)


// Multiple quotes.
// ----------------
symbols := []string{"BTC-USD", "XRP-USD"}
iter := crypto.List(symbols)

// Iterate over results. Will exit upon any error.
for iter.Next() {
  q := iter.CryptoPair()
  fmt.Println(q)
}

// Catch an error, if there was one.
if iter.Err() != nil {
  // Uh-oh!
  panic(err)
}
```

<h4 class="s-title" id="index"><i class="fas fa-folder"></i> index<a class="anchor" href="#index" aria-hidden="true">#</a></h4>

Provides access to an up-to-date measure of a market index.

##### Result

```go
// Index represents a single market Index quote.
// The term `quote` here doesn't really apply in
// a practical sense, as indicies themselves are
// by definition not tradable assets.
type Index struct {
  Quote
}
```

##### Methods

* `func Get(symbol string) (*finance.Index, error)` - single index
* `func List(symbols []string) *Iter` - multiple indicies
* `func ListP(params *Params) *Iter` - granular control over request execution

##### Example

```go
// A single index.
// ---------------
q, err := index.Get("^GSPC")
if err != nil {
  // Uh-oh!
  panic(err)
}
// All good.
fmt.Println(q)


// Multiple indicies.
// ----------------
symbols := []string{"^GSPC", "^DJI"}
iter := index.List(symbols)

// Iterate over results. Will exit upon any error.
for iter.Next() {
  q := iter.Index()
  fmt.Println(q)
}

// Catch an error, if there was one.
if iter.Err() != nil {
  // Uh-oh!
  panic(err)
}
```

<h4 class="s-title" id="chart"><i class="fas fa-folder"></i> chart<a class="anchor" href="#chart" aria-hidden="true">#</a></h4>

Provides access to a time-series of OHLCV quotes.

##### Result

```go
// Iter is a structure containing results
// and related metadata for a
// yfin chart request.
type Iter struct {
  *iter.Iter
}
```

##### Methods

* `func Get(params *Params) *Iter` - iterator of historical quotes

Where `chart.Params` is

```go
// Params carries a context and chart information.
type Params struct {
  // Context access.
  finance.Params
  // Accessible fields.
  Symbol   string // requested symbol
  Start    *datetime.Datetime // start of the time period
  End      *datetime.Datetime // end of the time period
  Interval datetime.Interval // per-bar aggregation
  IncludeExt bool // include extended-hours
}
```

##### Example

```go
// Historical quotes for AAPL
// ----------------
p := &chart.Params{
  Symbol:   "AAPL",
  Start:    &datetime.Datetime{Month: 1, Day: 1, Year: 2017},
  End:      &datetime.Datetime{Month: 1, Day: 1, Year: 2018},
  Interval: datetime.OneDay
}
iter := chart.Get(p)

// Iterate over results. Will exit upon any error.
for iter.Next() {
  b := iter.Bar()
  fmt.Println(b)

  // Meta-data for the iterator - (*finance.ChartMeta).
  fmt.Println(iter.Meta())
}

// Catch an error, if there was one.
if iter.Err() != nil {
  // Uh-oh!
  panic(err)
}
```

<h4 class="s-title" id="options"><i class="fas fa-folder"></i> options<a class="anchor" href="#options" aria-hidden="true">#</a></h4>

Provides access to a matrix of equity options for various time frames.

##### Results

```go
// OptionsMeta is meta data associated with an options response.
type OptionsMeta struct {
  UnderlyingSymbol   string
  ExpirationDate     int
  AllExpirationDates []int
  Strikes            []float64
  HasMiniOptions     bool
  Quote              *Quote
}

// Straddle is a put/call straddle for a particular strike.
type Straddle struct {
  Strike float64  
  Call   *Contract
  Put    *Contract
}

// Contract is a struct containing a single option contract, usually part of a chain.
type Contract struct {
  Symbol            string
  Strike            float64
  Currency          string
  LastPrice         float64
  Change            float64
  PercentChange     float64
  Volume            int
  OpenInterest      int
  Bid               float64
  Ask               float64
  Size              string
  Expiration        int
  LastTradeDate     int
  ImpliedVolatility float64
  InTheMoney        bool
}
```

##### Methods

* `func GetStraddle(underlier string) *StraddleIter` - iterator of options straddles for the front month
* `func GetStraddleP(params *Params) *StraddleIter` - iterator of options straddles for an expiration


Where `options.Params` is

```go
// Params carries a context and options information.
type Params struct {
  // Context access.
  finance.Params
  // Accessible fields.
  UnderlyingSymbol string             
  Expiration *datetime.Datetime
}
```

##### Example

```go
// Options for AAPL
// ----------------
iter := options.GetStraddle("AAPL")

// Iterate over results. Will exit upon any error.
for iter.Next() {
  s := iter.Straddle()
  fmt.Println(s)

  // Meta-data for the iterator - (*finance.OptionsMeta).
  fmt.Println(iter.Meta())
}

// Catch an error, if there was one.
if iter.Err() != nil {
  // Uh-oh!
  panic(err)
}
```
