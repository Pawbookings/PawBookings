module ApplicationHelper
  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

  def number_of_pets_option
    [
      [0, 0],
      [1, 1],
      [2, 2],
      [3, 3],
      [4, 4],
      [5, 5],
    ]
  end

  def number_of_rooms_option
    [
      [1,1],
      [2,2],
      [3,3],
      [4,4],
      [5,5],
      [6,6],
      [7,7],
      [8,8],
      [9,9],
      [10,10],
    ]
  end
end
