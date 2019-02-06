#Intro to R
#------------------------------------------------------
#this is a comment and will not be run as code

#R is the underlying statistical computing environment
#RStudio sits on top of R and makes writing code a lot easier.

#Creating projects.

#R Studio Panes
#-On the top left is the script or editor window. This is where we are going to write all of our code.
#- On the lower left there's the console window. This is where R tells us what it thinks we told it and then the answer. This is basically the same kind of interface as the terminal
#- The top right has the environment and history tabs ... environment is a list of all objects that are saved in memory ... history (SHOW HISTORY) is the history of all commands that have been run ...
#- On the bottom right hand side there's a window with Files / Plots / Help

# R can be used as a calculator

# R knows order of operations

# Assign objects using <-

# R is case sensitive

#Do not name R objects with period, spaces, or using name that is already used in R
#e.g. data() is already a function and so is a bad name for an object

#we can do arithmetic with R objects

#modify R object by reassigning object to new number

#we can rename 2.2*weight_kg as weight_lb

#change value of weight_kg

###YOUR TURN###
#What value does weight_kg have?

#What value does weight_lb have?

#list objects in environment

#remove objects from environment

#--------------------------------------------------
#Exercise 1
# 1.	You have a patient with a height (inches) of 73 and a weight (lbs) of 203. Create r objects labeled 'height' and 'weight'.

# 2.	Convert 'weight' to 'weight_kg' by dividing by 2.2. Convert 'height' to 'height_m' by dividing by 39.37

# 3.	Calculate a new object 'bmi' where BMI = weight_kg / (height_m*height_m)


#--------------------------------------------------

#Built-in Functions

#Get help with function

#The base= part inside the parentheses is called an argument. Arguments are the inputs to functions

#We can write functions without labeling arguments as long as they come in the same order as in the help file


#Nesting Functions

#Because sqrt() takes a number and because log() outputs a number we can nest the two together

#create intermediate object to make nesting easier to decipher

#------------------------------------------------
#Exercise 2
#See `?abs` and calculate the square root of the log-base-10 of the absolute value of `-4*(2550-50)`. Answer should be `2`.

#Vectors
  #Vectors are one of the most basic data types in R. They are a sequence of data elemnets of the same type. This can be numeric (2, 3.2, etc.), character ("a", "a sentence is here", "548-4241"), logical ("TRUE", "FALSE"), etc, they just all have to be of the same type.


#Create vectors using c() function (concatenate / combine)

#What if we wanted to created a vector from to 2 to 200 by 4s?

#assign vectors to object name

#vectors can also be character type

#Inspecting vectors

#appending to vectors using c()

#sum

#Indexing vectors

#fifth through 10th elements

#40th and 48th elements (non-sequential)

#what happens when we call an index beyond the vector


#--------------------------------------------------
#Data frames
#data frames store heterogeneous tabular data in R: tabular, meaning that individuals or observations are typically represented in rows, while variables or features are represented as columns; heterogeneous, meaning that columns/features/variables can be different classes (on variable, e.g. age, can be numeric, while another, e.g., cause of death, can be text)

#load data using read.csv

#another option is read_csv in the readr package
#inspecting dataframes

#Using the $ to access variables


#would need mean(gm$lifeExp, na.rm = TRUE) if there are missing values in dataframe

#------------------------------------------------------
#Exercise 3
#1. What's the standard deviation of the life expectancy (hint: get help on the `sd` function with `?sd`).

#2. What's the mean population size in millions? (hint: divide by `1000000`, or alternatively, `1e6`).


#3. What's the range of years represented in the data? (hint: `range()`).

#4.	Run a correlation between life expectancy and GDP per capita (hint: ?cor())