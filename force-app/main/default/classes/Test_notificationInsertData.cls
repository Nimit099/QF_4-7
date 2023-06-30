@isTest
public class Test_notificationInsertData {

    /**
     * @description createRecord - Test Setup Method 
     */
    @TestSetup
    public static void createRecord(){
        Test.startTest();

        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;        
        insert form; 

        Notification__c n = new Notification__c();
        n.To_Recipients__c = 'test@gmail.com';
        n.CC_Recipients__c =  'test1@gmail.com';
        n.Subject__c = 'Test';
        n.Email_Body__c = 'test the email body';
        n.Attachment__c = false;
        n.BCC_Recipients__c = '';
        n.Form__c = form.ID;
        insert n;
    
        Test.stopTest();
    }

    @IsTest
   public static void testCreate(){
        Test.startTest();

        Form__c formData = [SELECT id,Name,Status__c FROM Form__c WHERE Name = 'Test'];
        Notification__c notificationData = [SELECT ID,To_Recipients__c,CC_Recipients__c,Subject__c,Email_Body__c,Attachment__c,BCC_Recipients__c,Form__c,Status__c FROM Notification__c WHERE Form__c =: formData.ID];
        
        notificationInsertData.create(notificationData);
        
        System.assert(notificationData != null, 'Successful');
        
        Test.stopTest();
    }
    @IsTest
   public static void testUpdate(){
        Test.startTest();
        
        Form__c formData = [SELECT id,Name,Status__c FROM Form__c WHERE Name = 'Test'];
        Notification__c notificationData = [SELECT ID,To_Recipients__c,CC_Recipients__c,Subject__c,Email_Body__c,Attachment__c,BCC_Recipients__c,Form__c FROM Notification__c WHERE Form__c =: formData.ID];

        Notification__c n1 = new Notification__c();
        n1.To_Recipients__c = 'test@gmail.com';
        n1.CC_Recipients__c =  'test1@gmail.com';
        n1.Subject__c = 'demo';
        n1.Email_Body__c = 'testdemo the email body';
        n1.Attachment__c = true;
        n1.BCC_Recipients__c = '';

        
        Notification__c updateNotification = notificationInsertData.updated(notificationData);
        Notification__c updateNotification1 = notificationInsertData.updated(n1);
        System.assert(updateNotification != null, 'Successful');
        System.assert(updateNotification1 == null, 'Successful');

        Test.stopTest();
    }
    @IsTest
   public static void testGetContactList(){
        Test.startTest();    
        Form__c formData = [SELECT id,Name,Status__c FROM Form__c WHERE Name = 'Test'];
		Notification__c notificationData = [SELECT ID,To_Recipients__c,CC_Recipients__c,Subject__c,Email_Body__c,Attachment__c,BCC_Recipients__c,Form__c FROM Notification__c WHERE Form__c =: formData.ID];
        
        String formId = null;
        List<Notification__c> getcon = notificationInsertData.getContactList(formData.id);
        List<Notification__c> getcon1 = notificationInsertData.getContactList(formId);
        System.assert(getcon != null, 'Successful');
        System.assert(getcon1 != null, 'Successful');
        
        Test.stopTest();
    }

    @istest
   public static void testGetNotificationByStatus() {
        Test.startTest();
        Form__c formData = [SELECT id,Name,Status__c FROM Form__c WHERE Name = 'Test'];
		Notification__c notificationData = [SELECT ID,To_Recipients__c,CC_Recipients__c,Subject__c,Email_Body__c,Attachment__c,BCC_Recipients__c,Form__c FROM Notification__c WHERE Form__c =: formData.ID];

        List<Notification__c> getNotification = notificationInsertData.getNotificationByStatus(formData.id,true);
        List<Notification__c> getNotification1 = notificationInsertData.getNotificationByStatus(formData.id,false);
        System.assert(getNotification != null, 'Successful');
        System.assert(getNotification1 != null, 'Successful');
        
        List<Notification__c> getNotification2 = notificationInsertData.getNotificationByStatus(notificationData.id,false);        

        Test.stopTest();
    }

}