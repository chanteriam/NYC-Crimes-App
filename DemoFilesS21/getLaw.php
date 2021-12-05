<?php
// If the all the variables are set when the Submit button is clicked...
if (isset($_POST['field_submit'])) {
    // Refer to conn.php file and open a connection.
    require_once("conn.php");
    // Will get the value typed in the form text field and save into variable
    $var_director = $_POST['offense_input'];
    $query = "CALL getLaw(:offense)";

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
    var availableTags  = ["MISDEMEANOR", "FELONY"];

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
                  Searching
                </a>
                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                  <li><a class="dropdown-item" href="complaintNumber.php">Complaint Number</a></li>
                  <li><a class="dropdown-item" href="offenseTypes.php">Offense Description</a></li>
                  <li><a class="dropdown-item" href="getLaw.php">Law Classifications</a></li>
                </ul>
              </li>
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                  Updating
                </a>
                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                  <li><a class="dropdown-item" href="insertRecord.php">Insert Report</a></li>
                  <li><a class="dropdown-item" href="updateRecord.php">Update Report</a></li>
                  <li><a class="dropdown-item" href="deleteRecord.php">Delete Report</a></li>
                </ul>
              </li>
            </ul>
          </div>
        </div>
      </nav>    
    <h1 style="text-align: center">Search by Violation Level</h1>
    <form method="post" style="text-align: center">
    <div class="ui-widget">
      <label for="tags">Violation Level: </label>
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
                    <th scope="col">Offense Description</th>
                    <th scope="col">Offense Date</th>
                    <th scope="col">Law Category</th>
                  </tr>
                </thead>
                <tbody>

                    <?php foreach ($result as $row) { ?>
                      <tr>
                         <!-- Print (echo) the value of mID in first column of table -->
                        <td><?php echo $row["cmplnt_num"]; ?></td>
                        <!-- Print (echo) the value of title in second column of table -->
                        <td><?php echo $row["ofns_desc"]; ?></td>
                        <td><?php echo $row["cmplnt_fr_dt"]; ?></td>
                        <td><?php echo $row["law_cat_cd"]; ?></td>
                      <!-- End first row. Note this will repeat for each row in the $result variable-->
                      </tr>
                    <?php } ?>
                </tbody>
            </table>

        <?php } else { ?>
          <!-- IF query execution resulted in error display the following message-->
          <h3 style="text-align: center">Sorry, no results found for law classification:  <?php echo $_POST['cplt_num']; ?>. </h3>
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



