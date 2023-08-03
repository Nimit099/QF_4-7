/**
 * @description error_handler Class
 */
public with sharing class error_handler {
     /** @description class_name variable */
    public Static String class_name = '';
     /** @description method_name variable */
    public Static String method_name = '';

     /**
        Method Name : insert_errordata 
        @param e to stored the Exception 
        @param classname to stored the class name
        @param methodname to stored the method name  
        @description insert error data into the obeject as record
    */
    public static Id insert_errordata(Exception e,String classname, String methodname) {
        class_name = classname;
        method_name = methodname;
        
            Error_Handler__c error = new Error_Handler__C();
        
            error.Exception_Message__c = e.getMessage();
            error.Exception_Type__c = e.getTypeName();
            error.Line_Number__c = String.valueOf(e.getLineNumber());
            error.More_Details__c = e.getStackTraceString();
            error.Class_Name__c = class_name;
            error.Method_Name__c = method_name;
            if (Schema.sObjectType.Error_Handler__c.isCreateable() && Schema.sObjectType.Error_Handler__c.fields.Exception_Message__c.isCreateable() 
            && Schema.sObjectType.Error_Handler__c.fields.Exception_Type__c.isCreateable()
            && Schema.sObjectType.Error_Handler__c.fields.Line_Number__c.isCreateable() && Schema.sObjectType.Error_Handler__c.fields.More_Details__c.isCreateable()
            && Schema.sObjectType.Error_Handler__c.fields.Method_Name__c.isCreateable() && Schema.sObjectType.Error_Handler__c.fields.Class_Name__c.isCreateable()
            ) {
                insert error;  
                return error.Id;       
            }
            return null;
    }
}