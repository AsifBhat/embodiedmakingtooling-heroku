 // Temporary variables
var posid=0, elemid=0, x=0;

/*gapi.drive.realtime.load(docId, onLoaded, function(model) {
});*/

/** Call back configured to register types */
function registerTypes() {
  Util.log.console("Registering types...");
  try{
    VizDataModel.prototype.positions = gapi.drive.realtime.custom.collaborativeField('positions');
    VizDataModel.prototype.relations = gapi.drive.realtime.custom.collaborativeField('relations');
    VizDataModel.prototype.elements = gapi.drive.realtime.custom.collaborativeField('elements');
    VizDataModel.prototype.meta = gapi.drive.realtime.custom.collaborativeField('meta');
    VizDataModel.prototype.nuggets = gapi.drive.realtime.custom.collaborativeField('nuggets');
    gapi.drive.realtime.custom.registerType(VizDataModel, 'VizDataModel');
    gapi.drive.realtime.custom.setInitializer(VizDataModel, doInitialize);
  }
  catch(ex){
    Util.log.console('Error occured during registering the real time Data types');
    Util.log.console(ex);
  }
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

/*
 Triggered when the value of Nuggets is changed
*/
function doNuggetValueChanged(evt){
  // this is where the nuggets will be added to the UI
  // Most likely the nuggets should have their own space and must be searchable (A separate typeahead should be good here)
  Util.log.console(evt);
  if(!evt.isLocal){
    if(evt.type == gapi.drive.realtime.EventType.VALUES_ADDED){
      Util.log.console(evt.values);
      AppContext.grid.prependNuggetToDisplay(evt.values);
    }
    else if(evt.type == gapi.drive.realtime.EventType.VALUES_REMOVED){
      AppContext.vizdata.removeNugget(evt.values);
    }
  }
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
  this.nuggets = model.createList(); //init the nuggets from the realtime model
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
  Util.log.console('Logging AppContext vizdata ');
  Util.log.console(AppContext.vizdata);

  try{

    if(AppContext.vizdata.positions){
      /**
        Registering Listeners for Positional Information for various cells placed on the Grid.
       */
      AppContext.vizdata.positions.addEventListener(gapi.drive.realtime.EventType.VALUES_ADDED, doPosValueChanged);
      AppContext.vizdata.positions.addEventListener(gapi.drive.realtime.EventType.VALUES_REMOVED, doPosValueChanged);
    }
    else{
      Util.log.console('Listeners to positional information cannot be registered successfully.\n File load failed.');
      alert('File loading failed');
      // throw exception for positons
    }
  
    if(AppContext.vizdata.elements){
      /**
        Registering Listeners for Content Elements
       */
      AppContext.vizdata.elements.addEventListener(gapi.drive.realtime.EventType.VALUES_ADDED, doContentValueChanged);
      AppContext.vizdata.elements.addEventListener(gapi.drive.realtime.EventType.VALUES_REMOVED, doContentValueChanged);
    }
    else{
      Util.log.console('Listeners to the Content-Elements cannot be registered successfully. \n File loading failed');
      alert('file loading failed');
      // throw exception for elements
    }

    if(AppContext.vizdata.relations){
      /**
        Registering Listeners for relations between various Content Elements
       */
      AppContext.vizdata.relations.addEventListener(gapi.drive.realtime.EventType.VALUES_ADDED, doRelValueChanged);
      AppContext.vizdata.relations.addEventListener(gapi.drive.realtime.EventType.VALUES_REMOVED, doRelValueChanged);
    }
    else{
      Util.log.console('Listeners for relational information could not be attached.\n File loading failed');
      // Throw exception if the relational information is critical. Skip loading.
    }
    /**
      Registering Listeners for nuggets data constructs
     */
    if(AppContext.vizdata.nuggets){
      AppContext.vizdata.nuggets.addEventListener(gapi.drive.realtime.EventType.VALUES_ADDED, doNuggetValueChanged);
      AppContext.vizdata.nuggets.addEventListener(gapi.drive.realtime.EventType.VALUES_REMOVED, doNuggetValueChanged);
    }
    else{
      Util.log.console('AppContext.vizdata.nuggets is not defined, hence skipping event registration');
    }

    if(AppContext.vizdata.meta){
      /**
        Registerng Listeners for meta information for the given making
       */
      AppContext.vizdata.meta.addEventListener(gapi.drive.realtime.EventType.VALUES_ADDED, doMetaValueChanged);
      AppContext.vizdata.meta.addEventListener(gapi.drive.realtime.EventType.VALUES_REMOVED, doMetaValueChanged);
    }
    else{
      Util.log.console('Meta Information could not be loaded. Skipping meta info event registration');
    }
  }
  catch(ex){
    console.log('Error occured while registering one of the listeners: ');
    console.log(ex);
  }
  
  AppContext.grid.displayAllPositions(AppContext.vizdata.getPositions());
  
  AppContext.grid.activateListeners();
  AppContext.grid.activateZoomListeners();
  AppContext.grid.activateTypeahead(AppContext.vizdata.getElements());

  AppContext.project.getFileDetails();
  fetchClientDetails(AppContext.project.getUserInfo);
}