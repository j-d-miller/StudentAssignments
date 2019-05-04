# StudentAssignments

Shiny app that calls the d96assign package to assign students to schools. 

0. Download the app by clicking Clone or Download, and then selecting download zip. The zipfile that you download contains the app and two data file templates.   

1. To use the app, you need to create an excel spreadsheet with student names and addresses. The format of this file should be identical to the sample file StudentAddressesTemplate.xlsx in the directory inst/extdata. I created StudentAddressesTemplate.xlsx by randomly assigning fake names to addresses. The eight columuns of your input file should have exactly the same names as the eight columns of StudentAddressesTemplate.xlxs: 

Student,	UID,	Siblings,	Street,	Apartment,	City,	State,	Zip

The content of StudentAddressesTemplate.xlxs (and your own version, containing real data) should be self explanatory. 

Two things to note: 1) the UID column can have any kind of character uniqueid and 2) if an address has an apartment number or a unit number or anything similiar, put this info in the Apartment column. Do not put it in the Street column - Google doesn't always handle apartment numbers correctly when they are in a Street address.   

After you have made your input file of student names and addresses, you need to create the distance matrix of walking distances from each address to each school. The app will do this for you, by calling the Google maps API. But first you need to:  

2. Create a Google account.
3. Get a Google API key.
4. Set Google API permissions to allow geocoding, distance matrix, and map queries.

This is all free and easy to do. 

Next, to run the app, you need to: 

5. Install R: 

https://www.r-project.org

6. Install RStudio:

https://www.rstudio.com

7. Start RStudio. In RStudio, install these libraries:

  - devtools
  - lpSolve
  - ggmap
  - readxl
  - writexl
  - shiny
  
8. In RStudio, load devtools like this:

  library(devtools)
  
9. In RStudio, install the library d96assign from git-hub:

  - install_github("j-d-miller/d96assign")
  
  The d96assign library contains the function that assigns assigns students to schools. It does so by minimizing total walking distance, subject to user imposed constraints on the number of students that can be accomomodated at each school. The underlying algorithm is a mixed integer linear program. 
  
10. In RStudio, open the StudentAssignments project (in the directory that you downloaded in step 0).  

11. In the StudentAssignments project, open the file app.R and replace "yourgooglekeygoeshere" with your google key in this line: 

register_google(key = "yourgooglekeygoeshere") 

You are now ready to run the app: 

12. In RStudio, run the shiny app. Make sure when you run the app, you choose the "Run in Window" option. 

13. If you have not already created the distance matrix file, create it. (If you have already created the distance matrix file, skip this step):

On the lefthand side of the app, click the Browse button and load your input file of student addresses. After your file loads, you should see the data on the righthand side of the app under the Student Addresses tab. Next, click the Calculate Distance Matrix button. The app will then calculate the walking distances from each student to each school and put the results in a time stamped file called distMat-[date-time].xlsx. 

14. Once you have the distance matrix, load it by clicking the browse under the Load Distance Matrix button on the left hand side of the app. As soon as the distanve matrix is loaded, the app will automatically assign students to the closest school. You will see this assignmemnt on the map. 

15. You can impose constraints on the number of students at schools using the slider buttons on the left of the app. Note that not all constraints are possible. 


