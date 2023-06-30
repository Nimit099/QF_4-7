/***************************************************************
 ** Author             : Nitin
 ** Created Date       : 04/03/2023
 ** Last Modified Date : 06/03/2023
 ** Description        : Used for genrating pdf of submission record
 ***************************************************************/
/**
 * @description PDFGeneratorController class for generating pdf of submission record.
 */
public with  sharing class PDFGeneratorController{
    /** @description formSubmissionData variable */
    public Form_Submission__c fromSubmisionData{ get; set; }

    /** @description formData variable */
    public formDataWrapper formData{ get; set; }

    /** @description isFirstObject variable */
    public boolean isFirstObject{ get; set; }

    /** @description isSecondObject variable */
    public boolean isSecondObject{ get; set; }

    /** @description isThirdObject variable */
    public boolean isThirdObject{ get; set; }

    /** @description isOtherObject variable */
    public boolean isOtherObject{ get; set; }

    /** @description isSignature variable */
    public boolean isSignature{ get; set; }

    /** @description isFileupload variable */
    public boolean isFileupload{ get; set; }

    /** @description PDFGeneratorController */
    public PDFGeneratorController(){
        getPagesOfForm();
    }

    /** @description getPagesOfForm method to get the number of pages of the form. */
    public void getPagesOfForm(){

        fromSubmisionData = new Form_Submission__c();
        formData = new formDataWrapper();
        Map<String, Object> mapofFirstObject = new Map<String, Object>();
        Map<String, String> mapofFirstObjectData = new Map<String, String>();

        Map<String, Object> mapofSecondObject = new Map<String, Object>();
        Map<String, String> mapofSecondObjectData = new Map<String, String>();

        Map<String, Object> mapofThirdObject = new Map<String, Object>();
        Map<String, String> mapofThirdObjectData = new Map<String, String>();

        Map<String, Object> mapofOtherObject = new Map<String, Object>();
        Map<String, String> mapofOtherObjectData = new Map<String, String>();
        Map<String, String> mapofExtraFieldsData = new Map<String, String>();

        Map<String, String> mapofSignatureData = new Map<String, String>();
        Map<String, String> mapofFileUploadData = new Map<String, String>();
        Map<String, String> mapofOtherFieldsLabelData = new Map<String, String>();

        try{
            // Getting Form_Submission__c record id using page referenc
            String submissionId = ApexPages.currentPage().getParameters().get('Id');

            // Submitted record
            Form_Submission__c formSubmissionRecord = [SELECT Id, Name, Form__c, Form__r.Name, First_object_data__c, Second_object_data__c, Third_object_data__c, Other_fields_data__c
                                                       FROM Form_Submission__c
                                                       WHERE Id = :submissionId
                                                       WITH SECURITY_ENFORCED];
            fromSubmisionData = formSubmissionRecord;

            // getting formfields of form in to list
            List<Form_Fields__c> formFildsList = new List<Form_Fields__c>();
            formFildsList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Label__c, Mapped_Obj__c, Field_Mapping__c
                             FROM Form_Fields__c
                             WHERE Form__c = :formSubmissionRecord.Form__c
                             WITH SECURITY_ENFORCED];

            // Stroring First object fields submitted data into Map<String, String>
            mapofFirstObject = (Map<String, Object>)JSON.deserializeUntyped(formSubmissionRecord.First_object_data__c);
            for (String key : mapofFirstObject.keySet()){
                Object value = mapofFirstObject.get(key);
                if (value != null){
                    String strValue = String.valueOf(value);
                    if (strValue.length() > 40 && !strValue.contains(' ')){
                        String modifiedValue = '';
                        for (Integer i = 0; i < strValue.length(); i += 40){
                            if (i + 40 < strValue.length()){
                                modifiedValue += strValue.substring(i, i + 40) + ' ';
                            } else{
                                modifiedValue += strValue.substring(i);
                            }
                        }
                        strValue = modifiedValue.trim();
                    }
                    mapofFirstObjectData.put(key, strValue);
                }
                isFirstObject = true;
            }

            // Stroring Second object fields submitted data into Map<String, String>
            mapofSecondObject = (Map<String, Object>)JSON.deserializeUntyped(formSubmissionRecord.Second_object_data__c);
            if (mapofSecondObject != null){
                for (String key : mapofSecondObject.keySet()){
                    Object value = mapofSecondObject.get(key);
                    if (value != null){
                        String strValue = String.valueOf(value);
                        if (strValue.length() > 40 && !strValue.contains(' ')){
                            String modifiedValue = '';
                            for (Integer i = 0; i < strValue.length(); i += 40){
                                if (i + 40 < strValue.length()){
                                    modifiedValue += strValue.substring(i, i + 40) + ' ';
                                } else{
                                    modifiedValue += strValue.substring(i);
                                }
                            }
                            strValue = modifiedValue.trim();
                        }
                        mapofSecondObjectData.put(key, strValue);
                    }
                    isSecondObject = true;
                }
            }

            // Stroring Third object fields submitted data into Map<String, String>
            mapofThirdObject = (Map<String, Object>)JSON.deserializeUntyped(formSubmissionRecord.Third_object_data__c);
            if (mapofThirdObject != null){
                for (String key : mapofThirdObject.keySet()){
                    Object value = mapofThirdObject.get(key);
                    if (value != null){
                        String strValue = String.valueOf(value);
                        if (strValue.length() > 40 && !strValue.contains(' ')){
                            String modifiedValue = '';
                            for (Integer i = 0; i < strValue.length(); i += 40){
                                if (i + 40 < strValue.length()){
                                    modifiedValue += strValue.substring(i, i + 40) + ' ';
                                } else{
                                    modifiedValue += strValue.substring(i);
                                }
                            }
                            strValue = modifiedValue.trim();
                        }
                        mapofThirdObjectData.put(key, strValue);
                    }
                    isThirdObject = true;
                }
            }

            // Storing Other fields submitted data into Map<String, String>
            mapofOtherObject = (Map<String, Object>)JSON.deserializeUntyped(formSubmissionRecord.Other_fields_data__c);
            for (String key : mapofOtherObject.keySet()){
                Object value = mapofOtherObject.get(key);
                if (value != null){
                    String strValue = String.valueOf(value);
                    if (strValue.length() > 40 && !strValue.contains(' ')){
                        String modifiedValue = '';
                        for (Integer i = 0; i < strValue.length(); i += 40){
                            if (i + 40 < strValue.length()){
                                modifiedValue += strValue.substring(i, i + 40) + ' ';
                            } else{
                                modifiedValue += strValue.substring(i);
                            }
                        }
                        strValue = modifiedValue.trim();
                    }
                    mapofOtherObjectData.put(key, strValue);
                }
                isOtherObject = true;
            }

            Set<Id> contentVersionIdOfFiles = new Set<Id>();

            for (String key : mapofOtherObjectData.keySet()){
                if (key == 'sobjectType'){
                    mapofExtraFieldsData.put(key, mapofOtherObjectData.get(key));
                } else{
                    for (Form_Fields__c ff : formFildsList){
                        if (ff.Id == key && ff.Name.Contains('QFSIGNATURE')){
                            mapofSignatureData.put(key, mapofOtherObjectData.get(key));
                            System.debug('NIMIT Debug : ' + key+ ',' + mapofOtherObjectData.get(key));
                            isSignature = true;
                        } else if (ff.Id == key && ff.Name.Contains('QFFILEUPLOAD')){
                            mapofFileUploadData.put(key, mapofOtherObjectData.get(key));
                            contentVersionIdOfFiles.add(mapofOtherObjectData.get(key));
                            isFileupload = true;
                        } else if (ff.Id == key){
                            mapofExtraFieldsData.put(key, mapofOtherObjectData.get(key));
                        }

                        // Storing Fields label in map to display in vf page
                        if (ff.Id == key){
                            if (String.isNotBlank(ff.Field_Label__c)){
                                mapofOtherFieldsLabelData.put(key, ff.Field_Label__c);
                            } else{
                                mapofOtherFieldsLabelData.put(key, key);
                            }
                        }
                    }
                }
            }
            List<contentDocument> contentDocList = new List<contentDocument>();
            contentDocList = [SELECT Id, Title, LatestPublishedVersionId
                              FROM contentDocument
                              WHERE LatestPublishedVersionId IN:contentVersionIdOfFiles
                              WITH SECURITY_ENFORCED];

            Map<String, String> fileUploadTitles = new Map<String, String>();
            for (String key : mapofFileUploadData.keySet()){
                for (contentDocument cd : contentDocList){
                    if (cd.LatestPublishedVersionId == mapofFileUploadData.get(key)){
                        // here adding Salesforce URL to map to show in PDF
                        mapofFileUploadData.put(key, URL.getSalesforceBaseUrl().toExternalForm() + '/' + cd.Id);
                        fileUploadTitles.put(key, cd.Title);
                    }
                }
            }

            // For first object
            Map<String, String> firstObjectLbl = new Map<String, String>();
            firstObjectLbl = genrateLabelMap(mapofFirstObjectData, formFildsList);

            // for second object
            Map<String, String> secondObjectLbl = new Map<String, String>();
            secondObjectLbl = genrateLabelMap(mapofSecondObjectData, formFildsList);

            // for third object
            Map<String, String> thirdObjectLbl = new Map<String, String>();
            thirdObjectLbl = genrateLabelMap(mapofThirdObjectData, formFildsList);

            // getting list of pages of the submited form
            List<Form_Page__c> formpageList = new List<Form_Page__c>();
            formpageList = [SELECT Id, Name, Page_Number__c
                            FROM Form_Page__c
                            WHERE Form__c = :formSubmissionRecord.Form__c
                            WITH SECURITY_ENFORCED
                            ORDER BY Page_Number__c ASC];

            // Assigning values to wrraper class
            formData.formName = formSubmissionRecord.Form__r.Name;
            formData.formPages = formpageList;
            formData.firstObjectFieldMap = mapofFirstObjectData;
            formData.secondObjectFieldMap = mapofSecondObjectData;
            formData.thirdObjectFieldMap = mapofThirdObjectData;
            formData.otherObjectFieldMap = mapofExtraFieldsData;
            formData.signatureFieldMap = mapofSignatureData;
            formData.fileUploadFieldMap = mapofFileUploadData;
            formData.otherObjectFieldLabelsMap = mapofOtherFieldsLabelData;
            formData.firstObjectFieldLabelsMap = firstObjectLbl;
            formData.secondObjectFieldLabelsMap = secondObjectLbl;
            formData.thirdObjectFieldLabelsMap = thirdObjectLbl;
            formData.contentDocumentTitleMap = fileUploadTitles;

        } catch (Exception e){
            System.debug('Exception--->' + e.getMessage() + ' -->>' + e.getLineNumber());
        }
    }

    /**
     * @description This method generates a map with labels of the fields mapped to the corresponding keys in the provided objectDataMap.
     * @param objectDataMap A Map of String keys and String or Object values. It should contain a 'sobjectType' key with the API name of the object to map labels for.
     * @param formFildsList A List of Form_Fields__c objects, used to retrieve field label mappings.
     * @return A Map of String keys and String values, containing the labels of the fields mapped to the corresponding keys in the provided objectDataMap.
     **/
    public Map<String, String> genrateLabelMap(Map<String, String> objectDataMap, List<Form_Fields__c> formFildsList){
        Map<String, String> objLabelMap = new Map<String, String>();
        try{
            for (String key : objectDataMap.keySet()){
                if (key == 'sobjectType'){
                    // here puting object label name in mao instead od api name
                    objLabelMap.put(key, genrateObjectLabel(objectDataMap.get('sobjectType')));
                } else{
                    String label = '';
                    for (Form_Fields__c ff : formFildsList){
                        if (ff.Mapped_Obj__c == objectDataMap.get('sobjectType')){
                            String[] splitString = ff.Field_Mapping__c.split('<!@!>');
                            if (splitString[0] == key){
                                label = ff.Field_Label__c;
                                break;
                        }
                    }
                }
                    // If label is not found, assign a default label
                    if (label == ''){
                        if (key == 'BillingStreet' || key == 'ShippingStreet' || key == 'OtherStreet' || key == 'MailingStreet' || key == 'Street' || key == 'ShipToStreet' || key == 'ShipFromStreet'){
                            label = 'STREET';
                        } else if (key == 'BillingCity' || key == 'ShippingCity' || key == 'OtherCity' || key == 'MailingCity' || key == 'City' || key == 'ShipToCity' || key == 'ShipFromCity'){
                            label = 'CITY';
                        } else if (key == 'BillingPostalCode' || key == 'ShippingPostalCode' || key == 'OtherPostalCode' || key == 'MailingPostalCode' || key == 'PostalCode' || key == 'ShipToPostalCode' || key == 'ShipFromPostalCode'){
                            label = 'POSTAL CODE';
                        } else if (key == 'BillingState' || key == 'ShippingState' || key == 'OtherState' || key == 'MailingState' || key == 'State' || key == 'ShipToState' || key == 'ShipFromState'){
                            label = 'STATE';
                        } else if (key == 'BillingCountry' || key == 'ShippingCountry' || key == 'OtherCountry' || key == 'MailingCountry' || key == 'Country' || key == 'ShipToCountry' || key == 'ShipFromCountry'){
                            label = 'COUNTRY';
                        } else if (key == 'Salutation'){
                            label = 'SALUTATION';
                        } else if (key == 'FirstName'){
                            label = 'FIRST NAME';
                        } else if (key == 'LastName'){
                            label = 'LAST NAME';
                        } else{
                            label = 'Unknown Label';
            }
                    }
                    objLabelMap.put(key, label);
                }
            }

        } catch (Exception e){
            System.debug('Exception--->' + e.getMessage() + ' -->>' + e.getLineNumber());
        }
        return objLabelMap;
    }

    /**
     * @description This method takes in the object API name as a parameter and returns the object label as a string value.
     * @param objectApiName - the API name of the object.
     * @return String objectLabel - the label of the object.
     **/
    public String genrateObjectLabel(String objectApiName){
        String objectLabel = objectApiName;
        try{
            Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(objectApiName).getDescribe();
            objectLabel = describeResult.getLabel();
        } catch (Exception e){
            System.debug('Exception--->' + e.getMessage() + ' -->>' + e.getLineNumber());
        }
        return objectLabel;
    }

    /**
     * @description formDataWrapper class
     */
    public class formDataWrapper{
        /**
         * @description formName public wrapper variable
         * @return returns string value
         */
        public String formName{ get; set; }

        /**
         * @description formPages public wrapper variable
         * @return returns List of Form_Page__c value
         */
        public List<Form_Page__c> formPages{ get; set; }

        /**
         * @description firstObjectFieldMap public wrapper variable
         * @return returns map of String values as key and value pair
         */
        public Map<String, String> firstObjectFieldMap{ get; set; }

        /**
         * @description secondObjectFieldMap public wrapper variable
         * @return returns map of String values as key and value pair
         */
        public Map<String, String> secondObjectFieldMap{ get; set; }

        /**
         * @description thirdObjectFieldMap public wrapper variable
         * @return returns map of String values as key and value pair
         */
        public Map<String, String> thirdObjectFieldMap{ get; set; }

        /**
         * @description otherObjectFieldMap public wrapper variable
         * @return returns map of String values as key and value pair
         */
        public Map<String, String> otherObjectFieldMap{ get; set; }

        /**
         * @description signatureFieldMap public wrapper variable
         * @return returns map of String values as key and value pair
         */
        public Map<String, String> signatureFieldMap{ get; set; }

        /**
         * @description fileUploadFieldMap public wrapper variable
         * @return returns map of String values as key and value pair
         */
        public Map<String, String> fileUploadFieldMap{ get; set; }

        /**
         * @description otherObjectFieldLabelsMap public wrapper variable
         * @return returns map of String values as key and value pair
         */
        public Map<String, String> otherObjectFieldLabelsMap{ get; set; }

        /**
         * @description firstObjectFieldLabelsMap public wrapper variable
         * @return returns map of String values as key and value pair
         */
        public Map<String, String> firstObjectFieldLabelsMap{ get; set; }

        /**
         * @description secondObjectFieldLabelsMap public wrapper variable
         * @return returns map of String values as key and value pair
         */
        public Map<String, String> secondObjectFieldLabelsMap{ get; set; }

        /**
         * @description thirdObjectFieldLabelsMap public wrapper variable
         * @return returns map of String values as key and value pair
         */
        public Map<String, String> thirdObjectFieldLabelsMap{ get; set; }

        /**
         * @description contentDocumentTitleMap public wrapper variable
         * @return returns map of String values as key and value pair
         */
        public Map<String, String> contentDocumentTitleMap{ get; set; }

    }

}