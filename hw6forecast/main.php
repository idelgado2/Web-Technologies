<!-- 
  Dark Sky API Key: b61f7fb0abca06db1a09e7ed42ce4eb3
  Google API: AIzaSyCbW4NU1d10r_R9n8WW2OBrpBb96-dGkAQ

  example using Google API:
    https://maps.googleapis.com/maps/api/geocode/xml?address=[terra canyon, san antonio, texas]&key=AIzaSyCbW4NU1d10r_R9n8WW2OBrpBb96-dGkAQ
  example using Dark Sky API:
    https://api.forecast.io/forecast/b61f7fb0abca06db1a09e7ed42ce4eb3/29.6287275,-98.6544454?exclude=minutely,hourly,alerts,flags

-->

<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<style>
  #graphButton{
    background-color: #3499eb;
    border: none;
    color: white;
    padding: 15px;
    text-align: center;
    font-size: 16px;
  }
  div.weatherSearchBox {
    border-style: solid;
    border-width: 5px;
    border-color: black;
    border-radius: 25px;
  }
  div.weatherCard{
    border-style: solid;
    border-width: 5px;
    border-color: black;
    border-radius: 25px;
  }
  div.weatherTable{
    border-style: solid;
    border-width: 5px;
    border-color: black;
    border-radius: 25px;
  }
  div.dailySummaryCard{
    border-style: solid;
    border-width: 5px;
    border-color: black;
    border-radius: 25px;
  }
  div.weatherDetailCard{
    border-style: solid;
    border-width: 5px;
    border-color: black;
    border-radius: 25px;
  }

  div.weatherCard table, tr, td{
    border: 1px solid black;
    border-collapse: collapse;
  }

  table#weatherTableTest, th, td {
    border: 1px solid black;
    border-collapse: collapse;
  }
  td a {
    text-decoration: none;
    color: black;
  }
</style>
<?php
//$xml = file_get_contents("https://en.wikipedia.org/wiki/Metro_Boomin");
//echo $xml;
//$response = http_get("http://www.example.com/file.xml");
  if ($_POST["street"] || $_POST["city"] || $_POST["state"] || $_POST["currentLoc"])
  {
    //$street = $_POST["street"];
    //$city = $_POST["city"];
    //$state = $_POST["state"];
    $street;
    $city;
    $state;
    $geocodeAPI;
    $responseJSON;
    $jsonObj;
    $latitude;
    $longitude;
    if($_POST["currentLoc"]){
      $geocodeAPI = "http://ip-api.com/json";
      $responseJSON = file_get_contents($geocodeAPI);
      $jsonObj = json_decode($responseJSON, true);
      $latitude =  $jsonObj['lat'];
      $longitude = $jsonObj['lon'];
    }else{
      $street = $_POST["street"];
      $city = $_POST["city"];
      $state = $_POST["state"];
      $geocodeAPI = "https://maps.googleapis.com/maps/api/geocode/xml?address=[" . $street . "," . $city . "," . $state . "]&key=AIzaSyCbW4NU1d10r_R9n8WW2OBrpBb96-dGkAQ";
      $responseXML = file_get_contents($geocodeAPI);
      $xmlObj=simplexml_load_string($responseXML);
      $latitude =  $xmlObj->result->geometry->location->lat;
      $longitude = $xmlObj->result->geometry->location->lng;
    }

      //echo $latitude;
      //echo $longitude;
    $darkSkyAPI = "https://api.forecast.io/forecast/b61f7fb0abca06db1a09e7ed42ce4eb3/".$latitude.",".$longitude."?exclude=minutely,hourly,alerts,flags";
      //echo $darkSkyAPI;
    $responseJSON = file_get_contents($darkSkyAPI);
    //$responseJSON = file_get_contents("/Users/isaacdelgado/Documents/weather.json");
    $jsonObj = json_decode($responseJSON, true);
    $timeZone = $jsonObj['timezone'];
    $currentTemperature = $jsonObj['currently']['temperature'];
    $summary = $jsonObj['currently']['summary'];
    $humidity = $jsonObj['currently']['humidity'];
    $pressure = $jsonObj['currently']['pressure'];
    $windSpeed = $jsonObj['currently']['windSpeed'];
    $visibility = $jsonObj['currently']['visibility'];
    $cloudCover = $jsonObj['currently']['cloudCover'];
    $ozone = $jsonObj['currently']['ozone'];

    //This is for detailWeather Card

    $date = $jsonObj['daily']['data'][0]['time'];
    $status = $jsonObj['daily']['data'][0]['icon'];
    $summaryDaily = $jsonObj['daily']['data'][0]['summary'];
    $temperatureHigh = $jsonObj['daily']['data'][0]['temperatureHigh'];
    $temperatureLow = $jsonObj['daily']['data'][0]['temperatureLow'];
    $windSpeedDaily = $jsonObj['daily']['data'][0]['windSpeed'];

  }     
