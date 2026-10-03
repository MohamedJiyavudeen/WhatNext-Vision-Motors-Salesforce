@isTest
private class VehicleOrderBatchTest {

    @isTest
    static void testVehicleOrderBatch() {

        Vehicle__c vehicle = new Vehicle__c(
            Name = 'Test Vehicle',
            Vehicle_Model__c = 'SUV',
            Stock_Quantity__c = 2,
            Price__c = 100000
        );
        insert vehicle;

        Vehicle_Order__c order = new Vehicle_Order__c(
            Name = 'Test Order',
            Status__c = 'Pending',
            Vehicle__c = vehicle.Id
        );
        insert order;

        Test.startTest();
        Database.executeBatch(new VehicleOrderBatch(), 50);
        Test.stopTest();

        Vehicle_Order__c updatedOrder = [
            SELECT Status__c
            FROM Vehicle_Order__c
            WHERE Id = :order.Id
        ];

        System.assertEquals('Confirmed', updatedOrder.Status__c);
    }
}