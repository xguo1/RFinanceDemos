\name{instrument_attr}
\alias{instrument_attr}
\title{Add or change an attribute of an instrument}
\usage{
  instrument_attr(primary_id, attr, value, ...)
}
\arguments{
  \item{primary_id}{primary_id of the instrument that will
  be updated}

  \item{attr}{Name of the slot that will be added or
  changed}

  \item{value}{What to assign to the \code{attr} slot of
  the \code{primary_id} instrument}

  \item{...}{arguments to pass to \code{getInstrument}. For
  example, \code{type} could be provided to allow for
  \code{primary_id} to be an identifier that is shared by
  more that one instrument (of different types)}
}
\value{
  called for side-effect
}
\description{
  This function will add or overwrite the data stored in
  the specified slot of the specified instrument.
}
\details{
  If the \code{attr} you are trying to change is the
  \dQuote{primary_id,} the instrument will be renamed. (A
  copy of the instrument will be stored by the name of
  \code{value} and the old instrument will be removed.) If
  the \code{attr} you are changing is \dQuote{type}, the
  instrument will be reclassed with that type. If
  \code{attr} is \dQuote{src}, \code{value} will be used in
  a call to \code{setSymbolLookup}.  Other checks are in
  place to make sure that \dQuote{currency} remains a
  \code{\link{currency}} object and that
  \dQuote{multiplier} and \dQuote{tick_size} can only be
  changed to reasonable values.

  If \code{attr} is \dQuote{identifiers} and \code{value}
  is \code{NULL}, \code{identifiers} will be set to
  \code{list()}.  If \code{value} is not a list,
  \code{\link{add.identifier}} will be called with
  \code{value}. \code{add.identifier} will convert
  \code{value} to a list and append it to the current
  \code{identifiers}
}
\note{
  You can remove an attribute/level from an instrument by
  calling this function with \code{value=NULL}
}
\examples{
\dontrun{
currency("USD")
stock("SPY","USD")
instrument_attr("USD","description","U.S. Dollar")
instrument_attr("SPY", "description", "An ETF")
getInstrument("USD")
getInstrument("SPY")

#Call with value=NULL to remove an attribute
instrument_attr("SPY", "description", NULL)
getInstrument("SPY")

instrument_attr("SPY","primary_id","SPX") #move/rename it
instrument_attr("SPX","type","synthetic") #re-class
instrument_attr("SPX","src",list(src='yahoo',name='^GSPC')) #setSymbolLookup
getSymbols("SPX") #knows where to look because the last line setSymbolLookup
getInstrument("SPX")
}
}

