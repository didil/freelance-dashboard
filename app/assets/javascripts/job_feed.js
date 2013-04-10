function refreshNumJobs(){
    $("#num_jobs").html( $("li.job").length + " jobs");
}

function highlightNewJobs() {
    $("li.new_job").css({'background-color':'#88ff88'}).animate({'background-color':'transparent'}, 700);
}