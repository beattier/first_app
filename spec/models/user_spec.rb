require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
      }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  describe "password_validations" do
    
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
      should_not be_valid
    end
    
    it "should require a matching passwrod confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
      should_not be_valid
    end
    
    it "should reject short passwords" do
      User.new(@attr.merge(:password => "aaaaa", :password_confirmation => "aaaaa")).
      should_not be_valid
    end
    
    it "should reject long passwords" do
      User.new(@attr.merge(:password => "a" * 41, :password_confirmation => "a" * 41)).
      should_not be_valid
    end
  end
    
    
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do 
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do
      
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should be false if password is wrong" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
      it "should return nil on email / password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end
      
      it "should return nil for an email address with no user" do
        nonexistant_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistant_user.should be_nil
      end
      
      it "should return the user on email/password match" do
        valid_user = User.authenticate(@attr[:email], @attr[:password])
        valid_user.should == @user
      end
    end
      
      
      
    
  end
  
  it "should require a name" do
    noname_user = User.new(@attr.merge(:name => ""))
    noname_user.should_not be_valid
  end
  
  it "should require an email" do
    noemail_user = User.new(@attr.merge(:email => ""))
    noemail_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    longname_user = User.new(@attr.merge(:name => long_name))
    longname_user.should_not be_valid
  end
  
  
  it "should accept valid email addresses" do 
    addresses = %w[user@foo.com THE_UsER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      v_mail_user = User.new(@attr.merge(:email => address))
      v_mail_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org first.last@foo.]
      addresses.each do |address|
        iv_mail_user = User.new(@attr.merge(:email => address))
        iv_mail_user.should_not be_valid
      end
    end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject duplicate email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject emails that are too long" do
    longemail = "a" * 50 + "@" + "a" * 50 + ".com"
    u = User.new(@attr.merge(:email => longemail))
    u.should_not be_valid
  end
    
  
end
