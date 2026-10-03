@isTest
private class VehicleStockSchedulerTest {

    @isTest
    static void testSchedulerExecution() {

        Vehicle__c vehicle = new Vehicle__c(
            Name = 'Scheduler Test Vehicle',
            Vehicle_Model__c = 'SUV',
            Stock_Quantity__c = null,
            Price__c = 100000
        );

        insert vehicle;

        Test.startTest();

        String cronExp = '0 0 0 1 1 ? 2099';

        System.schedule(
            'Vehicle Stock Scheduler Test',
            cronExp,
            new VehicleStockScheduler()
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