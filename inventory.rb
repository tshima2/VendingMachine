require './drink.rb'

#在庫/売上管理クラス
class Inventory

  #初期化
  def initialize
    @hash_num={}    # {1:  50, 2:  50, 3:  50}  商品種別をキーとするハッシュ
    @sales=0
  end

  #在庫の追加
  def add(drink_obj, num)
    if( drink_obj.class != Drink)
      puts "Drink object is needed." #return nil
    elsif( @hash_num.has_key? (drink_obj.kind))
      @hash_num[drink_obj.kind] += num
    else
      @hash_num[drink_obj.kind] = num
    end
  end

  #在庫の払い出し
  def pull(kind, num)
    if( kind.class != Integer)
      puts "種別は正の整数値を指定してください." #return nil
    elsif( !@hash_num.has_key?(kind))
      puts "指定された種別の在庫がありません."
      return 0
    else
      a=[]
      pull_num=a.push(@hash_num[kind], num).min
      @hash_num[kind] -= pull_num
      @sales += ( pull_num * Drink::price(kind) )  #払い出した分の売り上げをカウント
      return pull_num
    end
  end

  #在庫の払い出し（１つ）
  def pull_one(kind)
    # if( kind.class != Integer)
    #   puts "種別は正の整数値を指定してください." #return nil
    # else
      pull(kind, 1)
    # end
  end

  #在庫情報を文字列で返す
  def to_s
    ret=""
    @hash_num.each do |kind, num|
      ret += "商品名:#{Drink::name(kind)},"
      ret += "価格:#{Drink::price(kind)},"
      ret += "在庫数:#{num}\n"
    end
    ret
  end

  #現在の売り上げ金額を返す
  def current_sales
    @sales
  end

  #売り上げの回収
  def reset_sales
    ret=@sales
    @sales=0
    ret
  end

=begin
  引数で与えられた金額で, 引数で与えられた名前の飲み物が購入できるかどうかを取得
　購入できる場合は購入可能本数とお釣りを配列で返却, 購入できない場合は 0を返却
(例1）投入金額800円, コーラの金額120円, 在庫数12本 => 戻り値 (6, 80)
(例2）投入金額800円, コーラの金額120円, 在庫数4本 => 戻り値 (4, 320)
=end
  def can_buy?(kind, input_money)
    if( kind.class != Integer)
      puts "種別は正の整数値を指定してください." #return nil
    #投入金額が足りなければ0を返却
    elsif Drink::price(kind) && input_money < Drink::price(kind)
      return 0
    elsif @hash_num.has_key?(kind)
      #投入金額を購入したい物の価格で割った商と余りを配列に格納
      ret = input_money.divmod(Drink::price(kind))
      if( @hash_num[kind] > ret[0] )
        #在庫が充分多い
        return ret
      else
        #在庫が少ない
        ret = []
        otsuri = ( input_money - Drink::price(kind)*@hash_num[kind] )
        return ret.push(@hash_num[kind], otsuri)
      end
    else
      return 0
    end
  end

  def available_items(input_money)
    ret_array=[]
    @hash_num.each do |kind, num|
      if ( Drink::price(kind) && (input_money >= Drink::price(kind)) && (num>0) )
        ret_array << kind
      end
    end
    ret_array
  end
end
