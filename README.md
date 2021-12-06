# cs3265_proj2
Required environement: 
  -WAMP (Windows) or MAMP (MacOS)
  -MySQL Workbench tool
  -MySQL Database created 
  
 Setup:
  -Download source dataset from https://www.kaggle.com/mrmorj/new-york-city-police-crime-data-historic 
  
  -Make sure your MySQL Server is running, whether that be through WAMP or MAMP 
  -Open up nyccrimes.sql query file. Change the load data statement to use the datapath leading to the folder containing the downloaded dataset. 
  -Update allowed query time in your MySQL Workbench settings:
    -(on Mac) MySQLWorkbench > Preferences > SQL Editor
        set DBMS connection keep-alive interval (in seconds): 600
        set DBMS connection timeout interval (in seconds): 60
    -(on Windows): MySQLWorkbench > Edit > Preferences > SQL Editor
        set DBMS connection keep-alive interval (in seconds): 600
        set DBMS connection timeout interval (in seconds): 60
-Run the nyccrimes.sql query file

-After you have run the sql file, place the frontend folder inside the wamp64/mamp folder’s www directory (for Windows) or the MAMP folder’s htdocs director (for MAC) to have access to the frontend through your web browser.  
-Edit the conn.php file with the details for your database login. 
-Finally, access the frontend at:
  http://localhost/<frontend_folder>/index.html (for Windows) 
  http://localhost:8888/<frontend folder>/index.html (for MAC) 
