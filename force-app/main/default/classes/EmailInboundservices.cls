global class EmailInboundservices implements Messaging.InboundEmailHandler {
	  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          try{
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            String formid = email.plainTextBody.split(',')[0];
            String submissionid = email.plainTextBody.split(',')[1];
            Notification__c notify = new Notification__c();
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress Limit 1];
            notify = [SELECT Id,Form__r.Name, To_Recipients__c, CC_Recipients__c, BCC_Recipients__c, Subject__c, Email_Body__c, Attachment__c, Status__c
                        FROM Notification__c
                        WHERE Form__c = :formid WITH SECURITY_ENFORCED];
                if (notify.Status__c == true){
                    if (notify != null || notify.Id != null){
                        String recipientList = notify.To_Recipients__c;
                        String ccmaillist = notify.CC_Recipients__c;
                        String bccmaillist = notify.BCC_Recipients__c;
                        String messageBody = notify.Email_Body__c;
                        String messageSubject = notify.Subject__c;
                        boolean attachmentpdf = notify.Attachment__c;
                        List<String> ccAddresses = new List<String>();
                        List<String> bccAddresses = new List<String>();
                        List<String> toAddresses = recipientList.split(',');
                        if (String.isNotBlank(ccmaillist)){
                            ccAddresses = ccmaillist.split(',');
                        }
                        if (String.isNotBlank(bccmaillist)){
                            bccAddresses = bccmaillist.split(',');
                        }

                        if (toAddresses.size() != 0){
                            Messaging.SingleEmailMessage emailNotification = new Messaging.SingleEmailMessage();
                            // if ( owea.size() > 0 ) {
                            //     emailNotification.setOrgWideEmailAddressId(owea.get(0).Id);
                            // }
                            emailNotification.setToAddresses(toAddresses);
                            if (ccAddresses.size() > 0){
                                emailNotification.setCCaddresses(ccAddresses);
                            }
                            if (bccAddresses.size() > 0){
                                emailNotification.setBCCaddresses(bccAddresses);
                            }
                            emailNotification.setSubject(messageSubject);
                            emailNotification.setHtmlBody(messageBody);
                            if (attachmentpdf == true){
                                String pdfUrl = '/apex/PDFGenerator?Id=' + submissionid;
                                PageReference pdfPage = new PageReference(pdfUrl);
                                Blob pdfContent;
                                if (Test.isRunningTest()){
                                    pdfContent = blob.valueOf('Unit.Test');
                                } else{
                                    pdfContent = pdfPage.getContentAsPDF();
                                }
                                Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
                                String pdfName = '';
                                if(String.isNotBlank(notify.Form__r.Name)){
                                    pdfName = notify.Form__r.Name +'_' +DateTime.now();
                                }
                                emailAttachment.setFileName(pdfName+'.pdf');
                                emailAttachment.setBody(pdfContent);
                                emailNotification.setFileAttachments(new Messaging.EmailFileAttachment[]{ emailAttachment });
                            }
                            System.debug('emailNotification' + emailNotification);
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ emailNotification });
                            // System.debug('results' + results);
                        }
                }
            }
          return result;
        } catch(Exception e){
            return null;
        }
      }
  }