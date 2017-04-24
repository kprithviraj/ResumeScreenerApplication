<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Darwin Registration</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>

<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container">
	<div class="navbar-header">
		<a class="navbar-brand" href="#">Darwin Box</a>
	</div>
  </div>
</nav>

<div class="container">
        <div class="row">

            <div class="col-md-8 col-md-offset-2">
                <form role="form" method="POST" action="uploadFile" enctype="multipart/form-data">

                    <legend class="text-center">Register</legend>

                    <fieldset>
                        <legend>Member Registration</legend>

                        <div class="form-group col-md-6">
                            <label for="first_name">First name</label>
                            <input type="text" class="form-control" name="first_name" id="first_name" placeholder="First Name">
                        </div>

                        <div class="form-group col-md-6">
                            <label for="last_name">Last name</label>
                            <input type="text" class="form-control" name="last_name" id="last_name" placeholder="Last Name">
                        </div>

                        <div class="form-group col-md-12">
                            <label for="">Email</label>
                            <input type="email" class="form-control" name="email" id="email" placeholder="Email">
                        </div>

                        <div class="form-group col-md-6">
                            <label for="">Phone</label>
                            <input type="phone" class="form-control" name="phone" id="phone" placeholder="Phone">
                        </div>

                        <div class="form-group col-md-12">
                            <label for="">Upload CV</label>
                            <input class="btn" type= "file" name="file" id="file" type="text" name="filePath">
                        </div>
                    </fieldset>

                    <div class="form-group">
                        <div class="col-md-12">
                            <button id="register-button" type="submit" class="btn btn-primary">
                                Register
                            </button>
                        </div>
                    </div>

                </form>
            </div>

        </div>
    </div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>

</body>
</html>

<script type="text/javascript">
    $(document).ready(function(){
        $('#register-button').click(function(ev){
            $('#register-button').addClass("disabled");
            var validationString = areInputsValid();
            if(validationString === "success"){

            } else {
                alert(validationString);
                $('#register-button').removeClass("disabled");
                return;
            }
        });

        function areInputsValid(){
            if(!$("#first_name").val()){
                return "Please enter a valid first name";
            }

            if(!$("#last_name").val()){
                return "Please enter a valid last name";
            }

            if(!$("#email").val()){
                return "Please enter a valid email id";
            }

            return "success";
        }






    });//End of document ready
</script>