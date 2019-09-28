//
//  ReportViewController.swift
//  eKar
//
//  Created by Arya Menon K on 9/27/19.
//  Copyright © 2019 Arya. All rights reserved.
//

import UIKit

class ReportViewController: BaseViewController {
    
    @IBOutlet weak var commentsTextView: UITextView?
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var nextButton: eKarButton?
    
    var reportImageModel = [ReportImageModel]() {
        didSet {
            // to reflect the selected images
            collectionView?.reloadData()
            shouldEnableNextButton()
        }
    }
    
    var comment : String = "" {
        didSet {
            // enable button only if comments are added
            shouldEnableNextButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        populateInitialValues()
        registerNotification()
    }
    
    override func dismissKeyboard() {
        super.dismissKeyboard()
        commentsTextView?.resignFirstResponder()
    }
}

extension ReportViewController {
    
    @IBAction func nextButtonAction() {
        //display success pop up
        let alertWarning = UIAlertController(title: "Success", message: "Report submitted successfully.", preferredStyle: .alert)
        alertWarning.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertWarning, animated: false, completion: nil)
    }
}

private extension ReportViewController {
    
    func shouldEnableNextButton() {
        // validation : enable next button only if atleast one image and a comment is added by the user
        let hasSelectedMinOneImage = (reportImageModel.first{$0.image != nil}) != nil
        nextButton?.isEnabled = !comment.isEmpty && hasSelectedMinOneImage
    }
    
    func populateInitialValues() {
        // set the sides to the datasource
        Side.allCases.forEach { (side) in
            reportImageModel.append(ReportImageModel(image: nil, side: side))
        }
    }
    
    func configureView() {
        // initially disable button
        nextButton?.isEnabled = false

        // beautify
        commentsTextView?.setBorder()
        nextButton?.setCornerRaduis()
        
        // register nib
        registerNib()
        
        // set collection view layout
        collectionView?.setCollectionViewLayout(makeLayout(), animated: true)
    }
    
    func registerNib() {
        collectionView?.register(CarPictureCollectionViewCell.nib, forCellWithReuseIdentifier: CarPictureCollectionViewCell.identifier)
    }

    
    func handlePictureTap(for value: ReportImageModel) {
        // clear option to be displayed only if a image is already selected for the side.
        displayActionSheet(for: value,shouldShowClearOption: value.image != nil)
    }
    
    func displayActionSheet(for value: ReportImageModel,shouldShowClearOption: Bool) {
       // get index of the side in datasource
        guard let index = reportImageModel.firstIndex(of: value) else { return }

        ImagePickerManager(type: shouldShowClearOption ? .clearImage : .default).pickImage(self) { [weak self] image in
            // save selected image
            self?.reportImageModel[index].image = image
        
        }.clearImageCallback = { [weak self]  in
            //clear image
            self?.reportImageModel[index].image = nil
        }
    }
}

extension ReportViewController: UICollectionViewDelegate,UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Side.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarPictureCollectionViewCell.identifier, for: indexPath) as? CarPictureCollectionViewCell else { return UICollectionViewCell() }
        cell.reportImageModel = reportImageModel[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CarPictureCollectionViewCell else { return }
        handlePictureTap(for: cell.reportImageModel)
    }
}

extension ReportViewController: UICollectionViewDelegateFlowLayout {
    // set collection view layout to show 2 cells per row, having same width and height
    func makeLayout() -> UICollectionViewLayout {
        let contentInsets: CGFloat = 5
        let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5)))
            item.contentInsets = NSDirectionalEdgeInsets(top: contentInsets, leading: contentInsets, bottom: contentInsets, trailing: contentInsets)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),  heightDimension: .fractionalHeight(0.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 1 , leading: 1, bottom: 1, trailing: 1)
            
            return section
        }
        return layout
    }
}

extension ReportViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // save value
        comment = textView.text
    }
}


extension ReportViewController {
    
    func registerNotification() {
        let notificationCenter = NotificationCenter.default
        
        // register keyboard notifications
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // move keyboard to show commnets text view while editing
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back after editing
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
