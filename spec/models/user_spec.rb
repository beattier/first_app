require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
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

  it "should reject emails that are too long"
  
end
