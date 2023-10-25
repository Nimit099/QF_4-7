/**
 * @description fieldvalidation Class
 */

public with sharing class fieldvalidation {
    /**
    * @description : fieldvalidation class
    * @param fieldId Id value.
    * @return fieldvalidationwrapper
    */
   @AuraEnabled
   public static fieldvalidationwrapper getfieldvalidation(Id fieldId) {
       try {
            Form_Fields__c fieldvalidation = new Form_Fields__c();
            fieldvalidation = [SELECT Id,Name,Field_Validations__c,Field_Mapping__c FROM Form_Fields__c WHERE Id =: fieldId WITH SECURITY_ENFORCED];
           String obj = fieldvalidation.Field_Mapping__c.split('<!@!>')[1];
           String field = fieldvalidation.Field_Mapping__c.split('<!@!>')[0];
           fieldvalidationwrapper wrapp = new fieldvalidationwrapper();
           if(!fieldvalidation.Name.split(',')[0].Contains('QF')) {
               Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
               Schema.SObjectType leadSchema = schemaMap.get(obj) ;
               Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
               if(fieldvalidation.Name.split(',')[1] == 'CURRENCY' || fieldvalidation.Name.split(',')[1] == 'DOUBLE' || fieldvalidation.Name.split(',')[1] == 'PERCENT') {
                   wrapp.fieldvalidations = fieldvalidation.Field_Validations__c;
                   wrapp.fieldlength = fieldMap.get(field).getDescribe().getPrecision();
               } else if (fieldvalidation.Name.split(',')[1] == 'ENCRYPTEDSTRING' || fieldvalidation.Name.split(',')[1] == 'STRING' ) {
                   wrapp.fieldvalidations = fieldvalidation.Field_Validations__c;
                   wrapp.fieldlength = fieldMap.get(field).getDescribe().getLength();
               } else if(fieldvalidation.Name.split(',')[1] == 'TEXTAREA') {
                   wrapp.fieldvalidations = fieldvalidation.Field_Validations__c;
                   wrapp.fieldlength = fieldMap.get(field).getDescribe().getLength();
                   wrapp.filterable = fieldMap.get(field).getDescribe().isFilterable();
               } else {
                   wrapp.fieldvalidations = fieldvalidation.Field_Validations__c;
                   wrapp.fieldmapping = fieldvalidation.Field_Mapping__c;
                   wrapp.fieldlength = 255;
               }
           } else {
               if(fieldvalidation.Name.split(',')[0] == 'QFNAME') {
                   wrapp.fieldvalidations = fieldvalidation.Field_Validations__c;
                   wrapp.fieldlength = 50;
               } else if(fieldvalidation.Name.split(',')[0] == 'QFSHORTTEXT') {
                   wrapp.fieldvalidations = fieldvalidation.Field_Validations__c;
                   wrapp.fieldlength = 255;
               } else if( fieldvalidation.Name.split(',')[0] == 'QFLONGTEXT') {
                   wrapp.fieldvalidations = fieldvalidation.Field_Validations__c;
                   wrapp.fieldlength = 131072;
               } else if( fieldvalidation.Name.split(',')[0] == 'QFNUMBER' || fieldvalidation.Name.split(',')[0] == 'QFPRICE') {
                   wrapp.fieldvalidations = fieldvalidation.Field_Validations__c;
                   wrapp.fieldlength = 18;
               } else {
                   wrapp.fieldvalidations = fieldvalidation.Field_Validations__c;
                   wrapp.fieldlength = 255;
               }
           }
           return wrapp;
       } catch (Exception e) {
           fieldvalidationwrapper wrapp = new fieldvalidationwrapper();
           wrapp.error = String.valueOf(e);
           return wrapp;
       }
   }

   /**
    * @description :
    * @param fieldId Id value.
    */
   @AuraEnabled
   public static void deletefield(Id fieldId) {
       try {
           Form_Fields__c formFieldToDelete = [SELECT Id FROM Form_Fields__c WHERE Id =: fieldId WITH SECURITY_ENFORCED];
           if (Schema.sObjectType.Form_Fields__c.isDeletable()) {
               delete formFieldToDelete;
           }
       } catch (Exception e) {
           error_handler.insert_errordata(e,'fieldvalidation','deletefield');
       }
   }

   /**
    * @description :
    * @param fieldId Id value.
    * @param fieldValidation String value.
    * @param Label String value.
    */
   @AuraEnabled
   public static void savevalidation(Id fieldId, String fieldValidation,String Label) {
       try {
           fieldValidation = fieldValidation;
           if (Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.isAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.isUpdateable()
               && Schema.sObjectType.Form_Fields__c.fields.Field_Label__c.isAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Label__c.isUpdateable()) {
               Form_Fields__c field = [SELECT Id,Field_Validations__c	FROM Form_Fields__c WHERE Id =: fieldId];
               field.Field_Validations__c = fieldValidation;
               field.Field_Label__c = Label;
               update field;
           }
       } catch (Exception e) {
           error_handler.insert_errordata(e,'fieldvalidation','savevalidation');
       }
   }

   /**
    * @description :
    * @param fieldId Id value.
    */
   @AuraEnabled
   public static void copyfield(Id fieldId) {
        try {
            Form_Fields__c field = [SELECT Id,Field_Label__c,Field_Validations__c,Field_Mapping__c,Field_Order__c,Form__c,Form_Page__c,Name,Mapped_Obj__c FROM Form_Fields__c WHERE Id =: fieldId WITH SECURITY_ENFORCED];
            Form_Fields__c clonefield = new Form_Fields__c ();
            if (String.isNotBlank(field.Field_Validations__c)) {
                clonefield.Field_Validations__c = field.Field_Validations__c;
            }
            if (String.isNotBlank(field.Field_Label__c)) {
                clonefield.Field_Label__c = field.Field_Label__c;
            }
            if (String.isNotBlank(field.Field_Mapping__c)) {
                clonefield.Field_Mapping__c = field.Field_Mapping__c;
            }
            if (String.isNotBlank(String.valueOf(field.Field_Order__c))) {
                clonefield.Field_Order__c = field.Field_Order__c;
            }
            if (String.isNotBlank(field.Form__c)) {
                clonefield.Form__c = field.Form__c;
            }
            if (String.isNotBlank(field.Form_Page__c)) {
                clonefield.Form_Page__c = field.Form_Page__c;
            }
            if (String.isNotBlank(field.Name)) {
                clonefield.Name = field.Name;
            }
            if (String.isNotBlank(field.Mapped_Obj__c)) {
                clonefield.Mapped_Obj__c = field.Mapped_Obj__c;
            }
            if (Schema.sObjectType.Form_Fields__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.isCreateable() 
            && Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.isCreateable()
            && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Form__c.isCreateable()
            && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Name.isCreateable()
            && Schema.sObjectType.Form_Fields__c.fields.Mapped_Obj__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Label__c.isCreateable()) {
                insert clonefield;
            }
       } catch (Exception e) {
           error_handler.insert_errordata(e,'fieldvalidation','copyfield');
       }
   }

   /**
    * @description :
    * @return : 
    */
   public class fieldvalidationwrapper {
       /** @description : fieldvalidations String*/
       @AuraEnabled
       public string fieldvalidations{get; set;}

       /** @description : fieldlength Integer */
       @AuraEnabled
       public Integer fieldlength{get; set;}

       /** @description : error String */
       @AuraEnabled
       public String error{get; set;}

       /** @description : filterable Boolean*/
       @AuraEnabled
       public Boolean filterable{get; set;}

       /** @description : fieldmapping String*/
       @AuraEnabled
       public String fieldmapping{get; set;}
   }
}