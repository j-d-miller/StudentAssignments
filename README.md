# StudentAssignments

Shiny app that calls the d96assign package to assign students to schools. 

0. To run the app, you need to create an excel spreadsheet with student names and addresses. The format of this file should be identical to the sample file KEnrollTemplate.xls. I created KEnrollTemplate.xls by taking made up names and randomly assigning them to addresses. The names and addresses in this file do not correspond those of actual or former students. The eight columuns of your input file should have exactly the same names as the eight columns of KEnrollTemplate.xls: 

Student	UID	Siblings	Street	Apartment	City	State	Zip

The content of your input file should be self explanatory. Note: if an address has an apartment number or a unit number or anything similiar, put this info in the Apartment column. Do not put it in the Street column - Google doesn't always handle apartment numbers correctly when they are in a Street address.   

After you have your input file, you install the app like this: 

1. Create a Google account.
2. Get a Google API key.
3. Set Google API permissions to allow geocoding, distance matrix, and map queries.
4. Install R.
5. Install RStudio.
6. In RStudio, install these libraries from CRAN:
  - devtools
  - lpSolve
  - ggmap
  - readxl
  - writexl
  - shiny
7. In RStudio, load devtools:
  - library(devtools)
8. In RStudio, install the library d96assign from git-hub:
  - install_github("j-d-miller/d96assign")
9. Download the StudentAssignments app, project, and sample data from github (this project).  
10. Near the top of the file app.R, replace yourgooglekeygoeshere your google key. 

register_google(key = "yourgooglekeygoeshere") 

After you have created you input file and you have installed the app, you can run the app as follows: 


11. In RStudio, run the shiny app. Make sure when you run the app, you choose the "Run in Window" option. 

12. If you have not already created the distance matrix file, create it. (If you have already created the distance matrix file, skip this step.)

On  as follows the lefthand side of the app, click the Browse button and load your input file. After your file loads, you should see it on the righthand side of the app under the Student Addresses pane. Next, click the Calculate Distance Matrix button. The app will then calculate the walking distances from each student to each school and put the results in a time stamped file called distMat-[date-time].xlsx. 

13. On the lefthand side of the app, load the distance matrix file (browse to the appropriate file). 

14. 


13. 
