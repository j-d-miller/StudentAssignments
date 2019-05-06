# StudentAssignments

This is a shiny app that calls the d96assign package to assign students to schools in Riverside School District 96. 

Here, in excessive detail, is what you need to do to use this app: 

0. Download the app by clicking the "Clone or Download" button and then select "download zip". The zipfile that you download contains the app as well as two data file templates.   

1. Create an excel spreadsheet with the names and addresses of incoming students. The format of your file should be identical to the sample file StudentAddressesTemplate.xlsx located in the directory inst/extdata. I created StudentAddressesTemplate.xlsx by randomly assigning fake names to real addresses. The eight columns of your input file should have exactly the same names as the eight columns of StudentAddressesTemplate.xlxs: 

Student,    UID,    Siblings,    Street,    Apartment,    City,    State,    Zip

The content of StudentAddressesTemplate.xlxs (and your version, containing real data) should be self-explanatory. 

Two things to note: 1) the UID column can have any character uniqueid and 2) if an address has an apartment number or a unit number or anything similar, put this info in the Apartment column. Do not put it in the Street column - Google doesn't always handle apartment numbers correctly when they are in a Street address.   

After you have made your input file of student names and addresses, you need to create the distance matrix of the walking distances from each address to each school. The app will do this for you, by calling the Google maps API.  To call the Google API  you need a (free) Google key. To get the key:   

2. Create a Google account.
3. Get a Google API key.
4. Set Google API permissions to allow geocoding, distance matrix, and map queries.

Once you have your google key, you need to: 

5. Install R: 

https://www.r-project.org

and 

6. Install RStudio:

https://www.rstudio.com

Once you have installed RStudio, open it and 

7. Install these libraries:

  - devtools
  - lpSolve
  - ggmap
  - readxl
  - writexl
  - shiny
  
Then 

8. In RStudio, load the devtools package:

  library(devtools)
  
and 

9. Install the library d96assign from git-hub:

  install_github("j-d-miller/d96assign")
  
The d96assign library contains the function that assigns students to schools. This function minimizes total student walking distance, subject to user-imposed constraints on the number of students that can be accommodated at each school. The underlying algorithm calls a mixed integer linear program, lpSolve. 
  
Next,  

10. In RStudio, open the StudentAssignments project (in the directory that you downloaded in step 0).

Then, 

11. In the StudentAssignments project, open the file app.R and replace "yourkeygoeshere" with the google key you got in step 3 with this line: 

register_google(key = "yourkeygoeshere") 

You can now run the app,  

12. Click the button at the top which says "Run". Make sure that when you run the app, you choose the "Run in Window" option. 

13. If you have not already created the distance matrix file, create it. (If you have already created the distance matrix file, skip this step):

On the lefthand side of the app, click the Browse button and load the input file of student addresses which you created in step 1 (or as a demo, you can use the file StudentAddressesTemplate.xlsx located in the directory inst/extdata). After your file loads, you should see the data on the righthand side of the app under the Student Addresses tab. 

Next, click the Calculate Distance Matrix button. The app will then get the walking distances from each student to each school and put the results in a time-stamped file called distMat-[date-time].xlsx. This file should have the same format as DistanceMatrixTemplate.xlxs which is also in the directory inst/extdata.

14. Once you have the distance matrix, load it by clicking the browse under the Load Distance Matrix button on the left-hand side of the app. As soon as the distance matrix is loaded, the app will automatically assign students to the closest school. You will see this assignment on the map. 

15. You can now impose constraints on the number of students at schools using the slider buttons on the left of the app. Note that not all constraints are possible. 


