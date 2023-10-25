/**
 * @description : Notification Insert data Class to manage notification component.
 */
public with sharing class notificationInsertData{
    /**
     * @description : Method to create notification record.
     * @param acc Notification__c record.
     */
    @AuraEnabled
    public static void create(Notification__c acc){
        try{
            Notification__c notification = new Notification__c();
            notification.To_Recipients__c = acc.To_Recipients__c;
            notification.CC_Recipients__c = acc.CC_Recipients__c;
            notification.BCC_Recipients__c = acc.BCC_Recipients__c;
            notification.Subject__c = acc.Subject__c;
            notification.Email_Body__c = acc.Email_Body__c;
            notification.Form__c = acc.Form__c;
            notification.Attachment__c = acc.Attachment__c;
            notification.Id = acc.Id;
            notification.Status__c = acc.Status__c;
            if (Schema.sObjectType.Notification__c.fields.To_Recipients__c.isCreateable() && Schema.sObjectType.Notification__c.fields.CC_Recipients__c.isCreateable() && Schema.sObjectType.Notification__c.fields.BCC_Recipients__c.isCreateable() && Schema.sObjectType.Notification__c.fields.Subject__c.isCreateable() && Schema.sObjectType.Notification__c.fields.Email_Body__c.isCreateable() && Schema.sObjectType.Notification__c.fields.Form__c.isCreateable() && Schema.sObjectType.Notification__c.fields.Attachment__c.isCreateable() && Schema.sObjectType.Notification__c.fields.Status__c.isCreateable()){
                insert notification;
            }
        } catch (Exception e){
            error_handler.insert_errordata(e, 'notificationInsertData', 'create');
        }
    }

    /**
     * @description : Method to update notification record.
     * @param updatelist Notification__c record.
     * @return Notification__c record
     */
    @AuraEnabled
    public static Notification__c updated(Notification__c updatelist){
        try{
            Notification__c record = new Notification__c(Id = updatelist.Id);
            record.To_Recipients__c = updatelist.To_Recipients__c;
            record.CC_Recipients__c = updatelist.CC_Recipients__c;
            record.Subject__c = updatelist.Subject__c;
            record.Email_Body__c = updatelist.Email_Body__c;
            record.Attachment__c = updatelist.Attachment__c;
            record.BCC_Recipients__c = updatelist.BCC_Recipients__c;

            if (Schema.sObjectType.Notification__c.fields.Attachment__c.isUpdateable() && Schema.sObjectType.Notification__c.fields.CC_Recipients__c.isUpdateable() && Schema.sObjectType.Notification__c.fields.Email_Body__c.isUpdateable() && Schema.sObjectType.Notification__c.fields.To_Recipients__c.isUpdateable() && Schema.sObjectType.Notification__c.fields.Subject__c.isUpdateable() && Schema.sObjectType.Notification__c.fields.BCC_Recipients__c.isUpdateable()){
                update record;
            }
            return record;

        } catch (Exception e){
            error_handler.insert_errordata(e, 'notificationInsertData', 'updated');
            return null;
        }
    }

    /**
     * @description : Method for getting the contact list from the notification record.
     * @param formid String value.
     * @return List of Notification__c
     */
    @AuraEnabled
    public static List<Notification__c> getContactList(String formid){
        List<Notification__c> notification = new List<Notification__c>();
        try{
            notification = [SELECT Attachment__c, CC_Recipients__c, Email_Body__c, To_Recipients__c, ID, Subject__c, BCC_Recipients__c, Status__c
                            FROM Notification__c
                            WHERE Form__c = :formid
                            WITH SECURITY_ENFORCED];
        } catch (Exception e){
            error_handler.insert_errordata(e, 'notificationInsertData', 'getContactList');
        }
        return notification;
    }

    /**
     * @description : Method to manage the notification status of a record.
     * @param formid Id value.
     * @param status Boolean value.
     * @return Notification__c record
     */
    @AuraEnabled
    public static List<Notification__c> getNotificationByStatus(Id formid, Boolean status){

        List<Notification__c> notification = new List<Notification__c>();
        try{
            notification = [SELECT Id, Status__c
                            FROM Notification__c
                            WHERE Form__c = :formid
                            WITH SECURITY_ENFORCED];
            if(!notification.isEmpty()){
                notification[0].Status__c = status;
                if (Schema.sObjectType.Notification__c.fields.Status__c.isUpdateable()){
                    update notification;
                }
            }
            return notification;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'notificationInsertData', 'getNotificationByStatus');
            return null;
        }
    }

}