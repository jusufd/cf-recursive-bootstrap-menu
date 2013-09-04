component output="false" {

	// ------------------------ CONSTRUCTOR ------------------------ //
	any function init(){
		variables.dbengine = getDBEngine();
		return this;		
	}
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
     * I delete an entity
	 */
	public void function delete( required entity ){
		EntityDelete( arguments.entity );
	}

	/**
     * I return an entity matching an id
	 */
	public any function get( required string entityname, required any id ){
		var Entity = EntityLoadByPK(arguments.entityname, arguments.id);
		if (IsNull(Entity)) 
			Entity = new( arguments.entityname );
		return Entity;
	}

	/**
     * I return an entity matching a filter
	 */
	public any function getSingle( required string entityname, required struct filter ){
		var Entity = entityload(arguments.entityname,arguments.filter,true);
		if (IsNull(Entity)) 
			Entity = new( arguments.entityname );
		return Entity;
	}

	/**
     * I return an entity matching a filter
	 */
	public array function getAll( required string entityname, required struct filter = {},string sortorder = '' ){
		var Entity = entityload(arguments.entityname,arguments.filter,arguments.sortorder);
		return Entity;
	}

	/**
     * I return a new entity
	 */
	public any function new( required string entityname ){
		return EntityNew( arguments.entityname );
	}

	/**
     * I save an entity
	 */
	public any function save( required entity ){
		EntitySave( arguments.entity );
		return arguments.entity;
	}

	private string function getDBEngine() {
		return "";
	}
}