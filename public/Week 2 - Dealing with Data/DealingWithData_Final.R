#' ---
#' title: Dealing with Data
#' date: February 18, 2019
#' output: html_document
#' ---
#'
#'[Back to the main page](bims8382.netlify.com)
#'
#' Data analysis involves a large amount of [janitorwork](http://www.nytimes.com/2014/08/18/technology/for-big-data-scientists-hurdle-to-insights-is-janitor-work.html) -- munging and cleaning data to facilitate downstream data analysis. In fact, data scientists say that around [80%](https://www.infoworld.com/article/3228245/data-science/the-80-20-data-science-dilemma.html) of their time is taken up by data cleaning tasks compared to just 20% for the actual analyses.
#'
#' Our goal will be to produce "tidy data" that we can then use to derive some insights. [Tidy data](https://vita.had.co.nz/papers/tidy-data.pdf) is defined as:
#'
#' 1. Each variable forms a column.
#' 2. Each observation forms a row.
#' 3. Each type of observational unit forms a table.
#'
#' To transform the data into tidy data will take different steps depending on the nature of the untidyness. Hadley Wickham, who works for RStudio, says "tidy datasets are all alike but every messy dataset is messy in its own way."
#'
#' This lesson demonstrates techniques for data cleaning and manipulation using the split-apply-combine strategy. We will make use of the tidyr package to clean the data. The dplyr package will help us effectively manipulate and conditionally compute summary statistics over subsets of data, while the stringr package will help us interact with string data.

#' **This lesson assumes a [basic familiarity with R](r-basics.html) and [data frames](r-dataframes.html).**
#'
#' **Recommended Resources**
#' 
#' 1. The [**R for Data Science book**](http://r4ds.had.co.nz/tibbles.html) is a fabulous resource for learning to do data science in R.
#'
#' 2. There are cheatsheets available on the [RStudio website](https://www.rstudio.com/resources/cheatsheets/) for **tidyr**, **dplyr**, and **stringr**, among others. They are excellent quick reference guides for what we will learn today.
#'
#' ## Our data ####

#' We're going to use data about yeast gene expression. This is gene expression dataset from [Brauer et al. Coordination of Growth Rate, Cell Cycle, Stress Response, and Metabolic Activity in Yeast (2008) _Mol Biol Cell_ 19:352-367](http://www.ncbi.nlm.nih.gov/pubmed/17959824). This data is from a gene expression microarray, and in this paper the authors are examining the relationship between growth rate and gene expression in 36 yeast cultures limited by one of six different nutrients (glucose, leucine, ammonium, sulfate, phosphate, uracil). 
#'
#' ## Set up project & Download data ######
#'
#' Download the version of the data that we will use. The file is called **brauer2007_messy.csv**
#'
#' First make new project folder and put the skeleton script and the data files in the project directory
#'
#' We need to load the readr, dplyr, tidyr, and stringr packages. All of these packages are contained in the tidyverse megapackage. Let's load those packages now - hopefully you have already installed them.

#'install.packages("tidyverse")
library(tidyverse)
#'
#' ## Read in original dataset ######

yeast <- read_csv("Data/brauer2007_messy.csv")

#' Display the data

yeast
class(yeast)

#' Optionally, bring up the data in a viewer window
#'
#' We used the `read_*` functions from the [**readr** package](http://readr.tidyverse.org/) to read our data into R. This function loaded data into a _tibble_ instead of R's traditional data.frame. When you read in data with the readr package (`read_csv()`) and you had the dplyr package loaded already, the data frame takes on this "special" class of data frames called a `tbl` (pronounced "tibble"), which you can see with `class(original)`.
#'
#' If you have other "regular" data frames in your workspace, the `as_tibble()` function will convert it into the special dplyr `tbl` that displays nicely (e.g.: `iris <- as_tibble(iris)`). You don't have to turn all your data frame objects into tibbles, but it does make working with large datasets a bit easier.
#'
#' Tibbles v. dataframe ######
#'
#' Tibbles are the tidyverse version of a dataframe and preserve all of the functionality of data frames (Hadley Wickham et al could not write over data.frame to make tibble). Main difference in loading is that string variables (letters) do not get read in as factors in tibbles where as they do in data.frames.
#'
#' When you print (i.e., display) a tibble, it only shows the first 10 rows and all the columns that fit on one screen. It also prints an abbreviated description of the column type. 
#'
#' Look at iris dataset

