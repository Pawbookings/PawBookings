module PaymentsHelper
  def cat_or_dog_only_option
    [
      ['Select', 'none_selected'],
      ['Dog', 'dog'],
      ['Cat', 'cat']
    ]
  end

  def card_type_option
    [
      ["Visa", "visa"],
      ["MasterCard", "MasterCard"],
      ["American Express", "american_express"],
      ["Discover", "discover"],
    ]
  end

  def false_or_true_option
    [
      ["False", "false"],
      ["True", "true"]
    ]
  end
end
