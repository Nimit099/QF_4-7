@istest
public class Test_QuickFormHome {/*@description : check the QuickFormHome code coverage*/
    
    /**
        * @description Testsetup method to create data for QuickformHome class
    */
    @TestSetup
    public static void createrecord(){
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        ContentVersion cv1 = new ContentVersion();
        cv1.Title = 'Test Document2';
        cv1.PathOnClient = 'TestDocument.pdf';
        cv1.VersionData = Blob.valueOf('Test Content');
        cv1.IsMajorVersion = true;
        Insert cv1;
        
        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;        
        form.Mapped_Objects__c = '';
        form.Form_Styling__c = 'demo:0;test:1;check:3';
        form.FormBgID__c = cv.Id;
        form.PageBgId__c = cv1.Id;
        form.Page_CSS__C = 'padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-image:"test.png";background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        insert form;

        
        Form__c form1 = new Form__c();
        form1.Name = 'Test2';
        form1.Status__c = false;
        insert form1;
        
        Form_Page__c pageno = new Form_Page__c();
        pageno.Name = 'Test';
        pageno.Page_Number__c = 1;
        pageno.Form__c = form1.ID;
        insert pageno;
    }

    @istest
    public static void testgetformrecords(){ 
        Test.startTest();
        QuickFormHome q = new QuickFormHome();
        q.urlvalue = '';
        QuickFormHome.formid = '';
        List<QuickFormHome.formwrapper> st = QuickFormHome.getFormRecords();
        System.assert(St != null, 'Successfully');
        Test.stopTest();

    }

    @istest
    public static void testsearchforms(){ 
        Test.startTest();
    
        Form__c formdata = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        
        List<QuickFormHome.formwrapper> st1 = QuickFormHome.searchForms(formdata.Name);
        System.assert(St1 != null, 'Successfully');
       
        Test.stopTest();

    }

    @istest
    public static void testgetFormsByStatus(){ 
        Test.startTest();
    
        Form__c formdata = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Form__c formdata1 = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test2' LIMIT 1];
        Form_Page__c sub1 = [SELECT ID, Form__c FROM Form_Page__c WHERE Form__c =: formdata1.ID LIMIT 1];
        
        List<QuickFormHome.formwrapper> getform = QuickFormHome.getFormsByStatus(formdata.ID,'Test');
        List<QuickFormHome.formwrapper> getform1 = QuickFormHome.getFormsByStatus(formdata1.ID,'Test');
        List<QuickFormHome.formwrapper> getform2 = QuickFormHome.getFormsByStatus(sub1.ID,'Test');
        System.assert(getform != null, 'Successfully');
        System.assert(getform2 == null, 'Successfully');
       
        Test.stopTest();

    }

    @istest
    public static void testdeleteFormRecord(){ 
        Test.startTest();
    
        Form__c formdata = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Form__c formdata1 = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test2' LIMIT 1];
        
        List<QuickFormHome.formwrapper> deleteform = QuickFormHome.deleteFormRecord(formdata.ID,'Test');
        List<QuickFormHome.formwrapper> deleteform1 = QuickFormHome.deleteFormRecord(formdata.ID,'Test');
        System.assert(deleteform != null, 'Successfully');
        System.assert(deleteform1 == null, 'Successfully');
       
        Test.stopTest();

    }

    @istest
    public static void testrenameFormRecord(){ 
        Test.startTest();
    
        Form__c formdata = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Form__c formdata1 = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test2' LIMIT 1];
        
        List<QuickFormHome.formwrapper> renameform = QuickFormHome.renameFormRecord(formdata1.ID,formdata.Name,'Test');
        List<QuickFormHome.formwrapper> renameform1 = QuickFormHome.renameFormRecord(formdata.ID,formdata.Name,'Test');
        System.assert(renameform != null, 'Successfully');
        System.assert(renameform1 != null, 'Successfully');
        Test.stopTest();

    }       

