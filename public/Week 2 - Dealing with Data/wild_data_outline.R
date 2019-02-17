#Instructor: David Martin
#Taming Wild Data
#9/24/2018
#dnm5ca@virginia.edu

#Let's start by creating a new project:


#The tidyverse should be the only package we need today.
#Remove the # if you need to install the tidyverse
  install.packages("tidyverse")
  library(tidyverse)
  
  nhanes <- read_csv("nhanes_w_notes.csv")

  class(nhanes)
  View(nhanes)
######## FILTER WITH DPLYR ############
#Selects the rows you want to look at based off of certain criteria.
  filter(nhanes, Gender == "female")
  filter(nhanes, TotChol > 4)

# Remove those who have not a value entered for Gender
  nhanes <- filter(nhanes, Gender == "male" | Gender == "female")  
  
# Remove those with an unknown marital status
  nhanes <- filter(nhanes, MaritalStatus != "Unknown")

# Keep those who have a poverty level greater than 1
  nhanes <- filter(nhanes, Poverty > 1)

# Watch out for those with unreasonably high or low Cholestorol levels
  nhanes <- filter(nhanes, HDLChol > 0 & HDLChol < 10)  
  nhanes <- filter(nhanes, TotChol > 0 & TotChol < 10)
View(nhanes)
  
#######################################
######## SELECT FROM DPLYR ############
#######################################
#Selects the columns you want to look at.
  select(nhanes, Patient_ID, TotChol)
  select(nhanes, -Patient_ID, -TotChol)  

#We are going to separate out our dataframe into three separate dataframes
  #One for only our Notes
  notes <- select(nhanes, Notes)
  notes
  
  #One for the Demographic Data
  demo <- select(nhanes, -Notes, -Diagnoses)
  demo
  
  #One for only the Diagnoses
  diagnoses <- select(nhanes, Diagnoses)
  diagnoses
  
###########################################
  #EXERCISE 1: Return a valid result (no negative values) for a patient that was satisfied. Return only the result and no other columns.

  classification <- c("Patient", "Doctor", "Patient", "Patient", "Doctor")
  satisfied <- c("no", "yes", "no", "yes", "yes")
  results <- c(513, 13, -1, 516, 510)
  
  ex1 <- data.frame(classification, satisfied, results)
  
  #1. Keep only the Patients
  
  
  #2. Get rid of those that have a negative results value
  
  
  #3. Drop the patient who was not satisfied
  
  
  #4. Select the results
  
###########################################
  #####STRINGR and Regular Expressions#######
  #Our first step today is to look at how we can manipulate and transform strings and other variables into valid and useful data. 
  

  #All stringr functions start with str_ followed by a descriptive word