iris

#' let's change it to a tibble to see the difference in display
iris <- as_tibble(iris)
iris

#' ## The pipe: **%>%** ######
#'
#' The dplyr package imports functionality from the [magrittr](https://github.com/smbache/magrittr) package that lets you _pipe_ the output of one function to the input of another, so you can avoid nesting functions. It looks like this: **`%>%`**. Quick keyboard shortcut is `Command+Shift+M` (mac) or `Control+Shift+M` (pc). You don't have to load the magrittr package to use it since dplyr imports its functionality when you load the dplyr package. 
#' 
#' To demo the pipe, let's call tail on the `iris` dataframe

tail(iris)
iris %>%
  tail()

#' We can use this pipe operator to chain together operations rather than nesting functions together. For example, we can chain together a few functions from the dplyr package.
#'
#' ## The dplyr package ######
#'
#' The [dplyr package](https://github.com/hadley/dplyr) is an R package that makes data manipulation fast and easy. It gives you a handful of useful **verbs** for managing data. On their own they don't do anything that base R can't do. The first two verbs we will learn are filter and select
#'
#' 1. `filter()`
#' 2. `select()`
#'
#' They all take a data frame or tibble as their input for the first argument, and they all return a data frame or tibble as output.
#' 
#' ### filter() ######
#' If you want to filter **rows** of the data where some condition is true, use the `filter()` function. 
#'
#' 1. The first argument is the data frame you want to filter, e.g. `filter(mydata, ...`.
#' 2. The second argument is a condition you must satisfy, e.g. `filter(mydata, variable == "levelA")`.
#' 
#' - `==`: Equal to
#' - `!=`: Not equal to
#' - `>`, `>=`: Greater than, greater than or equal to
#' - `<`, `<=`: Less than, less than or equal to
#'
#' If you want to satisfy *all* of multiple conditions, you can use the "and" operator, `&`. 
#'
#' The "or" operator `|` (the pipe character, usually shift-backslash) will return a subset that meet *any* of the conditions.

#'
#' ### select() ####
#' Whereas the `filter()` function allows you to return only certain _rows_ matching a condition, the `select()` function returns only certain _columns_. The first argument is the data, and subsequent arguments are the columns you want.
#'
#' dplyr in action ######
#'
#' filter for species virginica
iris %>%
  filter(Species == "virginica")

#' filter for where sepal length >= 6.5
iris %>%
  filter(Sepal.Length >= 6.5)

#' filter for where sepal length >= 6.5 then select the species column
iris %>%
  filter(Sepal.Length >= 6.5) %>%
  select(Species)

#' filter for where sepal length >= 6.5 then select the species column then table the frequency of each species

iris %>%
  filter(Sepal.Length >= 6.5) %>%
  select(Species) %>%
  table()

#' ## EXERCISE 1 ######
#' 1. Use filter to find how many plants of the versicolor species were observed with Sepal.Length >= 6.5. Answer should be 9.

iris %>%
  filter(Species == "versicolor" & Sepal.Length >= 6.5)

#' 2. Use filter to find the observations with Petal.Length below 1.5 followed by select to show the Petal.Width and Species for these observations.

iris %>%
  filter(Petal.Length < 1.5) %>%
  select(Petal.Width, Species)

#' ### Back to our messy data ######
yeast

#' ## Separate
#' In looking at the output of original, we have a lot of work to do to tidy the data for analysis. 
#'
#' One of the first problems I see is that there are multiple pieces of data encoded into the column called `NAME`. Luckily, the 3 pieces of data are each separated neatly by `::`. Let's use the separate function from the tidyr package to create 3 new columns from the original `NAME` column.
#'
#' If the separator was not as neat as this, you can input any [regular expression](https://en.wikipedia.org/wiki/Regular_expression) into the separator argument. 
#'
#' ### Resources for Regular Expressions ######
#' 
#' For a nice quick resource for writing regular expressions in R, see a [Regex cheatsheet](http://www.cbs.dtu.dk/courses/27610/regular-expressions-cheat-sheet-v2.pdf).
#'  
#' Also, Jenny Bryan has created a nice website tutorial for learning to use [Regular Expressions in R](http://stat545.com/block022_regular-expression.html).
#' 
yeast %>%
  separate(NAME, into = c("symbol", "systematic_name", "somenumber"), sep = "::")
