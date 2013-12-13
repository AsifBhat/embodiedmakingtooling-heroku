/**
 * Options for the Realtime loader.
 */
var realtimeOptions = {
  /**
   * Client ID from the console.
   * Original ID */
   // for localhost
   //changed to match the local Client-ID
   clientId: '71045400673-s9agh1hpuunu5v2k46bkbpivdrvf8ibj.apps.googleusercontent.com',
   
   // for heroku-staging 
   // Changed to match the Client ID for Heroku App
   //clientId: '883917966367-h1np3jeqi9v00aku4ugphoh1f5939jnk.apps.googleusercontent.com',


  /**
   * The ID of the button to click to authorize. Must be a DOM element ID.
   */
  authButtonElementId: 'authorizeButton',

  /**
   * Function to be called when a Realtime model is first created.
   */
  initializeModel: initializeModel,

  /**
   * Autocreate files right after auth automatically.
   */
  autoCreate: true,

  /**
   * The name of newly created Drive files.
   */
  defaultTitle: "Embodied Making Analysis.ema",

  /**
   * The MIME type of newly created Drive Files. By default the application
   * specific MIME type will be used:
   *     application/vnd.google-apps.drive-sdk.
   */
  newFileMimeType: "application/json", // Using default.

  /**
   * Function to be called every time a Realtime file is loaded.
   */
  onFileLoaded: onFileLoaded,

  /**
   * Function to be called to initialize custom Collaborative Objects types.
   */
  registerTypes: registerTypes,

  /**
   * Function to be called after authorization and before loading files.
   * This should prompt for the file name for a new project.
   */
  afterAuth: null // No action.
};

/**
 * Start the Realtime loader with the options.
 */
function startRealtime() {
  var realtimeLoader = new rtclient.RealtimeLoader(realtimeOptions);
  realtimeLoader.start();
}