#Here are a few functions we will be using:
  
  #str_length - Find the length of a string (The number of characters)
  

  #paste/paste0 - combines/concatenates strings together 
  
  #default seperator is a " "
  
  
  #Separator can be changed
  
  
  #Notice no separator with paste0
  
  
  #can also create a combined string using numbers
  
  
  #str_count - Count the number of matches in a string.
  test_string <- "There are 3 3s in this. 3 I say"
  
  
  ###############################
  #     REGULAR EXPRESSIONS     #
  ###############################
  # Regular Expression Basics -----------------------------------------------
  
  #http://uc-r.github.io/regex  
  #https://regex101.com/
  #http://www.cheatography.com/davechild/cheat-sheets/regular-expressions/
  #http://regexlib.com/CheatSheet.aspx
  
  #Thanks to Clay Ford for some of the notes regarding Regular Expressions.
  
  # Regular expressions are composed of three components:
  
  # (1) literal characters
  # (2) modifiers (or metacharacters)
  # (3) character classes
  
  # (1) LITERAL CHARACTERS 
  
  # These are the literal characters you want to match. If you want to find the
  # word "factor", you search for "factor", the literal characters.
  
  # (2) MODIFIERS
  
  # Modifiers define patterns;
  # meet the modifiers:
  # $ * + . ? [ ] ^ { } | ( ) \
  
  # precede these with double backslash (in R!) if you want to treat them as
  # literal characters.
  
  # ^  start of string
  # $  end of string
  # .  any character except new line
  # *  0 or more
  # +  1 or more
  # ?  0 or 1
  # |  or (alternative patterns)
  # {} quantifier brackets: exactly {n}; at least {n,}; between {n,m}
  # () group patterns together
  # \  escape character (needs to be escaped itself in R: \\)
  # [] character class brackets (not to be confused with R's subsetting brackets!)
  
  # (3) CHARACTER CLASSES
  # a range of characters to be matched;
  # placed in brackets: []
  # For example: [a-q] means all letters from a - q;
  # [a-zA-Z] means all alphabetic characters;
  # [0-9A-Za-z] means all alphanumeric characters;
  # The ^ symbol means "not" when used in brackets, so [^abc] means "Not (a or b
  # or c)"
  
  # PREDEFINED CHARACTER CLASSES
  
  # [:lower:] - Lower-case letters. [a-z] 
  # [:upper:] - Upper-case letters. [A-Z]
  # [:alpha:] - Alphabetic characters: [:lower:] and [:upper:]. [a-zA-Z]
  # [:digit:] - Digits: 0 1 2 3 4 5 6 7 8 9. [0-9]
  # [:alnum:] - Alphanumeric characters: [:alpha:] and [:digit:]. [0-9A-Za-z]
  # [:punct:] - Punctuation characters: ! " # $ % & ' ( ) * + , - . / : ; < = > ?
  # @ [ \ ] ^ _ ` { | } ~.
  
  # [:blank:] - Blank characters: space and tab, and possibly other
  # locale-dependent characters such as non-breaking space.
  
  # [:space:] - Space characters: tab, newline, vertical tab, form feed, carriage
  # return, space and possibly other locale-dependent characters.
  
  # More regex codes! (Yay! More stuff!) Be sure to escape that backslash!
  
  # \b - Word boundary
  # \d - any decimal digit
  # \w - any word character
  # \s - any white-space character
  # \n - a New line
  
   #Number of numbers
   #Number of Punctuation Marks
   #Number of letters
   #Can combine these codes
   #Number of letters
 
   
  #Number of letters or numbers

  #str_replace() replaces a single matching pattern, str_replace_all() replaces all matching patterns
  
  #Replacing a 3 with a 4, just once.
  
  #Replacing a 3 with a 4, any time a 3 occurs
  
  
  #Using a regular expression
  
  
  #str_extract(), str_extract_all() - Returns the matching pattern
  
  
  #str_split - essentially the opposite of paste and splits at certain character(s)
  #str_split(string_var, pattern)
  
  
  #Unlists turns from list to vector
  
  
  #str_split_fixed - explicitly tells R how many times to split.
  #str_split_fixed(string, pattern, number)
   
  
  #Subset strings - Allows you to pull out portions of strings.
  #str_sub - Extract substrings from a character vector.
  #str_sub(string_var , startPos, stopPos)
  
  # You can also assign character vectors to a substring
  
   #Replace the string from position 6 to 9 with the assigned string
  
    
  ####SOMETHING WITH MODIFIERS HERE
  # OR |, {n} - number of times, etc.
  # Lookahead, lookbehind ?<==, etc...
  
  #LAST THING 
  
  
  #OR
  
  
  #Take all matching 
  
  #consecutive
  
  
  #start/end of string
  View(nhanes)
  
  ############# EXERCISE  ##############
  #1. Create a variable called GenderMarital that combines together the Insured column and the 
  #   Diabetes column from the nhanes dataset. Use a comma as the separator.
  #   Return the length of this new variable
  
  
  #2. Convert this new string to all uppercase characters using str_to_upper
  
  
  #3. Detect if the following substrings are in the GenderMarital variable
    # m
    # : 
    # M
    # \\d
    # .
    # \\.
  
  #######################################
  #Let's Take a break
  #####################################
  
  #####################################
  ######## STARTING ON NOTES ##########
  #####################################
  #How can we simplify this? Any patterns?
  

  #First, let's count the number of commas

  
  #We can see there are 7, so we need to split 7 times 

    
  #Notice it only goes to the last comma, so we need to add one to the end

  #Need to reattach this split dataframe to the notes.

  
#Rename function in DPLYR
  #V1

  #V2

  #V3 - few ways to change this

    #One more way using a new regex modifier

    #Another way to assign a new name to a column

    ############Exercise: Create the Fever Variable ###############
    #Use whatever method you think would be easiest/most efficient.
    
    
    #V5 - Address, V6 - City
    
    
    #V7 (What can we do here?)
    #What seems to be the matter when we split?
    
    #Let's first try this. 
    
    #bind_cols - adds columns to the end of a dataframe
    
    #Finalize by dropping the Notes Column
    
    
