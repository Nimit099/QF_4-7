@isTest
public class Test_EncryptDecryptController {
    @isTest
    public static void encryptdecryptcontrollermethod(){
        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;        
        insert form; 

        EncryptDecryptController edc = new EncryptDecryptController();
        String proencr = EncryptDecryptController.processEncryption(form.ID);
        String prodec = EncryptDecryptController.processDecryption(proencr);
        String prodec1 = EncryptDecryptController.processDecryption('test for the decrypt');
        System.assert(proencr != null, 'Successful');
        System.assert(prodec != null, 'Successful');
        System.assert(prodec1 != null, 'Successful');
    }
}