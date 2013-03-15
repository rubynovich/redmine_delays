class DelaysController < ApplicationController
  unloadable
  before_filter :require_vacation_manager
  before_filter :new_delay, :only => [:new, :index, :create]
  before_filter :find_delay, :only => [:edit, :update, :show, :destroy]

  helper :sort
  include SortHelper
  helper :delays
  include DelaysHelper

  def index
    sort_init 'created_on', 'desc'
    sort_update({
      'arrival_time' => 'arrival_time', 'delay_on' => 'delay_on',
      'user_id' => ["users.lastname", "users.firstname"],
      'author_id' => ["users.lastname", "users.firstname"],
      'created_on' => 'created_on'})

    @limit = per_page_option

    @scope = Delay.time_period(params[:delay_on], :delay_on).
#      like_username(params[:user_name]).
      eql_field(params[:author_id], :author_id)

    @delays_count = @scope.count
    @delay_pages = Paginator.new self, @delays_count, @limit, params[:page]
    @offset ||= @delay_pages.current.offset
    @delays =  @scope.find  :all,
                            :order => sort_clause,
                            :limit  =>  @limit,
                            :offset =>  @offset
    respond_to do |format|
      format.html{ render :action => :index }
      format.csv{ send_data(index_to_csv, :type => 'text/csv; header=present', :filename => Date.today.strftime("delays_%Y-%m-%d.csv")) }
    end
  end

  def new
  end

  def create
    if @delay.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @delay.update_attributes(params[:delay])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def destroy
    @delay.destroy
    redirect_to :action => :index
  rescue
    flash[:error] = l(:error_unable_delete_delay)
    redirect_to :action => :index
  end

  private
    def new_delay
      @delay = Delay.new((params[:delay] || {}).merge(:author_id => User.current.id))
    end

    def find_delay
      @delay = Delay.find(params[:id])
    end

    def require_vacation_manager
      (render_403; return false) unless User.current.is_vacation_manager?
    end
end
