clear all

cd "/Users/bhavyapandey/Desktop/Spring 2024/ECON 16700 TA/Week 8"

import delimited "fixedeffects.csv", clear //Note: this is a madeup dataset. In your problem set, you will be using data from an actual school district.

//If you are having difficulty accessing data from the Remote Desktop, please use the following command: 
// use "https://fulyaeg.github.io/fixedeffects.dta", clear 

log using "fixedeffectsexample.smcl", replace

// Method 1:
// Generate dummy variables for each student and store in Dstudent*
tab student, gen(Dstudent)

// Generate dummy variables for each teacher and store in Dteacher*
tab teacher, gen(Dteacher)

// Generate dummy variables for each year and store in Dyear*
tab year, gen(Dyear)

// Run a linear regression of testscore on student, teacher, and year dummies. 
// The star (*) after variable prefixes includes all variables that start with that prefix. 
// It's a way to include all student, teacher, and year dummies in the model without listing each one.
reg testscore Dstudent* Dteacher* Dyear*, hascon


// Method 2:
// Declare the data as panel data (examine why) with 'teacher' as the panel identifier
xtset teacher

// Run a fixed-effects regression to analyze the impact of lagged test scores and year effects on current test scores
xtreg testscore lagtestscore Dyear*, fe //Note: you need to create year dummies before running this regression if they weren't created before 

// After running the fixed-effects model, predict the individual effects (or residuals) for each teacher
// This represents the teacher-specific random component not explained by the model.
predict testscorePredicted, u

// Create a unique identifier for the first observation within each panel group (teacher in this case). 
egen teacherUnique=tag(teacher) 

// Summarize the predicted teacher-specific effects for the first teacher
su testscorePredicted if teacherUnique==1, detail

log close
