trigger TaskObjectTrigger on Task (Before insert, After Insert, Before Update, After Update, Before Delete) {
 if(trigger.isupdate && trigger.isafter){
        TaskTriggerHandler.activateAccountOnTaskCompletion(trigger.new, trigger.oldMap);
    }
    if(trigger.isupdate && trigger.isbefore){
        TaskTriggerHandler.activateAccountOnBeforeUpdate(trigger.new);
    }
}