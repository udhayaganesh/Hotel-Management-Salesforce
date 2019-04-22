@isTest
private class Util_UTC {
    public static opportunity__c opp;
    public static TableList__c table;
    public static RoomBooking__c rbooking;
    public static Room_List__c room;

    static {



        opp = new opportunity__c();
        opp.EmailAddress__c = 'udhay@gmail.com';
        //opp.OrderNumber__c ='100';
        //stagename__c ='';
        //status__c='';
        //TableList__c
        //type__c
        insert opp;


        table = new TableList__c();
        table.NoOfPerson__c = '1';
        table.opportunitynew__c = opp.id;
        table.Status__c = 'Available';
        table.TableNo__c = Decimal.valueof('1');
        insert table;

        ApexPages.currentPage().getParameters().put('sid', table.id);



        product__c prod = new product__c();
        prod.Family__c = 'Lunch';
        prod.price__c = Decimal.valueof('100.00');
        prod.name = 'Meals';
        insert prod;

        OrderTaking__c order = new OrderTaking__c();
        order.price__c = Decimal.valueof('1000.00');
        order.quantity__c = Decimal.valueof('1');
        order.status__c = 'Available';
        order.opportunity__c = opp.id;
        order.product__c = prod.id;
        insert order;





        room = new Room_List__c();
        room.Base_Price__c = Decimal.valueof('100.00');
        //Current_Booking__c
        room.RoomNo__c = Decimal.valueof('1');
        room.Status__c = 'Booked';
        room.Type__c = 'Deluxe';
        room.name = '1';
        insert room;



        rbooking = new RoomBooking__c();
        rbooking.Room_Link__c = room.id;
        rbooking.Amount_Paid__c = Decimal.valueof('1000.00');
        rbooking.Check_In__c = date.today();
        rbooking.Check_Out__c = date.today() + 2;
        rbooking.Guest_Mobile__c = '63663632';
        rbooking.Guest_Name__c = 'Guest';

        insert rbooking;





    }
 
    static testMethod void validateRoomControl() {
        RoomController r = new RoomController();

    }
     

}