function check_form ()
{
	$('#level2_error0').hide();
	$('#level2_error1').hide();
	$('#level2_error2').hide();
	$('#level2_error3').hide();
	$('#level2_error4').hide();
	$('#level2_error5').hide();
	$('#level2_error6').hide();
	$('#level2_error7').hide();
	
	$('#no_good').hide();	
	$('#some_good').hide();		
	$('#all_good').hide();
	
	var a = clean_input($('#level2_q0').val()).toUpperCase();
	var b = clean_input($('#level2_q1').val()).toUpperCase();
	var c = clean_input($('#level2_q2').val()).toUpperCase();
	var d = clean_input($('#level2_q3').val());
	var e = clean_input($('#level2_q4').val()).toUpperCase();
	var f = clean_input($('#level2_q5').val()).toUpperCase();
	var g = clean_input($('#level2_q6').val()).toUpperCase();
	var h = clean_input($('#level2_q7').val()).toUpperCase();
	var points = 0;

	if (a == 'FROM')
	{
		points = points + 1;
	}
	else
	{
		$('#level2_error0').show();
	}
	if (b == 'RUN')
	{
		points = points + 1;
	}
	else
	{
		$('#level2_error1').show();
	}
	if (c == 'MAINTAINER')
	{
		points = points + 1;
	}
	else
	{
		$('#level2_error2').show();
	}
	if (d == '#')
	{
		points = points + 1;
	}
	else
	{
		$('#level2_error3').show();
	}

	if (e == 'ENTRYPOINT' || e == 'CMD')
	{
		points = points + 1;
	}
	else
	{
		$('#level2_error4').show();
	}
	
	if (f == 'USER')
	{
		points = points + 1;
	}
	else
	{
		$('#level2_error5').show();
	}
	
	if (g == 'EXPOSE')
	{
		points = points + 1;
	}
	else
	{
		$('#level2_error6').show();
	}
	if (h == 'ENTRYPOINT' || h == 'CMD')
	{
		points = points + 1;
	}
	else
	{
		$('#level2_error7').show();
	}
	
	
	if (points == 8) // all good
	{	
		$('#all_good').show();
	}
	else if (points == 0) // nothing good
	{
		$('#no_good').show();	
	}
	else // some good some bad
	{
		$('#some_good').show();
	}
	return (8- points);
}

function check_fill()
{
	$('#dockerfile_ok').hide();
	$('#dockerfile_ko').hide();
	
	var from = clean_input($('#from').val()).toUpperCase();
	var ubuntu = clean_input($('#ubuntu').val()).toUpperCase();
	var maintainer = clean_input($('#maintainer').val()).toUpperCase();
	var eric = clean_input($('#eric').val()).toUpperCase();
	var bardin = clean_input($('#bardin').val()).toUpperCase();
	var run0 = clean_input($('#run0').val()).toUpperCase();
	var run1 = clean_input($('#run1').val()).toUpperCase();
	var run2 = clean_input($('#run2').val()).toUpperCase();
	var run3 = clean_input($('#run3').val()).toUpperCase();
	var run4 = clean_input($('#run4').val()).toUpperCase();
	var run5 = clean_input($('#run5').val()).toUpperCase();
	var run6 = clean_input($('#run6').val()).toUpperCase();
	var entrypoint = clean_input($('#entrypoint').val()).toUpperCase();
	var user = clean_input($('#user').val()).toUpperCase();
	var expose = clean_input($('#expose').val()).toUpperCase();
	var gcc = clean_input($('#gcc').val()).toUpperCase();
	
	$('#from').attr("class", "input-small");
	$('#ubuntu').attr("class", "input-small");
	$('#maintainer').attr("class", "input-small");
	$('#eric').attr("class", "input-small");
	$('#bardin').attr("class", "input-small");
	$('#run0').attr("class", "input-small");
	$('#run1').attr("class", "input-small");
	$('#run2').attr("class", "input-small");
	$('#run3').attr("class", "input-small");
	$('#run4').attr("class", "input-small");
	$('#run5').attr("class", "input-small");
	$('#run6').attr("class", "input-small");
	
	$('#entrypoint').attr("class", "input-small");
	$('#user').attr("class", "input-small");
	$('#expose').attr("class", "input-small");
	$('#gcc').attr("class", "input-small");
	
	var errors = 0;
	
	if (from != "FROM")
	{
		$('#from').attr("class", "input-small error_input");
		errors = errors + 1;
	}
	if (ubuntu != "UNTU")
	{
		$('#ubuntu').attr("class", "input-small error_input");
		errors = errors + 1;
	}
	if (maintainer != "AINER")
	{
		$('#maintainer').attr("class", "input-small error_input");
		errors = errors + 1;
	}	
	if (eric != "BERTO")
	{
		$('#eric').attr("class", "input-small error_input");
		errors = errors + 1;
	}
	if (bardin != "SHIOKA")
	{
		$('#bardin').attr("class", "input-small error_input");
		errors = errors + 1;
	}	
	if (run0 != "RUN")
	{
		$('#run0').attr("class", "input-small error_input");
		errors = errors + 1;
	}	
	if (run1 != "RUN")
	{
		$('#run1').attr("class", "input-small error_input");
		errors = errors + 1;
	}	
	if (run2 != "RUN")
	{
		$('#run2').attr("class", "input-small error_input");
		errors = errors + 1;
	}
	if (run3 != "RUN")
	{
		$('#run3').attr("class", "input-small error_input");
		errors = errors + 1;
	}
	if (run4 != "RUN")
	{
		$('#run4').attr("class", "input-small error_input");
		errors = errors + 1;
	}
	if (run5 != "RUN")
	{
		$('#run5').attr("class", "input-small error_input");
		errors = errors + 1;
	}
	if (run6 != "RUN")
	{
		$('#run6').attr("class", "input-small error_input");
		errors = errors + 1;
	}

	if (gcc != "GCC")
	{
		$('#gcc').attr("class", "input-small error_input");
		errors = errors + 1;
	}
	if (entrypoint != "ENTRYPOINT")
	{
		$('#entrypoint').attr("class", "input-small error_input");
		errors = errors + 1;
	}
	if (user != "USER")
	{
		$('#user').attr("class", "input-small error_input");
		errors = errors + 1;
	}
	if (expose != "EXPOSE")
	{
		$('#expose').attr("class", "input-small error_input");
		errors = errors + 1;
	}

	if (errors != 0)
	{
		$('#dockerfile_ko').show();
	}
	else
	{
		$('#dockerfile_ok').show();
	}
	return (errors);
}

$(document).ready(function() {

    $("#check_level2_questions").click( function()
       {
        errors = check_form();
        dockerfile_log(2, '1_questions', errors);
       }
    );

    $("#check_level2_fill").click( function()
    {
        var errors = check_fill();
        dockerfile_log(2, '2_fill', errors);
    });
});
