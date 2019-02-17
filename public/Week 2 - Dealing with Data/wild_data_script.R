#Instructor: David Martin
#Taming Wild Data
#9/24/2018
#dnm5ca@virginia.edu

#The tidyverse should be the only package we need today.
#Remove the # if you need to install the tidyverse
#install.packages("tidyverse")
library(tidyverse)

  nhanes <- read_csv("nhanes_w_notes.csv")

######## FILTER WITH DPLYR ############
#Selects the rows you want to look at based off of certain criteria.

# Remove those who have not a value entered for Gender
  nhanes <- filter(nhanes, Gender == "male" | Gender == "female")

# Remove those with an unknown marital status
  nhanes <- filter(nhanes, MaritalStatus != "Unknown") 

# Keep those who have a poverty level greater than 1
  nhanes <- filter(nhanes, Poverty > 1)

# Watch out for those with unreasonably high or low Cholestorol levels
  nhanes <- filter(nhanes, HDLChol > 0 & HDLChol < 10)
  nhanes <- filter(nhanes, TotChol > 0 & TotChol < 10)

#######################################
######## SELECT FROM DPLYR ############
#######################################
#Selects the columns you want to look at.

  select(nhanes, Patient_ID, TotChol)
  select(nhanes, -Patient_ID, -TotChol)
  
#We are going to separate out our dataframe into three separate dataframes
  #One for only our Notes
  notes <- select(nhanes, Notes)
  
  #One for the Demographic Data
  demo <- select(nhanes, -Notes, -Diagnoses)
  
  #One for only the Diagnoses
  diagnoses <- select(nhanes, Diagnoses)

###########################################
  #EXERCISE 1: Return a valid result (no negative values) for a patient that was satisfied. Return only the result and no other columns.

  classification <- c("Patient", "Doctor", "Patient", "Patient", "Doctor")
  satisfied <- c("no", "yes", "no", "yes", "yes")
  results <- c(513, 13, -1, 516, 510)
  
  ex1 <- data.frame(classification, satisfied, results)
  
  #1. Keep only the Patients
  ex1.1 <- filter(ex1, classification == "Patient")
  
  
  #2. Get rid of those that have a negative results value
  ex1.2 <- filter(ex1.1, results > 0)
  
  #3. Drop the patient who was not satisfied
  ex1.3 <- filter(ex1.2, satisfied == "yes")
  
  #4. Select the results
  ex1.4 <- select(ex1.3, results)
  View(ex1.4)
  
###########################################
  #####STRINGR and Regular Expressions#######
  #Our first step today is to look at how we can manipulate and transform strings and other variables into valid and useful data. 
  View(notes)

  #All stringr functions start with str_ followed by a descriptive word
