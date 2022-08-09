library(shiny)
library(DT)
library(shinyalert)
library(shinyBS)
library(readxl)

setosa <- as.data.frame(readRDS("rds/setosa.rds"))
versicolor <- as.data.frame(readRDS("rds/versicolor.rds"))
