library(mfdb)
library(tidyverse)
library(Rgadget)
library(mskeyrun)
library(gadget3)
library(gadgetutils)
library(gadgetplots)

rm(list=ls())

## Which gadget version would you like to use, 2 or 3? 
## Notes on gadget versions: 
## - data inputs and setting for both gadget versions are identical
## - differences are in the model setup, gadget2 uses text files, gadget3 uses R formulas
## - gadget3 specific scripts are suffixed with '_g3'
## - gadget2 specific scripts are suffixed with '_g2'

gadget_version <- 3

# 11 spp list with extra biological data
sppLookup <- data.frame(nobaSpp = c("BWH","CAP","GRH","HAD","LRD","MAC","NCO","PCO","RED","SAI","SSH"),
                        mfdbSpp = c("WHB","CAP","GLH","HAD","PLA","MAC","COD","POC","RED","SAI","HER"),
                        ageGrpSize = c(1,1,2,2,2,2,2,2,4,2,2),
                        ageMax = c(10,5,20,20,20,20,20,10,40,20,20),
                        minLen = c(13,3,56,12,7,14,20,10,7,25,5),
                        maxLen = c(47,23,199,129,71,65,138,35,39,196,51),
                        iniScale = c(1e5,1e5,1e2,1e3,1e4,1e4,1e3,1e4,1e4,1e4,1e4),
                        recScale = c(1e9,1e7,1e4,1e8,1e8,1e8,1e7,1e8,1e8,1e7,1e9))
sppList <- left_join(simBiolPar, sppLookup %>% rename(Code=nobaSpp))

spp <- "STK" # select species

cat('\n## --------------\n\ngadget version:', gadget_version, '\nstock:', spp)

## Create a gadget directory, define some defaults to use with our queries below
dirName <- paste0(tolower(spp),"01",ifelse(gadget_version == 3, '_g3', ''))

if (gadget_version == 2){
  system(paste("rm -r", dirName))
  if(sum(match(list.files(),dirName), na.rm=T)==1){
    print(paste("folder",dirName,"exists"))
  } else {gd <- gadget_directory(dirName)}  
}

mdb <- mfdb('Barents', db_params=list(dbname="noba"))
#mdb <- mfdb('../../mfdb/Barents.duckdb')

simName <- "NOBA_sacc_38"

year_range <- 40:120
base_dir <- tolower(spp)
stock <- tolower(spp)
stock_names <- c(stock)
species_name <- tolower(spp)

sppListi <- sppList %>% filter(mfdbSpp==spp)

# define 'default' spatial and temporal aggregation
defaults <- list(
  year = year_range,
  #area = "noba_area",
  area = "noba_area",
  timestep = mfdb_timestep_quarterly,
  species = spp,
  length=mfdb_interval("len", seq(sppListi %>% .$minLen, sppListi %>% .$maxLen, by = 1)),
  ## # CAP
  ## age=mfdb_group('age0'=0,'age1'=1,'age2'=2,'age3'=3,'age4'=4,'age5'=5)
  ## # WHB
  ## age=mfdb_group('age0'=0,'age1'=1,'age2'=2,'age3'=3,'age4'=4,'age5'=5,'age6'=6,'age7'=7,'age8'=8,'age9'=9,'age10'=10)
  ## # RED
  ## age=mfdb_group('age0'=0,'age1'=1,'age2'=2,'age3'=3,'age4'=4,'age5'=5,'age6'=6,'age7'=7,'age8'=8,'age9'=9,'age10'=10,
  ##                'age11'=11,'age12'=12,'age13'=13,'age14'=14,'age15'=15,'age16'=16,'age17'=17,'age18'=18,'age19'=19,'age20'=20,
  ##                'age21'=21,'age22'=22,'age23'=23,'age24'=24,'age25'=25,'age26'=26,'age27'=27,'age28'=28,'age29'=29,'age30'=30,
  ##                'age31'=31,'age32'=32,'age33'=33,'age34'=34,'age35'=35,'age36'=36,'age37'=37,'age38'=38,'age39'=39,'age40'=40)
  # ALL OTHERS
  age=mfdb_group('age0'=0,'age1'=1,'age2'=2,'age3'=3,'age4'=4,'age5'=5,'age6'=6,'age7'=7,'age8'=8,'age9'=9,'age10'=10,
                 'age11'=11,'age12'=12,'age13'=13,'age14'=14,'age15'=15,'age16'=16,'age17'=17,'age18'=18,'age19'=19,'age20'=20)
)

