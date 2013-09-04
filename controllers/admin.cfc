component accessors="true" extends="models.abstract.base" {

	// DI
	property name="config" setter="true" getter="false";
	property name="CategoryService" setter="true" getter="false";

	public void function before(required struct rc) {
		super.before(rc,true,'admin');
	}

	public void function main(required struct rc ){
	}	

	public void function category(required struct rc ){
		param name="rc.pid" default="";
		param name="rc.parentId" default="0";
		rc.initVar = 'menu';	
		rc.selection = '';
		if (structkeyexists(rc,'product'))
			rc.initVar = 'product';
		if (isnull(rc.parentId) || !isnumeric(rc.parentId))
			rc.parentId = 0;	
		if (!structkeyexists(rc,'one'))
			rc.remoteResult = variables.CategoryService.getManageMenuProductCategory(initVar=rc.initVar,parentId=rc.pid);
		else 
			rc.remoteResult = variables.CategoryService.getMenuProductCategory(id=rc.pid,parentId=rc.parentId,initVar=rc.initVar);
	}

	public void function saveCategory(required struct rc ){
		var local = {};
		var CategoryService = variables.fw.getBeanFactory().getBean('CategoryService');
		/* begin service call init */
		local.reqField=['Name'];
		if (structkeyexists(rc,'Id'))
			if (len(trim(rc.Id)))
				local.context = 'update';
			else 
				local.context = 'create';
		/* service call */
		local.selection = ''; /* selection = section eg. customer side of menu or other side of menu */
		rc.category_save = CategoryService.saveCategory(rc,local.context,local.selection);
		rc.e = rc.category_save.getValidationMessage(reqField=local.reqField);
		/* ajax result init */
		structinsert(rc.remoteResult,'data',rc.category_save.resultForm);
		structinsert(rc.remoteResult.data,'validation',rc.e.remote);
	}

	public void function UpDownCategory(required struct rc ){
		param name="rc.Id" default="0";
		param name="rc.newId" default="0";
		param name="rc.initvar" default="product";
		if (rc.Id!=0 && rc.newId!=0)
			rc.remoteResult =  variables.CategoryService.swap(rc.Id,rc.initvar,rc.newId);
	}

	public void function deleteCategory(required struct rc ){
		param name="rc.remoteResult" default={};
		param name="rc.initvar" default="product";
		if (structkeyexists(rc,'id')) 
			rc.remoteResult = variables.CategoryService.deleteCategory(rc.id,rc.initvar);	
	}	
}	