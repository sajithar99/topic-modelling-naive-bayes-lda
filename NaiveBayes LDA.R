
#PMRL Chapter 8

#----------------Probabilistic Graphical Models------------
# Refer:
#    Naive Bayes Classifier 8.2.2
#    RStan
#    https://github.com/stan-dev/example-models/blob/master/misc/cluster/naive-bayes/sim-naive-bayes.R
#----------------------------------------------------------
#--------Naive Bayes Classifier Topic----------------------



library(rstan)


#Naive Bayes and LDA RData
#TODO Save as RData and Import

K <-
  4
V <-
  10
M <-
  200
N <-
  1955
z <-
  c(1L, 1L, 2L, 1L, 1L, 3L, 2L, 3L, 1L, 1L, 1L, 1L, 2L, 1L, 1L, 
    2L, 4L, 4L, 1L, 1L, 1L, 1L, 4L, 1L, 2L, 1L, 1L, 1L, 3L, 1L, 3L, 
    1L, 3L, 3L, 3L, 1L, 2L, 1L, 1L, 1L, 2L, 1L, 1L, 1L, 4L, 3L, 2L, 
    1L, 2L, 3L, 1L, 1L, 1L, 1L, 2L, 2L, 1L, 2L, 1L, 1L, 1L, 1L, 1L, 
    1L, 3L, 1L, 3L, 1L, 1L, 1L, 2L, 1L, 1L, 1L, 2L, 1L, 2L, 1L, 2L, 
    1L, 3L, 3L, 2L, 1L, 4L, 1L, 1L, 3L, 4L, 1L, 2L, 2L, 1L, 2L, 3L, 
    1L, 2L, 3L, 4L, 1L, 2L, 3L, 3L, 3L, 1L, 2L, 4L, 3L, 3L, 4L, 1L, 
    1L, 2L, 1L, 1L, 2L, 1L, 1L, 3L, 2L, 4L, 1L, 1L, 2L, 1L, 3L, 1L, 
    1L, 2L, 2L, 4L, 2L, 2L, 1L, 1L, 2L, 4L, 1L, 2L, 2L, 2L, 1L, 2L, 
    2L, 1L, 3L, 1L, 3L, 2L, 2L, 2L, 1L, 1L, 3L, 1L, 1L, 1L, 1L, 1L, 
    1L, 4L, 1L, 1L, 1L, 3L, 2L, 4L, 1L, 1L, 1L, 3L, 1L, 2L, 1L, 1L, 
    1L, 1L, 2L, 1L, 1L, 1L, 3L, 4L, 2L, 3L, 3L, 2L, 1L, 4L, 1L, 3L, 
    1L, 2L, 1L, 1L, 1L, 1L, 3L, 4L, 1L)
