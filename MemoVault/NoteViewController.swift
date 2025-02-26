//
//  NoteViewController.swift
//  MemoVault
//
//  Created by Matteo Orru on 22/05/24.
//



import UIKit

protocol NoteViewControllerDelegate: AnyObject {
    func didSaveNote(_ note: Note, at index: Int?)
}

class NoteViewController: UIViewController {
    var note: Note?
    var noteIndex: Int?
    weak var delegate: NoteViewControllerDelegate?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.allowsEditingTextAttributes = true
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(showFormatToolbar), for: .touchUpInside)
        button.tintColor = UIColor(red: 236/255, green: 180/255, blue: 130/255, alpha: 1.0)
        return button
    }()
    
    private lazy var formatToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.items = [
            UIBarButtonItem(image: UIImage(systemName: "textformat.size"), style: .plain, target: self, action: #selector(showStyleOptions)),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(image: UIImage(systemName: "bold"), style: .plain, target: self, action: #selector(toggleBold)),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(image: UIImage(systemName: "italic"), style: .plain, target: self, action: #selector(toggleItalic)),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(image: UIImage(systemName: "underline"), style: .plain, target: self, action: #selector(toggleUnderlineStyle)),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(image: UIImage(systemName: "strikethrough"), style: .plain, target: self, action: #selector(toggleStrikethrough)),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(insertBulletList)),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(hideFormatToolbar))
        ]
        
        toolbar.tintColor = UIColor(red: 236/255, green: 180/255, blue: 130/255, alpha: 1.0)
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .systemBackground
        
        if let note = note {
            // Convert attributed string from Data if needed
            if let attributedText = try? NSAttributedString(
                data: note.text.data(using: .utf8) ?? Data(),
                options: [.documentType: NSAttributedString.DocumentType.rtf],
                documentAttributes: nil) {
                textView.attributedText = attributedText
            } else {
                textView.text = note.text
            }
        }
    }
    
    func setupUI() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        textView.inputAccessoryView = formatToolbar
        textView.becomeFirstResponder()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        doneButton.tintColor = UIColor(red: 236/255, green: 180/255, blue: 130/255, alpha: 1.0)
        navigationItem.rightBarButtonItem = doneButton
        
        
        let backButtonIcon = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
        backButtonIcon.tintColor = UIColor(red: 236/255, green: 180/255, blue: 130/255, alpha: 1.0)
        
        navigationItem.leftBarButtonItems = [backButtonIcon]
    }
    
    @objc private func showStyleOptions() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let styles = [
            ("Title", 24.0),
            ("Heading", 20.0),
            ("Subheading", 18.0),
            ("Body", 16.0)
        ]
        
        for (title, size) in styles {
            alert.addAction(UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.applyFontSize(size)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func applyFontSize(_ size: CGFloat) {
        let selectedRange = textView.selectedRange
        guard selectedRange.length > 0 else { return }
        
        let font = UIFont.systemFont(ofSize: size)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        
        let mutableAttributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        mutableAttributedText.addAttributes(attributes, range: selectedRange)
        textView.attributedText = mutableAttributedText
    }
    
    @objc private func toggleBold() {
        toggleAttribute(.bold)
    }
    
    @objc private func toggleItalic() {
        toggleAttribute(.italic)
    }
    
    @objc private func toggleUnderlineStyle() {
        toggleAttribute(.underline)
    }
    
    @objc private func toggleStrikethrough() {
        toggleAttribute(.strikethrough)
    }
    
    private func toggleAttribute(_ style: TextStyle) {
        let selectedRange = textView.selectedRange
        guard selectedRange.length > 0 else { return }
        
        let mutableAttributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        let existingAttributes = mutableAttributedText.attributes(at: selectedRange.location, effectiveRange: nil)
        
        var newAttributes: [NSAttributedString.Key: Any] = [:]
        switch style {
        case .bold:
            let traits = existingAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
            if traits.fontDescriptor.symbolicTraits.contains(.traitBold) {
                newAttributes[.font] = UIFont.systemFont(ofSize: textView.font?.pointSize ?? 16)
            } else {
                newAttributes[.font] = UIFont.boldSystemFont(ofSize: textView.font?.pointSize ?? 16)
            }
        case .italic:
            let traits = existingAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
            if traits.fontDescriptor.symbolicTraits.contains(.traitItalic) {
                newAttributes[.font] = UIFont.systemFont(ofSize: textView.font?.pointSize ?? 16)
            } else {
                newAttributes[.font] = UIFont.italicSystemFont(ofSize: textView.font?.pointSize ?? 16)
            }
        case .underline:
            if existingAttributes[.underlineStyle] != nil {
                mutableAttributedText.removeAttribute(.underlineStyle, range: selectedRange)
            } else {
                newAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            }
        case .strikethrough:
            if existingAttributes[.strikethroughStyle] != nil {
                mutableAttributedText.removeAttribute(.strikethroughStyle, range: selectedRange)
            } else {
                newAttributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            }
        }
        
        if !newAttributes.isEmpty {
            mutableAttributedText.addAttributes(newAttributes, range: selectedRange)
        }
        textView.attributedText = mutableAttributedText
    }
    
    @objc private func insertBulletList() {
        guard let selectedRange = textView.selectedTextRange else { return }
        
        // Get the current line
        let beginning = textView.beginningOfDocument
        guard let start = textView.tokenizer.position(from: selectedRange.start, toBoundary: .line, inDirection: UITextDirection(rawValue: 1)), // forward
              let end = textView.tokenizer.position(from: selectedRange.end, toBoundary: .line, inDirection: UITextDirection(rawValue: 2)), // backward
              let lineRange = textView.textRange(from: start, to: end) else { return }
        
        let line = textView.text(in: lineRange) ?? ""
        
        if !line.hasPrefix("• ") {
            textView.replace(lineRange, withText: "• " + line)
        }
    }
    
    @objc private func hideFormatToolbar() {
        let expandButtonContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        expandButton.frame = CGRect(x: view.frame.width - 50, y: 0, width: 44, height: 44)
        expandButtonContainer.addSubview(expandButton)
        
        textView.inputAccessoryView = expandButtonContainer
        textView.reloadInputViews()
    }
    
    @objc private func showFormatToolbar() {
        textView.inputAccessoryView = formatToolbar
        textView.reloadInputViews()
    }
    
    @objc func done() {
        guard let noteText = textView.attributedText?.string.trimmingCharacters(in: .whitespacesAndNewlines),
              !noteText.isEmpty else {
            return
        }
        
        // Convert attributed text to Data for storage
        let note = Note(text: noteText, date: Date())
        delegate?.didSaveNote(note, at: noteIndex)
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
}

private enum TextStyle {
    case bold
    case italic
    case underline
    case strikethrough
}
