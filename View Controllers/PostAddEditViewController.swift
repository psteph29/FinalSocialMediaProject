//
//  PostAddEditViewController.swift
//  techSocialMediaApp
//
//  Created by Alexis Wright on 7/7/23.
//

import UIKit

class PostAddEditViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var post: Post?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = "Testing"
        bodyTextView.text = "What would you like to write?"
        
        if let post = post {
            titleTextField.text = post.title
            bodyTextView.text = post.body
            title = "Edit Post"
        } else {
            title = "New Post"
        }
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    private func createPost(title: String, body: String) {
        Task {
            do {
                let apiController = APIController()
                let _ = try await apiController.createPost(title: title, body: body)
                performSegue(withIdentifier: "postUnwind", sender: self)
            }
            catch {
                print(error)
            }
        }
    }
    
    private func editPost(title: String, body: String, postid: Int) {
        Task {
            do {
                let apiController = APIController()
                let _ = try await apiController.editPost(title: title, body: body, postid: postid)
                performSegue(withIdentifier: "editUnwind", sender: self)
            }
            catch {
                print(error)
            }
        }
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        if let title = titleTextField.text, let body = bodyTextView.text {
            if let postid = post?.postid {
                editPost(title: title, body: body, postid: postid)
            } else {
                createPost(title: title, body: body)
            }
        }
        
    }
    
    private func deletePost(postId: Int) {
        Task {
            do {
                let apiController = APIController()
                let _ = try await apiController.deletePosts(postId: postId)
                performSegue(withIdentifier: "editUnwind", sender: self)
            }
            catch {
                print(error)
            }
        }
    }

  
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        if let postId = post?.postid {
            deletePost(postId: postId)
        }
    }
    

}
