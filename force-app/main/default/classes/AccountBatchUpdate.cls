public class AccountBatchUpdate implements Database.batchable<sObject>, Database.Stateful{ 

    public List<SObject> accounts;

    public AccountBatchUpdate(List<SObject> accounts){      
        this.accounts = accounts;
    }
    public List<SObject> start(Database.BatchableContext BC)
    {
        return[SELECT Id,AccountId,Push_Date__c,Account.PushToVendor__c FROM Contact WHERE AccountId IN :accounts];
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> scope)
    {
        System.debug('enter to execute');
        List<Contact> contactsToUpdate = new List<Contact>();
        for(Contact c: scope){
            if(string.isNotBlank(c.Account.PushToVendor__c)){
                if(c.Account.PushToVendor__c=='Yes'){
                    c.Push_Date__c = date.today();
                }
                else if(c.Account.PushToVendor__c=='No'){
                    c.Push_Date__c = null;         
                }
                contactsToUpdate.add(c);
            }
        }
        update contactsToUpdate;
    
    }
    
    public void finish(Database.BatchableContext BC)
    {
        //finish method is where you do your DML and commit your processed information to Salesforce, 
        //this is for creating log records for your integration, and updating processed records to the 
        //database and chaining another batch class or even schedule one.
        
    }
}