#Here are a few functions we will be using:
  
  #str_length - Find the length of a string (The number of characters)
  str_length("This is ??? many characters long")

  #paste/paste0 - combines/concatenates strings together 
  
  #default seperator is a " "
  paste("one good turn", "deserves another", sep = " ") 
  
  #Separator can be changed
  paste("State", "VA", sep = ": ") 
  
  #Notice no separator with paste0
  paste0("one good turn", "deserves another")
  
  #can also create a combined string using numbers
  bp <- paste(120, 80, sep = " over ")
  bp 
  
  month <- 5
  day <- 30
  year <- 2018
  date <- paste(month, day, year, sep = "/")
  
  #str_count - Count the number of matches in a string.
  test_string <- "There are 3 3s in this. 3 I say"
  
  str_count(test_string, "3")
  str_count(test_string, "re")
  str_count(test_string, "I") #Case Sensitive
  str_count(test_string, "There")
  
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
  
  str_count(test_string, "\\d") #Number of numbers
  str_count(test_string, "[:punct:]") #Number of Punctuation Marks
  str_count(test_string, "[:alpha:]") #Number of letters
  str_count(test_string, "[:punct:][:punct:]") #Can combine these codes
  str_count(test_string, "\\d[:alpha:]") #Number of letters
  test_string
  
  str_count(test_string, "\\w") #Number of letters or numbers

  #str_replace() replaces a single matching pattern, str_replace_all() replaces all matching patterns
  
  #Replacing a 3 with a 4, just once.
  str_replace(test_string, "3", "4") 
  #Replacing a 3 with a 4, any time a 3 occurs
  str_replace_all(test_string, "3", "4") 
  
  #Using a regular expression
  str_replace_all(test_string, "\\d", "three")
  
  #str_extract(), str_extract_all() - Returns the matching pattern
  str_extract(test_string, "\\d")
  str_extract_all(test_string, "\\d\\w")
  str_extract_all(test_string, "[:alpha:][:punct:]")
  
  #str_split - essentially the opposite of paste and splits at certain character(s)
  #str_split(string_var, pattern)
  str_split(date, "/")
  
  #Unlists turns from list to vector
  unlist(str_split(date, "/")) 
  
  str_split("867-5309", "-")
  
  str_split(bp, " over ")
  
  #str_split_fixed - explicitly tells R how many times to split.
  #str_split_fixed(string, pattern, number)
  test_string
  str_split(test_string, "3")
  str_split_fixed(test_string, "3", 3) 
  
  #Subset strings - Allows you to pull out portions of strings.
  #str_sub - Extract substrings from a character vector.
  #str_sub(string_var , startPos, stopPos)
  str_sub(test_string, 1, 6)
  
  # You can also assign character vectors to a substring
  str_sub(test_string, 6, 9) <- "not" #Replace the string from position 6 to 9 with the assigned string
  test_string
    
  ####SOMETHING WITH MODIFIERS HERE
  # OR |, {n} - number of times, etc.
  # Lookahead, lookbehind ?<==, etc...
  
  #LAST THING 
  test_string <- "There are 3 3s in this. 3 I say"
  
  #OR
  str_detect(test_string, "1|4")
  str_detect(test_string, "3|4")
  str_detect(test_string, "d|f")
  str_detect(test_string, "e|f")
  
  #Take all matching 
  str_extract("the two g's in a row gg", "\\w*")
  str_extract(test_string, "[:alpha:][:punct:]")
  str_extract(test_string, "[:alpha:]*[:punct:]")
  
  #consecutive
  str_detect("the two g's in a row gg", "g{3}")
  str_detect("the two g's in a row gg", "g{2}")
  str_detect("the two g's in a row gg", "g{2,3}")
  
  
  #start/end of string
  str_detect(test_string, "t")
  str_detect(test_string, "^t")
  str_detect(test_string, "^T")
  str_detect(test_string, "t$")
  str_detect(test_string, "\\.$")
  str_detect(test_string, "\\y$")
  
  View(nhanes)
  
  ############# EXERCISE  ##############
  #1. Create a variable called GenderMarital that combines together the Gender column and the 
  #   MaritalStatus column from the nhanes dataset. Use a comma as the separator.
  #   Return the length of this new variable
  GenderMarital <- paste(nhanes$Gender, nhanes$MaritalStatus, sep = ", ")
  ID_length <- str_length(GenderMarital)
  
  #2. Convert this new string to all uppercase characters using str_to_upper
  GenderMarital <- str_to_upper(GenderMarital)
  
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
  View(notes)

  
  #First, let's count the number of commas
  str_count(notes$Notes,",")
  
  #We can see there are 7, so we need to split 7 times 
    View(str_split_fixed(notes$Notes, ",", 7))
    
  #Notice it only goes to the last comma, so we need to add one to the end
    split_df <- str_split_fixed(notes$Notes, ",", 8)
    split_df <- as.data.frame(split_df)
    View(split_df)
  #Need to reattach this split dataframe to the notes.
  notes <- bind_cols(split_df, notes)
  View(notes)
  
