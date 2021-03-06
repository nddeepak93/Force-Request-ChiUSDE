require 'spec_helper'
require 'rails_helper'

describe StudentRequestsController, :type => :controller do
  describe "MultiUpdate" do
    it  'should issue a flash warning when attempting to update a withdrawn request' do
      student_request = FactoryGirl.create(:student_request)
      student_request.state = StudentRequest::WITHDRAWN_STATE
     # StudentRequest.should_receive(:find).and_return([student_request])

      put :multiupdate, :request_ids => [student_request.id]

      expect(flash[:warning]).to eq("Nothing has been selected for Update")
    end


    it 'should update the student_request' do

      student_request = FactoryGirl.create(:student_request)
      #StudentRequest.should_receive(:find).with("1").and_return(student_request)


      put :multiupdate,  :request_ids => ["1"], :multi_state_sel => StudentRequest::WITHDRAWN_STATE

  expect(student_request.state).to eq(StudentRequest::WITHDRAWN_STATE)
      # assigns(:student_request) should eq(StudentRequest::WITHDRAWN_STATE)

    end
  end

  describe "Priority" do
    context 'on properly formatted create request' do
      it 'creates a student request' do

       #Given
       limit = FactoryGirl.create(:limit)
       student = FactoryGirl.create(:student)
       student_request = FactoryGirl.create(:student_request)
       Limit.should_receive(:where).once.and_return([limit])
       Student.should_receive(:where).once.and_return([student])
       #StudentMailer.should_receive(:confirm_force_request).and_return( double("Mailer", :deliver => true))


       #When
       post :create, :student_request => {:name => student_request.name,
                                          :uin => student_request.uin,
                                          :major => student_request.major,
                                          :classification => student_request.classification,
                                          :email => student_request.email,
                                          :request_semester => student_request.request_semester,
                                          :course_id => student_request.course_id,
                                          :priority => student_request.priority,
                                          :phone => student_request.phone,
                                          :section_id => 505
       }

       #Then
       expect(student_request.priority).to eq(StudentRequest::HIGH_PRIORITY)
       #expect(flash[:notice]).to eq("Student Request was successfully created.")
       #assert_response :redirect, :action => 'students_show_path'

      end
    end
    end

  describe "Create Student Request: " do
    context 'on a a student request that already exists' do
          it 'should display a flash warning and navigate to the :new' do
            #Given
            limit = FactoryGirl.create(:limit)
            student = FactoryGirl.create(:student)
            Student.should_receive(:where).once.and_return([student])
            student_request = FactoryGirl.create(:student_request)
            
            #StudentRequest.should_receive(:exists?).with(:uin => student_request.uin, :course_id => student_request.course_id, :section_id => student_request.section_id).once.and_return(true)
            #StudentRequest.should_receive(:exists?).once.and_return(true)
            Limit.should_receive(:where).once.and_return([limit])
            #StudentRequest.should_receive(:find).and_return(nil)
            Major.should_receive(:pluck).with(:major_id).once.and_return("Computer Science")
            @request.session['uin'] = student_request.uin
            #When
            post :create, :student_request => {:name => student_request.name,
                                               :uin => student_request.uin,
                                               :major => student_request.major,
                                               :classification => student_request.classification,
                                               :email => student_request.email,
                                               :request_semester => student_request.request_semester,
                                               :course_id => student_request.course_id,
                                               :phone => student_request.phone,
                                               :section_id => 505,
                                               :priority => student_request.priority
                                                }

          #THEN
          expect(flash[:warning]).to eq("You have already submitted a force request for CSCE" + student_request.course_id.to_s + "-505")

          assigns(:classificationList).should eq(StudentRequest::CLASSIFICATION_LIST)
          assigns(:YearSemester).should eq(StudentRequest::YEAR_SEMESTER)
          assigns(:requestSemester).should eq(StudentRequest::REQUEST_SEMESTER)
          assigns(:majorList).should eq("Computer Science")
          assert_template 'new'
        end
    end

    context 'on properly formatted create request' do
      it 'creates a student request' do

        #Given
        limit = FactoryGirl.create(:limit)
        student = FactoryGirl.create(:student)
        student_request = FactoryGirl.create(:student_request)
        Limit.should_receive(:where).once.and_return([limit])
        
        Student.should_receive(:where).once.and_return([student])
        #StudentRequest.should_receive(:where).once.and_return([student_request])
        #StudentMailer.should_receive(:confirm_force_request).once.and_return( double("Mailer", :deliver => true) );
        @request.session['uin'] = student_request.uin
        #When
        post :create, :student_request => {:name => student_request.name,
                                           :uin => student_request.uin,
                                           :major => student_request.major,
                                           :classification => student_request.classification,
                                           :email => student_request.email,
                                           :request_semester => student_request.request_semester,
                                           :course_id => student_request.course_id,
                                           :priority =>student_request.priority,
                                           :phone => student_request.phone,
                                           :section_id => 505
        }

        #Then"Student Request was successfully created."
        expect(flash[:notice]).to eq(nil)
        #assert_response :redirect, :action => 'students_show_path'

      end
    end

    # context 'limit on the number of force request' do
    #   it 'limits the number of request raised by a student' do
        
    #     #Then
    #     expect(flash[:notice]).to eq("Student Request was successfully created.")
    #     assert_response :redirect, :action => 'students_show_path'
        
    #   end

        
    # end
      

    context 'on mal formatted create request' do
      it 'attempts to create a new a New Force Request' do

        #Given
        limit = FactoryGirl.create(:limit)
        student = FactoryGirl.create(:student)
        student_request = FactoryGirl.create(:student_request)
        Limit.should_receive(:where).once.and_return([limit])
        Student.should_receive(:where).once.and_return([student])
        #StudentRequest.should_receive(:where).once.and_return([student_request])

        #@request.session['uin'] = student_request.uin
        #When
        #post :create, :student_request => {:name => student_request.name}
        post :create, :student_request => {:uin => student_request.uin, :priority => student_request.priority}

        #Then
        expect(flash[:warning]).to eq("Major can't be blank, Classification can't be blank, Request semester can't be blank, Request semester  is not a valid request semester, Course can't be blank, Course is invalid")
        assert_template 'new'
      end
    end
  end
  describe "Update student request: " do
    context 'on a a student request that already exists' do
          it 'should update the graduation semester' do
                  #Given
            student_request = FactoryGirl.create(:student_request)
            StudentRequest.should_receive(:find).with("14").and_return(student_request)
      
            put :update_request, :student_request => {:request_id => 14 ,:priority =>student_request.priority, :expected_graduation => "2021 FALL"}
      
            # expect(flash[:notice]).to eq("Student Request was successfully created.")
            expect(student_request.expected_graduation).to eq("2021 FALL")

        end
      end
    end
    
  describe "set Limit on prioritized request: " do
    context 'on a a student who has raised maximum allowed force request with high priority' do
          it 'should give error' do
                  #Given
                  
            # put :createlimits, :session => {:classification => "G7"}
            limits ={:classification => 'G7', :very_high => '0', :high => '0', :normal => '0', :low => '0', :very_low => '0'}
            
            put :set_request_limit, limits
            
            student = FactoryGirl.create(:student)
            Student.should_receive(:where).once.and_return([student])
            student_request = FactoryGirl.create(:student_request)
            @request.session['uin'] = student_request.uin
        #When
        put :create, :student_request => {:name => student_request.name,
                                          :uin => student_request.uin,
                                          :major => student_request.major,
                                          :classification => "G7",
                                          :email => student_request.email,
                                          :request_semester => student_request.request_semester,
                                          :course_id => student_request.course_id,
                                          :priority => 'high',
                                          :phone => student_request.phone,
                                          :section_id => 505
        }
        
        #ThenStudent Request was failed to create. Maximum limit on priority type reached
        expect(flash[:notice]).to eq(nil)
        end
      end
    end


  describe "Update Request" do
    context "When Student Request ACTIVE_STATE" do
      it "should be able to check priority" do
          student_request = FactoryGirl.create(:student_request)
          expect(student_request.priority).to eq(StudentRequest::HIGH_PRIORITY)
      end
      it "should update the state to WITHDRAWN_STATE" do
          #GIVEN
          student_request = FactoryGirl.create(:student_request)
          student_request.state = StudentRequest::ACTIVE_STATE
          StudentRequest.should_receive(:find).once.and_return(student_request)
          student_request.should_receive(:destroy)

          #When
          put :update, :id => 14

          #THEN
          expect(student_request.state).to eq(StudentRequest::WITHDRAWN_STATE)
          expect(flash[:notice]).to eq("Student Request was successfully withdrawn.")
      end

      it "should fail to update state to WITHDRAWN_STATE" do
        #GIVEN
        student_request = FactoryGirl.create(:student_request)
        student_request.state = StudentRequest::APPROVED_STATE
        StudentRequest.should_receive(:find).once.and_return(student_request)

        #when
        put :update, :id => 14

        #Then
        expect(flash[:warning]).to eq("Student Request cannot be withdrawn.")




      end
    end
  end

  describe "Add Force Request" do
    context("When UIN doesn't exist") do
      it " should issue a flash warning" do
        Student.should_receive(:where).and_return([nil])

        post :add_force_request, :admin_request => {:uin => "Non-existent UIN"}

        expect(flash[:warning]).to eq('Student of UIN doesn\'t exist in system, please add him first!')

      end

      it "should redirect to the student_requests_adminprivileges_path" do
        Student.should_receive(:where).and_return([nil])

        post :add_force_request, :admin_request => {:uin => "Non-existent UIN"}

        assert_response :redirect, :action => 'students_show_path'
      end
    end

    context("When UIN exists") do
      context("When student is saved") do
        before :each do
          student = FactoryGirl.create(:student)
          student_request = FactoryGirl.create(:student_request)
          Student.should_receive(:where).and_return([student])

          post :add_force_request, :admin_request => {:uin => student_request.uin},
                                   :student_request => {:name => student_request.name,
                                             :uin => student_request.uin,
                                             :major => student_request.major,
                                             :classification => student_request.classification,
                                             :email => student_request.email,
                                             :request_semester => student_request.request_semester,
                                             :course_id => student_request.course_id,
                                             :phone => student_request.phone}

        end
        it "should issue a flash notice" do
          expect(flash[:notice]).to eq("Student Request was successfully created.")
        end

        it "should redirect to the the Admin Privileges Path" do
          assert_response :redirect, :action => 'student_requests_adminprivileges_path'
        end


      end

      context("When student cannot be saved") do

        before :each do
          student = FactoryGirl.create(:student)
          student_request = FactoryGirl.create(:student_request)
          Student.should_receive(:where).and_return([student])

          post :add_force_request, :admin_request => {:uin => student_request.uin},
                                   :student_request => {:name => student_request.name}
        end

        it "should issue a flash warning" do
          expect(flash[:warning]).to eq("Major can't be blank, Classification can't be blank, Request semester can't be blank, Request semester  is not a valid request semester, Course can't be blank, Course is invalid")
        end

        it "should redirect to the to the admin privelages path" do

          assert_response :redirect, :action => 'student_requests_adminprivileges_path'
        end

      end
    end
  end


  describe "Admin Actions" do
    # it "should approve a student request" do
    #   #Given
    #   student = FactoryGirl.create(:student)
    #   student_request = FactoryGirl.create(:student_request)
    #   StudentRequest.should_receive(:find).with("14").twice.and_return(student_request)
    #   Student.should_receive(:where).once.and_return([student])
    #   student_request.should_receive(:save)
    #   StudentMailer.should_receive(:update_force_state).once.and_return( double("Mailer", :deliver => true) );

    #   #When
    #   put :approve, :id => 14

    #   #Then
    #   expect(student_request.state).to eq(StudentRequest::APPROVED_STATE)
    #   assert_response :redirect, :action => 'student_requests_adminview_path'
    # end
    
    it "should be able to set admin priority" do
      student = FactoryGirl.create(:student)
      student_request = FactoryGirl.create(:student_request)

      StudentRequest.should_receive(:find).once.and_return(student_request)
      # StudentRequest::HIGH_PRIORITY
      put :updaterequestbyadmin, :priority => StudentRequest::HIGH_PRIORITY
      
      expect(student_request.priority).to eq(StudentRequest::HIGH_PRIORITY)
    
    end

    # it "should Reject a student request" do
    #   #Given
    #   student_request = FactoryGirl.create(:student_request)
    #   StudentRequest.should_receive(:find).with("14").twice.and_return(student_request)
    #   student_request.should_receive(:save)
    #   StudentMailer.should_receive(:update_force_state).once.and_return( double("Mailer", :deliver => true) );


    #   #When
    #   put :reject, :id => 14

    #   #Then
    #   expect(student_request.state).to eq(StudentRequest::REJECTED_STATE)
    #   assert_response :redirect, :action => 'student_requests_adminview_path'
    # end

    it "should hold a student request" do
      #Given
      student_request = FactoryGirl.create(:student_request)
      StudentRequest.should_receive(:find).with("14").once.and_return(student_request)
      student_request.should_receive(:save)

      #When
      put :hold, :id => 14

      #Then
      expect(student_request.state).to eq(StudentRequest::HOLD_STATE)
      assert_response :redirect, :action => 'student_requests_adminview_path'
    end
  end

  describe 'Load Admin Page' do
    it "should redirect to home page for wrong UIN" do
      #GIVEN
      request.session[:uin] = nil

      get :adminview

      assert_response :redirect, :action => root_path
    end

    it "should load all of the states when state_selected is nil in both the session and the params" do
      #Given
      request.session[:uin] = 12345678
      request.session[:state_sel] = {StudentRequest::ACTIVE_STATE => true}

      #When
      get :adminview

      #THEN

      assigns(:state_selected).should eq( StudentRequest::ACTIVE_STATE => true,
        StudentRequest::REJECTED_STATE => false,
         StudentRequest::APPROVED_STATE => false,
         StudentRequest::HOLD_STATE => false)

    end

    it "should load all of the states when state_selected is passed in through params"  do
      #Given
      request.session[:uin] = 12345678

      #When
      get :adminview, :state_sel => {StudentRequest::ACTIVE_STATE => true}

      #THEN

      assigns(:state_selected).should eq( StudentRequest::ACTIVE_STATE => true,
        StudentRequest::REJECTED_STATE => false,
         StudentRequest::APPROVED_STATE => false,
         StudentRequest::HOLD_STATE => false)

         expect(request.session[:state_sel]).to eq( ActionController::Parameters.new("Active" => "true"))
    end

    # xit "should set the priority when params has a :priority_sel but session does not"  do
    #   #Given
    #   request.session[:uin] = 12345678
    #   request.session[:priority_sel] = {StudentRequest::VERYHIGH_PRIORITY => true}


    #   #When
    #   get :adminview

    #   #THEN

    #   assigns(:priority_selected).should eq(StudentRequest::VERYHIGH_PRIORITY => true,
    #     StudentRequest::HIGH_PRIORITY => false,
    #     StudentRequest::NORMAL_PRIORITY => false,
    #     StudentRequest::LOW_PRIORITY => false,
    #     StudentRequest::VERYLOW_PRIORITY => false)

    #   expect(request.session[:priority_sel]).to eq("Very High" => true)
    # end

    # xit "should set the priority when neither  params nor session has :priority_sel"  do
    #   #Given
    #   request.session[:uin] = 12345678
    #   request.session[:priority_sel] = {StudentRequest::VERYHIGH_PRIORITY => true}


    #   #When
    #   get :adminview

    #   #THEN

    #   assigns(:priority_selected).should eq(StudentRequest::VERYHIGH_PRIORITY => true,
    #     StudentRequest::HIGH_PRIORITY => false,
    #     StudentRequest::NORMAL_PRIORITY => false,
    #     StudentRequest::LOW_PRIORITY => false,
    #     StudentRequest::VERYLOW_PRIORITY => false)

    #     expect(request.session[:priority_sel]).to eq("Very High" => true)
    # end

    # xit "should set the priority from the params when available"  do
    #   #Given
    #   request.session[:uin] = 12345678
    #   #request.session[:priority_sel] = {StudentRequest::VERYHIGH_PRIORITY => true}


    #   #When
    #   get :adminview, :priority_sel => {StudentRequest::VERYHIGH_PRIORITY => true}

    #   #THEN

    #   assigns(:priority_selected).should eq(StudentRequest::VERYHIGH_PRIORITY => true,
    #     StudentRequest::HIGH_PRIORITY => false,
    #     StudentRequest::NORMAL_PRIORITY => false,
    #     StudentRequest::LOW_PRIORITY => false,
    #     StudentRequest::VERYLOW_PRIORITY => false)

    #     expect(request.session[:priority_sel]).to eq(ActionController::Parameters.new("Very High" => "true"))
    # end
  end

  describe "updaterequestbyadmin" do
    it "should issue a flash warning when attempting to update an already withdrawn request" do

        student_request = FactoryGirl.create(:student_request)
        student_request.state = StudentRequest::WITHDRAWN_STATE
        StudentRequest.should_receive(:find).once.and_return(student_request)

        put :updaterequestbyadmin, :id => 14

        expect(flash[:warning]).to eq("Request has already been withdrawn by the student. Please refresh your Page.")
    end

    it "should add admin notes if available" do
      student_request = FactoryGirl.create(:student_request)
      student_request.state = StudentRequest::ACTIVE_STATE
      StudentRequest.should_receive(:find).once.and_return(student_request)

      put :updaterequestbyadmin, {:id => 14, :notes_for_myself => "These are my admin notes."}

      expect(assigns(:student_request).admin_notes).to eq("These are my admin notes.")
    end

    # xit "should add notes to a student if available" do
    #   student_request = FactoryGirl.create(:student_request)
    #   student_request.state = StudentRequest::ACTIVE_STATE
    #   StudentRequest.should_receive(:find).once.and_return(student_request)

    #   put :updaterequestbyadmin, {:id => 14, :notes_for_student => "These are my notes to a student."}

    #   expect(assigns(:student_request).notes_to_student).to eq("These are my notes to a student.")
    # end

  end

  describe "login" do
    #post 'student_requests/login' => 'student_requests#login'
    it "should set current_state to nil when logging in" do
      Admin.should_receive(:where).once.and_return([nil])

      post :login, params: { 'session' => { :user => "admin"}}

       expect(request.session[:current_state]).to be_nil
    end

    it "should display a flash warning when account doesn't exist" do
      Admin.should_receive(:where).once.and_return([nil])

      post :login, params: { 'session' => { :user => "admin"}}

      expect(flash[:warning]).to eq("The admin account doesn't exist")
    end

    it "should redirect to rooth path when account doesn't exist" do
      Admin.should_receive(:where).once.and_return([nil])

      post :login, params: { 'session' => { :user => "admin"}}

      assert_response :redirect, :action => root_path
    end

    it "should set the current user to the returned user" do
      admin = FactoryGirl.create(:admin)
      Admin.should_receive(:where).with("email = 'IAmSchaeffer@tamu.edu'").once.and_return([admin])

      post :login, params: { 'session' => { :user => "admin", :email =>"IAmSchaeffer@tamu.edu", :password => "SchaefferDoesntKnow"}}

      expect(request.session[:name].to_s).to eq("Schaeffer")
      expect(request.session[:current_state]).to eq("admin")
      expect(request.session[:uin]).to eq("12345678")
      assert_response :redirect, :action => student_requests_adminview_path
    end

    it "should display a flash warning when account doesn't exist" do
      Student.should_receive(:where).once.and_return([nil])

      post :login, params: { 'session' => { :user => "student"}}

      expect(flash[:warning]).to eq("The account doesn't exist. Please sign up first.")
    end

    it "should redirect to rooth path when account doesn't exist" do
      Student.should_receive(:where).once.and_return([nil])

      post :login, params: { 'session' => { :user => "student"}}

      assert_response :redirect, :action => root_path
    end

    it "should redirect to rooth path when account doesn't exist" do
      Student.should_receive(:where).once.and_return([nil])

      post :login, params: { 'session' => { :user => "student"}}

      assert_response :redirect, :action => root_path
    end

    it "should set the current user when the email has been confirmed" do
      student = FactoryGirl.create(:student)
      student.email_confirmed = true
      Student.should_receive(:where).with("email = 'johndoe@tamu.edu'").once.and_return([student])
      #Student.should_receive(:where).with("email ='johndoe@tamu.edu' and password ='DarthVader123'").once.and_return([student])


      post :login, params: { 'session' => { :user => "student", :email =>'johndoe@tamu.edu', :password => "DarthVader123"}}

      expect(request.session[:name].to_s).to eq("John Doe")
      expect(request.session[:current_state]).to eq("student")
      expect(request.session[:uin]).to eq("12345678")
      assert_response :redirect, :action => students_show_path
    end

    it "should set issue a flash warning when email has not been confirmed" do
      student = FactoryGirl.create(:student)
      student.email_confirmed = false
      Student.should_receive(:where).with("email = 'johndoe@tamu.edu'").once.and_return([student])
      #Student.should_receive(:where).with("email ='johndoe@tamu.edu' and password ='DarthVader123'").once.and_return([student])

      post :login, params: { 'session' => { :user => "student", :email =>'johndoe@tamu.edu', :password => "DarthVader123"}}

      expect(flash[:warning]).to eq("The account has not been activated. Please check your email to activate your account!")
    end

    it "should redirect to root path when email has not been confirmed" do
      student = FactoryGirl.create(:student)
      student.email_confirmed = false
      Student.should_receive(:where).with("email = 'johndoe@tamu.edu'").once.and_return([student])
     # Student.should_receive(:where).with("email ='johndoe@tamu.edu' and password ='DarthVader123'").once.and_return([student])

      post :login, params: { 'session' => { :user => "student", :email =>'johndoe@tamu.edu', :password => "DarthVader123"}}

      assert_response :redirect, :action => root_path
    end



  end
end
