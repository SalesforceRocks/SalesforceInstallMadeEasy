# SalesforceInstallMadeEasy
Installation of a Force.com managed package should be as easy as possible. But not everything is packageable and quite often an admin needs to do a lot of manual work after installing the package. There are a couple of reasons for this:
* Before the installation can be finished, the configuration of the org in which it is installed needs to be changed. This cannot be done securily from within a managed package thus resulting in a lot of installation instructions for the system admin and risk of wrong configuration. 
* Sometimes data needs to be inserted into records during postinstall. Programming that by hand can be cumbersome.

The current version of this project focusses on the first point. To this end the project contains several features:
* A VF page that can be used in the config page of a managed package. It contains the following functionalities:
  * A check on load of the VF page if there is a remote site setting configured to call the metadata api
  * If the check fails the page checks if the current user has the 'Modify all Data' permission and then shows a create remote site setting button (see http://andyinthecloud.com/2014/07/29/post-install-apex-metadata-api-configuration-solved/)
  * If the user does not have that permission the page shows an appropriate error message
  * Functionality to create the remote site setting
  * A VF component (or Lightning tbd) to add / change picklist values. VF component will check if the user has the appropriate permissions. 
* A VF page that can be used as a wrapper to the first VF page. The VF page checks if the required config already has been done. If not, it shows the first VF page. If the config has been done redirects to a configurable page or loads a Lightning App.
