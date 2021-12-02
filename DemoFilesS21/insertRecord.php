<?php

if (isset($_POST['f_submit'])) {

    require_once("conn.php");

    /*
    $var_mID = $_POST['f_mID'];
    $var_title = $_POST['f_title'];
    $var_year = $_POST['f_year'];
    $var_director = $_POST['f_director'];
    */

    $var_complaint_num = $_POST['complaint_num'];
    $var_from_date = $_POST['from_date'];
    $var_from_time = $_POST['from_time']; 
    $var_end_date = $_POST['end_date'];
    $var_end_time = $_POST['end_time'];
    $var_precinct_code = $_POST['precinct_code'];
    $var_report_date = $_POST['report_date'];
    $var_key_cd = $_POST['key_cd'];
    $var_offense_desc = $_POST['offense_desc'];
    $var_pd_cd = $_POST['pd_cd'];
    $var_pd_desc = $_POST['pd_desc'];
    $var_completed_code = $_POST['completed_code'];
    $var_law_category = $_POST['law_category'];
    $var_borough = $_POST['borough'];
    $var_location_of_occurence = $_POST['location_of_occurence'];
    $var_premesis = $_POST['premesis'];
    $var_jurisdiction = $_POST['jurisdiction'];
    $var_jurisdiction_code = $_POST['jurisdiction_code'];
    $var_park = $_POST['park'];
    $var_housing_development = $_POST['housing_development'];
    $var_housing_code = $_POST['housing_code'];
    $var_coordX = $_POST['coordX'];
    $var_coordY = $_POST['coordY'];
    $var_suspect_age = $_POST['suspect_age'];
    $var_suspect_race = $_POST['suspect_race'];
    $var_suspect_sex = $_POST['suspect_sex'];
    $var_transit = $_POST['transit'];
    $var_lat = $_POST['lat'];
    $var_long = $_POST['long'];
    $var_latlong = $_POST['latlong'];
    $var_patrol_borough = $_POST['patrol_borough'];
    $var_station = $_POST['station'];
    $var_victim_age = $_POST['victim_age'];
    $var_victim_race = $_POST['victim_race'];
    $var_victim_sex = $_POST['victim_sex'];
    
    /*
    $query = "INSERT INTO Movie (mID, title, movieYear, director) "
            . "VALUES (:mID, :title, :year, :director)";

    try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindValue(':mID', $var_mID, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':title', $var_title, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':year', $var_year, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':director', $var_director, PDO::PARAM_STR);
      $result = $prepared_stmt->execute();

    }
    catch (PDOException $ex)
    { // Error in database processing.
      echo $sql . "<br>" . $error->getMessage(); // HTTP 500 - Internal Server Error
    }
    */
  }

?>

<html>
  <!-- Any thing inside the HEAD tags are not visible on page.-->
  <head>
    <!-- THe following is the stylesheet file. The CSS file decides look and feel -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
  </head> 

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

