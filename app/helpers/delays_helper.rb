module DelaysHelper
  def index_to_csv
    decimal_separator = l(:general_csv_decimal_separator)
    export = FCSV.generate(:col_sep => l(:general_csv_separator)) do |csv|
      # csv header fields
      csv << [ 
        l(:field_user), 
        l(:field_delay_on),
        l(:field_arrival_time),
        l(:field_reason),
        l(:field_author),
        l(:field_created_on),
        l(:field_updated_on),        
      ]
      
      # csv lines
      @scope.all(:order => "arrival_time, delay_on").each do |object|
        csv << [
          object.user.name,
          format_date(object.delay_on),
          format_time(object.arrival_time, false),
          object.reason,
          object.author.name,          
          format_time(object.created_on),
          format_time(object.updated_on)
        ]
      end
    end
    export    
  end
end
