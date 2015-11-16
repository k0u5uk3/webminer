# -*- coding: utf-8 -*-
def usage()
   puts "Usage : " + File.basename(__FILE__) + "[-v][-h]{-u|-l}"
   puts "   Example(1) : " + File.basename(__FILE__) + ' [-v][-h] -u url'
   puts "   Example(2) : " + File.basename(__FILE__) + ' [-v][-h] -l list'
end

def symbolize_keys(hash)
   hash.map{|k,v| [k.to_sym, v] }.to_h
end

def get_payloads()
   payloads = [
      "README.md",
      ".git/logs/HEAD"
   ]
   return payloads
end

def webminer(url)
   flag = false
   payloads = get_payloads
   timeout = Timeout.new

   Signal.trap(:ALRM) { |signo|
      flag=true
   }

   for payload in payloads do
      attack = 'http://' + url + '/' + payload
      status = -1
      while status.to_i < 0 or redirect?(status)
         begin
            timeout.alarm(5)
            res = HttpRequest.new.get attack
         rescue
            timeout.alarm(0)
            puts "[TIMEOUT] #{attack}"
            flag = false
            return
         end
         status = res["status"]
         if status.instance_of?(Array) 
            status = status[0]
         end 
         puts attack + ":" + status
         if redirect?(status)
            print "-> "
            attack = res["location"]
         end
      end
   end
end

def redirect?(status)
  (300..399).include?(status.to_i)
end

def __main__(argv)
   arg_hash = Getopts.getopts("vhu:l:", 'version', 'help')
   # getoptsは文字列のキーを持つハッシュを返すのでシンボルにしておく
   arg_hash = symbolize_keys(arg_hash)

   if arg_hash.has_key?(:v) or arg_hash.has_key?(:version)
      puts "v#{Webminer::VERSION}"
   elsif arg_hash.has_key?(:h) or arg_hash.has_key?(:help)
      usage
   elsif arg_hash.has_key?(:u)
      webminer(arg_hash[:u])
   elsif arg_hash.has_key?(:l)
      File.open(arg_hash[:l]) do |f|
         while line = f.gets
            webminer(line.chomp)
         end
      end
   else
      usage
   end
end