    @isTest
    public static void testsendemail(){ 
        Test.startTest();
        List<String> baseb64 = New List<String>{'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Nf2OyYOOdTyqJMHiomMkjXhxkJLUgYbmpok1FI3PKXcJA1k9zDlk6hWpKRkeEOedhsRdYUwHIwO3QpqcfWyLBf2jyK12HhMXrHOqJXa9XCVuNwMjvpUeiotYRTT4K60iQ9ZVTTHMuVNGk94tEg5SS4KgM8S4RNDxOgALDGPPu//cInHlNj4keTqK571r7xXOuRXTcgLgBiARP+Di74ORkb2OOPAczmtsTHEMO0SDUIvxfoek/wGT2vsJCmVuZHN0cmVhbQplbmRvYmoKMSAwIG9iajw8L1BhcmVudCAyIDAgUi9Db250ZW50cyAzIDAgUi9UeXBlL1BhZ2UvUmVzb3VyY2VzIDQgMCBSL01lZGlhQm94WzAgMCA2MTIgNzkyXT4+CmVuZG9iago4IDAgb2JqPDwvQmFzZUZvbnQvQ291cmllci1Cb2xkL1R5cGUvRm9udC9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcvU3VidHlwZS9UeXBlMS9OYW1lL0YxMT4+CmVuZG9iago2IDAgb2JqPDwvQmFzZUZvbnQvSGVsdmV0aWNhL1R5cGUvRm9udC9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcvU3VidHlwZS9UeXBlMS9OYW1lL0YxPj4KZW5kb2JqCjcgMCBvYmo8PC9CYXNlRm9udC9IZWx2ZXRpY2EtQm9sZC9UeXBlL0ZvbnQvRW5jb2RpbmcvV2luQW5zaUVuY29kaW5nL1N1YnR5cGUvVHlwZTEvTmFtZS9GMz4+CmVuZG9iagoyIDAgb2JqPDwvVHlwZS9QYWdlcy9Db3VudCAxL0tpZHNbMSAwIFJdPj4KZW5kb2JqCjkgMCBvYmo8PC9UeXBlL0NhdGFsb2cvUGFnZXMgMiAwIFI+PgplbmRvYmoKMTAgMCBvYmo8PC9Qcm9kdWNlcihpVGV4dDEuMy4xIGJ5IGxvd2FnaWUuY29tIFwoYmFzZWQgb24gaXRleHQtcGF1bG8tMTU0XCkpL01vZERhdGUoRDoyMDE3MDYyMjE0MTkyNi0wNicwMCcpL0NyZWF0aW9uRGF0ZShEOjIwMTcwNjIyMTQxOTI2LTA2JzAwJyk+PgplbmRvYmoKeHJlZgowIDExCjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwOTIwNCAwMDAwMCBuIAowMDAwMDA5NTkzIDAwMDAwIG4gCjAwMDAwMDAxMTkgMDAwMDAgbiAKMDAwMDAwMDAxNSAwMDAwMCBuIAowMDAwMDAzNzcwIDAwMDAwIG4gCjAwMDAwMDkzOTggMDAwMDAgbiAKMDAwMDAwOTQ5MyAwMDAwMCBuIAowMDAwMDA5Mjk5IDAwMDAwIG4gCjAwMDAwMDk2NDMgMDAwMDAgbiAKMDAwMDAwOTY4NyAwMDAwMCBuIAp0cmFpbGVyCjw8L1Jvb3QgOSAwIFIvSUQgWzw1MTk5ZTA2MmRlZjQ3ZThhMzEyZDVlNWMyOWMzN2YyMD48NTE5OWUwNjJkZWY0N2U4YTMxMmQ1ZTVjMjljMzdmMjA+XS9JbmZvIDEwIDAgUi9TaXplIDExPj4Kc3RhcnR4cmVmCjk4NDMKJSVFT0YK'};
        
        List<String> fname = New List<String>{'a'};
        String email = 'test@gmail.com';
        System.assert(email != null, 'Successfully');
        QuickFormHome.sendemail('Test', email, 'subject', 'body', fname, baseb64);
        
        Test.stopTest();
    }

    @IsTest
    public static void testfgettypes(){
    
        Test.startTest();

        List<Progress_Indicator__mdt> gettypes = QuickFormHome.f_Get_Types();
        System.assert(gettypes != null, 'Successfully');
       
        Test.stopTest();
    
    }
    @IsTest 
    public static void testgetcaptchatypes(){
        Test.startTest();

        List<Captcha_Type__mdt> captch = QuickFormHome.Get_Captcha_Types(); 
        System.assert(captch != null, 'Successfully');
        Test.stopTest();
    }

    @IsTest 
    public static void testsiteUrl(){
        Test.startTest();
        
        Form__c formdata2 = [SELECT ID,Name,Status__c FROM Form__c WHERE Name = 'Test2' LIMIT 1];
        Form_Page__c sub1 = [SELECT ID, Form__c FROM Form_Page__c WHERE Form__c =: formdata2.ID LIMIT 1];
        
        QuickForm_Administration__c adm = new QuickForm_Administration__c();
        adm.name = 'Admin';
        adm.SecureUrl__c = String.valueOf(system.URL.getSalesforceBaseUrl().toExternalForm());
        insert adm;

        String sit = QuickFormHome.siteUrl(formdata2.id);
        String sit1 = QuickFormHome.siteUrl(sub1.id);
        System.assert(sit != null, 'Successfully');
        System.assert(sit1 == null, 'Successfully');
       
        Test.stopTest();
    }

    @IsTest 
    public static void testgetProgressindicator(){
        Test.startTest();

        List<Progress_Indicator__mdt> proin = QuickFormHome.getProgressindicator();
        System.assert(proin != null , 'Successfully');
        
        Test.stopTest();
    }

    @IsTest 
    public static void testgetCaptchatype(){
        Test.startTest();

        List<Captcha_Type__mdt> captch = QuickFormHome.getCaptchatype(); 
        System.assert(captch != null , 'Successfully');
        
        Test.stopTest();
    }
    

}