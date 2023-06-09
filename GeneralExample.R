#### setting up stuff ####
rm(list=ls())
library(tidyverse)
library(ggplot2)
source("theme_Publication.R")

Psideplac <- 0.5

##Pr(B=1|A=1)/Pr(B=1|A=0)
Psidevaccvec <- c(1/2, 2/3, 1, 1.5, 2)

## assume that Pr(Y=1|S=B=0, A=0)=0.01
baseline <- 0.01

##the purely biological effect is (1-VEbio)
VEbio <- seq(from = 0.01, to = 0.99, length.out = 50)

##Pr(Y=1|A=a,B=1)/Pr(Y=1|A=a,B=0)
RRbehav <- 2

##dataframe for plotting
datlong <- data.frame(observed = numeric(), sideeffect=numeric(), VEbio = numeric())

##looping over the probability of unblinding and calculating the VEs
for (i in 1:length(Psidevaccvec)){
  Psidevacc <- Psidevaccvec[i]*Psideplac
  observedVacc <- baseline*RRbehav*(1 - VEbio)*Psidevacc + baseline*1*(1 - VEbio)*(1-Psidevacc)
  observedPlac <- baseline*RRbehav*Psideplac + baseline*1*(1-Psideplac)
  ObservedVE <- 1 -observedVacc/observedPlac
  datlong <- rbind(datlong,data.frame(observed = ObservedVE, sideeffect = Psidevaccvec[i],VEbio = VEbio))
}

##plotting everything
ggplot(datlong,aes(x=VEbio,y=observed,group=sideeffect,col=sideeffect))+
  geom_line()+geom_abline(slope = 1, intercept = 0,linetype = "dashed")+
  geom_segment(aes(x=0, xend=0.94,y=0.94,yend=0.94),col="red") +
  annotate("text", x=0.3, y=1, label="COVID-19")+
  geom_segment(aes(x=0, xend=0.71,y=0.71,yend=0.71),col="red") +
  annotate("text", x=0.3, y=0.76, label="pertussis")+
  geom_segment(aes(x=0, xend=0.55,y=0.55,yend=0.55),col="red") +
  annotate("text", x=0.3, y=0.6, label="influenza")+
  xlab("Biological VE \n [1-P(Y=1|A=1,B=b)/P(Y=1|A=0,B=b)]")+ylab("Observed VE")+  labs(color ="P(B=1|A=1)/P(B=1|A=0)")+
  scale_y_continuous(limits = c(0, 1.1), expand = c(0, 0))+
  scale_x_continuous(limits = c(0, 1), expand = c(0, 0))+
  ggtitle(paste0("P(B=1|A=0)=0.5 \n","P(Y=1|B=1,A=a)/P(Y=1|B=0,A=a)=",as.character(RRbehav)))+
  theme_Publication()+
  theme(plot.title = element_text(size = 10, face = "bold"))+
  theme(axis.title.x =  element_text(size = 10, face = "bold"))+  theme(axis.title.y =  element_text(size = 10, face = "bold"))+
  theme(legend.title =  element_text(size = 10, face = "bold"))+
  theme(legend.title =  element_text(size = 10, face = "bold"))+
  guides(color = guide_colourbar(barwidth = 0.5, barheight = 5))

ggsave("Illustration.png")

