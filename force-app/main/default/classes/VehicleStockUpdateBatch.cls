global class VehicleStockUpdateBatch
    implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Stock_Quantity__c FROM Vehicle__c'
        );
    }

    global void execute(
        Database.BatchableContext bc,
        List<Vehicle__c> vehicles
    ) {
        for (Vehicle__c vehicle : vehicles) {
            if (vehicle.Stock_Quantity__c == null) {
                vehicle.Stock_Quantity__c = 0;
            }
        }

        update vehicles;
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Vehicle Stock Update Batch Completed');
    }
}