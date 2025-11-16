using {database as db} from '../db/schema';

define service mainService @(path: '/mainService')@(restrict: [
    {
        grant: [
            'READ',
            'WRITE'
        ],
        to   : 'Admin'
    },
    {
        grant: ['READ'],
        to   : 'Customer'
    }
]) {
    entity orderHeader as projection on db.orderHeader;
    entity orderItems  as projection on db.orderItems;
}
