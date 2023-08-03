@isTest
private class EmailInboundservicesTest {

    @TestSetup
    static void makedata(){

        Form__c testForm = new Form__c(Name = 'Test');
        insert testForm;

        Form__c testForm2 = new Form__c(Name = 'Test1');
        insert testForm2;


        Notification__c testNotification = new Notification__c(
            Form__c = testForm.Id,
            To_Recipients__c = 'test1@example.com,test2@example.com',
            CC_Recipients__c = 'test3@example.com',
            BCC_Recipients__c = 'test4@example.com',
            Subject__c = 'Test Subject',
            Email_Body__c = 'Test Body',
            Attachment__c = true,
            Status__c = true
        );
        insert testNotification;

        Form_Submission__c sub = new Form_Submission__c();
        sub.Form__c = testForm.ID;
        sub.First_object_data__c  = '{"sobjectType":"Account","Name":"Testing", "AnnualRevenue":"12032","NumberOfEmployees":"20"}';
        sub.Second_object_data__c  = '{"sobjectType":"Contact","LastName":"Testing", "MobilePhone":"12032","Birthdate":"'+System.today()+'", "HasOptedOutOfEmail":"true","LastCURequestDate":"'+System.now()+'","HasOptedOutOfFax":"false"}';
        sub.Third_object_data__c  = '{"sobjectType":"Case","Status":"New"}';
        sub.Other_fields_data__c = '{}';
        insert sub;

        Form_Submission__c sub1 = new Form_Submission__c();
        sub1.Form__c = testForm2.ID;
        sub1.First_object_data__c  = '{"sobjectType":"Contact","LastName":"Testing", "MobilePhone":"12032","Birthdate":"'+System.today()+'", "HasOptedOutOfEmail":"true","LastCURequestDate":"'+System.now()+'","HasOptedOutOfFax":"false"}';
        sub1.Second_object_data__c  = '{}';
        sub1.Third_object_data__c = '{}';
        sub1.Other_fields_data__c = '{}';
        insert sub1;

    }
        public class wrapformsubmission{
            public Form_Submission__c acc {get;set;}
            public String sig_upload_jsone {get;set;}
            public List<String> sig_upload_fid_list {get;set;}
            public String file_upload_jsone {get;set;}
            public List<String> file_upload_fid_list {get;set;}
            public Boolean create_chi {get;set;}
            public List<String> lookup_list {get;set;}
            public Boolean create_chi_2 {get;set;}
            public List<String> lookup_list2 {get;set;}
            public String base64att {get;set;}
            public Integer ObjectCount {get; set;}
            public Id SubId {get; set;}
        }
    
    @isTest
    static void testHandleInboundEmail() {

        Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test' ];


        String sigUploadJsone = '{"signature1":"abc123"}';
        String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
        List<String> sigUploadFidList = new List<String>{'signature1'};
        List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};

            wrapformsubmission wrapper = new wrapformsubmission();
            wrapper.acc = testformsub;
            wrapper.sig_upload_jsone = sigUploadJsone;
            wrapper.sig_upload_fid_list = sigUploadFidList;
            wrapper.file_upload_jsone = fileUploadJsone;
            wrapper.file_upload_fid_list = fileUploadFidList;
            wrapper.ObjectCount = 1;
            wrapper.SubId = testformsub.Id;

        Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
        testEmail.subject = 'Test Email';
        testEmail.plainTextBody = JSON.serialize(wrapper);

        Test.startTest();

        EmailInboundservices emailHandler = new EmailInboundservices();
        Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);

        // System.assertEquals(true, result.success);

        Test.stopTest();
    }


     @isTest
    static void testHandleInboundEmail1() {

        Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test1' ];


        String sigUploadJsone = '{"signature1":"abc123"}';
        String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
        List<String> sigUploadFidList = new List<String>{'signature1'};
        List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};

            wrapformsubmission wrapper = new wrapformsubmission();
            wrapper.acc = testformsub;
            wrapper.sig_upload_jsone = sigUploadJsone;
            wrapper.sig_upload_fid_list = sigUploadFidList;
            wrapper.file_upload_jsone = fileUploadJsone;
            wrapper.file_upload_fid_list = fileUploadFidList;
            wrapper.ObjectCount = 1;
            wrapper.SubId = testformsub.Id;

        Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
        testEmail.subject = 'Test Email';
        testEmail.plainTextBody = JSON.serialize(wrapper);

        Test.startTest();

        EmailInboundservices emailHandler = new EmailInboundservices();
        Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);

        // System.assertEquals(true, result.success);

        Test.stopTest();
    }

  @isTest
    static void testHandleInboundEmail2() {

        Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test' ];


        String sigUploadJsone = '{"signature1":"abc123"}';
        String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
        List<String> sigUploadFidList = new List<String>{'signature1'};
        List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};

            wrapformsubmission wrapper = new wrapformsubmission();
            wrapper.acc = testformsub;
            wrapper.sig_upload_jsone = sigUploadJsone;
            wrapper.sig_upload_fid_list = sigUploadFidList;
            wrapper.file_upload_jsone = fileUploadJsone;
            wrapper.file_upload_fid_list = fileUploadFidList;
            wrapper.ObjectCount = 2;
            wrapper.SubId = testformsub.Id;

        Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
        testEmail.subject = 'Test Email';
        testEmail.plainTextBody = JSON.serialize(wrapper);

        Test.startTest();

        EmailInboundservices emailHandler = new EmailInboundservices();
        Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);

        // System.assertEquals(true, result.success);

        Test.stopTest();
    }

}