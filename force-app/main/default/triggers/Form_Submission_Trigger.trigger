trigger Form_Submission_Trigger on Form_Submission__c (after insert) {
    FormSubmission_trigger_controller.lookupcreation(Trigger.new);
}