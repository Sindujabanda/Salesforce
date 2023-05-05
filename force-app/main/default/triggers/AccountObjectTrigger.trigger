trigger AccountObjectTrigger on Account (Before insert, After Insert, Before Update, After Update, Before Delete) {
    
    if(trigger.isinsert && trigger.isafter){
        AccountTriggerHandler.createTaskOnAccountInsert(trigger.new);
    }
    
     if(trigger.isinsert && trigger.isBefore){
        AccountTriggerHandler.isActiveFalse(trigger.new);
    }
    
    if(trigger.isUpdate && trigger.isafter){
        AccountTriggerHandler.CompleteAllTasksOnAccountUpdate(trigger.new, trigger.oldMap);
    }

}