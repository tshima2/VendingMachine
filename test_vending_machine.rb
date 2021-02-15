require 'minitest/autorun'
require './vending_machine.rb'

class VendingMachineTest<Minitest::Test
  def test_vending_machine
    vm=VendingMachine.new

    # case1 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
    assert_equal true, vm.slot_money(10)
    assert_equal 10, vm.current_slot_money
    assert_equal true, vm.slot_money(50)
    assert_equal 60, vm.current_slot_money
    assert_equal true, vm.slot_money(100)
    assert_equal 160, vm.current_slot_money
    assert_equal true, vm.slot_money(500)
    assert_equal 660, vm.current_slot_money

    # case2 上記以外は扱えない
    assert_equal false, vm.slot_money(1)
    assert_equal 660, vm.current_slot_money
    assert_equal false, vm.slot_money(5)
    assert_equal 660, vm.current_slot_money
    assert_equal false, vm.slot_money(2000)
    assert_equal 660, vm.current_slot_money

    # case3 払い戻しをする
    assert_equal 660, vm.return_money
    assert_equal 0, vm.current_slot_money

    # case4 購入可能なドリンクのリストを表示する
    vm.slot_money(50)
    vm.slot_money(100)
    assert_equal 150, vm.current_slot_money
    assert_equal [:cola], vm.available_items

    # case5 購入する
    assert_equal false, vm.purchase(:redbull) 
    assert_equal true, vm.purchase(:cola)
    assert_equal 30, vm.current_slot_money

    # case6 （購入してから）払い戻す
    assert_equal true, vm.slot_money(100)
    assert_equal 130, vm.current_slot_money
    assert_equal false, vm.refund(:redbull)
    assert_equal 10, vm.refund(:cola)

  end
end
