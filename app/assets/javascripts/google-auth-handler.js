var SCOPES = [
          'https://www.googleapis.com/auth/drive.file',
          'https://www.googleapis.com/auth/userinfo.email',
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/drive.install',
          'openid'

          // Add other scopes needed by your application.
        ];
AppContext.making.userId = "";
/**
 * Called when the client library is loaded.
 */
function handleClientLoad() {
  checkAuth();
}

/**
 * Check if the current user has authorized the application.
 */
function checkAuth() {
  gapi.auth.authorize(
      {'client_id': realtimeOptions.clientId, 'scope': SCOPES.join(' '), 'immediate': true},
      handleAuthResult);
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
          AppContext.making.userId = resp.id;
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