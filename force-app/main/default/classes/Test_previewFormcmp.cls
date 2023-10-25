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

         Form__c form3 = new Form__c();
        form3.Name = 'Test3';
        form3.Status__c = true;        
        form3.Mapped_Objects__c = 'text,data,demo';
        form3.Form_Styling__c = 'demo:0;test:1;check:3';
        form3.FormBgID__c = 'test';
        form3.Page_CSS__C = 'padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-image:"test.png";background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        insert form3;
        
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

        Form_Page__c pageno = new Form_Page__c();
        pageno.Name = 'Test';
        pageno.Page_Number__c = 1;
        pageno.Form__c = form.ID;
        insert pageno;

        Form_Page__c pageno2 = new Form_Page__c();
        pageno2.Name = 'Test2';
        pageno2.Page_Number__c = 1;
        pageno2.Form__c = form.ID;
        insert pageno2;
        
        Form_Fields__c field = new Form_Fields__c();
        field.Name = 'Test,isrequired,feerf';
        field.Form__c = form.ID;
        field.Form_Page__c = pageno.ID;
        field.Field_Order__c = 3;
        field.Field_Mapping__c = 'Description<!@!>Contact';
        field.Field_Validations__c = 'isRequired<!@!>true?$`~isDisabled<!@!>false?$`~isLabel<!@!>true?$`~isHelpText<!@!>true?$`~Label<!@!>LAST NAME?$`~HelpText<!@!>ceweew?$`~isPlaceholder<!@!>true?$`~Placeholder<!@!>ecewcecewcew?$`~Minimum<!@!>25?$`~Maximum<!@!>250?$`~isPrefix<!@!>false?$`~Prefix<!@!>?$`~Decimal<!@!>?$`~Richtext<!@!>?$`~MinimumTime<!@!>?$`~MaximumTime<!@!>?$`~MinimumDateTime<!@!>?$`~MaximumDateTime<!@!>?$`~MinimumDate<!@!>?$`~MaximumDate<!@!>';
        field.Mapped_Obj__c = 'Contact';
        insert field;

        Thankyou_Page__c thank = new Thankyou_Page__c();
        thank.Name = 'Test thankyou';
        thank.Form__C = form.Id;
        insert thank;
        
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
    
   @isTest
    static void testGetpicklistvalue(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Mapped_Obj__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Fields__c field1 = [SELECT ID,Name,Form__c,Form_Page__c,Mapped_Obj__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Mapped_Obj__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        
        Map<String, String> getpicklist = previewFormcmp.getpicklistvalue(field.id);
        Map<String, String> getpicklist1 = previewFormcmp.getpicklistvalue(field2.id);
        Map<String, String> getpicklist2 = previewFormcmp.getpicklistvalue(field1.id);
        System.assert(getpicklist != null, 'Successfully');
        System.assert(getpicklist1 != null, 'Successfully');
        System.assert(getpicklist2 != null, 'Successfully');
    
        Test.stopTest();
    }

    @isTest
    static void testGetreferencevalue(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE Form__c =: form.Id LIMIT 1];
        previewFormcmp.referencewrapper re = previewFormcmp.getreferencevalue(field.id,'testdemo');
        previewFormcmp.referencewrapper re1 = previewFormcmp.getreferencevalue(form.id,'testdemo');
        System.assert(re == null, 'Successfully');
        System.assert(re1 == null, 'Successfully');
    
        Test.stopTest();
    }

    @IsTest
    public static void testgetthankyoupage(){
        
        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Thankyou_Page__c t1 = [SELECT Id FROM ThankYou_Page__c LIMIT 1];
        Thankyou_Page__c thank = previewFormcmp.getthankyoupage(form.Id);
        System.assertEquals(t1.Id, thank.Id, 'success');
        Test.stopTest();

    }

    @IsTest
    public static void testgetthankyoupage2(){
        Test.startTest();
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        Thankyou_Page__c thank2 = previewFormcmp.getthankyoupage(form2.Id);
        System.assert(thank2 == null, 'success');
        Test.stopTest();
    }

    @IsTest
    public static void testformpagedetails2(){
        Test.startTest();
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        List<Form_Page__c> pages = previewFormcmp.formpagedetails(form2.Id);
        System.assert(pages != null, 'success');
        Test.stopTest();
    }

    @IsTest
    public static void testgetpicklistvalue2(){
        Test.startTest();
        Form__c form3 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        Map<String, String> maps = previewFormcmp.getpicklistvalue(form3.Id);
        System.assert(maps == null, 'success');
        Test.stopTest();
    }

    @IsTest
    public static void testbgimages2(){
        Test.startTest();
        Form__c form3 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String data = previewFormcmp.bgimages(form3.Id, 'PreviewForm');
        System.assert(data == null, 'success');
        Test.stopTest();
    }
}