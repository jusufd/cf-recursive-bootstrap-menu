component extends="ValidateThis.util.Result"{

	/**
	 * I initialise this component
	 */				
	function init( required any Translator, required struct ValidateThisConfig ){
		variables.messagetype = "";
		variables.message = "";
		return super.init( argumentCollection=arguments );
	}

	/**
	 * I return a message
	 */		
	string function getMessage(){
		if( Len( super.getSuccessMessage() ) != 0 ) return getSuccessMessage();
		return variables.message;
	}

	/**
	 * I return a message type
	 */		
	string function getMessageType(){
		return variables.messagetype;
		
	}

	/**
	 * I return true if a message exists
	 */		
	boolean function hasMessage(){
		return Len( Trim( getMessage() ) ) != 0;
	}

	/**
	 * I set an error message
	 */		
	void function setErrorMessage( required string message ){
		super.setIsSuccess( false );
		variables.message = arguments.message;
		variables.messagetype = "error";
	}

	/**
	 * I set an information message
	 */		
	void function setInfoMessage( required string message ){
		variables.message = arguments.message;
		variables.messagetype = "info";
	}	

	/**
	 * I set a success message
	 */	
	void function setSuccessMessage( required string message ){
		super.setIsSuccess( true );
		super.setSuccessMessage( arguments.message );
		variables.messagetype = "success";
	}

	/**
	 * I set a warning message
	 */	
	void function setWarningMessage( required string message ){
		variables.message = arguments.message;
		variables.messagetype = "warning";
	}

	/**
	 * I set a warning message
	 */	
	struct function getValidationMessage(required array reqField,string cssStyle='style="border:1px solid ##9a0000;"') {
		var result = {"fields"={},"messageBox"="","remote"={"status"=""}};
		for (i=1;i<=arraylen(arguments.reqField);i++) {
			structInsert(result.fields,reqField[i],{"css"='',"message"=[]});
		};
		var messageBoxSet = '';
		var messabeBoxContent = '';
		if (variables.messagetype=='error') {
			result.remote.status = 1;
			structinsert(result.remote,'error',{"fields"={},"message"=[]});
			structinsert(result.remote,'failure',{"message" = '#variables.message#'});
			messageBoxSet = 'failure';
			var errStruct = getErrors();
			if (!structisempty(errStruct)) {
				var errStructKeyList = structkeylist(errStruct,',');
				var errStructKeyLen = listlen(errStructKeyList);
				for(i=1;i<=errStructKeyLen;i++) {
			 		var errKey = listgetat(errStructKeyList,i,',');
			 		var errMsgArray = evaluate('errStruct.#errKey#');
			 		setVariable("result.fields.#errKey#.css",arguments.cssStyle);
			 		if (arraylen(errMsgArray)>0) {
			 			setVariable("result.fields.#errKey#.message",errMsgArray);
			 			structinsert(result.remote.error.fields,errKey,errMsgArray);
			 			for(j=1;j<=arraylen(errMsgArray);j++) {
			 				messabeBoxContent = messabeBoxContent & '<p>#trim(errMsgArray[j])#</p>';
			 				arrayappend(result.remote.error.message,trim(errMsgArray[j]));
			 			}	
			 		}	
			 	}	
			} else {
				messabeBoxContent = messabeBoxContent & '<p>#trim(variables.message)#</p>';
				result.remote.error.message = trim(variables.message);
			} 	
		} else if (variables.messagetype=='info') {
			result.remote.status = 2;
			messageBoxSet = 'information';
			messabeBoxContent = '<p>' & variables.message & '</p>';
			structinsert(result.remote,'information',{"message" = '#variables.message#'});
		} else if (variables.messagetype=='success') {
			result.remote.status = 3;
			messageBoxSet = 'success';
			messabeBoxContent = '<p>' & super.getSuccessMessage() & '</p>';
			structinsert(result.remote,'success',{"message" = '#super.getSuccessMessage()#'});
		} else if (variables.messagetype=='warning') {
			result.remote.status = 4;
			messageBoxSet = 'warning';
			messabeBoxContent = '<p>' & variables.message & '</p>';
			structinsert(result.remote,'warning',{"message" = '#variables.message#'});
		}
		if (len(trim(messageBoxSet))) {
			result.messageBox = '<div id="error_wrapper" class="#messageBoxSet#-message"><div class="container_16"><div class="grid_16 notification #messageBoxSet# noborder">';
			result.messageBox = result.messageBox & messabeBoxContent;
			result.messageBox = result.messageBox & '</div></div></div>';
		}	
		return result;
	}

}