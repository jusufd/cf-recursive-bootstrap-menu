component accessors="true"{

	/* Dependency Injection */
	property name="UserSessionService" setter="true" getter="false";
	property name="UserService" setter="true" getter="false";
	property name="CategoryGateway" setter="true" getter="false";

	/** 
		* I am super before	function
		* @rc request context
		* @secureController set if controller can't be access with right authority
	*/
	private void function before(required struct rc,boolean secureController=false,string curSection) {
		var local = {};

		// if no user exists do initial setup
		rc.initialSetup = false;
		if (arraylen(variables.UserService.getOneUser()) == 0) {
			if (rc.action != 'go.main') 
				variables.fw.redirect(action='go.main');
			rc.initialSetup = true;	
		};
		local.curSection = arguments.curSection;
		// Session created if not //
		rc.UserSession = variables.UserSessionService.saveUserSession({"Id" = trim(session.sessionid)});
		// if controller is secured redirect to login //
		if (arguments.secureController) {
			if (!rc.UserSession.hasUser()) {
				local.gotoString = gotoString(rc = arguments.rc);
				variables.fw.redirect(action='go.login',querystring='&?goto=#local.gotoString#');	
			}
		}
		// request context for assets //
		if (structkeyexists(rc,'cdn')) {
			rc.css_path = rc.cdn & rc.config.asset & rc.config.css & "/";
			rc.image_path = rc.cdn & rc.config.asset & rc.config.image & "/";
			rc.js_path = rc.cdn & rc.config.asset & rc.config.js & "/";
			rc.ico_path = rc.cdn & rc.config.asset & rc.config.ico & "/";
			rc.upload_path = rc.cdn & rc.config.asset & rc.config.upload & "/";
		} else {
			if (trim(cgi.path_info) IS '/') {	
				rc.css_path = rc.config.asset & rc.config.css & "/";
				rc.image_path = rc.config.asset & rc.config.image & "/";
				rc.js_path = rc.config.asset & rc.config.js & "/";
				rc.ico_path = rc.config.asset & rc.config.ico & "/";
				rc.upload_path = rc.config.asset & rc.config.upload & "/";
			} else {
				local.context_path = trim(cgi.context_path);
				if (len(local.context_path) == 0) {
					local.context_path = rereplacenocase(cgi.script_name,'/index.cfm','','all');
				}
				rc.css_path = local.context_path & '/' & rc.config.asset & rc.config.css;
				rc.image_path = local.context_path & '/' & rc.config.asset & rc.config.image;
				rc.js_path = local.context_path & '/' & rc.config.asset & rc.config.js;
				rc.ico_path = local.context_path & '/' & rc.config.asset & rc.config.ico;
				rc.upload_path = local.context_path & '/' & rc.config.asset & rc.config.upload;
			}	
		}
		// meta default value
		rc.meta = {
			"description" = "",
			"keyword" = "",
			"og_title" = "",
			"og_description" = "",
			"og_image" = "",
			"og_street_address" = "",
			"og_locality" = "",
			"og_region" = "",
			"og_postal_code" = "",
			"og_phone_number" = "",
			"viewport" = "width=device-width, initial-scale=1.0",
			"http_equiv" = {
				"expires" = "0",
				"pragma" = "no-cache",
				"content_type" = "text/html; charset=utf-8",
				"x_ua_compatible" = "IE=edge,chrome=1"
			}	
		};
		rc.meta_title = "";	
		local.arrCSS = [];
		local.arrJS = [];
		arrayappend(local.arrCSS,{file='bootstrap.min.css'});
		arrayappend(local.arrCSS,{file='bootstrap-responsive.min.css'});
		arrayappend(local.arrCSS,{file='theme.css'});
		if (rc.action=='go.login')
			arrayappend(local.arrCSS,{file='signin.css'});
		rc.cssString = listify(sInput = local.arrCSS,path = rc.css_path,type = 'css');	
		arrayappend(local.arrJS,{file='jquery.js'});
		arrayappend(local.arrJS,{file='bootstrap-transition.js'});
		arrayappend(local.arrJS,{file='bootstrap-alert.js'});	
		arrayappend(local.arrJS,{file='bootstrap-modal.js'});
		arrayappend(local.arrJS,{file='bootstrap-dropdown.js'});
		arrayappend(local.arrJS,{file='bootstrap-scrollspy.js'});
		arrayappend(local.arrJS,{file='bootstrap-tab.js'});
		arrayappend(local.arrJS,{file='bootstrap-tooltip.js'});
		arrayappend(local.arrJS,{file='bootstrap-popover.js'});
		arrayappend(local.arrJS,{file='bootstrap-button.js'});
		arrayappend(local.arrJS,{file='bootstrap-collapse.js'});
		arrayappend(local.arrJS,{file='bootstrap-carousel.js'});
		arrayappend(local.arrJS,{file='bootstrap-typeahead.js'});
		arrayappend(local.arrJS,{file='angular.min.js'});
		arrayappend(local.arrJS,{file='angular-resource.min.js'});
		arrayappend(local.arrJS,{file='categorygen.js'});
		arrayappend(local.arrJS,{file='categorygenController.js'});
		arrayappend(local.arrJS,{file='categorygenService.js'});
		arrayappend(local.arrJS,{file='categorygenFilter.js'});
		arrayappend(local.arrJS,{file='categorygenDirective.js'});
		arrayappend(local.arrJS,{file='resourceSvc.js'});
		rc.jsString = listify(sInput = local.arrJS,path = rc.js_path,type = 'js');
		if (!structkeyexists(rc,'remoteResult'))
			rc.remoteResult = {};
		local.getCurrentSession = variables.UserSessionService.getCurrentSession();	
		rc.getCurrentSessionUser = local.getCurrentSession.getUser();
		rc.navString = '';
		if (listfirst(rc.action,'.')=='go')
			rc.navString = menuFrontEnd('',0,rc.action,rc.UserSession.hasUser());

	}	
	// I am outputing CSS or JS html
	private string function listify(array sInput=[],string path='',string type='css') {
		var local = structnew();
		local.retval = '';
		local.sInput = arguments.sInput;
		local.path = arguments.path;
		local.type = arguments.type;
		if (arraylen(local.sInput)>0 && len(trim(local.path)) > 0) {
			for(i=1;i<=arraylen(local.sInput);i++) {
				if (structkeyexists(local.sInput[i],'file')) 
				{			
					if (local.type=='css') {
						local.retval = local.retval & '<link rel="stylesheet" type="text/css" media="screen" href="#local.path##local.sInput[i].file#" />';
					} else {
						local.retval = local.retval & '<script type="text/javascript" src="#local.path##local.sInput[i].file#"></script>';
					}	
				}	
			}
		}	
		return local.retval;
	}
	/** 
		* I am serializing rc and encode64 to fill the automatic login redirect.	 
	*/
	private string function gotoString(required struct rc) {
		var data2return = {};
		structinsert(data2return,'cgi',cgi);
		structinsert(data2return,'action',arguments.rc.action);
		if (structkeyexists(arguments.rc,'queryparam')) 
			structinsert(data2return,'querystring',arguments.rc.queryparam);
		return urlencodedformat(tobase64(serializejson(data2return)));
	}
	/** 
		* I am setting the base value of error rc	 
	*/
	private struct function initErrField(required array reqField) {
		var result = {"fields"={},"messageBox"=""};
		for (i=1;i<=arraylen(arguments.reqField);i++) {
			structInsert(result.fields,reqField[i],{"css"='',"message"=[]});
		};
		return result;
	}
	private struct function initBlank(required struct rc, required array blankField) {
		var tempRC = arguments.rc;
		for (i=1;i<=arraylen(arguments.blankField);i++) {
			setVariable("tempRC.#arguments.blankField[i]#","");
		};
		return tempRC;
	}

	private string function menuFrontEnd(any parentId,any level=0,string curAction,boolean hasUser = false,string menustring = '') {
		var local = {};
		var EntityCategory = entitynew('Category',{
			"Parents" = arguments.parentId,
			"Section" = 'go',
			"IsActive" = true,
			"InNav" = true
			});
		local.objNav = variables.CategoryGateway.QueryCategory(EntityCategory,"SortOrder");
		if (arraylen(local.objNav) > 0) {
			for(local.i=1;local.i<=arraylen(local.objNav);local.i++) {
				var EntityCategoryKids = entitynew('Category',{
					"Parents" = local.objNav[local.i].getid(),
					"Section" = 'go',
					"IsActive" = true,
					"InNav" = true
					});
				var objKids = variables.CategoryGateway.QueryCategory(EntityCategoryKids,"SortOrder");
				var menutitle = local.objNav[local.i].getname();
				var urlGen = '';
				if (len(trim(local.objNav[local.i].getPath()))>0)
					if (listlen(trim(local.objNav[local.i].getPath()),'.')>=2)
						var urlGen = variables.fw.buildurl(action='#trim(local.objNav[local.i].getPath())#',querystring='#trim(local.objNav[local.i].getPathKey())#');
					else 
						var urlGen = '#trim(local.objNav[local.i].getPath())#' & '/' & '#trim(local.objNav[local.i].getPathKey())#';	
				var classlevel0 = '';
				if (comparenocase(trim(local.objNav[local.i].getPath()),arguments.curAction)==0) {
					classlevel0 = ' active';
				};
				var classlevel1 = '';
				var href = urlGen;	
				var Kids = false;
				if (arraylen(objKids) > 0) {
					Kids = true;
				}
				if (arguments.level==0 && len(arguments.menustring)==0) {
					arguments.menustring = arguments.menustring & '<div class="nav-collapse collapse">';
					arguments.menustring = arguments.menustring & '<ul class="nav">';
				}

				if (arguments.level==0) 
					arguments.menustring = arguments.menustring & '<li class="divider-vertical"></li>';	

				if (arguments.level==0) 
					if (Kids) 
					{
						arguments.menustring = arguments.menustring & '<li class="dropdown dropdown-hover#classlevel0#">';
						arguments.menustring = arguments.menustring & '<a href="#href#" class="dropdown-toggle" data-toggle="dropdown">#trim(menutitle)# <b class="caret"></b></a><ul class="dropdown-menu">'; 
					} 
					else 
					{
						arguments.menustring = arguments.menustring & '<li>';
						arguments.menustring = arguments.menustring & '<a href="#href#">#trim(menutitle)#</a>';
						arguments.menustring = arguments.menustring & '</li>';
					}

				if (arguments.level==1) 
					if (!Kids) 
						arguments.menustring = arguments.menustring & '<li><a href="#href#">#trim(menutitle)#</a></li>';
				
				if (local.i==arraylen(local.objNav)) 
					if (arguments.level == 1) 
						arguments.menustring = arguments.menustring & '</ul></li>';
					else 
						arguments.menustring = arguments.menustring & '</ul></div>';
				arguments.menustring = menuFrontEnd(
							parentId = local.objNav[local.i].getid(), 
							level = arguments.level + 1,
							curAction = arguments.curAction,
							hasUser = arguments.hasUser,
							menustring = arguments.menustring);
			}	
		}
		return arguments.menustring;	
	}			


	// Public Area
	public void function init( required any fw ){
		variables.fw = arguments.fw;
	}
	public void function after( required struct rc ){

	}	
}	