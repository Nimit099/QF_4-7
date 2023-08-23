/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-03-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class userConfig {




    @AuraEnabled
    public static List<Site> getSites() {
        return [SELECT Id, Name, MasterLabel, Subdomain, SiteType, Status FROM Site WHERE Status='Active' ];
    }

    @AuraEnabled
    public static void saveSecureUrl(Id selectedSiteid) {
        SiteDetail siteDetail = [SELECT Id, SecureUrl FROM SiteDetail WHERE DurableId = :selectedSiteid];
        Site_Details__c customSetting = Site_Details__c.getInstance();
        customSetting.SiteUrl__c = siteDetail.SecureUrl;
        upsert customSetting;
    }

    // get site from org 

    @AuraEnabled
    public static List<String> getSitePrefixes() {
        List<String> sitePrefixes = new List<String>();
        for(Site site : [SELECT Id, Name, Subdomain, SiteType, Status FROM Site WHERE Status='Active']) {
            if(site.SiteType == 'Site') {
                sitePrefixes.add(site.Subdomain);
            }
        }
        return sitePrefixes;
    }

}