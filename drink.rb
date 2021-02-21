# 自販機商品（飲み物）クラス
class Drink
  # 商品種別定義
  module Kind
    NONE=0
    COLA=1
    REDBULL=2
    WATER=3
  end

  #以下は隠蔽
  ITEMS_MASTER={
    Kind::COLA => {name: "cola", price: 120},
    Kind::REDBULL => {name: "redbull", price: 200},
    Kind::WATER => {name: "water", price: 100}
  }
  private_constant :ITEMS_MASTER

  # インスタンス生成, 初期化
  # 使用例1
  # v = Drink.new(4, "miku", 200)
  # 使用例2, 価格表に登録済みの飲み物は種別指定のみでok
  # v = Drink.new(1)
  def initialize(kind, name='', price=0)
    if(kind.class!=Integer)
      raise DrinkInitializeError, "種別は正の整数値を指定してください. #{kind}.to_s"
    else
      @kind = kind
      if ITEMS_MASTER.keys.include?(kind)
        @name = ITEMS_MASTER[kind][:name]
        @price = ITEMS_MASTER[kind][:price]
      else
        @name = name
        @price = price
      end
    end
  end

  # 以下はインスタンスメソッド定義
  # 使用例
  # d = Drink.new(1); d.kind
  def kind
    @kind
  end
  
  def name
    @name
  end

  def price
    @price
  end

  # 以下はクラスメソッド定義
  # 使用例
  # price = Drink::price(1)
  def self.price (kind)
    if(kind.class!=Integer)
      puts '種別は正の整数値を指定してください'   #return nil
    elsif ITEMS_MASTER.has_key?(kind)
      ITEMS_MASTER[kind][:price]
    else
      puts "specified kind is not exists."  #return nil
    end
  end

  def self.name (kind)
    if(kind.class!=Integer)
      puts '種別は正の整数値を指定してください'   #return nil
    elsif ITEMS_MASTER.has_key?(kind)
      ITEMS_MASTER[kind][:name]
    else
      puts "specified kind is not exists."  #return nil
    end
  end

  def self.insert(kind, name, price)
    if(kind.class!=Integer)
      puts '種別は正の整数値を指定してください'   #return nil
    elsif ITEMS_MASTER.has_key?(kind)
      puts "specified kind is already exists."  #return nil
    else
      ITEMS_MASTER[kind]={name: name, price: price}
    end
  end

  def self.update(kind, name: name="Unspecified", price: price=-1)
    if(kind.class!=Integer)
      puts '種別は正の整数値を指定してください'   #return nil
    elsif ITEMS_MASTER.has_key?(kind)
      if (name!="Unspecified" && name.empty? )
        ITEMS_MASTER[kind][:name]=name
      elsif (price >= 0)
        ITEMS_MASTER[kind][:price]=price
      end
      ITEMS_MASTER[kind]
    else
      puts "specified kind is not exists."  #return nil
    end
  end

  def self.destroy(kind)
    if(kind.class!=Integer)
      puts '種別は正の整数値を指定してください'   #return nil
    else
      ITEMS_MASTER.delete(kind)  #return nil if kind is NOT exists
    end
  end

  def self.master
    ITEMS_MASTER.each do |kind, item|
      puts "種別:#{kind.to_s}, 名前:#{item[:name]}, 価格:#{item[:price]}\n"
    end
    # return ITEMS_MASTER
  end
end

# 例外クラス定義
class DrinkInitializeError < StandardError
end
