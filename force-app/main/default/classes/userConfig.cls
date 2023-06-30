/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-03-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class userConfig {

    // Public Id selectedSite;

    public userConfig() {

    }


    @AuraEnabled
    public static List<Site> getSites() {
        return [SELECT Id, Name, MasterLabel, Subdomain, SiteType, Status FROM Site WHERE Status='Active' ];
    }

    @AuraEnabled
    public static void saveSecureUrl(Id selectedSiteid) {
        System.debug('siteID : '+selectedSiteid);
        SiteDetail siteDetail = [SELECT Id, SecureUrl FROM SiteDetail WHERE DurableId = :selectedSiteid];
        System.debug('SecureUrl : '+siteDetail);
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


    // @AuraEnabled
    // public static void saveSecureUrl(String siteId, String secureUrl) {
    //     Site_Details__c setting = new Site_Details__c();
    //     // setting.SiteName__c = siteId;
    //     setting.SiteUrl__c = secureUrl;
    //     upsert setting SiteUrl__c;
    //     // upsert setting SiteName__c;
    // }
}