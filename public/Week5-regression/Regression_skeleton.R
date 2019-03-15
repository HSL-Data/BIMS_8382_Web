# title: "Regression"
# date: "2019-03-11"

# Please set up by downloading necessary packages as detailed on the [Set-up page](https://bims8382.netlify.com/setup.html#regression)
                                                                                 
# Next, download the **nhanes.csv** dataset, the skeleton script, and optionally the lecture slides from our Collab page and create a new project in RStudio with the class materials

# Load tidyverse and lme4 libraries

# Import data

#use dplyr's `mutate_if` to convert all character vectors to factor variables

#The nhanes dataset contains observations from both adults and children. Let's perform our analyses on just adults

#**Slides 1-6**
### Linear regression with continuous X

#Let's look again at the relationship between height and weight.

#What is the interpretation of the Intercept?

#What is the interpretation of the output labeled "Height"?
  
#Check out the R^2. What does that mean?
  
#Let's visualize that relationship

#Assumptions of linear model:
#1. Random Sampling
#2. Equal variance across levels of X
#3. Normality of residuals
#4. Independent residuals
#5. Linear relationship between X and Y

#To check these assumptions, R has a nice built-in plotting feature


### EXERCISE 1 ###
#** YOUR TURN **
#This should mostly be a review from last session. 

#1. Starting with the `nhanes` dataset, create a dataset of children aged 2-10

#2. Fit a linear model of `Height` against `Age` for the dataset of the children. Assign this to an object called `fit`. 

#3. Get some `summary()` statistics on the fit. What is your interpretation of the output?

#4. Create a plot showing the data and the linear model relationship.

### Multiple regression
#**Slides 7-11**

#Let's do a multiple linear regression analysis, where we attempt to model the effect of multiple predictor variables at once on some outcome. First, let's look at the effect of physical activity on testosterone levels.

#Let's throw Age into the model as well.

#Sex is probably the single best predictor of testosterone levels in our dataset. Let's add that into the model


#The way that we have modeled just now is called forward selection where we start with a simple model and then add predictors, one at a time to determine each predictor's influence.

#We could also use a likelihood ratio test where we compare nested models to determine whether the addition of a term was "worth it".

#Let's conduct a likelihood ratio test on the below two models to determine whether PhysActive belongs in the model

### EXERCISE 2 ###
#** YOUR TURN **
#1. Examine the relationship between HDL cholesterol levels (`HDLChol`) and whether someone has diabetes or not (`Diabetes`).
#- Is there a difference between diabetics and nondiabetics? Perform a linear model to find out.

#- Does the relationship hold when adjusting for `Weight`?

#- What about when adjusting for `Weight`, `Age`, `Gender`, `PhysActive` (whether someone participates in moderate or vigorous-intensity sports, fitness or recreational activities, coded as yes/no). What is the effect of each of these explanatory variables?


#A different strategy for model selection is backwards selection where we start with several variables and then determine which to drop first. This time, let's begin with a large model and use information criterion to select terms to drop.

#Fit large model to predict Testosterone values

#Drop AlcoholYear

#Drop PhysActive

#Final model has Gender + BMI + SleepHrsNight + Age + TotChol

## EXERCISE 3 ###
#** YOUR TURN **
#Fit a large model to predict `Weight` using `Height`, `Gender`, `Work`, `TotChol`, and `Pulse`.

#1. Use the drop1 function to select terms to drop one by one.

#2. Continue to drop terms until you reach a final model. Which predictors are in the final model? What is their effect on Weight? Which is the strongest predictor?


# Logistic Regression
#**Slides 12 - 14**

#What if we wanted to model the discrete outcome, e.g., whether someone is insured, against several other variables, similar to how we did with multiple linear regression? For this we'll use _logistic regression_ to model the _log odds_ of binary response. That is, instead of modeling the outcome variable, $Y$, directly against the inputs, we'll model the _log odds_ of the outcome variable.

