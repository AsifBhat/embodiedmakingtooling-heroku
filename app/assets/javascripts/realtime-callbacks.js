 // Temporary variables
var posid=0, elemid=0, x=0;

/*gapi.drive.realtime.load(docId, onLoaded, function(model) {
});*/

/** Call back configured to register types */
function registerTypes() {
  Util.log.console("Registering types...");
  VizDataModel.prototype.positions = gapi.drive.realtime.custom.collaborativeField('positions');
  VizDataModel.prototype.relations = gapi.drive.realtime.custom.collaborativeField('relations');
  VizDataModel.prototype.elements = gapi.drive.realtime.custom.collaborativeField('elements');
  VizDataModel.prototype.meta = gapi.drive.realtime.custom.collaborativeField('meta');
  gapi.drive.realtime.custom.registerType(VizDataModel, 'VizDataModel');
  gapi.drive.realtime.custom.setInitializer(VizDataModel, doInitialize);
  //gapi.drive.realtime.custom.setOnLoaded(VizDataModel, onLoaded);
}

/*function onLoaded (){
}*/

/**
Callback in the event of the collaborative data being changed  
Best Practice - Update UIs from change listeners
Collaborative data models may change without warning as a result of 
edits from other collaborators. A well-written collaborative app must 
attach listeners to its data model to update the UI when collaborative 
edits are received. Whenever possible, all UI updates (even UI updates 
caused by changes from the current, local user) should be done from data 
model change event listeners, because then there is a single code path for 
UI updates.

There are some circumstances where it is necessary to detect the difference 
between a locally-initiated data model change and a remotely-initiated data
model change. In those cases UI updates should still be done from change 
listeners, but listener code should check the isLocal property of change 
events so that local changes can be ignored. See Handle Events for more 
detailed information on event handling.
*/
function doPosValuesAdded (event){
  $.map(event.values, AppContext.grid.posValueAddedCallback);
}

function doPosValueRemoved (event) {
  $.map(event.values, AppContext.grid.posValueRemovedCallback);
}

function doPosValueChanged (){
  var model = gapi.drive.realtime.custom.getModel(this);
  Util.log.console("Model value changed...");
  AppContext.grid.displayAllPositions(AppContext.vizdata.getPositions());
  
}

function doContentValueChanged(event){
  AppContext.grid.reloadTypeahead(AppContext.vizdata.getElements());
  if(event.type == gapi.drive.realtime.EventType.VALUES_ADDED)
    AppContext.graph.addElement(event.values);
  else if (event.type == gapi.drive.realtime.EventType.VALUES_REMOVED)
    AppContext.graph.removeElement(event.values);

}

function doRelValueChanged (event){
  var model = gapi.drive.realtime.custom.getModel(this);
  Util.log.console("Relations value changed...");
  if(event.type == gapi.drive.realtime.EventType.VALUES_ADDED)
    AppContext.graph.addRelation(event.values);
  else if (event.type == gapi.drive.realtime.EventType.VALUES_REMOVED)
    AppContext.graph.removeRelation(event.values);
}

function doMetaValueChanged (evt){
  AppContext.project.projectTitle = AppContext.vizdata.getTitle();
  Util.log.console('Project Title');
  Util.log.console(AppContext.project.projectTitle);
  AppContext.project.updateTitleText();
}
/**
 * The initializer is called exactly once in the lifetime of an object, 
 * immediately after the object is first created. When that object is reloaded
 * in the future, the initializer is not executed; instead, the object is
 * populated by loading saved data from the server. Initializer methods may 
 * take parameters, so the initial object state can be set up at creation time.   
 */
 function doInitialize() {
  var model = gapi.drive.realtime.custom.getModel(this);
  this.positions = model.createList();
  this.elements = model.createList();
  this.relations = model.createList();
  this.meta = model.createList();
  Util.log.console("Initialize object the first time it is created");
  AppContext.project.getFileDetails();
  model.beginCompoundOperation();
  this.updateTitle(AppContext.project.projectTitle);
  model.endCompoundOperation();
 }

/**
 * This function is called the first time that the Realtime model is created
 * for a file. This function should be used to initialize any values of the
 * model. 
 * 'at'param model {gapi.drive.realtime.Model} the Realtime root model object.
 */
function initializeModel(model) {
  /* Once the document has been loaded, we can create instances of the custom object 
  by calling create on the model with either the class or the string name used to 
  register the type. */
  AppContext.vizdata = model.create('VizDataModel');
  Util.log.console("Initial model state for new project has been created");
  /*After creating the VizDataModel object, we can now assign it to an object in the 
  hierarchy (in this case, the root) as follows */
  model.getRoot().set('vizdata', AppContext.vizdata);
}

/**
 * This function is called when the Realtime file has been loaded. It should
 * be used to initialize any user interface components and event handlers
 * depending on the Realtime model. In this case, create a text control binder
 * and bind it to our string model that we created in initializeModel.
 * 'at'param doc {gapi.drive.realtime.Document} the Realtime document.
 */
function onFileLoaded(doc) {
  Util.log.console("Doc:");
  Util.log.console(doc);
  Util.log.console("On file loaded...");
  AppContext.vizdata = doc.getModel().getRoot().get('vizdata');

  AppContext.vizdata.positions.addEventListener(gapi.drive.realtime.EventType.VALUES_ADDED, doPosValuesAdded);
  AppContext.vizdata.positions.addEventListener(gapi.drive.realtime.EventType.VALUES_REMOVED, doPosValueRemoved);

  AppContext.vizdata.elements.addEventListener(gapi.drive.realtime.EventType.VALUES_ADDED, doContentValueChanged);
  AppContext.vizdata.elements.addEventListener(gapi.drive.realtime.EventType.VALUES_REMOVED, doContentValueChanged);
  
  AppContext.vizdata.relations.addEventListener(gapi.drive.realtime.EventType.VALUES_ADDED, doRelValueChanged);
  AppContext.vizdata.relations.addEventListener(gapi.drive.realtime.EventType.VALUES_REMOVED, doRelValueChanged);
  
  AppContext.vizdata.meta.addEventListener(gapi.drive.realtime.EventType.VALUES_ADDED, doMetaValueChanged);
  AppContext.vizdata.meta.addEventListener(gapi.drive.realtime.EventType.VALUES_REMOVED, doMetaValueChanged);

  AppContext.grid.displayAllPositions(AppContext.vizdata.getPositions());
  
  AppContext.grid.activateListeners();
  AppContext.grid.activateZoomListeners();
  AppContext.grid.activateTypeahead(AppContext.vizdata.getElements());

  AppContext.project.getFileDetails();
  fetchClientDetails(getUserName);
}