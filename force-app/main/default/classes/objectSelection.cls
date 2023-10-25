/**
 * @description :This is a public class named objectSelection.
 */
public with sharing class objectSelection{

    /**
     * @description :This method fetches a list of parent objects.
     * @return List of String
     */
        @AuraEnabled
        public static List<String> fetchParentObject(){
            try{
                Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
                Set<String> qfObjects = new Set<String>();
                List<QFObjects__mdt> metadataRecords = new List<QFObjects__mdt>();
                if (Schema.sObjectType.QFObjects__mdt.fields.Label.isAccessible()){
                    metadataRecords = [SELECT Label FROM QFObjects__mdt];
                  }
                for (QFObjects__mdt record : metadataRecords){
                    qfObjects.add(record.Label);
                }
    
                Set<String> objects = new Set<String>();
                for (Schema.SObjectType d : gd.values()){
                    Schema.DescribeSObjectResult ds = d.getDescribe();
                    if (!ds.isCreateable()){
                        continue; 
                    }
                    if (ds.isUpdateable() && (ds.isCustom() == false && ds.getRecordTypeInfos().size() > 0 && !(qfObjects.contains(ds.getName()))  || (ds.isCustom() && !(qfObjects.contains(ds.getName()))))){
                        objects.add(ds.getName());
                    }
                    else if (ds.isCustom() && !(qfObjects.contains(ds.getName()))){
                        objects.add(ds.getName());
                    }
                }
                List<String> parentObjs = new List<String>(objects);
                parentObjs.sort ();
                return parentObjs;
    
            } catch (Exception e){
                error_handler.insert_errordata(e, 'objectSelection', 'fetchParentObject');
                return null;
            }
        }
    
    /**
     * @description :This method fetches a list of child objects for a given parent object.
     * @param parent The parent object.
     * @return List of String
     */   
        @AuraEnabled
        public static List<String> fetchChildObject(String parent){
            try{
                Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
                Set<String> qfObjects = new Set<String>();
                List<QFObjects__mdt> metadataRecords = new List<QFObjects__mdt>();
                if (Schema.sObjectType.QFObjects__mdt.fields.Label.isAccessible()){
                    metadataRecords = [SELECT Label FROM QFObjects__mdt];
                  }
                for (QFObjects__mdt record : metadataRecords){
                    qfObjects.add(record.Label);
                }

                Set<string> sObjectList = new Set<string>();
                Schema.SObjectType convertType = Schema.getGlobalDescribe().get(parent);
                Schema.DescribeSObjectResult res = convertType.getDescribe();
                for (Schema.ChildRelationship cr : res.getChildRelationships()){
                    if (!(qfObjects.contains(String.valueOf(cr.getChildSObject())))){

                        if (cr.getChildSObject().getDescribe().isUpdateable() && cr.getChildSObject().getDescribe().isCreateable() && cr.getChildSObject().getDescribe().isAccessible() && cr.getChildSObject().getDescribe().isDeletable()){
                        String temp = String.valueOf(cr.getChildSObject());
                            if (temp != parent) {   
                        sObjectList.add(temp) ;
                    }
                }
                    }
                }
                List<String> childObject = new List<String>(sObjectList);
                return childObject;
            } catch (Exception e){
                error_handler.insert_errordata(e, 'objectSelection', 'fetchChildObject');
                return null;
            }
        }
    
    /**
     * @description :This method fetches a map of child objects for a list of parent objects.
     * @param parentList The list of parent objects.
     * @return Map of String to List of String
     */  
        @AuraEnabled
        public static Map<String, List<String>> fetchChildObject1(List<String> parentList){
            Map<String, List<String>> sObjectMap = new Map<String, List<String>>();
            try{
                for (String par : parentList){
                    List<String> sobject2 = new List<String>();
                    Schema.SObjectType convertType = Schema.getGlobalDescribe().get(par);
                    Schema.DescribeSObjectResult res = convertType.getDescribe();
                    for (Schema.ChildRelationship cr : res.getChildRelationships()){
                        if (parentList.contains(String.valueOf(cr.getChildSObject()))){
                            if (!sObjectMap.containsKey(par)){
                                sObjectMap.put(par, new List<String>());
                            }
                            sObjectMap.get(par).add(String.valueOf(cr.getChildSObject()));
                        }
                    }
                }
                return sObjectMap;
    
            } catch (Exception e){
                error_handler.insert_errordata(e, 'objectSelection', 'fetchChildObject1');
                return null;
            }
        }
    
    /**
     * @description :Retrieves a list of child objects based on a given list of parent objects.
     *
     * @param parent A list of parent objects.
     * @return A list of child objects associated with the given parent objects.
     * @throws Exception if an error occurs while fetching the child objects.
     */   
        @AuraEnabled
        public static List<String> temp2(List<String> parent){
            try{
    
                List<String> temp2 = new List<String>();
                List<String> test = new List<String>();
                Map<String, List<String>> parentObjects = new Map<String, List<String>>();
                parentObjects = fetchChildObject1(parent);
                if(parentObjects != null) {
                    for (String lst : parentObjects.keySet()){
                        if ((parentObjects.get(lst)).size() >= 1){
                            temp2.add(lst);
                        }
                    }
                }
                return temp2;
            } catch (Exception e){
                error_handler.insert_errordata(e, 'objectSelection', 'temp2');
                return null;
            }
        }
    
    /**
    * @description :This method returns a list of parent objects that have at least two child objects.
    * @param parent - List of parent objects
    * @return List<String> - List of parent objects that have at least two child objects
    * @throws Exception - if any exception occurs while fetching child objects
    */  
        @AuraEnabled
        public static List<String> temp3(List<String> parent){
            try{
                List<String> temp3 = new List<String>();
                List<String> test = new List<String>();
                test = parent;
                Map<String, List<String>> parentObjects = new Map<String, List<String>>();
                parentObjects = fetchChildObject1(test) ;
                if(parentObjects != null) {
                    for (String lst : parentObjects.keySet()){
                        if ((parentObjects.get(lst)).size() >= 2){
                            temp3.add(lst);
                        }
                    }
                }
                return temp3;
            } catch (Exception e){
                error_handler.insert_errordata(e, 'objectSelection', 'aveMapped_object');
                return null;
            }
        }
    
    /**
     * @description :Saves a mapped object to the database and returns its ID.
     *
     * @param Mapped_Objects     The comma-separated list of mapped objects to be saved.
     * @param FormTitle          The title of the form.
     * @param FormDesc           The description of the form.
     * @param ProgressIndicator  The progress indicator for the form.
     * @param CaptchaType        The type of captcha for the form.
     * @return                   The ID of the saved form.
     */   
        @AuraEnabled
        public static String saveMapped_object(String Mapped_Objects, String FormTitle, String FormDesc, String ProgressIndicator, String CaptchaType){
            try{
                String styles = 'width:100%;padding-top:0%;padding-bottom:0%;padding-left:0%;padding-right:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-attachment:Fixed;';
                String pageStyle = 'padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-attachment:Fixed;border-color:#000000;border-style:Solid;border-width:1px;border-radius:0px;';
                String fieldStyle = 'background-color:#FFFFFF;border-color:#000000;border-style:Solid;border-width:1px;border-radius:5px;font-family:Arial;font-weight:Normal;color:#242424;font-size:12px;font-style:Normal;padding-left:5px;padding-right:0px;padding-top:0px;padding-bottom:0px;line-height:1.5;';
                String hoverStyle = 'background-color:#FFFFFF;border-color:#000000;border-style:Solid;border-width:1px;border-radius:5px;font-family:Arial;font-weight:Normal;color:#000000;font-size:12px;font-style:Normal;padding-left:5px;padding-right:0px;padding-top:0px;padding-bottom:0px;line-height:1.5;';
                String focusStyle = 'background-color:#FFFFFF;border-color:#000000;border-style:Solid;border-width:1px;border-radius:5px;font-family:Arial;font-weight:Normal;color:#000000;font-size:12px;font-style:Normal;padding-left:5px;padding-right:0px;padding-top:0px;padding-bottom:0px;line-height:1.5;';
                String labelStyle = 'justify-content:Left;font-family:Arial;font-weight:Normal;font-style:Normal;font-size:12px;line-height:1.5;color:#000000;margin-top:0px;margin-bottom:0px;';
                String buttonStyle = ' background-color:#6699CC;border-color:#FFFFFF;height:35px;width:120px;font-size:16px;border-width:0px;border-style:Solid;border-radius:28px;font-family:Arial;font-weight:Normal;color:#FFFFFF;font-style:Normal;';
                Form__c form = new Form__c(Name = FormTitle, Mapped_Objects__c = Mapped_Objects, Captcha_Type__c = CaptchaType, Form_Description__c = FormDesc, Progress_Indicator__c = ProgressIndicator, Form_Styling__c = styles, All_Field_Styling__c = fieldStyle, Page_CSS__c = pageStyle, Label_CSS__c = labelStyle, All_Field_Focus__c = focusStyle, All_Field_Hover__c = hoverStyle, Button_CSS__c = buttonStyle, Button_Position__c = 'justify-content:Center;');
                
                if (Schema.sObjectType.Form__c.fields.Name.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.Mapped_Objects__c.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.Captcha_Type__c.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.Form_Description__c.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.Progress_Indicator__c.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.Form_Styling__c.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.All_Field_Styling__c.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.Page_CSS__c.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.Label_CSS__c.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.All_Field_Focus__c.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.All_Field_Hover__c.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.Button_CSS__c.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.Button_Position__c.isAccessible() &&
                    Schema.sObjectType.Form__c.fields.Name.isCreateable() &&
                    Schema.sObjectType.Form__c.fields.Mapped_Objects__c.isCreateable() &&
                    Schema.sObjectType.Form__c.fields.Captcha_Type__c.isCreateable() &&
                    Schema.sObjectType.Form__c.fields.Form_Description__c.isCreateable() &&
                    Schema.sObjectType.Form__c.fields.Progress_Indicator__c.isCreateable() &&
                    Schema.sObjectType.Form__c.fields.Form_Styling__c.isCreateable() &&
                    Schema.sObjectType.Form__c.fields.All_Field_Styling__c.isCreateable() &&
                    Schema.sObjectType.Form__c.fields.Page_CSS__c.isCreateable() &&
                    Schema.sObjectType.Form__c.fields.Label_CSS__c.isCreateable() &&
                    Schema.sObjectType.Form__c.fields.All_Field_Focus__c.isCreateable() &&
                    Schema.sObjectType.Form__c.fields.All_Field_Hover__c.isCreateable() &&
                    Schema.sObjectType.Form__c.fields.Button_CSS__c.isCreateable() &&
                    Schema.sObjectType.Form__c.fields.Button_Position__c.isCreateable()             
                   ){
                    Database.insert(form);
                }
                List<String> lst = Mapped_Objects.split(',');
                List<Form_Page__c> formPages = new List<Form_Page__c>();
                Integer pageNum = 1;
                for (String obj : lst){
                    String newvar = obj + ' Page';
                    Form_Page__c fpage = new Form_Page__c(Name = newvar, Form__c = form.Id, Page_Number__c = pageNum);
                    formPages.add(fpage);
                    pageNum++;
                }
                if (Schema.sObjectType.Form_Page__c.fields.Name.isCreateable() && Schema.sObjectType.Form_Page__c.fields.Form__c.isCreateable() && Schema.sObjectType.Form_Page__c.fields.Page_Number__c.isCreateable()) {
                    Database.insert(formPages);
                }
                
                Thankyou_Page__c thankyoupage = new Thankyou_Page__c(Name = form.Name, Form__c = form.Id, Thankyou_Page_Type__c = 'None', ThankYou_Label__c = '<p style="text-align: center;"><strong style="font-size: 28px;">Thank You</strong><span style="font-size: 28px;">﻿</span></p>');
                if (Schema.sObjectType.Thankyou_Page__c.fields.Name.isAccessible() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.Form__c.isAccessible() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.Thankyou_Page_Type__c.isAccessible() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.ThankYou_Label__c.isAccessible() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.Name.isCreateable() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.Form__c.isCreateable() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.Thankyou_Page_Type__c.isCreateable() &&
                    Schema.sObjectType.Thankyou_Page__c.fields.ThankYou_Label__c.isCreateable()             
                   ){
                    insert thankyoupage;
                }

                setReqFieldsRecords(form.Id);
                QuickFormHome.siteUrl(form.Id);
                
                return form.Id;
            } catch (Exception e){
                error_handler.insert_errordata(e, 'objectSelection', 'saveMapped_object');
                return null;
            }
        }

         /**
     * @description :Saves a mapped object to the database and returns its ID.          
     * @param id        The type of captcha for the form.     
     */   
    public static void setReqFieldsRecords(Id id){
        /*This method is used to pass fields records in js*/
        try{
            Form__c FormDetail = [SELECT Id, Mapped_Objects__c
                                  FROM Form__c
                                  WHERE Id = :id
                                  WITH SECURITY_ENFORCED
                                  LIMIT 1];              
            List<String> types = (FormDetail.Mapped_Objects__c).split(',');            
            Decimal Position = 0;
            List<Form_Page__c> AllFormPages = [SELECT ID
                                               From Form_Page__c
                                               where Form__c = :FormDetail.Id
                                               WITH SECURITY_ENFORCED
                                               ORDER BY Page_Number__c];
            boolean hasRequiredField = false;
            List<Form_Fields__c> fieldContainsRequireCheck = [SELECT Name
                                                              From Form_Fields__c
                                                              where Form_Page__c = :AllFormPages.get(0).Id
                                                              WITH SECURITY_ENFORCED];
            List<Form_Fields__c> allFieldsOfForm = [SELECT Id, Name, Form__c, Form_Page__c
                                                    FROM Form_Fields__c
                                                    WHERE Form__c = :FormDetail.Id
                                                    WITH SECURITY_ENFORCED];

            for (Form_Fields__c it : fieldContainsRequireCheck){
                List<String> temp = it.Name.split(',');
                if (temp.size() == 3){
                    if (temp.get(2) == 'isrequired'){
                        hasRequiredField = true;
                    }
                }
            }

            if (hasRequiredField == false){
                if (allFieldsOfForm.size() == 0){
                    Integer iteration = 0;
                    List<Form_Fields__c> fields = new List<Form_Fields__c>();
                    for (String type : types){
                        Position = 0;
                        Form_Page__c page_Id = AllFormPages.get(iteration);
                        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();                        
                        Schema.SObjectType leadSchema = schemaMap.get(type) ;                        
                        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                        
                        for (String fieldName : fieldMap.keySet()){
                            if (fieldName != 'OwnerId' && (fieldMap.get(fieldName).getDescribe().getType() != Schema.DisplayType.BOOLEAN) && (!fieldMap.get(fieldName).getDescribe().isNillable() && fieldMap.get(fieldName).getDescribe().isCreateable())){
                                Position = Position + 1;
                                Form_Fields__c field = new Form_Fields__c();
                                field.Mapped_Obj__c = type;
                                String Label = '';
                                field.Field_Mapping__c = fieldMap.get(fieldName) + '<!@!>' + type;
                                if (fieldName == 'LastName'){
                                    field.Name = 'NAME' + ',' + 'QFFULLNAME' + ',isrequired';
                                    field.Field_Label__c = 'Name';
                                    Label = field.Field_Label__c;
                                } else{
                                    field.Name = fieldMap.get(fieldName).getDescribe().getLabel() + ',' + fieldMap.get(fieldName).getDescribe().getType() + ',isrequired';
                                    field.Field_Label__c = fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase();
                                    Label = field.Field_Label__c;
                                }
                                field.Form__c = FormDetail.Id;
                                field.Form_Page__c = page_Id.Id;
                                field.Field_Order__c = Position + 1;
                                if (!(type == 'Attachment' && fieldName == 'ParentId')){
                                    if (String.valueof(fieldMap.get(fieldName).getDescribe().getType()) == 'CURRENCY' || String.valueof(fieldMap.get(fieldName).getDescribe().getType()) == 'PERCENT' || String.valueof(fieldMap.get(fieldName).getDescribe().getType()) == 'DOUBLE'){
                                        field.Field_Validations__c = 'isRequired<!@!>true' + 
                                                                        '?$`~isDisabled<!@!>false' + 
                                                                        '?$`~isLabel<!@!>true' + 
                                                                        '?$`~isHelpText<!@!>false' + 
                                                                        '?$`~Label<!@!>' + Label + 
                                                                        '?$`~HelpText<!@!>' + 
                                                                        '?$`~isPlaceholder<!@!>false' + 
                                                                        '?$`~Placeholder<!@!>' + 
                                                                        '?$`~Minimum<!@!>0' + 
                                                                        '?$`~Maximum<!@!>' + fieldMap.get(fieldName).getDescribe().getPrecision() + 
                                                                        '?$`~isPrefix<!@!>false' + 
                                                                        '?$`~Prefix<!@!>' + 
                                                                        '?$`~Decimal<!@!>' + 
                                                                        '?$`~Richtext<!@!>' + 
                                                                        '?$`~MinimumTime<!@!>' + 
                                                                        '?$`~MaximumTime<!@!>' + 
                                                                        '?$`~MinimumDateTime<!@!>' + 
                                                                        '?$`~MaximumDateTime<!@!>' + 
                                                                        '?$`~MinimumDate<!@!>' + 
                                                                        '?$`~MaximumDate<!@!>' + 
                                                                        '?$`~Salutation<!@!>';
                                    } else{
                                        if (fieldMap.get(fieldName).getDescribe().getLength() > 0){
                                            if (fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase() == 'LAST NAME'){
                                                field.Field_Validations__c = 'isRequired<!@!>true' + 
                                                                        '?$`~isDisabled<!@!>false' + 
                                                                        '?$`~isLabel<!@!>true' + 
                                                                        '?$`~isHelpText<!@!>false' + 
                                                                        '?$`~Label<!@!>' + 'Name' + 
                                                                        '?$`~HelpText<!@!>' + 
                                                                        '?$`~isPlaceholder<!@!>false' + 
                                                                        '?$`~Placeholder<!@!>' + 
                                                                        '?$`~Minimum<!@!>0' + 
                                                                        '?$`~Maximum<!@!>' + fieldMap.get(fieldName).getDescribe().getLength() + 
                                                                        '?$`~isPrefix<!@!>false' + 
                                                                        '?$`~Prefix<!@!>' + 
                                                                        '?$`~Decimal<!@!>' + 
                                                                        '?$`~Richtext<!@!>' + 
                                                                        '?$`~MinimumTime<!@!>' + 
                                                                        '?$`~MaximumTime<!@!>' + 
                                                                        '?$`~MinimumDateTime<!@!>' + 
                                                                        '?$`~MaximumDateTime<!@!>' + 
                                                                        '?$`~MinimumDate<!@!>' + 
                                                                        '?$`~MaximumDate<!@!>';
                                                for (String fieldNames : fieldMap.keySet()){
                                                    if (fieldNames == 'salutation'){
                                                        Schema.DescribeFieldResult fieldDesc = (fieldMap.get(fieldNames).getDescribe());
                                                        for (Integer i = 0; i < fieldDesc.getPicklistValues().size(); i++){
                                                            field.Field_Validations__c = field.Field_Validations__c + '?$`~Salutation<!@!>' + fieldDesc.getPicklistValues()[i].getLabel();
                                                        }
                                                    }
                                                }
                                            }else {
                                                field.Field_Validations__c = 'isRequired<!@!>true' + 
                                                                        '?$`~isDisabled<!@!>false' + 
                                                                        '?$`~isLabel<!@!>true' + 
                                                                        '?$`~isHelpText<!@!>false' + 
                                                                        '?$`~Label<!@!>' + fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase() + 
                                                                        '?$`~HelpText<!@!>' + 
                                                                        '?$`~isPlaceholder<!@!>false' + 
                                                                        '?$`~Placeholder<!@!>' + 
                                                                        '?$`~Minimum<!@!>0' + 
                                                                        '?$`~Maximum<!@!>' + fieldMap.get(fieldName).getDescribe().getLength() + 
                                                                        '?$`~isPrefix<!@!>false' + 
                                                                        '?$`~Prefix<!@!>' + 
                                                                        '?$`~Decimal<!@!>' + 
                                                                        '?$`~Richtext<!@!>' + 
                                                                        '?$`~MinimumTime<!@!>' + 
                                                                        '?$`~MaximumTime<!@!>' + 
                                                                        '?$`~MinimumDateTime<!@!>' + 
                                                                        '?$`~MaximumDateTime<!@!>' + 
                                                                        '?$`~MinimumDate<!@!>' + 
                                                                        '?$`~MaximumDate<!@!>' + 
                                                                        '?$`~Salutation<!@!>';
                                            }
                                        }else {
                                            field.Field_Validations__c = 'isRequired<!@!>true' + 
                                                                        '?$`~isDisabled<!@!>false' + 
                                                                        '?$`~isLabel<!@!>true' + 
                                                                        '?$`~isHelpText<!@!>false' + 
                                                                        '?$`~Label<!@!>' + fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase() + 
                                                                        '?$`~HelpText<!@!>' + 
                                                                        '?$`~isPlaceholder<!@!>false' + 
                                                                        '?$`~Placeholder<!@!>' + 
                                                                        '?$`~Minimum<!@!>0' + 
                                                                        '?$`~Maximum<!@!>128' + 
                                                                        '?$`~isPrefix<!@!>false' + 
                                                                        '?$`~Prefix<!@!>' + 
                                                                        '?$`~Decimal<!@!>' + 
                                                                        '?$`~Richtext<!@!>' + 
                                                                        '?$`~MinimumTime<!@!>' + 
                                                                        '?$`~MaximumTime<!@!>' + 
                                                                        '?$`~MinimumDateTime<!@!>' + 
                                                                        '?$`~MaximumDateTime<!@!>' + 
                                                                        '?$`~MinimumDate<!@!>' + 
                                                                        '?$`~MaximumDate<!@!>' + 
                                                                        '?$`~Salutation<!@!>';
                                        }
                                    }
                                    fields.add(field);
                                }
                            } else if (fieldName == 'AccountId'){
                                if (type == 'Asset' || type == 'Order'){
                                    Position = Position + 1;
                                    Form_Fields__c field = new Form_Fields__c();
                                    field.Mapped_Obj__c = type;
                                    String Label = '';
                                    field.Field_Mapping__c = fieldMap.get(fieldName) + '<!@!>' + type;
                                    field.Name = 'Account ID' + ',' + 'REFERENCE' + ',isrequired';
                                    field.Field_Label__c = 'Name';
                                    Label = field.Field_Label__c;
                                    field.Form__c = FormDetail.Id;
                                    field.Form_Page__c = page_Id.Id;
                                    field.Field_Order__c = Position + 1;
                                    field.Field_Validations__c = 'isRequired<!@!>true' + 
                                                             '?$`~isDisabled<!@!>false' + 
                                                             '?$`~isLabel<!@!>true' + 
                                                             '?$`~isHelpText<!@!>false' + 
                                                             '?$`~Label<!@!>' + fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase() + 
                                                             '?$`~HelpText<!@!>' + 
                                                             '?$`~isPlaceholder<!@!>false' + 
                                                             '?$`~Placeholder<!@!>' + 
                                                             '?$`~Minimum<!@!>0' + 
                                                             '?$`~Maximum<!@!>128' + 
                                                             '?$`~isPrefix<!@!>false' + 
                                                             '?$`~Prefix<!@!>' + 
                                                             '?$`~Decimal<!@!>' + 
                                                             '?$`~Richtext<!@!>' + 
                                                             '?$`~MinimumTime<!@!>' + 
                                                             '?$`~MaximumTime<!@!>' + 
                                                             '?$`~MinimumDateTime<!@!>' + 
                                                             '?$`~MaximumDateTime<!@!>' + 
                                                             '?$`~MinimumDate<!@!>' + 
                                                             '?$`~MaximumDate<!@!>' + 
                                                             '?$`~Salutation<!@!>';
                                    fields.add(field);
                                }
                            } else if (fieldName == 'StartDateTime' || fieldName == 'EndDateTime'){
                                if (type == 'Event'){
                                    String leb;
                                    if (fieldName == 'StartDateTime'){
                                        leb = 'Start Date Time';
                                    } else{
                                        leb = 'End Date Time';
                                    }
                                    Position = Position + 1;
                                    Form_Fields__c field = new Form_Fields__c();
                                    field.Mapped_Obj__c = type;
                                    String Label = '';
                                    field.Field_Mapping__c = fieldMap.get(fieldName) + '<!@!>' + type;
                                    field.Name = leb + ',' + 'DATETIME' + ',isrequired';
                                    field.Field_Label__c = leb;
                                    Label = field.Field_Label__c;
                                    field.Form__c = FormDetail.Id;
                                    field.Form_Page__c = page_Id.Id;
                                    field.Field_Order__c = Position + 1;
                                    field.Field_Validations__c = 'isRequired<!@!>true' + 
                                                             '?$`~isDisabled<!@!>false' + 
                                                             '?$`~isLabel<!@!>true' + 
                                                             '?$`~isHelpText<!@!>false' + 
                                                             '?$`~Label<!@!>' + fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase() + 
                                                             '?$`~HelpText<!@!>' + 
                                                             '?$`~isPlaceholder<!@!>false' + 
                                                             '?$`~Placeholder<!@!>' + 
                                                             '?$`~Minimum<!@!>0' + 
                                                             '?$`~Maximum<!@!>128' + 
                                                             '?$`~isPrefix<!@!>false' + 
                                                             '?$`~Prefix<!@!>' + 
                                                             '?$`~Decimal<!@!>' + 
                                                             '?$`~Richtext<!@!>' + 
                                                             '?$`~MinimumTime<!@!>' + 
                                                             '?$`~MaximumTime<!@!>' + 
                                                             '?$`~MinimumDateTime<!@!>' + 
                                                             '?$`~MaximumDateTime<!@!>' + 
                                                             '?$`~MinimumDate<!@!>' + 
                                                             '?$`~MaximumDate<!@!>' + 
                                                             '?$`~Salutation<!@!>';
                                    fields.add(field);
                                }
                            }
                        }                     
                        iteration = iteration + 1;
                    }                    

                    if (Schema.sObjectType.Form_Fields__c.fields.Field_Label__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Mapped_Obj__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Name.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Form__c.IsCreateable()){
                        insert fields;                        
                    }
                }
            }
            
        } catch (Exception e){
            error_handler.insert_errordata(e, 'objectSelection', 'setReqFieldsRecords');
        }
    }
}