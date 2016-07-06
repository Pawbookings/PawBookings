module SearchesHelper
  def cat_or_dog_options
    [
      ['Select', 'none_selected'],
      ['Dog', 'dogs'],
      ['Cat', 'cats'],
      ['Cat & Dog', 'both']
    ]
  end

  def days_of_week
    [
      ["1", "monday_open"],
      ["2", "tuesday_open"],
      ["3", "wednesday_open"],
      ["4", "thursday_open"],
      ["5", "friday_open"],
      ["6", "saturday_open"],
      ["7", "sunday_open"],
    ]
  end
end
