public class TableController {
    public List<TableList__c> availableList{get;set;}
    public TableController() {
        availableList = new List<TableList__c>();
        availableList = [SELECT id, Name,status__c,TableNo__c,NoOfPerson__c,Opportunitynew__c From TableList__c  order by TableNo__c asc] ;
    }
    
}