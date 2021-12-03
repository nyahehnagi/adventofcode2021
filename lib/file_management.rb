module FileManagement

    def getData(filename)
        data_array = []
        File.foreach(filename) {|line| data_array << line.chomp}
        return data_array
    end
end
