#Ggplot 2 workshop
#layer by layer plotting

#install.packages("tidyverse")
###OR####
#install.packages("readr")
#install.packages("dplyr")
#install.packages("ggplot2")

library(tidyverse)

####OR####

library(ggplot2)
library(dplyr)
library(readr)
#read in data
brauer <- read_csv("Data/brauer2007_tidy.csv")
gm <- read_csv("Data/gapminder.csv")

#Refreshing skills from last week

#DPLYR
#filter -- select certain rows

#Just do a quick filter.
View(filter(brauer, symbol == "SFB2"))

View(filter(brauer, expression < 0 & symbol == "SFB2"))

#THE PIPE
brauer %>% 
  filter(symbol == "SFB2") %>% 
  View()

brauer <- brauer[sample(1:nrow(brauer), 10000),]
#PART 1.99 - PLOTTING in Base R
plot(gm$lifeexp, gm$gdpPercap)

#note about qplot: Encompasses many options and defaults, but not as flexible as ggplot.
qplot(data = gm, x = continent, y = lifeexp, geom = "boxplot")

##ggplot2
# geom -- plot type (point, bar, histogram, etc.)
# aesthetics -- variables mapped onto plot (axes and size, shape, color etc)
# stat -- statistical summary or transform in plot
# facets -- way to slice data on certain variable

# Two Continous Variables
# Point, jitter, quantile, smooth, etc.
# Continous X, Continous Y

#This will create a blank canvas to add layers upon.
ggplot()

#data = gm uses the gm dataset and a call to aes indicates the variables to be used.
#However, the graph will still be empty until we specify the type of graph to use.
ggplot(data = gm, aes(x = gdpPercap, y = lifeexp))

#Add the geom (plot type), which will be point. (Essentially a scatter plot)
ggplot(data = gm, aes(x = gdpPercap, y = lifeexp)) + geom_point()

#Save the canvas to a variable
p <- ggplot(gm, aes(x = gdpPercap, y = lifeexp))
p

#You can then slowly add on each layer, starting with adding the point geom to p
p <- p + geom_point()
  p
  
#You can also go ahead and test out other ggplot options
#Let's try to use one of the scaling functions. (check ggplot2 cheatsheet for other scale options)
p + scale_x_log10()
p + scale_x_sqrt()

#I think the log10() looks nice, lets make sure we save this back to p
p <- p + scale_x_log10()
p

#This graph looks ok, but it could use something else. 
#You can use an option within the geom_point function to color the individual points by different values within the data. 
#Example: Coloring the points by continent.
p + geom_point(aes(color = continent))

#The aes wrapper allows for the color to differentiate based upon variable values.


#Without wrapping the color option in an aes call, the color can be applied in a blanket way across all points.
p + geom_point(color = "blue")

#Here are a list of colors that are available in R. Put any of those in the color = "color" and it will change the color.
colors()

#Within the geom_point function you can also change the symbol type (pch), the size of the symbol (size), and the transparency of the symbol (alpha)
p + geom_point(color = "red", pch = 12, size = 6, alpha = 1)

#Using aes within the geom_point function allows you to use the above options and apply them across several variable values.
#Essentially there is a bit of a dynamic vs. static siutation here.
p + geom_point(aes(color = continent, shape = continent, size = lifeexp))

#change shape, color, size to be mapped to variables

# so here the size of the point is determined by lifexp, and the color and shape of the dot are determined by the value for continent

#You can also combine the use of an aes call with the use of options outside of an aes call.
p + geom_point(aes(color = continent), size = 3, pch = 3)

#This allows you to both apply specific options to various values and change the overall appearance to all values.

###################
#Exercise 1
p <- ggplot(gm, aes(gdpPercap, total_perthou))
p
p <- p + geom_point(aes(color = continent), size = 3, pch = 25)
p
p <- p + scale_x_reverse()
p

gm %>% 
  filter(!is.na(gdpPercap) | !is.na(total_perthou)) %>% 
  ggplot(aes(gdpPercap, total_perthou)) +
  geom_point(aes(color = continent), size = 3, pch = 25) +
  scale_x_reverse()

###End of Exercise 1
####################
# Adding to your plot
p <- ggplot(gm, aes(gdpPercap, lifeexp)) + scale_x_log10()
p

# Add in a smoothing line to better understand the relationships in your data.
# Smoothing line defaults to using the loess method.
p + geom_point() + geom_smooth()
p + geom_smooth()

