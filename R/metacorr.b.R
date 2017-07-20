
# This file is a generated template, your changes will not be overwritten

MetaCorrClass <- R6::R6Class(
    "MetaCorrClass",
    inherit = MetaCorrBase,
    private = list(
      .run = function() {
        ri <- self$options$rcor
        ni <- self$options$samplesize
        mods <- self$options$moderatorcor
        fsntype <- self$options$fsntype
        method2 <- self$options$methodmetacor
        cormeasure <- self$options$cormeasure
        slab <- self$options$slab
        includemods <- self$options$includemods
        addcred <- self$options$addcred
        addfit <- self$options$addfit
        showweights <- self$options$showweights
        level <- self$options$level
        #yaxis <- self$options$yaxis
        #data <- self$data
        
        #mods = cbind(mod1, mod2, mod3)
        
        if (self$options$includemods == TRUE) {
          data <- data.frame(ri = self$data[[self$options$rcor]], ni = self$data[[self$options$samplesize]], mods = self$data[[self$options$moderatorcor]], slab = self$data[[self$options$slab]])
          data[[ri]] <- jmvcore::toNumeric(data[[ri]])
          data[[ni]] <- jmvcore::toNumeric(data[[ni]])
          data[[mods]] <- jmvcore::toNumeric(data[[mods]])
        } else {
          data <- data.frame(ri = self$data[[self$options$rcor]], ni = self$data[[self$options$samplesize]], slab = self$data[[self$options$slab]])
          data[[ri]] <- jmvcore::toNumeric(data[[ri]])
          data[[ni]] <- jmvcore::toNumeric(data[[ni]])
        }
        
        
        if (self$options$includemods == TRUE) {
          res <- metafor::rma(ri=ri, ni=ni, method=method2, measure=cormeasure, mods=mods, data=data, slab=slab, level=level)
        } else {
          res <- metafor::rma(ri=ri, ni=ni, method=method2, measure=cormeasure, data=data, slab=slab, level=level)
        }
        
        #Pub Bias
        failsafePB <- metafor::fsn(yi=res$yi, vi=res$vi, type=fsntype)
        ranktestPB <- metafor::ranktest(res)
        regtestPB <- metafor::regtest(res)
        
        #Pub Bias Connections
        self$results$pubBias$fsn$setContent(failsafePB)
        self$results$pubBias$rank$setContent(ranktestPB)
        self$results$pubBias$reg$setContent(regtestPB)
        
        #Data Prep: Results Table
        CILB <- round(res$ci.lb, 3)
        CIUB <- round(res$ci.ub, 3)
        ciLBUB <- paste(CILB,"-",CIUB)
        
        #Results Table
        table <- self$results$textRICH
        table$setRow(rowNo=1, values=list(
          Intercept="Intercept",
          Estimate=as.numeric(res$b[,1]),
          se=res$se,
          p=res$pval,
          CI=ciLBUB,
          Z=res$zval,
          k=res$k
        ))
        
       
        #Data Prep: Heterogeneity Stats
        tauSquared <- round(res$tau2, 4)
        tauSquaredSE <- round(res$se.tau2, 4)
        
        tauSqCombind <- paste(tauSquared,"(SE=",tauSquaredSE,")")
        
        tauOnly <- round(sqrt(res$tau2), 4)
        
        ISquStat <- paste(round(res$I2, 2),"%",sep="")
        HSquStat <- round(res$H2, 4)
        
        #Heterogeneity Table
        tableTauSqaured <- self$results$tableTauSqaured
        tableTauSqaured$setRow(rowNo=1, values=list(
          tauSqComb=tauSqCombind,
          tauSQRT=tauOnly,
          ISqu=ISquStat,
          HSqu=HSquStat
          )) 
        
        #Data Prep: Heterogeneity Test
        QTestStatDF <- round(res$k - 1, 4)

        #Heterogeneity Stats Table
        tableQTest <- self$results$tableQTest
        tableQTest$setRow(rowNo=1, values=list(
          QallDF=QTestStatDF,
          Qall=res$QE,
          QallPval=res$QEp
        ))
        
        # `self$data` contains the data
        # `self$options` contains the options
        # `self$results` contains the results object (to populate)
        image <- self$results$plot
        imageFUN <- self$results$funplot

        image$setState(res)
        imageFUN$setState(res)

      },
      #Forest Plot Function
      .plot=function(image, ...) {  # <-- the plot function
        plotData <- image$state
        #StudyID <- self$options$studylabels
        #yi <- self$options$yi
        #vi <- self$options$vi
        #res <- metafor::rma(yi=yi, vi=vi, data=self$data)
        addcred <- self$options$addcred
        addfit <- self$options$addfit
        level <- self$options$level
        showweights <- self$options$showweights
        xlab <- self$options$xAxisTitle
        order <- self$options$forestOrder
        #plot <- metafor::forest(plotData$yi, plotData$vi, addcred=addcred, addfit=addfit)
        plot <- metafor::forest(plotData, addcred=addcred, addfit=addfit, level=level, showweights=showweights, xlab=xlab, order=order)
        print(plot)
        TRUE
      },
      #Funnel Plot Function
      .funplot=function(imageFUN, ...) {  # <-- the plot function
        plotDataFUN <- imageFUN$state
        yaxis <- self$options$yaxis
        plotFUN <- metafor::funnel(plotDataFUN,yaxis=yaxis)
        print(plotFUN)
        TRUE
      })
)