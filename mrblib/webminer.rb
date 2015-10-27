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
   payloads = get_payloads
   for payload in payloads do 
      attack = 'http://' + url + '/' + payload
      res = HttpRequest.new.get attack
      puts attack + ":" + res["status"]
   end
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


