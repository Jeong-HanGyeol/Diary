//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 정한결 on 2023/05/05.
//

import UIKit

protocol WriteDiaryViewDelegate: AnyObject {
  func didSelectReigster(diary: Diary)
}

class WriteDiaryViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!

    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    weak var delegate: WriteDiaryViewDelegate?
    
    override func viewDidLoad() {
      super.viewDidLoad()
      self.configureContentsTextView()
      self.configureDatePicker()
      self.configureInputField()
      self.confirmButton.isEnabled = false
    }
    
    private func configureContentsTextView() {
      let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
      self.contentsTextView.layer.borderColor = borderColor.cgColor
      self.contentsTextView.layer.borderWidth = 0.5
      self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    private func configureDatePicker() {
      self.datePicker.datePickerMode = .date
      self.datePicker.preferredDatePickerStyle = .wheels
      self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
      self.datePicker.locale = Locale(identifier: "ko-KR")
      self.dateTextField.inputView = self.datePicker
    }
    
    private func configureInputField() {
      self.contentsTextView.delegate = self
      self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
      self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        self.delegate?.didSelectReigster(diary: diary)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
      let formmater = DateFormatter()
      formmater.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
      formmater.locale = Locale(identifier: "ko_KR")
      self.diaryDate = datePicker.date
      self.dateTextField.text = formmater.string(from: datePicker.date)
      self.dateTextField.sendActions(for: .editingChanged)
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
      self.validateInputField()
    }

    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
      self.validateInputField()
    }
    
    // 빈화면을 누르면 키보드가 사라지는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
    }
    
    private func validateInputField() {
      self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    self.validateInputField()
  }
}
