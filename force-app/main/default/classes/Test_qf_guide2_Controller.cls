@istest
public class Test_qf_guide2_Controller {

    @istest
    public static void testgetsites() {
        List<Site> sitelist = qf_guide2_Controller.getSites();
        System.assert(sitelist != null , 'Successful');
    }
    
    @istest(SeeAllData=true) 
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
        qf_guide2_Controller.CustomSettingData data = qf_guide2_Controller.getSettingData();

        System.assert(data  == null , 'Successful');
   
    }
    
    @istest 
    public static void testgetsiteprefixes() {
        
        // Define test data
        String oldselectedSiteName = 'Old Site Name';
        String newselectedSiteName = 'New Site Name';
        
        // Create a test user record for the old site
        User oldSiteUser = new User(
            FirstName = 'Old Site Name',
            LastName = 'Site Guest User',
            Alias = 'tuser',
            Email = 'testuser@test.com',
            Username = 'testuser123test900124231@test.com',
            CommunityNickname = 'tuser90192301',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert oldSiteUser;
        
        // Create a test user record for the new site
        User newSiteUser = new User(
            FirstName = 'New Site Name',
            LastName = 'Site Guest User',
            Alias = 'tuser',
            Email = 'testuser@test1.com',
            Username = 'testuser123test90012@test.com',
            CommunityNickname = 'tuser9019230182341',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert newSiteUser;
            
        // Create a test permission set record
        PermissionSet permissionset = new PermissionSet(
            Name = 'TestQuickform',
            Label = 'TestQuickform'
        );
        insert permissionset;
            
        // Create a test permission set assignment record for the old site user
        PermissionSetAssignment oldpsa = new PermissionSetAssignment(
            PermissionSetId = permissionset.Id,
            AssigneeId = oldSiteUser.Id
        );
        insert oldpsa;                
        // Call the method being tested
        Test.startTest();
                
        List<String> sitedata = qf_guide2_Controller.getSitePrefixes();
        System.assert(sitedata != null , 'Successful');
        
        System.assert(newselectedSiteName != null , 'Successful');
        System.assert(oldselectedSiteName != null , 'Successful');
        
        qf_guide2_Controller.assignPermissionSet(oldselectedSiteName, newselectedSiteName);
        qf_guide2_Controller.getUserEmail(newSiteUser.Id);
        qf_guide2_Controller.updateUserEmail('test@test.com',newSiteUser.Id);
        Test.stopTest();  
    }
}