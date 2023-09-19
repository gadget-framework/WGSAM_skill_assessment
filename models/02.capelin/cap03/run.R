library(Rgadget)
library(tidyverse)
library(grid)
library(gridExtra)

rm(list=ls())

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

tmp <- gadget.iterative(rew.sI=TRUE,
                        grouping=list(
                          sind=c('siQ1.cap','siQ3.cap')),
                        params.file='params.in',
                        optinfofile='optinfofile',
                        wgts='WGTS')

