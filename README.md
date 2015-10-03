# Introducing the Asterisk Call Notifier Gem

    require 'asterisk_call_notifier'

    AsteriskCallNotifier.new(sps_address: '192.168.4.140').start

The above example monitors Asterisk PBX's CDR CSV file for new entries. The new entry is then published to a SimplePubSub broker using a JSON payload with the default topic of *asterisk*.

## Testing

I dialed a local telephone extension and I observed the SPS message was successfully received.

output:

<pre>MESSAGE: asterisk: {"accountcode":"","src":"c7905","dst":"1011",
"dcontet":"my-phones","clid":"c7905","channel":"SIP/c7905-0000009f",
"dstchannel":"SIP/line1-000000a0","lastapp":"Dial","lastdata":"SIP/line1,20",
"start":"2015-10-03 10:52:25","answer":null,"end":"2015-10-03 10:52:28",
"duration":"3","billsec":"0","disposition":"NO ANSWER",
"amaflags":"DOCUMENTATION","astid":"1443869545.162"}
</pre>

Note: It will monitor all new entries, meaning it can identify calls received, calls made, and calls missed etc.

## Resources

* How to parse CSV data http://www.jamesrobertson.eu/snippets/2015/oct/03/how-to-parse-csv-data.html
* Asterisk cdr csv http://www.voip-info.org/wiki/view/Asterisk+cdr+csv
* Capturing the output from `hcidump --raw` using Ruby http://www.jamesrobertson.eu/snippets/2015/jul/17/capturing-the-output-from-hcidump-raw-using-ruby.html
* Reading a growing log file http://www.jamesrobertson.eu/snippets/2013/aug/06/reading-a-growing-log-file.html

Update: *3-Oct-2015 @ 13:54*

# The Asterisk Call Notifier gem now features on_call_new

    require 'asterisk_call_notifier'

    acn = AsteriskCallNotifier.new()

    def acn.on_new_call(h)
      puts "extension %s called %s at %s" % [h[:src], h[:dst], h[:start]]
    end

    acn.start

The on_new_call method can now be implemented by the client, allowing them to use their on notifier as well as to control whether a notification needs to be sent and in what format.

output:

<pre>extension c7905 called 1011 at 2015-10-03 12:40:12</pre>

## Resources

* ?Introducing the Asterisk Call Notifier Gem http://www.jamesrobertson.eu/snippets/2015/oct/03/introducing-the-asterisk-call-notifier-gem.html?

asterisk csv cdr notifier callwatcher
