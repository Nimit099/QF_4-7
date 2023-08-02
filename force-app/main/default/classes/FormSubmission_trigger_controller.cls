public with sharing class FormSubmission_trigger_controller {

    public static void lookupcreation(List<Form_Submission__c> formsubmissions) {
      Map<Id, Form_Submission__c> formsubmitted = new Map<Id, Form_Submission__c>();
      Map<Id, Id> form_for_submissionId = new Map<Id, Id>();
    //   Map<Id, Form__c> formlist = new Map<Id, Form__c>();
      Set<Id> form_Id = new Set<Id>();

      for (Form_Submission__c formsubmission : formsubmissions) {
        formsubmitted.put(formsubmission.Id, formsubmission);
        form_Id.add(formsubmission.Form__c);
        form_for_submissionId.put(formsubmission.Form__c,formsubmission.Id);
      }
      Map<Id, Form__c> formlist = new Map<Id, Form__c>([SELECT Id,Mapped_Objects__c FROM Form__c WHERE Id IN: form_Id]);
        // formlist = [SELECT Id,Mapped_Objects__c FROM Form__c WHERE Id IN: form_Id];

        for (Form_Submission__c formsubmission : formsubmissions) {
            if (formlist.get(formsubmission.Form__c).Mapped_Objects__c.split(',').size() == 2) {
                Map<String,Object> mapofsecondObject = new Map<String,Object>();
                mapofsecondObject = (Map<String, Object>)JSON.deserializeUntyped(formsubmission.Second_object_data__c);
                System.debug(mapofsecondObject.get('sobjectType'));
            } else if (formlist.get(formsubmission.Form__c).Mapped_Objects__c.split(',').size() == 3) {

            }
        }
    }
}