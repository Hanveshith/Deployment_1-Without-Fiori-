
namespace database;

using { managed } from '@sap/cds/common';


entity orderHeader : managed {
    key hid : UUID;
    totalPrice : Decimal(9,2);
    discount : Decimal(6,2);
    status : String enum { Pending; Confirmed; Assigned; InProcess; Delivered }
    deliveryDate : Date;
    to_orderitems : Composition of many orderItems on to_orderitems.to_orderHeader = $self;
}

entity orderItems : managed {
    key oiid : UUID;
    name : String(54);
    price : Decimal(8,2);
    quantity : Integer;
    @UI.IsImageURL
    imageURL : LargeString;
    to_orderHeader : Association to one orderHeader;
}