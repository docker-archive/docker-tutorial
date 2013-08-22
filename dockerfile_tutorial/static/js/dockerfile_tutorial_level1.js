function check_form ()
{
	$('#level1_error0').hide();
	$('#level1_error1').hide();
	$('#level1_error2').hide();
	$('#level1_error3').hide();
	
	$('#no_good').hide();	
	$('#some_good').hide();		
	$('#all_good').hide();
	
	var a = clean_input($('#level1_q0').val()).toUpperCase();
	var b = clean_input($('#level1_q1').val()).toUpperCase();
	var c = clean_input($('#level1_q2').val()).toUpperCase();
	var d = clean_input($('#level1_q3').val());
	var points = 0;
	
	if (a == 'FROM')
	{
		points = points + 1;
	}
	else
	{
		$('#level1_error0').show();
	}
	if (b == 'RUN')
	{
		points = points + 1;
	}
	else
	{
		$('#level1_error1').show();
	}
	if (c == 'MAINTAINER')
	{
		points = points + 1;
	}
	else
	{
		$('#level1_error2').show();
	}
	if (d == '#')
	{
		points = points + 1;
	}
	else
	{
		$('#level1_error3').show();
	}
	if (points == 4) // all good
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
	return (4 - points);
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
	var memcached = clean_input($('#memcached').val()).toUpperCase();
	var run2 = clean_input($('#run2').val()).toUpperCase();
	
	$('#from').attr("class", "input-small");
	$('#ubuntu').attr("class", "input-small");
	$('#maintainer').attr("class", "input-small");
	$('#eric').attr("class", "input-small");
	$('#bardin').attr("class", "input-small");
	$('#run0').attr("class", "input-small");
	$('#run1').attr("class", "input-small");
	$('#memcached').attr("class", "input-small");
	$('#run2').attr("class", "input-small");
	
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
	if (maintainer != "MAINTAINER")
	{
		$('#maintainer').attr("class", "input-small error_input");
		errors = errors + 1;
	}	
	if (eric != "RIC")
	{
		$('#eric').attr("class", "input-small error_input");
		errors = errors + 1;
	}
	if (bardin != "ARDIN")
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
	if (memcached != "MEMCACHED")
	{
		$('#memcached').attr("class", "input-small error_input");
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

    $("#check_level1_questions").click( function()
       {
        errors = check_form();
        dockerfile_log(1, '1_questions', errors);
       }
    );

    $("#check_level1_fill").click( function()
    {
        var errors = check_fill();
        dockerfile_log(1, '2_fill', errors);
    });
});
