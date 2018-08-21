class TwitterPhotoScraper

    attr_accessor :profile_uri

    def initialize(profile_uri:)
        @profile_uri = profile_uri
    end

    def get_photo_source
        doc = Nokogiri::HTML(open(self.profile_uri))
        doc.css('div.ProfileCanopy div.ProfileCardMini a.profile-picture')[0]["href"]
    end

    def save_photo_to_file(filepath)
    end

end