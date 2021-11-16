def loot_resources(resources, carrying_capacity)
  total_amount = resources.values.sum
  # если грузоподъёмность армии больше, чем всего ресурсов, то они уносят всё
  return resources if carrying_capacity >= total_amount

  # посчитываем, сколько может унести армия ресурсов каждого типа пропорционально изначальному количеству
  looted_resources = resources.transform_values do |amount|
    amount * carrying_capacity / total_amount
  end

  looted_weight = looted_resources.values.sum
  remaining_amount = carrying_capacity - looted_weight # сколько ещё могут унести

  unless remaining_amount.zero?
    # для каждого ресурса рассчитаем его пропорциональную "ценность", относительно других ресурсов
    resources_proportion_value = resources.transform_values do |value|
      value * carrying_capacity - total_amount * ((carrying_capacity * value) / total_amount)
    end

    # армия заполнит оставшиеся места самыми "ценными" из ресурсов
    remaining_amount.times do
      max_value_resource = [resources_proportion_value.max_by { |_, value| value }].to_h.keys.first
      looted_resources[max_value_resource] += 1 # добавляем единицу этого ресурса
      resources_proportion_value.delete(max_value_resource) # больше не будем добавлять этот ресурс
    end
  end

  looted_resources
end

village_resources = { provision: 100, wood: 300, iron: 200, gold: 20 }
carrying_capacity = 129

looted_resources = loot_resources(village_resources, carrying_capacity)

puts 'In the village there were originally: ' \
     "#{village_resources.map { |resource, amount| "#{amount} items of #{resource}" }.join(', ')} "

puts 'From the village were stolen: ' \
     "#{looted_resources.map { |resource, amount| "#{amount} items of #{resource}" }.join(', ')} "
