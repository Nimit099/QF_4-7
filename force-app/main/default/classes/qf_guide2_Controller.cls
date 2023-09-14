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

    /** Method Name : saveSecureUrl
     * @description : saveSecureUrl data
     * @param selectedSiteid Id value
     * @return String of UserEmail
     */
    @AuraEnabled
    public static void saveSecureUrl(Id selectedSiteid) {
        try {
            SiteDetail siteDetail = [SELECT Id, SecureUrl FROM SiteDetail WHERE DurableId = :selectedSiteid WITH SECURITY_ENFORCED];
            QuickForm_Administration__c customSetting = QuickForm_Administration__c.getOrgDefaults();
            customSetting.SecureUrl__c = siteDetail.SecureUrl;
            customSetting.SiteId__c = selectedSiteid;
            
            if (QuickForm_Administration__c.SObjectType.getDescribe().isCreateable() && QuickForm_Administration__c.SObjectType.getDescribe().isUpdateable() && 
                Schema.SObjectType.QuickForm_Administration__c.fields.SecureUrl__c.isUpdateable() && Schema.SObjectType.QuickForm_Administration__c.fields.SecureUrl__c.isCreateable())
            {
            upsert customSetting;
            }
        } catch (Exception e) {
           error_handler.insert_errordata(e, 'qf_guide2_Controller','saveSecureUrl');
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
                return data;
            }else {
                return null;
            }
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
            error_handler.insert_errordata(e, 'qf_quide2_Controller', 'assignPermissionSet');
        }
    }
}