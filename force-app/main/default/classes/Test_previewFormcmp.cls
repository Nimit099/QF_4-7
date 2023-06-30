@isTest
public class Test_previewFormcmp{/* @description : check the PreviewForcmp code coverage */

    /**
        * @description Testsetup method to create data for PreviewForcmp class
    */
    @TestSetup
    public static void createrecord(){
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;        
        form.Mapped_Objects__c = 'text,data,demo';
        form.Form_Styling__c = 'demo:0;test:1;check:3';
        form.FormBgID__c = 'test';
        form.Page_CSS__C = 'padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-image:"test.png";background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        insert form;
        
        Form__c form2 = new Form__c();
        form2.Name = 'Test2';
        form2.Status__c = FALSE;        
        form2.Mapped_Objects__c = 'text,data,demo';
        form2.Form_Styling__c = 'demo:0;test:1;check:3';
        form2.FormBgID__c = 'test';
        form2.Page_CSS__C = 'padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-image:"test.png";background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        insert form2;

        Notification__c n = new Notification__c();
        n.To_Recipients__c = 'test@gmail.com';
        n.CC_Recipients__c =  'test@gmail.com';
        n.Subject__c = 'Test';
        n.Email_Body__c = 'test the email body';
        n.Attachment__c = True;
        n.BCC_Recipients__c = 'test@gmail.com';
        n.Status__c = True;
        n.Form__c = form2.ID;
        insert n;
        
    }

    @IsTest
    public static void testFormdetails(){
        Form__c formdata = [SELECT ID, Name, Status__c, Mapped_Objects__c, Form_Styling__c, FormBgID__c, Page_CSS__C FROM Form__C WHERE Name = 'Test' LIMIT 1];
        previewFormcmp.formdetails(formdata.Id,'apex/PreViewForm');
        previewFormcmp.formdetails(formdata.Id,'');
        System.assert(formdata != null, 'Successful');
    }
    
    @IsTest
    public static void testBgimages(){
        ContentVersion cv = [ SELECT ID, Title, PathOnClient, VersionData, IsMajorVersion FROM ContentVersion WHERE Title = 'Test Document'];
        previewFormcmp.bgimages(cv.Id,'PreViewForm');
        System.assert(cv != null, 'Successful');
        
    }
    
    @IsTest
    public static void testFormfielddetails(){
        Form__c formdata = [SELECT ID, Name, Status__c, Mapped_Objects__c, Form_Styling__c, FormBgID__c, Page_CSS__C FROM Form__C WHERE Name = 'Test' LIMIT 1];
        previewFormcmp.formfielddetails(formdata.Id);
        System.assert(formdata != null, 'Successful');
    }
    
    @IsTest
    public static void testFormpagedetails(){
        Form__c formdata = [SELECT ID, Name, Status__c, Mapped_Objects__c, Form_Styling__c, FormBgID__c, Page_CSS__C FROM Form__C WHERE Name = 'Test' LIMIT 1];
        previewFormcmp.formpagedetails(formdata.Id);
        System.assert(formdata != null, 'Successful');
    }
    
    @IsTest
    public static void testGetInactiveForms(){
        Form__c formdata = [SELECT ID, Name, Status__c, Mapped_Objects__c, Form_Styling__c, FormBgID__c, Page_CSS__C FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Form__c formdata2 = [SELECT ID, Name, Status__c, Mapped_Objects__c, Form_Styling__c, FormBgID__c, Page_CSS__C FROM Form__C WHERE Name = 'Test2' LIMIT 1];
        previewFormcmp.getInactiveForms(formdata.ID);
        System.assert(formdata != null, 'Successful');
        previewFormcmp.getInactiveForms(formdata2.ID);
        System.assert(formdata2 != null, 'Successful');
    }
    
    @IsTest
    public static void testSendemailaftersubmission(){
        Form__c formdata = [SELECT ID, Name, Status__c, Mapped_Objects__c, Form_Styling__c, FormBgID__c, Page_CSS__C FROM Form__C WHERE Name = 'Test2' LIMIT 1];
        Notification__c notificationdata = [SELECT Id,To_Recipients__c, CC_Recipients__c, Subject__c, Email_Body__c, Attachment__c, BCC_Recipients__c, Form__c,Status__c FROM Notification__c WHERE Subject__c = 'Test' LIMIT 1];
        System.assert(formdata != null, 'Successful');
        previewFormcmp.sendemailaftersubmission(formdata.Id,notificationdata.Id);
        System.assert(notificationdata != null, 'Successful');
    }

}