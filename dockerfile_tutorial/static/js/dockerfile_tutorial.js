if (!String.prototype.trim)
{
	String.prototype.trim = function() { return this.replace(/^\s+|\s+$/g, ''); };
}

function clean_input(i)
{
	return (i.trim());
}

function dockerfile_log(level, name, errors)
{
	var logUrl = 'dockerfile_tutorial_log.php';
	$.ajax({
			url: logUrl,
			type: "POST",
			cache:false,
			data: {
				'errors': errors,
				'level': level,
				'name': name,
			},
		}).done( function() { } );
}

function validate_email(email)
{ 
	var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
	return re.test(email);
} 

$(document).ready(function() {
    $("#send_email").click( function()
    {
        $('#email_invalid').hide();
        $('#email_already_registered').hide();
        $('#email_registered').hide();

        email = $('#email').val();
        if (!validate_email(email))
        {
            $('#email_invalid').show();
            return (false);
        }

        var emailUrl = '../subscribe/';
        var csrftoken = $.cookie('csrftoken');
        console.log (csrftoken);

        $.ajax({
                url: emailUrl,
                type: "POST",
                cache:false,
                data: {
                    'csrfmiddlewaretoken': csrftoken,
                    'email': email,
                    'from_level': 1,
                },
            }).done( function(data ) {
                    if (data == 1) // already registered
                    {
                        $('#email_already_registered').show();
                    }
                    else if (data == 0) // registered ok
                    {
                        $('#email_registered').show();
                    }

                } );
        return (true);
    });
})
