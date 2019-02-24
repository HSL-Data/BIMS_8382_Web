
library(tidyverse)
hd <- read_csv("Data/heart_disease.csv")

#smoothed line
#Reproduce this graph that is looking at the relationship between age and resting blood pressure
p <- ggplot(hd, aes(x = age, y = trestbps))
p + geom_smooth(size = 2)

#scatter
#Reproduce this graph that is looking at the relationship between resting blood pressure and cholestorol by outcome. 
p <- ggplot(hd, aes(x = trestbps, y = chol))
p + geom_point(aes(color = outcome), size = 2, pch = 4)

#smoothed line with facets 
#Reproduce these graphs looking at the relationship maximum heart rate achieved and cholestorol, Faceted by chest pain type (cp = 1, 2, 3 or 4)
p <- ggplot(hd, aes(thalach, chol)) 
p + geom_smooth() + geom_point(aes(color = outcome)) + facet_wrap(~cp, ncol = 4)

p <- ggplot(filter(hd,cp > 1 & cp < 4), aes(thalach, chol)) 
p + geom_smooth() + geom_point(aes(color = outcome)) + facet_wrap(~cp, ncol = 1)


#boxplot with jitter
#Reproduce this graph looking at the relationship between outcome and age. 
#Make sure to check the legend, axis, etc.

p <- ggplot(hd, aes(x = outcome, y = age)) 
p + geom_boxplot() + geom_jitter(aes(color = sex)) + ggtitle("Age vs. Outcome by Sex") +  xlab("Heart Disease Outcome") + ylab("Age (years)")

#Full graph
#density
#density curve of thalach faceted by cp
#Hint: Change cp to a factor
hd$cp <- as.factor(hd$cp)
p <- ggplot(hd, aes(thalach))
p + geom_density(aes(color = cp, fill = cp), alpha = 1/4) + geom_vline(xintercept = c(100, 150), size = 2, color = c("firebrick", "blue"), alpha = 1/4) + geom_hline(yintercept = c(.005, .020), size = 3, color = c("green", "yellow"), alpha = 1/4) + xlab("Maximum Heart Rate Achieved") + ggtitle("Distribution of Maximum Heart Rate Achieved by Chest Pain Type")

##
p <- ggplot(hd, aes(thalach))
p + geom_density(aes(color = cp, fill = cp)) + xlab("Maximum Heart Rate Achieved") + ggtitle("Distribution of Maximum Heart Rate Achieved by Chest Pain Type") + facet_wrap(aes(cp))