#Before we fit a logistic regression model let's _relevel_ the Race variable so that "White" is the baseline. That way, we'll get a separate coefficient (effect) for each level of the factor variable(s) in the model, telling you the increased odds that that level has, _as compared to the baseline group_.

#Look at Race. The default ordering is alphabetical

# Let's relevel that where the group with the highest rate of insurance is "baseline"

# If we're happy with that result, permanently change it

# Or do it the dplyr way

#Now, let's fit a logistic regression model assessing how the odds of being insured change with different levels of race. 

#To get the odds ratio rather than the log odds, we exponentiate

#The odds of being insured if you are Asian are 0.53 to 1., etc.

#To get the confidence interval for the odds ratio, we will want to take the $e^{estimate +/- 1.96*SE}$
  
#The SE is difficult to pull out of the model summary, but luckily there are a few great functions in the broom package to do just this!

#Let's add a few more variables into the model to see if something else can explain the apparent Race-Insured association. Let's add a few things likely to be involved (Age and Income), and something that's probably irrelevant (hours slept at night).

### EXERCISE 4 ###
#** YOUR TURN **
#1. Model the association between `Diabetes` and `PhysActive` in a logistic regression framework to assess the risk of diabetes using physical activity as a predictor.
#- Fit a model with just physical activity as a predictor, and display a model summary.

#- Add gender to the model, and show a summary.

#- Continue adding weight and age to the model. What happens to the gender association?

#- Continue and add income to the model. What happens to the original association with physical activity?

#- Examine model fit parameters of the above models. Which is the best model and why?

## Multinomial Logistic Regression ####
#**Slide 15**

#What if your outcome variable is not binary (Yes / No, Disease / Healthy, 1 / 0), but instead has several classes. In our NHANES dataset, `Work` is an example of a cateogrical variable with more than 2 levels. Let's say we want to predict a person's working status based on other variables in the dataset.

#Multinomial logistic regression is an extension of binary logistic regression but instead of creating one function that models 0 / 1, now we create a family of functions to model membership in each group

#We will not have time to cover this topic here, but please see a tutorial of multinomial regression on the [UCLA Institute for Digital Research and Education website](https://stats.idre.ucla.edu/r/dae/multinomial-logistic-regression/)

# Mixed Effects Models ####
#**Slides 16-21**
  
#A mixed effects model is a linear model with both fixed effects and random effects. So far we have only seen fixed effects

#This type of modeling is especially suitable for clustered, longitudinal, or repeated measures data where data are grouped by random levels and where the response variable is continuous

#The first step is to install and load the lme4 library

#Load sleepstudy dataset from lme4 package

#Look at reaction time for each patient

#add line for each subject

#Looks like individual differences will be important. Each subject begins the study with a different baseline reaction time, so we will need a different intercept for each subject and it looks like sleep deprivation affects each person's reaction time differently, so we will likely also need a random slope.

## Fit LM

#A linear model finds a significant effect of days. For each additional day of sleep deprivation, average reaction time increases by 10.46 ms. However, this model ignores the fact that several of the measurements come from the same person (violates independent residuals assumption).

### Random intercept (same slope)
#Because the baseline reaction time for each subject is different, let's fit a random intercept model. We are assuming here that the slope is the same for each subject.

# if you want p-values, know that their calculation is an approximation that sometimes will not perform well. That is why authors of lme4 have not included them

#See the random effects -- aka the intercept for each subject. aka the Best Linear Unbiased Predictions (BLUPs) 

#These are the predicted effect of subject on intercept.

#Let's plot the regression line for each subject

#These don't look bad, but perhaps we can get a better fit by allowing for a varying slope by subject. 

### Random intercept and Random slope model
#This model allows each subject to have their own intercept and slope. In other words, the effect of sleep deprivation over days varies by subject (different slopes).

#Plot for each subject

#would be nice to see these against main regression line

#Check out whether there is a difference between the two models. Because one is nested within the other, we can use the likelihood ratio test