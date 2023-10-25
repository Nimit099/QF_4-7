@isTest
public class Test_objectSelection {
    public static List<String> testData;
    
    @isTest
    static void testfetchparentobject(){
        objectSelection o = new objectSelection();
        List<String> parent = objectSelection.fetchParentObject();
        System.assert(parent != null, 'Successful');
    }

    @isTest
    static void testtemp2(){
        
        List<String> data = new List<String> {'Account','Case'};
        List<String> tem21 = objectSelection.temp2(testData);
        List<String> tem22 = objectSelection.temp2(data);
        System.assert(tem21 != null, 'Successful');
        System.assert(tem22 != null, 'Successful');
    }

    @IsTest
    static void testtemp3(){
        List<String> data = new List<String> {'Account','Case'};
        List<String> tem31 = objectSelection.temp3(testData);
        List<String> tem32 = objectSelection.temp3(data);
        System.assert(tem31 != null, 'Successful');
        System.assert(tem32 != null, 'Successful');
    }
    @IsTest
    static void testfetchchildobject(){
        List<String> child = objectSelection.fetchChildObject('Account');
        System.assert(child != null, 'Successful');
    }
    @IsTest
    static void testsavemappedobject(){
        String saveobject = objectSelection.saveMapped_object('Account', 'FormTitle', 'FormDesc', 'None', 'None');
        String saveobject1 = objectSelection.saveMapped_object('Account,Contact', 'FormTitle', 'FormDesc', 'None', 'None');
        System.assert(saveobject != null, 'Successful');
        System.assert(saveobject1 != null, 'Successful');
    }
}