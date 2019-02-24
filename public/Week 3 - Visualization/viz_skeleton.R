## Data Visualization
#We will first load up the tidyverse since we will be using the dplyr, ggplot, and readr packages.

library(tidyverse)

#read in data
brauer <- read_csv("Data/brauer2007_tidy.csv")

#We are going to make a smaller version of this data, for time sake
brauer <- brauer[seq(1, nrow(brauer), 5), ]

#We will also be using the gapminder dataset
gm <- read_csv("Data/gapminder.csv")

###Refreshing skills from last week
#DPLYR
#filter -- select certain rows

#Just do a quick filter.

#THE PIPE

#PART 1.99 - PLOTTING in Base R

#note about qplot: Encompasses many options and defaults, but not as flexible as ggplot.



##ggplot2
#`geom` -- plot type (point, bar, histogram, etc.)
#`aesthetics` -- variables mapped onto plot (axes and size, shape, color etc)
#`stat` -- statistical summary or transform in plot
#`facets` -- way to slice data on certain variable

### Two Continous Variables
### Point, jitter, quantile, smooth, etc.

#This will create a blank canvas to add layers upon.

#`data = gm` uses the `gm` dataset and a call to aes indicates the variables to be used.
#However, the graph will still be empty until we specify the type of graph to use.

#Add the geom (plot type), which will be point. (Essentially a scatter plot)


#Save the canvas to a variable

#You can then slowly add on each layer, starting with adding the point geom to p

#You can also go ahead and test out other ggplot options
#Let's try to use one of the scaling functions. (check ggplot2 cheatsheet for other scale options)

#I think the log10() looks nice, lets make sure we save this back to p


#This graph looks ok, but it could use something else. 
#You can use an option within the `geom_point` function to color the individual points by different values within the data. 

#Example: Coloring the points by continent.

#The `aes` wrapper allows for the color to differentiate based upon variable values.
#Without wrapping the color option in an `aes` call, the color can be applied in a blanket way across all points.

#Here are a list of colors that are available in R. Put any of those in the color = "color" and it will change the color.


#Within the `geom_point` function you can also change the symbol type (`pch`), the size of the symbol (`size`), and the transparency of the symbol (`alpha`)


#Using `aes` within the `geom_point` function allows you to use the above options and apply them across several variable values.
#Essentially there is a bit of a dynamic vs. static situation here.


#Change shape, color, size to be mapped to variables
#So here the size of the point is determined by lifexp, and the color and shape of the dot are determined by the value for continent

#You can also combine the use of an `aes` call with the use of options outside of an `aes` call.

#This allows you to both apply specific options to various values and change the overall appearance to all values.

###Exercise 1
#1. Start with the `ggplot()` function using the gm data.

#2. Create an aesthetic mapping of `gdpPercap` to the x-axis and `total_perthou` to the y-axis.

#3. Add points to the plot: Make the points size 3, use `pch = 25`, and map continent onto the aesthetics of the point

#4. Use a `scale_x_reverse` scale for the x-axis.

#----------------------------------------------------

#Adding to your plot



#Add in a smoothing line to better understand the relationships in your data.
#Smoothing line defaults to using the loess method.


###Adding a smoothing line
#Like in geom_point(), you can change the options within geom_smooth.
#Here we can change the method to a linear model (lm), Choose not to display confidence intervals (se), change the line width (lwd) to 2, and the line color (col) to red.


# You can also combine this with changing the look of your data points


###Faceting
#Facets divide a plot into subplots based off of the values of a variable.


#To use facets, you use the function facet wrap.


#Here we will use geom_line to create line graphs
#Watch out when using this to make sure you aren't breaking things up too much.
#Facet wraps allow for options as well. 
#`ncol` provides the number of columns you want to use to display the graphs.


##Saving plots


#However, we may want to add some smoothing lines to each facet and change to `geom_point`, etc.


#Can save as a pdf and other formats.

#Filtering your facets

##Exercise 2
# 1. Make a scatter plot of `lifeexp` on the y-axis against `year` on the x.

# 2. Make a series of small multiples faceting on continent.

# 3. Add a fitted curve, smooth or lm, with and without facets.

# Bonus: using `geom_line()` and and aesthetic mapping `country` to `group=`, make a "spaghetti plot",
# showing semitransparent lines connected for each country, faceted by continent. Add a smoothed loess
# curve with a thick (`lwd=3`) line with no standard error stripe. Reduce the opacity (`alpha=`) of the
# individual black lines. Don't show Oceania countries (that is,`filter()` the data where `continent != "Oceania"` before you plot it).

#---------------------------------------------------------------

## One categorical variable, one continuous variable.
# Country vs. deaths
# Gender vs. lifeexp
# etc,
# Bar, Boxplot, dotplot, violin

# X = categorical, Y = continuous

#expression by nutrient


#Lets how it looks with points


#Add transparency to the points


# Add a bit of stagger to the points


# And some transparency


#A boxplot may make a bit more sense.


#add jitter to a boxplot


###ORDER MATTERS
#boxplot on top instead 

#We should go ahead and make the box plot stand out a bit.

#We can also do a violin plot as well. 


#using the pipe 

#Using Filter to narrow things down
#Also quite useful for handling Nas
#filter()


#Reorder allows for you to reorder the axis labels


##Exercise 3
#1. Make a jittered strip plot of `GDP per capita` against `continent` .

#2. Make a box plot of `GDP per capita` against `continent`.

#3.Using a log10 y-axis scale, overlay semitransparent jittered points on top of box plots, where outlying points are colored.

#4. BONUS: Try to reorder the continents on the x-axis by `GDP per capita`. Why isn't this working as expected? See `?reorder` for clues.

#---------------------------------------------------------------
##Univariate plots: histograms, density, bar, dotplot

#histograms


#choose different number of bins


#density plots

#color univariate plots

#Alpha provides the transparency of each layer.  

#can facet these histograms

#we can look at this same chart as a density curve


###Exercise 4
#1. Plot a histogram of GDP Per Capita.

#2. Do the same but use a log10 x-axis.

#3. Still on the log10 x-axis scale, try a density plot mapping continent to the fill of each density distribution, and reduce the opacity.

#4. Still on the log10 x-axis scale, make a histogram faceted by continent and filled by continent. Facet with a single column (see ?facet_wrap for help).

#5. Save this figure to a 6x10 PDF file.

#-----------------------------------------------
##Changing the look of your plots

#Adding Reference Lines

#Let us go ahead and build up a nice base plot to use.

#Changing the Title

#Changing the X and Y axis labels

#To add a caption

#Using theme() you can control many different ggplot() elements.

#?theme()

# Themes to speed up formatting

#The ggthemes package has built in themes to mimic certain publications, etc.

#install.packages("ggthemes")
library(ggthemes)

