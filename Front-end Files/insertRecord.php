<?php

if (isset($_POST['f_submit'])) {

    require_once("conn.php");

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
    $var_patrol_borough = $_POST['patrol_borough'];
    $var_station = $_POST['station'];
    $var_victim_age = $_POST['victim_age'];
    $var_victim_race = $_POST['victim_race'];
    $var_victim_sex = $_POST['victim_sex'];
    
    
    $query = "CALL insert_proc(
              :cmplnt_num,
              :cmplnt_fr_dt,
              :cmplnt_fr_tm,
              :cmplnt_to_dt,
              :cmplnt_to_tm,
              :addr_pct_cd,
              :rpt_dt,
              :ky_cd,
              :ofns_desc,
              :pd_cd,
              :pd_desc,
              :crm_atpt_cptd_cd,
              :law_cat_cd,
              :boro_nm,
              :loc_of_occur_desc,
              :prem_typ_desc,
              :juris_desc,
              :jurisdiction_code,
              :parks_nm,
              :hadevelopt,
              :housing_psa,
              :x_coord_cd,
              :y_coord_cd,
              :susp_age_group,
              :susp_race,
              :susp_sex,
              :transit_district,
              :latitude,
              :longitude,
              :patrol_boro,
              :station_name,
              :vic_age_group,
              :vic_race,
              :vic_sex)";

    try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindValue(':cmplnt_num', $var_complaint_num, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':cmplnt_fr_dt', $var_from_date, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':cmplnt_fr_tm', $var_from_time, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':cmplnt_to_dt', $var_end_date, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':cmplnt_to_tm', $var_end_time, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':addr_pct_cd', $var_precinct_code, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':rpt_dt', $var_report_date, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':ky_cd', $var_key_cd, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':ofns_desc', $var_offense_desc, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':pd_cd', $var_pd_cd, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':pd_desc', $var_pd_desc, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':law_cat_cd', $var_law_category, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':crm_atpt_cptd_cd', $var_completed_code, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':boro_nm', $var_borough, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':loc_of_occur_desc', $var_location_of_occurence, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':prem_typ_desc', $var_premesis, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':juris_desc', $var_jurisdiction, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':jurisdiction_code', $var_jurisdiction_code, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':parks_nm', $var_park, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':hadevelopt', $var_housing_development, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':housing_psa', $var_housing_code, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':x_coord_cd', $var_coordX, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':y_coord_cd', $var_coordY, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':susp_age_group', $var_suspect_age, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':susp_race', $var_suspect_race, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':susp_sex', $var_suspect_sex, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':transit_district', $var_transit, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':latitude', $var_lat, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':longitude', $var_long, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':patrol_boro', $var_patrol_borough, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':station_name', $var_station, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':vic_age_group', $var_victim_age, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':vic_race', $var_victim_race, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':vic_sex', $var_victim_sex, PDO::PARAM_STR);

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
                <a class="nav-link" href="getMega.php">Reported Crimes</a>
              </li>
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                  Classifications and Codes
                </a>
                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                  <li><a class="dropdown-item" href="externalClass.php">External Classifications</a></li>
                  <li><a class="dropdown-item" href="internalClass.php">Internal Classifications</a></li>
                </ul>
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

