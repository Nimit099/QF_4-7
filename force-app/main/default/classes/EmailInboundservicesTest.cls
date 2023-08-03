@isTest
private class EmailInboundservicesTest {

    @TestSetup
    static void makedata(){

        Form__c testForm = new Form__c(Name = 'Test');
        insert testForm;

        Form__c testForm2 = new Form__c(Name = 'Test1');
        insert testForm2;

        Form__c testForm3 = new Form__c(Name = 'Test2');
        insert testForm3;

        Form__c testForm4 = new Form__c(Name = 'Test3');
        insert testForm4;

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
        sub.Second_object_data__c  = '{"sobjectType":"Contact","LastName":"Testing", "MobilePhone":"12032","Birthdate":"'+System.today()+'", "HasOptedOutOfEmail":"true","HasOptedOutOfFax":"false"}';
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

        Form_Submission__c sub2 = new Form_Submission__c();
        sub2.Form__c = testForm3.ID;
        sub2.First_object_data__c  = '{"sobjectType":"Account","Name":"Testing", "AnnualRevenue":"12032","NumberOfEmployees":"20"}';
        sub2.Second_object_data__c  = '{"sobjectType":"Contact","LastName":"Testing", "MobilePhone":"12032","Birthdate":"'+System.today()+'", "HasOptedOutOfEmail":"true","HasOptedOutOfFax":"false"}';
        sub2.Third_object_data__c  = '{"sobjectType":"Contact","LastName":"Testing", "MobilePhone":"12032","Birthdate":"'+System.today()+'", "HasOptedOutOfEmail":"true","HasOptedOutOfFax":"false"}';
        sub2.Other_fields_data__c = '{}';
        insert sub2;

        Form_Submission__c sub3 = new Form_Submission__c();
        sub3.Form__c = testForm4.ID;
        sub3.First_object_data__c  = '{"sobjectType":"Account","Name":"Testing", "AnnualRevenue":"12032","NumberOfEmployees":"20"}';
        sub3.Second_object_data__c  = '{"sobjectType":"Contact","LastName":"Testing", "MobilePhone":"12032","Birthdate":"'+System.today()+'", "HasOptedOutOfEmail":"true","HasOptedOutOfFax":"false"}';
        sub3.Third_object_data__c  = '{"sobjectType":"Opportunity","Name":"New", "CloseDate":"'+System.today()+'", "Stage":"Prospecting", "IsPrivate":"true"}';
        sub3.Other_fields_data__c = '{}';
        insert sub3;

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

    @isTest
    static void testHandleInboundEmail3() {

        Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test2' ];


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
            wrapper.ObjectCount = 3;
            wrapper.SubId = testformsub.Id;
            wrapper.create_chi = true;
            wrapper.create_chi_2 = true;

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
    static void testHandleInboundEmail4() {

        Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test3' ];

        List<String> lookup = new List<String>();
        lookup.add('AccountId');
        List<String> lookup1 = new List<String>();
        lookup1.add('AccountId');
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
            wrapper.ObjectCount = 3;
            wrapper.SubId = testformsub.Id;
            wrapper.create_chi = true;
            wrapper.create_chi_2 = true;
            wrapper.lookup_list = lookup;
            wrapper.lookup_list2 = lookup1;

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