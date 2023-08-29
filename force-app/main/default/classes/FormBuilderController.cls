/**
 * @description FormBuilderController Class
 */
public with sharing class FormBuilderController{
    /**
     * @description GetFieldsMetaData Method
     * @return List of BaseField_mdt__mdt
     */
    @AuraEnabled
    public static List<BaseField_mdt__mdt> GetFieldsMetaData(){
        /*This method is used to get metadata.*/
        try{
            List<BaseField_mdt__mdt> basefield = BaseField_mdt__mdt.getAll().values();
            return basefield;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description GetStyles Method
     * @return StylesWrapper
     */
    @AuraEnabled
    public static StylesWrapper GetStyles(){
        /*This method is used to pass data in js */
        try{
            StylesWrapper sw = new StylesWrapper();
            sw.AlignmentProp = Alignment__mdt.getAll().values();
            sw.Btn_AlignmentProp = Btn_Alignment__mdt.getAll().values();
            sw.BgPositionProp = Background_position__mdt.getAll().values();
            sw.BgRepeatProp = Background_repeat__mdt.getAll().values();
            sw.BgsizeProp = Background_size__mdt.getAll().values();
            sw.BorderStylesProp = Border_styles__mdt.getAll().values();
            sw.FixPosProp = Fix_position__mdt.getAll().values();
            sw.FontProp = Font__mdt.getAll().values();
            sw.FontLineHeightProp = Font_Line_Height__mdt.getAll().values();
            sw.FontStyleProp = Font_Style__mdt.getAll().values();
            sw.FontWeightProp = Font_Weight__mdt.getAll().values();
            return sw;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description getFields Method
     * @param id String Value
     * @return List of List of String
     */
    @Auraenabled
    public static List<List<String>> getFields(String id){
        /*This method is used to get Field's Data.*/
        try{
            List<String> types = new List<String>();
            Form__c formDetail = [SELECT Id, Mapped_Objects__c
                                  FROM Form__c
                                  WHERE Id = :id
                                  WITH SECURITY_ENFORCED
                                  LIMIT 1];
            types = (formDetail.Mapped_Objects__c).split(',');
            List<List<String>> allFields = new List<List<String>>();
            List<List<String>> allReqiredFields = new List<List<String>>();
            List<Form_Fields__c> fieldList = new List<Form_Fields__c>();
            for (String type : types){
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchema = schemaMap.get(type) ;
                Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                List<String> fields = new List<String>();
                Set<String> compoundFields = new Set<String>();
                Integer position = 0;
                for (String fieldName : fieldMap.keySet()){
                    if (type == 'Event' && fieldName == 'DurationInMinutes'){
                        continue;
                    } else{
                        if ((fieldMap.get(fieldName).getDescribe().getRelationshipName() != null && fieldMap.get(fieldName).getDescribe().isUpdateable() && fieldMap.get(fieldName).getDescribe().isCreateable()) || ((fieldMap.get(fieldName).getDescribe().isUpdateable() && (fieldMap.get(fieldName).getDescribe().getType() == Schema.DisplayType.BOOLEAN || fieldMap.get(fieldName).getDescribe().isNillable() == true)) && fieldMap.get(fieldName).getDescribe().getCalculatedFormula() == null) && fieldMap.get(fieldName).getDescribe().isCreateable()){
                            if (fieldMap.get(fieldName).getDescribe().getCompoundFieldName() == null){
                                fields.add(fieldMap.get(fieldName).getDescribe().getLabel() + './.' + fieldMap.get(fieldName).getDescribe().getType() + './.' + type);
                            } else{
                                String temp = fieldMap.get(fieldName).getDescribe().getCompoundFieldName();
                                String type1 = '';
                                boolean hasAddress = temp.Contains('Address');
                                if (hasAddress){
                                    type1 = 'QFADDRESS';
                                    compoundFields.add(temp + './.' + type1 + './.' + type);
                                }
                            }
                        }
                    }
                }
                fields.addAll(compoundFields);
                allFields.add(fields);
            }
            return allFields;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description UploadFormImage Method
     * @param id String Value
     * @param body String Value
     * @param FName String Value
     * @param Type String Value
     * @return String
     */
    @AuraEnabled
    public static String UploadFormImage(String id, String body, String FName, String Type){
        try{
            Blob b = EncodingUtil.base64Decode(body);
            ContentVersion cv = new ContentVersion();
            cv.Title = FName;
            cv.PathOnClient = FName;
            cv.VersionData = b;
            cv.IsMajorVersion = true;

            if (Schema.sObjectType.ContentVersion.fields.Title.isCreateable() && Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable() && Schema.sObjectType.ContentVersion.fields.VersionData.isCreateable() && Schema.sObjectType.ContentVersion.fields.IsMajorVersion.isCreateable() && Schema.sObjectType.ContentVersion.fields.Title.isAccessible() && Schema.sObjectType.ContentVersion.fields.PathOnClient.isAccessible() && Schema.sObjectType.ContentVersion.fields.VersionData.isAccessible() && Schema.sObjectType.ContentVersion.fields.IsMajorVersion.isAccessible()){
                insert cv;
            }

            Form__c nform = [SELECT id, Form_Styling__c, FormBgID__c
                             FROM Form__c
                             where Id = :id
                             WITH SECURITY_ENFORCED];
            String fullFileURL;
            String url = '/sfc/servlet.shepherd/version/download/' + cv.id;
            if (nform.Form_Styling__c == null){
                nform.Form_Styling__c = 'background-image:' + 'url("/sfc/servlet.shepherd/version/download/' + cv.id + '")';
            } else{
                List<String> lst = nform.Form_Styling__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == 'background-image'){
                        fullFileURL = 'url("/sfc/servlet.shepherd/version/download/' + cv.id + '")';
                        lst2[1] = fullFileURL;
                        lst[i] = String.join(lst2, ':');
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    fullFileURL = 'url("/sfc/servlet.shepherd/version/download/' + cv.id + '")';
                    nform.Form_Styling__c += 'background-image:' + fullFileURL;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.Form_Styling__c = fvalue;
                }
            }
            if ((nform.Form_Styling__c).substring(nform.Form_Styling__c.length() - 1, nform.Form_Styling__c.length()) != ';'){
                nform.Form_Styling__c += ';';
            }
            nform.FormBgID__c = cv.id;
            if (Schema.sObjectType.Form__c.fields.Form_Styling__c.isAccessible() && Schema.sObjectType.Form__c.fields.FormBgID__c.isAccessible() && Schema.sObjectType.Form__c.fields.Form_Styling__c.isUpdateable() && Schema.sObjectType.Form__c.fields.FormBgID__c.isUpdateable()){
                update nform;
            }
            return nform.Form_Styling__c + ',' + url;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description UploadPageImage Method
     * @param id String Value
     * @param body String Value
     * @param FName String Value
     * @param Type String Value
     * @return String
     */
    @AuraEnabled
    public static String UploadPageImage(String id, String body, String FName, String Type){
        try{
            Attachment a = new Attachment();
            Blob b = EncodingUtil.base64Decode(body);
            ContentVersion cv = new ContentVersion();
            cv.Title = FName;
            cv.PathOnClient = FName;
            cv.VersionData = b;
            cv.IsMajorVersion = true;
            if (Schema.sObjectType.ContentVersion.fields.Title.IsCreateable() && Schema.sObjectType.ContentVersion.fields.PathOnClient.IsCreateable() && Schema.sObjectType.ContentVersion.fields.IsMajorVersion.IsCreateable()){
                insert cv;
            }
            Form__c nform = [SELECT id, Page_CSS__c, PageBgID__c
                             FROM Form__c
                             where Id = :id];
            String fullFileURL;
            String url = '/sfc/servlet.shepherd/version/download/' + cv.id;
            if (nform.Page_CSS__c == null){
                nform.Page_CSS__c = 'background-image:' + 'url("/sfc/servlet.shepherd/version/download/' + cv.id + '")';
            } else{
                List<String> lst = nform.Page_CSS__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == 'background-image'){
                        fullFileURL = 'url("/sfc/servlet.shepherd/version/download/' + cv.id + '")';
                        lst2[1] = fullFileURL;
                        lst[i] = String.join(lst2, ':');
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    fullFileURL = 'url("/sfc/servlet.shepherd/version/download/' + cv.id + '")';
                    nform.Page_CSS__c += 'background-image:' + fullFileURL;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.Page_CSS__c = fvalue;
                }
            }
            if ((nform.Page_CSS__c).substring(nform.Page_CSS__c.length() - 1, nform.Page_CSS__c.length()) != ';'){
                nform.Page_CSS__c += ';';
            }
            nform.PageBgID__c = cv.id;
            if (Schema.sObjectType.Form__c.fields.PageBgID__c.isUpdateable() && Schema.sObjectType.Form__c.fields.Page_CSS__c.isUpdateable() && Schema.sObjectType.Form__c.fields.PageBgID__c.isAccessible() && Schema.sObjectType.Form__c.fields.Page_CSS__c.isAccessible()){  
                update nform;
            }
            return nform.Page_CSS__c + ',' + url;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description RemoveFormImage Method
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String RemoveFormImage(String id){
        /*This method is used to Remove Form Image in Attachment object */
        try{
            Form__c nform = [SELECT id, Form_Styling__c, FormBgID__c
                             FROM Form__c
                             where Id = :id];
            ContentVersion cv = [SELECT Id, ContentDocumentId
                                 FROM ContentVersion
                                 WHERE Id = :nform.FormBgID__c
                                 WITH SECURITY_ENFORCED];
            ContentDocument cd = [SELECT Id
                                  FROM ContentDocument
                                  WHERE Id = :cv.ContentDocumentId
                                  WITH SECURITY_ENFORCED];
            if (ContentDocument.sObjectType.getDescribe().isDeletable()){
                delete cd;
            }
            String str = nform.Form_Styling__c;
            List<String> arr = str.split(';background-image:');
            List<string> arr2 = arr[1].split(';');
            arr2.remove(0);
            arr[1] = String.join(arr2, ';');

            str = String.join(arr, ';');
            nform.Form_Styling__c = str;
            nform.FormBgID__c = null;
            if (Schema.sObjectType.Form__c.fields.Form_Styling__c.isUpdateable() && Schema.sObjectType.Form__c.fields.Form_Styling__c.isAccessible() && Schema.sObjectType.Form__c.fields.FormBgID__c.isUpdateable() && Schema.sObjectType.Form__c.fields.FormBgID__c.isAccessible()){
                update nform;
            }
            return nform.Form_Styling__c;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description RemovePageImage Method
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String RemovePageImage(String id){
        /*This method is used to Remove Page Image in Attachment object */
        try{

            Form__c nform = [SELECT id, Page_CSS__c, PageBgID__c
                             FROM Form__c
                             WHERE Id = :id
                             WITH SECURITY_ENFORCED];
            ContentVersion cv = [SELECT Id, ContentDocumentId
                                 FROM ContentVersion
                                 WHERE Id = :nform.PageBgID__c
                                 WITH SECURITY_ENFORCED];
            ContentDocument cd = [SELECT Id
                                  FROM ContentDocument
                                  WHERE Id = :cv.ContentDocumentId
                                  WITH SECURITY_ENFORCED];
            if (ContentDocument.sObjectType.getDescribe().isDeletable()){
                delete cd;
            }
            nform.PageBgID__c = null;
            String str = nform.Page_CSS__c;
            List<String> arr = str.split(';background-image:');
            List<string> arr2 = arr[1].split(';');
            arr2.remove(0);
            arr[1] = String.join(arr2, ';');

            str = String.join(arr, ';');
            nform.Page_CSS__c = str;
            nform.PageBgID__c = null;

            if (Schema.sObjectType.Form__c.fields.Page_CSS__c.isUpdateable() && Schema.sObjectType.Form__c.fields.Page_CSS__c.isAccessible() && Schema.sObjectType.Form__c.fields.PageBgID__c.isUpdateable() && Schema.sObjectType.Form__c.fields.PageBgID__c.isAccessible()){
                update nform;
            }
            return nform.Page_CSS__c;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description StoreBtnStyles Method
     * @param Value String Value
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String StoreBtnStyles(String Value, String id){
        /*This method is used to store button css in form object */
        String result = '';
        try{
            Form__c nform = [SELECT Id, Button_CSS__c
                             FROM Form__c
                             WHERE Id = :id];
            String st = nform.Button_CSS__c;
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.Button_CSS__c == null){
                nform.Button_CSS__c = Value;
            } else{
                List<String> lst = nform.Button_CSS__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        lst[i] = String.join(lst2, ':');
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.Button_CSS__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.Button_CSS__c = fvalue;
                }
            }
            if ((nform.Button_CSS__c).substring(nform.Button_CSS__c.length() - 1, nform.Button_CSS__c.length()) != ';'){
                nform.Button_CSS__c += ';';
            }
            if (Schema.sObjectType.Form__c.fields.Button_CSS__c.isUpdateable() && Schema.sObjectType.Form__c.fields.Button_CSS__c.isAccessible()){
                update nform;
            }
            result = nform.Button_CSS__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StoreBtnStyles');
            result = e.getMessage();
        }
        return result;
    }

    /**
     * @description StoreBtnposition Method
     * @param Value String Value
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String StoreBtnposition(String Value, String id){
        /*This method is used to store button position in form object */
        try{
            if (Schema.sObjectType.Form__c.fields.Button_Position__c.IsAccessible() && Schema.sObjectType.Form__c.fields.Button_Position__c.IsUpdateable()){
                Form__c nform = [SELECT Id, Button_Position__c
                                 FROM Form__c
                                 WHERE Id = :id];
                nform.Button_Position__c = value;
                update nform;
                return nform.Button_Position__c;
            } else{
                return null;
            }
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StoreBtnposition');
            return null;
        }
    }

    /**
     * @description StoreLabelStyles Method
     * @param Value String Value
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String StoreLabelStyles(String Value, String id){
        /*This method is used to store labels css in form object */
        String result = '';
        try{
            Form__c nform = [SELECT Id, Label_CSS__c
                             FROM Form__c
                             WHERE Id = :id];
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.Label_CSS__c == null){
                nform.Label_CSS__c = Value;
            } else{
                List<String> lst = nform.Label_CSS__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        lst[i] = String.join(lst2, ':');
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.Label_CSS__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.Label_CSS__c = fvalue;
                }
            }
            if ((nform.Label_CSS__c).substring(nform.Label_CSS__c.length() - 1, nform.Label_CSS__c.length()) != ';'){
                nform.Label_CSS__c += ';';
            }
            if (Schema.sObjectType.Form__c.fields.Label_CSS__c.IsAccessible() && Schema.sObjectType.Form__c.fields.Label_CSS__c.IsUpdateable()){
                update nform;
            }
            result = nform.Label_CSS__c;
        } catch (Exception e){
            result = e.getMessage();
        }
        return result;
    }

    /**
     * @description StoreFormStyles Method
     * @param Value String Value
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String StoreFormStyles(String Value, String id){
        /*This method is used to store Form css in form object */
        String result = '';
        try{
            Form__c nform = [SELECT Id, Form_Styling__c
                             FROM Form__c
                             WHERE Id = :id];
            String st = nform.Form_Styling__c;
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.Form_Styling__c == null){
                nform.Form_Styling__c = Value;
            } else{
                List<String> lst = nform.Form_Styling__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        lst[i] = String.join(lst2, ':');
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.Form_Styling__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.Form_Styling__c = fvalue;
                }
            }
            if ((nform.Form_Styling__c).substring(nform.Form_Styling__c.length() - 1, nform.Form_Styling__c.length()) != ';'){
                nform.Form_Styling__c += ';';
            }
            if (Schema.sObjectType.Form__c.fields.Form_Styling__c.IsAccessible() && Schema.sObjectType.Form__c.fields.Form_Styling__c.IsUpdateable()){
                update nform;
            }
            result = nform.Form_Styling__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StoreFormStyles');
            result = e.getMessage();
        }
        return result;
    }

    /**
     * @description StorePageStyles Method
     * @param Value String Value
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String StorePageStyles(String Value, String id){
        /*This method is used to store Page css in form object */
        String result = '';
        try{
            Form__c nform = [SELECT Id, Page_CSS__c
                             FROM Form__c
                             WHERE Id = :id];
            String st = nform.Page_CSS__c;
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.Page_CSS__c == null){
                nform.Page_CSS__c = Value;
            } else{
                List<String> lst = nform.Page_CSS__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        lst[i] = String.join(lst2, ':');
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.Page_CSS__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.Page_CSS__c = fvalue;
                }
            }
            if ((nform.Page_CSS__c).substring(nform.Page_CSS__c.length() - 1, nform.Page_CSS__c.length()) != ';'){
                nform.Page_CSS__c += ';';
            }
            if (Schema.sObjectType.Form__c.fields.Page_CSS__c.isUpdateable() && Schema.sObjectType.Form__c.fields.Page_CSS__c.isAccessible()){
                update nform;
            }
            result = nform.Page_CSS__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StorePageStyles');
            result = e.getMessage();
        }
        return result;
    }

    /**
     * @description StoreStyles Method
     * @param Value String Value
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String StoreStyles(String Value, String id){
        String result = '';
        try{
            Form__c nform = [SELECT Id, All_Field_Styling__c
                             FROM Form__c
                             WHERE Id = :id];
            String st = nform.All_Field_Styling__c;
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.All_Field_Styling__c == null){
                nform.All_Field_Styling__c = Value;
            } else{
                List<String> lst = nform.All_Field_Styling__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        lst[i] = String.join(lst2, ':');
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.All_Field_Styling__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.All_Field_Styling__c = fvalue;
                }
            }
            if ((nform.All_Field_Styling__c).substring(nform.All_Field_Styling__c.length() - 1, nform.All_Field_Styling__c.length()) != ';'){
                nform.All_Field_Styling__c += ';';
            }

            if (Schema.sObjectType.Form__c.fields.All_Field_Styling__c.isUpdateable() && Schema.sObjectType.Form__c.fields.All_Field_Styling__c.isAccessible()){
                update nform;
            }
            result = nform.All_Field_Styling__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StoreStyles');
            result = e.getMessage();
        }
        return result;
    }

    /**
     * @description getBGImages Method
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String getBGImages(String id){
        /*This method is used to get Form background Images*/
        try{
            Form__c nform = [SELECT Id, FormBgID__c, PageBgID__c
                             FROM Form__c
                             WHERE Id = :id
                             WITH SECURITY_ENFORCED];
            String str = '/sfc/servlet.shepherd/version/download/' + nform.FormBgID__c + ',' + '/sfc/servlet.shepherd/version/download/' + nform.PageBgID__c;
            return str;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description StoreHoverStyles Method
     * @param Value String Value
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String StoreHoverStyles(String Value, String id){
        /*This method is used to store fields hover css in form object */
        String result = '';
        try{
            Form__c nform = [SELECT Id, All_Field_Hover__c
                             FROM Form__c
                             WHERE Id = :id];
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.All_Field_Hover__c == null){
                nform.All_Field_Hover__c = Value;
            } else{
                List<String> lst = nform.All_Field_Hover__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        lst[i] = String.join(lst2, ':');
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.All_Field_Hover__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.All_Field_Hover__c = fvalue;
                }
            }
            if ((nform.All_Field_Hover__c).substring(nform.All_Field_Hover__c.length() - 1, nform.All_Field_Hover__c.length()) != ';'){
                nform.All_Field_Hover__c += ';';
            }
            if (Schema.sObjectType.Form__c.fields.All_Field_Hover__c.isUpdateable() && Schema.sObjectType.Form__c.fields.All_Field_Hover__c.isAccessible()){
                update nform;
            }
            result = nform.All_Field_Hover__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StoreHoverStyles');
            result = e.getMessage();
        }
        return result;
    }

    /**
     * @description StoreFocusStyles Method
     * @param Value String Value
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String StoreFocusStyles(String Value, String id){
        /*This method is used to store fields focus css in form object */
        String result = '';
        try{
            Form__c nform = [SELECT Id, All_Field_Focus__c
                             FROM Form__c
                             WHERE Id = :id];
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.All_Field_Focus__c == null){
                nform.All_Field_Focus__c = Value;
            } else{
                List<String> lst = nform.All_Field_Focus__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        lst[i] = String.join(lst2, ':');
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.All_Field_Focus__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.All_Field_Focus__c = fvalue;
                }
            }
            if ((nform.All_Field_Focus__c).substring(nform.All_Field_Focus__c.length() - 1, nform.All_Field_Focus__c.length()) != ';'){
                nform.All_Field_Focus__c += ';';
            }
            if (Schema.sObjectType.Form__c.fields.All_Field_Focus__c.isUpdateable() && Schema.sObjectType.Form__c.fields.All_Field_Focus__c.isAccessible()){
                update nform;
            }
            result = nform.All_Field_Focus__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StoreFocusStyles');
            result = e.getMessage();
        }
        return result;
    }

    /**
     * @description formdetails Method
     * @param id String Value
     * @return Form__c
     */
    @AuraEnabled
    public static Form__c formdetails(Id id){
        /*This method is used to get all the CSS of the form into a form object.*/
        try{
            Form__c nform = [SELECT Id, Name, Progress_Indicator__c, Captcha_Type__c, Button_CSS__c, Button_Position__c, Page_CSS__c, Form_Styling__c, All_Field_Hover__c, All_Field_Focus__c, All_Field_Styling__c, Label_CSS__c, FormBgID__c, PageBgID__c, Form_Description__c
                             FROM Form__c
                             WHERE Id = :id
                             WITH SECURITY_ENFORCED];
            return nform;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description getcaptcha Method
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String getcaptcha(String id){
        /*This method is used to get captcha type of the form.*/
        try{
            Form__c nform = [SELECT Id, Captcha_Type__c
                             FROM Form__c
                             WHERE Id = :id
                             WITH SECURITY_ENFORCED];
            return nform.Captcha_Type__c;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description GetFormPage Method
     * @param Form_Id String Value
     * @return List of Form_Page__c
     */
    @AuraEnabled
    public static List<Form_Page__c> GetFormPage(String Form_Id){
        try{
            List<Form_Page__c> pageList = [SELECT Id, Name, Page_Number__c
                                           FROM Form_Page__c
                                           WHERE Form__c = :Form_Id
                                           WITH SECURITY_ENFORCED
                                           ORDER BY Page_Number__c ASC];
            return pageList;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description StylesWrapper class
     */
    public class StylesWrapper{
        /*This method is used to pass background image properties.*/
        /** @description AlignmentProp - List of Alignment__mdt */
        @AuraEnabled
        public list<Alignment__mdt> AlignmentProp{ get; set; }

        /** @description Btn_AlignmentProp - List of Btn_Alignment__mdt */
        @AuraEnabled
        public list<Btn_Alignment__mdt> Btn_AlignmentProp{ get; set; }

        /** @description BgPositionProp - List of Background_position__mdt */
        @AuraEnabled
        public list<Background_position__mdt> BgPositionProp{ get; set; }

        /** @description BgRepeatProp - List of Background_repeat__mdt */
        @AuraEnabled
        public list<Background_repeat__mdt> BgRepeatProp{ get; set; }

        /** @description BgsizeProp - List of Background_size__mdt */
        @AuraEnabled
        public list<Background_size__mdt> BgsizeProp{ get; set; }

        /** @description BorderStylesProp - List of Border_styles__mdt */
        @AuraEnabled
        public list<Border_styles__mdt> BorderStylesProp{ get; set; }

        /** @description FixPosProp - List of Fix_position__mdt */
        @AuraEnabled
        public list<Fix_position__mdt> FixPosProp{ get; set; }

        /** @description FontProp - List of Font__mdt */
        @AuraEnabled
        public list<Font__mdt> FontProp{ get; set; }

        /** @description FontLineHeightProp - List of Font_Line_Height__mdt */
        @AuraEnabled
        public list<Font_Line_Height__mdt> FontLineHeightProp{ get; set; }

        /** @description FontStyleProp - List of Font_Style__mdt */
        @AuraEnabled
        public list<Font_Style__mdt> FontStyleProp{ get; set; }

        /** @description FontWeightProp - List of Font_Weight__mdt */
        @AuraEnabled
        public list<Font_Weight__mdt> FontWeightProp{ get; set; }

    }

    /**
     * @description getScaleRating Method
     * @return List of Scale_Rating__mdt
     */
    @AuraEnabled
    public static List<Scale_Rating__mdt> getScaleRating(){
        /*This method is used to pass scale rating metadata in js.*/
        try{
            return Scale_Rating__mdt.getAll().values();
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description CreateFieldRecord Method
     * @param Form_Id String Value
     * @param Name String Value
     * @param Form_Page_Id String Value
     * @param Position Decimal Value
     * @param isold Boolean Value
     * @param Field_Page_Id String Value
     * @param obj String Value
     * @return List of Form_Fields__c
     */
    @AuraEnabled
    public static List<Form_Fields__c> CreateFieldRecord(String Form_Id, String Name, String Form_Page_Id, Decimal Position, boolean isold, String Field_Page_Id, String obj){
        try{
            Form_Fields__c field = new Form_Fields__c();
            List<Form_Fields__c> updateList = new List<Form_Fields__c>();

            List<Form_Fields__c> fieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Mapping__c
                                              FROM Form_Fields__c
                                              WHERE Form_Page__c = :Form_Page_Id
                                              WITH SECURITY_ENFORCED
                                              ORDER BY Field_Order__c ASC];
            if (Field_Page_Id != ''){
                Form_Fields__c field_which_page_changed = [SELECT Id, Form_Page__c
                                                           FROM Form_Fields__c
                                                           WHERE Id = :Name
                                                           WITH SECURITY_ENFORCED
                                                           ORDER BY Field_Order__c ASC];
                field_which_page_changed.Form_Page__c = Form_Page_Id;
                if (Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsUpdateable()){
                    update field_which_page_changed;
                }
            }
            for (Form_Fields__c it : fieldList){
                if (it.Field_Order__c > Position){
                    if (isold){
                        if (it.Id == Name){
                            it.Field_Order__c = Position + 1;
                        } else{
                            it.Field_Order__c = it.Field_Order__c + 1;
                        }
                    } else{
                        it.Field_Order__c = it.Field_Order__c + 1;
                    }
                    updateList.add(it);
                }
            }
            if (!updateList.isEmpty() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.IsUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsUpdateable() &&  Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Form__c.IsAccessible() ){
                update updateList;
            }
            if (!isold){
                string form = [SELECT Mapped_Objects__c
                               from Form__c
                               WHERE Id = :Form_Id
                               WITH SECURITY_ENFORCED].Mapped_Objects__c;
                List<String> Objects = form.split(',');
                List<String> label = Name.split(',');
                String firstLabel = label[0];
                String secondlabel = label[1];
                for (String type : Objects){
                    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                    Schema.SObjectType leadSchema = schemaMap.get(type) ;
                    Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                    List<String> Fields = new List<String>();
                    for (String fieldName : fieldMap.keySet()){
                        if (fieldMap.get(fieldName).getDescribe().isCreateable()){
                            if (fieldMap.get(fieldName).getDescribe().getLabel() == firstLabel){
                                if (obj == type){
                                    field.Mapped_Obj__c = type;
                                    field.Field_Mapping__c = fieldMap.get(fieldName) + '<!@!>' + type;
                                    if (!fieldName.contains('QF')){
                                        if (String.valueOf(fieldMap.get(fieldName).getDescribe().getType()) == 'DOUBLE' || String.valueOf(fieldMap.get(fieldName).getDescribe().getType()) == 'CURRENCY' || String.valueOf(fieldMap.get(fieldName).getDescribe().getType()) == 'PERCENT'){
                                            field.Field_Validations__c = 'isRequired<!@!>false' + 
                                                            '?$`~isDisabled<!@!>false' + 
                                                            '?$`~isLabel<!@!>true' + 
                                                            '?$`~isHelpText<!@!>false' + 
                                                            '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                                                            '?$`~HelpText<!@!>' + 
                                                            '?$`~isPlaceholder<!@!>false' + 
                                                            '?$`~Placeholder<!@!>' + 
                                                            '?$`~Minimum<!@!>0' + 
                                                            '?$`~Maximum<!@!>' + fieldMap.get(fieldName).getDescribe().getPrecision() + 
                                                            '?$`~isPrefix<!@!>false' + 
                                                            '?$`~Prefix<!@!>' + 
                                                            '?$`~Decimal<!@!>' + 
                                                            '?$`~Richtext<!@!>' + 
                                                            '?$`~MinimumTime<!@!>' + 
                                                            '?$`~MaximumTime<!@!>' + 
                                                            '?$`~MinimumDateTime<!@!>' + 
                                                            '?$`~MaximumDateTime<!@!>' + 
                                                            '?$`~MinimumDate<!@!>' + 
                                                            '?$`~MaximumDate<!@!>' + 
                                                            '?$`~Salutation<!@!>';
                                        } else if (String.valueOf(fieldMap.get(fieldName).getDescribe().getType()) == 'STRING' || String.valueOf(fieldMap.get(fieldName).getDescribe().getType()) == 'TEXTAREA' || String.valueOf(fieldMap.get(fieldName).getDescribe().getType()) == 'ENCRYPTEDSTRING'){
                                            field.Field_Validations__c = 'isRequired<!@!>false' + 
                                                            '?$`~isDisabled<!@!>false' + 
                                                            '?$`~isLabel<!@!>true' + 
                                                            '?$`~isHelpText<!@!>false' + 
                                                            '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                                                            '?$`~HelpText<!@!>' + 
                                                            '?$`~isPlaceholder<!@!>false' + 
                                                            '?$`~Placeholder<!@!>' + 
                                                            '?$`~Minimum<!@!>0' + 
                                                            '?$`~Maximum<!@!>' + fieldMap.get(fieldName).getDescribe().getLength() + 
                                                            '?$`~isPrefix<!@!>false' + 
                                                            '?$`~Prefix<!@!>' + 
                                                            '?$`~Decimal<!@!>' + 
                                                            '?$`~Richtext<!@!>' + 
                                                            '?$`~MinimumTime<!@!>' + 
                                                            '?$`~MaximumTime<!@!>' + 
                                                            '?$`~MinimumDateTime<!@!>' + 
                                                            '?$`~MaximumDateTime<!@!>' + 
                                                            '?$`~MinimumDate<!@!>' + 
                                                            '?$`~MaximumDate<!@!>' + 
                                                            '?$`~Salutation<!@!>';
                                        } else{
                                            field.Field_Validations__c = 'isRequired<!@!>false' + 
                                                            '?$`~isDisabled<!@!>false' + 
                                                            '?$`~isLabel<!@!>true' + 
                                                            '?$`~isHelpText<!@!>false' + 
                                                            '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                                                            '?$`~HelpText<!@!>' + 
                                                            '?$`~isPlaceholder<!@!>false' + 
                                                            '?$`~Placeholder<!@!>' + 
                                                            '?$`~Minimum<!@!>0' + 
                                                            '?$`~Maximum<!@!>255' + 
                                                            '?$`~isPrefix<!@!>false' + 
                                                            '?$`~Prefix<!@!>' + 
                                                            '?$`~Decimal<!@!>' + 
                                                            '?$`~Richtext<!@!>' + 
                                                            '?$`~MinimumTime<!@!>' + 
                                                            '?$`~MaximumTime<!@!>' + 
                                                            '?$`~MinimumDateTime<!@!>' + 
                                                            '?$`~MaximumDateTime<!@!>' + 
                                                            '?$`~MinimumDate<!@!>' + 
                                                            '?$`~MaximumDate<!@!>' + 
                                                            '?$`~Salutation<!@!>';
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (Position == 0){
                    Form_Fields__c maxPostion = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Mapping__c
                                                 FROM Form_Fields__c
                                                 WITH SECURITY_ENFORCED
                                                 ORDER BY Field_Order__c DESC
                                                 LIMIT 1];
                    if (maxPostion != null){
                        Position = maxPostion.Field_Order__c;
                    }
                }
                field.Name = Name;
                field.Form__c = Form_Id;
                field.Form_Page__c = Form_Page_Id;
                field.Field_Order__c = Position + 1;
                field.Field_Label__c = Name.split(',')[0].replace('QF', '').toUpperCase();
                if (Name.split(',')[0].contains('QF') || Name.split(',')[1].contains('QF')){
                    if (Name.split(',')[0].replace('QF', '') == 'RADIOBUTTON' || Name.split(',')[0].replace('QF', '') == 'CHECKBOX'){
                        field.Field_Validations__c = 'isRequired<!@!>false' + 
                             '?$`~isDisabled<!@!>false' + 
                             '?$`~isLabel<!@!>true' + 
                             '?$`~isHelpText<!@!>false' + 
                             '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                             '?$`~HelpText<!@!>' + 
                             '?$`~isPlaceholder<!@!>false' + 
                             '?$`~Placeholder<!@!>' + 
                             '?$`~Minimum<!@!>0' + 
                             '?$`~Maximum<!@!>128' + 
                             '?$`~isPrefix<!@!>false' + 
                             '?$`~Prefix<!@!>' + 
                             '?$`~Decimal<!@!>' + 
                             '?$`~Richtext<!@!>' + 
                             '?$`~MinimumTime<!@!>' + 
                             '?$`~MaximumTime<!@!>' + 
                             '?$`~MinimumDateTime<!@!>' + 
                             '?$`~MaximumDateTime<!@!>' + 
                             '?$`~MinimumDate<!@!>' + 
                             '?$`~MaximumDate<!@!>' + 
                             '?$`~Salutation<!@!>1';
                    } else if (Name.split(',')[0].replace('QF', '') == 'SCALERATING'){
                        field.Field_Validations__c = 'isRequired<!@!>false' + 
                             '?$`~isDisabled<!@!>false' + 
                             '?$`~isLabel<!@!>true' + 
                             '?$`~isHelpText<!@!>false' + 
                             '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                             '?$`~HelpText<!@!>' + 
                             '?$`~isPlaceholder<!@!>false' + 
                             '?$`~Placeholder<!@!>' + 
                             '?$`~Minimum<!@!>0' + 
                             '?$`~Maximum<!@!>128' + 
                             '?$`~isPrefix<!@!>false' + 
                             '?$`~Prefix<!@!>' + 
                             '?$`~Decimal<!@!>' + 
                             '?$`~Richtext<!@!>' + 
                             '?$`~MinimumTime<!@!>' + 
                             '?$`~MaximumTime<!@!>' + 
                             '?$`~MinimumDateTime<!@!>' + 
                             '?$`~MaximumDateTime<!@!>' + 
                             '?$`~MinimumDate<!@!>' + 
                             '?$`~MaximumDate<!@!>' + 
                             '?$`~Salutation<!@!>Very Poor?$`~Salutation<!@!>Poor?$`~Salutation<!@!>Good?$`~Salutation<!@!>Very Good?$`~Salutation<!@!>Excellent';
                    } else if (Name.split(',')[0].replace('QF', '') == 'NUMBER' || Name.split(',')[0].replace('QF', '') == 'PRICE'){
                        field.Field_Validations__c = 'isRequired<!@!>false' + 
                             '?$`~isDisabled<!@!>false' + 
                             '?$`~isLabel<!@!>true' + 
                             '?$`~isHelpText<!@!>false' + 
                             '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                             '?$`~HelpText<!@!>' + 
                             '?$`~isPlaceholder<!@!>false' + 
                             '?$`~Placeholder<!@!>' + 
                             '?$`~Minimum<!@!>0' + 
                             '?$`~Maximum<!@!>18' + 
                             '?$`~isPrefix<!@!>false' + 
                             '?$`~Prefix<!@!>' + 
                             '?$`~Decimal<!@!>' + 
                             '?$`~Richtext<!@!>' + 
                             '?$`~MinimumTime<!@!>' + 
                             '?$`~MaximumTime<!@!>' + 
                             '?$`~MinimumDateTime<!@!>' + 
                             '?$`~MaximumDateTime<!@!>' + 
                             '?$`~MinimumDate<!@!>' + 
                             '?$`~MaximumDate<!@!>' + 
                             '?$`~Salutation<!@!>';
                    } else if (Name.split(',')[0].replace('QF', '') == 'SHORTTEXT'){
                        field.Field_Validations__c = 'isRequired<!@!>false' + 
                             '?$`~isDisabled<!@!>false' + 
                             '?$`~isLabel<!@!>true' + 
                             '?$`~isHelpText<!@!>false' + 
                             '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                             '?$`~HelpText<!@!>' + 
                             '?$`~isPlaceholder<!@!>false' + 
                             '?$`~Placeholder<!@!>' + 
                             '?$`~Minimum<!@!>0' + 
                             '?$`~Maximum<!@!>255' + 
                             '?$`~isPrefix<!@!>false' + 
                             '?$`~Prefix<!@!>' + 
                             '?$`~Decimal<!@!>' + 
                             '?$`~Richtext<!@!>' + 
                             '?$`~MinimumTime<!@!>' + 
                             '?$`~MaximumTime<!@!>' + 
                             '?$`~MinimumDateTime<!@!>' + 
                             '?$`~MaximumDateTime<!@!>' + 
                             '?$`~MinimumDate<!@!>' + 
                             '?$`~MaximumDate<!@!>' + 
                             '?$`~Salutation<!@!>';
                    } else if (Name.split(',')[0].replace('QF', '') == 'LONGTEXT'){
                        field.Field_Validations__c = 'isRequired<!@!>false' + 
                             '?$`~isDisabled<!@!>false' + 
                             '?$`~isLabel<!@!>true' + 
                             '?$`~isHelpText<!@!>false' + 
                             '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                             '?$`~HelpText<!@!>' + 
                             '?$`~isPlaceholder<!@!>false' + 
                             '?$`~Placeholder<!@!>' + 
                             '?$`~Minimum<!@!>0' + 
                             '?$`~Maximum<!@!>131072' + 
                             '?$`~isPrefix<!@!>false' + 
                             '?$`~Prefix<!@!>' + 
                             '?$`~Decimal<!@!>' + 
                             '?$`~Richtext<!@!>' + 
                             '?$`~MinimumTime<!@!>' + 
                             '?$`~MaximumTime<!@!>' + 
                             '?$`~MinimumDateTime<!@!>' + 
                             '?$`~MaximumDateTime<!@!>' + 
                             '?$`~MinimumDate<!@!>' + 
                             '?$`~MaximumDate<!@!>' + 
                             '?$`~Salutation<!@!>';
                    } else if (Name.split(',')[0].replace('QF', '') == 'NAME'){
                        field.Field_Validations__c = 'isRequired<!@!>false' + 
                             '?$`~isDisabled<!@!>false' + 
                             '?$`~isLabel<!@!>true' + 
                             '?$`~isHelpText<!@!>false' + 
                             '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                             '?$`~HelpText<!@!>' + 
                             '?$`~isPlaceholder<!@!>false' + 
                             '?$`~Placeholder<!@!>' + 
                             '?$`~Minimum<!@!>0' + 
                             '?$`~Maximum<!@!>50' + 
                             '?$`~isPrefix<!@!>false' + 
                             '?$`~Prefix<!@!>' + 
                             '?$`~Decimal<!@!>' + 
                             '?$`~Richtext<!@!>' + 
                             '?$`~MinimumTime<!@!>' + 
                             '?$`~MaximumTime<!@!>' + 
                             '?$`~MinimumDateTime<!@!>' + 
                             '?$`~MaximumDateTime<!@!>' + 
                             '?$`~MinimumDate<!@!>' + 
                             '?$`~MaximumDate<!@!>' + 
                             '?$`~Salutation<!@!>';
                    } else{
                        field.Field_Validations__c = 'isRequired<!@!>false' + 
                             '?$`~isDisabled<!@!>false' + 
                             '?$`~isLabel<!@!>true' + 
                             '?$`~isHelpText<!@!>false' + 
                             '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                             '?$`~HelpText<!@!>' + 
                             '?$`~isPlaceholder<!@!>false' + 
                             '?$`~Placeholder<!@!>' + 
                             '?$`~Minimum<!@!>0' + 
                             '?$`~Maximum<!@!>255' + 
                             '?$`~isPrefix<!@!>false' + 
                             '?$`~Prefix<!@!>' + 
                             '?$`~Decimal<!@!>' + 
                             '?$`~Richtext<!@!>' + 
                             '?$`~MinimumTime<!@!>' + 
                             '?$`~MaximumTime<!@!>' + 
                             '?$`~MinimumDateTime<!@!>' + 
                             '?$`~MaximumDateTime<!@!>' + 
                             '?$`~MinimumDate<!@!>' + 
                             '?$`~MaximumDate<!@!>' + 
                             '?$`~Salutation<!@!>';
                    }
                }
                if (Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Mapped_Obj__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Name.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Mapped_Obj__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Name.IsAccessible() && Schema.sObjectType.Form__c.fields.Mapped_Objects__c.IsAccessible()){
                    insert field;
                }

                if (Name.split(',')[1] == 'Extra'){
                    field.Mapped_Obj__c = 'Extra';
                    field.Field_Mapping__c = field.Id + '<!@!>' + 'Extra';
                } else if (Name.split(',')[1] == 'QFADDRESS'){
                    for (String type : Objects){
                        if (type == obj){
                            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                            Schema.SObjectType leadSchema = schemaMap.get(type) ;
                            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                            if (Name.split(',')[1] == 'QFADDRESS'){
                                for (String fieldName : fieldMap.keySet()){
                                    if (fieldMap.get(fieldName).getDescribe().getCompoundFieldName() == firstLabel){
                                        field.Mapped_Obj__c = type;
                                        field.Field_Mapping__c = fieldMap.get(Name.split(',')[0]) + '<!@!>' + type;
                                    }
                                }
                            }
                        }
                    }
                }

                if (Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.isUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.isUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.isUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.isUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Mapped_Obj__c.isUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Name.isUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Mapped_Obj__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Name.IsAccessible() && Schema.sObjectType.Form__c.fields.Mapped_Objects__c.IsAccessible()){
                    update field;
                }
            }
            fieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c, Mapped_Obj__c
                         FROM Form_Fields__c
                         WHERE Form__c = :Form_Id
                         WITH SECURITY_ENFORCED
                         ORDER BY Field_Order__c ASC];
            return fieldList;

        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'CreateFieldRecord');
            return null;
        }
    }

    /**
     * @description addPageBreak Method
     * @param FormId String Value
     * @param Name String Value
     * @param Form_Page_Id String Value
     * @param Position Integer Value
     * @param dropFieldId String Value
     * @return pageWrapper
     */
    @AuraEnabled
    public static pageWrapper addPageBreak(Id FormId, String Name, String Form_Page_Id, Integer Position, String dropFieldId){
        try{
            List<Form_Fields__c> cuurentPageFields = new List<Form_Fields__c>();

            Form_Page__c currentFormPage = new Form_Page__c();
            cuurentPageFields = [SELECT Id, Name, Field_Order__c, Form_Page__c, Field_Mapping__c
                                 FROM Form_Fields__c
                                 WHERE Form_Page__c = :Form_Page_Id
                                 WITH SECURITY_ENFORCED
                                 ORDER BY Field_Order__c ASC];

            List<Form_Page__c> allPages = [SELECT id, Name, Page_Number__c
                                           FROM Form_Page__c
                                           WHERE Form__c = :FormId
                                           WITH SECURITY_ENFORCED
                                           ORDER BY Page_Number__c ASC];

            List<Form_Page__c> pagesToUpdateList = new List<Form_Page__c>();
            boolean isPageFind = false;

            for (Form_Page__c fp : allPages){
                if (isPageFind){
                    pagesToUpdateList.add(fp);
                }
                if (fp.Id == Form_Page_Id && isPageFind == false){
                    isPageFind = true;
                    currentFormPage = fp;
                }

            }

            Form_Page__c newFormPage = new Form_Page__c();
            newFormPage.Form__c = FormId;
            newFormPage.Name = 'New Page';
            if (currentFormPage.Page_Number__c != null){
                newFormPage.Page_Number__c = currentFormPage.Page_Number__c + 1;
            }

            if (Schema.sObjectType.Form_Page__c.fields.Form__c.IsCreateable() && Schema.sObjectType.Form_Page__c.fields.Name.isCreateable() && Schema.sObjectType.Form_Page__c.fields.Page_Number__c.isCreateable()){
                insert newFormPage;
            }

            for (Form_Page__c fp : pagesToUpdateList){
                if (fp.Page_Number__c != null){
                    fp.Page_Number__c = fp.Page_Number__c + 1;
                }
            }
            if (Schema.sObjectType.Form_Page__c.fields.Page_Number__c.isUpdateable() && Schema.sObjectType.Form_Page__c.fields.Name.isUpdateable()){
                update pagesToUpdateList;
            }

            // checking current page has any field or not
            if (String.isNotBlank(dropFieldId) && cuurentPageFields.size() > 0){
                List<Form_Fields__c> newPageFields = new List<Form_Fields__c>();
                boolean isFieldFind = false;
                for (Form_Fields__c ff : cuurentPageFields){
                    if (isFieldFind){
                        newPageFields.add(ff);
                    }
                    if (ff.Id == dropFieldId && isFieldFind == false){
                        isFieldFind = true;
                    }
                }

                for (Form_Fields__c ff : newPageFields){
                    ff.Form_Page__c = newFormPage.Id;
                }
                if (Schema.sObjectType.Form_Fields__c.fields.Name.isUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.isUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.isUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.isUpdateable()){
                    update newPageFields;
                }
            }

            pageWrapper pw = new pageWrapper();
            pw.fieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                            FROM Form_Fields__c
                            WHERE Form__c = :FormId
                            WITH SECURITY_ENFORCED
                            ORDER BY Field_Order__c ASC];
            pw.pageList = [SELECT Id, Name, Page_Number__c
                           FROM Form_Page__c
                           WHERE Form__c = :FormId
                           WITH SECURITY_ENFORCED
                           ORDER BY Page_Number__c ASC];
            return pw;

        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'addPageBreak');
            return null;
        }
    }

    /** @description pageWrapper class */
    public class pageWrapper{
        /** @description fieldList - List of Form_Fields__c */
        @AuraEnabled
        public list<Form_Fields__c> fieldList{ get; set; }

        /** @description pageList - List of Form_Page__c */
        @AuraEnabled
        public list<Form_Page__c> pageList{ get; set; }

    }

    /**
     * @description ObjName Method
     * @param id String Value
     * @return String
     */
    @AuraEnabled
    public static String ObjName(String id){
        /*This method is used to pass object name in js*/
        try{
            Form__c nform = [SELECT Id, Mapped_Objects__c
                             FROM Form__c
                             WHERE Id = :id
                             WITH SECURITY_ENFORCED];

            List<String> obj1 = nform.Mapped_Objects__c.split(',');
            String result = nform.Mapped_Objects__c;
            Map<String, String> objectIconMap = new Map<String, String>{ 'Account' => 'standard:account', 'Address' => 'standard:address', 'AlternativePaymentMethod' => 'standard:payment_gateway', 'Announcement' => 'standard:announcement', 'AppAnalyticsQueryRequest' => 'standard:care_request_reviewer', 'AppointmentTopicTimeSlot' => 'standard:timeslot', 'ApptBundleAggrDurDnscale' => 'standard:event', 'ApptBundleAggrPolicy' => 'standard:aggregation_policy', 'ApptBundleConfig' => 'standard:bundle_config', 'ApptBundlePolicy' => 'standard:bundle_policy', 'ApptBundlePolicySvcTerr' => 'standard:service_territory_policy', 'ApptBundlePropagatePolicy' => 'standard:propagation_policy', 'ApptBundleRestrictPolicy' => 'standard:restriction_policy', 'ApptBundleSortPolicy' => 'standard:sort_policy', 'Asset' => 'standard:asset_object', 'AssetDowntimePeriod' => 'standard:asset_downtime_period', 'AssetRelationship' => 'standard:asset_relationship', 'AssetWarranty' => 'standard:asset_warranty', 'AssociatedLocation' => 'standard:location', 'AttributeDefinition' => 'standard:variation_attribute_setup', 'AuthorizationForm' => 'standard:form', 'AuthorizationFormConsent' => 'standard:form', 'AuthorizationFormDataUse' => 'standard:form', 'AuthorizationFormText' => 'standard:form', 'BusinessBrand' => 'standard:store', 'CalendarView' => 'standard:date_input', 'Campaign' => 'standard:campaign', 'CampaignMember' => 'standard:campaign_members', 'CardPaymentMethod' => 'standard:contract_payment', 'Case' => 'standard:case', 'CollaborationGroup' => 'standard:live_chat', 'CollaborationGroupRecord' => 'standard:live_chat', 'CommSubscription' => 'standard:product_consumed', 'CommSubscriptionChannelType' => 'standard:channel_program_levels', 'CommSubscriptionConsent' => 'standard:product_consumed', 'CommSubscriptionTiming' => 'standard:channel_program_history', 'ConsumptionRate' => 'standard:product_consumed_state', 'ConsumptionSchedule' => 'standard:product_consumed_state', 'Contact' => 'standard:contact', 'ContactPointAddress' => 'standard:address', 'ContactPointConsent' => 'standard:address', 'ContactPointEmail' => 'standard:email', 'ContactPointPhone' => 'standard:call', 'ContactPointTypeConsent' => 'standard:contact', 'ContactRequest' => 'standard:contact_request', 'ContentVersion' => 'standard:file', 'Contract' => 'standard:contract', 'ContractGroupPlan' => 'standard:contract', 'ContractGroupPlanGroupClass' => 'standard:contract', 'ContractLineItem' => 'standard:contract_line_item', 'Customer' => 'standard:customer', 'DataUseLegalBasis' => 'standard:product_consumed', 'DataUsePurpose' => 'standard:product_consumed', 'DigitalWallet' => 'standard:connect_wallet', 'DuplicateRecordItem' => 'custom:custom49', 'DuplicateRecordSet' => 'standard:record', 'EngagementChannelType' => 'standard:channel_programs', 'Entitlement' => 'standard:entitlement', 'EntitlementContact' => 'standard:people', 'Event' => 'standard:event', 'Expense' => 'standard:expense', 'ExpenseReport' => 'standard:expense_report', 'ExpenseReportEntry' => 'standard:expense_report_entry', 'ExpressionFilter' => 'standard:filter', 'ExpressionFilterCriteria' => 'standard:filter_criteria', 'FinanceTransaction' => 'standard:crypto_transaction', 'FlowRecordRelation' => 'standard:flow', 'GroupCensus' => 'standard:groups', 'GroupCensusMember' => 'standard:groups', 'GroupCensusMemberPlan' => 'standard:groups', 'GroupClass' => 'standard:groups', 'GroupClassContribution' => 'standard:groups', 'Idea' => 'standard:solution', 'Image' => 'custom:custom38', 'Individual' => 'standard:individual', 'InsuranceContract' => 'standard:entitlement_policy', 'JobProfile' => 'standard:job_profile', 'Lead' => 'standard:lead', 'LegalEntity' => 'standard:entity', 'ListEmail' => 'standard:list_email', 'ListEmailIndividualRecipient' => 'standard:email', 'ListEmailRecipientSource' => 'standard:email', 'Location' => 'standard:location', 'LocationGroup' => 'standard:location', 'LocationGroupAssignment' => 'standard:location', 'Macro' => 'standard:macros', 'MacroInstruction' => 'standard:macros', 'MaintenanceAsset' => 'standard:maintenance_asset', 'MaintenancePlan' => 'standard:maintenance_plan', 'MaintenanceWorkRule' => 'standard:maintenance_work_rule', 'Opportunity' => 'standard:opportunity', 'Order' => 'standard:orders', 'OrgMetric' => 'standard:dashboard', 'OrgMetricScanResult' => 'standard:dashboard_ea', 'OrgMetricScanSummary' => 'standard:dashboard_component', 'PartyConsent' => 'custom:custom69', 'Payment' => 'standard:contract_payment', 'PaymentAuthAdjustment' => 'standard:contract_payment', 'PaymentAuthorization' => 'standard:contract_payment', 'PaymentGateway' => 'standard:payment_gateway', 'PaymentGatewayLog' => 'standard:payment_gateway', 'PaymentGroup' => 'standard:partner_fund_request', 'PaymentLineInvoice' => 'standard:payment_gateway', 'Pricebook2' => 'standard:pricebook', 'ProcessException' => 'standard:process_exception', 'Product2' => 'standard:product', 'ProductConsumed' => 'standard:product_consumed', 'ProductConsumptionSchedule' => 'standard:product_consumed', 'ProductItem' => 'standard:product_item', 'ProductRequest' => 'standard:product_request', 'ProductRequestLineItem' => 'standard:product_request_line_item', 'ProductRequired' => 'standard:product_required', 'ProductServiceCampaign' => 'standard:product_service_campaign', 'ProductServiceCampaignItem' => 'standard:product_service_campaign_item', 'ProductTransfer' => 'standard:product_transfer', 'ProductWarrantyTerm' => 'standard:product_warranty_term', 'ProfileSkill' => 'standard:skill', 'ProfileSkillEndorsement' => 'standard:skill_entity', 'ProfileSkillUser' => 'standard:skill_entity', 'PromptAction' => 'standard:prompt', 'PromptError' => 'standard:prompt', 'QuickText' => 'standard:quick_text', 'Recommendation' => 'standard:feedback', 'RecommendationResponse' => 'standard:feedback', 'RecordAction' => 'standard:record', 'Refund' => 'standard:contract_payment', 'RefundLinePayment' => 'standard:contract_payment', 'ResourceAbsence' => 'standard:resource_absence', 'ReturnOrder' => 'standard:return_order', 'ReturnOrderLineItem' => 'standard:return_order_line_item', 'SchedulingConstraint' => 'standard:scheduling_constraint', 'Scorecard' => 'standard:scan_card', 'ScorecardAssociation' => 'standard:scan_card', 'ScorecardMetric' => 'standard:scan_card', 'SearchPromotionRule' => 'standard:search', 'Seller' => 'standard:partner_fund_allocation', 'SerializedProduct' => 'standard:serialized_product', 'ServiceAppointment' => 'standard:service_appointment', 'ServiceContract' => 'standard:service_contract', 'ServiceCrew' => 'standard:service_crew', 'ServiceCrewMember' => 'standard:service_crew_member', 'ServiceResource' => 'standard:service_resource', 'ServiceResourcePreference' => 'standard:service_territory', 'ServiceTerritory' => 'standard:service_territory', 'ServiceTerritoryLocation' => 'standard:location', 'SetupAssistantStep' => 'standard:setup_modal', 'Shift' => 'standard:shift', 'ShiftTemplate' => 'standard:shift_template', 'Shipment' => 'standard:shipment', 'ShipmentItem' => 'standard:shipment', 'Solution' => 'standard:solution', 'Task' => 'standard:task', 'TimeSheet' => 'standard:timesheet', 'TimeSheetEntry' => 'standard:timesheet_entry', 'TravelMode' => 'standard:location', 'UnitOfMeasure' => 'custom:custom79', 'UserEmailPreferredPerson' => 'standard:people', 'WarrantyTerm' => 'standard:warranty_term', 'WorkAccess' => 'standard:work_queue', 'WorkBadge' => 'standard:skill_requirement', 'WorkBadgeDefinition' => 'standard:skill_requirement', 'WorkOrder' => 'standard:work_order', 'WorkOrderLineItem' => 'standard:work_order_item', 'WorkPlan' => 'standard:work_plan', 'WorkPlanSelectionRule' => 'standard:work_plan_rule', 'WorkPlanTemplate' => 'standard:work_plan_template', 'WorkPlanTemplateEntry' => 'standard:work_plan_template_entry', 'WorkStep' => 'standard:work_step', 'WorkStepTemplate' => 'standard:work_step_template', 'WorkThanks' => 'standard:thanks', 'WorkType' => 'standard:work_type', 'WorkTypeGroup' => 'standard:work_type_group', 'WorkTypeGroupMember' => 'standard:team_member' };
            Integer n = 0;
            for (String a : obj1){
                String str = '';
                if (objectIconMap.containsKey(a)){
                    str = objectIconMap.get(a);
                } else{
                    if (n == 0){
                        str = 'custom:custom3';
                        n++;
                    } else if (n == 1){
                        str = 'custom:custom10';
                        n++;
                    } else{
                        str = 'custom:custom11';
                        n++;
                    }
                }
                result = result + ',' + str;
            }
            return result;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description getFieldsRecords Method
     * @param id Id Value
     * @return List of Form_Fields__c
     */
    @AuraEnabled
    public static List<Form_Fields__c> getFieldsRecords(Id id){
        /*This method is used to pass fields records in js*/
        try{
            Form__c FormDetail = [SELECT Id, Mapped_Objects__c
                                  FROM Form__c
                                  WHERE Id = :id
                                  WITH SECURITY_ENFORCED
                                  LIMIT 1];
            List<String> types = (FormDetail.Mapped_Objects__c).split(',');
            Decimal Position = 0;
            List<Form_Page__c> AllFormPages = [SELECT ID
                                               From Form_Page__c
                                               where Form__c = :FormDetail.Id
                                               WITH SECURITY_ENFORCED
                                               ORDER BY Page_Number__c];
            boolean hasRequiredField = false;
            List<Form_Fields__c> fieldContainsRequireCheck = [SELECT Name
                                                              From Form_Fields__c
                                                              where Form_Page__c = :AllFormPages.get(0).Id
                                                              WITH SECURITY_ENFORCED];
            List<Form_Fields__c> allFieldsOfForm = [SELECT Id, Name, Form__c, Form_Page__c
                                                    FROM Form_Fields__c
                                                    WHERE Form__c = :FormDetail.Id
                                                    WITH SECURITY_ENFORCED];

            for (Form_Fields__c it : fieldContainsRequireCheck){
                List<String> temp = it.Name.split(',');
                if (temp.size() == 3){
                    if (temp.get(2) == 'isrequired'){
                        hasRequiredField = true;
                    }
                }
            }

            if (hasRequiredField == false){
                if (allFieldsOfForm.size() == 0){
                    Integer iteration = 0;
                    List<Form_Fields__c> fields = new List<Form_Fields__c>();
                    for (String type : types){
                        Position = 0;
                        Form_Page__c page_Id = AllFormPages.get(iteration);
                        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                        Schema.SObjectType leadSchema = schemaMap.get(type) ;
                        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                        for (String fieldName : fieldMap.keySet()){
                            if (fieldName != 'OwnerId' && (fieldMap.get(fieldName).getDescribe().getType() != Schema.DisplayType.BOOLEAN) && (!fieldMap.get(fieldName).getDescribe().isNillable() && fieldMap.get(fieldName).getDescribe().isCreateable())){
                                Position = Position + 1;
                                Form_Fields__c field = new Form_Fields__c();
                                field.Mapped_Obj__c = type;
                                String Label = '';
                                field.Field_Mapping__c = fieldMap.get(fieldName) + '<!@!>' + type;
                                if (fieldName == 'LastName'){
                                    field.Name = 'NAME' + ',' + 'QFFULLNAME' + ',isrequired';
                                    field.Field_Label__c = 'Name';
                                    Label = field.Field_Label__c;
                                } else{
                                    field.Name = fieldMap.get(fieldName).getDescribe().getLabel() + ',' + fieldMap.get(fieldName).getDescribe().getType() + ',isrequired';
                                    field.Field_Label__c = fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase();
                                    Label = field.Field_Label__c;
                                }
                                field.Form__c = FormDetail.Id;
                                field.Form_Page__c = page_Id.Id;
                                field.Field_Order__c = Position + 1;
                                if (!(type == 'Attachment' && fieldName == 'ParentId')){

                                    if (String.valueof(fieldMap.get(fieldName).getDescribe().getType()) == 'CURRENCY' || String.valueof(fieldMap.get(fieldName).getDescribe().getType()) == 'PERCENT' || String.valueof(fieldMap.get(fieldName).getDescribe().getType()) == 'DOUBLE'){
                                        field.Field_Validations__c = 'isRequired<!@!>true' + 
                                         '?$`~isDisabled<!@!>false' + 
                                         '?$`~isLabel<!@!>true' + 
                                         '?$`~isHelpText<!@!>false' + 
                                         '?$`~Label<!@!>' + Label + 
                                         '?$`~HelpText<!@!>' + 
                                         '?$`~isPlaceholder<!@!>false' + 
                                         '?$`~Placeholder<!@!>' + 
                                         '?$`~Minimum<!@!>0' + 
                                         '?$`~Maximum<!@!>' + fieldMap.get(fieldName).getDescribe().getPrecision() + 
                                         '?$`~isPrefix<!@!>false' + 
                                         '?$`~Prefix<!@!>' + 
                                         '?$`~Decimal<!@!>' + 
                                         '?$`~Richtext<!@!>' + 
                                         '?$`~MinimumTime<!@!>' + 
                                         '?$`~MaximumTime<!@!>' + 
                                         '?$`~MinimumDateTime<!@!>' + 
                                         '?$`~MaximumDateTime<!@!>' + 
                                         '?$`~MinimumDate<!@!>' + 
                                         '?$`~MaximumDate<!@!>' + 
                                         '?$`~Salutation<!@!>';
                                    } else{
                                        if (fieldMap.get(fieldName).getDescribe().getLength() > 0){
                                            if (fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase() == 'LAST NAME'){
                                                field.Field_Validations__c = 'isRequired<!@!>true' + 
                                                '?$`~isDisabled<!@!>false' + 
                                                '?$`~isLabel<!@!>true' + 
                                                '?$`~isHelpText<!@!>false' + 
                                                '?$`~Label<!@!>' + 'Name' + 
                                                '?$`~HelpText<!@!>' + 
                                                '?$`~isPlaceholder<!@!>false' + 
                                                '?$`~Placeholder<!@!>' + 
                                                '?$`~Minimum<!@!>0' + 
                                                '?$`~Maximum<!@!>' + fieldMap.get(fieldName).getDescribe().getLength() + 
                                                '?$`~isPrefix<!@!>false' + 
                                                '?$`~Prefix<!@!>' + 
                                                '?$`~Decimal<!@!>' + 
                                                '?$`~Richtext<!@!>' + 
                                                '?$`~MinimumTime<!@!>' + 
                                                '?$`~MaximumTime<!@!>' + 
                                                '?$`~MinimumDateTime<!@!>' + 
                                                '?$`~MaximumDateTime<!@!>' + 
                                                '?$`~MinimumDate<!@!>' + 
                                                '?$`~MaximumDate<!@!>';
                                                for (String fieldNames : fieldMap.keySet()){
                                                    if (fieldNames == 'salutation'){
                                                        Schema.DescribeFieldResult fieldDesc = (fieldMap.get(fieldNames).getDescribe());
                                                        for (Integer i = 0; i < fieldDesc.getPicklistValues().size(); i++){
                                                            field.Field_Validations__c = field.Field_Validations__c + '?$`~Salutation<!@!>' + fieldDesc.getPicklistValues()[i].getLabel();
                                                        }
                                                    }
                                                }
                                            } else{
                                                field.Field_Validations__c = 'isRequired<!@!>true' + 
                                                '?$`~isDisabled<!@!>false' + 
                                                '?$`~isLabel<!@!>true' + 
                                                '?$`~isHelpText<!@!>false' + 
                                                '?$`~Label<!@!>' + fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase() + 
                                                '?$`~HelpText<!@!>' + 
                                                '?$`~isPlaceholder<!@!>false' + 
                                                '?$`~Placeholder<!@!>' + 
                                                '?$`~Minimum<!@!>0' + 
                                                '?$`~Maximum<!@!>' + fieldMap.get(fieldName).getDescribe().getLength() + 
                                                '?$`~isPrefix<!@!>false' + 
                                                '?$`~Prefix<!@!>' + 
                                                '?$`~Decimal<!@!>' + 
                                                '?$`~Richtext<!@!>' + 
                                                '?$`~MinimumTime<!@!>' + 
                                                '?$`~MaximumTime<!@!>' + 
                                                '?$`~MinimumDateTime<!@!>' + 
                                                '?$`~MaximumDateTime<!@!>' + 
                                                '?$`~MinimumDate<!@!>' + 
                                                '?$`~MaximumDate<!@!>' + 
                                                '?$`~Salutation<!@!>';
                                            }
                                        } else{
                                            field.Field_Validations__c = 'isRequired<!@!>true' + 
                                            '?$`~isDisabled<!@!>false' + 
                                            '?$`~isLabel<!@!>true' + 
                                            '?$`~isHelpText<!@!>false' + 
                                            '?$`~Label<!@!>' + fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase() + 
                                            '?$`~HelpText<!@!>' + 
                                            '?$`~isPlaceholder<!@!>false' + 
                                            '?$`~Placeholder<!@!>' + 
                                            '?$`~Minimum<!@!>0' + 
                                            '?$`~Maximum<!@!>128' + 
                                            '?$`~isPrefix<!@!>false' + 
                                            '?$`~Prefix<!@!>' + 
                                            '?$`~Decimal<!@!>' + 
                                            '?$`~Richtext<!@!>' + 
                                            '?$`~MinimumTime<!@!>' + 
                                            '?$`~MaximumTime<!@!>' + 
                                            '?$`~MinimumDateTime<!@!>' + 
                                            '?$`~MaximumDateTime<!@!>' + 
                                            '?$`~MinimumDate<!@!>' + 
                                            '?$`~MaximumDate<!@!>' + 
                                            '?$`~Salutation<!@!>';
                                        }
                                    }
                                    fields.add(field);
                                }
                            } else if (fieldName == 'AccountId'){
                                if (type == 'Asset' || type == 'Order'){
                                    Position = Position + 1;
                                    Form_Fields__c field = new Form_Fields__c();
                                    field.Mapped_Obj__c = type;
                                    String Label = '';
                                    field.Field_Mapping__c = fieldMap.get(fieldName) + '<!@!>' + type;
                                    field.Name = 'Account ID' + ',' + 'REFERENCE' + ',isrequired';
                                    field.Field_Label__c = 'Name';
                                    Label = field.Field_Label__c;
                                    field.Form__c = FormDetail.Id;
                                    field.Form_Page__c = page_Id.Id;
                                    field.Field_Order__c = Position + 1;
                                    field.Field_Validations__c = 'isRequired<!@!>true' + 
                                                             '?$`~isDisabled<!@!>false' + 
                                                             '?$`~isLabel<!@!>true' + 
                                                             '?$`~isHelpText<!@!>false' + 
                                                             '?$`~Label<!@!>' + fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase() + 
                                                             '?$`~HelpText<!@!>' + 
                                                             '?$`~isPlaceholder<!@!>false' + 
                                                             '?$`~Placeholder<!@!>' + 
                                                             '?$`~Minimum<!@!>0' + 
                                                             '?$`~Maximum<!@!>128' + 
                                                             '?$`~isPrefix<!@!>false' + 
                                                             '?$`~Prefix<!@!>' + 
                                                             '?$`~Decimal<!@!>' + 
                                                             '?$`~Richtext<!@!>' + 
                                                             '?$`~MinimumTime<!@!>' + 
                                                             '?$`~MaximumTime<!@!>' + 
                                                             '?$`~MinimumDateTime<!@!>' + 
                                                             '?$`~MaximumDateTime<!@!>' + 
                                                             '?$`~MinimumDate<!@!>' + 
                                                             '?$`~MaximumDate<!@!>' + 
                                                             '?$`~Salutation<!@!>';
                                    fields.add(field);
                                }
                            } else if (fieldName == 'StartDateTime' || fieldName == 'EndDateTime'){
                                if (type == 'Event'){
                                    String leb;
                                    if (fieldName == 'StartDateTime'){
                                        leb = 'Start Date Time';
                                    } else{
                                        leb = 'End Date Time';
                                    }
                                    Position = Position + 1;
                                    Form_Fields__c field = new Form_Fields__c();
                                    field.Mapped_Obj__c = type;
                                    String Label = '';
                                    field.Field_Mapping__c = fieldMap.get(fieldName) + '<!@!>' + type;
                                    field.Name = leb + ',' + 'DATETIME' + ',isrequired';
                                    field.Field_Label__c = leb;
                                    Label = field.Field_Label__c;
                                    field.Form__c = FormDetail.Id;
                                    field.Form_Page__c = page_Id.Id;
                                    field.Field_Order__c = Position + 1;
                                    field.Field_Validations__c = 'isRequired<!@!>true' + 
                                                             '?$`~isDisabled<!@!>false' + 
                                                             '?$`~isLabel<!@!>true' + 
                                                             '?$`~isHelpText<!@!>false' + 
                                                             '?$`~Label<!@!>' + fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase() + 
                                                             '?$`~HelpText<!@!>' + 
                                                             '?$`~isPlaceholder<!@!>false' + 
                                                             '?$`~Placeholder<!@!>' + 
                                                             '?$`~Minimum<!@!>0' + 
                                                             '?$`~Maximum<!@!>128' + 
                                                             '?$`~isPrefix<!@!>false' + 
                                                             '?$`~Prefix<!@!>' + 
                                                             '?$`~Decimal<!@!>' + 
                                                             '?$`~Richtext<!@!>' + 
                                                             '?$`~MinimumTime<!@!>' + 
                                                             '?$`~MaximumTime<!@!>' + 
                                                             '?$`~MinimumDateTime<!@!>' + 
                                                             '?$`~MaximumDateTime<!@!>' + 
                                                             '?$`~MinimumDate<!@!>' + 
                                                             '?$`~MaximumDate<!@!>' + 
                                                             '?$`~Salutation<!@!>';
                                    fields.add(field);
                                }
                            }
                        }
                        iteration = iteration + 1;
                    }
                    if (Schema.sObjectType.Form_Fields__c.fields.Field_Label__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Mapped_Obj__c.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Name.isCreateable() && Schema.sObjectType.Form_Fields__c.fields.Form__c.IsCreateable()){
                        insert fields;
                    }
                }
            }
            List<Form_Fields__c> fieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c, Mapped_Obj__c
                                              FROM Form_Fields__c
                                              WHERE Form__c = :id
                                              WITH SECURITY_ENFORCED
                                              ORDER BY Field_Order__c ASC];
            return fieldList;

        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description reOrderField Method - Used for Reordering fields in form builder
     * @param dropFieldId String Value
     * @param currentFieldId String Value
     * @param dropPageId String Value
     * @return List of Form_Fields__c
     */
    @AuraEnabled
    public static List<Form_Fields__c> reOrderField(String dropFieldId, String currentFieldId, String dropPageId){
        /*This method is used to updeat fields records*/
        List<Form_Fields__c> fieldList = new List<Form_Fields__c>();
        List<Form_Fields__c> fieldListToUpdate = new List<Form_Fields__c>();

        Form_Fields__c cuurentField = new Form_Fields__c();
        Form_Fields__c dropField = new Form_Fields__c();
        try{
            if (String.isNotBlank(dropFieldId) && String.isNotBlank(currentFieldId)){
                cuurentField = [SELECT Id, Name, Form_Page__c, Field_Order__c, Form__c, Field_Mapping__c
                                FROM Form_Fields__c
                                WHERE Id = :currentFieldId
                                WITH SECURITY_ENFORCED];
                dropField = [SELECT Id, Name, Form_Page__c, Field_Order__c, Form__c, Field_Mapping__c
                             FROM Form_Fields__c
                             WHERE Id = :dropFieldId
                             WITH SECURITY_ENFORCED];
                fieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Mapping__c
                             FROM Form_Fields__c
                             WHERE Form__c = :cuurentField.Form__c
                             WITH SECURITY_ENFORCED
                             ORDER BY Field_Order__c ASC];

                if (cuurentField.Field_Order__c < dropField.Field_Order__c){
                    for (Form_Fields__c ff : fieldList){
                        if (ff.Field_Order__c > cuurentField.Field_Order__c && ff.Field_Order__c < dropField.Field_Order__c){
                            ff.Field_Order__c = ff.Field_Order__c - 1;
                            fieldListToUpdate.add(ff);
                        }
                    }
                    cuurentField.Field_Order__c = dropField.Field_Order__c - 1;
                    cuurentField.Form_Page__c = dropField.Form_Page__c;
                    fieldListToUpdate.add(cuurentField);
                } else if (cuurentField.Field_Order__c > dropField.Field_Order__c){
                    for (Form_Fields__c ff : fieldList){
                        if (ff.Field_Order__c >= dropField.Field_Order__c && ff.Field_Order__c < cuurentField.Field_Order__c){
                            ff.Field_Order__c = ff.Field_Order__c + 1;
                            fieldListToUpdate.add(ff);
                        }
                    }
                    cuurentField.Field_Order__c = dropField.Field_Order__c;
                    cuurentField.Form_Page__c = dropField.Form_Page__c;
                    fieldListToUpdate.add(cuurentField);
                }

                if (fieldListToUpdate.size() > 0 && Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Mapped_Obj__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Name.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.IsUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Name.IsUpdateable()){
                    update fieldListToUpdate;
                }

            } else if (String.isNotBlank(currentFieldId)){
                cuurentField = [SELECT Id, Name, Form_Page__c, Field_Order__c, Form__c
                                FROM Form_Fields__c
                                WHERE Id = :currentFieldId
                                WITH SECURITY_ENFORCED];
                cuurentField.Field_Order__c = 2;
                cuurentField.Form_Page__c = dropPageId;

                if (Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Mapped_Obj__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Name.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.IsUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsUpdateable() && Schema.sObjectType.Form_Fields__c.fields.Name.IsUpdateable()){
                    update cuurentField;
                }

            }
            List<Form_Fields__c> latestFieldList = new List<Form_Fields__c>();
            latestFieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c, Mapped_Obj__c
                               FROM Form_Fields__c
                               WHERE Form__c = :cuurentField.Form__c
                               WITH SECURITY_ENFORCED
                               ORDER BY Field_Order__c ASC];
            return latestFieldList;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description createPage Method
     * @param pageNumber Integer Value
     * @param totalPages Integer Value
     * @param formId Id Value
     * @param pagename String Value
     * @return pageWrapper
     */
    @AuraEnabled
    public static pageWrapper createPage(Integer pageNumber, Integer totalPages, Id formId, String pagename){
        /*This method is used store new page records*/
        try{
            if (Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Name.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Form__c.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Name.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Page_Number__c.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Page_Number__c.IsUpdateable() && Schema.sObjectType.Form_Page__c.fields.Page_Number__c.isCreateable() && Schema.sObjectType.Form_Page__c.fields.Form__c.isCreateable() && Schema.sObjectType.Form_Page__c.fields.Name.isCreateable()){

                Form_Page__c newFormPage = new Form_Page__c();
                newFormPage.Form__c = formId;
                newFormPage.Name = pagename;
                if (pageNumber != null && pageNumber <= totalPages){
                    List<Form_Page__c> existingPages = [SELECT Id, Page_Number__c
                                                        FROM Form_Page__c
                                                        WHERE Form__c = :formId AND Page_Number__c >= :pageNumber
                                                        WITH SECURITY_ENFORCED
                                                        ORDER BY Page_Number__c DESC];
                    for (Form_Page__c page : existingPages){
                        page.Page_Number__c += 1;
                    }
                    update existingPages;
                    newFormPage.Page_Number__c = pageNumber;
                } else{
                    newFormPage.Page_Number__c = totalPages + 1;
                }
                insert newFormPage;

                List<Form_Fields__c> formFields = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                                                   FROM Form_Fields__c
                                                   WITH SECURITY_ENFORCED
                                                   ORDER BY Field_Order__c ASC];
                pageWrapper pw = new pageWrapper();
                pw.fieldList = formFields;
                pw.pageList = [SELECT Id, Name, Page_Number__c
                               FROM Form_Page__c
                               WHERE Form__c = :formId
                               WITH SECURITY_ENFORCED
                               ORDER BY Page_Number__c ASC];
                return pw;

            } else{
                return null;
            }
        } catch (Exception e){
            System.debug('Exception--->' + e.getMessage() + ' -->>' + e.getLineNumber());
            return null;
        }
    }

    /**
     * @description updatePage Method
     * @param formId Id Value
     * @param pageId Id Value
     * @param pageTitle String Value
     * @param pageNumber Integer Value
     * @return pageWrapper
     */
    @AuraEnabled
    public static pageWrapper updatePage(Id formId, Id pageId, String pageTitle, Integer pageNumber){
        /*This method is used store update Page records*/
        try{

            if (Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Name.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Form__c.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Name.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Page_Number__c.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Page_Number__c.IsUpdateable() && Schema.sObjectType.Form_Page__c.fields.Name.IsUpdateable()){
                Form_Page__c formPage = new Form_Page__c(Id = pageId, Name = pageTitle, Page_Number__c = pageNumber);
                update formPage;

                // Get the page that was updated
                Form_Page__c updatedPage = [SELECT Id, Name, Page_Number__c
                                            FROM Form_Page__c
                                            WHERE Id = :pageId
                                            WITH SECURITY_ENFORCED];

                // Get the pages with a number less than or equal to the updated page number
                List<Form_Page__c> pagesBefore = [SELECT Id, Name, Page_Number__c
                                                  FROM Form_Page__c
                                                  WHERE Form__c = :formId AND Page_Number__c <= :pageNumber AND Id != :pageId
                                                  WITH SECURITY_ENFORCED
                                                  ORDER BY Page_Number__c ASC];

                // Get the pages with a number greater than the updated page number
                List<Form_Page__c> pagesAfter = [SELECT Id, Name, Page_Number__c
                                                 FROM Form_Page__c
                                                 WHERE Form__c = :formId AND Page_Number__c > :pageNumber
                                                 WITH SECURITY_ENFORCED
                                                 ORDER BY Page_Number__c ASC];

                // Update the page numbers for the pages before the updated page
                Integer newPageNumber = 1;
                for (Form_Page__c page : pagesBefore){
                    page.Page_Number__c = newPageNumber;
                    newPageNumber++;
                }

                // Set the updated page number to the updated page
                updatedPage.Page_Number__c = newPageNumber;
                newPageNumber++;

                // Update the page numbers for the pages after the updated page
                for (Form_Page__c page : pagesAfter){
                    page.Page_Number__c = newPageNumber;
                    newPageNumber++;
                }

                // Update the pages in the database
                List<Form_Page__c> pagesToUpdate = new List<Form_Page__c>();
                pagesToUpdate.addAll(pagesBefore);
                pagesToUpdate.add(updatedPage);
                pagesToUpdate.addAll(pagesAfter);
                update pagesToUpdate;
                List<Form_Fields__c> formFields = [SELECT Id, Name, Form__c, Form_Page__c, Field_Validations__c, Field_Order__c, Field_Mapping__c
                                                   FROM Form_Fields__c
                                                   WITH SECURITY_ENFORCED
                                                   ORDER BY Field_Order__c ASC];
                pageWrapper pw = new pageWrapper();
                pw.fieldList = formFields;
                pw.pageList = [SELECT Id, Name, Page_Number__c
                               FROM Form_Page__c
                               WHERE Form__c = :formId
                               WITH SECURITY_ENFORCED
                               ORDER BY Page_Number__c ASC];
                return pw;
            } else{
                return null;
            }
        } catch (Exception e){
            System.debug('Exception--->' + e.getMessage() + ' -->>' + e.getLineNumber());
            return null;
        }
    }

    /**
     * @description renameform Method
     * @param id Id Value
     * @param rename String Value
     * @param FormId Id Value
     * @return pageWrapper
     */
    @AuraEnabled
    public static pageWrapper renameform(Id id, String rename, Id FormId){
        try{
            Form_Page__c form = [SELECT Name
                                 FROM Form_Page__c
                                 WHERE Id = :id
                                 WITH SECURITY_ENFORCED];
            form.Name = rename;

            if (Schema.sObjectType.Form_Fields__c.fields.Name.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Name.IsUpdateable()){
                update form;
            }
            List<Form_Fields__c> formFields = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                                               FROM Form_Fields__c
                                               WITH SECURITY_ENFORCED
                                               ORDER BY Field_Order__c ASC];
            pageWrapper pw = new pageWrapper();
            pw.fieldList = formFields;
            pw.pageList = [SELECT Id, Name, Page_Number__c
                           FROM Form_Page__c
                           WHERE Form__c = :FormId
                           WITH SECURITY_ENFORCED
                           ORDER BY Page_Number__c ASC];
            return pw;
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description renameMainform Method
     * @param rename String Value
     * @param FormId Id Value
     * @return String
     */
    @AuraEnabled
    public static String renameMainform(String rename, Id FormId){
        try{
            if (Schema.sObjectType.Form__c.fields.Name.IsAccessible() && Schema.sObjectType.Form__c.fields.Name.IsUpdateable()){
                Form__c renameform = [SELECT Name
                                      from Form__c
                                      WHERE Id = :FormId];
                renameform.Name = rename;
                update renameform;
                return rename;
            } else{
                return null;
            }

        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description deletePage Method
     * @param FormId Id Value
     * @param PageId Id Value
     * @return pageWrapper
     */
    @AuraEnabled
    public static pageWrapper deletePage(Id FormId, Id PageId){
        try{
            if (Schema.sObjectType.Form_Fields__c.fields.Name.IsAccessible()  && Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Order__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Form__c.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Name.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Page_Number__c.IsAccessible() && Schema.sObjectType.Form_Page__c.fields.Page_Number__c.IsUpdateable() && Form_Page__c.SObjectType.getDescribe().isDeletable()){
                Form_Page__c deletePage = [SELECT Id, Page_Number__c
                                           from Form_Page__c
                                           where Id = :PageId];
                boolean hasRequiredField = false;
                List<Form_Fields__c> fieldContainsRequireCheck = [SELECT Name
                                                                  From Form_Fields__c
                                                                  where Form_Page__c = :PageId];
                for (Form_Fields__c it : fieldContainsRequireCheck){
                    List<String> temp = it.Name.split(',');
                    if (temp.size() == 3){
                        if (temp.get(2) == 'isrequired'){
                            hasRequiredField = true;
                        }
                    }
                }
                if (!hasRequiredField){
                    delete deletePage;
                    List<Form_Page__c> pagesToUpdate = [SELECT Id, Page_Number__c
                                                        FROM Form_Page__c
                                                        WHERE Form__c = :FormId AND Page_Number__c > :deletePage.Page_Number__c WITH SECURITY_ENFORCED];
                    for (Form_Page__c p : pagesToUpdate){
                        p.Page_Number__c -= 1;
                    }
                    if (Schema.sObjectType.Form_Page__c.fields.Page_Number__c.isAccessible() && Schema.sObjectType.Form_Page__c.fields.Page_Number__c.IsUpdateable() && Schema.sObjectType.Form_Page__c.fields.Form__c.IsAccessible()){
                        update pagesToUpdate;
                    }
                }
                List<Form_Fields__c> formFields = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                                                   FROM Form_Fields__c
                                                   ORDER BY Field_Order__c ASC];
                pageWrapper pw = new pageWrapper();
                pw.fieldList = formFields;
                pw.pageList = [SELECT Id, Name, Page_Number__c
                               FROM Form_Page__c
                               WHERE Form__c = :FormId
                               ORDER BY Page_Number__c ASC];
                return pw;
            } else{
                return null;
            }

        } catch (Exception e){
            System.debug('Exception--->' + e.getMessage() + ' -->>' + e.getLineNumber());
            return null;
        }
    }

    /**
     * @description pageDetails Method
     * @param FormId Id Value
     * @param PageId Id Value
     * @return Form_Page__c
     */
    @AuraEnabled
    public static Form_Page__c pageDetails(Id FormId, Id PageId){
        try{
            return [SELECT Id, Name, Page_Number__c
                    from Form_Page__c
                    where Id = :PageId
                    WITH SECURITY_ENFORCED];
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description editFormSubmit Method
     * @param id Id Value
     * @param name String Value
     * @param progressIn String Value
     * @param captcha String Value
     * @return String
     */
    @AuraEnabled
    public static String editFormSubmit(String id, String name, String progressIn, String captcha){
        /*This method is used update form submit*/
        try{
            if (Schema.sObjectType.Form__c.fields.Captcha_Type__c.IsAccessible() && Schema.sObjectType.Form__c.fields.Name.IsAccessible() && Schema.sObjectType.Form__c.fields.Progress_Indicator__c.IsAccessible() && Schema.sObjectType.Form__c.fields.Captcha_Type__c.IsUpdateable() && Schema.sObjectType.Form__c.fields.Name.IsUpdateable() && Schema.sObjectType.Form__c.fields.Progress_Indicator__c.IsUpdateable()){

                Form__c editForm = [SELECT Id, Captcha_Type__c, Progress_Indicator__c, Name
                                    FROM Form__c
                                    where Id = :id
                                    WITH SECURITY_ENFORCED];
                if (captcha == 'None'){
                    editForm.Captcha_Type__c = '';
                } else{
                    editForm.Captcha_Type__c = captcha;
                }

                if (progressIn == 'None'){
                    editForm.Progress_Indicator__c = progressIn;
                } else{
                    editForm.Progress_Indicator__c = progressIn;
                }
                editForm.Name = name;
                update editForm;
                return 'saved successfully';
            } else{
                return null;
            }
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'editFormSubmit');
            return null;
        }
    }

    /**
     * @description signatureSave Method
     * @param fieldId String Value
     * @param fieldData String Value
     * @return String
     */
    @AuraEnabled
    public static String signatureSave(String fieldId, String fieldData){
        /*This method is used store signature in ContentVersion*/
        try{

            Integer randomNumber = (Integer)Math.floor(Math.random() * 900000) + 100000;
            String s = fieldData.replaceFirst('data:image/png;base64,', '');
            ContentVersion conVer = new ContentVersion();
            conVer.title = 'Signature'+randomNumber+'.png';
            conVer.versionData = EncodingUtil.base64decode(s);
            conVer.PathOnClient = 'signatureImage.png';
            if (Schema.sObjectType.ContentVersion.fields.title.IsCreateable() && Schema.sObjectType.ContentVersion.fields.PathOnClient.IsCreateable()){
                insert conVer;
            }
            return conVer.Id;

        } catch (Exception e){
            System.debug('signature error' + String.valueOf(e));
            return null;
        }
    }

    /**
     * @description SaveFile Method
     * @param fieldId String Value
     * @param fileName String Value
     * @param base64Data String Value
     * @param contentType String Value
     * @return String
     */
    @AuraEnabled
    public static String SaveFile(String fieldId, String fileName, String base64Data, String contentType){
        /*This method is used store upload files in ContentVersion*/
        try{
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            ContentVersion cv = new ContentVersion();
            cv.Title = fileName;
            cv.PathOnClient = fileName;
            cv.VersionData = EncodingUtil.base64Decode(base64Data);
            cv.IsMajorVersion = true;
            if (Schema.sObjectType.ContentVersion.fields.Title.IsCreateable() && Schema.sObjectType.ContentVersion.fields.PathOnClient.IsCreateable() && Schema.sObjectType.ContentVersion.fields.IsMajorVersion.IsCreateable()){
                insert cv;
            }
            return cv.Id;

        } catch (Exception e){
            return null;
        }
    }

    /** @description referencewrapper class */
    public class referencewrapper{
        /** @description referenceval - List of SObject */
        @AuraEnabled
        public list<SObject> referenceval{ get; set; }

        /** @description objicon - String */
        @AuraEnabled
        public String objicon{ get; set; }

    }

    /**
     * @description getFieldsRecords_page Method
     * @param id Id Value
     * @return List of Form_Fields__c
     */
    @AuraEnabled
    public static List<Form_Fields__c> getFieldsRecords_page(Id id){
        /*This method is used get filds record page*/
        try{
            if (Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Validations__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Form_Page__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Name.IsAccessible()){
                List<Form_Fields__c> pageFildList = [SELECT Name, Field_Mapping__c, Field_Validations__c
                                                     From Form_Fields__c
                                                     where Form_Page__c = :ID];
                return pageFildList;
            } else{
                return null;
            }
        } catch (Exception e){
            return null;
        }
    }

    /**
     * @description GetFormObject Method
     * @param id String Value
     * @return List of Form__c
     */
    @AuraEnabled
    public static List<Form__c> GetFormObject(String id){
        /*This method is used get name of objects in form*/
        try{
            List<Form__c> form_obj = [SELECT Mapped_Objects__c
                                      From Form__c
                                      where ID = :Id
                                      WITH SECURITY_ENFORCED];

            return form_obj;

        } catch (Exception e){
            return null;
        }
    }

    public static List<Id> insertRecordList = new List<Id>(); // use to just revert the DML
    /**
     * @description createrecord Method
     * @param acc Form_Submission__c record
     * @param first_obj_list SObject record
     * @param sig_upload_jsone String Value
     * @param sig_upload_fid_list List of String
     * @param file_upload_jsone String Value
     * @param file_upload_fid_list List of String
     * @return SubId record
     */
    @AuraEnabled
    public static SubId createrecord(Form_Submission__c acc, SObject first_obj_list, String sig_upload_jsone, List<String> sig_upload_fid_list, String file_upload_jsone, List<String> file_upload_fid_list){
        try{
            /*This method is used create form submission*/

            String signatureid;
            String fildid;
            Map<String, Object> file_upload_map = new Map<String, Object>();
            Map<String, Object> sigUploadMap = new Map<String, Object>();
            Map<String, Object> sigMap = (Map<String, Object>)JSON.deserializeUntyped(sig_upload_jsone);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(file_upload_jsone);
            Map<String, Object> otherobjectdata = (Map<String, Object>) JSON.deserializeUntyped(acc.Other_fields_data__c);
            String subID = '';
            Integer sig_list_len = sig_upload_fid_list.size();
            if (sig_list_len > 0){
                for (String sigType : sig_upload_fid_list){
                    String sigBaseid = (String) sigMap.get(sigType);
                    signatureid = signatureSave(subID, sigBaseid);
                    sigUploadMap.put(sigType, signatureid);
                    otherobjectdata.put(sigType, signatureid);
                }
            }

            Integer listLen = file_upload_fid_list.size();
            if (listLen > 0){
                for (String type : file_upload_fid_list){
                    String[] address = type.split('<!QF!>');
                    String fName = address[1];
                    String fType = address[2];
                    String baseid = (String) m.get(type) ;
                    fildid = SaveFile(subID, fName, baseid, fType);
                    file_upload_map.put(address[0], fildid);
                    otherobjectdata.put(address[0], fildid);
                }
            }

            Form_Submission__c formsub = new Form_Submission__c();

            formsub.Form__c = acc.Form__c;
            formsub.First_object_data__c = acc.First_object_data__c;
            formsub.Second_object_data__c = acc.Second_object_data__c;
            formsub.Third_object_data__c = acc.Third_object_data__c;
            formsub.Other_fields_data__c = JSON.serialize(otherobjectdata);

            if (Schema.sObjectType.Form_Submission__c.fields.First_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Other_fields_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Form__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Second_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Third_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.First_object_data__c.isAccessible() && Schema.sObjectType.Form_Submission__c.fields.Other_fields_data__c.isAccessible() && Schema.sObjectType.Form_Submission__c.fields.Form__c.isAccessible() && Schema.sObjectType.Form_Submission__c.fields.Second_object_data__c.isAccessible() && Schema.sObjectType.Form_Submission__c.fields.Third_object_data__c.isAccessible()){
                insert formsub;
                insertRecordList.add(formsub.Id);
                subID = formsub.Id;
            }

            // To pass data to the email service
            wrapformsubmission wrapper = new wrapformsubmission();
            wrapper.acc = acc;
            wrapper.sig_upload_jsone = sig_upload_jsone;
            wrapper.sig_upload_fid_list = sig_upload_fid_list;
            wrapper.file_upload_jsone = file_upload_jsone;
            wrapper.file_upload_fid_list = file_upload_fid_list;
            wrapper.ObjectCount = 1;
            wrapper.SubId = subID;
        
            sendemailforformsubmission(wrapper);

            SubId ids = new SubId();
            ids.SubmissionId = formsub.Id;
            ids.SignatureId = signatureid;
            ids.Sig_upload_map = sigUploadMap;
            ids.File_upload_map = file_upload_map;
            return ids;
            
        } catch (Exception e){
            List<sobject> sobjlst = new List<sobject>();
            return null;
        }
    }

    /**
     * @description createrecord_for_secod_object Method
     * @param acc Form_Submission__c record
     * @param first_obj_list SObject record
     * @param list_second_obj SObject record
     * @param sig_upload_jsone String Value
     * @param sig_upload_fid_list List of String
     * @param file_upload_jsone String Value
     * @param file_upload_fid_list List of String
     * @param create_chi Boolean Value
     * @param lookup_list List of String
     * @param base64att base64 String
     * @return SubId record
     */
    @AuraEnabled
    public static SubId createrecord_for_secod_object(Form_Submission__c acc, SObject first_obj_list, SObject list_second_obj, String sig_upload_jsone, List<String> sig_upload_fid_list, String file_upload_jsone, List<String> file_upload_fid_list, Boolean create_chi, List<String> lookup_list, String base64att){
        try{
            /*This method is used create form submission*/
            String signatureid;
            String fildid;
            Map<String, Object> file_upload_map = new Map<String, Object>();
            Map<String, Object> sigUploadMap = new Map<String, Object>();
            Map<String, Object> sigMap = (Map<String, Object>)JSON.deserializeUntyped(sig_upload_jsone);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(file_upload_jsone);

            Map<String, Object> firstobjectdata = first_obj_list.getPopulatedFieldsAsMap();
            Map<String, Object> secondobjectdata = list_second_obj.getPopulatedFieldsAsMap();


            Map<String, Object> otherobjectdata = (Map<String, Object>) JSON.deserializeUntyped(acc.Other_fields_data__c);
            String subID = '';
            Integer sig_list_len = sig_upload_fid_list.size();
            if (sig_list_len > 0){
                for (String sigType : sig_upload_fid_list){
                    String sigBaseid = (String) sigMap.get(sigType);
                    signatureid = signatureSave(subID, sigBaseid);
                    sigUploadMap.put(sigType, signatureid);
                    otherobjectdata.put(sigType, signatureid);
                }
            }

             Integer listLen = file_upload_fid_list.size();
            if (listLen > 0){
                for (String type : file_upload_fid_list){
                    String[] address = type.split('<!QF!>');
                    String fName = address[1];
                    String fType = address[2];
                    String baseid = (String) m.get(type) ;
                    fildid = SaveFile(subID, fName, baseid, fType);
                    file_upload_map.put(address[0], fildid);
                    otherobjectdata.put(address[0], fildid);
                }
            }

            Form_Submission__c formsub = new Form_Submission__c();
            formsub.Form__c = acc.Form__c;
            formsub.First_object_data__c = acc.First_object_data__c;
            formsub.Second_object_data__c = acc.Second_object_data__c;
            formsub.Third_object_data__c = acc.Third_object_data__c;
            formsub.Other_fields_data__c = JSON.serialize(otherobjectdata);

            if (Schema.sObjectType.Form_Submission__c.fields.First_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Other_fields_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Form__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Second_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Third_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.First_object_data__c.isAccessible() && Schema.sObjectType.Form_Submission__c.fields.Other_fields_data__c.isAccessible() && Schema.sObjectType.Form_Submission__c.fields.Form__c.isAccessible() && Schema.sObjectType.Form_Submission__c.fields.Second_object_data__c.isAccessible() && Schema.sObjectType.Form_Submission__c.fields.Third_object_data__c.isAccessible()){
                insert formsub;
                insertRecordList.add(formsub.Id);
                subID = formsub.Id;
            }

            // To pass data to the email service
            wrapformsubmission wrapper = new wrapformsubmission();
            wrapper.acc = acc;
            wrapper.sig_upload_jsone = sig_upload_jsone;
            wrapper.sig_upload_fid_list = sig_upload_fid_list;
            wrapper.file_upload_jsone = file_upload_jsone;
            wrapper.file_upload_fid_list = file_upload_fid_list;
            wrapper.create_chi = create_chi;
            wrapper.lookup_list = lookup_list;
            wrapper.base64att = base64att;
            wrapper.ObjectCount = 2;
            wrapper.SubId = subID;

            sendemailforformsubmission(wrapper);

            SubId ids = new SubId();
            ids.SubmissionId = formsub.Id;
            ids.SignatureId = signatureid;
            ids.Sig_upload_map = sigUploadMap;
            ids.File_upload_map = file_upload_map;
            return ids;
            
        } catch (Exception e){
            System.debug('errror' +String.valueOf(e) + e.getLineNumber());
            return null;
        }
    }

    /**
     * @description createrecord_for_third_object Method
     * @param acc Form_Submission__c record
     * @param first_obj_list SObject record
     * @param list_second_obj SObject record
     * @param list_third_obj SObject record
     * @param sig_upload_jsone String Value
     * @param sig_upload_fid_list List of String
     * @param file_upload_jsone String Value
     * @param file_upload_fid_list List of String
     * @param create_chi Boolean Value
     * @param lookup_list List of String
     * @param create_chi_2 Boolean Value
     * @param lookup_list2 List of String
     * @param base64att String value
     * @return SubId record
     * @return base64att String
     */
    @AuraEnabled
    public static SubId createrecord_for_third_object(Form_Submission__c acc, SObject first_obj_list, SObject list_second_obj, SObject list_third_obj, String sig_upload_jsone, List<String> sig_upload_fid_list, String file_upload_jsone, List<String> file_upload_fid_list, Boolean create_chi, List<String> lookup_list, Boolean create_chi_2, List<String> lookup_list2, String base64att){
        try{
            /*This method is used create form submission*/
            String signatureid;
            String fildid;
            Map<String, Object> file_upload_map = new Map<String, Object>();
            Map<String, Object> sigUploadMap = new Map<String, Object>();
            Map<String, Object> sigMap = (Map<String, Object>)JSON.deserializeUntyped(sig_upload_jsone);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(file_upload_jsone);

            Map<String, Object> firstobjectdata = first_obj_list.getPopulatedFieldsAsMap();
            Map<String, Object> secondobjectdata = list_second_obj.getPopulatedFieldsAsMap();
            Map<String, Object> thirdobjectdata = list_third_obj.getPopulatedFieldsAsMap();

            Map<String, Object> otherobjectdata = (Map<String, Object>) JSON.deserializeUntyped(acc.Other_fields_data__c);
            String subID = '';
            Integer sig_list_len = sig_upload_fid_list.size();
            if (sig_list_len > 0){
                for (String sigType : sig_upload_fid_list){
                    String sigBaseid = (String) sigMap.get(sigType);
                    signatureid = signatureSave(subID, sigBaseid);
                    sigUploadMap.put(sigType, signatureid);
                    otherobjectdata.put(sigType, signatureid);
                }
            }

            Integer listLen = file_upload_fid_list.size();
            if (listLen > 0){
                for (String type : file_upload_fid_list){
                    String[] address = type.split('<!QF!>');
                    String fName = address[1];
                    String fType = address[2];
                    String baseid = (String) m.get(type) ;
                    fildid = SaveFile(subID, fName, baseid, fType);
                    file_upload_map.put(address[0], fildid);
                    otherobjectdata.put(address[0], fildid);
                }
            }
            

            Form_Submission__c formsub = new Form_Submission__c();
            formsub.Form__c = acc.Form__c;
            formsub.First_object_data__c = acc.First_object_data__c;
            formsub.Second_object_data__c = acc.Second_object_data__c;
            formsub.Third_object_data__c = acc.Third_object_data__c;
            formsub.Other_fields_data__c = JSON.serialize(otherobjectdata);

            if (Schema.sObjectType.Form_Submission__c.fields.First_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Second_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Third_object_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Form__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.Other_fields_data__c.isCreateable() && Schema.sObjectType.Form_Submission__c.fields.First_object_data__c.isAccessible() && Schema.sObjectType.Form_Submission__c.fields.Second_object_data__c.isAccessible() && Schema.sObjectType.Form_Submission__c.fields.Third_object_data__c.isAccessible() && Schema.sObjectType.Form_Submission__c.fields.Form__c.isAccessible() && Schema.sObjectType.Form_Submission__c.fields.Other_fields_data__c.isAccessible()){
                insert formsub;
                subID = formsub.Id;
                insertRecordList.add(formsub.Id);
            }

            // To pass data to email service class
            wrapformsubmission wrapper = new wrapformsubmission();
            wrapper.acc = acc;
            wrapper.sig_upload_jsone = sig_upload_jsone;
            wrapper.sig_upload_fid_list = sig_upload_fid_list;
            wrapper.file_upload_jsone = file_upload_jsone;
            wrapper.file_upload_fid_list = file_upload_fid_list;
            wrapper.create_chi = create_chi;
            wrapper.lookup_list = lookup_list;
            wrapper.base64att = base64att;
            wrapper.lookup_list2 = lookup_list2;
            wrapper.create_chi_2 = create_chi_2;
            wrapper.ObjectCount = 3;
            wrapper.SubId = subID;

            sendemailforformsubmission(wrapper);

            SubId ids = new SubId();
            ids.SubmissionId = formsub.Id;
            ids.SignatureId = signatureid;
            ids.Sig_upload_map = sigUploadMap;
            ids.File_upload_map = file_upload_map;
            return ids;

        } catch (Exception e){
            System.debug('Exception--->' + e.getMessage() + ' -->>' + e.getLineNumber());
            return null;
        }
    }

    /**
     * @description sendemailforformsubmission Method
     * @param wrapper wrapformsubmission
     */
    public static void sendemailforformsubmission(wrapformsubmission wrapper) {
        /*This method is used Send email to email service class*/
        try{
            EmailServicesAddress esa = [SELECT EmailDomainName, LocalPart FROM EmailServicesAddress WHERE Function.FunctionName =: 'QuickFormemailservice' LIMIT 1 ]; 
            List<OrgWideEmailAddress> owea  = [SELECT Id, Address from OrgWideEmailAddress WHERE DisplayName =: 'QF-OWA' LIMIT 1  ];
             
            Messaging.SingleEmailMessage emailNotification = new Messaging.SingleEmailMessage();        
            List<String> toAddresses = new List<String>();
            toAddresses.add(esa.LocalPart+'@' +esa.EmailDomainName);
            if ( owea.size() > 0 ) {
                emailNotification.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            emailNotification.setToAddresses(toAddresses);
            emailNotification.setSubject('Three Object Form');
            emailNotification.setPlainTextBody(JSON.serialize(wrapper));
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ emailNotification });
        } catch(Exception e){
            System.debug(e);
        }
        
    }

    /**
     * @description GetFormValidation Method
     * @param form_id String Value
     * @return List of Form_Fields__c
     */
    @AuraEnabled
    public static List<Form_Fields__c> GetFormValidation(String form_id){
        /*This method is used to get field validation.*/
        try{
            List<Form_Fields__c> form_val_list = [SELECT Field_Mapping__c, Field_Validations__c
                                                  FROM Form_Fields__c
                                                  WHERE Form__c = :form_id
                                                  WITH SECURITY_ENFORCED];

            return form_val_list;

        } catch (Exception e){
            return null;
        }
    }

    /** @description SubId class */
    public class SubId{
        /** @description SubmissionId - String */
        @AuraEnabled
        public String SubmissionId{ get; set; }

        /** @description SignatureId - String */
        @AuraEnabled
        public String SignatureId{ get; set; }

        /** @description Sig_upload_map - Map of String as Key and Object record as value */
        @AuraEnabled
        public Map<String, Object> Sig_upload_map{ get; set; }

        /** @description File_upload_map - Map of String as Key and Object record as value */
        @AuraEnabled
        public Map<String, Object> File_upload_map{ get; set; }

    }

    /**
     * @description findlookupfildes Method
     * @param minobj String Value
     * @param fsubobj String Value
     * @return List of String
     */
    @AuraEnabled
    public static List<String> findlookupfildes(String minobj, String fsubobj){
        /*This method is used to get lookup fildes name.*/
        try{            
            String objectApiName = fsubobj;
            Map<String, Schema.SObjectType> objectTypes = Schema.getGlobalDescribe();
            Schema.SObjectType objectType = objectTypes.get(objectApiName);
            Map<String, Schema.SObjectField> fields = objectType.getDescribe().fields.getMap();
            List<String> lookupFields = new List<String>();
            for (String fieldName : fields.keySet()){
                Schema.DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();
                if (fieldDescribe.getType() == Schema.DisplayType.REFERENCE){
                    if (fieldDescribe.getReferenceTo()[0].getDescribe().getName() == minobj){
                        String field = fieldDescribe.getRelationshipName();
                        if(field.contains('__r')){
                           field = field.replace('__r', '');
                        }
                        if(minobj.contains('__c')){
                            minobj = minobj.replace('__c', '');
                        }
                        if (field == minobj){
                            if (fsubobj == 'Task' || fsubobj == 'Event'){
                                if (fieldDescribe.getName() != 'AccountId'){
                                    lookupFields.add(fieldDescribe.getName());
                                }
                            } else{
                                lookupFields.add(fieldDescribe.getName());
                            }
                        }
                    }
                }
            }
            return lookupFields;
        } catch (Exception e){
            return null;
        }
    }

   /** @description wrapformsubmission class */
    public class wrapformsubmission{

         /** @description acc - Form_Submission_Record record as value */
       public Form_Submission__c acc {get;set;}

        /** @description sig_upload_jsone - String of Base64 as value */
       public String sig_upload_jsone {get;set;}

        /** @description sig_upload_fid_list - List of String as value */
       public List<String> sig_upload_fid_list {get;set;}

        /** @description file_upload_jsone - String of Base64 as value */
       public String file_upload_jsone {get;set;}

        /** @description file_upload_fid_list - List of String as value */
       public List<String> file_upload_fid_list {get;set;}

        /** @description create_chi - Boolean to check create child as value */
       public Boolean create_chi {get;set;}

        /** @description lookup_list - List of String as value */
       public List<String> lookup_list {get;set;}

        /** @description create_chi_2 -Boolean to check create child as value */
       public Boolean create_chi_2 {get;set;}

        /** @description lookup_list2 - List of String as value */
       public List<String> lookup_list2 {get;set;}

        /** @description base64att - String of Base64 as value */
       public String base64att {get;set;}

        /** @description ObjectCount - Integer as value */
       public Integer ObjectCount {get; set;}

        /** @description SubId - Submission Id as value */
       public Id SubId {get; set;}

    }
}