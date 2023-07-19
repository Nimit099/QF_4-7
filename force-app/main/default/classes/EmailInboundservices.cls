global class EmailInboundservices implements Messaging.InboundEmailHandler {
	  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          try{
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            List<String> objectName = new List<String>();
            Map<String, Object> mapoffirstobject = new Map<String, Object>();
            Map<String, Object> mapofsecondobject = new Map<String, Object>();
            List<String> firstobjectdata = email.plainTextBody.split('<MVQFSeperator>')[0].split(',');
            List<String> secondobjectdata = email.plainTextBody.split('<MVQFSeperator>')[1].split(',');
            List<String> lookup_list = email.plainTextBody.split('<MVQFSeperator>')[3].split(',');
            String base64att = email.plainTextBody.split('<MVQFSeperator>')[4];

            Boolean create_chi;
            String key = '';
            String value = '';
            for (String firstobject : firstobjectdata) {
                key = firstobject.split(':')[0];
                value = firstobject.split(':')[1];

                if (key == 'sobjectType') {
                    objectName.add(value);
                } else {
                    mapoffirstobject.put(key, value);
                }
            }

            for (String secondobject : secondobjectdata) {
                key = secondobject.split(':')[0];
                value = secondobject.split(':')[1];

                if (key == 'sobjectType') {
                    objectName.add(value);
                } else {
                    mapofsecondobject.put(key, value);
                }
            }
            if (email.plainTextBody.split('<MVQFSeperator>')[2] == 'true') {
                create_chi = true;
            } else if(email.plainTextBody.split('<MVQFSeperator>')[2] == 'false'){
                create_chi = false;
            }

           System.debug(create_chi);
           System.debug(mapoffirstobject);
           System.debug(mapofsecondobject);
           System.debug(objectName);
           System.debug(lookup_list);
           System.debug(firstobjectdata);
           System.debug(secondobjectdata);

            // String formid = email.plainTextBody.split(',')[0];
            // String submissionid = email.plainTextBody.split(',')[1];
            // Notification__c notify = new Notification__c();
            // OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress Limit 1];
            // notify = [SELECT Id,Form__r.Name, To_Recipients__c, CC_Recipients__c, BCC_Recipients__c, Subject__c, Email_Body__c, Attachment__c, Status__c
            //             FROM Notification__c
            //             WHERE Form__c = :formid WITH SECURITY_ENFORCED];
            //     if (notify.Status__c == true){
            //         if (notify != null || notify.Id != null){
            //             String recipientList = notify.To_Recipients__c;
            //             String ccmaillist = notify.CC_Recipients__c;
            //             String bccmaillist = notify.BCC_Recipients__c;
            //             String messageBody = notify.Email_Body__c;
            //             String messageSubject = notify.Subject__c;
            //             boolean attachmentpdf = notify.Attachment__c;
            //             List<String> ccAddresses = new List<String>();
            //             List<String> bccAddresses = new List<String>();
            //             List<String> toAddresses = recipientList.split(',');
            //             if (String.isNotBlank(ccmaillist)){
            //                 ccAddresses = ccmaillist.split(',');
            //             }
            //             if (String.isNotBlank(bccmaillist)){
            //                 bccAddresses = bccmaillist.split(',');
            //             }

            //             if (toAddresses.size() != 0){
            //                 Messaging.SingleEmailMessage emailNotification = new Messaging.SingleEmailMessage();
            //                 // if ( owea.size() > 0 ) {
            //                 //     emailNotification.setOrgWideEmailAddressId(owea.get(0).Id);
            //                 // }
            //                 emailNotification.setToAddresses(toAddresses);
            //                 if (ccAddresses.size() > 0){
            //                     emailNotification.setCCaddresses(ccAddresses);
            //                 }
            //                 if (bccAddresses.size() > 0){
            //                     emailNotification.setBCCaddresses(bccAddresses);
            //                 }
            //                 emailNotification.setSubject(messageSubject);
            //                 emailNotification.setHtmlBody(messageBody);
            //                 if (attachmentpdf == true){
            //                     String pdfUrl = '/apex/PDFGenerator?Id=' + submissionid;
            //                     PageReference pdfPage = new PageReference(pdfUrl);
            //                     Blob pdfContent;
            //                     if (Test.isRunningTest()){
            //                         pdfContent = blob.valueOf('Unit.Test');
            //                     } else{
            //                         pdfContent = pdfPage.getContentAsPDF();
            //                     }
            //                     Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
            //                     String pdfName = '';
            //                     if(String.isNotBlank(notify.Form__r.Name)){
            //                         pdfName = notify.Form__r.Name +'_' +DateTime.now();
            //                     }
            //                     emailAttachment.setFileName(pdfName+'.pdf');
            //                     emailAttachment.setBody(pdfContent);
            //                     emailNotification.setFileAttachments(new Messaging.EmailFileAttachment[]{ emailAttachment });
            //                 }
            //                 System.debug('emailNotification' + emailNotification);
            //                 Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ emailNotification });
            //                 // System.debug('results' + results);
            //             }
                // }
            // }
          return null;
        } catch(Exception e){
            System.debug('errror' +String.valueOf(e)+ ' : '+ e.getLineNumber());
            return null;
        }
      }

    public static List<Id> insertRecordList = new List<Id>();

      public static SubId createrecord_for_secod_object(List<String> objectName, Map<String, Object> firstobjectdata,Map<String, Object> secondobjectdata, Boolean create_chi, List<String> lookup_list, String base64att ){
        try{

            // Map<String, Object> firstobjectdata = first_obj_list.getPopulatedFieldsAsMap();
            // Map<String, Object> secondobjectdata = list_second_obj.getPopulatedFieldsAsMap();


            // Schema.SObjectType objType = objectName[0];
            // Schema.DescribeSObjectResult describeResult = objType.getDescribe();
            String sobjectName = objectName[0];

            // Schema.SObjectType objType2 = objectName[1];
            // Schema.DescribeSObjectResult describeResult2 = objType2.getDescribe();
            String sobjectName2 = objectName[1];

            Type sobjectType = Type.forName(sobjectName);
            System.debug('Type ' + sobjectType);
            sObject newSObject = (sObject) sobjectType.newInstance();
            System.debug('sObject ' + newSObject);
            Type sobjectType2 = Type.forName(sobjectName2);
            sObject newSObject2 = (sObject) sobjectType2.newInstance();

            //For First Object
            for (String key : firstobjectdata.keySet()){
                Object value = firstobjectdata.get(key);
                Integer intValue = null;
                if (key != 'sobjectType'){
                    String fieldType = String.valueOf(Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap().get(key).getDescribe().getType());
                    if (fieldType == 'INTEGER'){
                        intValue = Integer.valueOf(value);
                    }
                    if (intValue != null){
                        newSObject.put(key, intValue);
                    } else{
                        newSObject.put(key, value);
                    }
                }
            }

            //For Second Object
            for (String key : secondobjectdata.keySet()){
                Object value = secondobjectdata.get(key);
                Integer intValue = null;
                if (key != 'sobjectType'){
                    String fieldType = String.valueOf(Schema.getGlobalDescribe().get(sobjectName2).getDescribe().fields.getMap().get(key).getDescribe().getType());
                    if (fieldType == 'INTEGER'){
                        intValue = Integer.valueOf(value);
                    }
                    if (fieldType == 'BASE64'){
                        value = EncodingUtil.base64Decode(base64att);
                    }
                    if (intValue != null){
                        newSObject2.put(key, intValue);
                    } else{
                        newSObject2.put(key, value);
                    }
                }
            }
            System.debug('newSboject '+newSObject);
            // Check if the current user has permission to create records for the dynamic sObject type
            insert newSObject;
            insertRecordList.add(newSObject.Id);

            if (create_chi){
                for (String lookup_api : lookup_list){
                    System.debug('lookup.   ' +lookup_api + ' , '+ newSObject.Id );
                    newSObject2.put(lookup_api, newSObject.Id);
                }
                if (sobjectName2 == 'Attachment'){
                    Object bas = base64att;
                    String myStr = String.valueOf(bas);
                    Blob myBlob = EncodingUtil.base64Decode(myStr);
                    newSObject2.put('ParentId', newSObject.Id);
                    newSObject2.put('Body', myBlob);
                    insert newSObject2;
                    insertRecordList.add(newSObject2.Id);
                } else{
                    insert newSObject2;
                    insertRecordList.add(newSObject2.Id);
                }
            } else{
                if (sobjectName2 == 'Attachment'){
                    newSObject2.put('ParentId', newSObject.Id);
                    insert newSObject2;
                    insertRecordList.add(newSObject2.Id);
                } else{
                    insert newSObject2;
                    insertRecordList.add(newSObject2.Id);
                }
            }

            SubId ids = new SubId();
            // ids.SubmissionId = subID;
            // ids.SignatureId = signatureid;
            // ids.Sig_upload_map = sigUploadMap;
            // ids.File_upload_map = file_upload_map;
            return ids;

        } catch (Exception e){
            System.debug('errror' +String.valueOf(e)+ ' : '+ e.getLineNumber());
            List<sobject> sobjlst = new List<sobject>();
            for (Id i : insertRecordList){
                sObject q = i.getSobjectType().newSobject(i);
                sobjlst.add(q);
            }
            delete sobjlst;
            return null;
        }
    }

     /** @description SubId class */
     public class SubId{
        /** @description SubmissionId - String */
        @AuraEnabled
        public String SubmissionId{ get; set; }

        /** @description SignatureId - String */
        @AuraEnabled
        public String SignatureId{ get; set; }

        /** @description Sig_upload_map - Map of String as Key and Object record as value */
        @AuraEnabled
        public Map<String, Object> Sig_upload_map{ get; set; }

        /** @description File_upload_map - Map of String as Key and Object record as value */
        @AuraEnabled
        public Map<String, Object> File_upload_map{ get; set; }

    }

    public static String signatureSave(String fieldId, String fieldData){
        /*This method is used store signature in ContentVersion*/
        try{

            Integer randomNumber = (Integer)Math.floor(Math.random() * 900000) + 100000;
            String s = fieldData.replaceFirst('data:image/png;base64,', '');
            ContentVersion conVer = new ContentVersion();
            conVer.title = 'Signature'+randomNumber+'.png';
            conVer.versionData = EncodingUtil.base64decode(s);
            conVer.PathOnClient = 'signatureImage.png';
            if (Schema.sObjectType.ContentVersion.fields.title.IsCreateable() && Schema.sObjectType.ContentVersion.fields.PathOnClient.IsCreateable()){
                insert conVer;
            }
            return conVer.Id;

        } catch (Exception e){
            System.debug('signature error' + String.valueOf(e));
            return null;
        }
    }

    public static String SaveFile(String fieldId, String fileName, String base64Data, String contentType){
        /*This method is used store upload files in ContentVersion*/
        try{
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            ContentVersion cv = new ContentVersion();
            cv.Title = fileName;
            cv.PathOnClient = fileName;
            cv.VersionData = EncodingUtil.base64Decode(base64Data);
            cv.IsMajorVersion = true;
            if (Schema.sObjectType.ContentVersion.fields.Title.IsCreateable() && Schema.sObjectType.ContentVersion.fields.PathOnClient.IsCreateable() && Schema.sObjectType.ContentVersion.fields.IsMajorVersion.IsCreateable()){
                insert cv;
            }
            return cv.Id;

        } catch (Exception e){
            return null;
        }
    }
  } 