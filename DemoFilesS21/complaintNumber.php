<?php
// If the all the variables are set when the Submit button is clicked...
if (isset($_POST['field_submit'])) {
    // Refer to conn.php file and open a connection.
    require_once("conn.php");
    // Will get the value typed in the form text field and save into variable
    $var_director = $_POST['cplt_num'];
    $query = "CALL getComplaint(:complaint_num)";

try
    {
      // Create a prepared statement. Prepared statements are a way to eliminate SQL INJECTION.
      $prepared_stmt = $dbo->prepare($query);
      //bind the value saved in the variable $var_director to the place holder :ph_director  
      // Use PDO::PARAM_STR to sanitize user string.
      $prepared_stmt->bindValue(':complaint_num', $var_director, PDO::PARAM_STR);
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
    <h1 style="text-align: center"> Search by Complaint Number</h1>
    <!-- This is the start of the form. This form has one text field and one button.
      See the project.css file to note how form is stylized.-->
    <form method="post" style="text-align: center">

      <label for="id_director">Complaint Number</label>
      <!-- The input type is a text field. Note the name and id. The name attribute
        is referred above on line 7. $var_director = $_POST['field_director']; id attribute is referred in label tag above on line 52-->
      <input type="number" name="cplt_num" id = "id_director">
      <!-- The input type is a submit button. Note the name and value. The value attribute decides what will be dispalyed on Button. In this case the button shows Submit.
      The name attribute is referred  on line 3 and line 61. -->
      <input type="submit" name="field_submit" value="Submit">
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
                  <th scope="col">Complaint Start Date</th>
                  <th scope="col">Suspect Age Group</th>
                  <th scope="col">Suspect Race</th>
                  <th scope="col">Suspect Sex</th>
                </tr>
              </thead>
              <tbody>

                  <?php foreach ($result as $row) { ?>
                    <tr>
                       <!-- Print (echo) the value of mID in first column of table -->
                      <td><?php echo $row["cmplnt_num"]; ?></td>
                      <!-- Print (echo) the value of title in second column of table -->
                      <td><?php echo $row["cmplnt_fr_dt"]; ?></td>
                      <!-- Print (echo) the value of movieYear in third column of table and so on... -->
                      <td><?php echo $row["susp_age_group"]; ?></td>
                      <td><?php echo $row["susp_race"]; ?></td>
                      <td><?php echo $row["susp_sex"]; ?></td>
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>  
  </body>
</html>






