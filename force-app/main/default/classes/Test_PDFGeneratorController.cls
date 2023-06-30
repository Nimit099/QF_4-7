@isTest
public class Test_PDFGeneratorController {
    
    /**
    * @description : Test data setup method to create sample records for testing the Form Submission functionality.
    */
    @TestSetup
    public static void testdata(){
        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;
        form.Mapped_Objects__c = 'Account,Contact,Opportunity';
        insert form; 

        Form_Page__c pageno = new Form_Page__c();
        pageno.Name = 'Test';
        pageno.Page_Number__c = 1;
        pageno.Form__c = form.ID;
        insert pageno;
        
        Form_Page__c pageno1 = new Form_Page__c();
        pageno1.Name = 'Test';
        pageno1.Page_Number__c = 2;
        pageno1.Form__c = form.ID;
        insert pageno1;

        Form_Fields__c field = new Form_Fields__c();
        field.Name = 'QFSIGNATURE';
        field.Form__c = form.ID;
        field.Form_Page__c = pageno.ID;
        field.Field_Order__c = 1;
        field.Mapped_Obj__c = 'Account';
        field.Field_Mapping__c = 'Name<!@!>Account';
        insert field;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        Form_Fields__c field1 = new Form_Fields__c();
        field1.Name = String.valueOf(cv.Id);
        field1.Form__c = form.ID;
        field1.Form_Page__c = pageno.ID;
        field1.Field_Order__c = 2;
        field1.Field_Label__c = 'QFFILEUPLOAD,Extra,0';
        insert field1;

        Form_Fields__c field2 = new Form_Fields__c();
        field2.Name = 'fefefewdff';
        field2.Form__c = form.ID;
        field2.Form_Page__c = pageno.ID;
        field2.Field_Order__c = 2;
        insert field2;


        Account a = new Account();
        a.Name = 'test';
        insert a;

        Contact c =  new Contact();
        c.LastName = 'Test';
        c.AccountId = a.Id;
        insert c;

        Case cs = new Case();
        cs.Status = 'New';
        cs.AccountId = a.Id;
        cs.ContactId = c.Id;

        Form_Submission__c sub = new Form_Submission__c();
        sub.Form__c = form.ID;
        sub.First_object_data__c  = '{"sobjectType":"Account","Name":"Test Mitrajsinh","Type":"Technology Partner","BillingStreet":"Test Street","BillingCity":"Test City","BillingState":"Test State","BillingPostalCode":"Test zip","BillingCountry":"Test Country","Website":"Testwebsite.com","NaicsDesc":"test destafgtdf","Rating":"Warm","Ownership":"Private","Sic":"fsdgil32r4","SicDesc":"Sic desc","CleanStatus":"NotFound","Tradestyle":"retyrhfgvf"}';
        sub.Second_object_data__C  = '{"sobjectType":"Contact","LastName":"Test"}';
        sub.Third_object_data__C  = '{"sobjectType":"Case","Status":"New"}';        
        sub.Other_fields_data__c = '{"sobjectType":"Extra","'+field.Id+'":"'+field.Name+'","'+field1.Id+'":"'+field1.Name+'","'+field2.Id+'":"'+field2.Name+'"}';
        insert sub;
        

    }
    
    @isTest
    public static void testgetpagesofform() {
        
        Form_Submission__c sub = [SELECT id FROM Form_Submission__c];        

        System.Pagereference page = Page.PreViewForm;
        Test.setCurrentPage(page);
        page.getParameters().put('id',sub.id);

        PDFGeneratorController pdf = new PDFGeneratorController();
        pdf.GetPagesOfForm();
        
        String gen = pdf.genrateObjectLabel('account');
        System.assert(gen != null,'Successful');
        
        Map<String,String> strmap = new Map<String,String>();
        strmap.put('sobjectType','Account');
        
        
        List<Form_Fields__c> fieldslist  = [SELECT ID FROM Form_Fields__c WHERE Mapped_Obj__c = 'Account'];
        Map<String,String> labelmap = pdf.genrateLabelMap(strmap,fieldslist);
        
        List<Form_Fields__c> fieldslist1  = [SELECT ID FROM Form_Fields__c WHERE Mapped_Obj__c != 'Account'];
        Map<String,String> strmap1 = new Map<String,String>();
        strmap1.put('BillingAddress<!@!>Account','Test');
        Map<String,String> labelmap1 = pdf.genrateLabelMap(strmap1,fieldslist1);

        strmap.put('BillingCity<!@!>Account','Test');
        Map<String,String> strmap2 = new Map<String,String>();
        Map<String,String> labelmap2 = pdf.genrateLabelMap(strmap2,fieldslist1);

        strmap.put('BillingPostalCode<!@!>Account','Test');
        Map<String,String> strmap3 = new Map<String,String>();
        Map<String,String> labelmap3 = pdf.genrateLabelMap(strmap3,fieldslist1);

        strmap.put('BillingState','Test');
        Map<String,String> strmap4 = new Map<String,String>();
        Map<String,String> labelmap4 = pdf.genrateLabelMap(strmap4,fieldslist1);

        strmap.put('BillingCountry','Test');
        Map<String,String> strmap5 = new Map<String,String>();
        Map<String,String> labelmap5 = pdf.genrateLabelMap(strmap5,fieldslist1);
        
        System.assert(labelmap != null,'Successful');
        System.assert(labelmap1 != null,'Successful');
        System.assert(labelmap2 != null,'Successful');
        System.assert(labelmap3 != null,'Successful');
        System.assert(labelmap4 != null,'Successful');
        System.assert(labelmap5 != null,'Successful');

    }
}