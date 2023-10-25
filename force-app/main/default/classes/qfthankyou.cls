/**
* Create Date: 18/01/2023
* @description : Used for Edit, Delete, Read or Create New Form
*/
public with sharing class qfthankyou {

    /**
    * Method Name : getthankyoupage
    * @param currentformid Id value.
    * @description : getthankyoupage
    * @return Thankyou_Page__c record.
    */
    @AuraEnabled
    public static Thankyou_Page__c getthankyoupage(Id currentformid){
        try {
            Thankyou_Page__c record = new Thankyou_Page__c();
            if(currentformid != null) {
                record = [SELECT Id, Name, Form__c,Thank_you_URL__c, Thankyou_Page_Type__c	, Thankyou_Text__c, ThankYou_Label__c	FROM Thankyou_Page__c WHERE Form__c =: currentformid WITH SECURITY_ENFORCED LIMIT 1];
            }
            return record;
        } catch (Exception e) {
            return null;            
        }
    }
    
    /**
    * Method Name : insertrecord
    * @description : insertrecord
    * @param name String value. @param picklist String value. @param label String value. @param classtext String value. @param formId String value. @param url String value. @param currentthankyouid Id value.
    * @return Thankyou_Page__c record.
    */
    @AuraEnabled
    public static Thankyou_Page__c  insertrecord(String name,String picklist, String label, String classtext, String formId, String url, Id currentthankyouid){
        Thankyou_Page__c insertrecord = new Thankyou_Page__c();
        try {
            if (currentthankyouid == null) {      
                if (Schema.sObjectType.Thankyou_Page__c.isAccessible() && Schema.sObjectType.Thankyou_Page__c.isCreateable() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.Name.isAccessible() && Schema.sObjectType.Thankyou_Page__c.fields.Name.isCreateable() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.Form__c.isAccessible() && Schema.sObjectType.Thankyou_Page__c.fields.Form__c.isCreateable() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.ThankYou_Label__c.isAccessible() && Schema.sObjectType.Thankyou_Page__c.fields.ThankYou_Label__c.isCreateable() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.Thank_you_URL__c.isAccessible() && Schema.sObjectType.Thankyou_Page__c.fields.Thank_you_URL__c.isCreateable() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.Thankyou_Text__c.isAccessible() && Schema.sObjectType.Thankyou_Page__c.fields.Thankyou_Text__c.isCreateable() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.Thankyou_Page_Type__c.isAccessible() && Schema.sObjectType.Thankyou_Page__c.fields.Thankyou_Page_Type__c.isCreateable())
                {
                    insertrecord = new Thankyou_Page__c( Name = name, Form__c = formId, ThankYou_Label__c = label, Thank_you_URL__c = url, Thankyou_Text__c = classtext, Thankyou_Page_Type__c = picklist); 
                    Database.insert(insertrecord);
                }    
            } else {
                if (Schema.sObjectType.Thankyou_Page__c.isAccessible() && Schema.sObjectType.Thankyou_Page__c.isUpdateable() &&
                Schema.sObjectType.Thankyou_Page__c.fields.Name.isAccessible() && Schema.sObjectType.Thankyou_Page__c.fields.Name.isUpdateable() &&
                Schema.sObjectType.Thankyou_Page__c.fields.ThankYou_Label__c.isAccessible() && Schema.sObjectType.Thankyou_Page__c.fields.ThankYou_Label__c.isUpdateable() &&
                Schema.sObjectType.Thankyou_Page__c.fields.Thank_you_URL__c.isAccessible()  && Schema.sObjectType.Thankyou_Page__c.fields.Thank_you_URL__c.isUpdateable() &&
                Schema.sObjectType.Thankyou_Page__c.fields.Thankyou_Text__c.isAccessible() && Schema.sObjectType.Thankyou_Page__c.fields.Thankyou_Text__c.isUpdateable() &&
                Schema.sObjectType.Thankyou_Page__c.fields.Thankyou_Page_Type__c.isAccessible()  && Schema.sObjectType.Thankyou_Page__c.fields.Thankyou_Page_Type__c.isUpdateable() &&
                Schema.sObjectType.Thankyou_Page__c.fields.Id.isAccessible())
            {
                insertrecord = new Thankyou_Page__c( Name = name, ThankYou_Label__c = label, Thank_you_URL__c = url, Thankyou_Text__c = classtext, Thankyou_Page_Type__c = picklist, Id = currentthankyouid); 
                Database.update(insertrecord);
            }    
            }
        }catch(Exception e) {
            error_handler.insert_errordata(e,'qfthankyou','insertrecord');
        }
        return insertrecord;
    }

    /**
    * Method Name : getrecordslist
    * @description : getrecordslist
    * @param currentformid Id value.
    * @return Thankyou_Page__c record.
    */
    @AuraEnabled
    public static Thankyou_Page__c getrecordslist(Id currentformid){
        try {
            if(currentformid != null){
                Thankyou_Page__c thankyouformId = [SELECT Id, Name, Form__c,Thank_you_URL__c, Thankyou_Page_Type__c, Thankyou_Text__c, ThankYou_Label__c	FROM Thankyou_Page__c WHERE Form__c =: currentformid WITH SECURITY_ENFORCED];
                return thankyouformId;
            }
            else {
                return null;
            }
        } catch (Exception e) {
            return null;
        }
    }   

    /** @description Used to Update or insert thank you page
        @param label String Value.
        @param currentthankyouid Id Value.
    */
    @AuraEnabled
    public static void changelabel(String label, Id currentthankyouid){
        try {
            Thankyou_Page__c insertrecord = new Thankyou_Page__c(  ThankYou_Label__c = label, Id = currentthankyouid ); 
            if (Schema.sObjectType.Thankyou_Page__c.fields.ThankYou_Label__c.isCreateable() && Schema.sObjectType.Thankyou_Page__c.fields.ThankYou_Label__c.isUpdateable()){
                Database.upsert(insertrecord);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
      
}