#Adding a smoothing line

# Like in geom_point(), you can change the options within geom_smooth.
# Here we can change the method to a linear model (lm), Choose not to display confidence intervals (se), change the line width (lwd) to 2, and the line color (col) to red.
p <- p + geom_point() + geom_smooth(lwd = 2, se = FALSE, method = "lm", color = "red")

# You can also combine this with changing the look of your data points
p + geom_point(aes(color = continent))


###################
#Faceting: Facets divide a plot into subplots based off of the values of a variable.
p <- ggplot(gm, aes(gdpPercap, lifeexp)) + scale_x_log10()

#To use facets, you use the function facet wrap.
p + geom_line() + facet_wrap(~continent)
p + geom_line() + facet_wrap(~country)

#Here we will use geom_line to create line graphs
#Watch out when using this to make sure you aren't breaking things up too much.
#Facet wraps allow for options as well. 
#ncol provides the number of columns you want to use to display the graphs.
p + geom_line() + facet_wrap(~continent, ncol = 5)


##Saving plots
ggsave(file = "gdp_lifeexp.png")

#However, we may want to add some smoothing lines to each facet and change to geom_point, etc.
pfinal <- p + geom_point() + geom_smooth() + facet_wrap(~continent, ncol = 1)
pfinal

#Can save as a pdf and other formats.
ggsave(pfinal, file = "finalplot.pdf", width = 5, height = 15)

#Filtering your facets
p <- ggplot(filter(gm, year >= 1997), aes(gdpPercap, lifeexp)) + scale_x_log10()
p
p + geom_point() + facet_wrap(~year)

##################
#Exercise 2
p <- ggplot(gm, aes(year, lifeexp))
p <- p + geom_point()
p
p + facet_wrap(~continent)
p + geom_smooth(method = "lm") + facet_wrap(~continent)

p <- ggplot(filter(gm, continent != "Oceania"), aes(year, lifeexp))

p + geom_line(aes(group = country), alpha = .5) + facet_wrap(~continent) + geom_smooth(lwd = 3, se = FALSE)

#End of Exercise 2
####################################

####
# One categorical variable, one continuous variable.
#   Country vs. deaths
#   Gender vs. lifeexp
#   etc,
# Bar, Boxplot, dotplot, violin
# X = categorical, Y = continuous

# expression by nutrient
p <- ggplot(brauer, aes(x = nutrient, y = expression))
p
# Lets how it looks with points
p + geom_point()

# Add transparency to the points
p + geom_point(alpha = 1/4)

# Add a bit of stagger to the points
p + geom_jitter()

# And some transparency
p + geom_jitter(alpha = 1/4)

#A boxplot may make a bit more sense.
p + geom_boxplot()

#add jitter to a boxplot
p + geom_boxplot() + geom_jitter(alpha = 1/2)

#ORDER MATTERS
#boxplot on top instead 
p + geom_jitter() + geom_boxplot()

#We should go ahead and make the box plot stand out a bit.
p + geom_jitter() + geom_boxplot(color = "red", fill = "blue")

#We can also do a violin plot as well. 
p + geom_violin()
  p + 
    geom_violin() + 
    geom_jitter(aes(color = nutrient), alpha = 1/4)

###using the pipe 
brauer %>% 
  ggplot(aes(x = nutrient, y = expression)) + 
  geom_violin() + 
  geom_jitter(aes(color = nutrient), alpha = 1/4)


####USING Filter to narrow things down###
####ALSO QUITE USEFUL FOR HANDLING Nas.###

# Reorder allows for you to reorder the axis labels
p <- ggplot(brauer, aes(x = reorder(nutrient, rate), y = expression))
p 
p + geom_boxplot()

#################
#Exercise 3
p <- ggplot(gm, aes(x = continent, y = gdpPercap))
p + geom_jitter()
p + geom_boxplot()

p <- p + scale_y_log10()
p

p + geom_boxplot(outlier.color = "blue") + geom_jitter(alpha = 1/4)

p <- ggplot(gm, aes(x = reorder(continent, resp_deaths), y = gdpPercap)) + scale_y_log10()
p

p + geom_boxplot(outlier.color = "red") + geom_jitter(alpha = 1/4)
#End of Exercise 3
################
#raw means
#log10 mean
#use this in plot
#Lets point out the outliers here.
###################
#Univariate plots: histograms, density, bar, dotplot

