module Phantomblaster
  class API
    def self.get_user
      Phantomblaster::Client.get('/user')
    end

    def self.get_script(id: nil, name: nil)
      url = id ? "/script/by-id/json/#{id}" : "/script/by-name/json/#{name}"
      Phantomblaster::Client.get(url, withoutText: false)
    end

    def self.get_scripts
      Phantomblaster::Client.get('/scripts')
    end

    def self.post_script(name, text)
      url = "/script/#{name}"
      body = { text: text }
      Phantomblaster::Client.post(url, body, insertOnly: false, source: :phantomblaster)
    end
  end
end
