import UIKit

class ControllerView: UIView {

    let tableView: UITableView!
    
    override init(frame: CGRect) {
        self.tableView = UITableView(frame: frame)
        
        super.init(frame: frame)
        
        self.addSubview(self.tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.tableView.frame = self.bounds
    }
}
