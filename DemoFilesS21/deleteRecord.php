<?php
// If the all the variables are set when the Submit button is clicked...
if (isset($_POST['field_submit'])) {
    // It will refer to conn.php file and will open a connection.
    require_once("conn.php");
    // Will get the value typed in the form text field and save into variable
    $var_title = $_POST['field_title'];
    // Save the query into variable called $query. NOte that :title is a place holder
    $query = "CALL deleteComplaint(:title)";
    
    try
    {
      $prepared_stmt = $dbo->prepare($query);
      //bind the value saved in the variable $var_title to the place holder :title after //verifying (using PDO::PARAM_STR) that the user has typed a valid string.
      $prepared_stmt->bindValue(':title', $var_title, PDO::PARAM_STR);
      //Execute the query and save the result in variable named $result
      $result = $prepared_stmt->execute();

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
    <!-- See the project.css file to note h1 (Heading 1) is stylized.-->
    <h1 style="text-align: center"> Delete a Complaint </h1>
    <!-- This is the start of the form. This form has one text field and one button.
      See the project.css file to note how form is stylized.-->
    <form method="post" style="text-align: center">

      <label for="id_title">Complaint Number</label>
      <!-- The input type is a text field. Note the name and id. The name attribute
        is referred above on line 7. $var_title = $_POST['field_title']; -->
      <input type="number" name="field_title" id="id_title">
      <!-- The input type is a submit button. Note the name and value. The value attribute decides what will be dispalyed on Button. In this case the button shows Delete Movie.
      The name attribute is referred above on line 3 and line 63. -->
      <input type="submit" name="field_submit" value="Delete">
    </form>

    <?php
      if (isset($_POST['field_submit'])) {
        if ($result) { 
    ?>
          <h2 style="text-align: center">Complaint Deleted Successfully!</h2>
    <?php 
        } else { 
    ?>
          <h3> Sorry, there was an error. Could not delete this record. </h3>
    <?php 
        }
      } 
    ?>

    <footer class="py-2 bg-dark" style="position:absolute; bottom:0; width: 100%;">
        <div class="container px-3 px-md-3">
          <p class="m-0 text-center text-white"> CS 3265, Project Two. Created By: Chanteria Milner and Sneh Patel </p></div>
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>


