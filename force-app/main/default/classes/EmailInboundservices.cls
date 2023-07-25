global class EmailInboundservices implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          try{
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

            String passeddata = email.plainTextBody;
            Map<String, Object> map1 = (Map<String,Object>)JSON.deserializeUntyped(passeddata);
            System.debug(map1);
            System.debug(map1.get('first_obj_list'));
            System.debug(map1.get('list_second_obj'));
            System.debug(map1.get('sig_upload_jsone'));
            System.debug(map1.get('sig_upload_fid_list'));
            System.debug(map1.get('file_upload_jsone'));
            System.debug(map1.get('file_upload_fid_list'));
            System.debug(map1.get('create_chi'));
            System.debug(map1.get('lookup_list'));
            System.debug(map1.get('base64att'));
            Map<String, Object> accmap = (Map<String, Object>)map1.get('acc'); 
            Map<String, Object> first_obj_listmap = (Map<String, Object>)map1.get('first_obj_list'); 
            Map<String, Object> list_second_objmap = (Map<String, Object>)map1.get('list_second_obj'); 
            String sig_upload_jsoneString = (String)map1.get('sig_upload_jsone'); 
            List<Object> sig_upload_fid_listmap = (List<Object>)map1.get('sig_upload_fid_list'); 
            String file_upload_jsoneString = (String)map1.get('file_upload_jsone'); 
            List<Object> file_upload_fid_listmap = (List<Object>)map1.get('file_upload_fid_list'); 
            Boolean create_chiboolean = (Boolean)map1.get('create_chi'); 
            String base64attmap = (String)map1.get('base64att'); 
            List<Object> lookup_listmap = (List<Object>)map1.get('lookup_list'); 
            List<Object> lookup_list2map = (List<Object>)map1.get('lookup_list2'); 
            Boolean create_chi_2boolean = (Boolean)map1.get('create_chi_2'); 

            System.debug(accmap);
            System.debug(first_obj_listmap);
            System.debug(list_second_objmap);
            System.debug(sig_upload_jsoneString);
            System.debug(sig_upload_fid_listmap);
            System.debug(file_upload_jsoneString);
            System.debug(file_upload_fid_listmap);
            System.debug(create_chiboolean);
            System.debug(lookup_listmap);
            System.debug(base64attmap);

            String acc1 = (String)accmap.get('First_object_data__c');
            Map<String, Object> object1 = (Map<String, Object>)JSON.deserializeUntyped(acc1);

            String acc2 = (String)accmap.get('Second_object_data__c');
            Map<String, Object> object2 = (Map<String, Object>)JSON.deserializeUntyped(acc2);

            String acc3 = (String)accmap.get('Third_object_data__c');
            Map<String, Object> object3 = (Map<String, Object>)JSON.deserializeUntyped(acc3);

            System.debug(object1);
            System.debug(object2);
            System.debug(object3);
           
            // createrecord_for_secod_object( object1,object2, sig_upload_jsoneString, sig_upload_fid_listmap, file_upload_jsoneString , file_upload_fid_listmap,  create_chiboolean, lookup_listmap, base64attmap);
            
            createrecord_for_third_object(object1, object2, object3, sig_upload_jsoneString, sig_upload_fid_listmap, file_upload_jsoneString, file_upload_fid_listmap, create_chiboolean, lookup_listmap, create_chi_2boolean, lookup_list2map, base64attmap);
            // // formid = email.plainTextBody.split(',')[0];
            // // submissionid = email.plainTextBody.split(',')[1];
            // Notification__c notify = new Notification__c();
            // // OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress Limit 1];
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
            return result;
        } catch(Exception e){
            System.debug('errror' +String.valueOf(e)+ ' : '+ e.getLineNumber());
            return null;
        }
        }

        public static List<Id> insertRecordList = new List<Id>();

        @AuraEnabled
        public static SubId createrecord(Map<String, Object> first_obj_list, List<String> objectName){
            try{       
            String sobjectName = objectName[0];
            System.debug(sobjectName);
            Type sobjectType = Type.forName(sobjectName);
            System.debug(sobjectType);
            sObject newSObject = (sObject) sobjectType.newInstance();
            System.debug('newSObject ==>'+newSObject);

            System.debug(first_obj_list);
            for (String key : first_obj_list.keySet()){
                System.debug(key);
                Object value = first_obj_list.get(key);
                System.debug(value);
                Integer intValue = null;
                Decimal decValue = null;
                Date datValue = null;
                DateTime dattimValue = null;
                Time timValue = null;
                Boolean bolValue = null;
                if (key != 'sobjectType'){
                    String fieldType = String.valueOf(Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap().get(key).getDescribe().getType());
                    if (fieldType == 'INTEGER'){
                        intValue = Integer.valueOf(value);
                    } else if(fieldType == 'PERCENT' || fieldType == 'CURRENCY' || fieldType == 'DOUBLE'){
                        decValue = Decimal.valueOf(String.valueOf(value));
                    } else if (fieldType == 'DATE'){
                        datValue= Date.valueOf(String.valueOf(value));
                    } else if(fieldType == 'DATETIME'){
                        String dt = String.valueOf(value);
                        List<String> datetimes = dt.split('T');
                        List<String> dates = (datetimes[0].split('-'));
                        List<Integer> intdate = new List<Integer>();
                        for(String datee : dates){
                            intdate.add(Integer.valueOf(datee));
                        }
                        List<String> times = datetimes[1].split(':');
                        Integer hours = Integer.valueOf(times[0]);
                        Integer minutes = Integer.valueOf(times[1]);
                        dattimValue = Datetime.newInstance(intdate[0], intdate[1], intdate[2],hours,minutes,0);

                    } else if(fieldType == 'TIME'){
                        String startTime = String.valueOf(value);
                        Integer hour = Integer.valueOf(startTime.left(2)); //first 2 characters are hour
                        Integer minute = Integer.valueOf(startTime.substringBetween(':',':')); // between both : in String
                        timValue = Time.newInstance(hour, minute, 0, 0);
                    } else if (fieldType == 'BOOLEAN') {
                        if (value == 'True') {
                            bolValue = true;
                        } else {
                            bolValue = false;
                        }
                    }
                    if (intValue != null){
                        newSObject.put(key, intValue);
                    } else if(decValue != null){
                        newSObject.put(key, decValue);
                    } else if(datValue != null){
                        newSObject.put(key, datValue);
                    } else if(dattimValue != null){
                        newSObject.put(key, dattimValue);
                    } else if(timValue != null){
                        newSObject.put(key, timValue);
                    } else if (bolValue != null) {
                        newSObject.put(key, bolValue);
                    } else{
                        newSObject.put(key, value);
                    }
                }
            }          
            insert newSObject;
            System.debug(newSObject.Id);
            insertRecordList.add(newSObject.Id);
            return null;
            } catch (Exception e){
                System.debug(e.getLineNumber()+ ' '+e);
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
  
    //    /**
    //  * @description createrecord_for_secod_object Method
    //  * @param acc Form_Submission__c record
    //  * @param first_obj_list SObject record
    //  * @param list_second_obj SObject record
    //  * @param sig_upload_jsone String Value
    //  * @param sig_upload_fid_list List of String
    //  * @param file_upload_jsone String Value
    //  * @param file_upload_fid_list List of String
    //  * @param create_chi Boolean Value
    //  * @param lookup_list List of String
    //  * @param base64att base64 String
    //  * @return SubId record
    //  */
    public static void createrecord_for_secod_object( Map<String, Object> first_obj_list, Map<String, Object> list_second_obj, String sig_upload_jsone, List<Object> sig_upload_fid_list, String file_upload_jsone, List<Object> file_upload_fid_list, Boolean create_chi, List<Object> lookup_list, String base64att){
        try{

            String sobjectName = (String)first_obj_list.get('sobjectType');
            String sobjectName2 = (String)list_second_obj.get('sobjectType');
            Type sobjectType = Type.forName(sobjectName);
            sObject newSObject = (sObject) sobjectType.newInstance();
            Type sobjectType2 = Type.forName(sobjectName2);
            sObject newSObject2 = (sObject) sobjectType2.newInstance();

            
            //For First Object
            for (String key : first_obj_list.keySet()){
                Object value = first_obj_list.get(key);
                System.debug(key + ' : ' +value);
                Integer intValue = null;
                Decimal decValue = null;
                Date datValue = null;
                DateTime dattimValue = null;
                Time timValue = null;
                Boolean bolValue = null;
                if (key != 'sobjectType'){
                    String fieldType = String.valueOf(Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap().get(key).getDescribe().getType());
                    if (fieldType == 'INTEGER'){
                        intValue = Integer.valueOf(value);
                    } else if(fieldType == 'PERCENT' || fieldType == 'CURRENCY' || fieldType == 'DOUBLE'){
                        decValue = Decimal.valueOf(String.valueOf(value));
                    } else if (fieldType == 'DATE'){
                        datValue= Date.valueOf(String.valueOf(value));
                    } else if(fieldType == 'DATETIME'){
                        String dt = String.valueOf(value);
                        List<String> datetimes = dt.split('T');
                        List<String> dates = (datetimes[0].split('-'));
                        List<Integer> intdate = new List<Integer>();
                        for(String datee : dates){
                            intdate.add(Integer.valueOf(datee));
                        }
                        List<String> times = datetimes[1].split(':');
                        Integer hours = Integer.valueOf(times[0]);
                        Integer minutes = Integer.valueOf(times[1]);
                        dattimValue = Datetime.newInstance(intdate[0], intdate[1], intdate[2],hours,minutes,0);

                    } else if(fieldType == 'TIME'){
                        String startTime = String.valueOf(value);
                        Integer hour = Integer.valueOf(startTime.left(2)); //first 2 characters are hour
                        Integer minute = Integer.valueOf(startTime.substringBetween(':',':')); // between both : in String
                        timValue = Time.newInstance(hour, minute, 0, 0);
                    } else if (fieldType == 'BOOLEAN') {
                        if (value == 'True') {
                            bolValue = true;
                        } else {
                            bolValue = false;
                        }
                    }
                    if (intValue != null){
                        newSObject.put(key, intValue);
                    } else if(decValue != null){
                        newSObject.put(key, decValue);
                    } else if(datValue != null){
                        newSObject.put(key, datValue);
                    } else if(dattimValue != null){
                        newSObject.put(key, dattimValue);
                    } else if(timValue != null){
                        newSObject.put(key, timValue);
                    } else if (bolValue != null) {
                        newSObject.put(key, bolValue);
                    } else{
                        newSObject.put(key, value);
                    }
                }
            }

            //For Second Object
            for (String key : list_second_obj.keySet()){
                Object value = list_second_obj.get(key);
                System.debug(key + ' : ' +value);
                Integer intValue = null;
                Decimal decValue = null;
                Date datValue = null;
                DateTime dattimValue = null;
                Time timValue = null;
                Boolean bolValue = null;
                if (key != 'sobjectType'){
                    String fieldType = String.valueOf(Schema.getGlobalDescribe().get(sobjectName2).getDescribe().fields.getMap().get(key).getDescribe().getType());
                    if (fieldType == 'INTEGER'){
                        intValue = Integer.valueOf(value);
                    } else if(fieldType == 'PERCENT' || fieldType == 'CURRENCY' || fieldType == 'DOUBLE'){
                        decValue = Decimal.valueOf(String.valueOf(value));
                    } else if (fieldType == 'DATE'){
                        datValue= Date.valueOf(String.valueOf(value));
                    } else if(fieldType == 'DATETIME'){
                        String dt = String.valueOf(value);
                        List<String> datetimes = dt.split('T');
                        List<String> dates = (datetimes[0].split('-'));
                        List<Integer> intdate = new List<Integer>();
                        for(String datee : dates){
                            intdate.add(Integer.valueOf(datee));
                        }
                        List<String> times = datetimes[1].split(':');
                        Integer hours = Integer.valueOf(times[0]);
                        Integer minutes = Integer.valueOf(times[1]);
                        dattimValue = Datetime.newInstance(intdate[0], intdate[1], intdate[2],hours,minutes,0);

                    } else if(fieldType == 'TIME'){
                        String startTime = String.valueOf(value);
                        Integer hour = Integer.valueOf(startTime.left(2)); //first 2 characters are hour
                        Integer minute = Integer.valueOf(startTime.substringBetween(':',':')); // between both : in String
                        timValue = Time.newInstance(hour, minute, 0, 0);
                    } else if (fieldType == 'BASE64'){
                        value = EncodingUtil.base64Decode(base64att);
                    } else if (fieldType == 'BOOLEAN') {
                        if (value == 'True') {
                            bolValue = true;
                        } else {
                            bolValue = false;
                        }
                    }
                    if (intValue != null){
                        newSObject2.put(key, intValue);
                    } else if(decValue != null){
                        newSObject2.put(key, decValue);
                    } else if(datValue != null){
                        newSObject2.put(key, datValue);
                    } else if(dattimValue != null){
                        newSObject2.put(key, dattimValue);
                    } else if(timValue != null){
                        newSObject2.put(key, timValue);
                    } else if (bolValue != null) {
                        newSObject2.put(key, bolValue);
                    } else{
                        newSObject2.put(key, value);
                    }
                }
            }
            
            // Check if the current user has permission to create records for the dynamic sObject type
            insert newSObject;
            insertRecordList.add(newSObject.Id);

            if (create_chi){
                System.debug(lookup_list);
                for (Object lookup_api : lookup_list){
                    System.debug(lookup_api);
                    System.debug(newSObject.Id);
                    newSObject2.put((String)lookup_api, newSObject.Id);
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
            // SubId ids = new SubId();
            // ids.SubmissionId = subID;
            // ids.SignatureId = signatureid;
            // ids.Sig_upload_map = sigUploadMap;
            // ids.File_upload_map = file_upload_map;
            // return ids;

        } catch (Exception e){
            System.debug('errror' +String.valueOf(e) + ' '+ e.getLineNumber());
            List<sobject> sobjlst = new List<sobject>();
            for (Id i : insertRecordList){
                sObject q = i.getSobjectType().newSobject(i);
                sobjlst.add(q);
            }
            delete sobjlst;
            // return null;
        }
    }

        /**
     * @description createrecord_for_third_object Method
     * @param acc Form_Submission__c record
     * @param first_obj_list SObject record
     * @param list_second_obj SObject record
     * @param list_third_obj SObject record
     * @param sig_upload_jsone String Value
     * @param sig_upload_fid_list List of String
     * @param file_upload_jsone String Value
     * @param file_upload_fid_list List of String
     * @param create_chi Boolean Value
     * @param lookup_list List of String
     * @param create_chi_2 Boolean Value
     * @param lookup_list2 List of String
     * @param base64att String value
     * @return SubId record
     * @return base64att String
     */


    public static void createrecord_for_third_object(Map<String,Object> first_obj_list,  Map<String,Object> list_second_obj,  Map<String,Object> list_third_obj, String sig_upload_jsone, List<Object> sig_upload_fid_list, String file_upload_jsone, List<Object> file_upload_fid_list, Boolean create_chi, List<Object> lookup_list, Boolean create_chi_2, List<Object> lookup_list2, String base64att){
        try{

            String sobjectName = (String)first_obj_list.get('sobjectType');
            String sobjectName2 = (String)list_second_obj.get('sobjectType');
            String sobjectName3 = (String)list_third_obj.get('sobjectType');
            Type sobjectType = Type.forName(sobjectName);
            sObject newSObject = (sObject) sobjectType.newInstance();
            Type sobjectType2 = Type.forName(sobjectName2);
            sObject newSObject2 = (sObject) sobjectType2.newInstance();
            Type sobjectType3 = Type.forName(sobjectName3);
            sObject newSObject3 = (sObject) sobjectType3.newInstance();
            
            //For First Object
            for (String key : first_obj_list.keySet()){
                Object value = first_obj_list.get(key);
                Integer intValue = null;
                Decimal decValue = null;
                Date datValue = null;
                DateTime dattimValue = null;
                Time timValue = null;
                Boolean bolValue = null;
                if (key != 'sobjectType'){
                    String fieldType = String.valueOf(Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap().get(key).getDescribe().getType());
                    if (fieldType == 'INTEGER'){
                        intValue = Integer.valueOf(value);
                    } else if(fieldType == 'PERCENT' || fieldType == 'CURRENCY' || fieldType == 'DOUBLE'){
                        decValue = Decimal.valueOf(String.valueOf(value));
                    } else if (fieldType == 'DATE'){
                        datValue= Date.valueOf(String.valueOf(value));
                    } else if(fieldType == 'DATETIME'){
                        String dt = String.valueOf(value);
                        List<String> datetimes = dt.split('T');
                        List<String> dates = (datetimes[0].split('-'));
                        List<Integer> intdate = new List<Integer>();
                        for(String datee : dates){
                            intdate.add(Integer.valueOf(datee));
                        }
                        List<String> times = datetimes[1].split(':');
                        Integer hours = Integer.valueOf(times[0]);
                        Integer minutes = Integer.valueOf(times[1]);
                        dattimValue = Datetime.newInstance(intdate[0], intdate[1], intdate[2],hours,minutes,0);

                    } else if(fieldType == 'TIME'){
                        String startTime = String.valueOf(value);
                        Integer hour = Integer.valueOf(startTime.left(2)); //first 2 characters are hour
                        Integer minute = Integer.valueOf(startTime.substringBetween(':',':')); // between both : in String
                        timValue = Time.newInstance(hour, minute, 0, 0);
                    } else if (fieldType == 'BASE64'){
                        value = EncodingUtil.base64Decode(base64att);
                    } else if (fieldType == 'BOOLEAN') {
                        if (value == 'True') {
                            bolValue = true;
                        } else {
                            bolValue = false;
                        }
                    }

                    if (intValue != null){
                        newSObject.put(key, intValue);
                    } else if(decValue != null){
                        newSObject.put(key, decValue);
                    } else if(datValue != null){
                        newSObject.put(key, datValue);
                    } else if(dattimValue != null){
                        newSObject.put(key, dattimValue);
                    } else if(timValue != null){
                        newSObject.put(key, timValue);
                    } else if (bolValue != null) {
                        newSObject.put(key, bolValue);
                    } else{
                        newSObject.put(key, value);
                    }
                }
            }

            //For Second Object
            for (String key : list_second_obj.keySet()){
                Object value = list_second_obj.get(key);
                Integer intValue = null;
                Decimal decValue = null;
                Date datValue = null;
                DateTime dattimValue = null;
                Time timValue = null;
                Boolean bolValue = null;
                if (key != 'sobjectType'){
                    String fieldType = String.valueOf(Schema.getGlobalDescribe().get(sobjectName2).getDescribe().fields.getMap().get(key).getDescribe().getType());
                    if (fieldType == 'INTEGER'){
                        intValue = Integer.valueOf(value);
                    } else if(fieldType == 'PERCENT' || fieldType == 'CURRENCY' || fieldType == 'DOUBLE'){
                        decValue = Decimal.valueOf(String.valueOf(value));
                    } else if (fieldType == 'DATE'){
                        datValue= Date.valueOf(String.valueOf(value));
                    } else if(fieldType == 'DATETIME'){
                        String dt = String.valueOf(value);
                        List<String> datetimes = dt.split('T');
                        List<String> dates = (datetimes[0].split('-'));
                        List<Integer> intdate = new List<Integer>();
                        for(String datee : dates){
                            intdate.add(Integer.valueOf(datee));
                        }
                        List<String> times = datetimes[1].split(':');
                        Integer hours = Integer.valueOf(times[0]);
                        Integer minutes = Integer.valueOf(times[1]);
                        dattimValue = Datetime.newInstance(intdate[0], intdate[1], intdate[2],hours,minutes,0);

                    } else if(fieldType == 'TIME'){
                        String startTime = String.valueOf(value);
                        Integer hour = Integer.valueOf(startTime.left(2)); //first 2 characters are hour
                        Integer minute = Integer.valueOf(startTime.substringBetween(':',':')); // between both : in String
                        timValue = Time.newInstance(hour, minute, 0, 0);
                    } else if (fieldType == 'BASE64'){
                        value = EncodingUtil.base64Decode(base64att);
                    }  else if (fieldType == 'BOOLEAN') {
                        if (value == 'True') {
                            bolValue = true;
                        } else {
                            bolValue = false;
                        }
                    }

                    if (intValue != null){
                        newSObject2.put(key, intValue);
                    } else if(decValue != null){
                        newSObject2.put(key, decValue);
                    } else if(datValue != null){
                        newSObject2.put(key, datValue);
                    } else if(dattimValue != null){
                        newSObject2.put(key, dattimValue);
                    } else if(timValue != null){
                        newSObject2.put(key, timValue);
                    } else if (bolValue != null) {
                        newSObject2.put(key, bolValue);
                    } else{
                        newSObject2.put(key, value);
                    }
                }
            }

            //For third Object
            for (String key : list_third_obj.keySet()){
                Object value = list_third_obj.get(key);
                Integer intValue = null;
                Decimal decValue = null;
                Date datValue = null;
                DateTime dattimValue = null;
                Time timValue = null;
                Boolean bolValue = null;
                if (key != 'sobjectType'){
                    String fieldType = String.valueOf(Schema.getGlobalDescribe().get(sobjectName3).getDescribe().fields.getMap().get(key).getDescribe().getType());
                    if (fieldType == 'INTEGER'){
                        intValue = Integer.valueOf(value);
                    } else if(fieldType == 'PERCENT' || fieldType == 'CURRENCY' || fieldType == 'DOUBLE'){
                        decValue = Decimal.valueOf(String.valueOf(value));
                    } else if (fieldType == 'DATE'){
                        datValue= Date.valueOf(String.valueOf(value));
                    } else if(fieldType == 'DATETIME'){
                        String dt = String.valueOf(value);
                        List<String> datetimes = dt.split('T');
                        List<String> dates = (datetimes[0].split('-'));
                        List<Integer> intdate = new List<Integer>();
                        for(String datee : dates){
                            intdate.add(Integer.valueOf(datee));
                        }
                        List<String> times = datetimes[1].split(':');
                        Integer hours = Integer.valueOf(times[0]);
                        Integer minutes = Integer.valueOf(times[1]);
                        dattimValue = Datetime.newInstance(intdate[0], intdate[1], intdate[2],hours,minutes,0);

                    } else if(fieldType == 'TIME'){
                        String startTime = String.valueOf(value);
                        Integer hour = Integer.valueOf(startTime.left(2)); //first 2 characters are hour
                        Integer minute = Integer.valueOf(startTime.substringBetween(':',':')); // between both : in String
                        timValue = Time.newInstance(hour, minute, 0, 0);
                    } else if (fieldType == 'BASE64'){
                        value = EncodingUtil.base64Decode(base64att);
                    }  else if (fieldType == 'BOOLEAN') {
                        if (value == 'True') {
                            bolValue = true;
                        } else {
                            bolValue = false;
                        }
                    }

                    if (intValue != null){
                        newSObject3.put(key, intValue);
                    } else if(decValue != null){
                        newSObject3.put(key, decValue);
                    } else if(datValue != null){
                        newSObject3.put(key, datValue);
                    } else if(dattimValue != null){
                        newSObject3.put(key, dattimValue);
                    } else if(timValue != null){
                        newSObject3.put(key, timValue);
                    } else if (bolValue != null) {
                        newSObject3.put(key, bolValue);
                    } else{
                        newSObject3.put(key, value);
                    }
                }
            }
            insert newSObject;
            insertRecordList.add(newSObject.Id);

            if (create_chi){
                for (Object lookup_api : lookup_list){
                    newSObject2.put((String)lookup_api, newSObject.Id);
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
                for (Object lookup_api_2 : lookup_list2){
                    newSObject3.put((String)lookup_api_2, newSObject.Id);
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
        } catch (Exception e){
            System.debug('Exception--->' + e.getMessage() + ' -->>' + e.getLineNumber());
            List<sobject> sobjlst = new List<sobject>();
            for (Id i : insertRecordList){
                sObject q = i.getSobjectType().newSobject(i);
                sobjlst.add(q);
            }
            delete sobjlst;
            // return null;
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