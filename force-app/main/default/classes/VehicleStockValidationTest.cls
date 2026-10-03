@isTest
private class VehicleStockValidationTest {

    @isTest
    static void testMissingVehicle() {
        Vehicle_Order__c ord = new Vehicle_Order__c(
            Status__c = 'Pending'
        );

        try {
            insert ord;
            System.assert(false, 'Expected validation error');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Please select a vehicle.')
            );
        }
    }

    @isTest
    static void testOutOfStock() {

        Vehicle__c vehicle = new Vehicle__c(
            Name = 'Test Vehicle',
            Vehicle_Model__c = 'SUV',
            Stock_Quantity__c = 0,
            Price__c = 100000
        );
        insert vehicle;

        Vehicle_Order__c ord = new Vehicle_Order__c(
            Vehicle__c = vehicle.Id,
            Status__c = 'Pending'
        );

        try {
            insert ord;
            System.assert(false, 'Expected out of stock error');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Vehicle is out of stock.')
            );
        }
    }
}