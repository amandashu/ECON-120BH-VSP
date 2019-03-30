# libraries
library(dplyr)
library(stringr)

# get data
cape = read.csv("cape-1-20.csv", header=TRUE)

# rename columns
colnames(cape) <- c("instructor","course","term","num_enrolled","num_evals",
                     "rec_class","rec_instr","study_hrs","grade_exp","grade_rec")

# unique instructors
profs <- unique(cape[[1]])
num_profs <- length(profs)

# create dataframe with experience
new_cape <- data.frame()
for (i in 1:num_profs){
  df <- cape %>% filter(instructor==profs[i])
  df$experience <- seq(nrow(df),1,-1)
  new_cape <- rbind(new_cape,assign(paste0("prof", i),df))
}

# change rec_instr, rec_class to integers
new_cape$rec_instr <- as.integer(str_sub(new_cape$rec_instr, 1, str_length(new_cape$rec_instr)-1))
new_cape$rec_class <- as.integer(str_sub(new_cape$rec_class, 1, str_length(new_cape$rec_class)-1))

# change course to have only course numbers
#new_cape$course <- as.character(new_cape$course)
new_cape$course <- str_sub(new_cape$course, 1, str_locate(new_cape$course," - ")[,1]-1)
new_cape$course <- str_replace(new_cape$course," ","")
new_cape$course <- str_to_lower(new_cape$course)

# change grade_exp and grade_rec to numbers
new_cape$grade_exp <- str_sub(new_cape$grade_exp,str_locate(new_cape$grade_exp," \\(")[,1]+1)
new_cape$grade_exp <- as.numeric(str_sub(new_cape$grade_exp, 2, str_length(new_cape$grade_exp)-1))
new_cape$grade_rec <- str_sub(new_cape$grade_rec,str_locate(new_cape$grade_rec," \\(")[,1]+1)
new_cape$grade_rec <- as.numeric(str_sub(new_cape$grade_rec, 2, str_length(new_cape$grade_rec)-1))

# unique courses
course <- unique(new_cape$course)
num_courses <- length(course)

# add indicator variables for each course
for (i in 1:num_courses) {
  tf <- c()
  for (j in 1:nrow(new_cape)){
    if (new_cape[j,2]==course[i]) {
    tf <- c(tf,1) 
    } else {
    tf <- c(tf,0) 
    }
  }
  new_cape[course[i]] <- tf
}

# delete comma in instructor
new_cape$instructor <- str_replace(new_cape$instructor, ",", "")

# to csv file
new_cape <- as.matrix(new_cape)
write.csv(new_cape,"new_cape.csv")

