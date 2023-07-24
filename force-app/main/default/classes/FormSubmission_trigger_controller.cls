public with sharing class FormSubmission_trigger_controller {

    public static void lookupcreation(Form_Submission__c formsubmission) {
        Map<Id, Form_Submission__c> formsubmitted = new Map<Id, Form_Submission__c>();
        Map<Id, Id> form_for_submissionId = new Map<Id, Id>();
        Map<String,Object> mapoffirstObject = new Map<String,Object>();
        Map<String,Object> mapofsecondObject = new Map<String,Object>();
        Map<String,Object> mapofthirdObject = new Map<String,Object>();
        Set<Id> form_Id = new Set<Id>();
        String firstobject;
        String secondobject;
        String thirdobject;

        // for (Form_Submission__c formsubmission : formsubmissions) {
            formsubmitted.put(formsubmission.Id, formsubmission);
            form_Id.add(formsubmission.Form__c);
            form_for_submissionId.put(formsubmission.Form__c,formsubmission.Id);
        // }
        Map<Id, Form__c> formlist = new Map<Id, Form__c>([SELECT Id,Mapped_Objects__c FROM Form__c WHERE Id IN: form_Id]);
        
        // for (Form_Submission__c formsubmission : formsubmissions) {
            mapoffirstObject = (Map<String, Object>)JSON.deserializeUntyped(formsubmission.First_object_data__c);
            firstobject = mapoffirstObject.get('sobjectType');
            if (formlist.get(formsubmission.Form__c).Mapped_Objects__c.split(',').size() == 2) {
                
                mapofsecondObject = (Map<String, Object>)JSON.deserializeUntyped(formsubmission.Second_object_data__c);
                secondobject = mapofsecondObject.get('sobjectType');
                String queryStr='SELECT Id FROM ' + firstobject + 'Order By CreatedDate Desc LIMIT 1';
                SObject firstobjectrecord = Database.query(queryStr);
                
                Map<String, Schema.SObjectType> objectTypes = Schema.getGlobalDescribe();
                Schema.SObjectType objectType = objectTypes.get(secondobject);
                Map<String, Schema.SObjectField> fields = objectType.getDescribe().fields.getMap();
                String lookupFields;
                for (String fieldName : fields.keySet()){
                    Schema.DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();
                    if (fieldDescribe.getType() == Schema.DisplayType.REFERENCE){
                        if (fieldDescribe.getReferenceTo()[0].getDescribe().getName() == minobj){
                            if (fieldDescribe.getRelationshipName() == minobj){
                                if (fsubobj == 'Task' || fsubobj == 'Event'){
                                    if (fieldDescribe.getName() != 'AccountId'){
                                        lookupFields = fieldDescribe.getName();
                                    }
                                } else{
                                    lookupFields = fieldDescribe.getName();
                                }
                            }
                        }
                    }
                }

                String queryStr='SELECT Id '+lookupFields+' FROM ' + firstobject + 'Order By CreatedDate Desc LIMIT 1';
                SObject firstobjectrecord = Database.query(queryStr);
                

            } else if (formlist.get(formsubmission.Form__c).Mapped_Objects__c.split(',').size() == 3) {
                mapofsecondObject = (Map<String, Object>)JSON.deserializeUntyped(formsubmission.Second_object_data__c);
                mapofthirdObject = (Map<String, Object>)JSON.deserializeUntyped(formsubmission.Third_object_data__c);
                secondobject = mapofsecondObject.get('sobjectType');
                thirdobject = mapofthirdObject.get('sobjectType');
            }
        // }
    }
}