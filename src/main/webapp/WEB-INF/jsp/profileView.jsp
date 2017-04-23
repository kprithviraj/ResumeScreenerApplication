<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Upload Standards Data</title>

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                var model = model = "${personList}";
                var userIds = model.split(",");
                var currentUserId = "";
                $('#previous-button').addClass("disabled");

                populateDataWithUserId(userIds[0]);

                $('#previous-button').click(function(ev){
                    if(!!currentUserId){
                        currentUserId = userIds[userIds.indexOf(currentUserId) - 1];
                    }
                    if(userIds.indexOf(currentUserId)===0){
                        $('#previous-button').addClass("disabled");
                    }
                    populateDataWithUserId(currentUserId);
                });

                $('#next-button').click(function(ev){
                    if(!!currentUserId) {
                        currentUserId = userIds[userIds.indexOf(currentUserId) + 1];
                    } else {
                        currentUserId = userIds[0];
                    }
                    if(userIds.length-1 == userIds.indexOf(currentUserId)){
                        $('#next-button').addClass("disabled");
                    }
                    populateDataWithUserId(currentUserId);
                });

            function populateDataWithUserId(userId){
                alert("gettingData for " + userId);
                $.ajax({
                    type: "POST",
                    url: "/getDataById",
                    dataType : "text",
                    data: {userId :userId},
                    error: function (e) {
                        console.log(e);
                        alert("An error occurred. Please refresh the page and try again.");
                    },
                    success: function (response) {
                        var person = JSON.parse(response);
                        currentUserId = person.id;
                        $("#firstName").val(person.fname);
                        $("#lastName").val(person.lname);
                        $("#emailId").val(person.emailId);
                        $("#phone").val(person.phone);
                        $('#previous-button').removeClass("disabled");
                    }
                }); // end of ajax call
            } // End of function populateDataWithUserId
            }); //End of document ready
        </script>
    </head>

    <body class="white-bg ">
    <div class="container">
            <div class="row">
                <div id="resume-div" class="col-md-8 well">
                    <a>Prithvi</a>
                </div>
                <div id="actions-div" class="col-md-4 well">
                      <button id="shortlist-button" type="button" class="btn btn-success">Shortlist</button>
                      <button type="reject-button" class="btn btn-danger">Reject</button>
                      <br>
                      <br>
                      <br>
                      APPLICATION
                      <br>
                      <br>
                      <br><br>FirstName : <input type="text" id="firstName" />
                      <br><br>LastName : <input type="text" id="lastName" />
                      <br><br>Email : <input type="text" id="emailId" />
                      <br><br>Phone: <input type="text" id="phone" />

                      <br>
                      <br>
                      <button id="previous-button" type="button" class="btn">Previous</button>
                      <button id="next-button" class="btn">Next</button>

                </div>
            </div>
        </div>
    </body>
</html>
