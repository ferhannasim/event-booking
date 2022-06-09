class ToursController < ApplicationController
  before_action :set_tour, only: [:destroy]

  def index
    @tours = Tour.all
  end

  def new
    @tour = Tour.new
    @tour_types = ['Daily']
  end

  def create
    if params[:tour][:recurring_times].present? || params[:tour][:recurring_date].present?
      create_tours
    else
      Tour.create(tour_params)
    end
    redirect_to tours_path
  end

  def destroy
    redirect_to tours_path if @tour.destroy
  end

  def get_tour_types
    @tour_types = get_types
  end

  private

  def set_tour
    @tour = Tour.find_by(id: params[:id])
  end

  def tour_params
    params.require(:tour).permit(:start_datetime, :end_datetime, :tour_type, :recurring, :recurring_date, :recurring_times)
  end

  def get_types
    if params[:start_date].present?
       @start_date = params[:start_date].to_date
       day   = @start_date.strftime("%A")
       month = Date::MONTHNAMES[@start_date.month]
       date = @start_date.day
       week_of_month = find_day_position(@start_date)
      ['Daily', "Weekly on #{day}", "Monthly on Every #{date}", "on Every #{week_of_month} #{day}", "Annually on #{month} #{date}"]
    end
  end

  def create_tours
    tour_type = params[:tour][:tour_type]
    Tour.create(tour_params)
    if tour_type == 'Daily'
      create_daily_tour
    elsif(tour_type.include? "Weekly")
      create_weekly_tour
    elsif(tour_type.include? "Monthly")
      create_monthly_tour
    elsif(tour_type.include? "Annually")
      create_yearly_tour
    elsif(tour_type.include? "Every")
      create_week_month_tours
    end
  end

  def set_params_data
    set_params

    if params[:tour][:recurring_times].present?
      @count = params[:tour][:recurring_times].to_i
    elsif params[:tour][:recurring_date].present?
      if @tour_type == 'Daily'
        @count = TimeDifference.between(@start_datetime, @recurring_date).in_days
      elsif (@tour_type.include? "Weekly")
        @count = TimeDifference.between(@start_datetime, @recurring_date).in_weeks
      elsif(@tour_type.include? "Monthly")
        @count = TimeDifference.between(@start_datetime, @recurring_date).in_months
      elsif(@tour_type.include? "Annually")
        @count = TimeDifference.between(@start_datetime, @recurring_date).in_years
      elsif(@tour_type.include? "Every")
        @count = TimeDifference.between(@start_datetime, @recurring_date).in_months
      end
    end
  end

  def set_params
    @tour_type = params[:tour][:tour_type]
    @start_datetime = params[:tour][:start_datetime]
    @end_datetime   = params[:tour][:end_datetime]
    @recurring_date = params[:tour][:recurring_date]
  end

  def create_daily_tour
   set_params_data
    if @count > 1
        @date_counter = 1
      (@count-1).to_i.times do
        create_tour(@start_datetime.to_date, @end_datetime.to_date, @date_counter, @tour_type)
        @date_counter = @date_counter + 1
      end
    end
  end

  def create_weekly_tour
    set_params_data

    if @count > 1
        @date_counter = 7
      (@count-1).to_i.times do
        create_tour(@start_datetime.to_date, @end_datetime.to_date, @date_counter, @tour_type)
        @date_counter = @date_counter + 7
      end
    end
  end

  def create_monthly_tour
    set_params_data
    
    if @count > 1
        @date_counter = 1.month
      (@count-1).to_i.times do
        create_tour(@start_datetime.to_date, @end_datetime.to_date, @date_counter, @tour_type)
        @date_counter = @date_counter + 1.month
      end
    end
  end

  def create_yearly_tour
    set_params_data

    if @count > 1
        @date_counter = 1.year
      @count.to_i.times do
        create_tour(@start_datetime.to_date, @end_datetime.to_date, @date_counter, @tour_type)
        @date_counter = @date_counter + 1.year
      end
    end
  end

  def create_week_month_tours
    set_params_data

    if @count > 1
        @date_counter = 1.month
        current_month = current_month_day(@start_datetime.to_date)
        @index = current_month.find_index(@start_datetime.to_date.day) + 1
      @count.to_i.times do
        day_position = day_position(@start_datetime.to_date, @date_counter)
        next_date = day_position[@index-1]
        next_month = (@start_datetime.to_date + @date_counter).month
        next_year = (@start_datetime.to_date + @date_counter).year
        Tour.create!(start_datetime: "#{next_year}/#{next_month}/#{next_date} #{@start_datetime.to_time.strftime("%H:%M")}", end_datetime: @end_datetime.to_date + @date_counter, tour_type: @tour_type)
        @date_counter = @date_counter + 1.month
      end
    end
  end

  def create_tour(start_datetime, end_datetime, date_counter, tour_type)
    Tour.create!(start_datetime: start_datetime + date_counter, end_datetime: end_datetime + date_counter, tour_type: tour_type)
  end

### Functions to find dates and months

  def current_month_day(start_datetime)
    weekday_name = start_datetime.strftime("%A").downcase
    (start_datetime).send("all_#{weekday_name}s_in_month")
  end

  def day_position(start_date, date_counter)
    weekday_name = start_date.strftime("%A").downcase
    (start_date + date_counter).send("all_#{weekday_name}s_in_month")
   end

  def find_day_position(start_date)
    weekday_name = start_date.strftime("%A").downcase
    arr = start_date.send("all_#{weekday_name}s_in_month")
    arr.find_index(start_date.day) + 1
  end

end
