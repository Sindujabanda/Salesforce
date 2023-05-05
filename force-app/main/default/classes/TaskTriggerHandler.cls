public class TaskTriggerHandler {
    Public Static void activateAccountOnTaskCompletion(list<Task> taskList, Map<Id, Task> oldMap){
        User currentUser = [Select id from user where id =:UserInfo.getUserId() AND isActive=True limit 1];
        List<permissionsetAssignment> permSetAssignments=[SELECT Id, PermissionSetId, PermissionSetGroupId, AssigneeId, SystemModstamp, ExpirationDate, IsActive FROM PermissionSetAssignment where AssigneeId=:currentUser.Id AND PermissionSet.Name = 'CQ_Account_Admin'];
        Set<Id> accountIdList = new Set<Id>();
        Map<Id,Task> accountAndTaskMap = new Map<Id, Task>();
        for(Task taskRecord: taskList){
                if((oldMap.get(taskRecord.Id).Status !=taskRecord.Status) && taskRecord.Status=='Completed' ){
                    accountIdList.add(taskRecord.AccountId);
                    accountAndTaskMap.put(taskRecord.AccountId, taskRecord);
                }               
        }
        list<Account> accountList = [Select Id, name, IsActive__c, Description from Account where id IN: accountIdList];
        for(Account finalAccountRecords: accountList){
            finalAccountRecords.IsActive__c = true;
            if( finalAccountRecords.Description == null ||  finalAccountRecords.Description ==''){
                finalAccountRecords.Description =accountAndTaskMap.get(finalAccountRecords.Id).Description;
            }else{
                finalAccountRecords.Description += accountAndTaskMap.get(finalAccountRecords.Id).Description;
            }
        }
        if(!accountList.isEmpty()){
            update accountList;
        }
    }
    
    public static void activateAccountOnBeforeUpdate(List<Task> taskList){
        User currentUser = [Select id from user where id =:UserInfo.getUserId() AND isActive=True limit 1];
        List<permissionsetAssignment> permSetAssignments=[SELECT Id, PermissionSetId, PermissionSetGroupId, AssigneeId, SystemModstamp, ExpirationDate, IsActive FROM PermissionSetAssignment where AssigneeId=:currentUser.Id AND PermissionSet.Name = 'CQ_Account_Admin'];
        for (Task taskuser: taskList){
            if(permSetAssignments.size()>0 && taskuser.Status == 'Completed'){
                taskuser.Status = 'Completed';
            }else {
                taskuser.Status = 'Not Started';
            }
        }
    }
}