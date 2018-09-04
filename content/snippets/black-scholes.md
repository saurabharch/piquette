---
title: "Black-Scholes-Merton Model"
description: "A quick black-scholes math exercise."
tags: ["go", "finance"]
draft: false
code_lang: "go"
---
<br>
#### Code
<br>

```go
package main

import (
	"fmt"
	"math"
)

//
// Quick demo of the classic black-scholes-merton model for
// estimating npv of european options. Model assumes that
// the underlying stock does not pay any dividends for the
// lifetime of the option.
//
// For a call, c
// c = S*N(d1) - K*e^(-r(T-t))*N(d2)
//
// For a put, p
// p = K*e^(-r(T-t))*N(-d2) - S*N(-d1)
//
// Where
// d1 = (ln(S/K) + (r + σ²/2)(T-t))/ σ√(T-t)
// And
// d2 = d1 - σ√(T-t)
//
//
const TotalTradingDays = 252.0

type EuropeanOptionParameters struct {
	UnderlierPrice    float64
	StrikePrice       float64
	Volatility        float64
	RiskFreeRate      float64
	DaysTilExpiration float64
}

func main() {

	// A european option with parameters-
	params := EuropeanOptionParameters{
		UnderlierPrice:    42.0,
		StrikePrice:       40.0,
		RiskFreeRate:      0.1,
		Volatility:        0.2,
		DaysTilExpiration: 126.0,
	}

	cv, pv := calculateNPV(params)

	// has call value of
	fmt.Println("Call Option NPV = ", cv)
	// and put value of
	fmt.Println("Put Option NPV = ", pv)

}

func calculateNPV(params EuropeanOptionParameters) (callValue float64, putValue float64) {

	d1 := (math.Log(params.UnderlierPrice/params.StrikePrice) +
		(params.RiskFreeRate+(math.Pow(params.Volatility, 2.0)/2.0))*(params.DaysTilExpiration/TotalTradingDays)) /
		(params.Volatility * math.Sqrt(params.DaysTilExpiration/TotalTradingDays))

	d2 := (math.Log(params.UnderlierPrice/params.StrikePrice) +
		(params.RiskFreeRate-(math.Pow(params.Volatility, 2.0)/2.0))*(params.DaysTilExpiration/TotalTradingDays)) /
		(params.Volatility * math.Sqrt(params.DaysTilExpiration/TotalTradingDays))

	coeff := params.StrikePrice * math.Exp(-params.RiskFreeRate*(params.DaysTilExpiration/TotalTradingDays))

	cv := params.UnderlierPrice*cdf(d1) - coeff*cdf(d2)
	pv := coeff*cdf(-d2) - params.UnderlierPrice*cdf(-d1)
	return cv, pv
}

// cdf computes the value of the cumulative density function at x.
func cdf(x float64) float64 {
	// normal distribution with Mu = 0 and Sigma = 1.
	mu := 0.0
	sigma := 1.0
	return 0.5 * (1 + math.Erf((x-mu)/(sigma*math.Sqrt2)))

}
```
