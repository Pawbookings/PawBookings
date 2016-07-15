module PaymentsHelper
  def cat_or_dog_only_option
    [
      ['Select', 'none_selected'],
      ['Dog', 'dog'],
      ['Cat', 'cat']
    ]
  end
end
