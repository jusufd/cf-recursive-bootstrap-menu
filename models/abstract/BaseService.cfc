component accessors="true"{

	property name="Validator" getter="false";
	/**
	 * I return an entity validator
	*/		
	function getValidator( required Entity ){
		return variables.Validator.getValidator( theObject=arguments.Entity );
	}
	/**
     * I populate an entity
	 */	
	void function populate( required Entity, required struct memento, string exclude=""){
		var local = {};
		local.metaResult = getMetaData(arguments.Entity);
		if (structkeyexists(local.metaResult,'properties')) {
			local.arrMetaResult = local.metaResult.properties;
			for(i=1;i<=arraylen(local.arrMetaResult);i++) {
				local.ormtype = '';
				if (structkeyexists(local.arrMetaResult[i],'ormtype'))
					local.ormtype = local.arrMetaResult[i].ormtype;
				local.varname = local.arrMetaResult[i].name;
				if (!listfindnocase(arguments.exclude,local.varname)) 
					if (structkeyexists(arguments.memento,'#local.varname#')) {
						var value = arguments.memento[local.varname];
						if (local.ormtype=='true_false') {
							if (value=='Yes') 
								value = true;
							else 
								value = false;	
						}	
						evaluate( "arguments.Entity.set#local.varname#(value)" );
					}	
			}
		}	
	}
	/**
     * I am convert database properties to structure
	 */
	public struct function properties2struct(required Entity) {
		var local = {};
		local.result = {};
		local.metaResult = getMetaData(arguments.Entity);
		if (structkeyexists(local.metaResult,'properties')) {
			local.arrMetaResult = local.metaResult.properties;
			for(i=1;i<=arraylen(local.arrMetaResult);i++) {
				local.varname = local.arrMetaResult[i].name;
				local.varValue = evaluate("arguments.Entity.get#local.varname#()");	
				if (isnull(local.varValue))
					local.varValue = '';
				if (structkeyexists(local.arrMetaResult[i],'ormtype')) 
					if (local.arrMetaResult[i].ormtype=='true_false') 
						if (evaluate("arguments.Entity.get#local.varname#()")==true) 
							local.varValue = "Yes";
						else  
							local.varValue = "No";
				structinsert(local.result,local.varname,local.varValue);
			}
		}	
		return local.result;
	}
	
	
}