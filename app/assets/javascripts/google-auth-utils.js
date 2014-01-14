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
function handleAuthResult(file_state) {
  console.log('Logging the file_state:');
  console.log(file_state);
  var startAuthorization = function(authResult) {
    console.log('Access Token recieved. Requests can now be sent to the Google Application');
    console.log(authResult);
    if (authResult  && !authResult.error) {
        // Access token has been successfully retrieved, requests can be sent to the API
        var _this = this;
        gapi.client.load('oauth2', 'v2', function() {
          if(file_state == 'old'){
            console.log('Util something');
            // start the load picker
            gapi.load('picker', {'callback': createPicker});

            var picker = null;
            // Create and render a Picker object for searching images.
            function createPicker() {
              picker = new google.picker.PickerBuilder().
                  addView(new google.picker.View(google.picker.ViewId.DOCS).
                    setQuery('.ema')).
                  enableFeature(google.picker.Feature.NAV_HIDDEN).
                  setDeveloperKey(developerKey).
                  setCallback(pickerCallback).
                  build();
              picker.setVisible(true);
            }

            // A simple callback implementation.
            function pickerCallback(data) {
              console.log('Calling picker callback');
              var url = 'nothing';
              if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
                var doc = data[google.picker.Response.DOCUMENTS][0];
                url = doc[google.picker.Document.URL];
              }
              if(url != 'nothing')
                window.location.replace(url);
            }

          }
          else {
            window.onload = AppContext.grid.loadApplication();
            //gapi.client.oauth2.userinfo.get().execute(function(resp) {});
            //Fetch and set the User Info.
            AppContext.project.getUserInfo();
          }
        });
      } else {
        // No access token could be retrieved, force the authorization flow.
        $('body').append('<div id="authModal" class="modal hide fade auth_perm_modal" tabindex="-1" role="dialog" aria-labelledby="authModalLabel" aria-hidden="true"><div class="modal-header text-center"><h4 id="authModalLabel">Please Authorize The Embodied Making Tool for Saving your changes to <u>Your</u> Google Drive</h4></div><div class="modal-footer"><button class="btn btn-primary" aria-hidden="true" data-dismiss="modal" id="auth_em_btn">Authorize</button><button id="cancel_auth" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button></div></div>');

        $('#authModal').modal({
          show: true,
          keyboard: false
        });

        $('#auth_em_btn').click( function() {
          gapi.auth.init( function() {
            gapi.auth.authorize({
              client_id: googleAppConf().clientId, 
              scope: [
                rtclient.INSTALL_SCOPE,
                rtclient.FILE_SCOPE,
                rtclient.OPENID_SCOPE
              ], 
              user_id: undefined,
              immediate: false
            },startAuthorization);
          });  
        });
      }    
  }
  startAuthorization();
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