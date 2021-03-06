class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :event_owner!, only: [:edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    if params[:tag]
      @events = Event.tagged_with(params[:tag])
    else
      @events = Event.all
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event_owner = @event.organizer
    @pending_requests = Attendance.pending.where(event_id: @event.id)
    @attendees = Attendance.accepted.where(event_id: @event.id)
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    # add current_user to pass organizer_id to new Event object
    # use organized_events with multiple association to events table
    @event = current_user.organized_events.new(event_params)
    @event.organizer_id = current_user.id

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def join
    @attendance = Attendance.join_event(current_user.id, params[:event_id], 'request_sent')
    'Request Sent' if @attendance.save
    redirect_to events_path

  end

  def accept_request
    @event = Event.find(params[:event_id])
    @attendance = Attendance.find_by(id: params[:attendance_id]) rescue nil
    @attendance.accept!
    'Applicant Accepted' if @attendance.save
    redirect_to events_path
  end

  def reject_request
    @event = Event.find(params[:event_id])
    @attendance = Attendance.where(params[:attendance_id]) rescue nil
    @attendance.reject
    'Applicant Rejected' if @attendance.save
    redirect_to events_path
  end

  def my_event
    @events = current_user.organized_events
  end

  private

  def event_owner!
    authenticate_user!
    if @event.organizer_id != current_user.id
      redirect_to :index
      flash[:notice] = "You're not permitted to do this!"
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :start_date, :end_date, :location, :agenda, :address, :organizer_id, :all_tags)
    end
end
