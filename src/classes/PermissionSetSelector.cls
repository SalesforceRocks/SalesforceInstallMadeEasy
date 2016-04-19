/**
 * @author Jaap Branderhorst
 * @date 2016
 * @group selector
 * @description Class encapsulates query logic for PermissionSet
 *
 * https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Selector_Layerq
 **/
public class PermissionSetSelector extends fflib_SObjectSelector implements IPermissionSetSelector
{
	public interface IPermissionSetSelector extends fflib_ISObjectSelector {
		List<PermissionSet> selectById(Set<ID> idSet);
		List<PermissionSet> selectByPermissionNames(Set<String> permissionNames);
	}

	public PermissionSetSelector() {
	}

	/**
	* @return a list of fields that will be returned through the dynamic SOQL. Does NOT include the permissionSetSOMEPERMISSION list
	*/
	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField> {
				PermissionSet.Id,
				PermissionSet.Description,
				PermissionSet.IsOwnedByProfile,
				PermissionSet.Label,
				PermissionSet.Name,
				PermissionSet.NamespacePrefix,
				PermissionSet.ProfileId,
				PermissionSet.UserLicenseId
			};
	}

	public Schema.SObjectType getSObjectType()
	{
		return PermissionSet.sObjectType;
	}

	/**
	* @return returns a list of PermissionSets with the fields mentioned in the getSObjectFieldList method
	*/
	public List<PermissionSet> selectById(Set<ID> idSet)
	{
		return (List<PermissionSet>) selectSObjectsById(idSet);
	}

	/** 
	* @param permissionNames the names of the permissions that need to be true. Names can include Permissions but also be like ModifyAll.
	* @return returns a list of permissionsets that contain permissions with the names provided.
	* @description queries for all the permissionSets that contain permissions with the given names.  
	*/
	public List<PermissionSet> selectByPermissionNames(Set<String> permissionNames)
	{
		Set<String> sanitizedNames = new Set<String>();
		// format the permission names so we can query on them
		for (String name: permissionNames) {
			sanitizedNames.add(getSanitizedName(name));
		}
		return (List<PermissionSet>) Database.query(
				String.format(
				'select {0}, ' +
				  'from {1} ' +
				  'where  {2} ' + 
				  'order by {3}',
				new List<String> {
					getFieldListString(),
					getSObjectName(),
					getByPermissionNameWhereClause(sanitizedNames),
					getOrderBy() } ) );
	}	

	/**
	* @param permissionSets the permission sets to be queried/searched
	* @param permissionName the permission name to be searched for
	* @return a set of PermissionSet ids that contain thye given permissionName
	* @description searches through a given set of permissionSets. Returns the id of the permissions set if the set contains the permission name
	*/
	public Set<Id> selectByPermissionNameNoDb(List<PermissionSet> permissionSets, String permissionName) {
		// sanitize the name
		permissionName = getSanitizedName(permissionName);
		Set<Id> permissionSetsContainingPermission = new Set<Id>();
		for (PermissionSet permissionSet: permissionSets) {
			if ((Boolean)permissionSet.get(permissionName)) {
				permissionSetsContainingPermission.add(permissionSet.id);
			}
		}
		return permissionSetsContainingPermission;
	}

	private String getSanitizedName(String permissionName) {
		if (permissionName.startsWith('Permissions')) {
			return permissionName;
		} else {
			return 'Permissions' + permissionName;
		}
	}

	private static String getByPermissionNameWhereClause(Set<String> sanitizedNames) {
		String whereClause = '';
		List<String> sanitizedNamesList = new List<String>(sanitizedNames);
		for(Integer i = 0; i < (sanitizedNamesList.size())-1;i++) {
			whereClause = sanitizedNamesList.get(i) + '=TRUE OR ';
		}
		whereClause += (sanitizedNamesList.get(sanitizedNamesList.size()) + '=TRUE');
		return whereClause;
	}

}