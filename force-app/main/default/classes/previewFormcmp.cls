/**
* Class Name : previewFormcmp
* Test Class : Test_previewFormcmp
* Date : 05/04/2023
* @description : Used in previewFormCmp LWC componnet
*/
public with sharing class previewFormcmp{

    /**
    * Method Name : formdetails
    * @description : formdetails.
    * @param id Id value.
    * @param webUrl String value.
    * @return Form__c record.
    */
    @AuraEnabled
    public static Form__c formdetails(Id id, String webUrl){
        Form__c nform = new Form__c();
        try{
            nform = [SELECT Id, Name, Progress_Indicator__c, Captcha_Type__c, Button_CSS__c, Button_Position__c, Page_CSS__c, Form_Styling__c, All_Field_Hover__c, All_Field_Focus__c, All_Field_Styling__c, Label_CSS__c, FormBgID__c, PageBgID__c, Status__c, Mapped_Objects__c
                    FROM Form__c
                    WHERE Id = :id WITH SECURITY_ENFORCED];
            if (nform == null) {
                return null;
            }
            if (nform.Status__c && webUrl != null && webUrl != ''){
                String baseUrl = webUrl.split('PreViewForm?')[0];

                QuickForm_Administration__c customsetting = QuickForm_Administration__c.getOrgDefaults();
                if(customsetting.SecureUrl__c.right(1) != '/') {
                    customsetting.SecureUrl__c += '/';
                }
                if (baseUrl != customsetting.SecureUrl__c){
                    nform.Status__c = false;
                }
            } else if (webUrl == null || webUrl == ''){
                nform.Status__c = true;
            }
        } catch (Exception e){

            return null;
        }
        return nform;
    }

    /**
    * Method Name : bgimages
    * @description : bgimages
    * @param id Id value.
    * @param data String value.
    * @return String
    */
    @AuraEnabled
    public static String bgimages(Id id, String data){
        try{
            String result = '';
            ContentVersion cv = new ContentVersion();
            cv = [SELECT Id, VersionData
                    FROM ContentVersion
                    WHERE Id = :id WITH SECURITY_ENFORCED];
            if (cv == null) {
                return null;
            }
            result += 'url("data:image/png;base64,' + EncodingUtil.base64Encode(cv.VersionData);
            String str = data.split('background-image:')[0];
            str += 'background-image:' + result + '");';

            return str;
        } catch (Exception e){
            return null;
        }
    }

    /**
    * Method Name : formfielddetails
    * @description : formfielddetails
    * @param id Id value.
    * @return List of Form_Fields__c
    */
    @AuraEnabled
    public static List<Form_Fields__c> formfielddetails(Id id){
        try{
            List<Form_Fields__c> fieldList = new List<Form_Fields__c>();
            fieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                                            FROM Form_Fields__c
                                            WHERE Form__c = :id WITH SECURITY_ENFORCED
                                            ORDER BY Field_Order__c ASC];
            return fieldList;
        } catch (Exception e){
            return null;
        }
    }

    /**
    * Method Name : formpagedetails
    * @description : formpagedetails
    * @param id String value.
    * @return List of Form_Page__c
    */
    @AuraEnabled
    public static List<Form_Page__c> formpagedetails(String id){
        try{
            List<Form_Page__c> pageList = new List<Form_Page__c>();
            pageList = [SELECT Id, Name, Page_Number__c
                                        FROM Form_Page__c
                                        WHERE Form__c = :id WITH SECURITY_ENFORCED
                                        ORDER BY Page_Number__c ASC];
            return pageList;
        } catch (Exception e){
            return null;
        }
    }

    /**
    * Method Name : getInactiveForms
    * @description : getInactiveForms
    * @param id String value.
    * @return Boolean
    */
    @AuraEnabled
    public static Boolean getInactiveForms(String id){
        try{
            List<Form__c> inactiveForm = new List<Form__c>();
            inactiveForm = [SELECT Id, Status__c
                            FROM Form__c
                            WHERE Status__c = false AND Id = :id WITH SECURITY_ENFORCED];
            if (inactiveForm.size() > 0){
                return true;
            } else{
                return false;
            }
        } catch (Exception e){
            return null;
        }
    }

    /**
    * Method Name : sendemailaftersubmission
    * @description : sendemailaftersubmission
    * @param formid Id value.
    * @param submissionid Id value.
    */
    @AuraEnabled
    public static void sendemailaftersubmission(Id formid, Id submissionid){
        try{
            
            Notification__c notify = [SELECT Id,Form__r.Name, To_Recipients__c, CC_Recipients__c, BCC_Recipients__c, Subject__c, Email_Body__c, Attachment__c, Status__c
                    FROM Notification__c
                    WHERE Form__c = :formid WITH SECURITY_ENFORCED];
            if (notify.Status__c == true){
                EmailServicesAddress esa = [SELECT Id, EmailDomainName, IsActive, LocalPart FROM EmailServicesAddress WHERE Function.FunctionName =: 'QuickFormemailservice' Limit 1]; 
                OrgWideEmailAddress[] owea = [select Id, Address from OrgWideEmailAddress WHERE DisplayName =: 'QF-OWA'  LIMIT 1];
                Messaging.SingleEmailMessage emailNotification = new Messaging.SingleEmailMessage();        
                        List<String> toAddresses = new List<String>();
                        toAddresses.add(esa.LocalPart+'@' +esa.EmailDomainName);
                        if ( owea.size() > 0 ) {
                            emailNotification.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        emailNotification.setToAddresses(toAddresses);
                        emailNotification.setSubject('New Form');
                        emailNotification.setPlainTextBody(formid +','+ submissionid);
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ emailNotification });
            }
        } catch (Exception e){
            System.debug('Exception in previewclass--->>'+e.getLineNumber()+' -->>'+e.getMessage());
        }
    }
}