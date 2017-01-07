module PaymentsHelper
  def cat_or_dog_only_option
    [
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

  def spay_or_neutered_option
    [
      ["False", "false"],
      ["Spay", "spay"],
      ["Neutered", "neutered"]
    ]
  end
end