?>
<script type="text/javascript">
  function getWeather(what){
        //var street = what.street.value;
        //var city = what.city.value;
        //var state = what.state.value;
        //var geocodeAPI = "https://maps.googleapis.com/maps/api/geocode/xml?address=[" + street + "," + city + "," + state + "]&key=AIzaSyCbW4NU1d10r_R9n8WW2OBrpBb96-dGkAQ"
        
        var checkBoxStatus = document.getElementById("myLocationCheck");
        var streetElement = document.getElementById("streetID");
        var cityElement = document.getElementById("cityID");
        var stateElement = document.getElementById("stateID");

        if(checkBoxStatus.checked == true){
          //do IP-API search
          document.getElementById("searchForm").submit();
        }
        else if(streetElement.value == "" || cityElement.value == "" || stateElement.value == "notSelected"){
          //validate input
          alert("Invalid Input");
        }
        else{
          //search using data provided
          document.getElementById("searchForm").submit();
        }
        //document.getElementById("geoAPIResponse").innerHTML = getlocationPHP;
        //document.getElementById("street").innerHTML = street;
        //document.getElementById("city").innerHTML = city;
        //document.getElementById("state").innerHTML = state;
        //document.getElementById("geoAPI").innerHTML = geocodeAPI;
  }

  function clearInput(){
    document.getElementById("streetID").value = "";
    document.getElementById("cityID").value = "";
    document.getElementById("stateID").selectedIndex = "0";
  }

  function currentLoctionOption(){
    var checkBoxStatus = document.getElementById("myLocationCheck");
    var streetElement = document.getElementById("streetID");
    var cityElement = document.getElementById("cityID");
    var stateElement = document.getElementById("stateID");
    if (checkBoxStatus.checked == true){
      //disable input options
      streetElement.setAttribute("disabled", true);
      cityElement.setAttribute("disabled", true);
      stateElement.setAttribute("disabled", true);
      document.getElementById("stateID").selectedIndex = "0";
    } else {
      //enable input options
      streetElement.removeAttribute("disabled");
      cityElement.removeAttribute("disabled");
      stateElement.removeAttribute("disabled");
    }
  }

  function getDailySummary(index){  //have to add one to the index cause php takes 0 as false
    switch(index){
      case 1:
      //alert("im in case 0");
      document.getElementById("indexID").value = 1;
      document.getElementById("latID").value = "<?php echo $latitude?>";
      document.getElementById("lngID").value = "<?php echo $longitude?>";
        break;
      case 2:
      //alert("im in case 1");
      document.getElementById("indexID").value = 2;
      document.getElementById("latID").value = "<?php echo $latitude?>";
      document.getElementById("lngID").value = "<?php echo $longitude?>";
        break;
      case 3:
      //alert("im in case 2");
      document.getElementById("indexID").value = 3;
      document.getElementById("latID").value = "<?php echo $latitude?>";
      document.getElementById("lngID").value = "<?php echo $longitude?>";
        break;
      case 4:
      //alert("im in case 3");
      document.getElementById("indexID").value = 4;
      document.getElementById("latID").value = "<?php echo $latitude?>";
      document.getElementById("lngID").value = "<?php echo $longitude?>";
        break;
      case 5:
      //alert("im in case 4");
      document.getElementById("indexID").value = 5;
      document.getElementById("latID").value = "<?php echo $latitude?>";
      document.getElementById("lngID").value = "<?php echo $longitude?>";
        break;
      case 6:
      //alert("im in case 5");
      document.getElementById("indexID").value = 6;
      document.getElementById("latID").value = "<?php echo $latitude?>";
      document.getElementById("lngID").value = "<?php echo $longitude?>";
        break;
      case 7:
      //alert("im in case 6");
      document.getElementById("indexID").value = 7;
      document.getElementById("latID").value = "<?php echo $latitude?>";
      document.getElementById("lngID").value = "<?php echo $longitude?>";
        break;
      case 8:
      //alert("im in case 7");
      document.getElementById("indexID").value = 8;
      document.getElementById("latID").value = "<?php echo $latitude?>";
      document.getElementById("lngID").value = "<?php echo $longitude?>";
         break;
      default:
        //alert("im hit the default case");
    }
    
    document.getElementById("dailySummaryIndexID").submit();
  }