# select the relevant age grouping
## ageCls <- mfdb_group('age1'=1,'age2'=2,'age3'=3,'age4'=4) # CAP
## ageCls <- mfdb_group('age1'=1,'age2'=2,'age3'=3,'age4'=4,'age5'=5,'age6'=6,'age7'=7,'age8'=8,'age9'=9,'age10'=10) # WHB
## ageCls <- mfdb_group('age3'=1:4,'age7'=5:8,'age11'=9:12,'age15'=13:16,'age19'=17:20,'age23'=21:24,'age27'=25:28,'age31'=29:32,'age35'=33:36,'age39'=37:40) # RED
ageCls <- mfdb_group('age1'=1:2,'age3'=3:4,'age5'=5:6,'age7'=7:8,'age9'=9:10,'age11'=11:12,'age13'=13:14,'age15'=15:16,'age17'=17:18,'age19'=19:20) # ALL OTHERS


## -----------------------------------------------------------------------------
## Setup time and area gadget2 files
## -----------------------------------------------------------------------------

if (gadget_version == 2){
  
  gadgetfile('Modelfiles/time',
             file_type = 'time',
             components = list(list(firstyear = min(defaults$year),
                                    firststep=1,
                                    lastyear=max(defaults$year),
                                    laststep=4,
                                    notimesteps=c(4,3,3,3,3)))) %>% 
    write.gadget.file(gd$dir)
  
  ## Write out areafile and update mainfile with areafile location
  area <- expand.grid(year=min(defaults$year):max(defaults$year),
                      step=1:4,
                      area="noba_area",
                      mean=5)
  area <- arrange(area,year,step)
  
  # get temperature ...
  ## tmp <- read.gadget.file("~/Share/ICES/WGSAM/2019/keyrun/keyrun.10/Modelfiles/","area")[[2]]
  ## tmp <- unique(tmp[,c("year","mean")])
  ## area <- area %>%
  ##     select(-mean) %>%
  ##     left_join(tmp,by="year") %>%
  ##     mutate(mean=ifelse(is.na(mean), tmp$mean[dim(tmp)[1]], mean))
  ## rm(tmp)
  
  gadget_areafile(
    size = mfdb_area_size(mdb, defaults)[[1]],
    ## temperature = mfdb_temperature(mdb, defaults)[[1]]) %>% 
    temperature = area) %>% 
    gadget_dir_write(gd,.)
  
}else{
  
  ## -----------------------------------------------------------------------------
  ## Setup time and area gadget3 
  ## -----------------------------------------------------------------------------
  
  area_g3 <- structure(seq_along(defaults$area), names = defaults$area)
  
  # Timekeeping for the model, i.e. how long we run for
  time_actions <- list(gadget3::g3a_time(start_year = min(defaults$year),
                                         end_year = max(defaults$year),
                                         defaults$timestep),
                       list())
  
}

## -----------------------------------------------------------------------------

source('utils.R')
source('setup_model_stk.R') ## Setup model needs to happen prior to setup fleets for gadget3
source('setup_fleets_stk.R')
source('setup_catchdistribution_stk.R')
## source('setup_catchstatistic_stk.R')
source('setup_indices_stk.R')
source(paste0('setup_likelihood_stk_g', gadget_version, '.R'))

## -----------------------------------------------------------------------------
## GADGET2 RUN MODEL AND SET PARAMETERS
## -----------------------------------------------------------------------------

