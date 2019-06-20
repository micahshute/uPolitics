class Congress

    def self.number
        d = DateTime.now
        return (d.year - 1787) / 2
    end

end