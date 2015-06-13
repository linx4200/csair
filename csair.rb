# encoding: utf-8

require 'mechanize'  #gem install mechanize
require 'mail' #gem install mail

class Qmail
  def initialize(account, password)
    # 需要在 QQ邮箱 开启SMTP 服务
    Mail.defaults do
      delivery_method :smtp, { :address              => 'smtp.qq.com',
                               :port                 => 25,
                               :domain               => 'localhost',
                               :user_name            => account,
                               :password             => password,
                               :authentication       => :login,
                               :enable_starttls_auto => false  }
    end
    @account = account
  end
  def send(to, subject, msg)
    account =  @account
    Mail.deliver do
      to to
      from account
      subject subject
      body msg
    end
  end
end

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
  mail = Qmail.new('youremail@qq.com', 'password')
  flag = false

  while(1)
    res = fetch
    if res[:err]
      flag = true
      msg = '拿不回来数据了! 说不定就被封了! 老公自己去看看呀!'
    else
      price = res['segment'][0]['dateflight'][0]['prices'][0]['adultprice'].to_s
      offset = price - old_price

      if offset < 0
        flag = true
        msg = '机票跳水' + (-offset).to_s  + 'RMB啦!!!! 现价: ' + price.to_s + ' 大甩卖!'
      else
        flag = true
        msg = '竟然涨价了!!!!涨了' + offset.to_s + 'RMB这么贵!!!! 现在都要' + price.to_s + ' 那么贵了! 😢'
      end
    end

    if flag
      mail.send('241923064@qq.com', '湾湾机票呼喊老公哒~~~', msg)
    end
    flag = false
    old_price = price

    sleep(60 * 5)
  end
end

main