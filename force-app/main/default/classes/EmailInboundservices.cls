global class EmailInboundservices implements Messaging.InboundEmailHandler {
	  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          try{
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            List<String> objectName = new List<String>();
            Map<String, Object> mapoffirstobject = new Map<String, Object>();
            Map<String, Object> mapofsecondobject = new Map<String, Object>();
            Map<String, Object> mapofthirdobject = new Map<String, Object>();
            Integer howmanyobjects = 0;
            Boolean create_chi;
            Boolean create_chi_2;
            String key = '';
            String value = '';

            List<String> firstobjectdata = email.plainTextBody.split('<MVQFSeperator>')[0].split(',');
            List<String> secondobjectdata = email.plainTextBody.split('<MVQFSeperator>')[1].split(',');
            List<String> thirdobjectdata = email.plainTextBody.split('<MVQFSeperator>')[2].split(',');
            List<String> lookup_list = email.plainTextBody.split('<MVQFSeperator>')[4].split(','); 
            String base64att = email.plainTextBody.split('<MVQFSeperator>')[5];
            List<String> lookup_list2 = email.plainTextBody.split('<MVQFSeperator>')[6].split(',');
            String submissionid = email.plainTextBody.split('<MVQFSeperator>')[8];
            String formid = email.plainTextBody.split('<MVQFSeperator>')[9];


            System.debug(firstobjectdata);
            System.debug(secondobjectdata);
            System.debug(thirdobjectdata);
            System.debug(lookup_list);
            System.debug(base64att);
            System.debug(lookup_list2);


            System.debug(firstobjectdata.size());
            System.debug(secondobjectdata.size());
            System.debug(thirdobjectdata.size());
            System.debug(lookup_list.size());
            System.debug(lookup_list2.size());
         

            if (firstobjectdata.size() > 1) {
                howmanyobjects = 1;
                for (String firstobject : firstobjectdata) {
                    System.debug(firstobject);
                    key = firstobject.split(':')[0];
                    value = firstobject.split(':')[1];

                    System.debug(key);
                    System.debug(value);

                    if (String.valueOf(key) == '"sobjectType"') {
                        System.debug(key);
                        objectName.add(value);
                    } else {
                        System.debug(key + ' : ' +value);
                        mapoffirstobject.put(key, value);
                    }
                }
            }

            if (secondobjectdata.size() > 1) {
                howmanyobjects = 2;
                for (String secondobject : secondobjectdata) {
                    key = secondobject.split(':')[0];
                    value = secondobject.split(':')[1];
                    if (String.valueOf(key) == '"sobjectType"') {
                        System.debug(value);
                        objectName.add(value);
                    } else {
                        System.debug(key + ' : ' +value);
                        mapofsecondobject.put(key, value);
                    }
                }
            }
            
            if (thirdobjectdata.size() > 1) {
                howmanyobjects = 3;
                for (String thirdobject : thirdobjectdata) {
                    key = thirdobject.split(':')[0];
                    value = thirdobject.split(':')[1];
                    if (String.valueOf(key) == '"sobjectType"') {
                        System.debug(value);
                        objectName.add(value);
                    } else {
                        System.debug(key + ' : ' +value);
                        mapofthirdobject.put(key, value);
                    }
                }
            }

            if (email.plainTextBody.split('<MVQFSeperator>')[3] == 'true') {
                create_chi = true;
            } else if(email.plainTextBody.split('<MVQFSeperator>')[3] == 'false'){
                create_chi = false;
            }
            System.debug(create_chi);
            if (email.plainTextBody.split('<MVQFSeperator>')[7] == 'true') {
                create_chi_2 = true;
            } else if(email.plainTextBody.split('<MVQFSeperator>')[7] == 'false'){
                create_chi_2 = false;
            }
            System.debug(create_chi_2);

            System.debug(howmanyobjects);
            if (howmanyobjects == 1) {
                createrecord(mapoffirstobject, objectName);
            } else if(howmanyobjects == 2){
                System.debug(mapoffirstobject);
                System.debug(mapoffirstobject.size());
                System.debug(mapofsecondobject);
                System.debug(mapofsecondobject.size());
                createrecord_for_secod_object(objectName, mapoffirstobject, mapofsecondobject, create_chi, lookup_list, base64att);
            } else if (howmanyobjects == 3) {
                createrecord_for_third_object(mapoffirstobject, mapofsecondobject, mapofthirdobject, objectName, create_chi, lookup_list, create_chi_2, lookup_list2, base64att);
            }



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
            //                 Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ emailNotification });
            //             }
            //     }
            // }
          return null;
        } catch(Exception e){
            System.debug('errror' +String.valueOf(e)+ ' : '+ e.getLineNumber());
            return null;
        }
      }

      public static List<Id> insertRecordList = new List<Id>();

      @AuraEnabled
      public static SubId createrecord(Map<String, Object> firstobjectdata, List<String> objectName){
          try{       
            String sobjectName = objectName[0];

            Type sobjectType = Type.forName(sobjectName);
            sObject newSObject = (sObject) sobjectType.newInstance();

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
            insert newSObject;
            insertRecordList.add(newSObject.Id);
            return null;
          } catch (Exception e){
              List<sobject> sobjlst = new List<sobject>();
              System.debug('sobjlst ==>'+sobjlst);
              for (Id i : insertRecordList){
                  sObject q = i.getSobjectType().newSobject(i);
                  System.debug('q ==>'+q);
                  sobjlst.add(q);
              }
              delete sobjlst;
              return null;
          }
      }
      public static SubId createrecord_for_secod_object(List<String> objectName, Map<String, Object> firstobjectdata,Map<String, Object> secondobjectdata, Boolean create_chi, List<String> lookup_list, String base64att ){
        try{

            String sobjectName = objectName[0];
            String sobjectName2 = objectName[1];

            Type sobjectType = Type.forName(sobjectName);
            sObject newSObject = (sObject) sobjectType.newInstance();
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
            // Check if the current user has permission to create records for the dynamic sObject type
            insert newSObject;
            insertRecordList.add(newSObject.Id);

            if (create_chi){
                for (String lookup_api : lookup_list){
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
            return null;

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

    public static SubId createrecord_for_third_object(Map<String, Object> firstobjectdata, Map<String, Object> secondobjectdata, Map<String, Object> thirdobjectdata, List<String> objectName, Boolean create_chi, List<String> lookup_list, Boolean create_chi_2, List<String> lookup_list2, String base64att){
        try{


           
            String sobjectName = objectName[0];
            String sobjectName2 = objectName[1];
            String sobjectName3 = objectName[2];
            Type sobjectType = Type.forName(sobjectName);
            sObject newSObject = (sObject) sobjectType.newInstance();
            Type sobjectType2 = Type.forName(sobjectName2);
            sObject newSObject2 = (sObject) sobjectType2.newInstance();
            Type sobjectType3 = Type.forName(sobjectName3);
            sObject newSObject3 = (sObject) sobjectType3.newInstance();

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

            //For third Object
            for (String key : thirdobjectdata.keySet()){
                Object value = thirdobjectdata.get(key);
                Integer intValue = null;
                if (key != 'sobjectType'){
                    String fieldType = String.valueOf(Schema.getGlobalDescribe().get(sobjectName3).getDescribe().fields.getMap().get(key).getDescribe().getType());
                    if (fieldType == 'INTEGER'){
                        intValue = Integer.valueOf(value);
                    }
                    if (fieldType == 'BASE64'){
                        value = EncodingUtil.base64Decode(base64att);
                    }
                    if (intValue != null){
                        newSObject3.put(key, intValue);
                    } else{
                        newSObject3.put(key, value);
                    }
                }
            }
            insert newSObject;
            insertRecordList.add(newSObject.Id);

            if (create_chi){
                for (String lookup_api : lookup_list){
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
            if (create_chi_2){
                for (String lookup_api_2 : lookup_list2){
                    newSObject3.put(lookup_api_2, newSObject.Id);
                }
                if (sobjectName3 == 'Attachment'){
                    Object bas = base64att;
                    String myStr = String.valueOf(bas);
                    Blob myBlob = EncodingUtil.base64Decode(myStr);
                    newSObject3.put('ParentId', newSObject.Id);
                    newSObject3.put('Body', myBlob);
                    insert newSObject3;
                    insertRecordList.add(newSObject3.Id);
                } else{
                    insert newSObject3;
                    insertRecordList.add(newSObject3.Id);
                }
            } else{

                if (sobjectName3 == 'Attachment'){
                    Object bas = base64att;
                    String myStr = String.valueOf(bas);
                    Blob myBlob = EncodingUtil.base64Decode(myStr);
                    newSObject3.put('ParentId', newSObject.Id);
                    newSObject3.put('Body', myBlob);
                    insert newSObject3;
                    insertRecordList.add(newSObject3.Id);
                } else{
                    insert newSObject3;
                    insertRecordList.add(newSObject3.Id);
                }
            }
            SubId ids = new SubId();
            return null;
        } catch (Exception e){
            System.debug('Exception--->' + e.getMessage() + ' -->>' + e.getLineNumber());
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
   
  } 