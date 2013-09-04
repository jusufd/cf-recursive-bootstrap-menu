component extends="org.fw1.framework"{
			
	// Application Settings
	this.applicationroot = getDirectoryFromPath(getCurrentTemplatePath());
	this.name = ListLast( this.applicationroot, "\/" ) & "_" & Hash( this.applicationroot );
	this.sessionmanagement = true;
	this.sessionType = "j2ee";
	this.setclientcookies = false;

	// environment Settings
	this.remoteAddr = {
		'development' = 'dev', // make blank for using localhost
		'test' = 'tst',
		'staging' = 'stg'
	};
	this.env = 'production';
	if (len(this.remoteAddr.development)>0) {
		for(i=1;i<=listlen(structkeylist(this.remoteAddr));i++) 
			if ( listfirst(CGI.HTTP_HOST,'.') == evaluate('this.remoteAddr.#listgetat(structkeylist(this.remoteAddr),i)#') )
				this.env = listgetat(structkeylist(this.remoteAddr),i);
	} else {
		if (IsLocalHost(CGI.REMOTE_ADDR))
			this.env = 'development';
	}	
	structinsert(this,this.env,true);
	

	// prevent bots creating lots of sessions
	if (structKeyExists(cookie,"CFTOKEN" )) 
		this.sessiontimeout = createTimeSpan( 16384, 0, 0, 0 );
	else 
		this.sessiontimeout = createTimeSpan( 0, 0, 0, 1 );
	
	// mapping settings
	this.mappings[ "/models" ] = this.applicationroot & "models/";
	this.mappings[ "/ValidateThis" ] = this.applicationroot & "org/ValidateThis/";
	this.mappings[ "/hoth" ] = this.applicationroot & "org/hoth/";

	// orm settings
	this.datasource = rereplacenocase(ListLast(this.applicationroot,"\/"),'-','','all');
	this.ormenabled = true;
	this.ormsettings = {
		flushatrequestend = false, 
		automanagesession = false, 
		cfclocation = this.mappings[ "/models" ], 
		eventhandling = true, 
		eventhandler = "models.aop.GlobalEventHandler", 
		logsql = YesNoFormat(structkeyexists(this,'development')),
		dialect = "mysql"
	};	
	this.ormsettings.dbcreate = "update";
	if (structkeyexists(this,'development') && structkeyexists(url,'rebuild'))
			this.ormsettings.dbcreate = "dropcreate";
	
	// fw/1 settings
	variables.framework = {
		home = 'go.main',
		defaultSection = 'go',
		defaultItem = 'main',
		baseURL = 'useCgiScriptName',
		reload = 'restart', 
		password = '',
		generateSES = 'true',
		SESOmitIndex = 'true',
		error = 'go.error',
		usingSubsystems = false,
		maxNumContextsPreserved = 1,
		reloadApplicationOnEveryRequest = YesNoFormat(structkeyexists(this,'development'))
	};

	void function setupsession() {
		// for ACF turn on this
		// cookie.CFID = {value="#session.cfid#",httponly="true"};
		// cookie.CFTOKEN = {value="#session.cftoken#",httponly="true"};
	}

	void function setupApplication(){
		// add exception tracker to application scope
		var HothConfig = new hoth.config.HothConfig();
		HothConfig.setApplicationName( getConfiguration().name );
		HothConfig.setLogPath( this.applicationroot & "logs/hoth" );
		HothConfig.setLogPathIsRelative(false);
		HothConfig.setEmailNewExceptions(getConfiguration().exceptionTracker.emailNewExceptions);
		HothConfig.setEmailNewExceptionsTo(getConfiguration().exceptionTracker.emailNewExceptionsTo);
		HothConfig.setEmailNewExceptionsFrom(getConfiguration().exceptionTracker.emailNewExceptionsFrom);
		HothConfig.setEmailExceptionsAsHTML(getConfiguration().exceptionTracker.emailExceptionsAsHTML);
		application.exceptionTracker = new Hoth.HothTracker( HothConfig );

		// setup bean factory
		var beanfactory = new org.di1.ioc(
			"/models", 
			{singletonPattern = "(Service|Gateway)$"}
		);
		setBeanFactory(beanfactory);

		// add validator bean to factory
		var validatorConfig = {
			definitionPath="/models/",
			JSIncludes=false,
			resultPath="models.utility.ValidatorResult"
		};
		beanFactory.addBean("Validator",new ValidateThis.ValidateThis(validatorConfig) );

		// add config bean to factory
		beanFactory.addBean("config",getConfiguration());
	}

	void function setupRequest(){
		// store config in request context
		rc.config = getBeanFactory().getBean("config");

		if (structkeyexists(this,'development') && (structkeyexists(url,'rebuild') || structkeyexists(url,'reload')))
			ORMReload();

		if (structkeyexists(this,'development')) 
			writedump(var="*** Request Start - #TimeFormat( Now(), 'full' )# ***", output="console" );

		// define base url
		if( CGI.HTTPS eq "on" ) 
			rc.basehref = "https://";
		else 
			rc.basehref = "http://";

		rc.basehref &= CGI.HTTP_HOST & variables.framework.base;
		
	}

	// configuration	
	private struct function getConfiguration(){
		var config = {
			"#this.env#" = true,
			"version" = "0.1",
			"name" = "Menu Generator",
			"imageAllowedExtensions" = 'gif,jpg,png,jpeg',
			"asset" = "assets/",
			"css" = "css/",
			"js" = "js/",
			"ico" = "ico/",
			"fonts" = "fonts/",
			"image" = "image/",
			"upload" = "upload/",
			"facebook" = {
				"key" = "",
				"secret" = "",
				"graphURL" = ""
			},
			"googleanalyticstrackingid" = "", 
			"s3" = {
				"key" = "",
				"secret" = "",
				"bucket" = ""
			},
			"recaptcha" = {
				"public" = "",
				"private" = ""
			},
			"exceptionTracker" = { 
				"emailNewExceptions" = true, 
				"emailNewExceptionsTo" = "",
				"emailNewExceptionsFrom" = "",
				"emailExceptionsAsHTML" = true
			}
		};

		if (len(config.s3.key) && len(config.s3.secret) && len(config.s3.bucket)) {
			structinsert(config.s3,"access","s3://#trim(config.s3.key)#:#trim(config.s3.secret)#/#config.s3.bucket#/");
			structinsert(config,"cdn","https://#rc.config.s3.bucket#.s3.amazonaws.com/");
		}
		if (structkeyexists(this,'development')) {
			config.exceptionTracker.emailNewExceptions = false;
		}
		if (structkeyexists(this,'test')) {

		}
		if (structkeyexists(this,'staging')) {

		}
		if (structkeyexists(this,'production')) {

		}

		return config;
	}


}	