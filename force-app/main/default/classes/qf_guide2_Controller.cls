/**
* Class Name : qf_guide2_Controller
* @description : Used in User Configuration tab
*/
public with sharing class qf_guide2_Controller {
    
    /** Method Name : getSites
     * @description : getSites data
     * @return List of Site Object
     */
    @AuraEnabled
    public static List<Site> getSites() {
        try {
            return [SELECT Id, Name, MasterLabel, Subdomain, SiteType, Status, GuestUserId FROM Site WHERE Status = 'Active' AND SiteType = 'Visualforce' WITH SECURITY_ENFORCED];
        } catch (Exception e) {
            return null;
        }
    }

    /** Method Name : getUserEmail
     * @description : get users email address
     * @param uid Id value
     * @return user's email
     */
    @AuraEnabled
    public static String getUserEmail(String uid) {
        try {
            User user = [SELECT Email FROM User WHERE Id = :uid WITH SECURITY_ENFORCED];
            return user.Email;          
        } catch (Exception e) {
            return null;
        }
    }

    /** Method Name : updateUserEmail
     * @description : update users email address
     * @param newEmail new email address
     * @param userId Id value
     */
    @AuraEnabled
    public static void updateUserEmail(String newEmail, String userId) {
        try {
            User userToUpdate = [SELECT Email FROM User WHERE Id = :userId WITH SECURITY_ENFORCED];
            userToUpdate.Email = newEmail;
            if (Schema.sObjectType.User.fields.Email.IsCreateable() && Schema.sObjectType.User.fields.Email.IsUpdateable() && Schema.sObjectType.User.fields.Email.IsAccessible()){
                update userToUpdate;
            }
            
        } catch (Exception e) {       
            System.debug(e);
        }
    }

    /** Method Name : saveSecureUrl
     * @description : saveSecureUrl data
     * @param selectedSiteid Id value
     * @return String of UserEmail
     */
    @AuraEnabled
    public static String saveSecureUrl(Id selectedSiteid) {
        try {
            Site sitedta = [SELECT Id, Name, MasterLabel, Subdomain, SiteType, Status, GuestUserId FROM Site WHERE Id = :selectedSiteid];
            SiteDetail siteDetail = [SELECT Id, SecureUrl FROM SiteDetail WHERE DurableId = :selectedSiteid WITH SECURITY_ENFORCED];
            QuickForm_Administration__c customSetting = QuickForm_Administration__c.getOrgDefaults();
            customSetting.SecureUrl__c = siteDetail.SecureUrl;
            customSetting.SiteId__c = selectedSiteid;
            User user = [SELECT Email FROM User WHERE Id = :sitedta.GuestUserId WITH SECURITY_ENFORCED];
            
            if (QuickForm_Administration__c.SObjectType.getDescribe().isCreateable() && QuickForm_Administration__c.SObjectType.getDescribe().isUpdateable() && 
                Schema.SObjectType.QuickForm_Administration__c.fields.SecureUrl__c.isUpdateable() && Schema.SObjectType.QuickForm_Administration__c.fields.SecureUrl__c.isCreateable())
            {
            upsert customSetting;
            }
            return user.Email; 

        } catch (Exception e) {
            return null;
        }
    }

    /** Method Name : getSettingData
     * @description : getSettingData data
     * @return String
     */
    public class CustomSettingData {
        /** @description : siteId String*/
        @AuraEnabled
        public String siteId { get; set; }
        /** @description : userId String*/
        @AuraEnabled
        public String userId { get; set; }
    }


    /** Method Name : getSettingData
     * @description : getSettingData data
     * @return CustomSettingData
     */
    @AuraEnabled
    public static CustomSettingData getSettingData() {
        CustomSettingData data = new CustomSettingData();
        try {
            QuickForm_Administration__c customSetting = QuickForm_Administration__c.getOrgDefaults();
            if(String.isNotBlank(customSetting.SiteId__c)) {
                data.siteId = customSetting.SiteId__c;
                Site sitedta = [SELECT Id, GuestUserId FROM Site WHERE Id = :data.siteId];
                data.userId = sitedta.GuestUserId;
                return data;
            }else {
                return null;
            }
        } catch (Exception e) {
            return null;
        }
    }

    // get site from org 
    /** Method Name : getSitePrefixes
     * @description : getSitePrefixes data
     * @return List of String
     */
    @AuraEnabled
    public static List<String> getSitePrefixes() {
        try {
            List<String> sitePrefixes = new List<String>();
            for(Site site : [SELECT Id, Name, Subdomain, SiteType, Status FROM Site WHERE Status='Active']) {
                if(site.SiteType == 'Site') {
                    sitePrefixes.add(site.Subdomain);
                }
            }
            return sitePrefixes;
            
        } catch (Exception e) {
            return null;
        }
    }

    /** Method Name : assignPermissionSet
     * @description :assignPermissionSet data
     * @param oldselectedSiteName String
     * @param newselectedSiteName String
     */
    @AuraEnabled
    public static void assignPermissionSet(String oldselectedSiteName, String newselectedSiteName){
        try {
            
            PermissionSet permissionset = new PermissionSet();
            if (Schema.sObjectType.PermissionSet.IsAccessible()) {
                permissionset = [SELECT Id, Name FROM PermissionSet WHERE Name = 'QuickForm_Site_User_Access'];            
            if(Test.isRunningTest()){
                permissionset = [SELECT Id, Name FROM PermissionSet WHERE Name = 'TestQuickform'];            
            } 
            }


            if(oldselectedSiteName!=''){
                User oldusr = [SELECT Id, Name FROM User WHERE Name = :oldselectedSiteName+' Site Guest User' WITH SECURITY_ENFORCED];
                if (Schema.sObjectType.PermissionSetAssignment.isDeletable()  && PermissionSetAssignment.SObjectType.getDescribe().isAccessible()) {
                    PermissionSetAssignment oldpsa = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId = :permissionset.Id AND AssigneeId = :oldusr.Id];
                    if(oldpsa != null){
                    delete oldpsa;
                    }
                }
            }

                if (User.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.User.fields.Name.isAccessible() && PermissionSetAssignment.SObjectType.getDescribe().isAccessible() 
                && Schema.SObjectType.PermissionSetAssignment.fields.PermissionSetId.isAccessible() && Schema.SObjectType.PermissionSetAssignment.fields.AssigneeId.isAccessible() &&
                Schema.SObjectType.PermissionSetAssignment.fields.PermissionSetId.isCreateable() &&
                Schema.SObjectType.PermissionSetAssignment.fields.AssigneeId.isCreateable() &&
                   PermissionSetAssignment.SObjectType.getDescribe().isCreateable())
                {
                    User newSiteusr = [SELECT Id, Name FROM User WHERE Name = :newselectedSiteName+' Site Guest User'];
                    PermissionSetAssignment newpsa = new PermissionSetAssignment();
                    newpsa.PermissionSetId = permissionset.id;
                    newpsa.AssigneeId = newSiteusr.id;
                    if(Schema.sObjectType.PermissionSetAssignment.fields.AssigneeId.IsCreateable()){
                        insert newpsa;
                    }
                }


        } catch (Exception e) {
            System.debug('Exception--->>'+e.getMessage()+'-->'+e.getLinenumber());
        }
    }
}