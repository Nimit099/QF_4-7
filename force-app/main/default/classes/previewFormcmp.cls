/**
* Class Name : previewFormcmp
* Test Class : Test_previewFormcmp
* Date : 05/04/2023
* @description : Used in previewFormCmp LWC componnet
*/
public without sharing class previewFormcmp{

    /**
    * Method Name : formdetails
    * @description : formdetails.
    * @param id Id value.
    * @param webUrl String value.
    * @return Form__c record.
    */
    @AuraEnabled
    public static Form__c formdetails(Id id, String webUrl){
        Form__c nform = new Form__c();
        try{
            nform = [SELECT Id, Name, Progress_Indicator__c, Captcha_Type__c, Button_CSS__c, Button_Position__c, Page_CSS__c, Form_Styling__c, All_Field_Hover__c, All_Field_Focus__c, All_Field_Styling__c, Label_CSS__c, FormBgID__c, PageBgID__c, Status__c, Mapped_Objects__c
                    FROM Form__c
                    WHERE Id = :id WITH SECURITY_ENFORCED];
            if (nform == null) {
                return null;
            }
            if (nform.Status__c && webUrl != null && webUrl != ''){
                String baseUrl = webUrl.split('PreViewForm?')[0];

                QuickForm_Administration__c customsetting = QuickForm_Administration__c.getOrgDefaults();
                if(customsetting.SecureUrl__c.right(1) != '/') {
                    customsetting.SecureUrl__c += '/';
                }
                if (baseUrl != customsetting.SecureUrl__c){
                    nform.Status__c = false;
                }
            } else if (String.isBlank(webUrl)){
                nform.Status__c = true;
            }
        } catch (Exception e){
            System.debug(e);
            return null;
        }
        return nform;
    }

    /**
    * Method Name : bgimages
    * @description : bgimages
    * @param id Id value.
    * @param data String value.
    * @return String
    */
    @AuraEnabled
    public static String bgimages(Id id, String data){
        try{
            String result = '';
            ContentVersion cv = new ContentVersion();
            cv = [SELECT Id, VersionData
                    FROM ContentVersion
                    WHERE Id = :id WITH SECURITY_ENFORCED];
            if (cv == null) {
                return null;
            }
            result += 'url("data:image/png;base64,' + EncodingUtil.base64Encode(cv.VersionData);
            String str = data.split('background-image:')[0];
            str += 'background-image:' + result + '");';

            return str;
        } catch (Exception e){
            return null;
        }
    }

    /**
    * Method Name : formfielddetails
    * @description : formfielddetails
    * @param id Id value.
    * @return List of Form_Fields__c
    */
    @AuraEnabled
    public static List<Form_Fields__c> formfielddetails(Id id){
        try{
            List<Form_Fields__c> fieldList = new List<Form_Fields__c>();
            fieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                                            FROM Form_Fields__c
                                            WHERE Form__c = :id WITH SECURITY_ENFORCED
                                            ORDER BY Field_Order__c ASC];
            return fieldList;
        } catch (Exception e){
            return null;
        }
    }

    /**
    * Method Name : formpagedetails
    * @description : formpagedetails
    * @param id String value.
    * @return List of Form_Page__c
    */
    @AuraEnabled
    public static List<Form_Page__c> formpagedetails(String id){
        try{
            List<Form_Page__c> pageList = new List<Form_Page__c>();
            pageList = [SELECT Id, Name, Page_Number__c
                                        FROM Form_Page__c
                                        WHERE Form__c = :id WITH SECURITY_ENFORCED
                                        ORDER BY Page_Number__c ASC];
            return pageList;
        } catch (Exception e){
            return null;
        }
    }

    /**
    * Method Name : getInactiveForms
    * @description : getInactiveForms
    * @param id String value.
    * @return Boolean
    */
    @AuraEnabled
    public static Boolean getInactiveForms(String id){
        try{
            List<Form__c> inactiveForm = new List<Form__c>();
            inactiveForm = [SELECT Id, Status__c
                            FROM Form__c
                            WHERE Status__c = false AND Id = :id WITH SECURITY_ENFORCED];
            if (inactiveForm.size() > 0){
                return true;
            } else{
                return false;
            }
        } catch (Exception e){
            return null;
        }
    }

       /**
    * Method Name : getthankyoupage
    * @param currentformid Id value.
    * @description : getthankyoupage
    * @return Thankyou_Page__c record.
    */
    @AuraEnabled
    public static Thankyou_Page__c getthankyoupage(Id currentformid){
        try {
            Thankyou_Page__c record = new Thankyou_Page__c();
            if(currentformid != null) {
                record = [SELECT Id, Name, Form__c,Thank_you_URL__c, Thankyou_Page_Type__c	, Thankyou_Text__c, ThankYou_Label__c	FROM Thankyou_Page__c WHERE Form__c =: currentformid WITH SECURITY_ENFORCED LIMIT 1];
            }
            if (record == null) {
                return null;
            }
            return record;
        } catch (Exception e) {
            System.debug('Exception--->' + e.getMessage() + ' -->>' + e.getLineNumber());
            return null;            
        }
    }
    
    /**
     * @description getreferencevalue Method
     * @param id Id Value
     * @param searchkey String Value
     * @return referencewrapper
     */
    @AuraEnabled
    public static referencewrapper getreferencevalue(Id id, String searchkey){
        /*This method is used to pass referenc field values*/
        try{
            if (Schema.sObjectType.Form_Fields__c.fields.Mapped_Obj__c.IsAccessible() && Schema.sObjectType.Form_Fields__c.fields.Field_Mapping__c.IsAccessible()){
                String searchkeyword = '%' + searchkey + '%';
                String query;
                Form_Fields__c mappedObject = [SELECT Id, Mapped_Obj__c, Field_Mapping__c
                                               FROM Form_Fields__c
                                               WHERE Id = :id];
                String mappedfield = mappedObject.Field_Mapping__c.split('<!@!>')[0];
                Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get(mappedObject.Mapped_Obj__c).getDescribe().fields.getMap().get(mappedfield).getDescribe();
                String objects;
                for (Schema.SObjectType reference : f.getReferenceTo()){
                    objects = reference.getDescribe().getName();
                }
                if (searchkey == null || searchkey == 'undefined' || searchkey == ''){
                    query = 'SELECT Id, Name FROM ' + String.escapeSingleQuotes(objects) + ' Limit 1000';
                } else{
                    query = 'SELECT Id, Name FROM ' + String.escapeSingleQuotes(objects) + ' WHERE Name LIKE :searchkeyword';
                }
                List<sObject> objectRecords = Database.query(query);

                referencewrapper rw = new referencewrapper();
                rw.referenceval = objectRecords;
                Map<String, String> objectIconMap = new Map<String, String>{ 'Account' => 'standard:account', 'Address' => 'standard:address', 'AlternativePaymentMethod' => 'standard:payment_gateway', 'Announcement' => 'standard:announcement', 'AppAnalyticsQueryRequest' => 'standard:care_request_reviewer', 'AppointmentTopicTimeSlot' => 'standard:timeslot', 'ApptBundleAggrDurDnscale' => 'standard:event', 'ApptBundleAggrPolicy' => 'standard:aggregation_policy', 'ApptBundleConfig' => 'standard:bundle_config', 'ApptBundlePolicy' => 'standard:bundle_policy', 'ApptBundlePolicySvcTerr' => 'standard:service_territory_policy', 'ApptBundlePropagatePolicy' => 'standard:propagation_policy', 'ApptBundleRestrictPolicy' => 'standard:restriction_policy', 'ApptBundleSortPolicy' => 'standard:sort_policy', 'Asset' => 'standard:asset_object', 'AssetDowntimePeriod' => 'standard:asset_downtime_period', 'AssetRelationship' => 'standard:asset_relationship', 'AssetWarranty' => 'standard:asset_warranty', 'AssociatedLocation' => 'standard:location', 'AttributeDefinition' => 'standard:variation_attribute_setup', 'AuthorizationForm' => 'standard:form', 'AuthorizationFormConsent' => 'standard:form', 'AuthorizationFormDataUse' => 'standard:form', 'AuthorizationFormText' => 'standard:form', 'BusinessBrand' => 'standard:store', 'CalendarView' => 'standard:date_input', 'Campaign' => 'standard:campaign', 'CampaignMember' => 'standard:campaign_members', 'CardPaymentMethod' => 'standard:contract_payment', 'Case' => 'standard:case', 'CollaborationGroup' => 'standard:live_chat', 'CollaborationGroupRecord' => 'standard:live_chat', 'CommSubscription' => 'standard:product_consumed', 'CommSubscriptionChannelType' => 'standard:channel_program_levels', 'CommSubscriptionConsent' => 'standard:product_consumed', 'CommSubscriptionTiming' => 'standard:channel_program_history', 'ConsumptionRate' => 'standard:product_consumed_state', 'ConsumptionSchedule' => 'standard:product_consumed_state', 'Contact' => 'standard:contact', 'ContactPointAddress' => 'standard:address', 'ContactPointConsent' => 'standard:address', 'ContactPointEmail' => 'standard:email', 'ContactPointPhone' => 'standard:call', 'ContactPointTypeConsent' => 'standard:contact', 'ContactRequest' => 'standard:contact_request', 'ContentVersion' => 'standard:file', 'Contract' => 'standard:contract', 'ContractGroupPlan' => 'standard:contract', 'ContractGroupPlanGroupClass' => 'standard:contract', 'ContractLineItem' => 'standard:contract_line_item', 'Customer' => 'standard:customer', 'DataUseLegalBasis' => 'standard:product_consumed', 'DataUsePurpose' => 'standard:product_consumed', 'DigitalWallet' => 'standard:connect_wallet', 'DuplicateRecordItem' => 'custom:custom49', 'DuplicateRecordSet' => 'standard:record', 'EngagementChannelType' => 'standard:channel_programs', 'Entitlement' => 'standard:entitlement', 'EntitlementContact' => 'standard:people', 'Event' => 'standard:event', 'Expense' => 'standard:expense', 'ExpenseReport' => 'standard:expense_report', 'ExpenseReportEntry' => 'standard:expense_report_entry', 'ExpressionFilter' => 'standard:filter', 'ExpressionFilterCriteria' => 'standard:filter_criteria', 'FinanceTransaction' => 'standard:crypto_transaction', 'FlowRecordRelation' => 'standard:flow', 'GroupCensus' => 'standard:groups', 'GroupCensusMember' => 'standard:groups', 'GroupCensusMemberPlan' => 'standard:groups', 'GroupClass' => 'standard:groups', 'GroupClassContribution' => 'standard:groups', 'Idea' => 'standard:solution', 'Image' => 'custom:custom38', 'Individual' => 'standard:individual', 'InsuranceContract' => 'standard:entitlement_policy', 'JobProfile' => 'standard:job_profile', 'Lead' => 'standard:lead', 'LegalEntity' => 'standard:entity', 'ListEmail' => 'standard:list_email', 'ListEmailIndividualRecipient' => 'standard:email', 'ListEmailRecipientSource' => 'standard:email', 'Location' => 'standard:location', 'LocationGroup' => 'standard:location', 'LocationGroupAssignment' => 'standard:location', 'Macro' => 'standard:macros', 'MacroInstruction' => 'standard:macros', 'MaintenanceAsset' => 'standard:maintenance_asset', 'MaintenancePlan' => 'standard:maintenance_plan', 'MaintenanceWorkRule' => 'standard:maintenance_work_rule', 'Opportunity' => 'standard:opportunity', 'Order' => 'standard:orders', 'OrgMetric' => 'standard:dashboard', 'OrgMetricScanResult' => 'standard:dashboard_ea', 'OrgMetricScanSummary' => 'standard:dashboard_component', 'PartyConsent' => 'custom:custom69', 'Payment' => 'standard:contract_payment', 'PaymentAuthAdjustment' => 'standard:contract_payment', 'PaymentAuthorization' => 'standard:contract_payment', 'PaymentGateway' => 'standard:payment_gateway', 'PaymentGatewayLog' => 'standard:payment_gateway', 'PaymentGroup' => 'standard:partner_fund_request', 'PaymentLineInvoice' => 'standard:payment_gateway', 'Pricebook2' => 'standard:pricebook', 'ProcessException' => 'standard:process_exception', 'Product2' => 'standard:product', 'ProductConsumed' => 'standard:product_consumed', 'ProductConsumptionSchedule' => 'standard:product_consumed', 'ProductItem' => 'standard:product_item', 'ProductRequest' => 'standard:product_request', 'ProductRequestLineItem' => 'standard:product_request_line_item', 'ProductRequired' => 'standard:product_required', 'ProductServiceCampaign' => 'standard:product_service_campaign', 'ProductServiceCampaignItem' => 'standard:product_service_campaign_item', 'ProductTransfer' => 'standard:product_transfer', 'ProductWarrantyTerm' => 'standard:product_warranty_term', 'ProfileSkill' => 'standard:skill', 'ProfileSkillEndorsement' => 'standard:skill_entity', 'ProfileSkillUser' => 'standard:skill_entity', 'PromptAction' => 'standard:prompt', 'PromptError' => 'standard:prompt', 'QuickText' => 'standard:quick_text', 'Recommendation' => 'standard:feedback', 'RecommendationResponse' => 'standard:feedback', 'RecordAction' => 'standard:record', 'Refund' => 'standard:contract_payment', 'RefundLinePayment' => 'standard:contract_payment', 'ResourceAbsence' => 'standard:resource_absence', 'ReturnOrder' => 'standard:return_order', 'ReturnOrderLineItem' => 'standard:return_order_line_item', 'SchedulingConstraint' => 'standard:scheduling_constraint', 'Scorecard' => 'standard:scan_card', 'ScorecardAssociation' => 'standard:scan_card', 'ScorecardMetric' => 'standard:scan_card', 'SearchPromotionRule' => 'standard:search', 'Seller' => 'standard:partner_fund_allocation', 'SerializedProduct' => 'standard:serialized_product', 'ServiceAppointment' => 'standard:service_appointment', 'ServiceContract' => 'standard:service_contract', 'ServiceCrew' => 'standard:service_crew', 'ServiceCrewMember' => 'standard:service_crew_member', 'ServiceResource' => 'standard:service_resource', 'ServiceResourcePreference' => 'standard:service_territory', 'ServiceTerritory' => 'standard:service_territory', 'ServiceTerritoryLocation' => 'standard:location', 'SetupAssistantStep' => 'standard:setup_modal', 'Shift' => 'standard:shift', 'ShiftTemplate' => 'standard:shift_template', 'Shipment' => 'standard:shipment', 'ShipmentItem' => 'standard:shipment', 'Solution' => 'standard:solution', 'Task' => 'standard:task', 'TimeSheet' => 'standard:timesheet', 'TimeSheetEntry' => 'standard:timesheet_entry', 'TravelMode' => 'standard:location', 'UnitOfMeasure' => 'custom:custom79', 'UserEmailPreferredPerson' => 'standard:people', 'WarrantyTerm' => 'standard:warranty_term', 'WorkAccess' => 'standard:work_queue', 'WorkBadge' => 'standard:skill_requirement', 'WorkBadgeDefinition' => 'standard:skill_requirement', 'WorkOrder' => 'standard:work_order', 'WorkOrderLineItem' => 'standard:work_order_item', 'WorkPlan' => 'standard:work_plan', 'WorkPlanSelectionRule' => 'standard:work_plan_rule', 'WorkPlanTemplate' => 'standard:work_plan_template', 'WorkPlanTemplateEntry' => 'standard:work_plan_template_entry', 'WorkStep' => 'standard:work_step', 'WorkStepTemplate' => 'standard:work_step_template', 'WorkThanks' => 'standard:thanks', 'WorkType' => 'standard:work_type', 'WorkTypeGroup' => 'standard:work_type_group', 'WorkTypeGroupMember' => 'standard:team_member' };

                if (objectIconMap.containsKey(objects)){
                    rw.objicon = objectIconMap.get(objects);
                } else{
                    rw.objicon = 'custom:custom3';
                }
                return rw;
            } else{
                return null;
            }
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
     * @description getpicklistvalue Method
     * @param id Id Value
     * @return Map of String as key and String as value
     */
    @AuraEnabled
    public static Map<String, String> getpicklistvalue(Id id){
        /*This method is used to pass picklist value*/
        try{
                Form_Fields__c mappedObject = [SELECT Mapped_Obj__c, Field_Mapping__c
                                               FROM Form_Fields__c
                                               WHERE Id = :id WITH SECURITY_ENFORCED];
                String mappedfield = mappedObject.Field_Mapping__c.split('<!@!>')[0];
                Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
                Set<String> objectKeys = gd.keySet();
                Map<String, String> picklistvalue = new Map<String, String>();
                Schema.SObjectType systemObjectType = gd.get(mappedObject.Mapped_Obj__c);
                Schema.DescribeSObjectResult r = systemObjectType.getDescribe();
                Map<String, Schema.SObjectField> fieldsMap = r.fields.getMap();
                Schema.SObjectField field = fieldsMap.get(mappedfield);
                Schema.DescribeFieldResult fieldDesc = field.getDescribe();
                for (Integer i = 0; i < fieldDesc.getPicklistValues().size(); i++){
                    picklistvalue.put(fieldDesc.getPicklistValues()[i].getLabel(), fieldDesc.getPicklistValues()[i].getValue());
                }
                return picklistvalue;
        } catch (Exception e){
            return null;
        }
    }
}