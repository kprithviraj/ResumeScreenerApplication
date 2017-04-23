<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Darwin Registration</title>

<spring:url value="/resources/core/css/hello.css" var="coreCss" />
<spring:url value="/resources/core/css/bootstrap.min.css" var="bootstrapCss" />
<link href="${bootstrapCss}" rel="stylesheet" />
<link href="${coreCss}" rel="stylesheet" />
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
                <form role="form" method="POST" action="#">

                    <legend class="text-center">Register</legend>

                    <fieldset>
                        <legend>Member Registration</legend>

                        <div class="form-group col-md-6">
                            <label for="first_name">First name</label>
                            <input type="text" class="form-control" name="" id="first_name" placeholder="First Name">
                        </div>

                        <div class="form-group col-md-6">
                            <label for="last_name">Last name</label>
                            <input type="text" class="form-control" name="last_name" id="last_name" placeholder="Last Name">
                        </div>

                        <div class="form-group col-md-12">
                            <label for="">Email</label>
                            <input type="email" class="form-control" name="" id="email" placeholder="Email">
                        </div>

                        <div class="form-group col-md-12">
                            <label for="">Upload CV</label>
                            <input class="btn " type= "file" id="file" type="text" name="filePath">
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
            var validationString = areInputsValid();
            if(validationString === "success"){

            } else {
                alert(validationString);
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