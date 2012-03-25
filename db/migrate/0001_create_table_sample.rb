Sequel.migration do

  up do
    create_table(:sample) do
      primary_key :id, type:Integer   # integer
      String :a                       # varchar(255)
      String :a2, size:50             # varchar(50)
      String :a3, fixed:true          # char(255)
      String :a4, fixed:true, size:50 # char(50)
      String :a5, text:true           # text
      column :b, File                 # blob
      Fixnum :c                       # integer
      Float :e                        # double precision
      BigDecimal :f                   # numeric
      BigDecimal :f2, size:10         # numeric(10)
      BigDecimal :f3, size:[10, 2]    # numeric(10, 2)
      Date :g                         # date
      DateTime :h                     # timestamp
      Time :i                         # timestamp
      Time :i2, only_time:true        # time
      Numeric :j                      # numeric
      TrueClass :k                    # boolean
      FalseClass :l                   # boolean
    end
  end

  down do
    drop_table(:sample)
  end
end
