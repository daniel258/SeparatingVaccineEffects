#### VE comparison for Stensrud et al (2057)
# This file creates the plots comparing VE(-1), VE(0), VE(1) and VE_t 

#### setting up stuff ####
rm(list=ls())
library(tidyverse)
library(ggplot2)
source("theme_Publication.R")


# A function that takes RR_B and VE_t as defined in the paper and returns
# risks and VEs
CalcVEs <- function(ve_tot, rr_b)
{
  risk_a0m0 <- 0.01
  risk_a1m1 <- 0.01*(1 - ve_tot)
  risk_a0m1 <- 0.02
  risk_a0m1 <- 0.005*(1 - ve_tot)
  ve_0 <- 0.5*(ve_tot + 1)
  ve_1 <- 0.5*(ve_tot + 1)
  ve_minus1 <- 1 - (1- ve_tot)*(0.005 + 0.0025*rr_b)/0.015
  df_back <- data_frame(VE_t = ve_tot, RR_b = rr_b, VE0 = ve_0, VE1 = ve_1, VEminus1 = ve_minus1)
  return(df_back)
}
## POs under a=0,1 m=0,1


all_ve_tot <- seq(from = 0.01, to = 0.99, 0.02)
all_rr_b <- seq(from = 0.5, to = 2, 0.25)


my_df <- expand.grid(all_ve_tot, all_rr_b) %>% as.data.frame()
colnames(my_df) <- c("VE_total", "RR_B")

my_df %>% 
  group_by(VE_total,RR_B) %>%
  do(CalcVEs(.$VE_total,.$RR_B)) -> df_all
#df_all$RR_B <- factor(df_all$RR_B)
##plotting everything
ggplot(df_all,aes(x = VE_total, y = VEminus1, group = RR_B, col = RR_B)) +
  geom_line() + geom_abline(slope = 1, intercept = 0,linetype = "dashed") + 
  geom_segment(aes(x = 0, xend = 0.94, y = 0.94,yend = 0.94),col = "red") +
  annotate("text", x = 0.3, y = 1, label = "COVID-19") +
  geom_segment(aes(x = 0.71, xend = 1, y = 0.71, yend = 0.71), col = "red") +
  annotate("text", x = 0.875, y = 0.76, label = "pertussis") +
  geom_segment(aes(x = 0.55, xend = 1.00, y = 0.55, yend = 0.55), col = "red") +
  annotate("text", x = 0.875, y = 0.6, label="influenza") +
  # geom_segment(aes(x = 0, xend = 0.71, y = 0.71, yend = 0.71), col = "red") +
  # annotate("text", x = 0.3, y = 0.76, label = "pertussis") +
  # geom_segment(aes(x = 0, xend = 0.55, y = 0.55, yend = 0.55), col = "red") +
  # annotate("text", x = 0.3, y = 0.6, label="influenza") +
  ylab("VE(-1)") +   xlab(expression("VE"[t])) +
  scale_y_continuous(limits = c(0, 1.1), expand = c(0, 0),
                     sec.axis = sec_axis(~ .)) +
#  scale_y_continuous(limits = c(0,1.1), breaks =  c(0.25, 0.50, 0.75, 0.94, 1.00),
 #                    labels = c(0.25, 0.50, 0.75, "COVID-19", 1.00), expand = c(0,0))
  scale_x_continuous(limits = c(0, 1), expand = c(0, 0)) +
  theme_Publication()+
  theme(plot.title = element_text(size = 10, face = "bold"))+
  theme(axis.title.x =  element_text(size = 10, face = "bold"))+  
  theme(axis.title.y =  element_text(size = 10, face = "bold"))+
  theme(legend.title =  element_text(size = 10, face = "bold"))+
  theme(legend.title =  element_text(size = 10, face = "bold"))
  guides(color = guide_colourbar(barwidth = 0.5, barheight = 5))

ggsave("Plots/VEminus1VersusVEtotal2.png")

ggplot(df_all,aes(x = VE1, y = VEminus1, group = RR_B, col = RR_B)) +
  geom_line() + geom_abline(slope = 1, intercept = 0,linetype = "dashed") + 
  geom_segment(aes(x=0, xend=0.94,y=0.94,yend=0.94),col="red") +
  annotate("text", x=0.3, y=1, label="COVID-19")+
  geom_segment(aes(x=0, xend=0.71,y=0.71,yend=0.71),col="red") +
  annotate("text", x=0.3, y=0.76, label="pertussis")+
  geom_segment(aes(x=0, xend=0.55,y=0.55,yend=0.55),col="red") +
  annotate("text", x=0.3, y=0.6, label="influenza")+
  ylab("VE(-1)") +
  xlab("VE(0) = VE(1)") + 
  scale_y_continuous(limits = c(0, 1.1), expand = c(0, 0))+
  scale_x_continuous(limits = c(0, 1), expand = c(0, 0))+
  theme_Publication() +
  theme(plot.title = element_text(size = 10, face = "bold"))+
  theme(axis.title.x =  element_text(size = 10, face = "bold"))+  theme(axis.title.y =  element_text(size = 10, face = "bold"))+
  theme(legend.title =  element_text(size = 10, face = "bold"))+
  theme(legend.title =  element_text(size = 10, face = "bold"))+
  guides(color = guide_colourbar(barwidth = 0.5, barheight = 5))

ggsave("Plots/VEminus1VersusVE01.png")

ggplot(df_all, aes(x = VE1, y = VE_total, group = RR_B, col = RR_B)) +
  geom_line() + geom_abline(slope = 1, intercept = 0,linetype = "dashed") + 
  #geom_segment(aes(x=0, xend=0.94,y=0.94,yend=0.94),col="red") +
  # annotate("text", x=0.3, y=1, label="COVID-19")+
  # geom_segment(aes(x=0, xend=0.71,y=0.71,yend=0.71),col="red") +
  # annotate("text", x=0.3, y=0.76, label="pertussis")+
  # geom_segment(aes(x=0, xend=0.55,y=0.55,yend=0.55),col="red") +
  # annotate("text", x=0.3, y=0.6, label="influenza")+
  ylab("VE_t") +
  xlab("VE(0) = VE(1)") + 
  #xlab("Biological VE \n [1-P(Y=1|A=1,B=b)/P(Y=1|A=0,B=b)]")+ylab("Observed VE")+  labs(color ="P(B=1|A=1)/P(B=1|A=0)")+
  scale_y_continuous(limits = c(0, 1.1), expand = c(0, 0))+
  scale_x_continuous(limits = c(0, 1), expand = c(0, 0))+
  #ggtitle(paste0("P(B=1|A=0)=0.5 \n","P(Y=1|B=1,A=a)/P(Y=1|B=0,A=a)=",as.character(RRbehav)))+
  theme_Publication()+
  theme(plot.title = element_text(size = 10, face = "bold"))+
  theme(axis.title.x =  element_text(size = 10, face = "bold"))+  theme(axis.title.y =  element_text(size = 10, face = "bold"))+
  theme(legend.title =  element_text(size = 10, face = "bold"))+
  theme(legend.title =  element_text(size = 10, face = "bold"))+
  guides(color = guide_colourbar(barwidth = 0.5, barheight = 5))

ggsave("Plots/VE01VersusVEtotal.png")
