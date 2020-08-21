$(document).ready(function(){

////////////////////////////////////////////////
//  MOBILE MENU SLIDE OUT
///////////////////////////////////////////////
  $('.menu_btn').click(function(){
    var menu = $('#main_menu');
    var menu_btn = $(this);
    var veil = $('#veil');

    if ( menu.hasClass('open') ) {
      menu.removeClass('open');
      veil.removeClass('active');
    }
    else {
      menu.addClass('open');
      veil.addClass('active');
    }

    scrollLock();
  });

////////////////////////////////////////////////
//  LOGIN POPUP
///////////////////////////////////////////////
  $('#login_btn, #login_close, a[href^="login.cfm"]').click(function(e){
    e.preventDefault();
    if( $('#login_content').hasClass('active') ) {
      $('#login_content').removeClass('active');
      $('#veil').removeClass('active');
    }
    else {
      $('#login_content').addClass('active');
      $('#veil').addClass('active');
      if ( $('#main_menu').hasClass('open') ) { $('#main_menu').removeClass('open'); }
    }
  });

////////////////////////////////////////////////
//  LOGIN VALIDATION
///////////////////////////////////////////////
$('#login_submit').click(function(e){
  e.preventDefault();
  $(".notification").removeClass('error success');

  // Set form values to variables
  var lm = $('#lmfield').val();
  var username = $('#usernamefield').val();
  var password = $('#passwordfield').val();

  $.ajax({
    'url': 'loginAction.cfm',
    'type': 'POST',
    'dataType': 'json',
    'data': {
      'lm': lm,
      'uname': username,
      'pword': password
    },
    'success': function(response) {
      if(response['STATUS'] == "Success") { // Successful login
       // console.log(response);
		    window.location=response['redirect'];
      } 
      else { // Login failed, call error()
        this.error();
      }
    },
    'error': function(jqXHR, textStatus, errorThrown) {
      $(".notification").addClass('error');
    }
  });

});


////////////////////////////////////////////////
//  MENU SUB-MENUS (MOBILE & TABLET)
///////////////////////////////////////////////

  // Add Class to Menu Items w/ Sub Menus
  $('#main_menu li ul, #sidebar li ul').parent().addClass('has_sub_menu'); 

  // Mobile click event
  $('.has_sub_menu').on('click', function(){
    if( $(this).hasClass('active') ) {
      $(this).removeClass('active').find('ul').slideUp(); 
    }
    else {
      $('.has_sub_menu').removeClass('active').find('ul').slideUp(); /* Close any open menus */
      $(this).addClass('active').find('ul').slideDown(); 
    }
  });

  // Desktop hover event
  if ( $('#desktop_indicator').is(':visible') ) {
    $('#main_menu .has_sub_menu').on('mouseenter', function(){
      /* If doesn't have active class, close all menus and open this one */
      if( !$(this).hasClass('active') ) {
        $('.has_sub_menu').removeClass('active').find('ul').hide();
        $(this).addClass('active').find('ul').show();
      }
    }).on('mouseleave', function(){
        $(this).removeClass('active').find('ul').hide(); 
    });
  }

////////////////////////////////////////////////
//  SHOW OR HIDE READ MORE LINKS
///////////////////////////////////////////////
  $('.article_text').each(function(){
    if ( $('#desktop_indicator').is(":visible") && $(this).height() >= 120 ) {
      $(this).parent().next('.read_more').addClass('active');
    }
    else if ( $(this).height() >= 180 ) {
      $(this).parent().next('.read_more').addClass('active');
    }
  }); 

////////////////////////////////////////////////
//  ARTICLE MODAL
///////////////////////////////////////////////
  $('.read_more').click(function(){

    var article = $(this).closest('.article');

    if ( article.hasClass('active') ) {
      $(this).html('Read More');
      article.removeClass('active');
      $('#veil').removeClass('active');
    }
    else  {
      $(this).html('<i class="fa fa-times" aria-hidden="true"></i>');
      article.addClass('active');
      $('#veil').addClass('active');
    }

    $('#veil').click(function(){
      $('.read_more').html('Read More');
      article.removeClass('active');
      $('#veil').removeClass('active');
      $('html, body').removeClass('locked');
    });

    scrollLock();

  }); 

////////////////////////////////////////////////
//  MORE INFO POPUP
///////////////////////////////////////////////
  $('.more_link').click(function(e){
    e.preventDefault();
    fieldDetails($(this));
  }).contextmenu(function(e){
    fieldDetails($(this));
    e.preventDefault();
  });

  function fieldDetails(tgt){
    var more_info = tgt.next('.more_info');
    if( more_info.hasClass('active') ) {
      more_info.fadeOut().removeClass('active');
    }
    else {
      $('.more_info').fadeOut().removeClass('active');
      more_info.fadeIn().addClass('active');
    }
    $('.close_field_info').click(function(){
      $('.more_info').fadeOut().removeClass('active');
    });
  }

////////////////////////////////////////////////
//  STANDINGS / RESULTS
///////////////////////////////////////////////
  $('.standings_row').click(function(){
    var team_results = $(this).next('.hidden_row');
    if( team_results.hasClass('active') ) {
      $(this).removeClass('active');
      team_results.removeClass('active').hide();
    }
    else {
      $('.standings_row, .hidden_row').removeClass('active');
      $('.hidden_row').hide();
      $(this).addClass('active');
      team_results.addClass('active').show();
    }
  });

////////////////////////////////////////////////
//  ADD TO CALENDAR
///////////////////////////////////////////////
  $('.calendar_trigger, #calendar_close').click(function(){
    var calendarPopup = $('#calendar_popup');
    var notification = $('.notification');

    $('input[name=sch_gm_id]').val("");
    $('input[name=sch_fld_id]').val("");
    $('input[name=sch_gm_date]').val("");
    $('input[name=sch_gm_time]').val("");
    $('input[name=sch_gm_field]').val("");
    $('input[name=sch_gm_home_team]').val("");
    $('input[name=sch_gm_away_team]').val("");

    if (notification.hasClass('success')){
      notification.removeClass('success');
    } else {
      notification.removeClass('error');
    }

    if (calendarPopup.hasClass('active')){
      calendarPopup.removeClass('active');
      $('#veil').removeClass('active');
    } else {
      $('input[name=sch_gm_id]').val($(this).attr("data-game-id"));
      $('input[name=sch_fld_id]').val($(this).attr("data-field-id"));
      $('input[name=sch_gm_date]').val($(this).attr("data-date"));
      $('input[name=sch_gm_time]').val($(this).attr("data-time"));
      $('input[name=sch_gm_field]').val($(this).attr("data-field"));
      $('input[name=sch_gm_home_team]').val($(this).attr("data-home-team"));
      $('input[name=sch_gm_away_team]').val($(this).attr("data-away-team"));

      calendarPopup.addClass('active');
      $('#veil').addClass('active');
    }
    
    scrollLock();
  });
  $('.iCalForm').submit(function(e){
    e.preventDefault();
    var user_email = $('input[name=user_email]').val();
    var notification = $(this).find('.notification');

    if( !isEmail(user_email) ) {
      notification.addClass('error').text('Please enter a valid email address.');
    }

    $.ajax({
      'url': 'iCal/index.cfm',
      'type': 'POST',
      'dataType': 'json',
      'data': $(this).serialize(),
      'success': function(response) {
        notification.addClass('success').text('Success! Your email has sent.');

        setTimeout(function(){
          $("#calendar_close").click()
        },2000);
      },
      'error': function(jqXHR, textStatus, errorThrown) {
        notification.addClass('error').text('An error occurred please try again.');
      }
    });
  });

////////////////////////////////////////////////
//  EMAIL VALIDATION
///////////////////////////////////////////////
function isEmail(email) {
  var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  return regex.test(email); }

////////////////////////////////////////////////
//  SCROLL LOCK FUNCTION
///////////////////////////////////////////////
  function scrollLock() {
    var page = $('html, body');

    if (page.hasClass('locked')) {
      page.removeClass('locked');
    }
    else {
      page.addClass('locked');
    }
  } 

});