global class TrialEmailService implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        try{
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            System.debug(result);
            result.add('Form__c', 'ol');
            return result;
      } catch(Exception e){
          return null;
      }
    }
}