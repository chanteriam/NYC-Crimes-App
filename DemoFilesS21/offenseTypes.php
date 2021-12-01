<?php
// If the all the variables are set when the Submit button is clicked...
if (isset($_POST['field_submit'])) {
    // Refer to conn.php file and open a connection.
    require_once("conn.php");
    // Will get the value typed in the form text field and save into variable
    $var_director = $_POST['offense_input'];
    $query = "CALL getOffense(:offense)";

try
    {
      // Create a prepared statement. Prepared statements are a way to eliminate SQL INJECTION.
      $prepared_stmt = $dbo->prepare($query);
      //bind the value saved in the variable $var_director to the place holder :ph_director  
      // Use PDO::PARAM_STR to sanitize user string.
      $prepared_stmt->bindValue(':offense', $var_director, PDO::PARAM_STR);
      $prepared_stmt->execute();
      // Fetch all the values based on query and save that to variable $result
      $result = $prepared_stmt->fetchAll();

    }
    catch (PDOException $ex)
    { // Error in database processing.
      echo $sql . "<br>" . $error->getMessage(); // HTTP 500 - Internal Server Error
    }
}
?>

<html>
<!-- Any thing inside the HEAD tags are not visible on page.-->
  <head>
    <!-- THe following is the stylesheet file. The CSS file decides look and feel -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous"> 
     <link rel="stylesheet" href="//code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">
    <link rel="stylesheet" href="/resources/demos/style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
    <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
    <script>
  $( function() {
    var availableTags  = ["OFFENSES AGAINST PUBLIC ADMINI", "ASSAULT 3 & RELATED OFFENSES", "HARRASSMENT 2", "RAPE", "GRAND LARCENY", "PETIT LARCENY", "OFF. AGNST PUB ORD SENSBLTY &", "CRIMINAL TRESPASS", "CRIMINAL MISCHIEF & RELATED OF", "FELONY ASSAULT", "SEX CRIMES", "DANGEROUS DRUGS", "BURGLARY", "DANGEROUS WEAPONS", "THEFT-FRAUD", "ROBBERY", "MISCELLANEOUS PENAL LAW", "GRAND LARCENY OF MOTOR VEHICLE", "INTOXICATED & IMPAIRED DRIVING", "OTHER OFFENSES RELATED TO THEF", "POSSESSION OF STOLEN PROPERTY", "VEHICLE AND TRAFFIC LAWS", "MURDER & NON-NEGL. MANSLAUGHTER", "UNAUTHORIZED USE OF A VEHICLE", "THEFT OF SERVICES", "NYS LAWS-UNCLASSIFIED FELONY", "OFFENSES INVOLVING FRAUD", "FORGERY", "ADMINISTRATIVE CODE", "GAMBLING", "FRAUDS", "ARSON", "OFFENSES AGAINST THE PERSON", "OFFENSES RELATED TO CHILDREN", "PETIT LARCENY OF MOTOR VEHICLE", "DISORDERLY CONDUCT", "FRAUDULENT ACCOSTING", "OTHER STATE LAWS (NON PENAL LA", "BURGLAR'S TOOLS", "CHILD ABANDONMENT/NON SUPPORT", "ALCOHOLIC BEVERAGE CONTROL LAW", "KIDNAPPING & RELATED OFFENSES", "PROSTITUTION & RELATED OFFENSES", "OTHER STATE LAWS", "JOSTLING", "NEW YORK CITY HEALTH CODE", "OFFENSES AGAINST PUBLIC SAFETY", "AGRICULTURE & MRKTS LAW-UNCLASSIFIED", "LOITERING/GAMBLING (CARDS, DIC", "LOITERING/DEVIATE SEX", "HOMICIDE-NEGLIGENT,UNCLASSIFIE", "ENDAN WELFARE INCOMP", "LOITERING", "ESCAPE 3", "ANTICIPATORY OFFENSES", "DISRUPTION OF A RELIGIOUS SERV", "LOITERING FOR DRUG PURPOSES", "OTHER TRAFFIC INFRACTION", "INTOXICATED/IMPAIRED DRIVING", "HOMICIDE-NEGLIGENT-VEHICLE", "UNLAWFUL POSS. WEAP. ON SCHOOL", "ADMINISTRATIVE CODES", "UNDER THE INFLUENCE OF DRUGS", "FORTUNE TELLING", "ABORTION", "KIDNAPPING", "OTHER STATE LAWS (NON PENAL LAW)", "KIDNAPPING AND RELATED OFFENSES", "NYS LAWS-UNCLASSIFIED VIOLATION", "OFFENSES AGAINST MARRIAGE UNCL"];

    $( "#tags" ).autocomplete({
      source: availableTags
    });
  } );
  </script>
  </head> 

<!-- Everything inside the BODY tags are visible on page.-->
  <body>
      <nav class="navbar navbar-expand-md navbar-dark bg-dark">
        <div class="container-fluid">
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-md-0">
              <li class="nav-item">
                <a class="nav-link active" aria-current="page" href="index.html">Home</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="getMega.php">MegaTable</a>
              </li>
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                  Queries
                </a>
                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                  <li><a class="dropdown-item" href="complaintNumber.php">Complaint Number</a></li>
                  <li><a class="dropdown-item" href="offenseTypes.php">Offense Description</a></li>
                  <li><a class="dropdown-item" href="getLaw.php">Law Classifications</a></li>
                </ul>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="deleteRecord.php">Delete Report</a>
              </li>
            </ul>
          </div>
        </div>
      </nav>    
    <h1 style="text-align: center">Search by Unique Offenses</h1>
    <form method="post" style="text-align: center">
    <div class="ui-widget">
      <label for="tags">Offense: </label>
      <input name="offense_input" id = "tags">
      <input type="submit" name="field_submit" value="Submit">
    </div>
   </form>

  <?php
      if (isset($_POST['field_submit'])) {
        // If the query executed (result is true) and the row count returned from the query is greater than 0 then...
        if ($result && $prepared_stmt->rowCount() > 0) { ?>
              <!-- first show the header RESULT -->
              <h2 style="text-align: center">Results</h2>
              <!-- THen create a table like structure. See the project.css how table is stylized. -->
            <table class="table">
                <thead class="thead-dark">
                  <tr>
                    <th scope="col">Complaint Number</th>
                    <th scope="col">Offense</th>
                  </tr>
                </thead>
                <tbody>

                    <?php foreach ($result as $row) { ?>
                      <tr>
                         <!-- Print (echo) the value of mID in first column of table -->
                        <td><?php echo $row["cmplnt_num"]; ?></td>
                        <!-- Print (echo) the value of title in second column of table -->
                        <td><?php echo $row["ofns_desc"]; ?></td>
                      <!-- End first row. Note this will repeat for each row in the $result variable-->
                      </tr>
                    <?php } ?>
                </tbody>
            </table>

        <?php } else { ?>
          <!-- IF query execution resulted in error display the following message-->
          <h3 style="text-align: center">Sorry, no results found for complaint number:  <?php echo $_POST['cplt_num']; ?>. </h3>
        <?php }
    } ?>


   <footer class="py-2 bg-dark" style="position:absolute; bottom:0; width: 100%;">
      <div class="container px-3 px-md-3">
        <p class="m-0 text-center text-white"> CS 3265, Project Two. Created By: Chanteria Milner and Sneh Patel </p></div>
  </footer>
  </script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>





