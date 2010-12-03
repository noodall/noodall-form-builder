module Noodall
  class TextField < Noodall::Field
    key :rows, Integer, :default => 1
    
    before_validation :constrain_rows
    
    def constrain_rows
      rows = rows.to_i
      rows = 1 if rows < 1
    end
  end
end