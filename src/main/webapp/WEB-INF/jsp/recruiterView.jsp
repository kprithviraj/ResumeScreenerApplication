<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Darwin Box</title>

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
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
    	<div class="navbar-header">
    		<a class="navbar-brand">Recruiters View</a>
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
                              <table class="table table-striped">
                                <thead>
                                  <tr>
                                  <th>Firstname</th>
                                  <th>Email and Phone</th>
                                  <th>Status</th>
                                  <th>Application Date</th>
                                  <th>Application</th>
                                  </tr>
                                  <c:forEach var="person" items="${personList}">
                                    <tr>
                                        <td>${person.fname} ${person.lname}</td>
                                        <td>${person.emailId}<br>${person.phone}</td>
                                        <td>${person.status}</td>
                                        <td>${person.applicationDate}</td>
                                        <td><input type='button' class="cv-button" name=${person.id}.${person.cvType}>A PDF Doc</a></td>
                                    </tr>
                                   </c:forEach>

                                </thead>
                              </table>
                            </div>

                        </fieldset>
                    </form>
                </div>

            </div>
        </div>
    </body>
</html>
