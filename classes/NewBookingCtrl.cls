public class NewBookingCtrl {

    public boolean checkout {
        get;
        set;
    }
    public String roomno {
        get;
        set;
    }
    public Decimal tax {
        get;
        set;
    }
    public Decimal total {
        get;
        set;
    }

    public RoomBooking__c booking {
        get;
        set;
    }

    public NewBookingCtrl(ApexPages.StandardController controller) {
        roomno = ApexPages.currentPage().getparameters().get('aid');
        String recID = ApexPages.currentPage().getparameters().get('id');
        if (recID != null) {
            checkout = true;
            booking = [select id, name, Check_In__c, Check_Out__c, Room_Link__r.name, Deal__c, Pending_Amount__c, Guest_Mobile__c, Guest_Name__c, Guest_Address__c, Guest_Verfication_ID__c, Amount_Paid__c, Additional_Charges__c from RoomBooking__c where id = :recID];
            roomno = booking.Room_Link__r.name;
        }
        else {
            checkout = false;
            booking = new RoomBooking__c();
            booking.Room_Link__c = ApexPages.currentPage().getparameters().get('sid');
        }
    }

    public PageReference saveRecord() {
        String recordID = ApexPages.currentPage().getparameters().get('id');
        String recID = ApexPages.currentPage().getparameters().get('sid');
        if (recordID == null) {
            Room_List__c roomLs = [select id, status__c, Base_Price__c from Room_List__c where id = :recID];
            RoomBooking__c cd = new RoomBooking__c();
            cd.Guest_Address__c = booking.Guest_Address__c;
            cd.Guest_Verfication_ID__c = booking.Guest_Verfication_ID__c;
            cd.Amount_Paid__c = booking.Amount_Paid__c;
            cd.Additional_Charges__c = booking.Additional_Charges__c;
            cd.Check_In__c = booking.Check_In__c;
            cd.Check_Out__c = booking.Check_Out__c;
            cd.Guest_Mobile__c = booking.Guest_Mobile__c;
            cd.Guest_Name__c = booking.Guest_Name__c;
            cd.Room_Link__c = recID;
            cd.Price_Per_Day__c = roomLs.Base_Price__c;
            cd.Deal__c = 'Checked-In';

            insert cd;

            if (booking.Check_In__c == date.today()) {
                roomLs.status__c = 'Booked';
                roomLs.Current_Booking__c = cd.id + '';
                update roomLs;
            }
            Pagereference pg = new Pagereference('/apex/NewBooking?id=' + cd.id);
            pg.setredirect(true);
            return pg;
        }
        else {
            update booking;
            Pagereference pg = new Pagereference('/apex/NewBooking?id=' + booking.id);
            pg.setredirect(true);
            return pg;
        }
    }
    public PageReference checkOut() {
        Id roomno = booking.Room_Link__r.id;
        booking.Deal__c = 'Checked-Out';
        update booking;
        Room_List__c roomLs = [select id, status__c from Room_List__c where id = :roomno];
        roomLs.status__c = 'Available';
        roomLs.Current_Booking__c = '';
        update roomLs;

        PageReference p = new PageReference('/apex/PrintBill?id=' + booking.id);
        p.setRedirect(true);
        return p;
    }

    public PageReference back() {
        PageReference p = new PageReference('/apex/RoomList');
        p.setRedirect(true);
        return p;
    }

}