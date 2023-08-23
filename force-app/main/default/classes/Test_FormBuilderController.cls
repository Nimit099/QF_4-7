@istest 
public class Test_FormBuilderController {
    @TestSetup 
    static void createdata(){
            
        Test.startTest();
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;

        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;
        form.Total_Submissions__c = 2;
        form.Mapped_Objects__c = 'Account,Contact,Lead';
        form.Form_Styling__c = 'color:red;background';
        form.Page_CSS__C = 'color:red;background-image:"test.png";padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        form.PageBgID__c = cv.Id;
        form.FormBgID__c = cv.Id;
        insert form;

        Form__c form3 = new Form__c();
        form3.Name = 'Test4';
        form3.Status__c = true;
        form3.Total_Submissions__c = 2;
        form3.Mapped_Objects__c = 'text,data,demo';
        form3.Form_Styling__c = 'color:red;background-image:test.pdf';
        form3.Page_CSS__C = 'color:red;background-image:"test.png";padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        form3.PageBgID__c = cv.Id;
        form3.FormBgID__c = cv.Id;
        insert form3;

        Form__c form1 = new Form__c();
        form1.Name = 'Test2';
        form1.Status__c = true;
        form1.Total_Submissions__c = 2;
        form1.Mapped_Objects__c = 'Account,Contact,Lead';
        form1.FormBgID__c = 'test';
        form.Form_Styling__c = 'width:60%;padding-top:0%;padding-bottom:0%;padding-left:0%;padding-right:0%;background-color:#A391FF;background-size:auto;background-position:top center;background-repeat:Repeat;background-attachment:Fixed;';
        form1.Button_CSS__c = 'color:red;';
        form1.Label_CSS__c = 'color:red';
        form1.All_Field_Styling__c = 'background-color:#CA3D3D;border-color:#FF16FF;border-style:Solid;border-width:10px;border-radius:10px;font-family:monospace;font-weight:Normal;color:#242424;font-size:12px;font-style:Italic;padding-left:5%px;padding-right:0px;padding-top:0px;padding-bottom:0px;line-height:1;';
        form1.All_Field_Hover__c = 'color:red';
        form1.All_Field_Focus__c = 'background-color:#FFFFFF;border-color:#000000;border-style:Solid;border-width:10px;border-radius:10px;font-family:monospace;font-weight:Normal;color:#242424;font-size:12px;font-style:Italic;padding-left:5%px;padding-right:0px;padding-top:0px;padding-bottom:0px;';
        form1.Page_CSS__C = 'padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        form1.PageBgID__c = cv.Id;
        insert form1;
        
        Form__c form2 = new Form__c();
        form2.Name = 'Test3';
        form2.Status__c = true;
        form2.Total_Submissions__c = 2;
        form2.Mapped_Objects__c = 'Account,Contact,Case';
        form2.FormBgID__c = 'test';
        form2.Form_Styling__c = 'background-image:test.pdf';
        form2.Button_CSS__c = 'color red';
        form2.Label_CSS__c = 'color red';
        form2.All_Field_Styling__c = 'color red';
        form2.All_Field_Hover__c = 'color:red';
        form2.All_Field_Focus__c = 'size:13px';
        form1.Page_CSS__C = 'padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        form2.PageBgID__c = cv.Id;
        insert form2;


        Form_Page__c pageno = new Form_Page__c();
        pageno.Name = 'Test';
        pageno.Page_Number__c = 1;
        pageno.Form__c = form.ID;
        insert pageno;

        Form_Page__c pageno3 = new Form_Page__c();
        pageno3.Name = 'Test3';
        pageno3.Page_Number__c = 1;
        pageno3.Form__c = form2.ID;
        insert pageno3;

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

        Form_Fields__c field1 = new Form_Fields__c();
        field1.Name = 'Test2,dferf';
        field1.Form__c = form.ID;
        field1.Form_Page__c = pageno.ID;
        field1.Field_Order__c = 1;
        field1.Field_Mapping__c = 'LeadSource<!@!>Opportunity';
        field1.Field_Validations__c = 'isRequired<!@!>true?$`~isDisabled<!@!>false?$`~isLabel<!@!>true?$`~isHelpText<!@!>true?$`~Label<!@!>NAME?$`~HelpText<!@!>cdescece?$`~isPlaceholder<!@!>false?$`~Placeholder<!@!>?$`~Minimum<!@!>0?$`~Maximum<!@!>128?$`~isPrefix<!@!>false?$`~Prefix<!@!>?$`~Decimal<!@!>?$`~Richtext<!@!>?$`~MinimumTime<!@!>?$`~MaximumTime<!@!>?$`~MinimumDateTime<!@!>?$`~MaximumDateTime<!@!>?$`~MinimumDate<!@!>?$`~MaximumDate<!@!>';
        field1.Mapped_Obj__c = 'Contact';

        insert field1;
        
        Form_Fields__c field2 = new Form_Fields__c();
        field2.Name = 'Test3,dferf,feerf';
        field2.Form__c = form.ID;
        field2.Form_Page__c = pageno.ID;
        field2.Field_Order__c = 2;
        field2.Field_Mapping__c = 'Name<!@!>Account';
        field2.Mapped_Obj__c = 'Contact';
        field2.Field_Validations__c = 'isRequired<!@!>false?$`~isDisabled<!@!>false?$`~isLabel<!@!>true?$`~isHelpText<!@!>true?$`~Label<!@!>ACCOUNT NUMBER?$`~HelpText<!@!>rhrthth?$`~isPlaceholder<!@!>true?$`~Placeholder<!@!>hrghrthtrhtrhtr?$`~Minimum<!@!>0?$`~Maximum<!@!>128?$`~isPrefix<!@!>false?$`~Prefix<!@!>?$`~Decimal<!@!>?$`~Richtext<!@!>?$`~MinimumTime<!@!>?$`~MaximumTime<!@!>?$`~MinimumDateTime<!@!>?$`~MaximumDateTime<!@!>?$`~MinimumDate<!@!>?$`~MaximumDate<!@!>';
        insert field2;

        Form_Fields__c field3 = new Form_Fields__c();
        field3.Name = 'QFRADIOBUTTON,Extra,0';
        field3.Form__c = form.ID;
        field3.Form_Page__c = pageno.ID;
        field3.Field_Order__c = 3;
        field3.Field_Mapping__c = 'Description<!@!>Contact';
        field3.Field_Validations__c = 'isRequired<!@!>true?$`~isDisabled<!@!>false?$`~isLabel<!@!>true?$`~isHelpText<!@!>true?$`~Label<!@!>LAST NAME?$`~HelpText<!@!>ceweew?$`~isPlaceholder<!@!>true?$`~Placeholder<!@!>ecewcecewcew?$`~Minimum<!@!>25?$`~Maximum<!@!>250?$`~isPrefix<!@!>false?$`~Prefix<!@!>?$`~Decimal<!@!>?$`~Richtext<!@!>?$`~MinimumTime<!@!>?$`~MaximumTime<!@!>?$`~MinimumDateTime<!@!>?$`~MaximumDateTime<!@!>?$`~MinimumDate<!@!>?$`~MaximumDate<!@!>';
        field3.Mapped_Obj__c = 'Contact';
        insert field3;
        
        Form_Fields__c field4 = new Form_Fields__c();
        field4.Name = 'QFSCALERATING,Extra,0';
        field4.Form__c = form.ID;
        field4.Form_Page__c = pageno.ID;
        field4.Field_Order__c = 3;
        field4.Field_Mapping__c = 'Description<!@!>Contact';
        field4.Field_Validations__c = 'isRequired<!@!>true?$`~isDisabled<!@!>false?$`~isLabel<!@!>true?$`~isHelpText<!@!>true?$`~Label<!@!>LAST NAME?$`~HelpText<!@!>ceweew?$`~isPlaceholder<!@!>true?$`~Placeholder<!@!>ecewcecewcew?$`~Minimum<!@!>25?$`~Maximum<!@!>250?$`~isPrefix<!@!>false?$`~Prefix<!@!>?$`~Decimal<!@!>?$`~Richtext<!@!>?$`~MinimumTime<!@!>?$`~MaximumTime<!@!>?$`~MinimumDateTime<!@!>?$`~MaximumDateTime<!@!>?$`~MinimumDate<!@!>?$`~MaximumDate<!@!>';
        field4.Mapped_Obj__c = 'Contact';
        insert field4;

        Form_Submission__c sub = new Form_Submission__c();
        sub.Form__c = form.ID;
        sub.First_object_data__c  = '{"sobjectType":"Account","Name":"Testing"}';
        sub.Second_object_data__C  = '{"sobjectType":"Contact","LastName":"Test"}';
        sub.Third_object_data__C  = '{"sobjectType":"Case","Status":"New"}';
        sub.Other_fields_data__c = '{"sobjectType":"Form_c","'+field.Id+'":"'+field.Name+'","'+field1.ID+'":"'+field1.Name+'","'+field2.ID+'":"'+field2.Name+'"}';
        insert sub;

        Test.stopTest();

    }

