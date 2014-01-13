var googleAppConf = function(){
    if (window.location != undefined){
      var browserURL = window.location + '';
      if(browserURL.indexOf("localhost") != -1 )
        return {
          clientId : '71045400673-s9agh1hpuunu5v2k46bkbpivdrvf8ibj.apps.googleusercontent.com',
          browserKey : 'AIzaSyBYEmPSy44XpEXayCK9Xt8_vw_qKLFAkFs'
        };
      else if (browserURL.indexOf('emtool-staging.herokuapp') != -1)
        return {
          clientId : '883917966367-h1np3jeqi9v00aku4ugphoh1f5939jnk.apps.googleusercontent.com',
          browserKey : 'AIzaSyD7MkLjTksTUuovzbvMfXHMrYMh7EnYAz4'
        };        
      else if (browserURL.indexOf('embodiedmaking.com') != -1 )
        return {
          clientId : '306371176841-vkomb513h9hj2coj9301pgs9snsh9kdk.apps.googleusercontent.com',
          browserKey : 'AIzaSyDbCHB5i1vFDi73J3Zxg5aDxQ-DWttdViI'
        };
      return {
        clientId: '',
        browserKey: ''
      };
    }
  }

var SCOPES = [
          'https://www.googleapis.com/auth/drive.file',
          'https://www.googleapis.com/auth/drive.install',
          'openid'
        ];
/**
 * Called when the client library is loaded.
 */
function fetchClientDetails(callback) {
  console.log('Handle Client Load');
  checkAuth(callback);
}

/**
 * Check if the current user has authorized the application.
 */
function checkAuth(callback) {
  console.log('Checking Authorization');
  gapi.auth.authorize(
      {'client_id': googleAppConf().clientId, 'scope': SCOPES.join(' '), 'immediate': true},
      callback);
}

/**
 * Called when authorization server replies.
 *
 * @param {Object} authResult Authorization result.
 */
function handleAuthResult(authResult) {
  if (authResult) {
    // Access token has been successfully retrieved, requests can be sent to the API
    console.log('Access Token recieved. Requests can now be sent to the Google Application');
    console.log(authResult);
    var _this = this;
    gapi.client.load('oauth2', 'v2', function() {
      gapi.client.oauth2.userinfo.get().execute(function(resp) {
        if (resp.id) {
          console.log(resp.id);
        }
      });
      if(window.location.hash.length == 0 && window.location.search.length == 0)
        AppContext.grid.loadPicker();
      else
        window.onload = AppContext.grid.loadApplication();
      //Fetch and set the User Info.
      AppContext.project.getUserInfo();
    });
  } else {
    console.log('The application cannot call google API, please make sure that you are logged in');
    // No access token could be retrieved, force the authorization flow.
    $('body').append('<div id="authModal" class="modal hide fade auth_perm_modal" tabindex="-1" role="dialog" aria-labelledby="authModalLabel" aria-hidden="true"><div class="modal-header text-center"><h4 id="authModalLabel">Please Authorize The Embodied Making Tool for Saving your changes to <u>Your</u> Google Drive</h4></div><div class="modal-footer"><button class="btn btn-primary" aria-hidden="true" data-dismiss="modal" id="auth_em_btn">Authorize</button><button id="cancel_auth" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button></div></div>');

    $('#authModal').modal({
      show: true,
      keyboard: false
    });

    $('#auth_em_btn').click( function() {
      gapi.auth.init( function() {
        console.log('Initializing the authorization process');
        gapi.auth.authorize({
          client_id: googleAppConf().clientId, 
          scope: [
            rtclient.INSTALL_SCOPE,
            rtclient.FILE_SCOPE,
            rtclient.OPENID_SCOPE
          ], 
          user_id: undefined,
          immediate: false
        },handleAuthResult);
      });  
    });
  }
}

function getUserName(authResult){
  console.log('Fetching user name');
  if(authResult){
    console.log('Authorized');
    setTimeout (AppContext.project.getUserInfo, 10000);
  }
  else{
    console.log ('Not Authorized');
  }
}