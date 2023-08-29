/**
    *@description QuickFormHome used of the Create,update or Delete. 
*/
public with sharing class QuickFormHome{/*QuickFormHome used ofr the Create,update or Delete. */

    /**    
        @description Public Variable formid to store the id of the form
    */
    public static String formid{ get; set; }
    /**    
        @description Public Variable urlvalue to store the publicurl of the form
    */
    public string urlvalue{ get; set; }
     /**    
        @description QuickFormHome constructor
    */
    public QuickFormHome(){
        urlvalue = Apexpages.currentPage().getParameters().get('formid');
    }

    /**
     * @description return the list of form objects records
     * @return list of form object records
    */
    @AuraEnabled
    public static List<Formwrapper> getFormRecords(){ /*getFormRecords to return all record to store into the Form object */
        try{
            return commonquery('');
        } catch (Exception e){
            return null;
        }
    }

    /**
    Method Name : searchForms 
    @param searchkey to finde the form name
    @description searchForms to return based onthe serch the form name all record to store into the Form object
    * @return list of form object records according to search key
    */  
    @AuraEnabled
    public static List<Formwrapper> searchForms(String searchkey){ /*searchForms to return based onthe serch the form name all record to store into the Form object */
        try{
            if(Schema.sObjectType.Form__c.fields.Name.IsAccessible()){
                return commonquery(searchkey);
            }else{
                return null;
            }

        } catch (Exception e){
            return null;
        }
    }  

    /**
    Method Name : getFormsByStatus 
    @param id to finde the form name 
    @param searchkey to finde the form        
    @description getFormsByStatus to return the form is Active or not
    @return returns formstatus by using id and search key parameter
    */
    @AuraEnabled
    public static List<Formwrapper> getFormsByStatus(Id id, String searchkey){/*getFormsByStatus to return the form is Active or not */
        try{            
            if(Schema.sObjectType.Form__c.fields.Name.IsAccessible() && Schema.sObjectType.Form__c.fields.createdDate.IsAccessible()){
                Form__c form = [SELECT Id, Name, Status__c, (SELECT Id FROM Form_Submissions__r) FROM Form__c WHERE Id = :id WITH SECURITY_ENFORCED order by createdDate DESC];
                if (form.Status__c == true){
                    form.Status__c = false;
                } else{
                    form.Status__c = true;
                }
                if(Schema.sObjectType.Form__c.fields.Status__c.isUpdateable()){
                    update form;
                }
                return commonquery(searchkey);
            }else{
                return null;
            }
        } catch (Exception e){
            error_handler.insert_errordata(e, 'QuickFormHome', 'getFormsByStatus');
            return null;
        }
    }
    
    /**
    Method Name : deleteFormRecord 
    @param id to finde the form name 
    @param searchkey to finde the form        
    @description deleteFormRecord to delete a form
    @return returns list after delete form record
    */
    @AuraEnabled
    public static List<Formwrapper> deleteFormRecord(Id id, String searchkey){    /*deleteFormRecord to delete a form */
        try{

            Form__c form = [SELECT Id, Name, Status__c,PageBgID__c,FormBgID__c, (SELECT Id FROM Form_Submissions__r) FROM Form__c  WHERE Id = :id WITH SECURITY_ENFORCED order by createdDate DESC];
            if(Schema.sObjectType.ContentDocument.isDeletable()){
                List<Id> bgId = new List<Id>();
                bgId.add(form.FormBgID__c);
                bgId.add(form.PageBgID__c);
                if (Schema.sObjectType.ContentVersion.fields.ContentDocumentId.IsAccessible()){    
                    List<ContentVersion> cv = [SELECT Id,ContentDocumentId FROM ContentVersion WHERE Id IN : bgId];
                    bgId.clear();
                    for(ContentVersion c : cv){
                        bgId.add(c.ContentDocumentId);
                    }
                    delete [SELECT Id FROM ContentDocument WHERE Id IN : bgId];
                }
            }
            if(Schema.sObjectType.Form__c.isDeletable()){
                delete form;
            }
            return commonquery(searchkey);    
            
        } catch (Exception e){
            error_handler.insert_errordata(e, 'QuickFormHome', 'deleteFormRecord');
            return null;
        }
    }

    /**
    Method Name : renameFormRecord 
    @param id to stored the new formName 
    @param rename to stored the formName to find the form
    @param searchkey to finde the form    
    @description renameFormRecord to rename the form name
    @return form records after renaming the form
    */
    @AuraEnabled
    public static List<Formwrapper> renameFormRecord(Id id, String rename, String searchkey){ /* renameFormRecord to rename the form name */
        try{                        
            if (Schema.sObjectType.Form__c.fields.Name.IsAccessible() && Schema.sObjectType.Form__c.fields.Name.isUpdateable()) {
                Form__c form = [SELECT Name FROM Form__c WHERE Id = :id Limit 1];
                form.Name = rename;
                update form;
                return commonquery(searchkey);                    
            }else {
                return null;
            }
            } catch (Exception e){
            error_handler.insert_errordata(e, 'QuickFormHome', 'renameFormRecord');
            return null;
        }
    }

    /**
    Method Name : sendemail 
    @param name to stored the username 
    @param email to stored the user email address 
    @param subject to stored the subject name  
    @param body to stored the email body user requrmaint or feedback 
    @param fname to stored the files Name 
    @param fbase64 to stored the files data 
    @return String
    @description sendemail send the email uisng QuickBot data
    */
    @AuraEnabled
    public static String sendemail(String name, String email, String subject, String body, List<String> fname, List<String> fbase64){/*sendemail send the email uisng QuickBot data */
        try{
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            String myCustomLabel = System.Label.supportEmail;
            List<String> toEmailAddress = new List<String>();
            if(myCustomLabel.contains(',')){
                toEmailAddress.addAll(myCustomLabel.split(','));
            }else{ 
                toEmailAddress.add(myCustomLabel); 
            }             
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            for (Integer i = 0; i < fname.size(); i++){
                Messaging.Emailfileattachment efat = new Messaging.Emailfileattachment();
                efat.setFileName(fname[i]);
                String fdata = fbase64[i];
                efat.setBody(EncodingUtil.base64Decode(fdata));
                fileAttachments.add(efat);
            }

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject(subject);
            mail.setplaintextbody(body + '\n\n\nFrom ' + name + '\nEmail ' + email);
            mail.setToAddresses(toEmailAddress) ;
            if (fileAttachments != null && fileAttachments.size() > 0){
                mail.setFileAttachments(fileAttachments);
            }
            emailList.add(mail);
            Messaging.sendEmail(emailList);

            return 'success';
        } catch (Exception e){
            error_handler.insert_errordata(e, 'QuickFormHome', 'sendemail');
            return 'fail';
        }
    }



    /**
    Method Name : getProgressindicator         
    @description getProgressindicator get the progress bar using form metadata
    @return progress indicator metadata values
    */
    @AuraEnabled(cacheable = true)
    public static List<Progress_Indicator__mdt> getProgressindicator(){/* getProgressindicator get the progress bar using form object*/
        return Progress_Indicator__mdt.getAll().values();
    }

    /**
    Method Name : getCaptchatype 
    @return Captcha_Type__mdt return the metadata value
    @description getCaptchatype get the captchatype based on the form metadata
    */
    @AuraEnabled(cacheable=true)
    public static List<	Captcha_Type__mdt> getCaptchatype(){/*getCaptchatype get the captchatype based on the form object*/
        return Captcha_Type__mdt.getAll().values();
       
    }

    /**
    Method Name : f_Get_Types 
    @return lTypes return all metadata values
    @description f_Get_Types return the progree bar based onthe store the progress bar type
    */
    @AuraEnabled(cacheable=true)
    public static List<Progress_Indicator__mdt> f_Get_Types(){/* f_Get_Types return the progree bar based onthe store the progress bar type*/
        try {
            List<Progress_Indicator__mdt> lTypes = new List<Progress_Indicator__mdt>();
            if (Schema.sObjectType.Progress_Indicator__mdt.fields.DeveloperName.IsAccessible() && Schema.sObjectType.Progress_Indicator__mdt.fields.Label.IsAccessible() && Schema.sObjectType.Progress_Indicator__mdt.fields.sr__c.IsAccessible()) {
                lTypes = [SELECT DeveloperName,Label,sr__c FROM Progress_Indicator__mdt ORDER BY sr__c ASC];
                return lTypes;
            }else{
                return null;
            }
        } catch (Exception e) {
            return null;
        }
    }

    /**
    Method Name : Get_Captcha_Types 
    @return captchaTypes return all metadata values
    @description Get_Captcha_Types return the progree bar based onthe store the Captcha type
    */
    @AuraEnabled(cacheable=true)
    public static List<Captcha_Type__mdt> Get_Captcha_Types(){/*Get_Captcha_Types return the progree bar based onthe store the Captcha type*/
        try {
            List<Captcha_Type__mdt> captchaTypes = new List<Captcha_Type__mdt>();
            if (Schema.sObjectType.Captcha_Type__mdt.fields.DeveloperName.IsAccessible() && Schema.sObjectType.Captcha_Type__mdt.fields.Label.IsAccessible() && Schema.sObjectType.Captcha_Type__mdt.fields.sr__c.IsAccessible()) {
                captchaTypes = [SELECT DeveloperName,Label,sr__c FROM Captcha_Type__mdt ORDER BY sr__c ASC]; 
                return captchaTypes;
            }else{
                return null;
            }
        } catch (Exception e) {
            return null;
        }
    }

    /**
        Method Name : siteUrl 
        @param formid return all form list         
        @description siteUrl return the all site name is created in org
        @return siteUrl return the all site name is created in org
    */
    @AuraEnabled
    public static String siteUrl(String formid){/*siteUrl return the all site name is created in org */
        String publishedURL = '';
        try {
            if(Schema.sObjectType.Form__c.fields.Name.IsAccessible() && Schema.sObjectType.Form__c.fields.Form_Published_URL__c.IsAccessible() && Schema.sObjectType.Form__c.fields.Form_Published_URL__c.isUpdateable()){
                List<Form__c> formRecord = new List<Form__c>([SELECT Id, Name, Form_Published_URL__c FROM Form__c WHERE Id = :formid]);
                QuickForm_Administration__c customsetting = QuickForm_Administration__c.getInstance();

                if(String.isBlank(customsetting.SecureUrl__c)) {
                    publishedURL = 'Please select site from User Configuration tab to publish form.';
                }else if(formRecord.size() > 0 && !String.isBlank(formRecord[0].Form_Published_URL__c) && formRecord[0].Form_Published_URL__c.contains(customsetting.SecureUrl__c)) {
                    publishedURL = formRecord[0].Form_Published_URL__c;
                }else if(!String.isBlank(customsetting.SecureUrl__c)) {
                        String modifiedSecureURL = customsetting.SecureUrl__c;
                        String encryptedData = EncryptDecryptController.processEncryption(formid);
                        if(modifiedSecureURL.right(1) != '/') {
                            modifiedSecureURL += '/';
                        }
                        publishedURL = modifiedSecureURL+'PreViewForm?access_key='+encryptedData;
                        Form__c formRec = new Form__c(Id = formid);
                        formRec.Form_Published_URL__c = publishedURL;
                        update formRec;
                }else {
                    publishedURL = 'Please select site from User Configuration tab to publish form.';
                }
            }else{
                return null;
            }
        } catch (Exception e) {
            return null;
        }
        return publishedURL;
    }

    /**                 
        @param searchkey find the form list based onthe serckkey value 
        @description return the form list based onthe the pass value
        @return return submitted forms count
    */    
    public static List<Formwrapper> commonquery(String searchkey){/* return the form list based onthe the pass value */
        try {
            
            if(Schema.sObjectType.Form__c.fields.Name.IsAccessible() && Schema.sObjectType.Form__c.fields.Status__c.IsAccessible() && Schema.sObjectType.Form__c.fields.createdDate.IsAccessible()){
                String searchkeyword = '%' + searchkey + '%';
                String query = 'SELECT Id, Name, Status__c ,(SELECT Id FROM Form_Submissions__r) FROM Form__c';
                if (searchkey != null && searchkey != '' && searchkey != 'undefined'){
                    query += ' WHERE Name LIKE :searchkeyword order by createdDate  DESC  ';
                } else{
                    query += ' order by createdDate  DESC   ';
                }
    
                List<Form__c> forms = Database.query(query);
    
                List<Formwrapper> wrapper = new List<Formwrapper>();
                for (Form__c qfForm : forms){
                    wrapper.add(new formWrapper(qfForm.Form_Submissions__r.size(), qfForm));
                }
                return wrapper;
    
            }else{
                return null;
            }
        } catch (Exception e) {
            System.debug(e);
            return null;
        }
    }

    /**
        *@description create a wrapper for stord the all value
    */
    public class Formwrapper{/* create a wrapper for stord the all value*/
        /**
            *@description wrapperclass variable to store submissioncount
        */
        @AuraEnabled
        public Integer submissionCount{ get; set; }
        /**
            *@description wrapperclass variable to store formlist record
        */
        @AuraEnabled
        public Form__c formlist{ get; set; }

        /** 
        check the form obejct value
        @param count return total submistion onthe form 
        @param form return the form value
        @description return the Data and total number of Submisson this form
        */    
        public formWrapper(Integer count, Form__c form){/* return the Data and total number of Submisson this form */
            try{
                this.submissionCount = count;
                this.formlist = form;
            } catch (Exception e){
                error_handler.insert_errordata(e,'QuickFormHome','formWrapper');
            }
        }
    }
}