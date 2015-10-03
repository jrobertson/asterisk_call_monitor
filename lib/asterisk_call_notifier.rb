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

    @sps = SPSPub.new(address: sps_address, port: sps_port)
    @sps_topic = sps_topic

    @command = 'tail -n 1 -f ' + csv_path
    @headings = %i(accountcode src dst dcontet clid channel dstchannel
           lastapp lastdata start answer end duration billsec disposition
                                                               amaflags astid)
  end

  def start()

    #FileUtils.mv @csv_path, @csv_path + '.old'
    #File.write @csv_path, ''
    t = Time.now # using the time we can ignore existing entries

    IO.popen(@command).each_line do |x| 
      
      if Time.now > t + 10 then
        raw_call_entry = x.lines.last
        json = Hash[@headings.zip(CSV.parse(raw_call_entry).first)].to_json
        @sps.notice @sps_topic+ ': ' + json
      end
    end

  end

end

if __FILE__ == $0 then
  
  AsteriskCallNotifier.new(sps_address: 'sps').start
  
end