</script>
</head>
<body>
<div class = "weatherSearchBox">
  <h1>Weather Search</h1>
  <p>This is a paragraph.</p>
  <form name="weatherQuery" id="searchForm" method="post">
    Street:
    <input type="text" id="streetID" name="street" value="">
    <br>
    City:
    <input type="text" id="cityID" name="city" value="">
    <br>
    State:
    <select name="state" id="stateID">
      <option value="notSelected">State</option>
      <option value="null" disabled>----------------------</option>
      <option value="alabama">Alabama</option>
      <option value="alaska">Alaska</option>
      <option value="arizona">Arizona</option>
      <option value="arkansas">Arkansas</option>
      <option value="california" >California</option>
      <option value="colorado" >Colorado</option>
      <option value="Connecticut" >Connecticut</option>
      <option value="Delaware" >Delaware</option>
      <option value="Florida" >Florida</option>
      <option value="Georgia" >Georgia</option>
      <option value="Hawaii">Hawaii</option>
      <option value="Idaho">Idaho</option>
      <option value="Illinois">Illinois</option>
      <option value="Indiana">Indiana</option>
      <option value="Iowa" >Iowa</option>
      <option value="Kansas" >Kansas</option>
      <option value="Kentucky" >Kentucky</option>
      <option value="Louisiana" >Louisiana</option>
      <option value="Maine" >Maine</option>
      <option value="Maryland" >Maryland</option>
      <option value="Massachusetts">Massachusetts</option>
      <option value="Michigan">Michigan</option>
      <option value="Minnesota">Minnesota</option>
      <option value="Mississippi">Mississippi</option>
      <option value="Missouri" >Missouri</option>
      <option value="Montana" >Montana</option>
      <option value="Nebraska" >Nebraska</option>
      <option value="Nevada" >Nevada</option>
      <option value="New Hampshire" >New Hampshire</option>
      <option value="New Jersey" >New Jersey</option>
      <option value="New Mexico">New Mexico</option>
      <option value="New York">New York</option>
      <option value="North Carolina">North Carolina</option>
      <option value="North Dakota">North Dakota</option>
      <option value="Ohio" >Ohio</option>
      <option value="Oklahoma" >Oklahoma</option>
      <option value="Oregon" >Oregon</option>
      <option value="Pennsylvania" >Pennsylvania</option>
      <option value="Rhode Island" >Rhode Island</option>
      <option value="South Carolina" >South Carolina</option>
      <option value="South Dakota">South Dakota</option>
      <option value="Tennessee">Tennessee</option>
      <option value="Texas">Texas</option>
      <option value="Utah">Utah</option>
      <option value="Vermont" >Vermont</option>
      <option value="Virginia" >Virginia</option>
      <option value="Washington" >Washington</option>
      <option value="West Virginia" >West Virginia</option>
      <option value="Wisconsin" >Wisconsin</option>
      <option value="Wyoming" >Wyoming</option>
    </select>
    <br><br>
    <input type="button" value="search" onClick="getWeather(this.form);">
    <input type="button" value="clear" onClick="clearInput();">
    <input name="currentLoc" type="checkbox" id="myLocationCheck" onClick="currentLoctionOption();">
    <label for="currentLoc">Current Location</label>
  </form> 
</div>

