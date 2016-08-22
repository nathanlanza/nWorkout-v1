import UIKit
import CoreData

class TVCWithTVDS<Source: DataProvider, Type: NSManagedObject, Cell: UITableViewCell>: TVCWithContext where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type {
    
    init(dataProvider: Source) {
        self.dataProvider = dataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName: String? , bundle: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }


    var dataSource: TableViewDataSource<TVCWithTVDS, Source, Cell>!
    var dataProvider: Source!
    
    internal func setupTableView() {
        tableView.register(Cell.self, forCellReuseIdentifier: cellIdentifierForRegistration(for: Cell.self))
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Theme.Colors.backgroundColor.color
    }
    
    //DataSourceDelegate
    //Has to be here to be overrideable
    func cellIdentifier(for object: Type) -> String {
        return "cell"
    }
    func cellIdentifierForRegistration(for cell: Cell.Type) -> String {
        return "cell"
    }
    func canEditRow(at: IndexPath) -> Bool {
        print("Implement \(#function)")
        return false
    }
    func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) {
        print("Implement \(#function)")
    }
    func cell(forRowAt indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func numberOfSections() -> Int? {
        return nil
    }
    func numberOfRows(inSection section: Int) -> Int? {
        return nil
    }
}

extension TVCWithTVDS: DataSourceDelegate {}

