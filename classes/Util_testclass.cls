@isTest
private class Util_testclass {
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

    static testMethod void validateProd() {
        ProductController p = new ProductController();
        p.emailAddr = 'test@test.com';
        ApexPages.currentPage().getParameters().put('oppid', opp.id);
        p.oppid = opp.id;
        p.redirectPopup();
        p.getRecord();
        p.getLongDate();
        p.saveOrder();
        p.oppid = null;
        p.selectedValue = 'Lunch';
        p.getRecord();
        p.saveOrder();
        p.redirectPopup();
        p.sendEmail();
        p.closePopup();
        p = new ProductController();



        // p.MPItems;
        //p.MPOptions;
    }
    static testMethod void validateSOC() {
        ServiceOrderController s = new ServiceOrderController();
        table.Status__c = 'Serving';
        upsert table;

        s.updateOppId = opp.id;
        s.deliver();
        s.incrementCounter();
    }

    static testMethod void validateTable() {
        TableController t = new TableController();

    }
    static testMethod void validateRoomControl() {
        RoomController r = new RoomController();

    }
    static testMethod void validateBill() {
        BillDetailsHandler b = new BillDetailsHandler();
    BillDetailsHandler.OpportuntiyId = opp.id;
    b.getData();
    BillDetailsHandler.Customer c= new BillDetailsHandler.Customer();
    c.Name='';
        c.CDate='';
        
        c.OrderNo='';
        c.TableName='';
        c.Email='';
try{

    b.getCustomerData();
      } catch (Exception e) {}


    }



    static testMethod void validateNewOrder() {
        //ApexPages.currentPage().getParameters().put('id',rbooking.id);

        NewBookingCtrl n = new NewBookingCtrl(new ApexPages.StandardController(rbooking));

        try {
            // n.saveRecord();
            // n.checkOut();
        } catch (Exception e) {}
        system.debug('---->' + room.id);
        ApexPages.currentPage().getParameters().put('aid', '1');
        ApexPages.currentPage().getParameters().put('id', rbooking.id);
        ApexPages.currentPage().getParameters().put('sid', room.id);
        n.booking = rbooking;

        try {
            ApexPages.currentPage().getParameters().put('id', room.id);

            n.saveRecord();
            n.checkOut();
        } catch (Exception e) {}



        try {
            ApexPages.currentPage().getParameters().put('id', null);

            n.saveRecord();
            n.checkOut();
        } catch (Exception e) {}


        n.back();
        n = new NewBookingCtrl(new ApexPages.StandardController(rbooking));
    }

}