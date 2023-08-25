/**
 * @description EmailInboundservices Class
 */
global with sharing class EmailInboundservices implements Messaging.InboundEmailHandler {

    /** @description insertRecordList variable */
    public static List<Id> insertRecordList = new List<Id>();
     /** @description formId variable */
    public static string formId;

     /**
     * @description getFields Method
     * @param email String Value
     * @param envelope String Value
     * @return Messaging.InboundEmailResult
     */
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        try{
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
            String passeddata = email.plainTextBody;
            Map<String, Object> map1 = (Map<String,Object>)JSON.deserializeUntyped(passeddata);
            Map<String, Object> accmap = (Map<String, Object>)map1.get('acc'); 
            String sigUploadJsoneString = (String)map1.get('sig_upload_jsone'); 
            List<Object> sigUploadFidListmap = (List<Object>)map1.get('sig_upload_fid_list'); 
            String fileuploadjsoneString = (String)map1.get('file_upload_jsone'); 
            List<Object> fileUploadFidListmap = (List<Object>)map1.get('file_upload_fid_list'); 
            Boolean createChiboolean = (Boolean)map1.get('create_chi'); 
            String base64attmap = (String)map1.get('base64att'); 
            List<Object> lookupListmap = (List<Object>)map1.get('lookup_list'); 
            List<Object> lookupList2map = (List<Object>)map1.get('lookup_list2'); 
            Boolean createChi2boolean = (Boolean)map1.get('create_chi_2'); 
            Integer objectCount = (Integer)map1.get('ObjectCount');
            String acc1 = (String)accmap.get('First_object_data__c');
            Map<String, Object> object1 = (Map<String, Object>)JSON.deserializeUntyped(acc1);
            String acc2 = (String)accmap.get('Second_object_data__c');
            Map<String, Object> object2 = (Map<String, Object>)JSON.deserializeUntyped(acc2);
            String acc3 = (String)accmap.get('Third_object_data__c');
            Map<String, Object> object3 = (Map<String, Object>)JSON.deserializeUntyped(acc3);
            insertRecordList.add((Id)map1.get('SubId'));
            Id submissionid = (Id) map1.get('SubId');
            formId = (String)accmap.get('Form__c');

            String success;
            if (objectCount == 1) {
                success = Createrecord(object1, sigUploadJsoneString, sigUploadFidListmap, fileuploadjsoneString, fileUploadFidListmap);
            } else if (objectCount == 2) {
             success =  Createrecord_for_secod_object( object1,object2, sigUploadJsoneString, sigUploadFidListmap, fileuploadjsoneString , fileUploadFidListmap,  createChiboolean, lookupListmap, base64attmap);
           } else if (objectCount == 3){
               success = Createrecord_for_third_object(object1, object2, object3, sigUploadJsoneString, sigUploadFidListmap, fileuploadjsoneString, fileUploadFidListmap, createChiboolean, lookupListmap, createChi2boolean, lookupList2map, base64attmap);
           }
            
           if (success == 'success') {
                Id formid = (Id)accmap.get('Form__c');
                 
                    if ([SELECT Count() FROM Notification__c WHERE Form__c =: formid WITH SECURITY_ENFORCED] > 0) {  
                        Notification__c notify = new Notification__c();
                        notify = [SELECT Id,Form__r.Name, To_Recipients__c, CC_Recipients__c, BCC_Recipients__c, Subject__c, Email_Body__c, Attachment__c, Status__c
                                FROM Notification__c
                                WHERE Form__c = :formid WITH SECURITY_ENFORCED];
                        if (notify.Status__c == true){
                            if (notify != null || notify.Id != null){
                                String recipientList = notify.To_Recipients__c;
                                String ccmaillist = notify.CC_Recipients__c;
                                String bccmaillist = notify.BCC_Recipients__c;
                                String messageBody = notify.Email_Body__c;
                                String messageSubject = notify.Subject__c;
                                boolean attachmentpdf = notify.Attachment__c;
                                List<String> ccAddresses = new List<String>();
                                List<String> bccAddresses = new List<String>();
                                List<String> toAddresses = recipientList.split(',');
                                if (String.isNotBlank(ccmaillist)){
                                    ccAddresses = ccmaillist.split(',');
                                }
                                if (String.isNotBlank(bccmaillist)){
                                    bccAddresses = bccmaillist.split(',');
                                }
                                if (toAddresses.size() != 0){
                                    Messaging.SingleEmailMessage emailNotification = new Messaging.SingleEmailMessage();
                                    emailNotification.setToAddresses(toAddresses);
                                    if (ccAddresses.size() > 0){
                                        emailNotification.setCCaddresses(ccAddresses);
                                    }
                                    if (bccAddresses.size() > 0){
                                        emailNotification.setBCCaddresses(bccAddresses);
                                    }
                                    emailNotification.setSubject(messageSubject);
                                    emailNotification.setHtmlBody(messageBody);
                                    if (attachmentpdf == true){
                                        String pdfUrl = '/apex/PDFGenerator?Id=' + submissionid;
                                        PageReference pdfPage = new PageReference(pdfUrl);
                                        Blob pdfContent;
                                        if (Test.isRunningTest()){
                                            pdfContent = blob.valueOf('Unit.Test');
                                        } else{
                                            pdfContent = pdfPage.getContentAsPDF();
                                        }
                                        Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
                                        String pdfName = '';
                                        if(String.isNotBlank(notify.Form__r.Name)){
                                            pdfName = notify.Form__r.Name +'_' +DateTime.now();
                                        }
                                        emailAttachment.setFileName(pdfName+'.pdf');
                                        emailAttachment.setBody(pdfContent);
                                        emailNotification.setFileAttachments(new Messaging.EmailFileAttachment[]{ emailAttachment });
                                    }
                                    Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ emailNotification });
                                }
                            }
                        }
                    }
                    return result;
                }  
            return null;
        } catch(Exception e){
            System.debug('errror' +String.valueOf(e)+ ' : '+ e.getLineNumber());
            return null;
        }
    }

      /**
     * @description Createrecord Method
     * @param firstObjList Map<String, Object> record
     * @param sigUploadJsone String Value
     * @param sigUploadFidList List of Object
     * @param fileuploadjsone String Value
     * @param fileUploadFidList List of Object
     * @return String 'success' record
     */
    public static String Createrecord( Map<String, Object> firstObjList, String sigUploadJsone, List<Object> sigUploadFidList, String fileuploadjsone, List<Object> fileUploadFidList){
        try{

            String sobjectName = (String)firstObjList.get('sobjectType');
            Type sobjectType = Type.forName(sobjectName);
            sObject newSObject = (sObject) sobjectType.newInstance();

            for (String key : firstObjList.keySet()){
                Object value = firstObjList.get(key);
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
                    }else if(fieldType == 'PERCENT' || fieldType == 'CURRENCY' || fieldType == 'DOUBLE'){
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
            insert as User newSObject;
            insertRecordList.add(newSObject.Id);

            return 'success';

        } catch (Exception e){
            Id errorId = error_handler.insert_errordata(e,'EmailInboundservice','createrecord');
            erroremail(errorId);
            return null;
        }
    }


     /**
     * * @description Createrecord_for_secod_object Method
     * @param firstObjList Map<String, Object> record
     * @param listSecondObj Map<String, Object> record
     * @param sigUploadJsone String Value
     * @param sigUploadFidList List of object
     * @param fileuploadjsone String Value
     * @param fileUploadFidList List of object
     * @param createChi Boolean Value
     * @param lookupList List of object
     * @param base64att base64 String
     * @return String 'success' record
     */
    public static String Createrecord_for_secod_object( Map<String, Object> firstObjList, Map<String, Object> listSecondObj, String sigUploadJsone, List<Object> sigUploadFidList, String fileuploadjsone, List<Object> fileUploadFidList, Boolean createChi, List<Object> lookupList, String base64att){
        try{

            String sobjectName = (String)firstObjList.get('sobjectType');
            String sobjectName2 = (String)listSecondObj.get('sobjectType');
            Type sobjectType = Type.forName(sobjectName);
            sObject newSObject = (sObject) sobjectType.newInstance();
            Type sobjectType2 = Type.forName(sobjectName2);
            sObject newSObject2 = (sObject) sobjectType2.newInstance();

            
            //For First Object
            for (String key : firstObjList.keySet()){
                Object value = firstObjList.get(key);
                Integer intValue = null;
                Decimal decValue = null;
                Date datValue = null;
                DateTime dattimValue = null;
                Time timValue = null;
                Boolean bolValue = null;
                Blob blobvalue = null;
    
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
                    }else if (fieldType == 'BOOLEAN') {
                        if (value == 'True') {
                            bolValue = true;
                        } else {
                            bolValue = false;
                        }
                    } else if (fieldType == 'BASE64'){
                        blobvalue = EncodingUtil.base64Decode(base64att);
                    }

                    if (intValue != null){
                        newSObject.put(key, intValue);
                    } else if(decValue != null){
                        newSObject.put(key, decValue);
                    } else if(datValue != null){
                        newSObject.put(key, datValue);
                    } else if(dattimValue != null){
                        newSObject.put(key, dattimValue);
                    } else if (bolValue != null) {
                        newSObject.put(key, bolValue);
                    } else if(timValue != null){
                        newSObject.put(key, timValue);
                    } else if (blobvalue != null) {
                        newSObject.put(key, blobvalue);
                    } else{
                        newSObject.put(key, value);
                    }
                }
            }

            //For Second Object
            for (String key : listSecondObj.keySet()){
                Object value = listSecondObj.get(key);
                Integer intValue = null;
                Decimal decValue = null;
                Date datValue = null;
                DateTime dattimValue = null;
                Time timValue = null;
                Boolean bolValue = null;
                Blob blobvalue = null;

                if (key != 'sobjectType'){
                    String fieldType = String.valueOf(Schema.getGlobalDescribe().get(sobjectName2).getDescribe().fields.getMap().get(key).getDescribe().getType());
                    if (fieldType == 'INTEGER'){
                        intValue = Integer.valueOf(value);
                    } 
                    else if(fieldType == 'PERCENT' || fieldType == 'CURRENCY' || fieldType == 'DOUBLE'){
                        decValue = Decimal.valueOf(String.valueOf(value));
                    } 
                    else if (fieldType == 'DATE'){
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
                        blobvalue = EncodingUtil.base64Decode(base64att);
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
                    } else if (bolValue != null) {
                        newSObject2.put(key, bolValue);
                    } else if(timValue != null){
                        newSObject2.put(key, timValue);
                    } else if(blobvalue != null){
                        newSObject2.put(key, blobvalue);
                    } else{
                        newSObject2.put(key, value);
                    }
                }
            }
            
            // Check if the current user has permission to create records for the dynamic sObject type
            insert as User newSObject;
            insertRecordList.add(newSObject.Id);

            if (createChi){
                for (Object lookupApi : lookupList){
                    if (sobjectName == 'Contact' && sobjectName2 == 'Opportunity') {
                        newSObject2.put('ContactId', newSObject.Id);
                    } else {
                        newSObject2.put((String)lookupApi, newSObject.Id);
                    }
                }
                if (sobjectName2 == 'Attachment'){
                    Object bas = base64att;
                    String myStr = String.valueOf(bas);
                    Blob myBlob = EncodingUtil.base64Decode(myStr);
                    newSObject2.put('ParentId', newSObject.Id);
                    newSObject2.put('Body', myBlob);
                    insert as User newSObject2;
                    insertRecordList.add(newSObject2.Id);
                } else{
                    insert as User newSObject2;
                    insertRecordList.add(newSObject2.Id);
                }
            } else{
                if (sobjectName2 == 'Attachment'){
                    newSObject2.put('ParentId', newSObject.Id);
                    insert as User newSObject2;
                    insertRecordList.add(newSObject2.Id);
                } else{
                    insert as User newSObject2;
                    insertRecordList.add(newSObject2.Id);
                }
            }
            return 'success';
        } catch (Exception e){
            Id errorId = error_handler.insert_errordata(e,'EmailInboundservice','createrecord_secod_object');
            erroremail(errorId);
            System.debug('errror' +String.valueOf(e) + ' '+ e.getLineNumber());
            return null;
        }
    }

        /**
     * @description Createrecord_for_third_object Method
     * @param firstObjList Map<String,Object> record
     * @param listSecondObj Map<String,Object> record
     * @param list_third_obj Map<String,Object> record
     * @param sigUploadJsone String Value
     * @param sigUploadFidList List of Object
     * @param fileuploadjsone String Value
     * @param fileUploadFidList List of Object
     * @param createChi Boolean Value
     * @param lookupList List of Object
     * @param createChi_2 Boolean Value
     * @param lookupList2 List of Object
     * @param base64att String value
     * @return String 'success' record
     */
    public static String Createrecord_for_third_object(Map<String,Object> firstObjList,  Map<String,Object> listSecondObj,  Map<String,Object> list_third_obj, String sigUploadJsone, List<Object> sigUploadFidList, String fileuploadjsone, List<Object> fileUploadFidList, Boolean createChi, List<Object> lookupList, Boolean createChi_2, List<Object> lookupList2, String base64att){
        try{

            String sobjectName = (String)firstObjList.get('sobjectType');
            String sobjectName2 = (String)listSecondObj.get('sobjectType');
            String sobjectName3 = (String)list_third_obj.get('sobjectType');
            Type sobjectType = Type.forName(sobjectName);
            sObject newSObject = (sObject) sobjectType.newInstance();
            Type sobjectType2 = Type.forName(sobjectName2);
            sObject newSObject2 = (sObject) sobjectType2.newInstance();
            Type sobjectType3 = Type.forName(sobjectName3);
            sObject newSObject3 = (sObject) sobjectType3.newInstance();
            
            //For First Object
            for (String key : firstObjList.keySet()){
                Object value = firstObjList.get(key);
                Integer intValue = null;
                Decimal decValue = null;
                Date datValue = null;
                DateTime dattimValue = null;
                Time timValue = null;
                Boolean bolValue = null;
                Blob blobvalue = null;
                
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
                        blobvalue = EncodingUtil.base64Decode(base64att);
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
                    } else if (blobvalue != null) {
                        newSObject.put(key, blobvalue);
                    } else{
                        newSObject.put(key, value);
                    }
                }
            }

            //For Second Object
            for (String key : listSecondObj.keySet()){
                Object value = listSecondObj.get(key);
                Integer intValue = null;
                Decimal decValue = null;
                Date datValue = null;
                DateTime dattimValue = null;
                Time timValue = null;
                Boolean bolValue = null;
                Blob blobvalue = null;
                
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
                        blobvalue = EncodingUtil.base64Decode(base64att);
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
                    } else if (blobvalue != null) {
                        newSObject2.put(key, blobvalue);
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
                Blob blobvalue = null;
                
                
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
                        blobvalue = EncodingUtil.base64Decode(base64att);
                    } else if (fieldType == 'BOOLEAN') {
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
                    } else if (bolValue != null) {
                        newSObject3.put(key, bolValue);
                    } else if(timValue != null){
                        newSObject3.put(key, timValue);
                    } else if (blobvalue != null) {
                        newSObject3.put(key, blobvalue);
                    } else{
                        newSObject3.put(key, value);
                    }
                }
            }
            insert as User newSObject;
            insertRecordList.add(newSObject.Id);

            if (createChi){
                for (Object lookupApi : lookupList){
                    if (sobjectName == 'Contact' && sobjectName2 == 'Opportunity') {
                        newSObject2.put('ContactId', newSObject.Id);
                    } else {
                        newSObject2.put((String)lookupApi, newSObject.Id);
                    }
                }
                if (sobjectName2 == 'Attachment'){
                    Object bas = base64att;
                    String myStr = String.valueOf(bas);
                    Blob myBlob = EncodingUtil.base64Decode(myStr);
                    newSObject2.put('ParentId', newSObject.Id);
                    newSObject2.put('Body', myBlob);
                    insert as User newSObject2;
                    insertRecordList.add(newSObject2.Id);
                } else{
                    insert as User newSObject2;
                    insertRecordList.add(newSObject2.Id);
                }
            } else{
                if (sobjectName2 == 'Attachment'){
                    newSObject2.put('ParentId', newSObject.Id);
                    insert as User newSObject2;
                    insertRecordList.add(newSObject2.Id);
                } else{
                    insert as User newSObject2;
                    insertRecordList.add(newSObject2.Id);
                }
            }
            if (createChi_2){
                for (Object lookupApi_2 : lookupList2){
                    if (sobjectName == 'Contact' && sobjectName2 == 'Opportunity') {
                        newSObject3.put('ContactId', newSObject.Id);
                    } else {
                        newSObject3.put((String)lookupApi_2, newSObject.Id);
                    }
                }
                if (sobjectName3 == 'Attachment'){
                    Object bas = base64att;
                    String myStr = String.valueOf(bas);
                    Blob myBlob = EncodingUtil.base64Decode(myStr);
                    newSObject3.put('ParentId', newSObject.Id);
                    newSObject3.put('Body', myBlob);
                    insert as User newSObject3;
                    insertRecordList.add(newSObject3.Id);
                } else{
                    insert as User newSObject3;
                    insertRecordList.add(newSObject3.Id);
                }
            } else{

                if (sobjectName3 == 'Attachment'){
                    Object bas = base64att;
                    String myStr = String.valueOf(bas);
                    Blob myBlob = EncodingUtil.base64Decode(myStr);
                    newSObject3.put('ParentId', newSObject.Id);
                    newSObject3.put('Body', myBlob);
                    insert as User newSObject3;
                    insertRecordList.add(newSObject3.Id);
                } else{
                    insert as User newSObject3;
                    insertRecordList.add(newSObject3.Id);
                }
            }
            return 'success';
        } catch (Exception e){
            
            Id errorId = error_handler.insert_errordata(e,'EmailInboundservice','createrecord_third_object');
            erroremail(errorId);
            return null;
        }
    }   
    
    /**
     * @description erroremail Method
     * @param errorId Id
     */
    public static void erroremail(Id errorId) {

        Form__c form = [SELECT Id,Name FROM Form__c WHERE Id =: formId WITH SECURITY_ENFORCED ];
        String errormessage = '<p><span style="font-size: 16px; color: rgb(0, 0, 0); font-family: verdana;">Dear '+UserInfo.getName()+',</span></p><p><br></p><p><span style="font-size: 16px; color: rgb(0, 0, 0); font-family: verdana;">We regret to inform you that there has been an issue with the submission of the ' +form.Name+'. The details of the failed submission are as follows:</span></p><p><br></p><p><span style="font-size: 16px; color: rgb(0, 0, 0); font-family: verdana;">Form Submission ID: '+insertRecordList[0]+'</span></p><p><span style="font-size: 16px; color: rgb(0, 0, 0); font-family: verdana;">Form Name: '+form.Name+'</span></p><p><span style="font-size: 16px; color: rgb(0, 0, 0); font-family: verdana;">Error ID: '+errorId+'</span></p><p><br></p><p><span style="font-size: 16px; color: rgb(21, 21, 21); font-family: verdana;">Please contact admin if you have any questions or need further assistance.</span></p>';
        List<OrgWideEmailAddress> owea = [select Id, Address from OrgWideEmailAddress WHERE DisplayName =: 'QF-OWA' WITH SECURITY_ENFORCED LIMIT 1];
        Messaging.SingleEmailMessage emailNotification = new Messaging.SingleEmailMessage();        
        List<String> toAddresses = new List<String>();
        toAddresses.add(owea[0].Address);
        if ( owea.size() > 0 ) {
            emailNotification.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        emailNotification.setToAddresses(toAddresses);
        emailNotification.setSubject('Form Submission Failure - '+form.Name);
        emailNotification.setHtmlBody(errormessage);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ emailNotification });
    }
}