    @isTest
    static void testGetMetaData(){ 

        Test.startTest();

        List<BaseField_mdt__mdt> getfieldmetadata = FormBuilderController.GetFieldsMetaData();
        System.assert(getfieldmetadata != null , 'Successfully');

        Test.stopTest();
    }
    @isTest
    static void testGetStyles(){ 

        Test.startTest();

        FormBuilderController.StylesWrapper sw = FormBuilderController.GetStyles();
        System.assert(sw != null, 'Successfully');
        Test.stopTest();
    }
    @isTest
    static void testGetFields(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        List<List<String>> getfield = FormBuilderController.getFields(form.ID);
        System.assert(getfield != null, 'Successfully');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        List<List<String>> getfield1 = FormBuilderController.getFields(form1.ID);
        System.assert(getfield != null, 'Successfully');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        List<List<String>> getfield2 = FormBuilderController.getFields(form2.ID);
        System.assert(getfield != null, 'Successfully');
        
        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        List<List<String>> getfield3 = FormBuilderController.getFields(field2.ID);
        System.assert(getfield != null, 'Successfully');
        
        Test.stopTest();
    }
    @isTest
    static void testUploadFormImage(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];

        String uploadimage = FormBuilderController.UploadFormImage(form.ID,'testData','Test','Test_Type');
        String uploadimage1 = FormBuilderController.UploadFormImage(form1.ID,'testData','Test','Test_Type');
        