#'
#' Notice that our original variable `NAME` no longer appears. This change is good, but so far is only in the console. The originial dataframe is still unchanged. 
#'
#' Let's keep the change created by the `separate()` function by saving original with separate back into original

yeast <- yeast %>%
  separate(NAME, into = c("symbol", "systematic_name", "somenumber"), sep = "::")

#' The next problem we will tackle is reshaping the dataframe. Notice that we have several variables that seem to be encoding the same information. Columns G0.05 through U0.3 tell us the gene expression under the nutrient / growth rate condition. We will use `gather` to change the dataframe from wide to long -- make nutrient and growth rate extra rows. 
#'
#' After the dataframe, `gather()` needs 3 other arguments. The first two are very important, but take some getting used to. `key` is the new column you want to create that has the old dataframe column headers. `value` corresponds to the row entries from old dataframe that you want in a new column. The third argument is the vector of columns that we want `gather()` to operate on.
#'
#' ## gather ####
# ?gather

yeast %>%
  gather(key = nutrientrate, value = expression, G0.05:U0.3)

#' make that change stick

yeast <- yeast %>%
  gather(key = nutrientrate, value = expression, G0.05:U0.3)

#' if you got lost, load the half-cleaned dataframe
# yeast <- read_csv("Data/brauer2007_halfclean.csv")
#'
#' Next we will need to separate the 'nutrient' and 'rate' out of the 'nutrientrate' column we just created. To understand how to separate this column properly, let's have a look at the length of each of the entries to understand how many letters long each nutrientrate combination is.
#'
#' To accomplish this, we'll use a function from the stringr package that will count the length of strings in a character vector.
#' 
#' str_length
str_length(yeast$nutrientrate)

#' are any different lengths?

str_length(yeast$nutrientrate) %>% table()

#' Some are 4 and some are 5. Let's take a look at ones that are length 4 using the `filter()` function from dplyr

yeast %>%
  filter(str_length(yeast$nutrientrate) == 4)

#' select the nutrientrate column

yeast %>%
  filter(str_length(yeast$nutrientrate) == 4) %>%
  select(nutrientrate)

#' use table to see all the nutrient rates that are length 4
yeast %>%
  filter(str_length(yeast$nutrientrate) == 4) %>%
  select(nutrientrate) %>%
  table()

#' and look at ones that are length 5
yeast %>%
  filter(str_length(yeast$nutrientrate) == 5) %>%
  select(nutrientrate) %>%
  table()
#' The nutrient is always the first character and the rate is 3 or 4 characters after that.
#'
#' ## EXERCISE 2 ##########
#' Use `separate` to create two new columns called 'nutrient' and 'rate' from the old 'nutrientrate' column. Think about how to separate the nutrient from the rate. Look at the help menu for `separate` by calling `?separate`

#' _hint:_ try `sep = 1`
#' 
yeast %>%
  separate(nutrientrate, into = c("nutrient", "rate"), sep = 1)

#'
#' make the change stick

yeast <- yeast %>%
  separate(nutrientrate, into = c("nutrient", "rate"), sep = 1)

#' The next thing we will do is to get rid of 4 columns we will no longer use: GID, YORF, somenumber, and GWEIGHT

yeast <- yeast %>%
  select(-GID, -YORF, -somenumber, -GWEIGHT)

#' A few more clean up tasks exist. We will append some gene ontologies to the dataframe, change the nutrient names to be more descriptive, change the rate into a numeric vector rather than a character, and a few other details.
#'
#' ## Merge Gene Ontologies ######
#' We will use an inner join to merge the gene ontology data and the original data set. An inner join will keep instances that exist in both the left and the right dataframes
#'
#' ## read in GO data
sn2go <- read_csv("Data/brauer2007_sysname2go.csv")
#'
#' inner join sn2go with original

joined <- inner_join(yeast, sn2go, by = "systematic_name")

#' ## Fix Nutrient names ######
#' To make the nutrient names more descriptive, we will first create a dataframe that matches the nutrient character to its full name.

