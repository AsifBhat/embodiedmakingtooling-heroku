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
          clientId : '306371176841-t8cb5dfuc1tjsj8g6pglnfbkbhtripis.apps.googleusercontent.com',
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
/*          'https://www.googleapis.com/auth/userinfo.email',
          'https://www.googleapis.com/auth/userinfo.profile',*/

          // Add other scopes needed by your application.
        ];
//AppContext.making.userId = "";
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
          //_this.userId = resp.id;
          console.log(resp.id);
          //AppContext.making.userId = resp.id;
        }
      });
      if(window.location.hash.length == 0 && window.location.search.length == 0)
        AppContext.grid.loadPicker();
      else
        window.onload = AppContext.grid.loadApplication();
    
      $('.proj_title').attr('data-content', '<div class="title_edit"><button id="edit_project_name" class="btn btn-mini"> Edit <span class="icon-edit"></span></button>&nbsp;<button id="cl_edit_project_name" class="btn btn-mini"> Cancel <span class="icon-remove-sign"></span></button></div>');
    });
  } else {
    // No access token could be retrieved, force the authorization flow.
    gapi.auth.authorize(
        {'client_id': realtimeOptions.clientId, 'scope': SCOPES, 'immediate': false},
        handleAuthResult);
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