        System.assert(uploadimage != null, 'Successfully ');
        System.assert(uploadimage1 != null, 'Successfully ');

        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String uploadimage2 = FormBuilderController.UploadPageImage(form2.ID,'testData','Test','Test_Type');
        System.assert(uploadimage2 != null, 'Successfully ');
        
        Form__c form3 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test4'];
        String uploadimage3 = FormBuilderController.UploadFormImage(form3.ID,'testData','Test','Test_Type');
        System.assert(uploadimage3 != null, 'Successfully ');

        Test.stopTest();
    }
    @isTest
    static void testUploadPageImage(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];

        String uploadpageiimage = FormBuilderController.UploadPageImage(form.ID,'testData','Test','Test_Type');
        String uploadpageiimage1 = FormBuilderController.UploadPageImage(form1.ID,'testData','Test','Test_Type');
        System.assert(uploadpageiimage != null, 'Successfully ');
        System.assert(uploadpageiimage1 != null, 'Successfully ');

        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String uploadpageiimage2 = FormBuilderController.UploadPageImage(form2.ID,'testData','Test','Test_Type');
        System.assert(uploadpageiimage2 != null, 'Successfully ');
        
        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        String uploadpageiimage3 = FormBuilderController.UploadPageImage(field2.ID,'testData','Test','Test_Type');
        System.assert(uploadpageiimage3 == null, 'Successfully ');
        
        Test.stopTest();
    }
    @isTest
    static void testRemoveFormImage(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,PageBgID__c,Label_CSS__c FROM form__c WHERE Name = 'Test4'];
 
        String removeimge = FormBuilderController.RemoveFormImage(form.ID);
        System.assert(removeimge != null, 'Successfully ');
        
        Test.stopTest();
    }
    
    @isTest
    static void testRemovePageImage(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,PageBgID__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        String removepageimage = FormBuilderController.RemovePageImage(form.ID);
        System.assert(removepageimage != null, 'Successfully ');
        
        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        String removepageimage1 = FormBuilderController.RemovePageImage(field2.ID);
        System.assert(removepageimage1 == null, 'Successfully ');

        Test.stopTest();
    }
    
    @isTest
    static void testStoreBtnStyles(){ 
        
        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        String storebtnstyle = FormBuilderController.StoreBtnStyles('color:red;',form.ID);
        System.assert(storebtnstyle != null, 'Successfully ');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        String storebtnstyle1 = FormBuilderController.StoreBtnStyles('color:red;',form1.ID);
        System.assert(storebtnstyle != null, 'Successfully ');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String storebtnstyle2 = FormBuilderController.StoreBtnStyles('color:red;',form2.ID);
        System.assert(storebtnstyle != null, 'Successfully ');
        
        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        String storebtnstyle3 = FormBuilderController.StoreBtnStyles('color:red;',field2.ID);
        System.assert(storebtnstyle != null, 'Successfully ');

        Test.stopTest();
    }
    @isTest
    static void testStoreBtnposition(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        String storebtnpo = FormBuilderController.StoreBtnposition('color red;',form.ID);
        System.assert(storebtnpo != null, 'Successfully ');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        String storebtnpo1 = FormBuilderController.StoreBtnposition('color:red;',form1.ID);
        System.assert(storebtnpo1 != null, 'Successfully ');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String storebtnpo2 = FormBuilderController.StoreBtnposition('color:red;',form2.ID);
        System.assert(storebtnpo2 != null, 'Successfully ');
        
        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        String storebtnpo3 = FormBuilderController.StoreBtnposition('color:red;',field2.ID);
        System.assert(storebtnpo3 == null, 'Successfully ');

        Test.stopTest();
    }
    @isTest
    static void testStoreLabelStyles(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        String storelabelstyle = FormBuilderController.StoreLabelStyles('color red;',form.ID);
        System.assert(storelabelstyle != null, 'Successfully ');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        String storelabelstyle1 = FormBuilderController.StoreLabelStyles('color:red;',form1.ID);
        System.assert(storelabelstyle1 != null, 'Successfully ');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String storelabelstyle2 = FormBuilderController.StoreLabelStyles('color:red;',form2.ID);
        System.assert(storelabelstyle2 != null, 'Successfully ');

        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        String storelabelstyle3 = FormBuilderController.StoreLabelStyles('color:red;',field2.ID);
        System.assert(storelabelstyle3 != null, 'Successfully ');
        
        Test.stopTest();
    }
    @isTest
    static void testStoreFormStyles(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        String storeformstyle = FormBuilderController.StoreFormStyles('color:red;',form.ID);
        System.assert(storeformstyle != null, 'Successfully ');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        String storeformstyle1 = FormBuilderController.StoreFormStyles('color:red;',form1.ID);
        System.assert(storeformstyle1 != null, 'Successfully ');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String storeformstyle2 = FormBuilderController.StoreFormStyles('color:red;',form2.ID);
        System.assert(storeformstyle2 != null, 'Successfully ');
        
        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        String storeformstyle3= FormBuilderController.StoreFormStyles('color:red;',field2.ID);
        System.assert(storeformstyle3 != null, 'Successfully ');
        
        Test.stopTest();
    }
    @isTest
    static void testStorePageStyles(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        String storepaagestyle = FormBuilderController.StorePageStyles('color:red;',form.ID);
        System.assert(storepaagestyle != null, 'Successfully ');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        String storepaagestyle1 = FormBuilderController.StorePageStyles('color:red;',form1.ID);
        System.assert(storepaagestyle1 != null, 'Successfully ');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String storepaagestyle2 = FormBuilderController.StorePageStyles('color:red;',form2.ID);
        System.assert(storepaagestyle2 != null, 'Successfully ');

        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        String storepaagestyle3 = FormBuilderController.StorePageStyles('color:red;',field2.ID);
        System.assert(storepaagestyle3 != null, 'Successfully ');

        Test.stopTest();
    }
    @isTest
    static void testStoreStyles(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        String storestyle = FormBuilderController.StoreStyles('color red;',form.ID);
        System.assert(storestyle != null, 'Successfully ');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        String storestyle1 = FormBuilderController.StoreStyles('color:red;',form1.ID);
        System.assert(storestyle1 != null, 'Successfully ');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String storestyle2 = FormBuilderController.StoreStyles('color:red;',form2.ID);
        System.assert(storestyle2 != null, 'Successfully ');

        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        String storestyle3 = FormBuilderController.StoreStyles('color:red;',field2.ID);
        System.assert(storestyle3 != null, 'Successfully ');

        Test.stopTest();
    }
    @isTest
    static void testGetBGImages(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        String getbgimg = FormBuilderController.getBGImages(form.ID);
        System.assert(getbgimg != null, 'Successfully ');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        String getbgimg1 = FormBuilderController.getBGImages(form1.ID);
        System.assert(getbgimg1 != null, 'Successfully ');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String getbgimg2 = FormBuilderController.getBGImages(form2.ID);
        System.assert(getbgimg2 != null, 'Successfully ');

        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        String getbgimg3 = FormBuilderController.getBGImages(field2.ID);
        System.assert(getbgimg3 == null, 'Successfully ');

        Test.stopTest();
    }
    @isTest
    static void testStoreHoverStyles(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        String storehoverstyle = FormBuilderController.StoreHoverStyles('color:red;',form.ID);
        System.assert(storehoverstyle != null, 'Successfully ');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        String storehoverstyle1 = FormBuilderController.StoreHoverStyles('color red;',form1.ID);
        System.assert(storehoverstyle1 != null, 'Successfully ');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String storehoverstyle2 = FormBuilderController.StoreHoverStyles('color:red;',form2.ID);
        System.assert(storehoverstyle2 != null, 'Successfully ');

        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        String storehoverstyle3 = FormBuilderController.StoreHoverStyles('color:red;',field2.ID);
        System.assert(storehoverstyle3 != null, 'Successfully ');
        
        Test.stopTest();
    }
    @isTest
    static void testStoreFocusStyles(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        String storefous = FormBuilderController.StoreFocusStyles('color:red;',form.ID);
        System.assert(storefous != null, 'Successfully ');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        String storefous1 = FormBuilderController.StoreFocusStyles('color:red;',form1.ID);
        System.assert(storefous1 != null, 'Successfully ');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String storefous2 = FormBuilderController.StoreFocusStyles('color:red;',form2.ID);
        System.assert(storefous2 != null, 'Successfully ');

        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        String storefous3 = FormBuilderController.StoreFocusStyles('color:red;',field2.ID);
        System.assert(storefous3 != null, 'Successfully ');

        Test.stopTest();
    }
    @isTest
    static void testFormdetails(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form__c formdetails = FormBuilderController.formdetails(form.ID);
        System.assert(formdetails != null, 'Successfully ');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        Form__c formdetails1 = FormBuilderController.formdetails(form1.ID);
        System.assert(formdetails1 != null, 'Successfully ');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        Form__c formdetails2 = FormBuilderController.formdetails(form2.ID);        
        System.assert(formdetails2!= null, 'Successfully ');

        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        Form__c formdetails3 = FormBuilderController.formdetails(field2.ID);        
        System.assert(formdetails3 == null, 'Successfully ');
        
        Test.stopTest();
    }
    @isTest
    static void testGetcaptcha(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        String getcaptcha = FormBuilderController.getcaptcha(form.ID);
        System.assert(getcaptcha == null, 'Successfully ');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        String getcaptcha1 = FormBuilderController.getcaptcha(form1.ID);
        System.assert(getcaptcha1 == null, 'Successfully ');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        String getcaptcha2 = FormBuilderController.getcaptcha(form2.ID);
        System.assert(getcaptcha2 == null, 'Successfully ');

        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        String getcaptcha3 = FormBuilderController.getcaptcha(field2.ID);
        System.assert(getcaptcha3 == null, 'Successfully ');
        
        Test.stopTest();
    }
    @isTest
    static void testGetFormPage(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        List<Form_Page__c> getformpage = FormBuilderController.GetFormPage(form.ID);
        System.assert(getformpage != null, 'Successfully ');
        
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        List<Form_Page__c> getformpage1 = FormBuilderController.GetFormPage(form1.ID);
        System.assert(getformpage1 != null, 'Successfully ');
        
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        List<Form_Page__c> getformpage2 = FormBuilderController.GetFormPage(form2.ID);
        System.assert(getformpage2 != null, 'Successfully ');

        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID and Name = 'Test2,dferf' LIMIT 1];
        List<Form_Page__c> getformpage3 = FormBuilderController.GetFormPage(field2.ID);
        System.assert(getformpage3 != null, 'Successfully ');
        
        
        Test.stopTest();
    }
    @isTest
    static void testGetScaleRating(){ 

        Test.startTest();
        
        List<Scale_Rating__mdt> getscale = FormBuilderController.getScaleRating();
        System.assert(getscale != null, 'Successfully ');
        
        Test.stopTest();
    }
    @isTest
    static void testCreateFieldRecord(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Fields__c field3 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE Name = 'QFRADIOBUTTON,Extra,0' LIMIT 1];
        Form_Fields__c field4 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE NAme = 'QFSCALERATING,Extra,0' LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Name = 'Test' LIMIT 1];
        Form_Page__c pageno2 = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Name ='Test2'];
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        
        
        List<Form_Fields__c> createfield = FormBuilderController.CreateFieldRecord(form2.ID,field3.ID,pageno.ID,2,true,field.ID,'Account');
        List<Form_Fields__c> createfield1 = FormBuilderController.CreateFieldRecord(form2.ID,field4.ID,pageno.ID,2,false,field.ID,'Account');
        System.assert(createfield != null, 'Successfully ');
        System.assert(createfield1 == null, 'Successfully ');
        
        List<Form_Fields__c> createfield2 = FormBuilderController.CreateFieldRecord(form.ID,field.ID,pageno.ID,2,true,field.ID,'Account');
        List<Form_Fields__c> createfield3 = FormBuilderController.CreateFieldRecord(form.ID,field2.ID,pageno.ID,2,false,field.ID,'Account');
        System.assert(createfield2 != null, 'Successfully ');
        System.assert(createfield3 == null, 'Successfully ');
        
        List<Form_Fields__c> createfield4 = FormBuilderController.CreateFieldRecord(form2.ID,field3.ID,pageno.ID,0,true,field.ID,'Account');
        List<Form_Fields__c> createfield5 = FormBuilderController.CreateFieldRecord(form2.ID,field4.ID,pageno.ID,0,false,field.ID,'Account');
        System.assert(createfield4 != null, 'Successfully ');
        System.assert(createfield5 == null, 'Successfully ');
        
        List<Form_Fields__c> createfield6 = FormBuilderController.CreateFieldRecord(form.ID,field.ID,pageno.ID,0,true,field.ID,'Account');
        List<Form_Fields__c> createfield7 = FormBuilderController.CreateFieldRecord(form.ID,field2.ID,pageno.ID,0,false,field.ID,'Account');
        System.assert(createfield6 != null, 'Successfully ');
        System.assert(createfield7 == null, 'Successfully ');

        Test.stopTest();
    }
    @isTest
    static void testAddPageBreak(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Name = 'Test'];
        
        FormBuilderController.pageWrapper pw = FormBuilderController.addPageBreak(form.ID,'test_name',pageno.ID,3,field.ID);
        System.assert(pw != null, 'successfully');
        Test.stopTest();
    }
    @isTest
    static void testObjName(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test4'];
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        
        String st = FormBuilderController.ObjName(form.ID);
        String st1 = FormBuilderController.ObjName(form2.ID);
        System.assert(st != null, 'Successfully');
        System.assert(st1 != null, 'Successfully');
        Test.stopTest();
    }
    @isTest
    static void testGetFieldsRecords(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];

        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test4'];
        
        List<Form_Fields__c> getfield1 = FormBuilderController.getFieldsRecords(form.ID);
        System.assert(getfield1 != null, 'Successfully');
        Test.stopTest();
    }
    @isTest
    static void testReOrderField(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE Name = 'Test,isrequired,feerf' LIMIT 1];
        Form_Fields__c field1 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE Name = 'Test2,dferf' LIMIT 1];
        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE Name = 'Test3,dferf,feerf' LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Name = 'Test'];
        
        List<Form_Fields__c> re = FormBuilderController.reOrderField(field.ID,field1.ID,pageno.ID);
        List<Form_Fields__c> re1 = FormBuilderController.reOrderField(field2.ID,field1.ID,pageno.ID);
        List<Form_Fields__c> re2 = FormBuilderController.reOrderField(field.ID,field1.ID,pageno.ID);
        field2.Id = null;
        List<Form_Fields__c> re3 = FormBuilderController.reOrderField(field2.ID,field.ID,pageno.ID);
        
        System.assert(re != null, 'Successfully');
        System.assert(re1 != null, 'Successfully');
        System.assert(re2 != null, 'Successfully');
        System.assert(re3 != null, 'Successfully');
        Test.stopTest();
    }
    @isTest
    static void testCreatePage(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        
        FormBuilderController.pageWrapper pw1 = FormBuilderController.createPage(1, 3, form.Id, 'Test_pagename1');
        FormBuilderController.pageWrapper pw2 = FormBuilderController.createPage(2, 3, form.Id, 'Test_pagename2');
        System.assertNotEquals(null, pw1);
        System.assertNotEquals(null, pw2);
        
        Test.stopTest();
    }
    @isTest
    static void testUpdatePage(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Name = 'Test'];
        
        FormBuilderController.pageWrapper updaetpage = FormBuilderController.updatePage(form.ID,pageno.ID,'test',5);
        System.assert(updaetpage != null, 'Successfully');
        
        Test.stopTest();
    }
    @isTest
    static void testRenameform(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Name = 'Test'];
        
        FormBuilderController.pageWrapper renameform = FormBuilderController.renameform(pageno.id,'test_renameform',form.ID);
        FormBuilderController.pageWrapper renameform1 = FormBuilderController.renameform(pageno.id,'test_renameform',field.ID);
        System.assert(renameform != null, 'Successfully');
        System.assert(renameform1 != null, 'Successfully');
        
        Test.stopTest();
    }
    @isTest
    static void testRenameMainform(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];

        String renamemain = FormBuilderController.renameMainform('Testmain',form.ID);
        String renamemain1 = FormBuilderController.renameMainform('Testmain',field.ID);
        System.assert(renamemain != null, 'Successfully');
        System.assert(renamemain1 == null, 'Successfully');
        
        Test.stopTest();
    }
    @isTest
    static void testDeletePage(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form__c form1 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Name = 'Test'];
        
        FormBuilderController.pageWrapper deletepage = FormBuilderController.deletePage(form.id,pageno.id);
        FormBuilderController.pageWrapper deletepage1 = FormBuilderController.deletePage(form1.id,pageno.id);
        System.assert(deletepage != null, 'Successfully');
        System.assert(deletepage1 == null, 'Successfully');
        
        Test.stopTest();
    }
    @isTest
    static void testPageDetails(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Name = 'Test'];
        
        Form_Page__c page = FormBuilderController.pageDetails(form.ID,pageno.ID);
        Form_Page__c page1 = FormBuilderController.pageDetails(pageno.ID,form.ID);
        System.assert(page != null, 'Successfully');
        System.assert(page1 == null, 'Successfully');
        
        Test.stopTest();
    }
    @isTest
    static void testEditFormSubmit(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];

        String editform = FormBuilderController.editFormSubmit(form.id,'testdemo','Page Count','Normal Captcha');
        String editform1 = FormBuilderController.editFormSubmit(form.id,'testdemo','None','None');
        System.assert(editform == null, 'Successfully');
        System.assert(editform1 != null, 'Successfully');

        Test.stopTest();
    }

    @isTest
    static void testSignatureSave(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];

        String sing = FormBuilderController.signatureSave(field.id,'testdemo');
        String sing1 = FormBuilderController.signatureSave(form.id,'testdemo');
        System.assert(sing != null, 'Successfully');
        System.assert(sing1 != null, 'Successfully');
    
        Test.stopTest();
    }
    @isTest
    static void testSaveFile(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];

        String savefile = FormBuilderController.SaveFile(field.id,'testdemo','None','None');
        String savefile1 = FormBuilderController.SaveFile(form.id,'testdemo','None','None');
        System.assert(savefile != null, 'Successfully');
        System.assert(savefile1 != null, 'Successfully');
    
        Test.stopTest();
    }
    @isTest
    static void testGetFieldsRecordsPage(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form__c form2 = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Name = 'Test'];
       
        List<Form_Fields__c> getfield = FormBuilderController.getFieldsRecords_page(pageno.ID);
        List<Form_Fields__c> getfield1 = FormBuilderController.getFieldsRecords_page(form.ID);
        List<Form_Fields__c> getfield2 = FormBuilderController.getFieldsRecords_page(form2.ID);
        List<Form_Fields__c> getfield3 = FormBuilderController.getFieldsRecords_page(field.ID);
        System.assert(getfield != null, 'Successfully');
        System.assert(getfield1 != null, 'Successfully');
        System.assert(getfield2 != null, 'Successfully');
        System.assert(getfield3 != null, 'Successfully');
        
        Test.stopTest();
    }
    @isTest
    static void testGetFormObject(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Name = 'Test'];
        
        List<Form__c> getobj = FormBuilderController.GetFormObject(form.id);
        List<Form__c> getobj1 = FormBuilderController.GetFormObject(field.id);
        List<Form__c> getobj2 = FormBuilderController.GetFormObject(pageno.id);
        System.assert(getobj != null, 'Successfully');
        System.assert(getobj1 != null, 'Successfully');
        System.assert(getobj2 != null, 'Successfully');
        

        Test.stopTest();
    }
    @isTest
    static void testCreaterecord(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Submission__c sub1 = [SELECT ID, Form__c,First_object_data__c,Second_object_data__c,Third_object_data__c,Other_fields_data__c FROM Form_Submission__c WHERE Form__c =: form.ID];
    
        SObject acc = new Account( Name = 'Testing');
    
        String sigUploadJsone = '{"signature1":"abc123"}';
        String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
        List<String> sigUploadFidList = new List<String>{'signature1'};
        List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};

        FormBuilderController.Subid createrec1 = FormBuilderController.createrecord(sub1,acc,sigUploadJsone,sigUploadFidList,fileUploadJsone,fileUploadFidList);
        System.assert(createrec1 != null, 'Successfully');
        
        Test.stopTest();

    }
    @isTest
    static void testCreaterecordForSecodObject(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Submission__c sub1 = [SELECT ID, Form__c,First_object_data__c,Second_object_data__c,Third_object_data__c,Other_fields_data__c FROM Form_Submission__c WHERE Form__c =: form.ID];

        String base64 = '{"fhfhgfhghf<!QF!>test.jpg<!QF!>image/jpeg":"dfghld;ghfdjgndsgkjfgjdsgnbfjkgbsdg;jkfgdsbfgjkbg;gjgh"}';
        
        SObject acc = new Account( Name = 'Testing');
        SObject att = new Attachment(Name = 'Testing',ParentId = acc.Id,Body = Blob.valueOf(base64));
        SObject con = new Contact(LastName = 'Test',Email= 'test@gmail.com',AccountId = acc.Id);
        
        String sigUploadJsone = '{"signature1":"abc123"}';
        String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
        List<String> sigUploadFidList = new List<String>{'signature1'};
        List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};
        
        List<String> lookupList = new List<String>{'AccountId'};
        
        FormBuilderController.Subid createSecObj1 = FormBuilderController.createrecord_for_secod_object(sub1,acc,con,sigUploadJsone,sigUploadFidList,fileUploadJsone,fileUploadFidList,true,lookupList,base64);
        System.assert(createSecObj1 != null, 'Successfully');
        
        Test.stopTest();
    }
    @isTest
    static void testCreaterecordForThirdObject(){ 
        
        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Submission__c sub1 = [SELECT ID, Form__c,First_object_data__c,Second_object_data__c,Third_object_data__c,Other_fields_data__c FROM Form_Submission__c WHERE Form__c =: form.ID];
        
        String base64 = '{"dfgfdgfgffg<!QF!>test.jpg<!QF!>image/jpeg":"dfghld;ghfdjgndsgkjfgjdsgnbfjkgbsdg;jkfgdsbfgjkbg;gjgh"}';

        SObject acc = new Account( Name = 'Testing');
        SObject att = new Attachment(Name = 'Testing',ParentId = acc.Id,Body = Blob.valueOf(base64));
        SObject con = new Contact(LastName = 'Test',Email= 'test@gmail.com',AccountId = acc.Id);
        SObject ca = new Case(ContactId = con.ID,Status = 'New',Origin = 'Email');

        String sigUploadJsone = '{"signature1":"abc123"}';
        String fileUploadJsone = '{"file1<!QF!>file1.txt<!QF!>pdf":"xyz456"}';
        List<String> sigUploadFidList = new List<String>{'signature1'};
        List<String> fileUploadFidList = new List<String>{'file1<!QF!>file1.txt<!QF!>pdf'};

        List<String> lookupList = new List<String>{'AccountId'};
        List<String> lookupList1 = new List<String>{'AccountId'};

        FormBuilderController.Subid createThirdObj1 = FormBuilderController.createrecord_for_third_object(sub1,acc,con,ca,sigUploadJsone,sigUploadFidList,fileUploadJsone,fileUploadFidList,true,lookupList,true,lookupList1,base64);
        System.assert(createThirdObj1 != null, 'Successfully');

        Test.stopTest();
    }
    @isTest
    static void testGetFormValidation(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Submission__c sub1 = [SELECT ID, Form__c FROM Form_Submission__c WHERE Form__c =: form.ID];
        
        List<Form_Fields__c> getform = FormBuilderController.GetFormValidation(sub1.id);
        List<Form_Fields__c> getform1 = FormBuilderController.GetFormValidation(field.id);
        System.assert(getform != null, 'Successfully');
        System.assert(getform1 != null, 'Successfully');

        Test.stopTest();
    }
    @isTest
    static void testUpdateExtList(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,Total_Submissions__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Submission__c sub1 = [SELECT ID, Form__c FROM Form_Submission__c WHERE Form__c =: form.ID];

        List<String> find = FormBuilderController.findlookupfildes('Account','Case');
        
        System.assert(field != null, 'Successfully');
        System.assert(sub1 != null, 'Successfully');

        Test.stopTest();
    }   
}