joined %>%
  select(nutrient) %>%
  table()

nutrient_lookup <- tibble(nutrient = c("G", "L", "N", "P", "S", "U"),
                              nutrient_name = c("Glucose", "Leucine", "Ammonia", "Phosphate", "Sulfate", "Uracil"))

#' Now we will use left join to merge our joined dataset with the new nutrient labels.
joined %>%
  left_join(nutrient_lookup, by = "nutrient")

#' now make the change stick
joined <- joined %>%
  left_join(nutrient_lookup, by = "nutrient")

#' Finally we will change rate to numeric and replace the nutrient column with the nutrient_name.

#' To create new variables or change variables in place, we are going to use dplyr's `mutate()` function. Just like the other dplyr verbs we learned, `filter()` and `select()`, `mutate()` takes a dataframe as the first argument and then the name of the new variable followed by a function to create the new variable. Remember, these functions don't modify the data frame you're operating on, and the result is transient unless you assign it to a new object or reassign it back to itself (not always a good practice).

#' Let's use `mutate()` to change rate into numeric.

joined <- joined %>%
  mutate(rate = as.numeric(rate))

#' Notice that in the symbol, there are NAs but they are formatted just like the other gene symbols. We will use a common structure calling `ifelse()` within the `mutate()` function to recode the NAs as missings

joined %>%
  mutate(symbol = ifelse(symbol == "NA", NA, symbol))

#' Next, we will use select to remove the nutrient column and then a second call to select to move the nutrient name column into the place and variable name nutrient
#' 
#' 
joined %>%
  mutate(symbol = ifelse(symbol == "NA", NA, symbol)) %>%
  select(-nutrient) %>%
  select(symbol, systematic_name, nutrient = nutrient_name, rate:mf)

#' Make those changes stick
joined <- joined %>%
  mutate(symbol = ifelse(symbol == "NA", NA, symbol)) %>%
  select(-nutrient) %>%
  select(symbol, systematic_name, nutrient = nutrient_name, rate:mf)

#' Our last tidying step will be to remove cases where gene expression was missing.

clean <- joined %>%
  filter(!is.na(expression))

#' Read in brauer2007_tidy.csv as "clean" if you got lost
# clean <- read_csv("Data/brauer2007_tidy.csv")

#' Now that we have a tidy dataframe, we can learn a little bit about it.

#' This data is from a gene expression microarray, and in this paper the authors are examining the relationship between growth rate and gene expression in 36 yeast cultures limited by one of six different nutrients (glucose, leucine, ammonium, sulfate, phosphate, uracil). If you give yeast a rich media loaded with nutrients except restrict the supply of a _single_ nutrient, you can control the growth rate to any rate you choose. By starving yeast of specific nutrients you can find genes that: 
  
#' 1. **Raise or lower their expression in response to growth rate**. Growth-rate dependent expression patterns can tell us a lot about cell cycle control, and how the cell responds to stress. The authors found that expression of >25% of all yeast genes is linearly correlated with growth rate, independent of the limiting nutrient. They also found that the subset of negatively growth-correlated genes is enriched for peroxisomal functions, and positively correlated genes mainly encode ribosomal functions. 

#' 2. **Respond differently when different nutrients are being limited**. If you see particular genes that respond very differently when a nutrient is sharply restricted, these genes might be involved in the transport or metabolism of that specific nutrient.

#' ## More fun with dplyr ######

#' Let's use filter to look at the [LEU1](http://www.yeastgenome.org/locus/Leu1/overview) gene, a gene involved in leucine synthesis.

#' Look at a single gene involved in leucine synthesis pathway

clean %>%
  filter(symbol == "LEU1")

#' Look at LEU1 expression at a low growth rate due to nutrient depletion

clean %>%
  filter(symbol == "LEU1" & rate == 0.05)

#' Notice how LEU1 is highly upregulated when leucine is depleted!

#' But expression goes back down when the growth/nutrient restriction is relaxed

clean %>%
  filter(symbol == "LEU1" & rate == 0.3)

#' Show only observations for LEU1 and Leucine depletion. 

clean %>%
  filter(symbol == "LEU1" & nutrient == "Leucine")

