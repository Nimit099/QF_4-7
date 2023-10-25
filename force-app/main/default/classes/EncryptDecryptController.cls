/**
 * @description : Encrypt Decrypt controller Class.
 */
public with sharing class EncryptDecryptController {

    private Blob cryptoKey = blob.valueOf('QuickForm//Application//MVClouds');

    /**
     * @description : Method to Process Decryption progress method.
     * @param recId Id value.
     * @return String of Notification__c
     */
    @AuraEnabled
    public static String processEncryption(Id recId) {
        String encryptedData = '';
        try{
            EncryptDecryptController encObj = new EncryptDecryptController();
            Blob datavalue = Blob.valueOf(recId);
            Blob encryptedBlob = Crypto.encryptWithManagedIV('AES256', encObj.cryptoKey, datavalue);
            encryptedData = EncodingUtil.base64Encode(encryptedBlob);
        }catch(Exception e) {
            error_handler.insert_errordata(e,'EncryptDecryptController','processEncryption');

        }
        return encryptedData;
    }

    /**
     * @description : Method to Process Decryption progress method .
     * @param encryptedData String value.
     * @return String of Notification__c
     */
    @AuraEnabled
    public static String processDecryption(String encryptedData) {
        String decryptedData = '';
        try{
            EncryptDecryptController encObj = new EncryptDecryptController();
            Blob datavalue = EncodingUtil.base64Decode(encryptedData);
            Blob decryptedBlob = Crypto.decryptWithManagedIV('AES256', encObj.cryptoKey, datavalue);
            decryptedData = decryptedBlob.toString();
        }catch(Exception e) {
            error_handler.insert_errordata(e,'EncryptDecryptController','processDecryption');

        }
        return decryptedData;
    }
}