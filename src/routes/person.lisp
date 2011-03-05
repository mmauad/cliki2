;;;; auth.lisp

(in-package #:cliki2)

(restas:define-route view-person ("person/:name")
  (check-person name))
    
(restas:define-route edit-person ("person/edit/:name"
                                  :requirement 'sign-in-p)
  (make-instance 'edit-person-page
                 :person (check-owner-person name)))

(restas:define-route save-person ("person/edit/:name"
                                  :method :post
                                  :requirement (check-edit-command "save"))
  (let ((person (check-owner-person name)))
    (setf (user-info person)
          (hunchentoot:post-parameter "content"))
    (restas:redirect 'view-person :name name)))

(restas:define-route preview-person ("person/edit/:name"
                                     :method :post
                                     :requirement (check-edit-command "preview"))
  (let ((person (check-owner-person name)))
    (make-instance 'preview-person-page
                   :person person
                   :info (hunchentoot:post-parameter "content"))))

(restas:define-route cancel-edit-person ("person/edit/:name"
                                          :method :post
                                          :requirement (check-edit-command "cancel"))
  (check-owner-person name)
  (restas:redirect 'view-person
                   :name name))
