@istest
public class AccountTriggerHandler_test 
{
	@testsetup
    public static void dataSetup()
    { 
        List<Account> accList = new List<Account>();
        Account acc;
         acc = new Account();
        acc.Name = 'test';
        acc.IsActive__c = false;
        acc.AccountNumber = 'test';
       accList.add(acc);
        acc = new Account();
        acc.Name = 'test';
        acc.IsActive__c = false;
       accList.add(acc);
        acc = new Account();
        acc.Name = 'test';
        acc.IsActive__c = true;
        acc.AccountNumber = 'test';
       accList.add(acc);
        acc = new Account();
        acc.Name = 'test';
        acc.IsActive__c = true;
       accList.add(acc);
        insert accList;
    }
    @istest
    public static void createTaskOnAccountInsert_test()
    {
        List<Account> accList = [select Id, Name,IsActive__c, AccountNumber from Account where isActive__c = false ];
        test.startTest();
        AccountTriggerHandler.createTaskOnAccountInsert(accList);
        test.stopTest();
    }
    @istest
    public static void CompleteAllTasksOnAccountUpdate()
    {
        List<Account> accList = new List<Account>();
         Map<Id,Account> accMap = new Map<Id,Account>([select Id, Name,IsActive__c, AccountNumber from Account
                                                       where isActive__c = false ]);
        for(Account acc : accMap.values())
        {
            acc.isActive__c = true;
        }
        update accMap.values();
    }
}