<h1 style="text-align: center"> Complaint Insert Form </h1>
<h3 style="text-align: center"> Please use this form to insert complaint information</h3>
      <div class="container">
        <form method="post">
          <div class="form-group">
              <label for="cmplt_num">
                <b>Complaint Number</b>
              </label>
              <p>Persistent ID for each complaint</p>
              <input type="number" class="form-control" name="complaint_num" id="cmplt_num"> 
          </div>

          <div class="form-group">
            <label for="cmplnt_fr_dt">
                <b>Complaint Start Date (DD/MM/YYYY)</b>
            </label>
            <p>Exact date of occurrence for the reported event</p>
            <input type="text" class="form-control" name = "from_date" id="cmplnt_fr_dt">
          </div>

          <div class="form-group">
            <label for="cmplnt_fr_tm">
              <b>Complaint Start Time (HH:MM:SS)</b>
            </label>
            <p>Exact time of occurrence for the reported event</p>
            <input type="text" class="form-control" name = "from_time" id="cmplnt_fr_tm">
          </div>

          <div class="form-group">
            <label for="cmplnt_to_dt">
              <b>Complaint End Date (DD/MM/YYYY)</b>
            </label>
            <p>Ending date of occurrence for the reported event, if exact time of occurrence is unknown</p>
            <input type="text" class="form-control" name = "end_date" id="cmplnt_to_dt">
          </div>

          <div class="form-group">
            <label for="cmplnt_to_tm">
              <b>Complaint End Time (HH:MM:SS)</b>
            </label>
            <p>Ending time of occurrence for the reported event, if exact time of occurrence is unknown</p>
            <input type="text" class="form-control" name = "end_time" id="cmplnt_to_tm">
          </div>

          <div class="form-group">
            <label for="addr_pct_cd">
              <b>Precinct Code (1-123)</b>
            </label>
            <p>The precinct in which the incident occurred</p>
            <input type="text" class="form-control" name = "precinct_code" id="addr_pct_cd">
          </div>

          <div class="form-group">
            <label for="rpt_dt">
              <b>Report Date (DD/MM/YYYY)</b>
            </label>
            <p>Date event was reported to police</p>
            <input type="text" class="form-control" name = "report_date" id="rpt_dt">
          </div>

          <div class="form-group">
            <label for="ky_cd">
              <b>Offense Key Code (101-881)</b>
            </label>
            <p>Three digit offense classification code</p>
            <input type="number" class="form-control" name = "key_cd" id="ky_cd">
          </div>

          <div class="form-group">
            <label for="ofns_desc">
              <b>Offense Description</b>
            </label>
            <p>Description of offense corresponding with key code</p>
            <input type="text" class="form-control" name = "offense_desc" id="ofns_desc">
          </div>

          <div class="form-group">
            <label for="pd_cd">
              <b>Internal Classification Code (101-975)</b>
            </label>
            <p>Three digit internal classification code (more granular than Key Code)</p>
            <input type="text" class="form-control" name = "pd_cd" id="pd_cd">
          </div>

          <div class="form-group">
            <label for="pd_desc">
              <b>Internal Classification Description</b>
            </label>
            <p>Description of internal classification corresponding with PD code</p>
            <input type="text" class="form-control" name = "pd_desc" id="pd_desc">
          </div>

          <div class="form-group">
            <label for="crm_atpt_cptd_cd">
              <b>Crime Completion Code</b>
            </label>
            <p>Indicator of whether crime was successfully COMPLETED or ATTEMPTED, but failed or was interrupted prematurely</p>
            <input type="text" class="form-control" name = "completed_code" id="crm_atpt_cptd_cd">
          </div>

          <div class="form-group">
            <label for="law_cat_cd">
              <b>Law Category Code</b>
            </label>
            <p>Level of offense: felony, misdemeanor, violation</p>
            <input type="text" class="form-control" name = "law_category" id="law_cat_cd">
          </div>

          <div class="form-group">
            <label for="boro_nm">
              <b>Borough Name</b>
            </label>
            <p>The name of the borough in which the incident occurred</p>
            <input type="text" class="form-control" name = "borough" id="boro_nm">
          </div>

          <div class="form-group">
            <label for="loc_of_occur_desc">
              <b>Location of Occurence</b>
            </label>
            <p>Specific location of occurrence in or around the premises: INSIDE, OPPOSITE OF, FRONT OF, REAR OF</p>
            <input type="text" class="form-control" name = "location_of_occurence" id="loc_of_occur_desc">
          </div>

          <div class="form-group">
            <label for="prem_typ_desc">
              <b>Premesis Type</b>
            </label>
            <p>Specific description of premises; grocery store, residence, street, etc.</p>
            <input type="text" class="form-control" name = "premesis" id="prem_typ_desc">
          </div>

          <div class="form-group">
            <label for="juris_desc">
              <b>Jurisdiction</b>
            </label>
            <p>Description of the jurisdiction code</p>
            <input type="text" class="form-control" name = "jurisdiction" id="juris_desc">
          </div>

          <div class="form-group">
            <label for="jurisdiction_cd">
              <b>Jurisdiction Code</b>
            </label>
            <p>Jurisdiction responsible for incident. Either internal, like Police(0), Transit(1), and Housing(2); or external(3), like Correction, Port Authority, etc<p>
            <input type="text" class="form-control" name = "jurisdiction_code" id="jurisdiction_cd">
          </div>

          <div class="form-group">
            <label for="parks_nm">
              <b>Park Name</b>
            </label>
            <p>Name of NYC park, playground or greenspace of occurrence, if applicable</p>
            <input type="text" class="form-control" name = "park" id="parks_nm">
          </div>

          <div class="form-group">
            <label for="hadevelopt">
              <b>Housing Development</b>
            </label>
            <p>Name of NYCHA housing development of occurrence, if applicable</p>
            <input type="text" class="form-control" name = "housing_development" id="hadevelopt">
          </div>

          <div class="form-group">
            <label for="housing_psa">
              <b>Housing Code</b>
            </label>
            <p>Development Level Code</p>
            <input type="number" class="form-control" name = "housing_code" id="housing_psa">
          </div>

          <div class="form-group">
            <label for="x_coord_cd">
              <b>X-Coordinate</b>
            </label>
            <p>X-coordinate for New York State Plane Coordinate System, Long Island Zone, NAD 83, units feet</p>
            <input type="text" class="form-control" name = "coordX" id="x_coord_cd">
          </div>

          <div class="form-group">
            <label for="y_coord_cd">
              <b>Y-Coordinate</b>
            </label>
            <p>X-coordinate for New York State Plane Coordinate System, Long Island Zone, NAD 83, units feet</p>
            <input type="text" class="form-control" name = "coordY" id="y_coord_cd">
          </div>

          <div class="form-group">
            <label for="susp_age_group">
              <b>Suspect Age Group</b>
            </label>
            <p>Suspect’s Age Group: <18, 18-24, 25-44, 45-64, 65+<p>
            <input type="text" class="form-control" name = "suspect_age" id="susp_age_group">
          </div>

          <div class="form-group">
            <label for="susp_race">
              <b>Suspect Race</b>
            </label>
            <p>Suspect’s Race Description</p>
            <input type="text" class="form-control" name = "suspect_race" id="susp_race">
          </div>

          <div class="form-group">
            <label for="susp_sex">
              <b>Suspect Sex</b>
            </label>
            <p>Suspect’s Sex Description: F=Female, M=Male, U=UNKNOWN</p>
            <input type="text" class="form-control" name = "suspect_sex" id="susp_sex">
          </div>

          <div class="form-group">
            <label for="transit_district">
              <b>Transit District</b>
            </label>
            <p>Transit district in which the offense occurred</p>
            <input type="text" class="form-control" name = "transit" id="transit_district">
          </div>

          <div class="form-group">
            <label for="latitude">
              <b>Latitude</b>
            </label>
            <p>Midblock Latitude coordinate for Global Coordinate System, WGS 1984, decimal degrees</p>
            <input type="text" class="form-control" name = "lat" id="latitude">
          </div>

          <div class="form-group">
            <label for="longitude">
              <b>Longitude</b>
            </label>
            <p>Midblock Longitude coordinate for Global Coordinate System, WGS 1984, decimal degrees</p>
            <input type="text" class="form-control" name = "long" id="longitude">
          </div>

          <div class="form-group">
            <label for="patrol_boro">
              <b>Patrol Borough</b>
            </label>
            <p>The name of the patrol borough in which the incident occurred</p>
            <input type="text" class="form-control" name = "patrol_borough" id="patrol_boro">
          </div>

          <div class="form-group">
            <label for="station_name">
              <b>Station Name</b>
            </label>
            <p>Transit station name</p>
            <input type="text" class="form-control" name = "station" id="station_name">
          </div>

          <div class="form-group">
            <label for="vic_age_group">
              <b>Victim Age Group</b>
            </label>
            <p>Victim’s Age Group: <18, 18-24, 25-44, 45-64, 65+</p>
            <input type="text" class="form-control" name = "victim_age" id="vic_age_group">
          </div>

          <div class="form-group">
            <label for="vic_race">
              <b>Victim Race</b>
            </label>
            <p>Victim’s Race Description</p>
            <input type="text" class="form-control" name = "victim_race" id="vic_race">
          </div>

          <div class="form-group">
            <label for="vic_sex">
              <b>Victim Sex</b>
            </label>
            <p>Victim’s Sex Description (D=Business/Organization, E=PSNY/People of the State of New York, F=Female, M=Male)</p>
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
    
    <footer class="py-2 bg-dark" style="position:relative; bottom:0; width: 100%;">
        <div class="container px-3 px-md-3">
          <p class="m-0 text-center text-white"> CS 3265, Project Two. Created By: Chanteria Milner and Sneh Patel </p></div>
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>