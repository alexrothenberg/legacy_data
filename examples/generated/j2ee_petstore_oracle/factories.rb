Factory.define :address do |a|
  a.street1   'some string'
  a.city      'some string'
  a.state     'some string'
  a.zip       'some string'
  a.latitude  12.3
  a.longitude 12.3
end

Factory.define :category do |c|
  c.name        'some string'
  c.description 'some string'
end

Factory.define :id_gen do |i|
  i.gen_value 7
end

Factory.define :item do |i|
  i.productid                 'some string'
  i.name                      'some string'
  i.description               'some string'
  i.price                     12.3
  i.address_addressid         'some string'
  i.contactinfo_contactinfoid 'some string'
  i.totalscore                7
  i.numberofvotes             7
  i.disabled                  7
end

Factory.define :product do |p|
  p.categoryid  'some string'
  p.name        'some string'
  p.description 'some string'
end

Factory.define :sellercontactinfo do |s|
  s.lastname      'some string'
  s.firstname     'some string'
  s.email         'some string'
end

Factory.define :tag do |t|
  t.tag      'some string'
  t.refcount 7
end

Factory.define :ziplocation do |z|
  z.city    'some string'
  z.state   'some string'
end

