library(PortfolioAnalytics)
library(PerformanceAnalytics)
library(DEoptim)
library(foreach)
library(iterators)
library(doParallel)
library(quantmod)

#symbol list stolen from deoptim vignette with some non yahoo symbols dropped

tickers = c( "VNO" , "VMC") # two tickers for simpler debugging

getSymbols(tickers,from="2000-12-01", to = "2013-05-01")


## Make matrix of Returns code stolen from vignette of deoptim
P<- NULL
seltickers<-NULL
for(ticker in tickers){
  tmp = Cl(to.monthly(eval(parse(text=ticker))))
  if(is.null(P)){
      timeP=time(tmp)
  }
  if(any(time(tmp)!=timeP)) {
      next
  }
  else {
      P = cbind(P,as.numeric(tmp))
  }
  seltickers = c(seltickers,ticker)
}
P = xts(P,order.by=timeP)
colnames(P) = seltickers
R = diff(log(P))
R = R[-1,]

#### Functions to use in backtest

#taken from peterson's 2012 r/finance seminar
pasd <- function(R, weights){
  as.numeric(StdDev(R=R, weights=weights)*sqrt(12)) # hardcoded for monthly data
  #    as.numeric(StdDev(R=R, weights=weights)*sqrt(4)) # hardcoded for quarterly data
}

###### Calculate min variance portfolio

GMVconst = constraint(assets=colnames(R),
                      min=rep(0.001,
                      ncol(R)),
                      max=rep(0.05,ncol(R)),
                      min_sum=0.98,
                      max_sum=1.02,
                      risk_aversion=1, 
                      weight_seq=seq(.0001,.05,by=.0001)
            )

GMVconst = add.objective(GMVconst,
                         type="risk",
                         name ="pasd",
                         enabled=TRUE,
                         multiplier=0,
                         risk_aversion=1
                         )

# without rebalancing, for speed.
GMVPortfolio <- optimize.portfolio(R, constraints=GMVconst,
                                               optimize_method="random", 
                                               trace=TRUE, 
                                               rebalance_on='months', 
                                               trailing_periods=NULL, 
                                               training_period=36,
                                               search_size=2000,
                                               verbose=FALSE,
                                               parallel=TRUE)

#GMVPortfolio <- optimize.portfolio.rebalancing(R, constraints=GMVconst,
 #                                              optimize_method="random", 
 #                                              trace=TRUE, 
 #                                              rebalance_on='months', 
 #                                              trailing_periods=NULL, 
 #                                              training_period=36,
 #                                              search_size=2000,
 #                                              verbose=FALSE,
 #                                              parallel=TRUE)
Return.rebalancing(R,extractWeights.rebal(GMVPortfolio)) # print results
summary(GMVPortfolio)