#' LEU1 expression starts off high when the growth rate is limited and drops down as the growth rate is relaxed

#' What about LEU1 expression with other nutrients being depleted?

clean %>%
  filter(symbol == "LEU1" & nutrient == "Glucose")

#' if you get the spelling or casing wrong here, it returns an empty tibble rather than throwing an error

#' ## EXERCISE 3 #########

#' 1. Display the data where the biological process the gene plays a role in (the `bp` variable) is "leucine biosynthesis" (be careful with spelling) _and_ the limiting nutrient is Leucine. (Answer should return a 24-by-7 data frame -- 4 genes $\times$ 6 growth rates).

clean %>%
  filter(nutrient == "Leucine" & bp == "leucine biosynthesis")

#' 2. Display the data where the observation had high expression (in the top 1% of expressed genes). _Hint:_ see `?quantile` and try `quantile(clean$expression, probs=.99)` to see the expression value which is higher than 99% of all the data, then `filter()` based on that. Try piping your answer into the `View()` function so you can see the whole thing. What does it look like those genes are doing? Answer should return a 1971-by-7 data frame.

quantile(clean$expression, probs=.99)
clean %>%
  filter(expression > quantile(expression, probs=.99))

#' Can we use a regex and fuzzy matching to find leucine in the nutrient and bp columns?

clean %>%
  filter(str_detect(nutrient, "Leu") & str_detect(bp, "[Ll]eu"))

#' leu is also part of nucleus so let's match with a longer word

clean %>%
  filter(str_detect(nutrient, "Leu") & str_detect(bp, "[Ll]eucine"))

#' Aside from the incredibly useful dplyr verbs `filter`, `select` and `mutate`, dplyr has a few other single-table verbs that we should learn.

#' 1. `arrange()`
#' 2. `summarize()`
#' 3. `group_by()`

#' ### arrange() ######

#' The `arrange()` function does what it sounds like. It takes a data frame or tbl and arranges (or sorts) by column(s) of interest. The first argument is the data, and subsequent arguments are columns to sort on. Use the `desc()` function to arrange by descending.

#' arrange by gene symbol

clean %>%
  arrange(symbol)

#' arrange by expression (default: increasing)

clean %>%
  arrange(expression)

#' arrange by decreasing expression

clean %>%
  arrange(desc(expression))

#' arrange by multiple conditions. Gene symbol (ascending) THEN expression descending
clean %>%
  arrange(symbol, desc(expression))

#' ## EXERCISE 4 ######

#' 1. First, filter the dataframe for genes involved in the "leucine biosynthesis" biological process _and_ where the limiting nutrient is Leucine. 

clean %>%
  filter(nutrient == "Leucine" & bp == "leucine biosynthesis")

#' 2. Pipe the filtered result to `arrange()` where you'll arrange the result of #1 by the gene symbol.
clean %>%
  filter(nutrient == "Leucine" & bp == "leucine biosynthesis") %>%
  arrange(symbol)

#' 3. Pipe this result in a `View()` statement so you can see the entire result.
clean %>%
  filter(nutrient == "Leucine" & bp == "leucine biosynthesis") %>%
  arrange(symbol) #%>% View()

#' ### summarize() #####

#' The `summarize()` function summarizes multiple values to a single value. On its own the `summarize()` function doesn't seem to be all that useful. The dplyr package provides a few convenience functions called `n()` and `n_distinct()` that tell you the number of observations or the number of distinct values of a particular variable.

#' Notice that summarize takes a data frame and returns a data frame. In this case it's a 1x1 data frame with a single row and a single column. The name of the column, by default is whatever the expression was used to summarize the data. This usually isn't pretty, and if we wanted to work with this resulting data frame later on, we'd want to name that returned value something easier to deal with.

#' Get the mean expression for all genes
clean %>%
  summarize(mean(expression))

#' Use a more friendly name, e.g., meanexp, or whatever you want to call it
clean %>%
  summarize(meanexp = mean(expression))

#' Get the number of observations
clean %>%
  summarize(n())

#' The number of distinct gene symbols in the data 

clean %>%
  summarize(ngene = n_distinct(symbol))

#' ### group_by() ######

#' We saw that `summarize()` isn't that useful on its own. Neither is `group_by()` All this does is takes an existing data frame and coverts it into a grouped data frame where operations are performed by group.