if (gadget_version == 2){
  
  Sys.setenv(GADGET_WORKING_DIR=normalizePath(gd$dir))
  callGadget(s=1,log = 'init.log') #ignore.stderr = FALSE,
  
  read.gadget.parameters(sprintf('%s/params.out',gd$dir)) %>% 
    init_guess(paste0(stock_names,'.rec.[0-9]'),1,0.1,100,1) %>%
    ## mutate(value = ifelse(switch == paste0(stock_names,'.rec.1'), 1e-4 * exp(init.rec$number), value),
    ##        optimise = ifelse(switch == paste0(stock_names,'.rec.1'), 0, optimise)) %>%
    ## init_guess(paste0(stock_names,'.init.[0-9]'),1,0.001,1000,1) %>%
    init_guess(paste0(stock_names,'.rec.scalar'), sppListi$recScale, 1e3, 1e9, 0) %>% 
    ## init_guess(paste0(stock_names,'.rec.scalar'), sppListi %>% .$recScale, 1, 1e7, 0) %>% 
    init_guess(paste0(stock_names,'.init.scalar'), 1e-4, 1e-5, 1e6, 0) %>%
    init_guess(paste0(stock_names,'.recl'), grw.constants["recl"], grw.constants["recl"]*0.2, grw.constants["recl"]*2, 0) %>%
    ## init_guess(paste0(stock_names,'.recl'), min(defaults$length)*2, min(defaults$length), min(defaults$length)*3,1) %>%
    init_guess(paste0(stock_names,'.rec.sd'), init.sigma$stddev[1]*0.9, init.sigma$stddev[1]*0.2, init.sigma$stddev[1]*2,0) %>%
    init_guess(paste0(stock_names,'.Linf'), grw.constants["Linf"], grw.constants["Linf"]*0.8, grw.constants["Linf"]*1.2,0) %>%
    init_guess(paste0(stock_names,'.k'), 1e2 * grw.constants["k"], 1e2 * grw.constants["k"] * 0.1, 1e2 * grw.constants["k"] * 5,1) %>%
    init_guess(paste0(stock_names,'.bbin'), 0.9, 0.01, 50, 1) %>% 
    init_guess(paste0(stock_names,'.com.alpha'), 0.9,  0.1, 3, 1) %>% 
    init_guess(paste0(stock_names,'.com.l50'), mean(as.numeric(substring(ldist.com$length,4,6))), min(as.numeric(substring(ldist.com$length,4,6))), max(as.numeric(substring(ldist.com$length,4,6))), 1) %>% 
    init_guess(paste0(stock_names,'.surQ1.alpha'), 0.9,  0.1, 2, 1) %>% 
    init_guess(paste0(stock_names,'.surQ1.l50'),  mean(as.numeric(substring(ldist.survQ1$length,4,6))), min(as.numeric(substring(ldist.survQ1$length,4,6))), max(as.numeric(substring(ldist.survQ1$length,4,6))), 1) %>% 
    init_guess(paste0(stock_names,'.surQ3.alpha'), 0.9,  0.1, 2, 1) %>% 
    init_guess(paste0(stock_names,'.surQ3.l50'), mean(as.numeric(substring(ldist.survQ3$length,4,6))), min(as.numeric(substring(ldist.survQ3$length,4,6))), max(as.numeric(substring(ldist.survQ3$length,4,6))), 1) %>%
    init_guess(paste0(stock_names,'.walpha'), lw.constants$a, lw.constants$a*0.1, lw.constants$a*10, 0) %>% 
    init_guess(paste0(stock_names,'.wbeta'), lw.constants$b, 2, 4, 0) %>% 
    init_guess(paste0(stock_names,'.M'), 0.2, 0.001, 1, 0) %>% 
    ## init_guess('had.init.F',0.3,0.1,1,0) %>%
    write.gadget.parameters(.,file=sprintf('%s/params.in',gd$dir))
  
  
  file.copy(sprintf('%s/optinfofile','./'),gd$dir)
  ## file.copy(sprintf('optinfofile','./'),gd$dir)
  
  file.copy(sprintf('%s/run.R','./'),gd$dir)
  ## file.copy(sprintf('%s/run.R','./'),gd$dir)
  
}else{
  
  ## -----------------------------------------------------------------------------
  ## GADGET3 MODEL AND PARAMETERS
  ## -----------------------------------------------------------------------------
  
  tmb_model <- gadget3::g3_to_tmb(c(stock_actions,
                                    fleet_actions,
                                    likelihood_actions,
                                    time_actions,
                                    NULL
  ))
  
  r_model <- gadget3::g3_to_r(attr(tmb_model, 'actions'))
  
  ## Set parameters, just copy values and ranges from above
  tmb_param <- 
    attr(tmb_model, 'parameter_template') %>% 
    gadgetutils::g3_init_guess(paste0(stock_names,'.rec.[0-9]'),1,0.1,100,1) %>%
    ## mutate(value = ifelse(switch == paste0(stock_names,'.rec.1'), 1e-4 * exp(init.rec$number), value),
    ##        optimise = ifelse(switch == paste0(stock_names,'.rec.1'), 0, optimise)) %>%
    ## gadgetutils::g3_init_guess(paste0(stock_names,'.init.[0-9]'),1,0.001,1000,1) %>%
    gadgetutils::g3_init_guess(paste0(stock_names,'.rec.scalar'), sppListi$recScale, 1e3, 1e9, 1) %>% 
    ## gadgetutils::g3_init_guess(paste0(stock_names,'.rec.scalar'), sppListi %>% .$recScale, 1, 1e7, 0) %>% 
    gadgetutils::g3_init_guess(paste0(stock_names,'.init.scalar'), 1e-4, 1e-5, 1e6, 0) %>%
    gadgetutils::g3_init_guess(paste0(stock_names,'.recl'), grw.constants["recl"], grw.constants["recl"]*0.2, grw.constants["recl"]*2, 0) %>%
    ## gadgetutils::g3_init_guess(paste0(stock_names,'.recl'), min(defaults$length)*2, min(defaults$length), min(defaults$length)*3,1) %>%
    gadgetutils::g3_init_guess(paste0(stock_names,'.rec.sd'), init.sigma$stddev[1]*0.9, init.sigma$stddev[1]*0.2, init.sigma$stddev[1]*2,0) %>%
    gadgetutils::g3_init_guess(paste0(stock_names,'.Linf'), grw.constants["Linf"], grw.constants["Linf"]*0.8, grw.constants["Linf"]*1.2,0) %>%
    gadgetutils::g3_init_guess(paste0(stock_names,'.k'), 1e2 * grw.constants["k"], 1e2 * grw.constants["k"] * 0.1, 1e2 * grw.constants["k"] * 5,1) %>%
    gadgetutils::g3_init_guess(paste0(stock_names,'.bbin'), 0.9, 0.01, 50, 1) %>% 
    gadgetutils::g3_init_guess(paste0(stock_names,'.com.alpha'), 0.9,  0.1, 3, 1) %>% 
    gadgetutils::g3_init_guess(paste0(stock_names,'.com.l50'), mean(as.numeric(substring(ldist.com$length,4,6))), min(as.numeric(substring(ldist.com$length,4,6))), max(as.numeric(substring(ldist.com$length,4,6))), 1) %>% 
    gadgetutils::g3_init_guess(paste0(stock_names,'.surQ1.alpha'), 0.9,  0.1, 2, 1) %>% 
    gadgetutils::g3_init_guess(paste0(stock_names,'.surQ1.l50'),  mean(as.numeric(substring(ldist.survQ1$length,4,6))), min(as.numeric(substring(ldist.survQ1$length,4,6))), max(as.numeric(substring(ldist.survQ1$length,4,6))), 1) %>% 
    gadgetutils::g3_init_guess(paste0(stock_names,'.surQ3.alpha'), 0.9,  0.1, 2, 1) %>% 
    gadgetutils::g3_init_guess(paste0(stock_names,'.surQ3.l50'), mean(as.numeric(substring(ldist.survQ3$length,4,6))), min(as.numeric(substring(ldist.survQ3$length,4,6))), max(as.numeric(substring(ldist.survQ3$length,4,6))), 1) %>%
    gadgetutils::g3_init_guess(paste0(stock_names,'.walpha'), lw.constants$a, lw.constants$a*0.1, lw.constants$a*10, 0) %>% 
    gadgetutils::g3_init_guess(paste0(stock_names,'.wbeta'), lw.constants$b, 2, 4, 0) %>% 
    gadgetutils::g3_init_guess(paste0(stock_names,'.M'), 0.2, 0.001, 1, 0) 
  
  
  ## Re-build the TMB model with a penalty for when values exceed bounds (during optimisation)
  tmb_model <- gadget3::g3_to_tmb(c(attr(tmb_model, 'actions'), 
                                    list(g3experiments::g3l_bounds_penalty(tmb_param %>% filter(optimise)))))
  
  ## Check the model produces a NLL, we will do this using the R model
  r_model <- gadget3::g3_to_r(attr(tmb_model, 'actions'))
  result <- attributes(r_model(tmb_param$value))
  print(paste0('NLL = ', result$nll))
  
  ## Setup gadget3 folder
  if (!dir.exists(file.path(dirName, 'WGTS'))){
    dir.create(file.path(dirName, 'WGTS'), recursive = TRUE)
  }
  if (!dir.exists(file.path(dirName, 'OPT'))){
    dir.create(file.path(dirName, 'OPT'), recursive = TRUE)
  }
  
  ## Save model
  save(tmb_model, file = file.path(dirName, 'tmb_model.Rdata'))
  save(tmb_param, file = file.path(dirName, 'tmb_param.Rdata'))
  
}


mfdb_disconnect(mdb)

## setwd(gd$dir)
## source("run.R")
