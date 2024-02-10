da <- read.csv('C:/Users/DELL/Downloads/proportional_species_richness_V3.csv')
library(dplyr)
head(da)
#Choosing my BD7
BD7 <- subset(da, select = c(Bees, Isopods,Grasshoppers_._Crickets,Butterflies, Bryophytes,Carabids,Ladybirds))
head(BD7)
BD11<-da[,2:12]
head(BD11)
da$BD11<-rowMeans(BD11)
da$BD7<- rowMeans(BD7)

#Data Exploration: Univariate Analysis

#First, let's look at the summary statistics for each variable:
summary(BD7)
library(ggplot2)
library(tidyverse)
library(corrplot)
#Next, look at some graphical representations of the data
BD7 %>%
  gather(key = "taxonomic_group", value = "proportional_species_richness") %>%
  ggplot(aes(x = proportional_species_richness, fill = taxonomic_group)) +
  geom_histogram(alpha = 0.5, position = "identity", bins = 10) +
  facet_wrap(~ taxonomic_group, ncol = 3) +
  labs(x = "Proportional Species Richness", y = "Frequency")
library(corrplot)

library(tidyverse)
# compute correlation matrix
corr_matrix <- cor(BD7)


# visualize correlation matrix
corrplot::corrplot(corr_matrix, method = "color", type = "lower", tl.col = "black")

#Hypothesis Testing

# Test 1: Mean proportional species richness for butterflies vs isopods
butterflies <- BD7$Butterflies
isopods <- BD7$Isopods
t.test(butterflies, isopods, alternative = "two.sided")

# Test 2: Proportional species richness for first five samples vs last five samples
first_five <- rowMeans(BD7[1:5,])
last_five <- rowMeans(BD7[10:14,])
t.test(first_five, last_five, paired = TRUE, alternative = "two.sided")

#Simple Linear Regression

# Perform simple linear regression for the entire dataset

model <- lm(BD11 ~ Bees + Isopods + Grasshoppers_._Crickets + Butterflies + Bryophytes + Carabids + Ladybirds, data = da)

# Print the model summary
summary(model)

# Split the data into subsets based on period
da_by_period <- split(da, da$period)

# Loop through the subsets and fit a separate linear regression model to each
for (i in 1:length(da_by_period)) {
  period_data <- da_by_period[[i]]
  model <- lm(BD11 ~ Bees + Isopods + Grasshoppers_._Crickets + Butterflies + Bryophytes + Carabids + Ladybirds, data = period_data)
  print(paste0("Period ", i, ":"))
  print(summary(model))
  print(coef(model))
}
#Multiple Linear Regression

BD4 <- select(BD11, -Grasshoppers_._Crickets, -Butterflies, -Bryophytes, -Carabids,-Ladybirds, -Isopods, -Bees)
da$BD4 <- rowMeans(BD4)
#summarize_all(mean)

model <- lm(BD4 ~ BD7 , data = da)

summary(model)

#AIC
#Create a full model with all predictors
BD4 <- subset(BD11, select = c(Bird, Hoverflies, Macromoths,Vascular_plants))
full_model <- lm(BD4$Hoverflies ~ BD7$Bees + da$Bird + da$Macromoths + da$Vascular_plants + da$Easting + da$Northing + da$period)

# Perform stepwise regression
step_model <- step(full_model, direction="backward")
final_model=full_model <- lm(BD4$Hoverflies ~ BD7$Bees + da$Bird + da$Macromoths + da$Vascular_plants + da$Easting + da$Northing)
summary(final_model)



#Open Analysis
new_df=subset(da, period == 'Y70')
summary(new_df)
new_df=subset(da, period == 'Y00')
summary(new_df)


#Creating a boxplot for open analysis
ggplot(da, aes(x= Bees,y=period))+
  geom_boxplot()

# Additional
#First, we need to create two subsets of the data for each period
Y00_data <- da[da$period == "Y00",]
Y70_data<- da[da$period == "Y70",]
#Next, we can perform a t-test using the t.test() function
t.test(Y00_data$Bees, Y70_data$Bees, var.equal = TRUE)
