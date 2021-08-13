class Pokemon
    attr_accessor :name, :type
    attr_reader :id, :db
    @@id = nil
    @@name = ""
    @@type = ""
    def initialize(id:,name:,type:, db:)
        @name = name
        @type = type
        @id = id
        @db = db
        @@id = @id
        @@name = @name
        @@type = @type
    end

    def id
        @id
    end

    def self.id
        @@id
    end

    def name
        @name
    end

    def type
        @type
    end
 
    def self.update(db)
        sql = "UPDATE pokemon SET name = ?, type = ? WHERE id = ?"
        db.execute(sql, self.name, self.type, self.id)
    end
    
    def self.save(name,type,db)
        sql = <<-SQL
            INSERT INTO pokemon (name, type) 
            VALUES (?, ?)
        SQL
        db.execute(sql, name, type)
        @id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
    end

    def self.new_from_db(row,db)
        new_pokemon = self.new(id:row[0],name:row[1],type:row[2],db:db)
        new_pokemon
    end

    def self.find(id,db)
        sql = <<-SQL 
            SELECT * 
            FROM pokemon
            WHERE id = ?
            LIMIT 1
        SQL
        db.execute(sql, id).map do |row|
            self.new_from_db(row,db)
        end.first       
    end

end
#
