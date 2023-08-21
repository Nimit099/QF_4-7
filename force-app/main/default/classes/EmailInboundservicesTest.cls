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

        Form__c testForm5 = new Form__c(Name = 'Test4');
        insert testForm5;

        Notification__c testNotification = new Notification__c(
            Form__c = testForm4.Id,
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
        sub.First_object_data__c  = '{"sobjectType":"Contact","LastName":"Testing","MobilePhone":"12032","Birthdate":"2002-12-3", "HasOptedOutOfEmail":"true","HasOptedOutOfFax":"false"}';
        sub.Second_object_data__c  = '{"sobjectType":"Opportunity","Name":"Testing","Amount":"12032","CloseDate":"2002-12-3","StageName":"Prospecting","IsPrivate":"True"}';
        sub.Third_object_data__c  = '{"sobjectType":"Attachment","Name":"New","Body":"XXXX","IsPrivate":"True"}';
        sub.Other_fields_data__c = '{}';
        insert sub;

        Form_Submission__c sub1 = new Form_Submission__c();
        sub1.Form__c = testForm2.ID;
        sub1.First_object_data__c  = '{"sobjectType":"Contact","LastName":"Testing", "MobilePhone":"12032","Birthdate":"2002-12-3", "HasOptedOutOfEmail":"true","HasOptedOutOfFax":"false"}';
        sub1.Second_object_data__c  = '{"sobjectType":"Attachment","Name":"New","Body":"XXXX", "IsPrivate":"false"}';
        sub1.Third_object_data__c = '{}';
        sub1.Other_fields_data__c = '{}';
        insert sub1;

        Form_Submission__c sub2 = new Form_Submission__c();
        sub2.Form__c = testForm3.ID;
        sub2.First_object_data__c  = '{"sobjectType":"Opportunity","Name":"Testing", "Amount":"12032","IqScore":"20", "CloseDate":"2002-12-3","StageName":"Prospecting","IsPrivate":"True"}';
        sub2.Second_object_data__c  = '{"sobjectType":"Opportunity","Name":"Testing", "Amount":"12032","IqScore":"20", "CloseDate":"2002-12-3","StageName":"Prospecting","IsPrivate":"false","CreatedDate":"2023-07-25T00:45:00.000+0000"}';
        sub2.Third_object_data__c  = '{}';
        sub2.Other_fields_data__c = '{}';
        insert sub2;

        Form_Submission__c sub3 = new Form_Submission__c();
        sub3.Form__c = testForm4.Id;
        sub3.First_object_data__c  = '{"sobjectType":"Event","EndDateTime":"2023-07-25T00:45:00.000+0000","StartDateTime":"2023-07-25T00:45:00.000+0000","IsPrivate":"True","Description":"Test"}';
        sub3.Second_object_data__c  = '{"sobjectType":"Attachment","Name":"New","Body":"XXXX", "IsPrivate":"True"}';
        sub3.Third_object_data__c  = '{"sobjectType":"Opportunity","Name":"Testing", "Amount":"12032", "CloseDate":"2002-12-3","StageName":"Prospecting","IsPrivate":"false"}';
        sub3.Other_fields_data__c = '{}';
        insert sub3;

         Form_Submission__c sub4 = new Form_Submission__c();
        sub4.Form__c = testForm5.Id;
        sub4.First_object_data__c  = '{"sobjectType":"Account","AnnualRevenue":"123","NumberOfEmployees":"34","Name":"Test" }';
        sub4.Second_object_data__c  = '{"sobjectType":"Event","EndDateTime":"2023-07-25T00:45:00.000+0000","StartDateTime":"2023-07-25T00:45:00.000+0000","IsPrivate":"True","Description":"Test"}';
        sub4.Third_object_data__c  = '{"sobjectType":"Event","EndDateTime":"2023-07-25T00:45:00.000+0000","StartDateTime":"2023-07-25T00:45:00.000+0000","IsPrivate":"True","Description":"Test"}';
        sub4.Other_fields_data__c = '{}';
        insert sub4;


    }

         /** @description wrapformsubmission class */
    public class wrapformsubmission{

        /** @description acc - Form_Submission_Record record as value */
      public Form_Submission__c acc {get;set;}

       /** @description sig_upload_jsone - String of Base64 as value */
      public String sig_upload_jsone {get;set;}

       /** @description sig_upload_fid_list - List of String as value */
      public List<String> sig_upload_fid_list {get;set;}

       /** @description file_upload_jsone - String of Base64 as value */
      public String file_upload_jsone {get;set;}

       /** @description file_upload_fid_list - List of String as value */
      public List<String> file_upload_fid_list {get;set;}

       /** @description create_chi - Boolean to check create child as value */
      public Boolean create_chi {get;set;}

       /** @description lookup_list - List of String as value */
      public List<String> lookup_list {get;set;}

       /** @description create_chi_2 -Boolean to check create child as value */
      public Boolean create_chi_2 {get;set;}

       /** @description lookup_list2 - List of String as value */
      public List<String> lookup_list2 {get;set;}

       /** @description base64att - String of Base64 as value */
      public String base64att {get;set;}

       /** @description ObjectCount - Integer as value */
      public Integer ObjectCount {get; set;}

       /** @description SubId - Submission Id as value */
      public Id SubId {get; set;}

   }
    
        @isTest
        public  static void createrecordTest() {
            Test.startTest();

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
                    wrapper.create_chi = true;
                    wrapper.create_chi_2 = true;

                Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
                testEmail.subject = 'Test Email';
                testEmail.plainTextBody = JSON.serialize(wrapper);


                EmailInboundservices emailHandler = new EmailInboundservices();
                Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);
                System.assert( result == null, 'Success');
            Test.stopTest();
        }

        @isTest
        public  static void createrecord1Test() {
            Test.startTest();

                Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test3' ];


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
                    wrapper.create_chi = true;
                    wrapper.create_chi_2 = true;

                Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
                testEmail.subject = 'Test Email';
                testEmail.plainTextBody = JSON.serialize(wrapper);

                EmailInboundservices emailHandler = new EmailInboundservices();
                Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);

                System.assert( result != null, 'Success');
            Test.stopTest();
        }

        @isTest
        public  static void createrecord_for_secnd_objectTest1() {
            Test.startTest();

                Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test1' ];


                String sigUploadJsone = '{"signature1":"abc123"}';
                String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
                List<String> sigUploadFidList = new List<String>{'signature1'};
                List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};
                List<String> lookup_list = new List<String>();
                List<String> lookup_list2 = new List<String>();
                lookup_list.add('ParentId');
                lookup_list2.add('');

                    wrapformsubmission wrapper = new wrapformsubmission();
                    wrapper.acc = testformsub;
                    wrapper.sig_upload_jsone = sigUploadJsone;
                    wrapper.sig_upload_fid_list = sigUploadFidList;
                    wrapper.file_upload_jsone = fileUploadJsone;
                    wrapper.file_upload_fid_list = fileUploadFidList;
                    wrapper.ObjectCount = 2;
                    wrapper.SubId = testformsub.Id;
                    wrapper.create_chi = true;
                    wrapper.create_chi_2 = true;
                    wrapper.lookup_list = lookup_list;
                    wrapper.lookup_list2 = lookup_list2;

                Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
                testEmail.subject = 'Test Email';
                testEmail.plainTextBody = JSON.serialize(wrapper);

                EmailInboundservices emailHandler = new EmailInboundservices();
                Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);

                System.assert( result == null, 'Success');
            Test.stopTest();
        }

        @isTest
        public  static void createrecord_for_secnd_objectTest() {
            Test.startTest();

                Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test' ];


                String sigUploadJsone = '{"signature1":"abc123"}';
                String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
                List<String> sigUploadFidList = new List<String>{'signature1'};
                List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};
                List<String> lookup_list = new List<String>();
                List<String> lookup_list2 = new List<String>();
                lookup_list.add('ContactId');
                lookup_list2.add('ParentId');
                

                    wrapformsubmission wrapper = new wrapformsubmission();
                    wrapper.acc = testformsub;
                    wrapper.sig_upload_jsone = sigUploadJsone;
                    wrapper.sig_upload_fid_list = sigUploadFidList;
                    wrapper.file_upload_jsone = fileUploadJsone;
                    wrapper.file_upload_fid_list = fileUploadFidList;
                    wrapper.ObjectCount = 2;
                    wrapper.SubId = testformsub.Id;
                    wrapper.create_chi = true;
                    wrapper.create_chi_2 = true;
                    wrapper.lookup_list = lookup_list;
                    wrapper.lookup_list2 = lookup_list2;

                Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
                testEmail.subject = 'Test Email';
                testEmail.plainTextBody = JSON.serialize(wrapper);

                EmailInboundservices emailHandler = new EmailInboundservices();
                Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);

                System.assert( result == null, 'Success');
            Test.stopTest();
        }


        @isTest
        public  static void createrecord_for_third_objectTest() {
            Test.startTest();

                Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test' ];

                List<String> lookup_list = new List<String>();
                List<String> lookup_list2 = new List<String>();
                lookup_list.add('ContactId');
                lookup_list2.add('ParentId');

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
                    wrapper.lookup_list = lookup_list;
                    wrapper.lookup_list2 = lookup_list2;

                Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
                testEmail.subject = 'Test Email';
                testEmail.plainTextBody = JSON.serialize(wrapper);

                EmailInboundservices emailHandler = new EmailInboundservices();
                Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);

                System.assert( result == null, 'Success');
            Test.stopTest();
        }

        @isTest
        public  static void createrecord2Test() {
            Test.startTest();

                Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test3' ];


                String sigUploadJsone = '{"signature1":"abc123"}';
                String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
                List<String> sigUploadFidList = new List<String>{'signature1'};
                List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};

                List<String> lookup_list = new List<String>();
                List<String> lookup_list2 = new List<String>();
                lookup_list.add('ContactId');
                lookup_list2.add('WhoId');

                    wrapformsubmission wrapper = new wrapformsubmission();
                    wrapper.acc = testformsub;
                    wrapper.sig_upload_jsone = sigUploadJsone;
                    wrapper.sig_upload_fid_list = sigUploadFidList;
                    wrapper.file_upload_jsone = fileUploadJsone;
                    wrapper.file_upload_fid_list = fileUploadFidList;
                    wrapper.ObjectCount = 2;
                    wrapper.SubId = testformsub.Id;
                    wrapper.create_chi = false;
                    wrapper.create_chi_2 = true;
                    wrapper.lookup_list = lookup_list;
                    wrapper.lookup_list2 = lookup_list2;

                Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
                testEmail.subject = 'Test Email';
                testEmail.plainTextBody = JSON.serialize(wrapper);

                EmailInboundservices emailHandler = new EmailInboundservices();
                Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);
                System.assert( result == null, 'Success');
                Test.stopTest();
        }

        @isTest
        public  static void createrecord3Test() {
            Test.startTest();

                Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test3' ];


                String sigUploadJsone = '{"signature1":"abc123"}';
                String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
                List<String> sigUploadFidList = new List<String>{'signature1'};
                List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};
                List<String> lookup_list = new List<String>();
                List<String> lookup_list2 = new List<String>();

                lookup_list.add('ContactId');
                lookup_list2.add('WhoId');

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
                    wrapper.lookup_list = lookup_list;
                    wrapper.lookup_list2 = lookup_list2;

                Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
                testEmail.subject = 'Test Email';
                testEmail.plainTextBody = JSON.serialize(wrapper);

                EmailInboundservices emailHandler = new EmailInboundservices();
                Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);

                System.assert( result == null, 'Success');
            Test.stopTest();
        }


        @isTest
        public  static void createrecord4Test() {
            Test.startTest();

                Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test2' ];


                String sigUploadJsone = '{"signature1":"abc123"}';
                String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
                List<String> sigUploadFidList = new List<String>{'signature1'};
                List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};
                List<String> lookup_list = new List<String>();
                List<String> lookup_list2 = new List<String>();

                lookup_list.add('ContactId');
                lookup_list2.add('WhoId');

                    wrapformsubmission wrapper = new wrapformsubmission();
                    wrapper.acc = testformsub;
                    wrapper.sig_upload_jsone = sigUploadJsone;
                    wrapper.sig_upload_fid_list = sigUploadFidList;
                    wrapper.file_upload_jsone = fileUploadJsone;
                    wrapper.file_upload_fid_list = fileUploadFidList;
                    wrapper.ObjectCount = 1;
                    wrapper.SubId = testformsub.Id;
                    wrapper.create_chi = true;
                    wrapper.create_chi_2 = true;
                    wrapper.lookup_list = lookup_list;
                    wrapper.lookup_list2 = lookup_list2;

                Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
                testEmail.subject = 'Test Email';
                testEmail.plainTextBody = JSON.serialize(wrapper);

                EmailInboundservices emailHandler = new EmailInboundservices();
                Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);

                System.assert( result == null, 'Success');
            Test.stopTest();
        }

        @isTest
        public  static void createrecord_for_secod2_Test() {
            Test.startTest();

                Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test2' ];


                String sigUploadJsone = '{"signature1":"abc123"}';
                String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
                List<String> sigUploadFidList = new List<String>{'signature1'};
                List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};
                List<String> lookup_list = new List<String>();
                List<String> lookup_list2 = new List<String>();

                lookup_list.add('ContactId');
                lookup_list2.add('WhoId');

                    wrapformsubmission wrapper = new wrapformsubmission();
                    wrapper.acc = testformsub;
                    wrapper.sig_upload_jsone = sigUploadJsone;
                    wrapper.sig_upload_fid_list = sigUploadFidList;
                    wrapper.file_upload_jsone = fileUploadJsone;
                    wrapper.file_upload_fid_list = fileUploadFidList;
                    wrapper.ObjectCount = 2;
                    wrapper.SubId = testformsub.Id;
                    wrapper.create_chi = true;
                    wrapper.create_chi_2 = true;
                    wrapper.lookup_list = lookup_list;
                    wrapper.lookup_list2 = lookup_list2;

                Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
                testEmail.subject = 'Test Email';
                testEmail.plainTextBody = JSON.serialize(wrapper);

                EmailInboundservices emailHandler = new EmailInboundservices();
                Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);
                System.assert( result == null, 'Success');
            Test.stopTest();
        }


        @isTest
        public  static void createrecord5Test() {
            Test.startTest();

                Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test4' ];


                String sigUploadJsone = '{"signature1":"abc123"}';
                String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
                List<String> sigUploadFidList = new List<String>{'signature1'};
                List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};

                List<String> lookup_list = new List<String>();
                List<String> lookup_list2 = new List<String>();
                lookup_list.add('ContactId');
                lookup_list2.add('WhoId');

                    wrapformsubmission wrapper = new wrapformsubmission();
                    wrapper.acc = testformsub;
                    wrapper.sig_upload_jsone = sigUploadJsone;
                    wrapper.sig_upload_fid_list = sigUploadFidList;
                    wrapper.file_upload_jsone = fileUploadJsone;
                    wrapper.file_upload_fid_list = fileUploadFidList;
                    wrapper.ObjectCount = 2;
                    wrapper.SubId = testformsub.Id;
                    wrapper.create_chi = false;
                    wrapper.create_chi_2 = true;
                    wrapper.lookup_list = lookup_list;
                    wrapper.lookup_list2 = lookup_list2;

                Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
                testEmail.subject = 'Test Email';
                testEmail.plainTextBody = JSON.serialize(wrapper);

                EmailInboundservices emailHandler = new EmailInboundservices();
                Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);
                System.assert( result != null, 'Success');
            Test.stopTest();
        }

         @isTest
        public  static void createrecord_for_third_objectTest1() {
            Test.startTest();

                Form_Submission__c testformsub = [SELECT Id, First_object_data__c,Second_object_data__c,Other_fields_data__c,Third_object_data__c,Form__c FROM Form_Submission__c WHERE Form__r.Name = 'Test4' ];


                String sigUploadJsone = '{"signature1":"abc123"}';
                String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
                List<String> sigUploadFidList = new List<String>{'signature1'};
                List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};

                List<String> lookup_list = new List<String>();
                List<String> lookup_list2 = new List<String>();
                lookup_list.add('ContactId');
                lookup_list2.add('WhoId');

                    wrapformsubmission wrapper = new wrapformsubmission();
                    wrapper.acc = testformsub;
                    wrapper.sig_upload_jsone = sigUploadJsone;
                    wrapper.sig_upload_fid_list = sigUploadFidList;
                    wrapper.file_upload_jsone = fileUploadJsone;
                    wrapper.file_upload_fid_list = fileUploadFidList;
                    wrapper.ObjectCount = 3;
                    wrapper.SubId = testformsub.Id;
                    wrapper.create_chi = false;
                    wrapper.create_chi_2 = true;
                    wrapper.lookup_list = lookup_list;
                    wrapper.lookup_list2 = lookup_list2;

                Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
                testEmail.subject = 'Test Email';
                testEmail.plainTextBody = JSON.serialize(wrapper);

                EmailInboundservices emailHandler = new EmailInboundservices();
                Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);
                System.assert( result == null, 'Success');
            Test.stopTest();
        }
}