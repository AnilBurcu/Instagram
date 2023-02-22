//
//  FormTableViewCell.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.02.2023.
//

import UIKit

protocol FormTableViewCellDelegate {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel)
}

class FormTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "FormTableViewCell" // EditProfile'da tableview'de kullanacağımız için static tanımladık
    
    private var model:EditProfileFormModel?
    
    public var delegate: FormTableViewCellDelegate?
    
    private let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let field:UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        return field
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(field)
        field.delegate = self
        selectionStyle = .none // seçim görüntüsünü engellemek için
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: EditProfileFormModel){
        self.model = model
        formLabel.text = model.label
        field.placeholder = model.placeholder
        field.text = model.value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        formLabel.text = nil
        field.placeholder = nil
        field.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Assign frames
        formLabel.frame = CGRect(x: 0,
                                 y: 0,
                                 width: contentView.width/3,
                                 height: contentView.height)
        field.frame = CGRect(x: formLabel.right + 5,
                                 y: 0,
                             width: contentView.width-10-formLabel.width,
                                 height: contentView.height)
    }
    
    // MARK: Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else {
            return true
        }
        delegate?.formTableViewCell(self, didUpdateField: model)
        textField.resignFirstResponder() // kullanıcı return'e bastığında klavyeyi kapatır(klavyedeki bitti tuşu)
   
        return true
    }

}
