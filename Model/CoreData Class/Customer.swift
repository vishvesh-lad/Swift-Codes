//
//  Customer.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

extension Customer{
    //Custom Init to Insert in Customer
    convenience init(inspection_contact_id: Int64?, contact_id: Int64?, contact_type_id: Int64?, buyer_seller_type: Int16?, inspection_id: Int64?, is_deleted: Int16?, is_signature_required: Int16?, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: CoreDataEntityIdentifier.Customer, in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.inspection_contact_id = inspection_contact_id ?? 0
        self.inspection_contact_app_id = CoreDataService.sharedInstance.getIncrementedId(idKeyName: "inspection_contact_app_id", entityName: CoreDataEntityIdentifier.Customer, context: context)
        self.contact_id = contact_id ?? 0
        self.contact_type_id = contact_type_id ?? 0
        self.inspection_id = inspection_id ?? 0
        self.is_deleted = is_deleted ?? 0
        self.buyer_seller_type = buyer_seller_type ?? 0
        self.is_signature_required = is_signature_required ?? 0
    }
    
    //Custom Init to Insert in Customer
    convenience init(objCustomerModel: CustomerModel, context: NSManagedObjectContext) {
        self.init(inspection_contact_id: Int64(objCustomerModel.inspection_contact_id ?? 0), contact_id: Int64(objCustomerModel.contact_id ?? 0), contact_type_id: Int64(objCustomerModel.contact_type_id ?? 0), buyer_seller_type: Int16(objCustomerModel.buyer_seller_type ?? 0), inspection_id: Int64(objCustomerModel.inspection_id ?? 0), is_deleted: Int16(objCustomerModel.is_deleted ?? 0),is_signature_required: Int16(objCustomerModel.is_signature_required ?? 0), context: context)
    }
    
    //Update Customer
    internal static func updateCustomer(objCustomer: Customer, objCustomerModel: CustomerModel){
        objCustomer.inspection_contact_id = Int64(objCustomerModel.inspection_contact_id ?? 0)
        objCustomer.contact_id = Int64(objCustomerModel.contact_id ?? 0)
        objCustomer.contact_type_id = Int64(objCustomerModel.contact_type_id ?? 0)
        objCustomer.inspection_id = Int64(objCustomerModel.inspection_id ?? 0)
        objCustomer.is_deleted = Int16(objCustomerModel.is_deleted ?? 0)
        objCustomer.buyer_seller_type = Int16(objCustomerModel.buyer_seller_type ?? 0)
        objCustomer.is_signature_required = Int16(objCustomerModel.is_signature_required ?? 0)
        CoreDataService.sharedInstance.saveContext()
    }
    
    //MARK:- Private Methods
    //Fetch Customer for inspection
    internal static func getCustomersObjectFor(inspectionId:Int64, in context:NSManagedObjectContext) -> [Customer]? {
        let fetchRequest : NSFetchRequest<Customer>  = self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "inspection_id == %i",
                                             inspectionId)
        //Sorting
        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "contact_id", ascending: true)
        fetchRequest.sortDescriptors = [idDescriptor]
        
        do {
            let result = try context.fetch(fetchRequest)
            if (result.count > 0) {
                return result
            }
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
        return nil
    }

    //Remove customer for inspectionId
    internal static func removeCustomerObjectsFor(inspectionId: Int64, in context:NSManagedObjectContext) {
        
        let fetchRequest : NSFetchRequest<Customer>  = self.fetchRequest()
        fetchRequest.predicate =  NSPredicate(format: "inspection_id == %i", inspectionId)
        
        do {
            let records:[Customer] = try context.fetch(fetchRequest)
            
            for object in records
            {
                context.delete(object)
                CoreDataService.sharedInstance.saveContext()
            }
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
    }
    
    //Remove old Customer records which are now removed from server
    internal static func removeOldCustomerOtherThan(inspectionId: Int?, arrNewCustomerRecordIds: [Int?]?, context: NSManagedObjectContext) {
        context.performAndWait {
            let predicate1 = NSPredicate(format: "inspection_id == %i", inspectionId ?? 0)
            let predicate2 = NSPredicate(format: "NOT inspection_contact_id IN %@",arrNewCustomerRecordIds ?? [])
            if let removeCustomerStatus = CoreDataService.sharedInstance.getRecordIfExistIn(predicate: NSCompoundPredicate(type: .and, subpredicates: [predicate1, predicate2]), entityName: CoreDataEntityIdentifier.Customer, context: context) {
                if removeCustomerStatus.isRecordExist{
                    if let arrCustomers = removeCustomerStatus.Records as? [Customer] {
                        for objCustomer in arrCustomers{
                            
                            //Remove Customer Signatute
                            Agreement_Signature.removeOldAgreementSignatureOtherThan(inspectionId: inspectionId, inspection_contact_id: Int(objCustomer.inspection_contact_id), arrNewAgreementSignatureRecordIds: [], context: context)
                            
                            //Remove Customer
                            context.delete(objCustomer)
                        }
                        CoreDataService.sharedInstance.saveContext()
                    }
                }
            }
        }
    }
    
    //Check Record exist than update or insert
    internal static func checkRecordExistAndUpdateOrInsert(arrCustomer: [CustomerModel], context: NSManagedObjectContext){
        context.performAndWait {
            //Insert or update Customer
            let predicate = NSPredicate(format: "inspection_contact_id IN %@", arrCustomer.map({ $0.inspection_contact_id }))
            
            if let customerStatus = CoreDataService.sharedInstance.getRecordIfExistIn(predicate: predicate, entityName: CoreDataEntityIdentifier.Customer, context: context){
                //Insert or update Customer
                for objCustomerModel in arrCustomer {
                    if let arrFoundedRecords = customerStatus.Records as? [Customer], let objCustomer = arrFoundedRecords.first(where: { Int($0.inspection_contact_id) == objCustomerModel.inspection_contact_id }){
                        //Update
                        Customer.updateCustomer(objCustomer: objCustomer, objCustomerModel: objCustomerModel)
                    }else{
                        //Insert
                        let _ = Customer(objCustomerModel: objCustomerModel, context: context)
                    }
                }
            }
            CoreDataService.sharedInstance.saveContext()
        }
    }
}
