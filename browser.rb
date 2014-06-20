#require 'fileutils'
require 'yaml'

class Browser

  def initialize

    @paths = YAML.load_file("paths.yml")


  end

  def proxystate(toggle)

    `sudo /usr/sbin/NewNetworkSetup -setwebproxystate Wi-Fi #{toggle}`
    `sudo /usr/sbin/NewNetworkSetup -setsecurewebproxystate Wi-Fi #{toggle}`
    `sudo /usr/sbin/NewNetworkSetup -setftpproxystate Wi-Fi #{toggle}`

    puts("Proxy is #{toggle}")

  end

  def start(name, version, url, proxy, port)

    puts("\n")
    puts("name #{name} version #{version} url #{url} proxy #{proxy} port #{port}")

    proxy_command = @paths["proxy"]

    if proxy != nil
      `sudo /usr/sbin/NewNetworkSetup -setwebproxy Wi-Fi #{proxy} #{port}`
      `sudo /usr/sbin/NewNetworkSetup -setsecurewebproxy Wi-Fi #{proxy} #{port}`
      `sudo /usr/sbin/NewNetworkSetup -setftpproxy Wi-Fi #{proxy} #{port}`
      
      proxystate("on")

    else
      proxystate("off")

    end

    if name == 'opera' && version >= '15'
      name = 'opera_new'
    end

    command = @paths['start'][name]
    puts("command is #{command}")

    open_command = @paths["open_command"]

    proc_pid = fork do

      if name == "safari"
        open_safari = @paths["open_safari"]
        url = "http://" + url unless url.start_with?("http://")
        puts("Safari url is --- #{url}")
        `#{open_safari} \"#{command}\" #{url}`

      else
        `#{open_command} \"#{command}\" --args #{url}`
      end
    end

    puts("Browser #{name} launched with pid #{proc_pid}")

  end


  def stop(name, version)

    process_name = @paths['stop'][name]

    puts("Killing with SIGTERM")
    `killall \"#{process_name}\"`

    sleep 1
    running = `ps -ef | grep \"#{process_name}\" | grep -v grep`
    puts("Processes still running --- \n#{running}")

    if running != ""
      puts("Killing with SIGKILL")
      `killall -9 \"#{process_name}\"`
    
    end

    puts("Process #{process_name} killed")

  end


  def clean(name, version)

    proxystate('off')

    if name == 'opera' && version >= '15'
      name = 'opera_new'
    end

    clean_paths = @paths['clean'][name]

    clean_paths.each do |clean_path|
      clean_this = File.expand_path(clean_path)
      puts("Running clean command for #{clean_this}")
      ret_val = `rm -rfv \"#{clean_this}\"/*`
      puts("#{ret_val}")
    end

    puts("Cleanup for #{name} completed")

  end


end