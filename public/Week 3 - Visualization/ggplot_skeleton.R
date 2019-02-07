#GGPLOT 2 workshop
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
gm <- read_csv("gapminder.csv")
View(gm)

###PART 1 - DATA WRANGLING: Getting your data into shape###

#DPLYR
  #filter -- select certain rows

#Just do a quick filter.


# The PIPE
#Part 1.99 - PLOTTING in Base R


#note about qplot: Encompasses many options and defaults, but not as flexible as ggplot.


###Part 2 - Plotting in GGPLOT2
  #Overview of ggplot2 elements
    # geom -- plot type (point, bar, histogram, etc.)
    # aesthetics -- variables to be mapped onto plot (axes and size, shape, color etc)
    # stat -- statistical summary or transform in plot
    # facets -- way to slice and filter data on certain variable

# Two Continous Variables
# Point, jitter, quantile, smooth, etc.
# Continous X, Continous Y

#The ggplot() function will create a blank canvas to add layers upon.


#data = gm uses the gm dataset and a call to aes indicates the variables to be used.
#However, the graph will still be empty until we specify the type of graph to use.


#Add the geom (plot type), which will be point. (Essentially a scatter plot)


#Save the canvas to a variable


#You can then slowly add on each layer, starting with adding the point geom to p

  
#You can also go ahead and test out other ggplot options
#Let's try to use one of the scaling functions. (check ggplot2 cheatsheet for other scale options)


#I think the log10() looks nice, lets make sure we save this back to p


#This graph looks ok, but it could use something else. 
#You can use an option within the geom_point function to color the individual points by different values within the data. 
#Example: Coloring the points by continent.


#The aes wrapper allows for the color to differentiate based upon variable values.


#Without wrapping the color option in an aes call, the color can be applied in a blanket way across all points.


#Here are a list of colors that are available in R. Put any of those in the color = "color" and it will change the color.


#Within the geom_point function you can also change the symbol type (pch), the size of the symbol (size), and the transparency of the symbol (alpha)


#Using aes within the geom_point function allows you to use the above options and apply them across several variable values.
#Essentially there is a bit of a dynamic vs. static siutation here.


#change shape, color, size to be mapped to variables


# so here the size of the point is determined by lifexp, and the color and shape of the dot are determined by the value for continent

#You can also combine the use of an aes call with the use of options outside of an aes call.


#This allows you to both apply specific options to various values and change the overall appearance to all values.

###################
#Exercise 1



###End of Exercise 1
####################
# Adding to your plot


# Add in a smoothing line to better understand the relationships in your data.
# Smoothing line defaults to using the loess method.


#Adding a smoothing line

# Like in geom_point(), you can change the options within geom_smooth.
# Here we can change the method to a linear model (lm), Choose not to display confidence intervals (se), change the line width (lwd) to 2, and the line color (col) to red.


# You can also combine this with changing the look of your data points


###################
#Faceting: Facets divide a plot into subplots based off of the values of a variable.


#To use facets, you use the function facet wrap.


#Here we will use geom_line to create line graphs
#Watch out when using this to make sure you aren't breaking things up too much.
#Facet wraps allow for options as well. 
#ncol provides the number of columns you want to use to display the graphs.



##Saving plots


#However, we may want to add some smoothing lines to each facet and change to geom_point, etc.


#Can save as a pdf and other formats.


#Filtering your facets

##################
#Exercise 2


#End of Exercise 2
####################################

####
# One categorical variable, one continuous variable.
#   Country vs. deaths
#   Gender vs. lifeexp
#   etc,
# Bar, Boxplot, dotplot, violin
# X = categorical, Y = continuous

# lifeexp by continent

# Lets how it looks with points


# Add transparency to the points


# Add a bit of stagger to the points


# And some transparency


#A boxplot may make a bit more sense.


#add jitter to a boxplot

#ORDER MATTERS
#boxplot on top instead 

#We should go ahead and make the box plot stand out a bit.

#We can also do a violin plot as well. 


###using the pipe 



####USING Filter to narrow things down###
####ALSO QUITE USEFUL FOR HANDLING Nas.###

# Reorder allows for you to reorder the axis labels


#################
#Exercise 3


#End of Exercise 3
################
#raw means
#log10 mean
#use this in plot
#Lets point out the outliers here.
###################
#Univariate plots: histograms, density, bar, dotplot

###histograms

#choose different number of bins


#density plots


#color univariate plots

  
#Alpha provides the transparency of each layer.  

  
#can facet these histograms
 

#we can look at this same chart as a density curve

################
#Exercise 4
#hist of gdpPercap


#hist of gdpPercap on log10 scale


#density plot of gdpPercap on log10 scale filled by continent


#hist on log10 scale faceted by continent and filled by continent. Facet in single column

#save last hist to 6x10 pdf


########End of Exercise 4

########
#Changing the look of your plots
#ADDING REFERENCE LINES


#######
##Let us go ahead and build up a nice base plot to use.


#Changing the Title


#Changing the X and Y axis labels


#To add a caption


###Still doesnt look perfect.
#Using theme() you can control many different ggplot() elements.

##############FORMATTING YOUR GRAPH######## BEYOND THE PLOT WINDOW


#Themes to speed up formatting


#install.packages("ggthemes")