#' group_by nutrient
clean %>%
  group_by(nutrient)

#' group_by nutrient and rate
clean %>%
  group_by(nutrient, rate)

#' The real power comes in where `group_by()` and `summarize()` are used together. First, write the `group_by()` statement. Then pipe the result to a call to `summarize()`.

#' Get the mean expression for each gene

clean %>%
  group_by(symbol) %>%
  summarize(meanexp = mean(expression))

#' ## EXERCISE 5 #####
#' Putting it all together

#' 1. Show the limiting nutrient and expression values for the gene ADH2 when the growth rate is restricted to 0.05. _Hint:_ 2 pipes: `filter` and `select`.

clean %>%
  filter(symbol == "ADH2" & rate == 0.05) %>%
  select(nutrient, expression)

#' 2. What are the four most highly expressed genes when the growth rate is restricted to 0.05 by restricting glucose? Show only the symbol, expression value, and GO terms (bp and mf). _Hint:_ 4 pipes: `filter`, `arrange`, `head`, and `select`.
#' 
clean %>%
  filter(rate == 0.05 & nutrient == "Glucose") %>%
  arrange(desc(expression)) %>%
  head(4) %>%
  select(symbol, expression, bp, mf)

#' 3. When the growth rate is restricted to 0.05, what is the average expression level across all genes involved in the biological process == "response to stress", separately for each limiting nutrient? What about genes in the "protein biosynthesis" biological process? _Hint:_ 3 pipes: `filter`, `group_by`, `summarize`.

clean %>%
  filter(rate == 0.05 & bp == "response to stress") %>%
  group_by(nutrient) %>%
  summarize(meanexp = mean(expression))

clean %>%
  filter(rate == 0.05 & bp == "protein biosynthesis") %>%
  group_by(nutrient) %>%
  summarize(meanexp = mean(expression))

#' There are many biological processes listed that have to do with stress. If you wanted to select any of the bps where stress was mentioned, you could use a regular expression searching for "stress" to capture all of them
#' 
clean %>% 
  filter(rate==.05 & str_detect(bp, "stress"))

clean %>% 
  filter(rate==.05 & str_detect(bp, "stress"))%>% 
  group_by(nutrient) %>% 
  summarize(meanexp=mean(expression))

#' ## EXERCISE 6 ##########
#' ** If there is time **
  
#' Those were easy, right? How about some tougher ones.

#' 1. Use `n_distinct()` within a `summarize()` call to count the number of different biological processes in the dataset

clean %>% summarize(n_distinct(bp))

#' 2. Which 10 biological process annotations have the most genes associated with them? What about molecular functions? _Hint:_ 4 pipes: `group_by`, `summarize` with `n_distinct`, `arrange`, `head`.

clean %>% 
  group_by(bp) %>% 
  summarize(n=n_distinct(symbol)) %>% 
  arrange(desc(n)) %>% 
  head(10)

clean %>% 
  group_by(mf) %>% 
  summarize(n=n_distinct(symbol)) %>% 
  arrange(desc(n)) %>% 
  head(10)

#' 3. How many distinct genes are there where we know what process the gene is involved in but we don't know what it does? _Hint:_ 3 pipes; `filter` where `bp!="biological process unknown" & mf=="molecular function unknown"`, and after `select`ing columns of interest (symbol, bp, mf), pipe the output to `distinct()`. The answer should be **737**

clean %>% 
  filter(bp!="biological process unknown" & mf=="molecular function unknown") %>% 
  select(symbol, bp, mf) %>% 
  distinct()

#' 4. When the growth rate is restricted to 0.05 by limiting Glucose, which biological processes are the most upregulated? Show a sorted list with the most upregulated BPs on top, displaying the biological process and the average expression of all genes in that process rounded to two digits. _Hint:_ 5 pipes: `filter`, `group_by`, `summarize`, `mutate`, `arrange`.
#' 
clean %>% 
  filter(nutrient=="Glucose" & rate==.05) %>% 
  group_by(bp) %>% 
  summarize(meanexp=mean(expression)) %>% 
  mutate(meanexp=round(meanexp, 2)) %>% 
  arrange(desc(meanexp))

