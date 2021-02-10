require 'minitest/autorun'
require './vending_machine.rb'

class VendingMachineTest<Minitest::Test
  def test_vending_machine
    vm=VendingMachine.new

    assert_equal false, vm.slot_money(2000)
    assert_equal 0, vm.current_slot_money
  end
end
