require 'json'
require 'ostruct'

class ChildrenController < ApplicationController
  include ActionController::Live
  protect_from_forgery with: :null_session



 
  #before_action :set_child, only: [:show, :edit, :update, :destroy]
    
   def update_attributes(hash)
    hash.keys.each do |key|
      m = "#{key}="
      Child.send(m, hash[key]) if Child.respond_to?(m)
    end
  end
       
    
  # GET /children
  # GET /children.json
  def index
    children = []
    base_uri = 'https://postjson-d117c.firebaseio.com/'
    @firebase = Firebase::Client.new(base_uri)
    childrenjs = @firebase.get("Child")
    parsed = JSON.parse(childrenjs.raw_body)
    kids = parsed.deep_symbolize_keys

    kids.uniq.each do |key, value|
      value.each do |key2, value2|
      children << value
      end
    end    
    
@children = children.flatten.uniq
 #    render :json => @children

  end

  # GET /children/1
  # GET /children/1.json
  def show
    children = []
    base_uri = 'https://postjson-d117c.firebaseio.com/'
    @firebase = Firebase::Client.new(base_uri)
    childrenjs = @firebase.get("Child")
    parsed = JSON.parse(childrenjs.raw_body)
    kids = parsed.deep_symbolize_keys

    kids.uniq.each do |key, value|
      value.each do |key2, value2|
        
      children << key
      end
    end
     parsed.each do |key, value|
      children << key
      value.each do |key3, value3|
      children << value3
      end
    end
      
      response = @firebase.get("Child/").raw_body
   #@child = eval(response)
    
  render :json => response
   end

  # GET /children/new
  def new
    @child = Child.new

  end

  # GET /children/1/edit
  def edit
  end

  # POST /children
  # POST /children.json
  def create
    @child = Child.new(child_params)
    base_uri = 'https://postjson-d117c.firebaseio.com/'
    @firebase = Firebase::Client.new(base_uri)
    kid = []
    child_params.each do |k,v|
        kid << k
        kid<< v
      
      end
     
     #  render :json => kid

     response = @firebase.push("Child", :name => kid[1.to_i].to_s, :age => kid[3.to_i].to_s)
  
   respond_to do |format|
      if response.success?
        format.html { redirect_to @child, notice: 'Child was successfully created.' }
        format.json { render :show, status: :created, location: @child }
      else
        format.html { render :new }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end   
  end
    
    
  end
  # POST /children/android
  # POST /children/android.json
  def android

    #skip_before_action :verify_authenticity_token

    print "\n----------------------\n"
    data_json = JSON.parse(request.raw_post)
    print data_json

    print "\n----------------------\n"

    data_json = JSON.parse(request.raw_post)
    @child = Child.new(data_json)

    if @child.glucose < 4 
      message = "Your Glucose levels are too LOW please drink some juice " 
    end 
    if 4 <= @child.glucose && @child.glucose < 9 
      message = "Your Glucose levels are just great well done  "
    end 
    
    if 9 <= @child.glucose && @child.glucose < 12 
      message = "Your Glucose levels are a little high if you ate in the last hour please check again in 30 minutes "
    end 
    
    if 12 <= @child.glucose && @child.glucose <=25 
      message = "Your Glucose levels are too HIGH please use your insulin NOW " 
    end 
    if @child.glucose > 25
     message = "Call emergency services "
    end
    
   

    app = RailsPushNotifications::GCMApp.new
    gcm_api_key = 'AAAA6eNVwfI:APA91bEdWYsiOgJY5--USHyFt6EfzO52t-vDfQU3SwFLUqg1-6A972l0o6sat45h3FORAGvQwPEN2RCU83sVv-Vd7h3ACPo7sgiEWhCOI0JRu_2thOkgF87O-i4imZffoAUH94eIxMVn'
    app.gcm_key = gcm_api_key
    app.save
    
      if app.save
      notif = app.notifications.build(
         destinations: [@child.token],
        data: { text: message + @child.name}
      )
      
      if notif.save
        app.push_notifications
        notif.reload
        print "Notification successfully pushed through!. Results #{notif.results.success} succeded, #{notif.results.failed} failed"
      #   redirect_to :android_index
      else
      print app.errors.full_messages
      render :json
      end
      else
        print notif.errors.full_messages
        render :json
      end
    
  

   #if response.success do
   #render :json => {"ok":true}
    #redirect_to 'android#create'
   
   end
  # PATCH/PUT /children/1
  # PATCH/PUT /children/1.json
  def update
    respond_to do |format|
      if @child.update(child_params)
        format.html { redirect_to @child, notice: 'Child was successfully updated.' }
        format.json { render :show, status: :ok, location: @child }
      else
        format.html { render :edit }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /children/1
  # DELETE /children/1.json
  def destroy
    @child.destroy
    respond_to do |format|
      format.html { redirect_to children_url, notice: 'Child was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_child
      @child = Child.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def child_params
      params.require(:child).permit(:id, :age, :name)
    end
end
