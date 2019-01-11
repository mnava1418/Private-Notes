//
//  NoteDetailsViewController.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 26/04/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailsViewController: UIViewController, NSFetchedResultsControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var noteContent: UITextView!
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var fetchedResultsController: NSFetchedResultsController<Note>? = nil
    var selectedFolder:Folder? = nil
    var action = ""
    var currentNote: Note? = nil
    var originalAttributes: [NSAttributedStringKey: Any] = [:]
    var isAddingImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.originalAttributes = self.noteContent.attributedText.attributes(at: 0, effectiveRange: nil)
        
        if let note = currentNote {
            if note.binaryContent == nil {
                let attributedText = NSAttributedString(string: note.content!, attributes: self.originalAttributes )
                self.noteContent.attributedText = attributedText
            } else {
                self.noteContent.attributedText = note.binaryContent
            }
        }
        
        if(self.action == "addNote" && self.selectedFolder != nil) {
            let attributedText = NSAttributedString(string: "", attributes: self.originalAttributes )
            self.noteContent.attributedText = attributedText
        } else {
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(confirmDeleteNote))
            let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
            
            self.navigationItem.setRightBarButtonItems([shareButton,deleteButton], animated: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerKeyBoardNotifications()
        if( (self.action == "addNote" && self.selectedFolder != nil ) || self.isAddingImage) {
            noteContent.becomeFirstResponder()
            self.isAddingImage = false
        } else {
            noteContent.resignFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.doneEditing()
        self.deregisterKeyBoardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        let imageButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addImage))
        
        self.navigationItem.setRightBarButtonItems([doneButton, imageButton], animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(confirmDeleteNote))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        
        self.navigationItem.setRightBarButtonItems([shareButton,deleteButton], animated: true)
    }
    
    func addNote(content: NSAttributedString) {
        guard let context = self.managedObjectContext else {
            return
        }
        
        if self.selectedFolder == nil {
                return
        }
        
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        note.folder = self.selectedFolder
        note.binaryContent = content
        note.date = Date()
        
        if content.string.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.locale = .current
            note.content = dateFormatter.string(from: note.date!)
        } else {
            note.content = content.string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        do {
            try context.save()
        } catch {}
    }
    
    func updateNote(content: NSAttributedString) {
        guard let context = self.managedObjectContext else {
            return
        }
        
        if let note = self.currentNote {
            note.binaryContent = content
            note.date = Date()
            
            if content.string.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                dateFormatter.locale = .current
                note.content = dateFormatter.string(from: note.date!)
            } else {
                note.content = content.string.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            do {
                try context.save()
            } catch {}
        }
    }
    
    @objc func confirmDeleteNote() {
        if self.currentNote != nil {
            let confirmScreen = UIAlertController(title: "Are you sure you want to delete the note?", message: "", preferredStyle: .actionSheet)
            let deleteAction:UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
                OperationQueue.main.addOperation {
                    self.deleteNote()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            confirmScreen.addAction(deleteAction)
            confirmScreen.addAction(cancelAction)
            
            self.present(confirmScreen, animated: true)
        }
    }
    
    func deleteNote() {
        guard let context = self.managedObjectContext else {
            return
        }
        
        context.delete(self.currentNote!)
        
        do {
            try context.save()
        } catch {}
        
        self.action = ""
        self.currentNote = nil
    }
    
    @objc func doneEditing() {
        noteContent.resignFirstResponder()
        if let content = noteContent {
            if(content.attributedText.string.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
                return
            }
            
            if(self.action == "addNote" && self.selectedFolder != nil) {
                self.addNote( content: content.attributedText)
                let indexPath: IndexPath = IndexPath(row: 0, section: 0)
                
                do {
                    try self.fetchedResultsController?.performFetch()
                } catch {}
                
                self.currentNote = self.fetchedResultsController?.object(at: indexPath)
                self.action = "updateNote"
            } else {
                if(self.action == "updateNote") {
                    self.updateNote(content: content.attributedText)
                }
            }
        }
    }
    
    @objc func addImage() {
        var sourceType: UIImagePickerControllerSourceType = .camera
        let selectInput = UIAlertController(title: "Select image", message: "From one of the options", preferredStyle: .actionSheet)
        
        self.isAddingImage = true
        self.noteContent.resignFirstResponder()
        
        let cameraAction:UIAlertAction = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
            OperationQueue.main.addOperation {
                sourceType = .camera
                self.selectImage(sourceType: sourceType)
            }
        }
        
        let photoLibraryAction:UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) { (action: UIAlertAction) in
            OperationQueue.main.addOperation {
                sourceType = .photoLibrary
                self.selectImage(sourceType: sourceType)
            }
        }
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
            OperationQueue.main.addOperation {
                self.isAddingImage = false
                self.noteContent.becomeFirstResponder()
            }
        }
        
        selectInput.addAction(cameraAction)
        selectInput.addAction(photoLibraryAction)
        selectInput.addAction(cancelAction)
        
        self.present(selectInput, animated: true)
    }
    
    func selectImage(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //Get Image to attach
            let finalImage = self.resizeImage(image: image)
            let textAttachment = NSTextAttachment()
            textAttachment.image = finalImage
            
            //Copy existing info
            let attributedText = NSMutableAttributedString(attributedString: self.noteContent.attributedText)
            
            //Prepare attachemnts
            let attributedImage = NSAttributedString(attachment: textAttachment)
            attributedText.append(NSAttributedString(string: "\n\n", attributes: self.originalAttributes))
            attributedText.append(attributedImage)
            attributedText.append(NSAttributedString(string: "\n\n", attributes: self.originalAttributes))
            
            self.noteContent.attributedText = attributedText
        }
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        
        let currentSize = image.size
        let textViewSize = self.noteContent.frame.size
        
        let widthRatio = (textViewSize.width * 0.75) / currentSize.width
        let heightRatio = (textViewSize.height * 0.75) / currentSize.height
        
        var newSize: CGSize
        
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: currentSize.width * heightRatio, height: currentSize.height * heightRatio)
        } else {
            newSize = CGSize(width: currentSize.width * widthRatio,  height: currentSize.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @objc func shareNote() {
        if let currentText = self.noteContent.attributedText {
            if currentText.string.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return
            }
            
            let contentToShare:[String] = [currentText.string]
            let shareVC = UIActivityViewController(activityItems: contentToShare, applicationActivities: nil)
            self.present(shareVC, animated: true)
        }
    }
    
    @objc func willResignActive() {
        self.doneEditing()
    }
    
    func registerKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterKeyBoardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        
        let keyboardHeight = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        
        var aRect: CGRect = self.noteContent.frame
        aRect.size.height -= keyboardHeight!
        self.noteContent.frame = aRect
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        var info = notification.userInfo!
        
        let keyboardHeight = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        
        var aRect: CGRect = self.noteContent.frame
        aRect.size.height += keyboardHeight!
        self.noteContent.frame = aRect
    }
}
