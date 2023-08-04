/**
 * @description FormBuilderController Class
 */
public with sharing class customMetadata {

    /** @description formid variable */
    public static String formid{get;set;}

    /** @description test_form_id variable */
    public static String test_form_id;

    /** @description urlvalue variable */
    public string urlvalue{get;set;}

    /**
     * @description customMetadata Constructor
     */
    public customMetadata() {
        urlvalue=Apexpages.currentPage().getParameters().get('formid');
    }

    /**
     * @description getProgressindicator Method
     * @return List of Progress_Indicator__mdt
     */
    @AuraEnabled(cacheable=true)
    public static List<Progress_Indicator__mdt> getProgressindicator(){
        return Progress_Indicator__mdt.getAll().values();
       
    }

    /**
     * @description getCaptchatype Method
     * @return List of Captcha_Type__mdt
     */
    @AuraEnabled(cacheable=true)
    public static List<	Captcha_Type__mdt> getCaptchatype(){
        return Captcha_Type__mdt.getAll().values();
       
    }

    /**
     * @description f_Get_Types Method
     * @return List of Progress_Indicator__mdt
     */
    @AuraEnabled(cacheable=true)
    public static List<Progress_Indicator__mdt> f_Get_Types(){
        try {
            List<Progress_Indicator__mdt> l_Types = new List<Progress_Indicator__mdt>();
             
            l_Types = [SELECT DeveloperName,Label,sr__c FROM Progress_Indicator__mdt ORDER BY sr__c ASC]; // Can include multiple fields, 
            
            // You can also use any standard or custom object
            // You can get values from custom setting also.
             
            return l_Types;
        } catch (Exception e) {
            // error_handler.insert_errordata(e ,'customMetadata','f_get_Type');
            // System.debug(e.getMessage());
            System.debug('Exception: '+e.getMessage());
            return null;
        }
    }


    /**
     * @description Get_Captcha_Types Method
     * @return List of Captcha_Type__mdt
     */
    @AuraEnabled(cacheable=true)
    public static List<Captcha_Type__mdt> Get_Captcha_Types(){
        try {
            List<Captcha_Type__mdt> Captcha_Types = new List<Captcha_Type__mdt>();
             
            Captcha_Types = [SELECT DeveloperName,Label,sr__c FROM Captcha_Type__mdt ORDER BY sr__c ASC]; // Can include multiple fields, 
            
            // You can also use any standard or custom object
            // You can get values from custom setting also.
             
            return Captcha_Types;
        } catch (Exception e) {
            // error_handler.insert_errordata(e,'customMetadata','Get_Captcha_Types');
            // System.debug(e.getMessage());
            System.debug('Exception: '+e.getMessage());
            return null;
        }
    }

    /**
     * @description siteUrl Method
     * @param Formid
     * @return String
     */
    @AuraEnabled
    public static String siteUrl(String Formid){
        String publishedURL = '';
        try {
            List<Form__c> formRecord = new List<Form__c>();
        if (Schema.sObjectType.Form__c.fields.Name.isAccessible() && Schema.sObjectType.Form__c.fields.Form_Published_URL__c.isAccessible()){
            formRecord = new List<Form__c>([SELECT Id, Name, Form_Published_URL__c FROM Form__c WHERE Id = :Formid]);
        }
            QuickForm_Administration__c customsetting = QuickForm_Administration__c.getInstance();
            if(String.isBlank(customsetting.SecureUrl__c)) {
                publishedURL = 'Please select site from User Configuration tab to publish form.';
            }else if(formRecord.size() > 0 && !String.isBlank(formRecord[0].Form_Published_URL__c) && formRecord[0].Form_Published_URL__c.contains(customsetting.SecureUrl__c)) {
                publishedURL = formRecord[0].Form_Published_URL__c;
            }else if(!String.isBlank(customsetting.SecureUrl__c)) {
                String modifiedSecureURL = customsetting.SecureUrl__c;

                // Form Id Encryption 
                String encryptedData = EncryptDecryptController.processEncryption(Formid);
                publishedURL = modifiedSecureURL+'PreViewForm?access_key='+encryptedData;
                System.debug(publishedURL);
                Form__c formRec = new Form__c(Id = Formid);
                formRec.Form_Published_URL__c = publishedURL;

                if (Schema.sObjectType.Form__c.fields.Form_Published_URL__c.isUpdateable() && Schema.sObjectType.Form__c.fields.Form_Published_URL__c.isAccessible() && Schema.sObjectType.Form__c.fields.Id.isAccessible()){
                    update formRec;
                }
            }else {
                publishedURL = 'Please select site from User Configuration tab to publish form.';
            }
        } catch (Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            return null;
        }
        return publishedURL;
    }
}