#Rename function in DPLYR
  #V1
  notes <- rename(notes, Patient_ID = V1)
    View(notes)
    
  #V2
  notes <- rename(notes, Age = V2)
    View(notes)
  notes$Age <- as.numeric(notes$Age)
  
  #V3 - few ways to change this
    str_extract(notes$V3, "Yes|No")
    str_replace(notes$V3, "Diabetes: ", "")
  
    #One more way using a new regex modifier
    V3_value <- str_extract(notes$V3, "(?<=: )Yes|No") # ": " followed by Yes or no
    V3_name <- unlist(str_split(notes$V3, ":"))[1]
    V3_name #Notice the spaces around the name
    
    str_trim(" test ")
    
    V3_name <- str_trim(V3_name)
    View(notes)
    
    #Another way to assign a new name to a column
    names(notes)[names(notes) == "V3"] <- V3_name
    
    notes$Diabetes <- V3_value
    View(notes)  

    ############Exercise: Create the Fever Variable ###############
    #Use whatever method you think would be easiest/most efficient.
    V4_name <- str_extract(notes$V4, "[:alpha:]*(?=: )")
    V4_name <- str_trim(V4_name)
    
    names(notes)[names(notes) == "V4"] <- V4_name[1]
    
    V4_value <- str_extract(notes$Fever, "(?<=: )\\d*")
    V4_value <- as.numeric(V4_value)

    notes$Fever <- V4_value
    View(notes)
    
    #V5 - Address, V6 - City
    names(notes)[names(notes) == "V5"] <- "Address"
    notes <- rename(notes, City = V6)
    notes$Address <- str_replace(notes$Address, "Address: ", "")
    View(notes)
    
    #V7 (What can we do here?)
    #What seems to be the matter when we split?
    str_split(notes$V7, " ")
    
    #Let's first try this. 
    str_split(str_trim(notes$V7), " ")
    
    notes_split <- notes$V7 %>% 
      str_trim() %>% 
      str_split_fixed(" ", 2) %>% 
      as.data.frame()
    
    #bind_cols - adds columns to the end of a dataframe
    notes <- bind_cols(notes, notes_split)
    notes <- select(notes, -V7)
    
    notes <- rename(notes, State = V1, ZipCode = V2, Email = V8)
    
    #Finalize by dropping the Notes Column
    notes <- select(notes, -Notes)
    