w <-
  c(7L, 9L, 5L, 2L, 9L, 1L, 1L, 9L, 6L, 9L, 1L, 10L, 6L, 7L, 2L, 
    3L, 3L, 2L, 9L, 3L, 8L, 10L, 4L, 3L, 6L, 2L, 7L, 1L, 7L, 7L, 
    1L, 6L, 7L, 7L, 1L, 7L, 7L, 4L, 7L, 7L, 4L, 1L, 7L, 6L, 6L, 3L, 
    10L, 5L, 5L, 4L, 5L, 5L, 3L, 5L, 6L, 3L, 6L, 5L, 5L, 3L, 3L, 
    3L, 7L, 9L, 2L, 2L, 9L, 8L, 5L, 8L, 9L, 1L, 7L, 1L, 7L, 7L, 1L, 
    1L, 7L, 7L, 7L, 4L, 7L, 4L, 6L, 4L, 3L, 9L, 6L, 7L, 9L, 9L, 9L, 
    9L, 6L, 3L, 7L, 1L, 1L, 7L, 1L, 4L, 7L, 8L, 1L, 9L, 9L, 6L, 8L, 
    2L, 7L, 7L, 6L, 9L, 1L, 7L, 3L, 7L, 3L, 3L, 3L, 4L, 3L, 9L, 3L, 
    3L, 3L, 1L, 4L, 9L, 10L, 1L, 6L, 7L, 6L, 1L, 7L, 7L, 1L, 3L, 
    1L, 7L, 7L, 6L, 9L, 1L, 7L, 3L, 7L, 7L, 7L, 6L, 3L, 3L, 2L, 8L, 
    3L, 2L, 3L, 3L, 1L, 2L, 3L, 2L, 2L, 1L, 3L, 2L, 9L, 9L, 2L, 10L, 
    2L, 1L, 2L, 2L, 6L, 2L, 1L, 1L, 2L, 2L, 7L, 1L, 5L, 1L, 7L, 7L, 
    7L, 8L, 3L, 5L, 7L, 9L, 7L, 9L, 7L, 7L, 1L, 6L, 1L, 10L, 7L, 
    7L, 7L, 9L, 7L, 6L, 7L, 9L, 7L, 9L, 7L, 7L, 6L, 7L, 1L, 1L, 7L, 
    7L, 1L, 7L, 2L, 2L, 1L, 4L, 2L, 5L, 7L, 2L, 1L, 9L, 4L, 1L, 7L, 
    7L, 9L, 1L, 10L, 7L, 9L, 2L, 2L, 2L, 3L, 3L, 2L, 4L, 3L, 4L, 
    4L, 4L, 4L, 7L, 1L, 6L, 7L, 1L, 7L, 7L, 7L, 1L, 7L, 9L, 4L, 3L, 
    1L, 9L, 1L, 7L, 7L, 9L, 7L, 1L, 7L, 9L, 5L, 5L, 9L, 5L, 5L, 4L, 
    8L, 1L, 9L, 7L, 6L, 7L, 7L, 7L, 9L, 6L, 8L, 5L, 5L, 2L, 9L, 5L, 
    5L, 1L, 5L, 1L, 4L, 9L, 9L, 7L, 2L, 7L, 7L, 7L, 9L, 5L, 3L, 5L, 
    5L, 5L, 6L, 5L, 6L, 1L, 5L, 6L, 3L, 6L, 5L, 4L, 6L, 4L, 3L, 5L, 
    5L, 5L, 7L, 7L, 7L, 7L, 7L, 7L, 5L, 1L, 1L, 7L, 1L, 7L, 9L, 9L, 
    2L, 4L, 2L, 3L, 3L, 4L, 3L, 1L, 1L, 7L, 1L, 4L, 7L, 8L, 7L, 6L, 
    1L, 1L, 9L, 1L, 10L, 3L, 7L, 7L, 1L, 1L, 7L, 2L, 1L, 7L, 7L, 
    9L, 4L, 3L, 3L, 2L, 3L, 3L, 2L, 9L, 3L, 9L, 7L, 9L, 7L, 4L, 1L, 
    1L, 1L, 1L, 1L, 7L, 7L, 3L, 7L, 1L, 2L, 7L, 7L, 7L, 9L, 1L, 1L, 
    7L, 1L, 9L, 7L, 1L, 7L, 9L, 7L, 7L, 6L, 7L, 1L, 2L, 2L, 2L, 1L, 
    9L, 2L, 2L, 1L, 1L, 2L, 6L, 5L, 5L, 5L, 6L, 5L, 6L, 3L, 2L, 5L, 
    5L, 3L, 5L, 5L, 3L, 3L, 8L, 9L, 3L, 3L, 3L, 9L, 4L, 3L, 10L, 
    3L, 2L, 4L, 6L, 7L, 10L, 1L, 10L, 1L, 9L, 7L, 7L, 7L, 3L, 7L, 
    4L, 9L, 4L, 4L, 4L, 3L, 3L, 3L, 6L, 3L, 2L, 2L, 6L, 7L, 6L, 5L, 
    5L, 10L, 3L, 6L, 5L, 5L, 5L, 1L, 9L, 8L, 8L, 7L, 7L, 1L, 7L, 
    7L, 9L, 1L, 3L, 1L, 5L, 10L, 7L, 7L, 6L, 7L, 7L, 7L, 7L, 7L, 
    7L, 1L, 7L, 3L, 1L, 9L, 7L, 7L, 7L, 7L, 8L, 10L, 7L, 2L, 7L, 
    5L, 7L, 4L, 7L, 7L, 9L, 5L, 7L, 6L, 9L, 1L, 6L, 4L, 3L, 2L, 3L, 
    2L, 4L, 4L, 3L, 10L, 2L, 3L, 3L, 3L, 9L, 3L, 3L, 9L, 3L, 2L, 
    4L, 3L, 3L, 6L, 9L, 3L, 3L, 7L, 7L, 1L, 6L, 9L, 3L, 7L, 9L, 3L, 
    7L, 9L, 9L, 3L, 4L, 3L, 4L, 3L, 9L, 4L, 6L, 5L, 1L, 7L, 9L, 1L, 
    7L, 4L, 1L, 7L, 7L, 7L, 6L, 7L, 7L, 7L, 9L, 7L, 1L, 6L, 9L, 7L, 
    9L, 1L, 9L, 3L, 7L, 9L, 7L, 3L, 7L, 7L, 7L, 9L, 3L, 6L, 7L, 8L, 
    7L, 7L, 7L, 7L, 4L, 3L, 7L, 7L, 9L, 7L, 1L, 1L, 1L, 7L, 1L, 7L, 
    9L, 1L, 7L, 6L, 5L, 5L, 10L, 3L, 3L, 6L, 1L, 7L, 7L, 1L, 9L, 
    7L, 1L, 3L, 9L, 7L, 7L, 5L, 5L, 6L, 3L, 5L, 5L, 1L, 5L, 5L, 5L, 
    6L, 3L, 7L, 8L, 8L, 8L, 7L, 4L, 9L, 9L, 6L, 7L, 7L, 7L, 7L, 1L, 
    2L, 7L, 1L, 4L, 9L, 7L, 7L, 6L, 1L, 7L, 7L, 7L, 7L, 7L, 7L, 9L, 
    7L, 9L, 6L, 7L, 9L, 3L, 8L, 3L, 9L, 9L, 2L, 3L, 3L, 3L, 2L, 9L, 
    3L, 7L, 10L, 4L, 7L, 1L, 7L, 1L, 9L, 7L, 7L, 7L, 4L, 7L, 1L, 
    4L, 7L, 7L, 9L, 1L, 7L, 7L, 1L, 7L, 5L, 2L, 4L, 4L, 7L, 7L, 7L, 
    7L, 7L, 9L, 3L, 4L, 4L, 1L, 3L, 3L, 4L, 3L, 3L, 9L, 9L, 3L, 2L, 
    7L, 7L, 7L, 7L, 7L, 7L, 4L, 7L, 7L, 8L, 3L, 6L, 2L, 7L, 10L, 
    3L, 2L, 7L, 8L, 3L, 7L, 1L, 7L, 1L, 7L, 8L, 9L, 1L, 7L, 7L, 7L, 
    7L, 7L, 7L, 3L, 2L, 9L, 3L, 2L, 9L, 7L, 5L, 5L, 5L, 6L, 10L, 
    8L, 5L, 9L, 6L, 1L, 5L, 1L, 5L, 7L, 7L, 3L, 2L, 4L, 3L, 7L, 4L, 
    9L, 2L, 2L, 7L, 1L, 2L, 5L, 3L, 2L, 3L, 4L, 7L, 7L, 9L, 7L, 9L, 
    1L, 1L, 6L, 9L, 5L, 9L, 9L, 2L, 6L, 2L, 10L, 2L, 9L, 1L, 1L, 
    3L, 8L, 7L, 7L, 7L, 1L, 7L, 7L, 7L, 9L, 9L, 7L, 7L, 4L, 9L, 1L, 
    4L, 8L, 5L, 5L, 5L, 5L, 6L, 2L, 1L, 3L, 5L, 1L, 2L, 4L, 7L, 2L, 
    2L, 2L, 2L, 2L, 1L, 9L, 1L, 10L, 1L, 6L, 4L, 3L, 7L, 7L, 1L, 
    7L, 3L, 2L, 6L, 4L, 3L, 2L, 8L, 3L, 3L, 2L, 8L, 2L, 7L, 6L, 3L, 
    8L, 1L, 10L, 2L, 10L, 4L, 3L, 3L, 3L, 7L, 9L, 7L, 7L, 2L, 7L, 
    4L, 3L, 2L, 3L, 5L, 3L, 3L, 9L, 9L, 8L, 5L, 6L, 8L, 3L, 5L, 5L, 
    3L, 1L, 1L, 7L, 1L, 7L, 7L, 7L, 7L, 7L, 1L, 7L, 7L, 3L, 2L, 3L, 
    3L, 2L, 3L, 2L, 2L, 6L, 5L, 5L, 5L, 1L, 2L, 2L, 5L, 5L, 10L, 
    7L, 8L, 7L, 9L, 7L, 7L, 1L, 1L, 8L, 7L, 7L, 2L, 3L, 3L, 7L, 8L, 
    9L, 5L, 6L, 3L, 3L, 5L, 3L, 5L, 5L, 5L, 5L, 5L, 3L, 1L, 6L, 3L, 
    5L, 3L, 5L, 5L, 5L, 3L, 5L, 5L, 5L, 3L, 5L, 5L, 7L, 9L, 4L, 1L, 
    7L, 1L, 7L, 3L, 3L, 5L, 3L, 6L, 3L, 3L, 3L, 2L, 3L, 3L, 3L, 2L, 
    1L, 2L, 2L, 2L, 9L, 9L, 3L, 2L, 3L, 5L, 6L, 9L, 3L, 10L, 5L, 
    5L, 5L, 5L, 6L, 6L, 5L, 2L, 2L, 2L, 3L, 2L, 1L, 2L, 2L, 1L, 5L, 
    9L, 1L, 1L, 7L, 7L, 8L, 9L, 7L, 4L, 1L, 6L, 7L, 1L, 4L, 1L, 3L, 
    3L, 3L, 2L, 2L, 7L, 3L, 2L, 3L, 2L, 2L, 4L, 10L, 2L, 2L, 3L, 
    3L, 8L, 1L, 10L, 8L, 7L, 7L, 6L, 7L, 1L, 7L, 8L, 9L, 7L, 7L, 
    7L, 7L, 7L, 1L, 1L, 1L, 1L, 3L, 7L, 7L, 1L, 7L, 7L, 4L, 3L, 3L, 
    9L, 3L, 7L, 4L, 3L, 7L, 7L, 7L, 7L, 9L, 7L, 9L, 7L, 8L, 4L, 1L, 
    1L, 3L, 10L, 3L, 5L, 3L, 5L, 6L, 6L, 1L, 3L, 3L, 2L, 3L, 2L, 
    7L, 5L, 7L, 4L, 2L, 2L, 1L, 2L, 9L, 1L, 1L, 6L, 2L, 1L, 7L, 7L, 
    3L, 10L, 1L, 7L, 7L, 3L, 1L, 1L, 1L, 2L, 7L, 6L, 1L, 9L, 7L, 
    2L, 2L, 10L, 4L, 10L, 2L, 6L, 7L, 7L, 7L, 4L, 5L, 3L, 5L, 5L, 
    5L, 6L, 8L, 6L, 7L, 7L, 3L, 4L, 7L, 7L, 9L, 4L, 7L, 10L, 6L, 
    1L, 7L, 7L, 7L, 7L, 1L, 7L, 1L, 2L, 1L, 2L, 9L, 2L, 3L, 3L, 3L, 
    10L, 3L, 3L, 3L, 9L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 4L, 2L, 
    7L, 1L, 7L, 4L, 10L, 2L, 2L, 1L, 8L, 4L, 8L, 3L, 3L, 8L, 9L, 
    3L, 3L, 4L, 3L, 3L, 3L, 2L, 6L, 2L, 3L, 4L, 3L, 3L, 2L, 7L, 7L, 
    7L, 6L, 7L, 7L, 10L, 4L, 7L, 3L, 7L, 1L, 7L, 7L, 9L, 9L, 7L, 
    1L, 7L, 4L, 9L, 1L, 9L, 7L, 7L, 3L, 2L, 3L, 9L, 3L, 9L, 3L, 2L, 
    2L, 7L, 8L, 6L, 2L, 2L, 1L, 2L, 2L, 4L, 2L, 6L, 7L, 3L, 1L, 9L, 
    4L, 7L, 3L, 3L, 1L, 3L, 7L, 3L, 3L, 9L, 2L, 3L, 10L, 3L, 10L, 
    3L, 3L, 3L, 3L, 3L, 4L, 2L, 2L, 3L, 3L, 7L, 6L, 7L, 7L, 7L, 7L, 
    7L, 3L, 3L, 5L, 6L, 5L, 9L, 4L, 7L, 9L, 3L, 3L, 9L, 3L, 2L, 9L, 
    7L, 6L, 1L, 7L, 7L, 3L, 7L, 1L, 8L, 7L, 7L, 3L, 5L, 3L, 5L, 5L, 
    6L, 3L, 2L, 7L, 7L, 6L, 7L, 7L, 1L, 7L, 6L, 7L, 1L, 5L, 5L, 5L, 
    7L, 5L, 3L, 3L, 5L, 2L, 3L, 4L, 9L, 3L, 3L, 3L, 2L, 2L, 1L, 3L, 
    2L, 4L, 2L, 3L, 2L, 9L, 3L, 4L, 3L, 3L, 7L, 4L, 3L, 7L, 7L, 2L, 
    1L, 3L, 1L, 7L, 7L, 7L, 1L, 7L, 4L, 7L, 1L, 7L, 7L, 9L, 7L, 6L, 
    7L, 5L, 7L, 1L, 7L, 8L, 6L, 6L, 3L, 5L, 6L, 3L, 5L, 5L, 5L, 5L, 
    5L, 6L, 6L, 5L, 3L, 5L, 5L, 7L, 4L, 7L, 1L, 1L, 4L, 9L, 7L, 7L, 
    7L, 7L, 7L, 2L, 7L, 7L, 1L, 1L, 7L, 1L, 3L, 1L, 6L, 3L, 2L, 9L, 
    1L, 9L, 9L, 7L, 8L, 7L, 6L, 1L, 1L, 7L, 7L, 7L, 7L, 9L, 4L, 9L, 
    7L, 1L, 6L, 8L, 1L, 2L, 2L, 1L, 9L, 7L, 2L, 1L, 2L, 9L, 9L, 6L, 
    7L, 1L, 7L, 7L, 8L, 7L, 10L, 7L, 7L, 7L, 7L, 7L, 1L, 1L, 4L, 
    1L, 7L, 7L, 1L, 1L, 1L, 1L, 7L, 7L, 4L, 7L, 5L, 5L, 6L, 5L, 10L, 
    5L, 5L, 5L, 5L, 5L, 5L, 6L, 6L, 5L, 2L, 3L, 10L, 3L, 3L, 4L, 
    3L, 4L, 2L, 3L, 1L, 1L, 2L, 10L, 1L, 2L, 7L, 7L, 9L, 4L, 6L, 
    7L, 7L, 5L, 1L, 8L, 7L, 6L, 1L, 9L, 1L, 3L, 2L, 3L, 8L, 1L, 7L, 
    7L, 8L, 5L, 7L, 3L, 8L, 8L, 9L, 1L, 9L, 9L, 1L, 9L, 2L, 9L, 6L, 
    5L, 3L, 6L, 6L, 9L, 5L, 4L, 9L, 3L, 5L, 5L, 1L, 5L, 5L, 6L, 7L, 
    7L, 8L, 7L, 1L, 7L, 7L, 7L, 3L, 7L, 6L, 4L, 2L, 2L, 3L, 3L, 2L, 
    3L, 3L, 4L, 3L, 3L, 3L, 3L, 3L, 4L, 7L, 6L, 7L, 9L, 7L, 1L, 7L, 
    4L, 7L, 7L, 7L, 9L, 1L, 4L, 9L, 7L, 7L, 7L, 1L, 7L, 7L, 7L, 1L, 
    6L, 7L, 7L, 1L, 1L, 3L, 7L, 7L, 7L, 6L, 7L, 3L, 5L, 9L, 7L, 7L, 
    7L, 1L, 9L, 7L, 7L, 1L, 3L, 3L, 1L, 3L, 3L, 3L, 4L, 2L, 2L, 3L, 
    3L, 3L, 6L, 1L, 3L, 7L, 3L, 4L, 7L, 7L, 9L, 4L, 6L, 10L, 9L, 
    7L, 6L, 7L, 1L, 2L, 1L, 1L, 7L, 1L, 1L, 7L, 7L, 7L, 7L, 7L, 9L, 
    1L, 7L, 7L, 7L, 9L, 9L, 8L, 10L, 5L, 4L, 5L, 5L, 3L, 5L, 3L, 
    1L, 6L, 8L, 5L, 1L, 4L, 2L, 1L, 2L, 2L, 2L, 1L, 2L, 6L, 2L, 4L, 
    9L, 3L, 3L, 9L, 10L, 3L, 3L, 9L, 6L, 6L, 3L, 8L, 5L, 3L, 5L, 
    3L, 1L, 7L, 4L, 2L, 6L, 3L, 10L, 7L, 8L, 9L, 7L, 7L, 7L, 7L, 
    7L, 2L, 1L, 2L, 2L, 2L, 1L, 5L, 7L, 2L, 2L, 1L, 2L, 9L, 4L, 1L, 
    7L, 7L, 2L, 4L, 7L, 6L, 6L, 10L, 5L, 6L, 5L, 5L, 8L, 9L, 5L, 
    5L, 7L, 1L, 6L, 9L, 7L, 7L, 7L, 3L, 3L, 7L, 3L, 2L, 1L, 3L, 4L, 
    7L, 1L, 7L, 6L, 7L, 7L, 7L, 7L, 4L, 7L, 5L, 9L, 6L, 9L, 4L, 7L, 
    1L, 7L, 7L, 1L, 1L, 7L, 7L, 1L, 7L, 7L, 6L, 7L, 7L, 1L, 7L, 8L, 
    7L, 7L, 9L, 7L, 9L, 7L, 2L, 4L, 9L, 9L, 5L, 5L, 4L, 5L, 1L, 3L, 
    3L, 7L, 5L, 2L, 1L, 7L, 5L, 5L, 9L, 9L, 2L, 2L, 2L, 5L, 5L, 1L, 
    7L, 1L, 7L, 2L, 4L, 7L, 7L, 9L, 1L, 7L, 9L)