####################################################################   
  ###Let's now combine our notes and demo back together.
    

    #Combines the dataframes by a common variable and only keeps the rows that have data in both datasets.

    #### We can now run things like ttests, ANOVAS, Regressions on this new dataset.
    

  ########################
    #Back to dplyr
  ########################
    #Select helps with reordering columns

    #Filter to look through values

    ### THE PIPE ###
    # Using the pipe with filter

    # Combining Filter and Select

    #### DPLYR EXERCISE 1 #####
    # 1. Using filter and select, display the Age, Gender, MaritalStatus, and Fever where the patient is married and lives in Virginia 
    #    (Answer should return a 4-by-4 tibble/dataframe).

    # 2. Display the patient data where the TotChol ishigh (in the top 20% of all patients). 
    #    _Hint:_ see `?quantile` and try `quantile(nd$TotChol, probs=.80, na.rm = TRUE) 
    #    to see the TotChol value which is higher than 80% of all the data, then `filter()` based on that. 
    #    Use Select to look at the Age, Gender, and HDLChol for these patients. 
    #    Answer should return a 3-by-3 tibble/data frame.

    #----------------------------------------------------------#
    
  
    # mutate - changes or creates a new variable/column
  
    
    # mutate using a function
  
    
    # mutate using a conditional
  
  
    # mutate with the pipe
  
    #### DPLYR EXERCISE 2 #####
    
    # 1. Using Mutate, create an indicator (LowPov) for those patients that have a Poverty Level less than 2 (Poverty).
    
    # 2. Filter using the LowPov indicator and Select the Age, TotChol, and Fever variables
    
    # 3. Using mutate, create a "Low", "Medium", and "High" indicator (HDLChol_cat) 
    # for the TotChol variable ranging from 0 to 4, 4 to 5, and 5 and above. 
    # Use select and View() to show Age, Gender, TotChol and TotChol_cat.
    
    
    #----------------------------------------------------------#
    
    # summarize - Applies a function to a group  
    # group_by - Tells a function which group(s) to act upon
    # Look at cheatsheet (Help -> Cheatsheets -> Data Manipulation with DPLYR, TidyR) for small list of functions you can use in R
    
    #Can use Group by to group by one variable
    
    #...Or multiple variables
    
    #Advantage of using the Pipe 
    #Old Way
    select(filter(summarize(group_by(nd, Gender, MaritalStatus), mean_size = mean(Age, na.rm = TRUE), min_HDLChol = min(HDLChol)), !is.na(min_HDLChol)), Gender, mean_size, min_HDLChol)
    
    #Pipe Way

    
    
    ######DPLYR EXERCISE#####
    #1. When the poverty level is less than 4, what is the average Fever across all     #   patients that have High_TotChol, separately for each City? 
    #   _Hint:_ 3 pipes: `filter`, `group_by, `summarize.

  
  ###########################################################
    
    ##GRAPHING##


    #Show only Females

    #Show only those with a Fever greater than 100

    
##HOMEWORK
# LOOKING AT DIAGNOSIS   

  ####################################################
#  Diagnoses
  
  #We now want to try and get variables for Flu, Soft Tissue Sarcoma, and Physical activity.
    #Data would not always be even this neat, these may be input in a different order, or something of that nature.
  #Separated by periods it appears. 
  str_split_fixed(Diagnoses, "\\.", 3)
  
  #Looks good, first element seems to be flu related, second element seems to be sarcoma, and third is physical activity
  #Since we used fix, we have a list with a consistent number of objects within each list element.
  
  diag <- as.data.frame(str_split_fixed(diagnoses, "\\.", 3))
  
  #Let's look at the Flu. Any common patterns seen??
  diag$V1
  str_detect(diag$V1, "flu|Flu")
  
  str_detect(diag$V1, "flu|Flu|inf|Inf")
  
  #Usually a good idea to make sure you account for any option.
  diag$Flu <- ifelse(str_detect(diag$V1, "no|No"), "No", ifelse(str_detect(diag$V1, "^[\\s]*$"), NA, "Yes")) #^[\\s]*$ finds a vector with only blank spaces
  diag$Flu
  table(diag$V1, diag$Flu)
  
  #Let's move on to Sarcoma
  diag$V2
  str_extract(diag$V2, "sarc")
  str_count(diag$V2, "sarc")
  str_count(diag$V2, "oma")
  
  diag$V2 <- str_to_lower(diag$V2)
  diag$sarc <- ifelse(str_detect(diag$V2, "no"), "No", ifelse(str_detect(diag$V2, "^[\\s]*$"), NA, "Yes")) #^[\\s]*$ finds a vector with only blank spaces
  View(diag)
  #Any issues here?
  table(diag$V2, diag$sarc)
  
  
  #Let's check out Physical Activity
  diag$V3
    #Any patterns?
  diag$PhysActive <- ifelse(str_detect(diag$V3, "([[:digit:]])"), "Yes", ifelse(str_detect(diag$V3, "^[\\s]*$"), NA, "No")) #^[\\s]*$ finds a vector with only blank spaces
  diag$PhysActive
  
  ########EXERCISE#######
  #Create a variable called PhysActiveDays within the diag dataframe that 
  #contains the number of days they were active and NA otherwise.
  diag$PhysActiveDays <- diag$V3 %>%
      str_extract("[:digit:]")  %>% 
      as.numeric()

  