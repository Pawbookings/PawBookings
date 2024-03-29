module KennelsHelper
    def states_options
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end

  def time_option
    [
      ['6:00 a.m', '6:00 a.m'],
      ['7:00 a.m', '7:00 a.m'],
      ['8:00 a.m', '8:00 a.m'],
      ['9:00 a.m', '9:00 a.m'],
      ['10:00 a.m', '10:00 a.m'],
      ['11:00 a.m', '11:00 a.m'],
      ['12:00 p.m', '12:00 p.m'],
      ['1:00 p.m', '1:00 p.m'],
      ['2:00 p.m', '2:00 p.m'],
      ['3:00 p.m', '3:00 p.m'],
      ['4:00 p.m', '4:00 p.m'],
    ]
  end

  def unsanitize_date(param)
    @new_date = []
    split_params = param.split('-')
    @new_date << split_params[1]
    @new_date << split_params[2]
    @new_date << split_params[0]
    @new_date = @new_date.join("/")
  end

  def get_kennel_price_range(kennel_id)
    price_range = []
    runs = Run.where(kennel_id: kennel_id).to_a
    runs.each do |run|
      price_range << run[:price]
    end
    @price_range = price_range.sort!
  end

end
