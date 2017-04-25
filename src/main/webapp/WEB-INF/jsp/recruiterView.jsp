<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Recruiter View</title>

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="/resources/core/css/darwinbox.css">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                $.ajax({
                    type: "POST",
                    url: "/getAllUsersList",
                    dataType : "text",
                    error: function (e) {
                        console.log(e);
                        alert("An error occurred. Please refresh the page and try again.");
                    },
                    success: function (response) {
                        var userData = JSON.parse(response);
                        var table = $("#data-table");
                        for(var i=0; i<userData.length ; i++){
                            var user = userData[i];
                            var d = new Date(user.applicationDate);
                            var applicationDate = d.getDate() + "-" + d.getMonth() + "-" + d.getFullYear();
                            var days = Math.round((new Date() - d)/(1000*60*60*24));
                            var finalDays = days == 0 ? "Today" : days + " day(s) ago";
                            var googleURL = "http://docs.google.com/gview?url=";
                            var microsoftURL = "https://view.officeapps.live.com/op/view.aspx?src=";
                            var amazonURL = "https://s3.ap-south-1.amazonaws.com/prithvirajk/";
                            var fileName = user.id + "." + user.cvType;
                            var googleOrMSURL = user.cvType == "pdf" ? googleURL : microsoftURL;
                            var finalURL = googleOrMSURL + amazonURL + fileName + "&embedded=true";
                            $('<tr/>').appendTo(table)
                                .append(
                                        '<td><b>'+user.fname + " " + user.lname
                                        +'</td><td><b>'+user.emailId + "<br> " + user.phone
                                        +'</td><td><b>'+user.status
                                        +'</td><td><b>'+applicationDate + "<br></b>" + finalDays
                                        +'</td><td>'+"<a target='_blank' class='glyphicon glyphicon-open-file' href=" + finalURL + "></a>(" + user.cvType.toUpperCase() + ")"
                                );
                            }
                    } //success
                }); // end of ajax call


                $('.cv-button').click(function(ev){
                   var fileName = $(ev.currentTarget).attr('name');
                   var location = '/getCV?fileName=' + fileName;
                    window.open(location,'_blank');
                });
            }); //End of document ready
        </script>
    </head>

    <body class="white-bg ">
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div clas="row">
            <div class="col-xs-8"
            <div class="navbar-header">
            <a href="/recruiterView" class="navbar-brand">Recruiters View</a>
            </div>
            <div class="col-xs-4">
            <a href="/profileView" class="navbar-brand">Individual Profile View</a>
            </div>
        </div>
    </div>
</nav>

    <div class="container">
            <div class="row">
                <div class="col-md-8">
                    <form role="form" method="POST" action="#">

                        <legend class="text-center">Register</legend>

                        <fieldset>
                            <div class="container">
                              <table id="data-table" class="table table-striped">
                                <thead>
                                  <tr>
                                  <th>Firstname</th>
                                  <th>Email and Phone</th>
                                  <th>Status</th>
                                  <th>Application Date</th>
                                  <th>Application</th>
                                  </tr>
                                </thead>
                              </table>
                            </div>

                        </fieldset>
                    </form>
                </div>

            </div>
        </div>
        <input type="hidden" id="allPersonData" value=${personList}></input>
    </body>
</html>
