const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const PORT = process.env.PORT || 3000;
const app = express();
const XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;

//search variables
var street = "";
var city = "";
var state = "";
var currentLocation = false;
var lat = "";
var lng = "";
var jsonobject = "";

app.use(bodyParser.json());
app.use(cors());

app.get('/', function(req, res){
    res.send('Hello from server, this is done through this great tutorial');
})

app.post('/forecasttest', function(req, res){
    console.log(req.body);
    res.status(200).send({"message":"Data received"})
})

/*
app.post('/forecast', function(req,res){
    var jsonData = JSON.parse(JSON.stringify(req.body));
    setSearchVariables(jsonData);
    getWeatherData();
    console.log(jsonobject);
    //getWeatherData();
}) */

app.post('/forecast_ip', function(req, res){
    var jsonObj = req.body;
    lat = jsonObj['latitude'];
    lng = jsonObj['longitude'];
    weather_url = "https://api.forecast.io/forecast/b61f7fb0abca06db1a09e7ed42ce4eb3/"+lat+","+lng+"?exclude=minutely";
    var weather_xhr = new XMLHttpRequest;
    weather_xhr.open("GET", weather_url, true);
    weather_xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200){
            jsonobject = this.responseText;
            //at this point I want to send information back to angular
            res.status(200).send(jsonobject);
        }
    }
    weather_xhr.send();
})

app.post('/forecast', function(req,res){
    var jsonData = JSON.parse(JSON.stringify(req.body)); //request body is the send search in json structure -- street, city, state
    setSearchVariables(jsonData);   //set the incoming search request into individual varibales
    //getting coordinates associated with the search
    var coordinates_url = "https://maps.googleapis.com/maps/api/geocode/xml?address=[" +street+","+city+","+state+"]&key=AIzaSyCbW4NU1d10r_R9n8WW2OBrpBb96-dGkAQ";
    var weather_url = "";
    var xhr = new XMLHttpRequest;
    var myjsonObj = "";
    xhr.open("GET", coordinates_url, true);
    xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var xmlDoc = this.responseText;
            var parseString = require('xml2js').parseString;
            parseString(xmlDoc, function (err, result) {
                myjsonObj = JSON.parse(JSON.stringify(result));
            });
            lat = myjsonObj.GeocodeResponse.result[0].geometry[0].location[0].lat[0];
            lng = myjsonObj.GeocodeResponse.result[0].geometry[0].location[0].lng[0];
            weather_url = "https://api.forecast.io/forecast/b61f7fb0abca06db1a09e7ed42ce4eb3/"+lat+","+lng+"?exclude=minutely";
            //call weather api to get the full weather report
            var weather_xhr = new XMLHttpRequest;
            weather_xhr.open("GET", weather_url, true);
            weather_xhr.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200){
                    jsonobject = this.responseText;
                    //at this point I want to send information back to angular
                    res.status(200).send(jsonobject);
                }
            }
            weather_xhr.send();
        }
    };
    xhr.send();
})

app.listen(PORT, function(){
    console.log("Server running on localhost:" + PORT);
})

function setSearchVariables(jsonObj){
    street = jsonObj['street'];
    city = jsonObj['city'];
    state = jsonObj['state'];
    currentLocation = jsonObj['currentLocation'];
}
function getWeatherData(){
    var url = "https://maps.googleapis.com/maps/api/geocode/xml?address=[" +street+","+city+","+state+"]&key=AIzaSyCbW4NU1d10r_R9n8WW2OBrpBb96-dGkAQ";
    var xhr = new XMLHttpRequest;
    var myjsonObj = "";
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var xmlDoc = this.responseText;
            var parseString = require('xml2js').parseString;
            parseString(xmlDoc, function (err, result) {
                myjsonObj = JSON.parse(JSON.stringify(result));
            });
            lat = myjsonObj.GeocodeResponse.result[0].geometry[0].location[0].lat[0];
            lng = myjsonObj.GeocodeResponse.result[0].geometry[0].location[0].lng[0];
            callWeatherAPI(lat, lng);
        }
    };
    xhr.send();
}

function callWeatherAPI(lat, lng){
    var url = "https://api.forecast.io/forecast/b61f7fb0abca06db1a09e7ed42ce4eb3/"+lat+","+lng+"?exclude=minutely,hourly,alerts,flags";
    var xhr = new XMLHttpRequest;
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200){
            jsonobject = this.responseText;
            //I don't want to parse this, I want to send it straight to the client and let them parse it.
            //console.log(myjsonObj.currently.temperature);
        }
    }
    xhr.send();
}
