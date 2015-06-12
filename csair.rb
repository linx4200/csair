# encoding: utf-8

require 'mechanize'  #gem install mechanize
require 'mail' #gem install mail

def fetch()
  agent = Mechanize.new
  url = 'http://b2c.csair.com/B2C40/query/jaxb/interDirect/query.ao'
  bo = {
    'json' => '{"depcity":"TPE","arrcity":"CAN","flightdate":"20151008","adultnum":"1","childnum":"0","infantnum":"0","cabinorder":"0","airline":"1","flytype":"0","international":"1","action":"0","segtype":"1","cache":"0","preUrl": ""}'
  }
  begin
    return JSON.parse(agent.post(url, bo).body)
  rescue Exception => e
    return {
      :err => '请求错误!'
    }
  end
end

def main()
  old_price = 0

  while(1)
    res = fetch
    if res[:err]
      # todo
    end

    price = res['segment'][0]['dateflight'][0]['prices'][0]['adultprice']

    if price < old_price
      # todo
    end

    old_price = price

    sleep(60 * 5)
  end
end

main