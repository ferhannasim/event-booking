class Tour < ApplicationRecord
  belongs_to :operator, optional: true

validates_presence_of :start_datetime, :end_datetime, :tour_type

validate :end_date_is_after_start_date
validate :recurrence_date

def tour_length
  if start_datetime.present? && end_datetime.present?
    TimeDifference.between(start_datetime, end_datetime).humanize
  end
end

private

  def end_date_is_after_start_date
    return if end_datetime.blank? || start_datetime.blank?

      if end_datetime < start_datetime
        errors.add(:end_datetime, "cannot be before the start date")
      end
    end
  end

  def recurrence_date
    return if recurring.blank?

    if recurring == 'On' && recurring_date.blank?
      errors.add(:recurring_date, "cannot be blank is recurrence is On") 
    end
  end