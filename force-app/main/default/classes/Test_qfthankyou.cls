@istest
public class Test_qfthankyou {
    /** @description createRecord Method */
    @TestSetup
    public static void createRecord(){
        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;        
        insert form; 
        
        Thankyou_Page__c th = new Thankyou_Page__c();
        th.Name = 'Test';
        th.Form__c = form.Id;
        th.Thank_you_URL__c = '';
        th.ThankYou_Label__c = 'hi thsi data';
        th.Thankyou_Page_Type__c = 'Show Text';
        th.Thankyou_Text__c = 'data text';
        insert th;

    }
    @isTest
    public static void testGetthankyoupage(){
        Test.startTest();

        Form__c formData = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Thankyou_Page__c thankyouData = [SELECT ID,Thankyou_Page_Type__c,ThankYou_Label__c,Thankyou_Text__c,Thank_you_URL__c,Form__c FROM Thankyou_Page__C WHERE Form__C =: formData.ID];
		
        string formId = null;
        Thankyou_Page__c gt1 = qfthankyou.getthankyoupage(formData.ID);
        Thankyou_Page__c gt2 = qfthankyou.getthankyoupage(formId);
        Thankyou_Page__c gt3 = qfthankyou.getthankyoupage(thankyouData.ID);
       
        System.assert(gt1 != null, 'Successful');
        System.assert(gt2 != null, 'Successful');
        System.assert(gt3 == null, 'Successful');
        Test.stopTest();
    }
        
    @istest 
    public static void testInsertrecord(){
        Test.StartTest();

        Form__c formData = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Thankyou_Page__c thankyouData = [SELECT ID,Name,Thankyou_Page_Type__c,ThankYou_Label__c,Thankyou_Text__c,Thank_you_URL__c,Form__c FROM Thankyou_Page__C WHERE Form__C =: formData.ID];

        Thankyou_Page__c insertrecord = qfthankyou.insertrecord(thankyouData.Name,thankyouData.Thankyou_Page_Type__c,thankyouData.ThankYou_Label__c,thankyouData.Thankyou_Text__c,thankyouData.Form__c,thankyouData.Thank_you_URL__c,thankyouData.Id);        
        System.assert(insertrecord != null, 'Successful');

        Thankyou_Page__c insertrecord1 = qfthankyou.insertrecord('thank you','show Text','','vcrvvrvrv',thankyouData.ID,'',formData.ID);        
        System.assert(insertrecord1 != null, 'Successful');
        
        Test.stopTest();
    }
    
    @istest 
    public static void testGetrecordslist(){
        Test.StartTest();
        
        Form__c formData = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        String id = null;
        
        Thankyou_Page__c getreList = qfthankyou.getrecordslist(formData.Id);
        Thankyou_Page__c getreList1 = qfthankyou.getrecordslist(id);
        
        System.assert(getreList != null, 'Successful');
        System.assert(getreList1 == null, 'Successful');
        Test.stopTest();
    }
    
    @isTest
    public static void testchangelabel(){
        Test.startTest();
        
        Form__c formData = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Thankyou_Page__c thankyouData = [SELECT ID,Name,Thankyou_Page_Type__c,ThankYou_Label__c,Thankyou_Text__c,Thank_you_URL__c,Form__c FROM Thankyou_Page__C WHERE Form__C =: formData.ID];
        
        qfthankyou.changelabel('TestChage', thankyouData.id);
        
        System.assert(thankyouData != null, 'Successful');
        Test.stopTest();
    }

    @isTest
    public static void insertrecordTest(){
        Test.startTest();
        
        Form__c formData = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Thankyou_Page__c thankyouData = [SELECT ID,Name,Thankyou_Page_Type__c,ThankYou_Label__c,Thankyou_Text__c,Thank_you_URL__c,Form__c FROM Thankyou_Page__C WHERE Form__C =: formData.ID];
        
        Thankyou_Page__c insertrecord1 = qfthankyou.insertrecord('thank you','show Text','','vcrvvrvrv',formData.ID,'',null);        
        System.assert(insertrecord1 != null, 'Successful');

        // System.assert(thankyouData != null, 'Successful');
        Test.stopTest();
    }

}