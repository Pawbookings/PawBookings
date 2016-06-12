module RunsHelper
  def indoor_outdoor_option
    [
      ['Indoor', 'indoor'],
      ['Outdoor', 'outdoor']
    ]
  end

  def private_shared_option
    [
      ['Private', 'private'],
      ['Shared', 'shared']
    ]
  end

  def breed_restriction_option
    [
      ['Pitbull', 'pitbull'],
      ['German Shepherd', 'shepherd'],
      ['Husky', 'husky'],
      ['Rotweiler', 'rotweiler']
    ]
  end
end
