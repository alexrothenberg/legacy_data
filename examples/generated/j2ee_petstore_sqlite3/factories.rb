Factory.define :address do |address|
  address.street1   'some string'
  address.city      'some string'
  address.state     'some string'
  address.zip       'some string'
  address.latitude  12.3
  address.longitude 12.3
end

Factory.define :seller_contact_info do |seller_contact_info|
  seller_contact_info.lastname      'some string'
  seller_contact_info.firstname     'some string'
  seller_contact_info.email         'some string'
end

Factory.define :category do |category|
  category.name        'some string'
  category.description 'some string'
end

Factory.define :id_gen do |id_gen|
  id_gen.gen_value 7
end

Factory.define :item do |item|
  item.productid                 'some string'
  item.name                      'some string'
  item.description               'some string'
  item.price                     12.3
  item.address_addressid         'some string'
  item.contactinfo_contactinfoid 'some string'
  item.totalscore                7
  item.numberofvotes             7
  item.disabled                  7
end

Factory.define :product do |product|
  product.categoryid  'some string'
  product.name        'some string'
  product.description 'some string'
end

Factory.define :tag do |tag|
  tag.tag      'some string'
  tag.refcount 7
end

Factory.define :tag_item do |tag_item|
  tag_item.tagid  7
  tag_item.itemid 'some string'
end

Factory.define :ziplocation do |ziplocation|
  ziplocation.city    'some string'
  ziplocation.state   'some string'
end

