#!/usr/bin/env ruby

# file: asterisk_call_notifier.rb


require 'csv'
require 'json'
require 'sps-pub'
require 'fileutils'


class AsteriskCallNotifier

  def initialize(csv_path: '/var/log/asterisk/cdr-csv/Master.csv', \
                    sps_address: nil, sps_port: 59000, sps_topic: 'asterisk')

    @csv_path = csv_path

    @sps = sps_address ? SPSPub.new(address: sps_address, port: sps_port) : nil
    @sps_topic = sps_topic

    @command = 'tail -n 1 -f ' + csv_path
    @headings = %i(accountcode src dst dcontet clid channel dstchannel
           lastapp lastdata start answer end duration billsec disposition
                                                               amaflags astid)
  end
  
  def on_new_call(h)
    
    # custom defined
    
  end

  def start()

    t = Time.now # using the time we can ignore existing entries

    IO.popen(@command).each_line do |x| 
      
      # anything after 5 seconds from start is new
      if Time.now > t + 5 then 
        
        raw_call_entry = x.lines.last
        h = Hash[@headings.zip(CSV.parse(raw_call_entry).first)]
        json = h.to_json
        
        @sps.notice(@sps_topic + ': ' + json) if @sps
        on_new_call(h)
      end
    end

  end  

end

if __FILE__ == $0 then
  
  AsteriskCallNotifier.new(sps_address: 'sps').start
  
end