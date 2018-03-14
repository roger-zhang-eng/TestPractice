########### observe Keyboard display frame size update ####
Solution #1:
NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: .UIKeyboardWillChangeFrame, object: nil)

fileprivate var bottomContainerViewBottomConstraint: Constraint?
fileprivate var bottomContainerViewBottomConstraintOffset: CGFloat = 0.0

bottomContainerView.snp.makeConstraints { (make) in
			self.bottomContainerViewBottomConstraint = make.bottom.equalTo(self.view.snp.bottom).constraint
			make.left.right.equalTo(self.view)
			make.height.equalTo(97.0)
		}

@objc fileprivate func keyboardWillChangeFrame(_ notification: Notification) {
		guard
			self.nameTextField.isEditing,
			let userInfo = notification.userInfo,
			let keyboardBeginFrameValue = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue,
			let keyboardEndFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
			let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
			else {
				return
		}
		
		let keyboardBeginFrame = keyboardBeginFrameValue.cgRectValue
		let keyboardEndFrame = keyboardEndFrameValue.cgRectValue
		
		self.bottomContainerViewBottomConstraintOffset = (keyboardBeginFrame.minY - keyboardEndFrame.minY) + self.bottomContainerViewBottomConstraintOffset
		
		self.bottomContainerViewBottomConstraint?.update(offset: -self.bottomContainerViewBottomConstraintOffset)
		self.bottomContainerView.setNeedsUpdateConstraints()
		
		UIView.animate(withDuration: animationDuration, animations: {
			self.view.layoutIfNeeded()
		})
		
	}

Solution #2:
NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		
@objc func keyBoardShow(_ notification: Notification) {
	let height: CGFloat = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
			//print("The keyboard show height: \(height?.size.height)")
			delegate?.keyboardDisplay(height!)

}

		NotificationCenter.default.addObserver(self, selector: #selector(keyBoardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

@objc func keyBoardHide() {
	delegate?.keyboardDisappear()
}

########### observe UITextField value update ####

NotificationCenter.default.addObserver(self, selector: #selector(nameDidChange), name: .UITextFieldTextDidChange, object: self.nameTextField)

fileprivate var name: String?

internal func nameDidChange(_ notification: Notification) {
		name = nameTextField.text
	}

########## UISearchBar delegate UISearchBarDelegate ######
var shopSearchBar:UISearchBar

self.shopSearchBar.delegate = self
self.shopSearchBar.returnKeyType = .done
//Hide cancel button
self.shopSearchBar.showsCancelButton = false
//Hide keyboard
self.shopSearchBar.endEditing(true)
self.shopSearchBar.resignFirstResponder()

if !self.shopSearchBar.showsCancelButton {
				self.shopSearchBar.placeholder = searchBarPlaceHolderText + searchBarPaddingSpace
			}

//Mark: - UISearchBarDelegate
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {. … }

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
if !self.shopSearchBar.showsCancelButton {
			//Hide keyboard, and resize shoplist tableView if it display
			self.shopSearchBar.resignFirstResponder()
		
		
		} else {
			if self.goButton != nil {
				self.goButtonClicked(self.goButton)
			}
		}
}


func showSearbarKeyboard() {
		Utilities.print("set keyboar with Go")
		self.shopSearchBar.returnKeyType = .go
		self.shopSearchBar.enablesReturnKeyAutomatically = true
		self.shopSearchBar.becomeFirstResponder()
}
	
func hideSearbarKeyboard() {
		Utilities.print("set keyboar with Done")
		if !self.shopSearchBar.showsCancelButton {
			self.shopSearchBar.returnKeyType = .done
		} else {
			self.shopSearchBar.returnKeyType = .go
		}
		
		self.shopSearchBar.endEditing(true)
		self.shopSearchBar.resignFirstResponder()
}