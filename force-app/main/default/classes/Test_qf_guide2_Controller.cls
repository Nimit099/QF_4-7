@istest
public class Test_qf_guide2_Controller {

    @istest
    public static void testgetsites() {
        List<Site> sitelist = qf_guide2_Controller.getSites();
        System.assert(sitelist != null , 'Successful');
    }
    
    @istest
    public static void testsavesecureurl() {
        
        Site s = [SELECT Id, Name, MasterLabel, Subdomain, SiteType, Status FROM Site Limit 1];
        System.assert(s != null, 'Successful');
        SiteDetail sd = [SELECT ID,DurableId FROM SiteDetail WHERE DurableId =:  s.ID];
        System.assert(sd != null, 'Successful');
        
        qf_guide2_Controller.saveSecureUrl(s.ID);
        qf_guide2_Controller.saveSecureUrl(sd.ID);
    }
    
    @istest 
    public static void testgetsettingdata() {
        String data = qf_guide2_Controller.getSettingData();
        System.assert(data  == null , 'Successful');
   
    }
    
    @istest
    public static void testgetsiteprefixes() {
        
        // Define test data
        Site newSite  = [SELECT Id, Name, GuestUserId FROM Site WITH SECURITY_ENFORCED LIMIT 1];        
            
        // Create a test permission set record
        PermissionSet permissionset = new PermissionSet(
            Name = 'TestQuickform',
            Label = 'TestQuickform'
        );
        insert permissionset;
            
        // // Create a test permission set assignment record for the old site user
        PermissionSetAssignment oldpsa = new PermissionSetAssignment(
            PermissionSetId = permissionset.Id,
            AssigneeId = newSite.GuestUserId
        );
        insert oldpsa;                
        // Call the method being tested
        Test.startTest();
                                
        System.assert(oldpsa != null , 'Successful');        
        
        qf_guide2_Controller.assignPermissionSet(newSite.Name, newSite.Name);
        Test.stopTest();  
    }
}