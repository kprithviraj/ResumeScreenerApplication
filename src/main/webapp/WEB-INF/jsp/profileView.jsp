<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Profile View</title>

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="/resources/core/css/profileview.css">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                var model = "${personList}";
                if(!!model) {
                    var userIds = model.split(",");
                    var currentUserId = "";

                    $('#previous-button').hide();

                    if(userIds.length){
                        populateDataWithUserId(userIds[0]);
                    }
                }else {
                    alert("No user present in the database");
                }

                $('#previous-button').click(function(ev){
                    if(!!currentUserId){
                        currentUserId = userIds[userIds.indexOf(currentUserId) - 1];
                    }
                    populateDataWithUserId(currentUserId);
                });

                $('#next-button').click(function(ev){
                    if(!!currentUserId) {
                        currentUserId = userIds[userIds.indexOf(currentUserId) + 1];
                    } else {
                        currentUserId = userIds[0];
                    }
                    populateDataWithUserId(currentUserId);
                });

                $('.status-button').click(function(ev){
                    var status="";
                    if($(ev.currentTarget).text() == "SHORTLIST"){
                        $(ev.currentTarget).text("SHORTLISTING");
                        $('#shortlist-button').addClass('disabled');
                        $("#reject-button").hide();
                        status = "SHORTLISTED";
                    } else {
                        $(ev.currentTarget).text("REJECTING");
                        $('#reject-button').addClass('disabled');
                        $("#shortlist-button").hide();
                        status = "REJECTED";
                    }
                    changeUserStatus(status);
                });

                function populateDataWithUserId(userId){
                    if(!!userId){
                    $("#resumeIframe").attr("src", "");
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
                            var googleURL = "http://docs.google.com/gview?url=";
                            var microsoftURL = "https://view.officeapps.live.com/op/view.aspx?src=";
                            var amazonURL = "https://s3.ap-south-1.amazonaws.com/prithvirajk/";
                            var fileName = person.id + "." + person.cvType;
                            var googleOrMSURL = person.cvType == "pdf" ? googleURL : microsoftURL;
                            var finalURL = googleOrMSURL + amazonURL + fileName + "&embedded=true";
                            $("#firstName").text(person.fname);
                            $("#lastName").text(person.lname);
                            $("#emailId").text(person.emailId);
                            $("#phone").text(person.phone);
                            $("#status").text(person.status);
                            $("#userId").val(person.id);
                            $("#resumeIframe").attr("src", finalURL);
                            resetShortListAndRejectButtons();
                        }
                    }); // end of ajax call

                    }

                } // End of function populateDataWithUserId

                function changeUserStatus(status){
                    var userId = $("#userId").val();
                     if(!!userId){
                     $.ajax({
                         type: "POST",
                         url: "/changeUserStatus",
                         dataType : "text",
                         data: {userId :userId, status : status},
                         error: function (e) {
                             console.log(e);
                             alert("An error occurred. Please refresh the page and try again.");
                         },
                         success: function (response) {
                             if(status=="SHORTLISTED") {
                                $("#shortlist-button").text(status);
                             } else {
                                $("#reject-button").text(status);
                             }
                         }
                     }); // end of ajax call
                     } else{
                        resetShortListAndRejectButtons();
                     }

                }//End of changeUserStatus

                function resetShortListAndRejectButtons(){
                 $("#shortlist-button").show().text("SHORTLIST");
                 $("#shortlist-button").removeClass("disabled")
                 $("#reject-button").show().text("REJECT");
                 $("#reject-button").removeClass('disabled');
                 $('#previous-button').show();
                 $('#next-button').show();
                  if(userIds && userIds.length>0){
                      if(userIds.indexOf(currentUserId)===0){
                         $('#previous-button').hide();
                      }
                      if(userIds.length-1 == userIds.indexOf(currentUserId)){
                          $('#next-button').hide();
                      }
                  }

                }

            }); //End of document ready
        </script>
    </head>

    <body class="white-bg ">
    <div class="container m-t-lg">
        <div class="row">
            <div id="resume-div" class="col-md-8">
                <iframe id="resumeIframe" src="about:blank" width="600" height="600"></iframe>
            </div>
            <div id="actions-div" class="col-md-4">
                  <button id="shortlist-button" class="btn btn-outlined btn-success status-button">SHORTLIST</button>
                  <button id="reject-button" class="btn btn-outlined btn-danger status-button">REJECT</button>
                  <br>
                  <br>
                  <br>
                  APPLICATION
                  <br>
                  <br><br>FirstName : <span type="text" id="firstName"></span>
                  <br><br>LastName : <span type="text" id="lastName"></span>
                  <br><br>Email : <span type="text" id="emailId"></span>
                  <br><br>Phone: <span type="text" id="phone"></span>
                  <br><br>Status: <span type="text" id="status"></span>
                  <input type="hidden" id="userId"></input>

                  <br>
                  <br>
            </div>
        <a id="previous-button" class="left-arrow">
        <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
        </a>
        <a id="next-button" class="right-arrow">
        <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
        </a>
        </div>
    </div>
    </body>
</html>
