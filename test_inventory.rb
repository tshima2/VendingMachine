require 'minitest/autorun'
require './inventory.rb'

class InventoryTest < Minitest::Test
  def test_inventory
    inventory = Inventory.new
    cola = Drink.new(Drink::Kind::COLA)

    #在庫の新規追加
    assert_equal 5, inventory.add(cola, 5)
    assert_equal 10, inventory.add(cola, 5)


    #例外処理（Drinkクラスにないものを追加）
    assert_equal 10.5, inventory.add(cola, 0.5) #少数でも通る
    assert_equal 5, inventory.add(cola, -5.5) #負の値でも通る
    assert_equal nil, inventory.add("sports", 100) #クラス判定

    #現在の在庫情報(rb:18,19で小数点が登場してしまったため、在庫数も小数点第一位まで表示)
    assert_equal "商品名:cola,価格:120,在庫数:5.0\n", inventory.to_s


    #在庫の払い出し（1:cola＠120円）
    assert_equal 4, inventory.pull(1, 4)
    assert_equal 480, inventory.current_sales
    assert_equal 1, inventory.pull(1, 1)
    assert_equal 600, inventory.current_sales
    assert_equal 0, inventory.pull(1, 1)
    assert_equal 600, inventory.current_sales

    #例外処理
    assert_equal nil, inventory.pull(0.1, 1)
    assert_equal 0, inventory.pull(-1, 1) #負の値でも通る
    assert_equal 1, inventory.add(cola, 1) #通常の在庫追加処理
    assert_equal -1, inventory.pull(1, -1) #負の値でも通る
    assert_equal 480, inventory.current_sales #売上減少してしまう

    #現在の在庫情報（在庫も増えてしまっている）
    assert_equal "商品名:cola,価格:120,在庫数:2.0\n", inventory.to_s


    #在庫の払い出し（１つ）
    assert_equal 1, inventory.pull_one(1)
    assert_equal 1, inventory.pull_one(1)
    assert_equal 0, inventory.pull_one(1) #在庫切れの商品（cola）
    assert_equal 0, inventory.pull_one(4) #種別に設定されていない商品
    assert_equal nil, inventory.pull_one(0.5) #if文不要？？
    assert_equal nil, inventory.pull_one("kajiyama") #if文不要？？

    #現在の在庫情報
    assert_equal "商品名:cola,価格:120,在庫数:0.0\n", inventory.to_s

    #売上集計
    assert_equal 720, inventory.current_sales
    assert_equal 720, inventory.reset_sales
    assert_equal 0, inventory.current_sales
  end

  def test_inventory_method
    inventory = Inventory.new
    cola = Drink.new(Drink::Kind::COLA)
    redbull = Drink.new(2)
    water = Drink.new(3)

    #在庫の追加
    assert_equal 5, inventory.add(cola, 5)
    assert_equal 8, inventory.add(redbull, 8)

    #在庫の連続追加
    assert_equal 10, inventory.add(water, 10)
    assert_equal 20, inventory.add(water, 10)

    #在庫確認(cola@120:5, redbull@200:8, water@100:20)
    assert_equal "商品名:cola,価格:120,在庫数:5\n商品名:redbull,価格:200,在庫数:8\n商品名:water,価格:100,在庫数:20\n", inventory.to_s

    #can_buy?
    assert_equal nil, inventory.can_buy?(0.1, 200)
    assert_equal 0, inventory.can_buy?(-1, 200) #rb:96のreturn 0
    assert_equal 0, inventory.can_buy?(1, 10) #rb:82のreturn 0

    #投入金額分以上の在庫がある[買える本数, おつり]
    assert_equal [4, 20], inventory.can_buy?(1, 500)
    assert_equal [3, 150], inventory.can_buy?(2, 750)
    assert_equal [10, 0], inventory.can_buy?(3, 1000)

    #投入金額分の在庫がない[在庫の本数, おつり]
    assert_equal [5, 9400], inventory.can_buy?(1, 10000)
    assert_equal [8, 8400], inventory.can_buy?(2, 10000)
    assert_equal [20, 8000], inventory.can_buy?(3, 10000)


    #available_items
    assert_equal [1, 2, 3], inventory.available_items(600)
    assert_equal [3], inventory.available_items(100)
    assert_equal [], inventory.available_items(99)
    assert_equal [], inventory.available_items(0)
    assert_equal [], inventory.available_items(0.5)
    assert_equal [], inventory.available_items(-200)
    assert_equal [1,3], inventory.available_items(150.05)

    #available_items（追加検証）
    assert_equal 5, inventory.pull(1, 5)
    assert_equal 600, inventory.current_sales
    assert_equal [2, 3], inventory.available_items(600)
    #assert_equal [], inventory.available_items("") #文字列は当然ダメ
  end
end
