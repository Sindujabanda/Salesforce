public class AccountTriggerHandler {
    
    Public Static void createTaskOnAccountInsert(List<Account> accountList){
        
        List<Task> taskRecordsList = new List<Task>();
        for(Account accountRecords:accountList ){
            if(accountRecords.IsActive__c==false){
                Task taskRecord = new task();
                taskRecord.Subject = 'Review Account-'+ accountRecords.AccountNumber ;
                taskRecord.ActivityDate	= System.Today().addDays(7);
                taskRecord.OwnerId = accountRecords.OwnerId;
                taskRecord.Status = 'Not Started';
                taskRecord.WhatId = accountRecords.Id;         
                taskRecordsList.add(taskRecord);
            }
        }
        if(!taskRecordsList.isEmpty()){
            Insert taskRecordsList;
        }
    }
    
    Public Static Void isActiveFalse(List<Account> accountList){
        for(Account accOnjRecrods: accountList){
            accOnjRecrods.IsActive__c = false;
        }        
    }
    
    Public Static Void CompleteAllTasksOnAccountUpdate(List<Account> accountList, Map<Id, Account> oldMap){
        Set<Id> accountIdSet = new Set<Id>();
        for(Account accountObj: accountList){
            if((accountObj.IsActive__c != oldMap.get(accountObj.Id).IsActive__c) && accountObj.IsActive__c == true){
                accountIdSet.add(accountObj.Id);
            }
        }
        List<Task> TaskList = [Select id, Status,WhatId from task where WhatId IN:accountIdSet];
        for(Task finalTaskRecords: TaskList){
            finalTaskRecords.Status = 'Completed';
        }
        if(!TaskList.isEmpty()){
            update TaskList;
        }
    }
}