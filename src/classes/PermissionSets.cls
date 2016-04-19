/**
 * See https://github.com/financialforcedev/fflib-apex-common for more info
 *
 * Install library via 
 *   https://githubsfdeploy.herokuapp.com/app/githubdeploy/financialforcedev/fflib-apex-common
 */

/**
 * Encapsulates all behaviour logic relating to the PermissionSet object
 * 
 * For more guidelines and details see 
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Domain_Layer
 *
 **/
public class PermissionSets extends fflib_SObjectDomain 
{
	private PermissionSetSelector.IPermissionSetSelector permissionSetSelector {
		get;
		set;
	}

	@testVisible
	private PermissionSets(PermissionSetSelector.IPermissionSetSelector permissionSetSelector, List<PermissionSet> records) {
		super(records);
		this.permissionSetSelector = permissionSetSelector;
	}
	
	public List<PermissionSet> getPermissionSetWithPermission(String permissionName) {
		return null;
	}
	
	public PermissionSets(List<PermissionSet> records) 
	{
		this(new PermissionSetSelector(), records);
	}

	public override void onValidate()
	{
		for(PermissionSet record : (List<PermissionSet>) Records)
		{
		}
	}

	public override void onValidate(Map<Id,SObject> existingRecords)
	{
		for(PermissionSet record : (List<PermissionSet>) Records)
		{
		}
	}

	public override void onBeforeInsert()
	{
		for(PermissionSet record : (List<PermissionSet>) Records)
		{
		}
	}

	public void someMethod()
	{
		for(PermissionSet record : (List<PermissionSet>) Records)
		{
		}		
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable2
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new PermissionSets(sObjectList);
		}

		public fflib_SObjectDomain construct(List<SObject> sObjectList, SObjectType sObjectType)
		{
			return new PermissionSets(sObjectList);
		}			
	}	
}