doc <-
  c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 3L, 
    3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 
    4L, 4L, 4L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 6L, 6L, 6L, 
    6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 7L, 7L, 7L, 7L, 
    7L, 7L, 7L, 7L, 8L, 8L, 8L, 8L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 
    9L, 9L, 9L, 9L, 9L, 9L, 9L, 10L, 10L, 10L, 10L, 10L, 10L, 10L, 
    10L, 10L, 10L, 10L, 10L, 11L, 11L, 11L, 11L, 11L, 11L, 11L, 11L, 
    11L, 11L, 11L, 11L, 11L, 12L, 12L, 12L, 12L, 12L, 12L, 12L, 13L, 
    13L, 13L, 13L, 13L, 13L, 13L, 13L, 13L, 13L, 13L, 14L, 14L, 14L, 
    14L, 14L, 14L, 14L, 14L, 14L, 14L, 14L, 14L, 14L, 15L, 15L, 15L, 
    15L, 15L, 15L, 15L, 15L, 15L, 15L, 16L, 16L, 16L, 16L, 16L, 16L, 
    16L, 16L, 16L, 17L, 17L, 17L, 17L, 17L, 17L, 17L, 17L, 17L, 17L, 
    17L, 17L, 17L, 18L, 18L, 18L, 18L, 18L, 18L, 18L, 19L, 19L, 19L, 
    19L, 19L, 19L, 19L, 19L, 19L, 19L, 19L, 20L, 20L, 20L, 20L, 20L, 
    20L, 20L, 20L, 21L, 21L, 21L, 21L, 21L, 21L, 21L, 21L, 21L, 21L, 
    21L, 21L, 21L, 21L, 21L, 21L, 21L, 22L, 22L, 22L, 23L, 23L, 23L, 
    23L, 23L, 23L, 23L, 23L, 23L, 23L, 23L, 23L, 23L, 24L, 24L, 24L, 
    24L, 24L, 24L, 24L, 25L, 25L, 25L, 25L, 25L, 25L, 25L, 25L, 25L, 
    25L, 25L, 25L, 25L, 26L, 26L, 26L, 26L, 26L, 27L, 27L, 27L, 27L, 
    27L, 27L, 27L, 27L, 27L, 27L, 27L, 27L, 28L, 28L, 28L, 28L, 28L, 
    28L, 29L, 29L, 29L, 29L, 29L, 29L, 29L, 30L, 30L, 30L, 30L, 30L, 
    30L, 30L, 31L, 31L, 31L, 31L, 31L, 31L, 31L, 31L, 31L, 31L, 31L, 
    32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 32L, 33L, 33L, 33L, 
    33L, 33L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 34L, 35L, 35L, 
    35L, 35L, 35L, 35L, 35L, 36L, 36L, 36L, 36L, 36L, 36L, 36L, 36L, 
    36L, 36L, 36L, 36L, 36L, 36L, 37L, 37L, 37L, 37L, 37L, 37L, 37L, 
    38L, 38L, 38L, 38L, 38L, 38L, 38L, 38L, 38L, 38L, 38L, 39L, 39L, 
    39L, 39L, 39L, 39L, 39L, 39L, 40L, 40L, 40L, 40L, 40L, 40L, 40L, 
    41L, 41L, 41L, 41L, 41L, 41L, 41L, 41L, 42L, 42L, 42L, 42L, 42L, 
    42L, 42L, 42L, 42L, 43L, 43L, 43L, 43L, 43L, 43L, 43L, 43L, 43L, 
    43L, 43L, 43L, 43L, 43L, 43L, 43L, 44L, 44L, 44L, 44L, 44L, 44L, 
    44L, 44L, 44L, 45L, 45L, 45L, 45L, 45L, 45L, 45L, 45L, 45L, 45L, 
    46L, 46L, 46L, 46L, 46L, 46L, 46L, 46L, 46L, 46L, 46L, 46L, 46L, 
    46L, 46L, 47L, 47L, 47L, 47L, 47L, 47L, 47L, 47L, 47L, 47L, 47L, 
    47L, 47L, 48L, 48L, 48L, 48L, 48L, 48L, 48L, 48L, 48L, 48L, 48L, 
    48L, 48L, 48L, 49L, 49L, 49L, 49L, 49L, 49L, 49L, 49L, 49L, 49L, 
    50L, 50L, 50L, 50L, 50L, 50L, 50L, 50L, 50L, 50L, 50L, 51L, 51L, 
    51L, 51L, 51L, 51L, 51L, 51L, 51L, 51L, 51L, 51L, 52L, 52L, 52L, 
    52L, 52L, 52L, 52L, 52L, 52L, 52L, 52L, 52L, 52L, 52L, 52L, 53L, 
    53L, 53L, 53L, 53L, 53L, 53L, 53L, 53L, 53L, 53L, 53L, 53L, 53L, 
    54L, 54L, 54L, 54L, 54L, 54L, 54L, 54L, 54L, 55L, 55L, 55L, 55L, 
    55L, 55L, 55L, 55L, 55L, 55L, 55L, 55L, 55L, 55L, 56L, 56L, 56L, 
    56L, 56L, 56L, 56L, 56L, 56L, 56L, 56L, 57L, 57L, 57L, 57L, 57L, 
    57L, 57L, 57L, 57L, 58L, 58L, 58L, 58L, 58L, 58L, 58L, 58L, 58L, 
    58L, 58L, 59L, 59L, 59L, 59L, 59L, 59L, 59L, 59L, 59L, 59L, 59L, 
    60L, 60L, 60L, 60L, 60L, 60L, 60L, 60L, 60L, 60L, 60L, 60L, 61L, 
    61L, 61L, 61L, 61L, 61L, 61L, 61L, 61L, 62L, 62L, 62L, 62L, 62L, 
    62L, 62L, 62L, 62L, 62L, 63L, 63L, 63L, 63L, 63L, 63L, 63L, 64L, 
    64L, 64L, 64L, 64L, 64L, 64L, 64L, 65L, 65L, 65L, 65L, 65L, 65L, 
    65L, 65L, 66L, 66L, 66L, 66L, 66L, 66L, 66L, 66L, 66L, 66L, 67L, 
    67L, 67L, 67L, 67L, 67L, 67L, 67L, 67L, 67L, 67L, 67L, 67L, 67L, 
    67L, 67L, 67L, 68L, 68L, 68L, 68L, 68L, 68L, 68L, 68L, 69L, 69L, 
    69L, 69L, 69L, 69L, 69L, 69L, 69L, 69L, 69L, 70L, 70L, 70L, 70L, 
    70L, 70L, 70L, 70L, 70L, 70L, 71L, 71L, 71L, 71L, 71L, 71L, 71L, 
    71L, 71L, 71L, 71L, 71L, 71L, 72L, 72L, 72L, 72L, 72L, 72L, 72L, 
    72L, 72L, 72L, 73L, 73L, 73L, 73L, 73L, 73L, 73L, 73L, 73L, 73L, 
    73L, 73L, 73L, 74L, 74L, 74L, 74L, 74L, 74L, 74L, 74L, 74L, 75L, 
    75L, 75L, 75L, 75L, 75L, 75L, 75L, 75L, 75L, 76L, 76L, 76L, 76L, 
    76L, 76L, 76L, 76L, 76L, 76L, 76L, 76L, 76L, 76L, 77L, 77L, 77L, 
    77L, 77L, 77L, 77L, 77L, 77L, 77L, 77L, 78L, 78L, 78L, 78L, 78L, 
    78L, 78L, 78L, 78L, 78L, 78L, 78L, 79L, 79L, 79L, 79L, 79L, 79L, 
    80L, 80L, 81L, 81L, 81L, 82L, 82L, 82L, 82L, 82L, 82L, 82L, 82L, 
    82L, 82L, 82L, 83L, 83L, 83L, 83L, 83L, 83L, 83L, 83L, 83L, 83L, 
    83L, 83L, 83L, 83L, 83L, 83L, 83L, 83L, 84L, 84L, 84L, 84L, 84L, 
    84L, 84L, 84L, 84L, 85L, 85L, 85L, 85L, 85L, 85L, 85L, 85L, 85L, 
    85L, 86L, 86L, 86L, 86L, 86L, 86L, 86L, 87L, 87L, 87L, 87L, 87L, 
    87L, 87L, 87L, 87L, 87L, 87L, 88L, 88L, 88L, 88L, 88L, 88L, 88L, 
    88L, 88L, 88L, 89L, 89L, 89L, 89L, 89L, 89L, 89L, 89L, 89L, 89L, 
    90L, 90L, 90L, 90L, 90L, 90L, 90L, 90L, 90L, 90L, 90L, 91L, 91L, 
    91L, 91L, 91L, 91L, 91L, 91L, 92L, 92L, 92L, 92L, 92L, 92L, 92L, 
    92L, 92L, 92L, 92L, 92L, 92L, 92L, 92L, 92L, 93L, 93L, 93L, 93L, 
    93L, 93L, 94L, 94L, 94L, 94L, 94L, 94L, 94L, 94L, 94L, 94L, 95L, 
    95L, 95L, 95L, 95L, 95L, 96L, 96L, 96L, 96L, 96L, 96L, 96L, 96L, 
    96L, 96L, 96L, 96L, 96L, 97L, 97L, 97L, 97L, 97L, 97L, 97L, 97L, 
    98L, 98L, 98L, 98L, 98L, 99L, 99L, 99L, 99L, 100L, 100L, 100L, 
    100L, 100L, 100L, 100L, 100L, 100L, 100L, 100L, 100L, 101L, 101L, 
    101L, 101L, 102L, 102L, 102L, 102L, 102L, 102L, 102L, 102L, 102L, 
    102L, 103L, 103L, 103L, 103L, 103L, 103L, 103L, 103L, 103L, 103L, 
    104L, 104L, 104L, 104L, 104L, 104L, 104L, 104L, 104L, 105L, 105L, 
    105L, 105L, 105L, 105L, 105L, 106L, 106L, 106L, 106L, 106L, 106L, 
    106L, 106L, 106L, 106L, 106L, 106L, 107L, 107L, 107L, 107L, 107L, 
    107L, 107L, 107L, 107L, 108L, 108L, 108L, 108L, 108L, 109L, 109L, 
    109L, 109L, 109L, 109L, 109L, 109L, 110L, 110L, 110L, 110L, 110L, 
    110L, 110L, 110L, 110L, 110L, 110L, 111L, 111L, 111L, 111L, 111L, 
    112L, 112L, 112L, 112L, 112L, 112L, 112L, 112L, 112L, 113L, 113L, 
    113L, 113L, 113L, 113L, 113L, 113L, 113L, 113L, 113L, 113L, 113L, 
    113L, 113L, 113L, 113L, 113L, 114L, 114L, 114L, 114L, 114L, 114L, 
    114L, 114L, 114L, 114L, 114L, 114L, 115L, 115L, 115L, 115L, 115L, 
    115L, 115L, 115L, 115L, 115L, 115L, 115L, 115L, 115L, 116L, 116L, 
    116L, 116L, 116L, 117L, 117L, 117L, 117L, 117L, 117L, 118L, 118L, 
    118L, 118L, 118L, 118L, 118L, 118L, 118L, 118L, 119L, 119L, 119L, 
    119L, 119L, 119L, 119L, 119L, 120L, 120L, 120L, 120L, 120L, 120L, 
    120L, 120L, 121L, 121L, 121L, 121L, 121L, 121L, 121L, 121L, 121L, 
    121L, 122L, 122L, 122L, 122L, 122L, 122L, 122L, 122L, 123L, 123L, 
    123L, 123L, 123L, 123L, 123L, 123L, 123L, 123L, 124L, 124L, 124L, 
    124L, 124L, 124L, 125L, 125L, 125L, 125L, 126L, 126L, 126L, 126L, 
    126L, 126L, 126L, 126L, 127L, 127L, 127L, 127L, 127L, 127L, 127L, 
    127L, 127L, 127L, 127L, 127L, 128L, 128L, 128L, 128L, 128L, 128L, 
    128L, 128L, 128L, 128L, 129L, 129L, 129L, 129L, 129L, 129L, 129L, 
    129L, 129L, 129L, 129L, 130L, 130L, 130L, 130L, 130L, 130L, 130L, 
    130L, 130L, 130L, 131L, 131L, 131L, 131L, 131L, 131L, 131L, 131L, 
    132L, 132L, 132L, 132L, 132L, 132L, 132L, 133L, 133L, 133L, 133L, 
    133L, 133L, 133L, 133L, 133L, 133L, 133L, 133L, 133L, 133L, 134L, 
    134L, 134L, 134L, 134L, 134L, 134L, 134L, 134L, 134L, 134L, 134L, 
    134L, 134L, 134L, 135L, 135L, 135L, 135L, 135L, 135L, 135L, 135L, 
    135L, 135L, 136L, 136L, 136L, 136L, 136L, 136L, 136L, 137L, 137L, 
    137L, 137L, 137L, 137L, 137L, 137L, 137L, 137L, 137L, 137L, 138L, 
    138L, 138L, 138L, 138L, 138L, 138L, 139L, 139L, 139L, 139L, 139L, 
    139L, 140L, 140L, 140L, 140L, 140L, 140L, 140L, 140L, 141L, 141L, 
    141L, 141L, 141L, 141L, 141L, 141L, 141L, 141L, 142L, 142L, 142L, 
    142L, 142L, 142L, 143L, 143L, 143L, 143L, 144L, 144L, 144L, 144L, 
    144L, 144L, 144L, 144L, 144L, 144L, 145L, 145L, 145L, 145L, 145L, 
    145L, 145L, 145L, 145L, 145L, 145L, 145L, 146L, 146L, 146L, 146L, 
    146L, 146L, 146L, 146L, 147L, 147L, 147L, 147L, 147L, 147L, 147L, 
    147L, 147L, 147L, 148L, 148L, 148L, 148L, 148L, 148L, 148L, 148L, 
    148L, 149L, 149L, 149L, 149L, 149L, 149L, 150L, 150L, 150L, 150L, 
    150L, 150L, 150L, 150L, 150L, 150L, 150L, 150L, 150L, 150L, 151L, 
    151L, 151L, 151L, 151L, 151L, 152L, 152L, 152L, 152L, 152L, 152L, 
    152L, 152L, 152L, 152L, 153L, 153L, 153L, 153L, 153L, 153L, 153L, 
    153L, 153L, 153L, 153L, 154L, 154L, 154L, 154L, 154L, 154L, 154L, 
    154L, 154L, 154L, 154L, 154L, 154L, 154L, 154L, 154L, 154L, 155L, 
    155L, 155L, 155L, 155L, 155L, 155L, 155L, 156L, 156L, 157L, 157L, 
    157L, 157L, 157L, 158L, 158L, 158L, 158L, 158L, 158L, 158L, 159L, 
    159L, 159L, 159L, 159L, 159L, 159L, 159L, 159L, 159L, 159L, 159L, 
    159L, 160L, 160L, 160L, 160L, 160L, 160L, 160L, 160L, 160L, 160L, 
    160L, 160L, 161L, 161L, 161L, 161L, 161L, 161L, 161L, 161L, 161L, 
    162L, 162L, 162L, 162L, 163L, 163L, 163L, 163L, 163L, 163L, 163L, 
    163L, 163L, 164L, 164L, 164L, 164L, 164L, 164L, 164L, 164L, 164L, 
    164L, 164L, 164L, 164L, 164L, 165L, 165L, 165L, 165L, 165L, 165L, 
    165L, 165L, 165L, 165L, 165L, 165L, 165L, 165L, 165L, 165L, 166L, 
    166L, 166L, 166L, 166L, 166L, 166L, 166L, 166L, 167L, 167L, 167L, 
    167L, 167L, 167L, 168L, 168L, 168L, 168L, 168L, 168L, 168L, 168L, 
    168L, 168L, 168L, 168L, 168L, 169L, 169L, 169L, 169L, 169L, 169L, 
    169L, 169L, 169L, 170L, 170L, 170L, 170L, 170L, 170L, 170L, 170L, 
    170L, 170L, 170L, 170L, 170L, 171L, 171L, 171L, 171L, 171L, 171L, 
    171L, 171L, 171L, 171L, 171L, 171L, 171L, 171L, 171L, 171L, 171L, 
    172L, 172L, 172L, 172L, 172L, 172L, 172L, 172L, 172L, 172L, 172L, 
    173L, 173L, 173L, 173L, 173L, 173L, 173L, 173L, 173L, 173L, 173L, 
    173L, 173L, 173L, 174L, 174L, 174L, 174L, 174L, 174L, 174L, 174L, 
    174L, 174L, 174L, 174L, 174L, 174L, 174L, 174L, 175L, 175L, 175L, 
    175L, 175L, 175L, 175L, 175L, 175L, 175L, 175L, 175L, 176L, 176L, 
    176L, 176L, 176L, 176L, 176L, 176L, 176L, 176L, 177L, 177L, 177L, 
    177L, 177L, 177L, 177L, 177L, 177L, 178L, 178L, 178L, 178L, 178L, 
    178L, 178L, 178L, 178L, 178L, 178L, 178L, 179L, 179L, 179L, 179L, 
    179L, 179L, 179L, 179L, 179L, 179L, 180L, 180L, 180L, 180L, 180L, 
    180L, 180L, 180L, 181L, 181L, 181L, 181L, 181L, 181L, 181L, 181L, 
    181L, 181L, 181L, 181L, 181L, 181L, 181L, 181L, 182L, 182L, 182L, 
    182L, 182L, 182L, 182L, 182L, 182L, 182L, 182L, 182L, 182L, 183L, 
    183L, 183L, 183L, 183L, 183L, 183L, 183L, 183L, 183L, 183L, 184L, 
    184L, 184L, 184L, 184L, 184L, 184L, 184L, 184L, 185L, 185L, 186L, 
    186L, 186L, 186L, 186L, 187L, 187L, 187L, 187L, 187L, 187L, 187L, 
    188L, 188L, 188L, 188L, 188L, 188L, 188L, 188L, 188L, 189L, 189L, 
    189L, 189L, 189L, 189L, 189L, 189L, 189L, 189L, 189L, 189L, 190L, 
    190L, 190L, 190L, 190L, 190L, 190L, 190L, 190L, 190L, 191L, 191L, 
    191L, 191L, 191L, 191L, 191L, 191L, 191L, 192L, 192L, 192L, 192L, 
    192L, 192L, 192L, 193L, 193L, 193L, 193L, 193L, 193L, 193L, 193L, 
    194L, 194L, 194L, 194L, 194L, 194L, 194L, 195L, 195L, 195L, 195L, 
    195L, 195L, 195L, 195L, 195L, 195L, 195L, 195L, 196L, 196L, 196L, 
    196L, 196L, 196L, 196L, 196L, 196L, 196L, 196L, 196L, 197L, 197L, 
    197L, 197L, 197L, 197L, 197L, 197L, 197L, 197L, 197L, 198L, 198L, 
    198L, 198L, 198L, 198L, 198L, 198L, 198L, 198L, 198L, 198L, 198L, 
    198L, 199L, 199L, 199L, 199L, 199L, 199L, 199L, 200L, 200L, 200L, 
    200L, 200L, 200L, 200L, 200L, 200L, 200L, 200L, 200L)