<?php
  if ($_POST["street"] || $_POST["city"] || $_POST["state"]||$_POST["currentLoc"]){
    echo "<div class=\"weatherCard\"><h1>Weather Card</h1>
      <table>
        <tr>
          <td colspan=\"6\">".$_POST["city"]."</td>
        </tr>
        <tr>
          <td colspan=\"6\">".$timeZone."</td>
        </tr>
        <tr>
          <td colspan=\"6\">".$currentTemperature."</td>
        </tr>
        <tr>
          <td colspan=\"6\">".$summary."</td>
        </tr>
        <tr>
          <td>".$humidity."</td>
          <td>".$pressure."</td>
          <td>".$windSpeed."</td>
          <td>".$visibility."</td>
          <td>".$cloudCover."</td>
          <td>".$ozone."</td>
        </tr>
      </table>
    </div>";
    echo "<br>";

    echo "<div class=\"weatherTable\">
            <table id=\"weatherTableTest\">
              <tr>
              <th>Date</th>
              <th>Status</th> 
              <th>Summary</th>
              <th>TemperatureHigh</th>
              <th>TemperatureLow</th>
              <th>Wind Speed</th>
              </tr>";
              $counter = 1;
              foreach($jsonObj['daily']['data'] as $value){
                echo"
                  <tr>
                    <td>"."<a href=\"javascript:getDailySummary(".$counter.")\">".$value['time']."</a></td>
                    <td>"."<a href=\"javascript:getDailySummary(".$counter.")\">".$value['icon']."</a></td>
                    <td>"."<a href=\"javascript:getDailySummary(".$counter.")\">".$value['summary']."</a></td>
                    <td>"."<a href=\"javascript:getDailySummary(".$counter.")\">".$value['temperatureHigh']."</a></td>
                    <td>"."<a href=\"javascript:getDailySummary(".$counter.")\">".$value['temperatureLow']."</a></td>
                    <td>"."<a href=\"javascript:getDailySummary(".$counter.")\">".$value['windSpeed']."</a></td>
                  </tr>";
                  $counter += 1;
                }
            echo "</table></div>";
  }elseif ($_POST["dailyIndex"]){
    $indexdata = $_POST["dailyIndex"];
    $latitudeTemp = $_POST["latdaily"];
    $longitudeTemp = $_POST["lngdaily"];

    $geoDetail = "https://api.forecast.io/forecast/b61f7fb0abca06db1a09e7ed42ce4eb3/".$latitudeTemp.",".$longitudeTemp."?exclude=minutely,hourly,alerts,flags";
    //echo $geoDetail;
    $responseJSONDetail = file_get_contents($geoDetail);
    $jsonObjDetail = json_decode($responseJSONDetail, true);
    $dateDetail = $jsonObjDetail['daily']['data'][($indexdata - 1)]['time'];
    $darkSkyAPIDetail = "https://api.forecast.io/forecast/b61f7fb0abca06db1a09e7ed42ce4eb3/".$latitudeTemp.",".$longitudeTemp.",".$dateDetail."?exclude=minutely";
    //echo $darkSkyAPIDetail;
    $responseJSONDetailTime = file_get_contents($darkSkyAPIDetail);
    $jsonObjDetailTime = json_decode($responseJSONDetailTime, true);
    $summaryDetail = $jsonObjDetailTime['currently']['summary'];
    $temperatureDetail = $jsonObjDetailTime['currently']['temperature'];
    $iconDetail = $jsonObjDetailTime['currently']['icon'];
    //$precipDetail = $jsonObjDetailTime['currently']['precipIntensity'];
    $rainChanceDetail = ($jsonObjDetailTime['currently']['precipProbability']*100);
    $windSpeedDetail = $jsonObjDetailTime['currently']['windSpeed'];
    $humidityDetail = ($jsonObjDetailTime['currently']['humidity']*100);
    $visibilityDetail = $jsonObjDetailTime['currently']['visibility'];
    $sunRiseDetail = $jsonObjDetailTime['daily']['data'][0]['sunriseTime'];
    $sunSetDetail = $jsonObjDetailTime['daily']['data'][0]['sunsetTime'];

    if($jsonObjDetailTime['currently']['precipIntensity'] <= 0.001){
      $precipDetail = "None";
    }elseif($jsonObjDetailTime['currently']['precipIntensity'] <= 0.015){
      $precipDetail = "Very Light";
    }elseif($jsonObjDetailTime['currently']['precipIntensity'] <= 0.05){
      $precipDetail = "Light";
    }elseif($jsonObjDetailTime['currently']['precipIntensity'] <= 0.1){
      $precipDetail = "Moderate";
    }else{
      $precipDetail = "Heavy";
    }
    

    echo "<div class=\"weatherDetailCard\"><h1>Weather Detail Card</h1>
          <table>
            <tr>
            <td>".$summaryDetail."</td>
            </tr>
            <tr>
            <td>".$temperatureDetail."</td>
            </tr>
            <tr>
            <td>Precipitation: ".$precipDetail."</td>
            </tr>
            <tr>
            <td>Chance of Rain: ".$rainChanceDetail."%</td>
            </tr>
            <tr>
            <td>Wind Speed: ".$windSpeedDetail."mph</td>
            </tr>
            <tr>
            <td>Humidity: ".$humidityDetail."%</td>
            </tr>
            <tr>
            <td>Visibility: ".$visibilityDetail."mi</td>
            </tr>
            <tr>
            <td>Sunrise/Sunset: ".$sunRiseDetail."/".$sunSetDetail."</td>
            </tr>
          </table>
          ";
    echo "</div>";
    echo " <button type=\"button\" onclick=\"showGraph();\" id=\"graphButton\">Click Me To Show Graph!</button> ";
    $hourcounter = 0;
    $hourArray = array();
    foreach($jsonObjDetailTime['hourly']['data'] as $valueTime){
      $hourArray[$hourcounter] = $valueTime['temperature'];
      $hourcounter += 1;
    }
  }
