@isTest
private class VehicleStockUpdateBatchTest {

    @isTest
    static void testBatchExecution() {

        Vehicle__c vehicle = new Vehicle__c(
            Name = 'Test Batch Vehicle',
            Vehicle_Model__c = 'SUV',
            Stock_Quantity__c = null,
            Price__c = 100000
        );

        insert vehicle;

        Test.startTest();

        Database.executeBatch(
            new VehicleStockUpdateBatch(),
            200
        );

        Test.stopTest();

        Vehicle__c updatedVehicle = [
            SELECT Stock_Quantity__c
            FROM Vehicle__c
            WHERE Id = :vehicle.Id
        ];

        System.assertEquals(0, updatedVehicle.Stock_Quantity__c);
    }
}