<h1 style="text-align: center"> Insert Complaint </h1>

    <form method="post">
    	<label for="id_mID">mID</label>
    	<input type="text" name="f_mID" id="id_mID"> 

    	<label for="id_title">title</label>
    	<input type="text" name="f_title" id="id_title">

    	<label for="id_year">year</label>
    	<input type="text" name="f_year" id="id_year">

    	<label for="id_director">director</label>
    	<input type="text" name="f_director" id="id_director">
    	
    	<input type="submit" name="f_submit" value="Submit">
    </form>

      <div class="container">
        <form method="post">
          <div class="form-group">
                <label for="cmplt_num">Complaint Number</label>
                <input type="number" class="form-control" name="complaint_num" id="cmplt_num"> 
          </div>

          <div class="form-group">
            <label for="cmplnt_fr_dt">Complaint Start Date</label>
            <input type="text" class="form-control" name = "from_date" id="cmplnt_fr_dt">
          </div>

          <div class="form-group">
            <label for="cmplnt_fr_tm">Complaint Start Time</label>
            <input type="text" class="form-control" name = "from_time" id="cmplnt_fr_tm">
          </div>

          <div class="form-group">
            <label for="cmplnt_to_dt">Complaint End Date</label>
            <input type="text" class="form-control" name = "end_date" id="cmplnt_to_dt">
          </div>

          <div class="form-group">
            <label for="cmplnt_to_tm">Complaint End Time</label>
            <input type="text" class="form-control" name = "end_time" id="cmplnt_to_tm">
          </div>

          <div class="form-group">
            <label for="addr_pct_cd">Precinct Code</label>
            <input type="text" class="form-control" name = "precinct_code" id="addr_pct_cd">
          </div>

          <div class="form-group">
            <label for="rpt_dt">Report Date</label>
            <input type="text" class="form-control" name = "report_date" id="rpt_dt">
          </div>

          <div class="form-group">
            <label for="ky_cd">Key Code</label>
            <input type="number" class="form-control" name = "key_cd" id="ky_cd">
          </div>

          <div class="form-group">
            <label for="ofns_desc">Offense Description</label>
            <input type="text" class="form-control" name = "offense_desc" id="ofns_desc">
          </div>

          <div class="form-group">
            <label for="pd_cd"> Pd Code</label>
            <input type="text" class="form-control" name = "pd_cd" id="pd_cd">
          </div>

          <div class="form-group">
            <label for="pd_desc">Pd Description</label>
            <input type="text" class="form-control" name = "pd_desc" id="pd_desc">
          </div>

          <div class="form-group">
            <label for="crm_atpt_cptd_cd">Completion Code</label>
            <input type="text" class="form-control" name = "completed_code" id="crm_atpt_cptd_cd">
          </div>

          <div class="form-group">
            <label for="law_cat_cd">Law Category Code</label>
            <input type="text" class="form-control" name = "law_category" id="law_cat_cd">
          </div>

          <div class="form-group">
            <label for="boro_nm">Borough Name</label>
            <input type="text" class="form-control" name = "borough" id="boro_nm">
          </div>

          <div class="form-group">
            <label for="loc_of_occur_desc">Location of Occurence</label>
            <input type="text" class="form-control" name = "location_of_occurence" id="loc_of_occur_desc">
          </div>

          <div class="form-group">
            <label for="prem_typ_desc">Premesis Type</label>
            <input type="text" class="form-control" name = "premesis" id="prem_typ_desc">
          </div>

          <div class="form-group">
            <label for="juris_desc">Jurisdiction</label>
            <input type="text" class="form-control" name = "jurisdiction" id="juris_desc">
          </div>

          <div class="form-group">
            <label for="jurisdiction_cd">Jurisdiction Code</label>
            <input type="text" class="form-control" name = "jurisdiction_code" id="jurisdiction_cd">
          </div>

          <div class="form-group">
            <label for="parks_nm">Park Name</label>
            <input type="text" class="form-control" name = "park" id="parks_nm">
          </div>

          <div class="form-group">
            <label for="hadevelopt">Housing Development</label>
            <input type="text" class="form-control" name = "housing_development" id="hadevelopt">
          </div>

          <div class="form-group">
            <label for="housing_psa">Housing Code</label>
            <input type="text" class="form-control" name = "housing_code" id="housing_psa">
          </div>

          <div class="form-group">
            <label for="x_coord_cd">X Coord</label>
            <input type="text" class="form-control" name = "coordX" id="x_coord_cd">
          </div>

          <div class="form-group">
            <label for="y_coord_cd">Y Coord</label>
            <input type="text" class="form-control" name = "coordY" id="y_coord_cd">
          </div>

          <div class="form-group">
            <label for="susp_age_group">Suspect Age Group</label>
            <input type="text" class="form-control" name = "suspect_age" id="susp_age_group">
          </div>

          <div class="form-group">
            <label for="susp_race">Suspect Race</label>
            <input type="text" class="form-control" name = "suspect_race" id="susp_race">
          </div>

          <div class="form-group">
            <label for="susp_sex">Suspect Sex</label>
            <input type="text" class="form-control" name = "suspect_sex" id="susp_sex">
          </div>

          <div class="form-group">
            <label for="transit_district">Transit District</label>
            <input type="text" class="form-control" name = "transit" id="transit_district">
          </div>

          <div class="form-group">
            <label for="latitude">Latitude</label>
            <input type="text" class="form-control" name = "lat" id="latitude">
          </div>

          <div class="form-group">
            <label for="longitude">Longitude</label>
            <input type="text" class="form-control" name = "long" id="longitude">
          </div>

          <div class="form-group">
            <label for="lat_lon">Latitude and Longitude</label>
            <input type="text" class="form-control" name = "latlong" id="lat_lon">
          </div>

          <div class="form-group">
            <label for="patrol_boro">Patrol Borough</label>
            <input type="text" class="form-control" name = "patrol_borough" id="patrol_boro">
          </div>

          <div class="form-group">
            <label for="station_name">Station Name</label>
            <input type="text" class="form-control" name = "station" id="station_name">
          </div>

          <div class="form-group">
            <label for="vic_age_group">Victim Age Group</label>
            <input type="text" class="form-control" name = "victim_age" id="vic_age_group">
          </div>

          <div class="form-group">
            <label for="vic_race">Victim Race</label>
            <input type="text" class="form-control" name = "victim_race" id="vic_race">
          </div>

          <div class="form-group">
            <label for="vic_sex">Victim Sex</label>
            <input type="text" class="form-control" name = "victim_sex" id="vic_sex">
          </div>

          <button type="submit" name="f_submit" class="btn btn-primary">Submit</button>
        </form>
      </div>

    <?php
      if (isset($_POST['f_submit'])) {
        if ($result) { 
    ?>
          <h3 style ="text-align: center"> Complaint information inserted into system successfully. </h3>
    <?php 
        } else { 
    ?>
          <h3 style ="text-align: center"> Sorry, there was an error. Complaint data was not inserted. </h3>
    <?php 
        }
      } 
    ?>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>