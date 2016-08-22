import UIKit

class TableViewDataSource<Delegate: DataSourceDelegate, DataProv: DataProvider, Cell: UITableViewCell>: NSObject, UITableViewDataSource where Delegate.Object == DataProv.Object, Cell: ConfigurableCell, Cell.DataSource == DataProv.Object {
    
    
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
    
    func processUpdates(updates: [DataProviderUpdate]?) {
        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .insert(let indexPath):
                tableView.insertRows(at: [indexPath], with: .fade)
            case .update(let indexPath, let object):
                guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { break }
                cell.configureForObject(object: object as! Delegate.Object, at: indexPath)
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
    internal let dataProvider: DataProv
    private weak var delegate: Delegate!
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let num = delegate?.numberOfSections() {
            return num
        } else {
            return dataProvider.numberOfSections()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = delegate?.numberOfRows(inSection: section) {
            return num
        } else {
            return dataProvider.numberOfItems(inSection: section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = delegate.cell(forRowAt: indexPath)
        if let theCell = cell as? Cell {
            let object = dataProvider.object(at: indexPath)
            theCell.configureForObject(object: object, at: indexPath)
            return theCell
        } else if let theCell = cell {
            return theCell
        } else {
            let object = dataProvider.object(at: indexPath)
            let identifier = delegate.cellIdentifier(for: object)
            let dqcell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
            dqcell.configureForObject(object: object, at: indexPath)
            return dqcell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let delegate = delegate else { return false }
        return delegate.canEditRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        delegate?.commit(editingStyle, for: indexPath)
    }
}

