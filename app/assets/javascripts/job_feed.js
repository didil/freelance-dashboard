function refreshNumJobs(){
    $("#num_jobs").html( $("li.job").length + " jobs");
}

function highlightNewJobs() {
    $("li.new_job").css({'background-color':'#88ff88'}).animate({'background-color':'transparent'}, 700);
}

$(function(){
    $("a.keyword").tooltip({ title: 'Click to delete' ,placement:'bottom' });

   $("#refresh_btn, a.keyword, #keyword_form :submit").click(function(){
           $("#jobs_loading").show();
       }
   );

});