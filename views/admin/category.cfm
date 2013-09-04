<cfif structkeyexists(rc,'json')>
	<cfcontent type="application/json" >
	<cfoutput>#serializejson(rc.remoteResult)#</cfoutput>
	<cfset request.layout = false>
<cfelse>
<cfoutput>
	<div ng-controller="ProductCategoryListController" ng-init="init('#rc.initVar#','#rc.selection#')">
		<div class="category-section">
			<div class="row-fluid">
				<!--  Buttons -->
				<div class="span12">
					<a href="##" ng-click="addCategory(categories.data.parent.Id2);" class="btn btn-primary btn-phone-block" data-toggle="modal" >
						<icon class="icon-plus-sign icon-white"></icon> <cfif rc.initVar IS 'product'>Add Product Category<cfelse>Add Menu Option</cfif>
					</a>
				</div>
				<div class="clearfix"></div>
				<div class="separator"></div>
				<!-- End Buttons -->
			</div>
			<div class="row-fluid">
				<!-- Categories Table -->
				<div class="span12">
					<table class="table table-striped table-bordered table-responsive block">
						<thead>
							<tr>
								<th class="center" width="20">No.</th>
								<th>Category name</th>
								<th class="center" width="40">Visible</th>
								<th class="center" width="80">Position</th>
								<th class="center" width="180">Actions</th>
							</tr>
						</thead>
						<tbody>
							<tr ng-hide="categories.data.main.length">
								<td colspan="5" >No Category</td>
							</tr>
							<tr ng-repeat="category in categories.data.main">
								<td class="center">{{$index + 1}}.</td>
								<td ng-show="category.Level < 2">
									<a ng-click="openCategory(category.Id)" href="##">{{category.Name}}</a>
								</td>
								<td ng-show="category.Level >= 2">
									{{category.Name}}
								</td>
								<td class="center"><icon ng-class="{'icon-ok icon-brown': category.IsActive,'icon-remove icon-brown': !category.IsActive}"></icon></td>
								<td class="center">
									<a ng-click="arrowUp(category.prevId,category.Id);" ng-show="category.Editable">
										<icon ng-class="{'icon-arrow-up icon-cream-w': category.Index==1,'icon-arrow-up icon-cream-brown': category.Index>1}"></icon>
									</a>
									<small ng-show="category.Editable">or</small> 
									<a ng-click="arrowDown(category.nextId,category.Id);" ng-show="category.Editable">
										<icon ng-class="{'icon-arrow-down icon-cream-w': category.Index==category.Size,'icon-arrow-down icon-cream-brown': category.Index<category.Size}"></icon>
									</a>
								</td>
								<td class="center">
									<button ng-show="category.Editable" class="btn btn-success btn-phone-block" ng-click="editCategory(category.Id);"><icon class="icon-pencil icon-white"></icon><span class="hidden-phone">Edit</span></button>
									<button ng-show="category.Deleteable" class="btn btn-danger btn-phone-block" ng-click="deleteCategory(category.Id);"><icon class="icon-remove icon-white"></icon><span class="hidden-phone">Delete</span></button>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- End Categories Table -->
			</div>
		</div>
		<!--  Modal Category -->
		<div class="hide modal" id="modalCategory" data-backdrop="static">
			<div class="modal-header">
				<p>
					{{titleCategoryWindow}} <button type="button" class="close " data-dismiss="modal" aria-hidden="true" ng-click="modalCategoryClose(categories.data.parent.Id2);">&times;</button>
				</p>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" name="categoryForm" >
					<div class="control-group" ng-show="category.data.validation.status==3">
						<div class="notification success">{{category.data.validation.success.message}}</div>
					</div>
					<div class="control-group" ng-show="category.data.validation.status==1">
						<div class="notification failure">{{category.data.validation.failure.message}}</div>
					</div>
					<div class="control-group">
						<label class="control-label">Category name:</label>
						<div class="controls">
							<input type="text" class="input-xx" placeholder="Category name" ng-model="category.data.Name" />
							<p class="error-message" ng-show="category.data.validation.error.fields.Name.length">{{category.data.validation.error.fields.Name[0]}}</p>
						</div>
					</div>
					<div class="control-group" ng-show="category.data.parentOptions.length">
						<label class="control-label">Subcategory of:</label>
						<div class="controls">
							 <select ng-model="category.data.Parents.Id" ng-options="o.Id as o.Name for o in category.data.parentOptions"></select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Path:</label>
						<div class="controls">
							<input type="text" class="input-xx" placeholder="Path" ng-model="category.data.Path" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Path Key:</label>
						<div class="controls">
							<input type="text" class="input-xx" placeholder="Path Key" ng-model="category.data.PathKey" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Meta Title:</label>
						<div class="controls">
							<input type="text" class="input-xx" placeholder="Meta Title" ng-model="category.data.MetaTitle" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Meta Description:</label>
						<div class="controls">
							<input type="text" class="input-xx" placeholder="Meta Description" ng-model="category.data.MetaDescription" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Meta Keyword:</label>
						<div class="controls">
							<input type="text" class="input-xx" placeholder="Meta Keyword" ng-model="category.data.MetaKeyword" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Description:</label>
						<div class="controls">
							<textarea name="description" rows="6" class="input-xx-textarea" placeholder="Description ..." ng-model="category.data.Description"></textarea>
						</div>
					</div>
					<div class="control-group">
						<label class="checkbox inline offset1">
						  <input type="checkbox" ng-model="category.data.IsActive" ng-true-value="Yes" ng-false-value="No" > Visible
						</label>
						<label class="checkbox inline">
						  <input type="checkbox" ng-model="category.data.InNav" ng-true-value="Yes" ng-false-value="No" > Show In Nav
						</label>
						<label class="checkbox inline">
						  <input type="checkbox" ng-model="category.data.InNavSecure" ng-true-value="Yes" ng-false-value="No" > In Secured Page
						</label>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<a href="" ng-click="saveCategory(categories.data.parent.Id2,category.data.Id);" class="btn btn-primary">Save & Continue <icon class="icon-share-alt icon-white"></icon></a>
			</div>
		</div>
		<!--  End Modal Category -->
</cfoutput>	
</cfif>