?>
<script type="text/javascript">
var temp;
  function testFunction(){
    //temp = [<?php echo '"'.implode('","', $hourArray).'"' ?>];
    //document.getElementById("tesst").innerHTML = temp[0];
  }
  function showGraph(){
    temp = [<?php echo '"'.implode('","', $hourArray).'"' ?>];
    google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Hour', 'Temperature'],
          ['1',  parseInt(temp[0])],
          ['2',  parseInt(temp[1])],
          ['3',  parseInt(temp[2])],
          ['4',  parseInt(temp[3])],
          ['5',  parseInt(temp[4])],
          ['6',  parseInt(temp[5])],
          ['7',  parseInt(temp[6])],
          ['8',  parseInt(temp[7])],
          ['9',  parseInt(temp[8])],
          ['10',  parseInt(temp[8])],
          ['11',  parseInt(temp[10])],
          ['12',  parseInt(temp[11])],
          ['13',  parseInt(temp[12])],
          ['14',  parseInt(temp[13])],
          ['15',  parseInt(temp[14])],
          ['16',  parseInt(temp[15])],
          ['17',  parseInt(temp[16])],
          ['18',  parseInt(temp[17])],
          ['19',  parseInt(temp[18])],
          ['20',  parseInt(temp[19])],
          ['21',  parseInt(temp[20])],
          ['22',  parseInt(temp[21])],
          ['23',  parseInt(temp[22])],
          ['24',  parseInt(temp[23])],
        ]);

        var options = {
          title: 'Day\'s Hourly Weather',
          curveType: 'function',
          legend: { position: 'bottom' },
          hAxis:{
            title:'Time',
            logScale: true
          },
          vAxis:{
            title: 'Temperature',
            logScale: false
          }
        };

        var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));

        chart.draw(data, options);
      }
      document.getElementById("curve_chart").style.display = 'block';
  }
</script>
  <form name="dailySummaryIndex" id="dailySummaryIndexID" method="post">
    <input type="text" id="indexID" name="dailyIndex" value="" style="display: none;">
    <input type="text" id="latID" name="latdaily" value="" style="display: none;">
    <input type="text" id="lngID" name="lngdaily" value="" style="display: none;">
  </form> 
  <p id="tesst"></p>
  <div id="curve_chart" style="width: 900px; height: 500px; display: none;"></div>
</body>
</html>