###histograms
p <- ggplot(gm, aes(lifeexp))
p

p <- p + geom_histogram()
  p 
#choose different number of bins
p + geom_histogram(bins = 5)
p + geom_histogram(binwidth = 25)
p + geom_histogram(binwidth = 5)
p + geom_histogram(breaks = c(40, 45, 55, 70, 80))

#density plots
p <- ggplot(gm, aes(lifeexp))
  p + geom_density()

#color univariate plots
  p + geom_histogram(aes(color = continent))
  
  p + geom_histogram(aes(fill = continent), position = "identity")
  
#Alpha provides the transparency of each layer.  
  p <- p + geom_histogram(aes(fill = continent), position = "identity", alpha = 1/3)
  p
  
#can facet these histograms
  p <- p + facet_wrap(~continent)
  p  
#we can look at this same chart as a density curve
  p <- ggplot(gm, aes(lifeexp))
    
  p + geom_density(aes(color = continent, fill = continent), alpha = 1/3, size = 1)
  
  p + geom_density(aes(color = continent, fill = continent)) + facet_wrap(~continent)
    

################
#Exercise 4
#hist of gdpPercap
p <- ggplot(gm, aes(gdpPercap))
p + geom_histogram()  

#hist of gdpPercap on log10 scale
p + geom_histogram() + scale_x_log10()

#density plot of gdpPercap on log10 scale filled by continent
p + geom_density(aes(fill = continent)) + scale_x_log10() + facet_wrap(~continent)

#hist on log10 scale faceted by continent and filled by continent. Facet in single column
p + geom_histogram(aes(fill = continent)) + scale_x_log10() + facet_wrap(~continent, ncol = 1)

#save last hist to 6x10 pdf
ggsave("continentplot.pdf", width = 6, height = 10)

########End of Exercise 4

########
#Changing the look of your plots
#ADDING REFERENCE LINES
p <- ggplot(gm, aes(x = total_perthou, y = lifeexp))
p

p <- p + geom_point(aes(color = death_cat), size = 3)
p

p <- p + geom_vline(xintercept = c(550, 725), size = 2, color = c("firebrick", "blue"), alpha = 1/4)
p
#######
##Let us go ahead and build up a nice base plot to use.

p <- ggplot(gm, aes(gdpPercap, lifeexp))
p <- p + scale_x_log10() + 
     aes(color = continent) +
     geom_point() + 
     geom_smooth(se = FALSE, lwd = 2)

p
#Changing the Title
p <- p + ggtitle("Life Expectancy vs. GDP by Continent")
p

title <- ggtitle("Life Expectancy vs. GDP by Continent")

#Changing the X and Y axis labels
p <- p + xlab("GDP Per Capita (USD)") + ylab("Life Expectancy (years)")
p

xlabs <- xlab("GDP Per Capita (USD)")
ylabs <- ylab("Life Expectancy (years)")

#To add a caption
p <- p + labs(caption = "(Data from gapminder.csv)")
p
caps <- labs(caption = "(Data from gapminder.csv)")

###Still doesnt look perfect.
#Using theme() you can control many different ggplot() elements.
##############FORMATTING YOUR GRAPH######## BEYOND THE PLOT WINDOW
?theme()
p
new_theme <- theme(legend.position = "bottom", 
        axis.text = element_text(color = "red"),
        panel.background = element_rect(fill = "mistyrose2"),
        plot.title = element_text(size = 20, color = "orange"),                                  
        axis.title = element_text(size = 14, color = "sienna")
        )

p + new_theme

# Themes to speed up formatting
p <- ggplot(gm, aes(gdpPercap, lifeexp))
p <- p + scale_x_log10() + 
  aes(color = continent) +
  geom_point() + 
  geom_smooth(se = FALSE, lwd = 2)
p

p + title + caps + xlabs + ylabs
p <- ggplot(gm, aes(gdpPercap, lifeexp))
p <- p + scale_x_log10() + 
  aes(color = continent) +
  geom_point() + 
  geom_smooth(se = FALSE, lwd = 2)

p

p + theme_bw() + theme(legend.position = "none")
p + theme_classic()

#install.packages("ggthemes")
library(ggthemes)
p + theme_excel() + scale_color_excel()
p + theme_gdocs() + scale_color_gdocs()
p + theme_stata() + scale_color_stata()
p + theme_wsj() + scale_color_wsj()
p + theme_economist()
p + theme_fivethirtyeight()