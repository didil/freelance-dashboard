function refreshNumJobs(){
    $("#num_jobs").html( $("li.job").length + " jobs");
}

function highlightNewJobs() {
    $("li.new_job").css({'background-color':'#88ff88'}).animate({'background-color':'transparent'}, 700);
}

function showLoader(){
    $("#jobs_loading").show();
}

$(function(){
    $('#keywords_container').tooltip({
        selector: '[class=keyword]' , title: 'Click to delete' ,placement:'bottom'
    });

    $("#keywords_list").on("click", "a.keyword", function(){
            showLoader();
        }
    );

   $("#refresh_btn, #keyword_form :submit").click(function(){
           showLoader();
       }
   );

});