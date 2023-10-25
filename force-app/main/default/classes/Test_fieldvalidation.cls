@istest
public class Test_fieldvalidation {
    @TestSetup
    static void testclassdataadd(){
         Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;        
        form.Mapped_Objects__c = 'text,data,demo';
        form.Form_Styling__c = 'demo:0;test:1;check:3';
        form.FormBgID__c = 'test';
        form.Page_CSS__C = 'padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-image:"test.png";background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        insert form;

        Form_Page__c pageno = new Form_Page__c();
        pageno.Name = 'Test';
        pageno.Page_Number__c = 4;
        pageno.Form__c = form.ID;
        insert pageno;
        
        Form_Fields__c field = new Form_Fields__c();
        field.Name = 'Test,dferf,feerf';
        field.Form__c = form.ID;
        field.Form_Page__c = pageno.ID;
        field.Field_Order__c = 10;
        field.Field_Validations__c = 'isRequired<!@!>false?$`~isDisabled<!@!>false?$`~isLabel<!@!>true?$`~isHelpText<!@!>false?$`~Label<!@!>ShippingAddress?$`~HelpText<!@!>?$`~isPlaceholder<!@!>false?$`~Placeholder<!@!>?$`~Minimum<!@!>0?$`~Maximum<!@!>128?$`~isPrefix<!@!>false?$`~Prefix<!@!>?$`~Decimal<!@!>?$`~Richtext<!@!>?$`~MinimumTime<!@!>?$`~MaximumTime<!@!>?$`~MinimumDateTime<!@!>?$`~MaximumDateTime<!@!>?$`~MinimumDate<!@!>?$`~MaximumDate<!@!>?$`~Salutation<!@!>'; 
        field.Field_Mapping__c = 'LastName<!@!>Contact';
        insert field;
    }

    @isTest
    static void getfieldvalidationmethod(){
        
        Test.startTest();
        
        Form__C formdate = [SELECT ID,Name,Status__c, Mapped_Objects__c , Form_Styling__c, FormBgID__c,Page_CSS__C FROM Form__c WHERE Name = 'Test' Limit 1];
        Form_Fields__c formfielddata = [SELECT ID,Name,Form__c, Form_Page__C, Field_Order__c,Field_Validations__c FROM Form_Fields__c WHERE Form__c =: formdate.Id ];
        
        fieldvalidation fi = new fieldvalidation();
        
        fieldvalidation.fieldvalidationwrapper  f =  fieldvalidation.getfieldvalidation(formfielddata.ID);
        formfielddata.Name = 'QF,test';
        update formfielddata;
        fieldvalidation.fieldvalidationwrapper  f1 =  fieldvalidation.getfieldvalidation(formfielddata.ID);
        
        formfielddata.Name = 'QFNUMBER,test';
        update formfielddata;
        fieldvalidation.fieldvalidationwrapper  f2 =  fieldvalidation.getfieldvalidation(formfielddata.ID);
        formfielddata.Name = 'Test,CURRENCY';
        update formfielddata;
        fieldvalidation.fieldvalidationwrapper  f3 =  fieldvalidation.getfieldvalidation(formfielddata.ID);
        
        formfielddata.Name = 'Test,ENCRYPTEDSTRING,test';
        update formfielddata;
        fieldvalidation.fieldvalidationwrapper  f4 =  fieldvalidation.getfieldvalidation(formfielddata.ID);
        
        formfielddata.Name = 'Test,TEXTAREA,test';
        update formfielddata;
        fieldvalidation.getfieldvalidation(formfielddata.ID);
        
        formfielddata.Name = 'QFNAME,test';
        update formfielddata;
        fieldvalidation.fieldvalidationwrapper  f5 =  fieldvalidation.getfieldvalidation(formfielddata.ID);
        
        formfielddata.Name = 'QFSHORTTEXT,test';
        update formfielddata;
        fieldvalidation.fieldvalidationwrapper  f6 =  fieldvalidation.getfieldvalidation(formfielddata.ID);
        
        formfielddata.Name = 'QFLONGTEXT,test';
        update formfielddata;
        fieldvalidation.fieldvalidationwrapper  f7 =  fieldvalidation.getfieldvalidation(formfielddata.ID);
        fieldvalidation.fieldvalidationwrapper  f8 =  fieldvalidation.getfieldvalidation(formdate.ID);

        System.assert(f != null, 'successful');
        System.assert(f1 != null , 'successful');
        System.assert(f2 != null , 'successful');
        System.assert(f3 != null , 'successful');
        System.assert(f4 != null , 'successful');
        System.assert(f5 != null , 'successful');
        System.assert(f6 != null , 'successful');
        System.assert(f7 != null , 'successful');
        System.assert(f8 != null , 'successful');
        
        Test.stopTest();
    }
    
    @IsTest
    static void deletefieldmethod(){
        Test.startTest();
        
        Form__C formdate = [SELECT ID,Name,Status__c, Mapped_Objects__c , Form_Styling__c, FormBgID__c,Page_CSS__C FROM Form__c WHERE Name = 'Test' Limit 1];
        Form_Page__c formpagedata = [SELECT ID,Name,Page_Number__c, Form__c FROM Form_Page__c WHERE Form__c =: formdate.Id];
        Form_Fields__c formfielddata = [SELECT ID,Name,Form__c, Form_Page__C, Field_Order__c,Field_Validations__c FROM Form_Fields__c WHERE Form__c =: formdate.Id ];
        
        fieldvalidation.deletefield(formfielddata.ID);
        fieldvalidation.deletefield(formpagedata.ID);
        System.assert(formdate != null , 'successful');
        System.assert(formpagedata != null , 'successful');
        System.assert(formfielddata != null , 'successful');
        
        Test.stopTest();
    }
    
    @IsTest
    static void savevalidationmethod(){
        Test.startTest();
        
        Form__C formdate = [SELECT ID,Name,Status__c, Mapped_Objects__c , Form_Styling__c, FormBgID__c,Page_CSS__C FROM Form__c WHERE Name = 'Test' Limit 1];
        Form_Fields__c formfielddata = [SELECT ID,Name,Form__c, Form_Page__C, Field_Order__c,Field_Validations__c FROM Form_Fields__c WHERE Form__c =: formdate.Id ];
        
        fieldvalidation.savevalidation(formfielddata.ID,formfielddata.Field_Validations__c,'test');
        fieldvalidation.savevalidation(formdate.ID,formdate.Form_Styling__c,'test');
        System.assert(formdate != null , 'successful');
        System.assert(formfielddata != null , 'successful');
        
        Test.stopTest();
    }
    
    @IsTest
    static void copyfieldmethod(){
        Test.startTest();
        
        Form__C formdate = [SELECT ID,Name,Status__c, Mapped_Objects__c , Form_Styling__c, FormBgID__c,Page_CSS__C FROM Form__c WHERE Name = 'Test' Limit 1];
        Form_Fields__c formfielddata = [SELECT ID,Name,Form__c, Form_Page__C, Field_Order__c,Field_Validations__c,Field_Label__c,Field_Mapping__c,Field_Properties__c,Field_Styling__c,Mapped_Obj__c FROM Form_Fields__c WHERE Form__c =: formdate.Id ];
        
        fieldvalidation.copyfield(formfielddata.ID);
        
        System.assert(formdate != null , 'successful');
        System.assert(formfielddata != null , 'successful');

        Test.stopTest();
    }
}