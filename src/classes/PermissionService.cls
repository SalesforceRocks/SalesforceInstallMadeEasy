/**
 * @author Jaap Branderhorst
 * @date 2016
 * @group service layer
 * @description Encapsulates all service layer logic for permission handling
 * 
 * For more guidelines and details see 
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Service_Layer
 *
 **/
public class PermissionService
{
	public interface IPermissionService {
		
	}
	public final static String MODIFY_ALL_DATA = 'PermissionsModifyAllData';
	/**
	* @description wrapper to ask if a certain user (userid) has access to certain permissions (permissionsGranted)
	* The wrapper does not execute the query itself. This is done by the service layer and its helper methods.
	* Permissions only cover permissions directly part of a PermissionSet. Object permissions, Field permissions and Setup Entity permissions are not covered
	*/
	public class PermissionAccessRequest {
		/**
		* @description Map containing permission names (keys) and booleans (values) indicating if the user has access to a certain permission yes or no
		*/
		public Map<String, Boolean> permissionsGranted {
			get {
				if (permissionsGranted == null) {
					permissionsGranted = new Map<String, Boolean>();
				}
				return permissionsGranted;
			}
			set;
		}

		/**
		* @description The id of the user for which we need to check if he has access to certain permissions
		*/
		public Id userId {
			get;
			set;
		}

		/**
		* @param permission the name of the permission
		* @return Boolean which is true if the user has access. In all other cases false.
		* @description returns if the user has access to a given permission. Doesn't execute the actual query!
		*/
		public Boolean hasPermission(String permission) {
			return permissionsGranted.get(permission);
		}

		/**
		* @return the names of the permissions requested as a set
		* @description returns a set of permissions requested
		*/
		public Set<String> getPermissionsRequested() {
			return permissionsGranted.keySet();
		}

		/**
		* @param userId the user id of the user for whom we are going to check if he has access
		* @param permissionName the permission name to check. Use the constants.
		* @description constructor
		*/
		public PermissionAccessRequest(Id userId, String permissionName) {
			this.userId = userId;
			permissionsGranted.put(permissionName, false);
		}
	}

	/**
	* @param userIds the list of userIds for which we want to know if they have access to the ModifyAllData permission
	* @return a list of PermissionAccessRequest objects. One per given userId.
	* @description checks if the given list of users have the ModifyAllData permission. 
	*/
	public static List<PermissionAccessRequest> hasModifyAllDataPermission(Set<Id> userIds) {
		return hasSinglePermissionGranted(userIds, 'ModifyAllData');
	}

	/**
	* @param userIds the list of userIds for which we want to know if they have access to the given permission
	* @param permission the permission name to check
	* @return a list of PermissionAccessRequest objects. One per given userId.
	* @description checks if the given list of users have the given permission. 
	*/
	public static List<PermissionAccessRequest> hasSinglePermissionGranted(Set<Id> userIds, String permission) {
		List<PermissionAccessRequest> permissionAccessRequests = new List<PermissionAccessRequest>();
		for (Id userId: userIds) {
			permissionAccessRequests.add(new PermissionAccessRequest(userId, permission)); 
		}
		return hasPermissionsGranted(permissionAccessRequests);
	}

	/**
	* @param permissionAccessRequests a list of permission access request objects. For each object, the service checks if the user has access to the contained permissions
	* @return a list of PermissionAccessRequest objects. One per given userId.
	* @description checks if the given list of users have been granted the requested permissions. 
	*/
	public static List<PermissionAccessRequest> hasPermissionsGranted(List<PermissionAccessRequest> permissionAccessRequests) {
		if (permissionAccessRequests.size() == 0) {
			throw new PermissionSetServiceException(Label.permissionset_error_no_permissionname_supplied);
		}
		// get all permissions requested in a set
		Set<String> permissionsRequested = new Set<String>();
		for (PermissionAccessRequest request: permissionAccessRequests) {
			permissionsRequested.addAll(request.getPermissionsRequested());
		}
		// now get all permission sets that include those permissions
		// List<PermissionSet> permissionSetsIncludingPermissions = new PermissionSetSelector().selectByPermissionName(permissionsRequested);
		// now create a Map with the permission name as key and a set of PermissionSet ids that contain the permissionset


		return null;

	}

	public class PermissionSetServiceException extends Exception
	{
		// Add members and methods here to communicate data
		// relating to exceptions
	}
	
}