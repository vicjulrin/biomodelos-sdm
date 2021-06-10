# BioModelos 2

BioModelos 2 is an effort to construct thousands of Species Distribution Models (SDM) from databases gathered and managed by the Instituto de Investigación de Recursos Biológicos Alexander von Humboldt (IAvH). It is attached to BioModelos initiative from the IAvH. "BioModelos 2" follows an automatized SDM general routine. First, it cleans occurrence data and constructs the accessible area when is necesary. Second, it crops and masks current and future environmental variables. Third, it creates SDM's using one or several algorithms and then ensemble the best of each one. Fourth, it projects to different scenarios at user discretion.

Current state: in development. Version 0.0.1

## Prerequisites

### Dependencies and files

Dependencies to install, choose the version depending on your operating system and version. For example, a windows 10 terminal with more than 4 gigabytes on memory RAM almost always has a 64 bit version of windows. Surf on the web in case of more information.

* [R](https://cran.r-project.org/mirrors.html)
* [RStudio](https://www.rstudio.com/products/rstudio/download/#download)
* [Rtools](https://cran.r-project.org/bin/windows/Rtools/)
* [Java Development Kit](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)
* [Maxent](https://drive.google.com/file/d/1a-0QPZyqk9DFWEm7rSreBTYiuTJDgABR/view)
* [BioModelos 2 repositiry](https://github.com/cmunozr/16kproject_IAVH) update to the permanent repository

### Libraries
Libraries required and their versions

```
"plyr" version 1.8.6
"dplyr" version 1.0.5
"automap" version 1.0.14
"PresenceAbsence" version 1.1.9
"devtools" version 2.3.2
"CoordinateCleaner" version 2.0.18
"sf" version 0.9.8
"spThin" version 0.2.0
"raster" version 3.4.10
"dismo" version 1.3.3
"biomod2" version 3.4.6
"ENMeval" version 0.3.1
"rgdal" version 1.5.23
"rJava" version 0.9.13
"kuenm" version 1.1.6
```

## How to run

1. Create a folder and move (uncompressed) the content of this repository and "maxent.jar" file (downloaded previously) there. For better results choose a root directory like "C" or "D" in windows to create the folder (working directory).

2. Open RStudio and create a new project using the folder created as working directory. It can be achieving doing the next. First, click on tool bar "File" (upper left of the RStudio window). Second, "New Project". In the opened window, click on "Existing Directory". After that, browse into the computer folder structure until reach the folder created in the step 1. Last, get click on "Create Project". *Note: This step is comparative to setup a working directory with* `setwd()`

3.  Create in RStudio a new script. It can be achieve going to "File" tool bar, "New File" and then "R Script". It may well be used the icon "New file" right under the tool bar "File" or using the keyboard shortcut "Ctrl+Shift+N" in windows.

4. Load the setup functions of **BioModelos 2**. In the script editor type 

```
source("setup.R")
``` 

5. Then run it using the icon "Run" or the keyboard shortcut "Ctrl+Enter" in windows. You will find four new objects in the environment (upper left portion of the RStudio window)
+ *vector.packages* vector character that stores the name of each package necessary to run **BioModelos 2**
+ *do.install* automatic installation of needed packages
+ *do.check* function to verify if the installation of vector packages was successfull
+ *do.load* automatic loading of needed packages
+ *do.folder.structure* function to create folders to organize work process in the working directory.

6. Run the automatic installation in the editor script. The process will install the packages stored in the 'vector.packages' object. In case of showing a compilation window procedure accept as it diminish likely of installation errors, it is slower than a traditional method, so be patient. Warning: if you have a version of ENMeval package lower or higher than 0.3.1 it will be replace by the former.
```
do.install(vector.packages)
``` 

You only need to install the packages once, so, it is better to block this command line typing a '#' character in the forefront of the line just before of the first run, like this `# do.install(vector.packages)` or even erase the line. 

7. Verify if packages were successfully installed using
```
do.check(vector.packages)
``` 
A message showing a table with column names "package" and "successfully_completed" will be shown in the console (corner left of the RStudio window), as well as the ENMeval version installed. For example,

```
             package successfully_installed
1               plyr                  TRUE
2              dplyr                  TRUE
3            automap                  TRUE
4    PresenceAbsence                  TRUE
5           devtools                  TRUE
6  CoordinateCleaner                  TRUE
7                 sf                  TRUE
8             spThin                  TRUE
9             raster                  TRUE
10             dismo                  TRUE
11           biomod2                  TRUE
12           ENMeval                  TRUE
13             rgdal                  TRUE
14             rJava                  TRUE
15             kuenm                  TRUE

ENMeval version 0.3.1 is TRUE
```

In case of receiving a FALSE statement on the table or having an ENMeval version different to 0.3.1, you need to troubleshoot before to continue. Please refer to the vignette **Manual Installation of Packages** MISSING.

8. Load the installed packages with

```
do.load(vector.packages)
``` 
9. Create the structure of folders typing and run. 

```
do.folder.structure(clim.datasets = "worldclim")
``` 

The use of the character "worldclim"" inside the function does not refer to retrieve the data from the repository. It is only a way to create an organized a framework inside the working directory in which you may store the environmental variables and occurrence data of species downloaded manually or using automatized tools. 

After run the function you will have in your working directory 3 new folders with subfolders:

* *Bias_layer* to storage bias file layers created (please refer to the vignette **Constructing Bias Layer**, [this article](https://onlinelibrary.wiley.com/doi/10.1111/j.1600-0587.2013.07872.x) and this [blog](https://scottrinnan.wordpress.com/2015/08/31/how-to-construct-a-bias-file-with-r-for-use-in-maxent-modeling/)
* *Data* to storage geographical data. Sub-folders:
  + *biogeographic_shp* storage biogeographic, ecoregions or hydrosheets objects used to construct accessible areas of species
  + *env_vars* to storage environmental variables. Most used files can be ".tif" or ".asc". Supported file types are the 'native' raster package format and those that can be read via [rgdal](https://www.rdocumentation.org/packages/rgdal/versions/1.5-23/topics/readGDAL). Sub-folders:
    + *other* environmental variables not related with climate but consider important to modeled species
      + *future*
      + *current*
    + *climatic* climatic variables consider important to modeled species
      + *future*
      + *current*
  + *shapes* to storage of useful shapefiles like Colombian or American borders
* *Occurrences* to storage geographical records of species, those records must have a column with name species, latitude and longitude in decimal format 

10. Load the wrapper function "Bio2_routine". This function follows the basic structure of an "Ecological Niche Modeling" (ENM) process (Peterson et al, 2011). It calls several subroutines to achieve this with a few inputs and having a wide range of customization. Also, it is useful for users not familiarized with ENM's or R.

```
source("R/Bio2_routine.R")
``` 

For help run 

```
?(Bio2_routine)
```

Also, please read all this readme or refer to **Structure and Functions** and **More deep in Bio2_routine** vignettes to find more information about. 

### Folder structure and RStudio window

Your folder structure must look like this:

![Folder_Structure](Folder_Structure.PNG)

Your RStudio window must look like this:

![RStudio_View](RStudio_View.png)


Now you are ready to customize Bio2_routine and run SDM models. You only need,as said before, two more basic elements: environmental variables and georeferenced occurrence data of one or several species. The next example will show you the structure and characteristics of both elements. Also, to go deep in this function revise **Structure and Functions** and **More deep in Bio2_routine** vignette.

## Example

### Environmental Data and Ocurrences

Having done the earlier steps, move the files inside of the folder *Example* to the main root folder. It will overwrite *Data* and *Occurrences* folders, please let the process continue if you are asked about. Inside *Data* folder you will find environmental variables representing climatic and other factors of current and future scenarios (for future explanation go to vignette **exercises**). In the current worldclim folder you will find two raster files ".tif". On the other hand, you will find two spreadsheet in ".csv" format inside *Occurrences* folder. Each ".csv" stores occurrence data, the first one is a single species database with column labels "species", "lon" and "lat", the second one is a multiple species database (10 species) using identical column names. 


In this example, we are going to run a simple ENM of a single species database. So, load the "xxx.csv". After loading, feel free to explore the object call dataSp.

```
dataSp <- read.csv("Example/Occurrences/xxx.csv")
``` 

### Running

Once the species occurrence data and environmental variables are ready, the function `Bio2_routine()` can be customized and run. In this specific example, we are going to use:

```
Bio2_routine(
  occ = dataSp, col_sp = "species", col_lat = "lat", 
  col_lon = "lon", clim_vars = "worldclim", dir_clim = "Data/env_vars/", 
  dir_other = "Data/env_vars/other/", points_Buffer = TRUE, dist_MOV = 74,
  proj_models = "M-M", algos = "MAXENT"
) 
```

A quick explanation for each of those arguments:

+ Occurrences **occ** database is *dataSp*
+ Column name of species **col_sp** in the database *species* 
+ Column in which is the longitude information **col_lon** in the database is *lon*
+ Column in which is the latitude information **col_lat** in the database is *lat*
+ Name of climatic variables (**clim_vars**) is *worldclim* (with this character string the function will search on the directory path)
+ The climatic directory (**dir_clim**) is located in *Data/env_vars/"* and the not-climatic variables (**dir_other**) in *Data/env_vars/other/*.
+ The niche models will be calibrated and projected inside a buffer (**points_Buffer**) to each occurrence point around a movement distance (**dist_Mov**) of 74 kilometers
+ Algorithm (**algos**) used will be *MAXENT*


There are several more arguments and ways to customize them, so, go to vignettes. Remember, for help run

```
?Bio2_routine
```

### Checking console messages and working directory files

```
[1] "Cleaning data"
```
```
[1] "Thinning database to 1km, using  sqkm"
```

```
[1] "Constructing accessible area - M"
```
```
[1] "Processing environmental layers"
```

```
[1] "Processing bias layer"
```

### Final results: Ensembles


## Authors and contact

* **Carlos Jair Muñoz Rodriguez** - *Initial development* - [cmunoz@humboldt.org.co](cmunoz@humboldt.org.co)

* **María Helena Olaya** - *Initial development* -

* **Gabriel Alejandro Perilla Suarez** - *Initial development* - 

* **Héctor Manuel Arango Martínez** - *Initial development* - 

* **Cristian Alexander Cruz Rodriguez** - *Initial development* - 

* **Luis Hernando Romero Jiménez** - *Initial development* - 

* **Andrés Felipe Suárez Castro** - *Initial development* - 

* **Elkin Alexi Noguera Urbano** - *Initial development* - [enoguera@humboldt.org.co](enoguera@humboldt.org.co) 


## License

This project is licensed under the MIT License - see the [License.md](License.md) file for details
