global class EmailInboundservices implements Messaging.InboundEmailHandler {


    public static List<Id> insertRecordList = new List<Id>();

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          try{
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
            String passeddata = email.plainTextBody;
            Map<String, Object> map1 = (Map<String,Object>)JSON.deserializeUntyped(passeddata);
            Map<String, Object> accmap = (Map<String, Object>)map1.get('acc'); 
            String sig_upload_jsoneString = (String)map1.get('sig_upload_jsone'); 
            List<Object> sig_upload_fid_listmap = (List<Object>)map1.get('sig_upload_fid_list'); 
            String file_upload_jsoneString = (String)map1.get('file_upload_jsone'); 
            List<Object> file_upload_fid_listmap = (List<Object>)map1.get('file_upload_fid_list'); 
            Boolean create_chiboolean = (Boolean)map1.get('create_chi'); 
            String base64attmap = (String)map1.get('base64att'); 
            List<Object> lookup_listmap = (List<Object>)map1.get('lookup_list'); 
            List<Object> lookup_list2map = (List<Object>)map1.get('lookup_list2'); 
            Boolean create_chi_2boolean = (Boolean)map1.get('create_chi_2'); 
            Integer ObjectCount = (Integer)map1.get('ObjectCount');
            String object1 = (String)accmap.get('First_object_data__c');
            String object2 = (String)accmap.get('Second_object_data__c');
            String object3 = (String)accmap.get('Third_object_data__c');
            String otherfields = (String)accmap.get('Other_fields_data__c');
            Id formid = (Id)accmap.get('Form__c');
            // insertRecordList.add((Id)map1.get('SubId'));

            String success;
            if (ObjectCount == 1) {
                success = createrecord(object1,object2,object3, otherfields,formid, sig_upload_jsoneString, sig_upload_fid_listmap, file_upload_jsoneString, file_upload_fid_listmap);
            } else if (ObjectCount == 2) {
             success =  createrecord_for_secod_object( object1,object2,object3, otherfields,formid, sig_upload_jsoneString, sig_upload_fid_listmap, file_upload_jsoneString , file_upload_fid_listmap,  create_chiboolean, lookup_listmap, base64attmap);
           } else if (ObjectCount == 3){
               success = createrecord_for_third_object(object1, object2, object3, otherfields,formid, sig_upload_jsoneString, sig_upload_fid_listmap, file_upload_jsoneString, file_upload_fid_listmap, create_chiboolean, lookup_listmap, create_chi_2boolean, lookup_list2map, base64attmap);
           }
            
           if (success == 'success') {
                
                Id submissionid = (Id) map1.get('SubId');
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
                return result;
            }
           return null;
        } catch(Exception e){
            System.debug('errror' +String.valueOf(e)+ ' : '+ e.getLineNumber());
            return null;
        }
    }

      /**
     * @description createrecord Method
     * @param acc Form_Submission__c record
     * @param first_obj_list SObject record
     * @param sig_upload_jsone String Value
     * @param sig_upload_fid_list List of String
     * @param file_upload_jsone String Value
     * @param file_upload_fid_list List of String
     * @return String 'success' record
     */
    public static String createrecord(String object1, String object2, String object3, String otherfields, Id formId, String sig_upload_jsone,  List<Object> sig_upload_fid_list, String file_upload_jsone, List<Object> file_upload_fid_list){
        try{



            Map<String, Object> first_obj_list = (Map<String, Object>)JSON.deserializeUntyped(object1);
            // Map<String, Object> list_second_obj = (Map<String, Object>)JSON.deserializeUntyped(object2);            
            // Map<String, Object> list_third_obj = (Map<String, Object>)JSON.deserializeUntyped(object3);

            String signatureid;
            String fildid;
            Map<String, Object> file_upload_map = new Map<String, Object>();
            Map<String, Object> sigUploadMap = new Map<String, Object>();
            Map<String, Object> sigMap = (Map<String, Object>)JSON.deserializeUntyped(sig_upload_jsone);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(file_upload_jsone);
            Map<String, Object> otherobjectdata = (Map<String, Object>) JSON.deserializeUntyped(otherfields);
            String subID = '';
            Integer sig_list_len = sig_upload_fid_list.size();
            if (sig_list_len > 0){
                for (Object sigType : sig_upload_fid_list){
                    String sigBaseid = (String) sigMap.get((String)sigType);
                    signatureid = signatureSave(subID, sigBaseid);
                    sigUploadMap.put((String)sigType, signatureid);
                    otherobjectdata.put((String)sigType, signatureid);
                }
            }
             

            Integer listLen = file_upload_fid_list.size();
            if (listLen > 0){
                for (Object type : file_upload_fid_list){
                    String types = (String)type;
                    String[] address = types.split('<!QF!>');
                    String fName = address[1];
                    String fType = address[2];
                    String baseid = (String) m.get(types) ;
                    fildid = SaveFile(subID, fName, baseid, fType);
                    file_upload_map.put(address[0], fildid);
                    otherobjectdata.put(address[0], fildid);
                }
            }

            Form_Submission__c formsub = new Form_Submission__c();

            formsub.Form__c = formId;
            formsub.First_object_data__c = object1;
            formsub.Second_object_data__c = object2;
            formsub.Third_object_data__c = object3;
            formsub.Other_fields_data__c = JSON.serialize(otherobjectdata);

            if (Schema.sObjectType.Form_Submission__c.fields.First_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Other_fields_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Form__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Second_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Third_object_data__c.isCreateable()){
                insert formsub;
                insertRecordList.add(formsub.Id);
                subID = formsub.Id;
            }



            String sobjectName = (String)first_obj_list.get('sobjectType');
            Type sobjectType = Type.forName(sobjectName);
            sObject newSObject = (sObject) sobjectType.newInstance();

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
            insert newSObject;
            insertRecordList.add(newSObject.Id);

            return 'success';

        } catch (Exception e){
            List<sobject> sobjlst = new List<sobject>();
            for (Id i : insertRecordList){
                sObject q = i.getSobjectType().newSobject(i);
                sobjlst.add(q);
            }
            delete sobjlst;
            return null;
        }
    }


     /**
     * * @description createrecord_for_secod_object Method
     * @param acc Form_Submission__c record
     * @param first_obj_list SObject record
     * @param sig_upload_jsone String Value
     * @param sig_upload_fid_list List of String
     * @param file_upload_jsone String Value
     * @param file_upload_fid_list List of String
     * @param create_chi Boolean Value
     * @param lookup_list List of String
     * @param base64att base64 String
     * @return String 'success' record
     */
    public static String createrecord_for_secod_object( String object1, String object2, String object3, String otherfields,Id formId, String sig_upload_jsone, List<Object> sig_upload_fid_list, String file_upload_jsone, List<Object> file_upload_fid_list, Boolean create_chi, List<Object> lookup_list, String base64att){
        try{

            Map<String, Object> first_obj_list = (Map<String, Object>)JSON.deserializeUntyped(object1);
            Map<String, Object> list_second_obj = (Map<String, Object>)JSON.deserializeUntyped(object2);            
            // Map<String, Object> list_third_obj = (Map<String, Object>)JSON.deserializeUntyped(object3);



            String signatureid;
            String fildid;
            Map<String, Object> file_upload_map = new Map<String, Object>();
            Map<String, Object> sigUploadMap = new Map<String, Object>();
            Map<String, Object> sigMap = (Map<String, Object>)JSON.deserializeUntyped(sig_upload_jsone);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(file_upload_jsone);
            Map<String, Object> otherobjectdata = (Map<String, Object>) JSON.deserializeUntyped(otherfields);
            String subID = '';
            Integer sig_list_len = sig_upload_fid_list.size();
            if (sig_list_len > 0){
                for (Object sigType : sig_upload_fid_list){
                    String sigBaseid = (String) sigMap.get((String)sigType);
                    signatureid = signatureSave(subID, sigBaseid);
                    sigUploadMap.put((String)sigType, signatureid);
                    otherobjectdata.put((String)sigType, signatureid);
                }
            }
             

            Integer listLen = file_upload_fid_list.size();
            if (listLen > 0){
                for (Object type : file_upload_fid_list){
                    String types = (String)type;
                    String[] address = types.split('<!QF!>');
                    String fName = address[1];
                    String fType = address[2];
                    String baseid = (String) m.get(types) ;
                    fildid = SaveFile(subID, fName, baseid, fType);
                    file_upload_map.put(address[0], fildid);
                    otherobjectdata.put(address[0], fildid);
                }
            }

            Form_Submission__c formsub = new Form_Submission__c();

            formsub.Form__c = formId;
            formsub.First_object_data__c = object1;
            formsub.Second_object_data__c = object2;
            formsub.Third_object_data__c = object3;
            formsub.Other_fields_data__c = JSON.serialize(otherobjectdata);

            if (Schema.sObjectType.Form_Submission__c.fields.First_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Other_fields_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Form__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Second_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Third_object_data__c.isCreateable()){
                insert formsub;
                insertRecordList.add(formsub.Id);
                subID = formsub.Id;
            }




            String sobjectName = (String)first_obj_list.get('sobjectType');
            String sobjectName2 = (String)list_second_obj.get('sobjectType');
            Type sobjectType = Type.forName(sobjectName);
            sObject newSObject = (sObject) sobjectType.newInstance();
            Type sobjectType2 = Type.forName(sobjectName2);
            sObject newSObject2 = (sObject) sobjectType2.newInstance();

            
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
                    }else if (fieldType == 'BOOLEAN') {
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
                    } else if (bolValue != null) {
                        newSObject.put(key, bolValue);
                    } else if(timValue != null){
                        newSObject.put(key, timValue);
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
                    } else if (bolValue != null) {
                        newSObject.put(key, bolValue);
                    } else if(timValue != null){
                        newSObject2.put(key, timValue);
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
            return 'success';
        } catch (Exception e){
            System.debug('errror' +String.valueOf(e) + ' '+ e.getLineNumber());
            List<sobject> sobjlst = new List<sobject>();
            for (Id i : insertRecordList){
                sObject q = i.getSobjectType().newSobject(i);
                sobjlst.add(q);
            }
            delete sobjlst;
            return null;
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
     * @return String 'success' record
     * @return base64att String
     */


    public static String createrecord_for_third_object(String object1,  String object2,  String object3,String otherfields, Id formId, String sig_upload_jsone, List<Object> sig_upload_fid_list, String file_upload_jsone, List<Object> file_upload_fid_list, Boolean create_chi, List<Object> lookup_list, Boolean create_chi_2, List<Object> lookup_list2, String base64att){
        try{


            Map<String, Object> first_obj_list = (Map<String, Object>)JSON.deserializeUntyped(object1);
            Map<String, Object> list_second_obj = (Map<String, Object>)JSON.deserializeUntyped(object2);            
            Map<String, Object> list_third_obj = (Map<String, Object>)JSON.deserializeUntyped(object3);




            String signatureid;
            String fildid;
            Map<String, Object> file_upload_map = new Map<String, Object>();
            Map<String, Object> sigUploadMap = new Map<String, Object>();
            Map<String, Object> sigMap = (Map<String, Object>)JSON.deserializeUntyped(sig_upload_jsone);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(file_upload_jsone);
            Map<String, Object> otherobjectdata = (Map<String, Object>) JSON.deserializeUntyped(otherfields);
            String subID = '';
            Integer sig_list_len = sig_upload_fid_list.size();
            if (sig_list_len > 0){
                for (Object sigType : sig_upload_fid_list){
                    String sigBaseid = (String) sigMap.get((String)sigType);
                    signatureid = signatureSave(subID, sigBaseid);
                    sigUploadMap.put((String)sigType, signatureid);
                    otherobjectdata.put((String)sigType, signatureid);
                }
            }
             

            Integer listLen = file_upload_fid_list.size();
            if (listLen > 0){
                for (Object type : file_upload_fid_list){
                    String types = (String)type;
                    String[] address = types.split('<!QF!>');
                    String fName = address[1];
                    String fType = address[2];
                    String baseid = (String) m.get(types) ;
                    fildid = SaveFile(subID, fName, baseid, fType);
                    file_upload_map.put(address[0], fildid);
                    otherobjectdata.put(address[0], fildid);
                }
            }
            
            Form_Submission__c formsub = new Form_Submission__c();

            formsub.Form__c = formId;
            formsub.First_object_data__c = object1;
            formsub.Second_object_data__c = object2;
            formsub.Third_object_data__c = object3;
            formsub.Other_fields_data__c = JSON.serialize(otherobjectdata);

            if (Schema.sObjectType.Form_Submission__c.fields.First_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Other_fields_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Form__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Second_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Third_object_data__c.isCreateable()){
                insert formsub;
                insertRecordList.add(formsub.Id);
                subID = formsub.Id;
            }




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
                        newSObject.put(key, bolValue);
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
                        newSObject.put(key, bolValue);
                    } else if(timValue != null){
                        newSObject3.put(key, timValue);
                    }  else{
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
            return 'success';
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

        /**
     * @description signatureSave Method
     * @param fieldId String Value
     * @param fieldData String Value
     * @return String
     */
    @AuraEnabled
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

    /**
     * @description SaveFile Method
     * @param fieldId String Value
     * @param fileName String Value
     * @param base64Data String Value
     * @param contentType String Value
     * @return String
     */
    @AuraEnabled
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