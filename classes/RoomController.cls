public class RoomController {
    public List<Room_List__c> availableList{get;set;}
    public List<Room_List__c> bookedList{get;set;}
   
    public RoomController() {
        availableList = new List<Room_List__c>();
        availableList = [SELECT id, Name,Base_Price__c,Type__c From Room_List__c where status__c ='Available' order by roomno__c asc] ;
        bookedList= new List<Room_List__c>();
        bookedList= [SELECT id, Name,Base_Price__c,Type__c,Current_Booking__c From Room_List__c where status__c ='Booked' order by roomno__c] ;

    }
   
}