alpha <-
  c(1, 1, 1, 1)
beta <-
  c(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)



#------------Model--------------------
model <- '
  data {
    // training data
    int<lower=1> K;               // num topics
    int<lower=1> V;               // num words, vocabulary
    int<lower=0> M;               // num docs
    int<lower=0> N;               // total word instances
    int<lower=1,upper=K> z[M];    // topic for doc m
    int<lower=1,upper=V> w[N];    // word n
    int<lower=1,upper=M> doc[N];  // doc ID for word n
    // hyperparameters
    vector<lower=0>[K] alpha;     // topic prior
    vector<lower=0>[V] beta;      // word prior
  }

  parameters {
    simplex[K] theta;   // topic prevalence
    simplex[V] phi[K];  // word dist for topic k
  }

  model {
    // priors
    theta ~ dirichlet(alpha);
    for (k in 1:K)  
      phi[k] ~ dirichlet(beta);

    // likelihood, including latent category
    for (m in 1:M)
      z[m] ~ categorical(theta);
    for (n in 1:N)
      w[n] ~ categorical(phi[z[doc[n]]]);
  }
'


fit <- stan(model_code = model, 
            data = list(K=K,V=V,M=M,N=N,z=z,w=w,doc=doc,alpha=alpha,beta=beta), 
            iter = 10000, chains=1, verbose=FALSE, seed=101, warmup=1000)



phi_means <- matrix(as.numeric(get_posterior_mean(fit, pars="phi")), ncol=4)
colnames(phi_means) <- paste0("K",1:4)  # i-th topic
rownames(phi_means) <- paste0("V",1:10) # i-th word in the vocabulary
phi_means


words <- c(1,5,4,1,2)            # the words id of a new document
predict_topic(words, phi_means)  # prediction