####################################################################   ###Let's now combine our notes and demo back together.
    
    View(notes)
    
    #Combines the dataframes by a common variable and only keeps the rows that have data in both datasets.
    inner_join(notes, demo)
    
    class(demo$Patient_ID)
    demo$Patient_ID <- as.factor(demo$Patient_ID)
    
    nd <- inner_join(notes, demo)
    View(nd)
  
    #### We can now run things like ttests, ANOVAS, Regressions on this new dataset.
    
    t.test(nd$Fever~nd$Gender)
    View(nd)
    aov(Fever ~ MaritalStatus, data = nd)
    
    lm(Fever ~ HDLChol + TotChol, data = nd)
    
  ########################
    #Back to dplyr
  ########################
    #Select helps with reordering columns
    nd <- select(nd, "Patient_ID", "Gender", "Poverty", "Fever", "TotChol", "HDLChol", everything())
    nd
      
    #Filter to look through values
    filter(nd, Fever >= 100)
    filter(nd, Diabetes == "Yes" & Fever >= 100)
    
    ### THE PIPE ###
    # Using the pipe with filter
    nd %>% 
      filter(Fever >=  100)
    
    nd_HF_Diabetes <- nd %>% 
      filter(Fever >=  100) %>% 
      filter(Diabetes == "Yes")
    View(nd)
    View(nd_HF_Diabetes)
    
    # Combining Filter and Select
    nd %>% 
      filter(Diabetes == "No") %>% 
      select(Patient_ID, Age, TotChol) %>%
      View()
    
    #### DPLYR EXERCISE 1 #####
    # 1. Using filter and select, display the Age, Gender, MaritalStatus, and Fever where the patient is married and lives in Virginia 
    #    (Answer should return a 4-by-4 tibble/dataframe).
    nd %>%
      filter(MaritalStatus == "Married" & State == "VA") %>%
      select(Age, Gender, MaritalStatus, Fever)  %>% 
    
    # 2. Display the patient data where the TotChol ishigh (in the top 20% of all patients). 
    #    _Hint:_ see `?quantile` and try `quantile(nd$TotChol, probs=.80, na.rm = TRUE) 
    #    to see the TotChol value which is higher than 80% of all the data, then `filter()` based on that. 
    #    Use Select to look at the Age, Gender, and HDLChol for these patients. 
    #    Answer should return a 3-by-3 tibble/data frame.
    nd %>%
      filter(TotChol >= quantile(TotChol, probs=.80, na.rm = TRUE)) %>%
      select(Age, Gender, HDLChol)
    
    #----------------------------------------------------------#
    
    
    
    # mutate - changes or creates a new variable/column
    mutate(nd, Chol = HDLChol + TotChol)
    
    # mutate using a function
    mutate(nd, TotChol_mean = mean(TotChol, na.rm = TRUE))
    
    # mutate using a conditional
    nd <- mutate(nd, High_Fever = ifelse(Fever >= 100, "High", "Low"))
  
    # mutate with the pipe
    nd <- nd   %>%  
      mutate(High_TotChol = ifelse(TotChol > 5, "High", "Low"))
  
    #### DPLYR EXERCISE 2 #####
    
    # 1. Using Mutate, create an indicator (LowPov) for those patients that have a Poverty Level less than 2 (Poverty).
    nd <- nd %>%
      mutate(LowPov = ifelse(Poverty < 2, 1, 0))
    # 2. Filter using the LowPov indicator and Select the Age, TotChol, and Fever variables
    nd %>% 
      filter(LowPov == 1) %>%
      select(Age, TotChol, Fever)
    
    # 3. Using mutate, create a "Low", "Medium", and "High" indicator (HDLChol_cat) 
    # for the TotChol variable ranging from 0 to 4, 4 to 5, and 5 and above. 
    # Use select and View() to show Age, Gender, TotChol and TotChol_cat.
    nd %>%
      mutate(TotChol_cat = ifelse(TotChol >= 0 & TotChol < 4, "Low",
                           ifelse(TotChol >= 4 & TotChol < 5, "Medium", "High"))) %>%
      select(Age, Gender, TotChol, TotChol_cat) %>% 
      View()
    
    #----------------------------------------------------------#
    
    # summarize - Applies a function to a group  
    # group_by - Tells a function which group(s) to act upon
    # Look at cheatsheet (Help -> Cheatsheets -> Data Manipulation with DPLYR, TidyR) for small list of functions you can use in R
    
    summarize(nd, mean(Fever, na.rm = TRUE))
    summarize(nd, IQR(Fever, na.rm = TRUE))
    
    summarize(group_by(nd, Gender), mean(Fever, na.rm = TRUE))
  
    #Can use Group by to group by one variable
    nd %>% 
      group_by(MaritalStatus) %>%
      summarize(n())
    
    #...Or multiple variables
    nd %>% 
      group_by(MaritalStatus, Gender) %>%
      summarize(n())
    
    #Advantage of using the Pipe 
    #Old Way
    select(filter(summarize(group_by(nd, Gender, MaritalStatus), mean_size = mean(Age, na.rm = TRUE), min_HDLChol = min(HDLChol)), !is.na(min_HDLChol)), Gender, mean_size, min_HDLChol)
    
    #Pipe Way
    nd %>%
      group_by(Gender, MaritalStatus) %>%
      summarize(mean_size = mean(Age, na.rm = TRUE), min_HDLChol = min(HDLChol)) %>%
      filter(!is.na(min_HDLChol)) %>%
      select(Gender,MaritalStatus, mean_size, min_HDLChol)
    
    nd %>% 
      filter(Gender == "female" & str_detect(City, "ville")) %>% 
      group_by(High_Fever) %>% 
      summarize(meanexp=mean(TotChol, na.rm = TRUE))
    
    ######DPLYR EXERCISE#####
    #1. When the poverty level is less than 4, what is the average Fever across all     #   patients that have High_TotChol, separately for each City? 
    #   _Hint:_ 3 pipes: `filter`, `group_by, `summarize.
    nd %>% 
      filter(Poverty < 4 & High_TotChol == "High") %>%
      group_by(City) %>%
      summarize(mean(Fever, na.rm = TRUE))
    
  
  ###########################################################
    
  # IF TIME
    ##GRAPHING##
ggplot(nd, aes(x = Fever, y = TotChol)) + geom_point()

    #Show only Females
    ggplot(filter(nd, Gender == "female"), aes(x = Fever, y = TotChol)) + geom_point()
    
    #Show only those with a Fever greater than 100
    ggplot(filter(nd, Fever >= 100), aes(x = Fever, y = TotChol)) + geom_point()
    
    ggplot(nd, aes(x = Gender, y = TotChol)) + geom_violin() + geom_jitter(aes(color = High_Fever), alpha = 1/4) 
    
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

  