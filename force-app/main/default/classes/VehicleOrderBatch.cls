global class VehicleOrderBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Status__c, Vehicle__c,
                   Vehicle__r.Stock_Quantity__c
            FROM Vehicle_Order__c
            WHERE Status__c = 'Pending'
        ]);
    }

    global void execute(Database.BatchableContext bc, List<Vehicle_Order__c> scope) {
        List<Vehicle_Order__c> ordersToUpdate = new List<Vehicle_Order__c>();
        Map<Id, Vehicle__c> vehiclesToUpdate = new Map<Id, Vehicle__c>();

        for (Vehicle_Order__c order : scope) {
            Vehicle__c vehicle = vehiclesToUpdate.containsKey(order.Vehicle__c)
                ? vehiclesToUpdate.get(order.Vehicle__c)
                : new Vehicle__c(
                    Id = order.Vehicle__c,
                    Stock_Quantity__c = order.Vehicle__r.Stock_Quantity__c
                );

            if (vehicle.Stock_Quantity__c != null &&
                vehicle.Stock_Quantity__c > 0) {

                vehicle.Stock_Quantity__c--;
                order.Status__c = 'Confirmed';

                vehiclesToUpdate.put(vehicle.Id, vehicle);
                ordersToUpdate.add(order);
            }
        }

        if (!vehiclesToUpdate.isEmpty()) {
            update vehiclesToUpdate.values();
        }

        if (!ordersToUpdate.isEmpty()) {
            update ordersToUpdate;
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Vehicle order batch job completed.');
    }
}