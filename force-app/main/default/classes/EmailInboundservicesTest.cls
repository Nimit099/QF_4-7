@isTest
private class EmailInboundservicesTest {
    @isTest
    static void testHandleInboundEmail() {

        Form__c testForm = new Form__c();
        insert testForm;

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

        Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
        testEmail.subject = 'Test Email';
        testEmail.plainTextBody = testForm.Id + ',' + testNotification.Id;

        Test.startTest();

        EmailInboundservices emailHandler = new EmailInboundservices();
        Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(testEmail, null);

        System.assertEquals(true, result.success);

        Test.stopTest();
    }
}