import UIKit

class TableViewDataSource<Delegate: DataSourceDelegate, DataProv: DataProvider, Cell: UITableViewCell where Delegate.Object == DataProv.Object, Cell: ConfigurableCell, Cell.DataSource == DataProv.Object>: NSObject, UITableViewDataSource {
    
    
    required init(tableView: UITableView, dataProvider: DataProv, delegate: Delegate) {
        self.tableView = tableView
        self.dataProvider = dataProvider
        self.delegate = delegate
        super.init()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    var selectedObject: DataProv.Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return dataProvider.object(at: indexPath)
    }
    
    func processUpdates(updates: [DataProviderUpdate<DataProv.Object>]?) {
        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .insert(let indexPath):
                tableView.insertRows(at: [indexPath], with: .fade)
            case .update(let indexPath, let object):
                guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { break }
                cell.configureForObject(object: object)
            case .move(let indexPath, let newIndexPath):
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            case .delete(let indexPath):
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        tableView.endUpdates()
    }
    
    // MARK: Private
    
    private let tableView: UITableView
    private let dataProvider: DataProv
    private weak var delegate: Delegate!
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItems(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = dataProvider.object(at: indexPath)
        let identifier = delegate.cellIdentifier(for: object)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else { fatalError("Unexpected cell type at \(indexPath)") }
        cell.configureForObject(object: object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = dataProvider.object(at: indexPath)
            object.managedObjectContext!.performAndWait {
                object.managedObjectContext!.delete(object)
            }
        }
    }
}